#pragma once
#include <string>
#include <string_view>

namespace polaron::fmt {

// Re-format Polaron source: canonical indentation (four spaces per brace/paren/bracket level) and token
// spacing, while preserving the user's line breaks and every comment. Deterministic and idempotent, and
// only ever adjusts whitespace between tokens -- it never merges or splits tokens, so the result re-lexes
// to exactly the same token sequence (formatting never changes meaning). Returns the formatted text; on a
// lex error it returns the input unchanged (via *ok = false).
std::string format(std::string_view source, std::string_view file, bool* ok = nullptr);

}  // namespace polaron::fmt
