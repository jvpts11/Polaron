#!/usr/bin/env python3
"""Expand inline { ... } blocks in Polaron source to multi-line, surgically.

Only blocks whose matching '}' is on the SAME source line as the '{' are expanded; already
multi-line blocks and everything else are left untouched. String/char literals ($"..." too),
line comments and block comments are treated as opaque so their braces/semicolons are never
touched. The transform ONLY inserts newlines + indentation -- it never alters any token -- and
a canonical-form check (below) proves that per file.
"""
import sys, os

def classify_scan(s):
    """Yield (idx, state) intent is internal; we provide helpers instead."""
    pass

# --- a small state machine over a single string, exposing brace/semicolon positions that are
# --- 'real' code (not inside string/char/comment). It also reports where comments/strings run so
# --- callers can copy them verbatim.

def real_positions(s):
    """Return a list `kind` of length len(s) where kind[i] is:
       'c' = code, 's' = inside string/char literal, '/' = inside a comment.
       Handles "..", '..', $"..", // line comments, /* */ block comments, with \\ escapes.
       (Line comments only run to end of `s`; block comments may too.)"""
    n = len(s)
    kind = ['c'] * n
    i = 0
    while i < n:
        ch = s[i]
        two = s[i:i+2]
        if two == '//':
            while i < n:
                kind[i] = '/'
                i += 1
            break
        if two == '/*':
            while i < n:
                kind[i] = '/'
                if s[i-1:i+1] == '*/' and i > 0:
                    i += 1
                    break
                i += 1
            continue
        if ch == '"' or (ch == '$' and s[i+1:i+2] == '"'):
            # string literal (interp $"" treated as opaque too)
            if ch == '$':
                kind[i] = 's'; i += 1
            # now at opening quote
            kind[i] = 's'; i += 1
            while i < n:
                kind[i] = 's'
                if s[i] == '\\' and i + 1 < n:
                    kind[i+1] = 's'; i += 2; continue
                if s[i] == '"':
                    i += 1; break
                i += 1
            continue
        if ch == "'":
            kind[i] = 's'; i += 1
            while i < n:
                kind[i] = 's'
                if s[i] == '\\' and i + 1 < n:
                    kind[i+1] = 's'; i += 2; continue
                if s[i] == "'":
                    i += 1; break
                i += 1
            continue
        i += 1
    return kind

def find_match(s, kind, open_idx):
    """Index of the '}' matching the '{' at open_idx (both code), or -1."""
    depth = 0
    for i in range(open_idx, len(s)):
        if kind[i] != 'c':
            continue
        if s[i] == '{':
            depth += 1
        elif s[i] == '}':
            depth -= 1
            if depth == 0:
                return i
    return -1

def split_statements(inner):
    """Split inner block text into pieces at top-level (depth-0) ';', keeping the ';'. Nested
       braces and literals/comments are respected."""
    kind = real_positions(inner)
    pieces = []
    depth = 0
    start = 0
    for i in range(len(inner)):
        if kind[i] != 'c':
            continue
        c = inner[i]
        if c == '{':
            depth += 1
        elif c == '}':
            depth -= 1
        elif c == ';' and depth == 0:
            pieces.append(inner[start:i+1])
            start = i + 1
    tail = inner[start:]
    if tail.strip():
        pieces.append(tail)
    return pieces

def leading_ws(line):
    return line[:len(line) - len(line.lstrip(' '))]

def process_line(line, in_block_comment):
    """Return (list_of_output_lines, in_block_comment_after). Expands the first inline block on
       the line and re-processes the remainder; recurses into statements."""
    # carry block-comment state: if we're inside a /* */ that started earlier, find its end.
    if in_block_comment:
        end = line.find('*/')
        if end < 0:
            return [line], True
        # rest after the comment close may contain code
        head = line[:end+2]
        rest = line[end+2:]
        outs, bc = process_line(rest, False)
        if not outs:
            return [head], bc
        # attach head to the first output line
        outs[0] = head + outs[0]
        return outs, bc

    kind = real_positions(line)
    # does a block comment open and stay open past end of line?
    # (real_positions marks it '/'; detect an unterminated /* )
    bc_after = False
    # detect unterminated block comment
    j = line.rfind('/*')
    if j >= 0 and kind[j] == '/' and '*/' not in line[j:]:
        bc_after = True

    # find the first code '{'
    n = len(line)
    open_idx = -1
    for i in range(n):
        if kind[i] == 'c' and line[i] == '{':
            open_idx = i
            break
    if open_idx < 0:
        return [line], bc_after
    close_idx = find_match(line, kind, open_idx)
    if close_idx < 0:
        # multi-line block opens here; leave the line as is
        return [line], bc_after
    # inline block found
    ind = leading_ws(line)
    pre = line[:open_idx].rstrip()          # e.g. "            if (x)"
    inner = line[open_idx+1:close_idx]
    post = line[close_idx+1:]               # e.g. " else { ... }" or "" or " // note"
    stmts = split_statements(inner)
    if len(stmts) == 0:
        # empty block (e.g. `method m() {}`): nothing to expand -- leave the line exactly as is
        return [line], bc_after
    out = []
    out.append((pre + ' {') if pre else (ind + '{'))
    for st in stmts:
        st = st.strip()
        if not st:
            continue
        # recurse into the statement for nested inline blocks
        sub, _ = process_line(ind + '    ' + st, False)
        out.extend(sub)
    post_s = post.strip()
    if post_s == '':
        return out + [ind + '}'], bc_after
    if is_continuation(post_s):
        # `} else { ... }`, `} catch (...) { ... }`, `} while (c);` stay glued to the close brace
        sub, bc = process_line(ind + '} ' + post_s, False)
        out.extend(sub)
        return out, bc
    # any other trailing statement goes to its own line
    out.append(ind + '}')
    sub, bc = process_line(ind + post_s, False)
    out.extend(sub)
    return out, bc

def is_continuation(post_s):
    for kw in ('else', 'catch', 'finally', 'while'):
        if post_s == kw or post_s.startswith(kw + ' ') or post_s.startswith(kw + '(') \
           or post_s.startswith(kw + '\t'):
            return True
    return False

def canonical(text):
    """Non-whitespace code chars + verbatim string/char/comment runs, per line-independent scan of
       the whole file. Whitespace outside literals/comments is collapsed away."""
    kind = real_positions_multiline(text)
    out = []
    for i, ch in enumerate(text):
        k = kind[i]
        if k == 'c':
            if not ch.isspace():
                out.append(ch)
        else:
            out.append(ch)  # keep literal/comment verbatim (incl. their whitespace)
    return ''.join(out)

def real_positions_multiline(s):
    """Like real_positions but // runs only to end of line, /* */ spans lines."""
    n = len(s)
    kind = ['c'] * n
    i = 0
    while i < n:
        ch = s[i]
        two = s[i:i+2]
        if two == '//':
            while i < n and s[i] != '\n':
                kind[i] = '/'; i += 1
            continue
        if two == '/*':
            kind[i] = '/'; kind[i+1] = '/'; i += 2
            while i < n:
                kind[i] = '/'
                if s[i-1:i+1] == '*/':
                    i += 1; break
                i += 1
            continue
        if ch == '"' or (ch == '$' and s[i+1:i+2] == '"'):
            if ch == '$':
                kind[i] = 's'; i += 1
            kind[i] = 's'; i += 1
            while i < n:
                kind[i] = 's'
                if s[i] == '\\' and i+1 < n:
                    kind[i+1] = 's'; i += 2; continue
                if s[i] == '"':
                    i += 1; break
                i += 1
            continue
        if ch == "'":
            kind[i] = 's'; i += 1
            while i < n:
                kind[i] = 's'
                if s[i] == '\\' and i+1 < n:
                    kind[i+1] = 's'; i += 2; continue
                if s[i] == "'":
                    i += 1; break
                i += 1
            continue
        i += 1
    return kind

def expand_text(text):
    lines = text.split('\n')
    out_lines = []
    bc = False
    for line in lines:
        outs, bc = process_line(line, bc)
        out_lines.extend(outs)
    return '\n'.join(out_lines)

def main():
    files = sys.argv[1:]
    changed = 0
    for path in files:
        with open(path, 'r', encoding='utf-8', newline='') as f:
            orig = f.read()
        # normalize CRLF to LF for processing, remember
        crlf = '\r\n' in orig
        text = orig.replace('\r\n', '\n')
        new = expand_text(text)
        # SAFETY: canonical forms must match (transform only inserts whitespace)
        if canonical(text) != canonical(new):
            print(f"UNSAFE (canonical mismatch), skipping: {path}")
            continue
        if new != text:
            if crlf:
                new = new.replace('\n', '\r\n')
            with open(path, 'w', encoding='utf-8', newline='') as f:
                f.write(new)
            changed += 1
            print(f"expanded: {path}")
    print(f"done: {changed} files changed")

if __name__ == '__main__':
    main()
