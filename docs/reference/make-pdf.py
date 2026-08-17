#!/usr/bin/env python3
# Assemble the Polaron language reference (docs/reference/*.md) into one styled HTML document, ready to
# print to PDF with a headless browser. Regenerate the PDF with:
#   python docs/reference/make-pdf.py
#   msedge --headless --print-to-pdf=docs/reference/Polaron-Language-Reference-1.0.129.pdf \
#          --no-pdf-header-footer docs/reference/_reference.html
import datetime
import html as _html
import os
import re

import markdown

HERE = os.path.dirname(os.path.abspath(__file__))
VERSION = "1.0.129"

# Order the documents for the PDF: the eleven language chapters (each already carries its own
# "# N. Title" heading), then the six standard-library slices. Titles here drive the table of
# contents; each document's own heading is preserved in the body.
DOCS = [
    ("Introduction & Philosophy", "guide/01-introduction.md"),
    ("Program Structure & Modules", "guide/02-program-structure.md"),
    ("Expressions, Statements & Method Calls", "guide/03-expressions-statements.md"),
    ("Values & the Type System", "guide/04-type-system.md"),
    ("Memory & Ownership", "guide/05-memory-and-ownership.md"),
    ("Object-Oriented Programming", "guide/06-oop.md"),
    ("Control Flow", "guide/07-control-flow.md"),
    ("Errors, Results & Contracts", "guide/08-errors-and-contracts.md"),
    ("Concurrency", "guide/09-concurrency.md"),
    ("Compile-Time, Reflection & Prefixes", "guide/10-metaprogramming-and-prefixes.md"),
    ("Systems Programming", "guide/11-systems-programming.md"),
    ("Keyword Reference", "guide/12-keyword-reference.md"),
    ("Diagnostics", "guide/13-diagnostics.md"),
    ("Functions, Lambdas & Tuples", "guide/14-functions-and-lambdas.md"),
    ("The Toolchain & Projects", "guide/15-toolchain.md"),
    ("Testing", "guide/16-testing.md"),
    ("Standard Library — Concurrency & Core", "stdlib/concurrency-and-core.md"),
    ("Standard Library — Collections", "stdlib/collections.md"),
    ("Standard Library — Data Structures & ECS", "stdlib/data-structures.md"),
    ("Standard Library — Text, Encoding & Crypto", "stdlib/text-encoding-crypto.md"),
    ("Standard Library — Parsing, Time & JSON", "stdlib/parsing-time-json.md"),
    ("Standard Library — Math, Net & Misc", "stdlib/math-net-misc.md"),
]

CSS = r"""
@page { size: A4; margin: 20mm 18mm 18mm 18mm; }
:root {
  --amber: #c8781f; --amber-soft: #eab464; --ink: #1c1a17; --muted: #6b645c;
  --rule: #e4ddd2; --code-bg: #f6f2ea; --code-ink: #3a352e; --row: #faf7f1;
}
* { box-sizing: border-box; }
body {
  font-family: "Segoe UI", "Helvetica Neue", Arial, sans-serif;
  color: var(--ink); font-size: 10.5pt; line-height: 1.55; margin: 0;
  -webkit-print-color-adjust: exact; print-color-adjust: exact;
}
.doc { page-break-before: always; }
h1, h2, h3, h4 { font-weight: 650; line-height: 1.25; text-wrap: balance; }
h1 { font-size: 22pt; color: var(--amber); border-bottom: 3px solid var(--amber-soft);
     padding-bottom: .25em; margin: 0 0 .6em; }
h2 { font-size: 15pt; margin: 1.4em 0 .4em; padding-top: .2em; border-top: 1px solid var(--rule);
     page-break-after: avoid; }
h3 { font-size: 12pt; color: var(--amber); margin: 1.1em 0 .3em; page-break-after: avoid; }
h4 { font-size: 10.5pt; color: var(--muted); margin: .9em 0 .3em; }
p { margin: .5em 0; }
a { color: var(--amber); text-decoration: none; }
code, pre, .sig { font-family: "Cascadia Code", "Consolas", "Liberation Mono", monospace; }
code { background: var(--code-bg); color: var(--code-ink); padding: .08em .32em;
       border-radius: 3px; font-size: 9pt; }
pre { background: var(--code-bg); border: 1px solid var(--rule); border-left: 3px solid var(--amber-soft);
      border-radius: 5px; padding: .7em .9em; overflow-x: auto; font-size: 8.8pt; line-height: 1.45;
      page-break-inside: avoid; }
pre code { background: none; padding: 0; font-size: inherit; }
table { border-collapse: collapse; width: 100%; margin: .6em 0; font-size: 9pt; }
th, td { border: 1px solid var(--rule); padding: .3em .5em; text-align: left; vertical-align: top; }
th { background: var(--amber-soft); color: #2a2115; font-weight: 650; }
tr:nth-child(even) td { background: var(--row); }
td code, td:first-child { font-family: "Cascadia Code", "Consolas", monospace; font-size: 8.6pt; }
blockquote { border-left: 3px solid var(--amber-soft); margin: .6em 0; padding: .1em .9em; color: var(--muted); }
hr { border: none; border-top: 1px solid var(--rule); margin: 1.2em 0; }
ul, ol { margin: .4em 0; padding-left: 1.5em; }
li { margin: .15em 0; }
/* Title page */
.cover { page-break-after: always; height: 247mm; display: flex; flex-direction: column;
         justify-content: center; align-items: center; text-align: center; }
.cover .mark { font-size: 64pt; font-weight: 800; letter-spacing: -2px; color: var(--amber);
               line-height: 1; }
.cover .sub { font-size: 20pt; color: var(--ink); margin-top: .3em; }
.cover .ver { font-size: 14pt; color: var(--muted); margin-top: 1.4em; letter-spacing: 2px; }
.cover .by { font-size: 11pt; color: var(--muted); margin-top: .6em; }
.cover .flame { font-size: 40pt; margin-bottom: .2em; }
/* Contents */
.toc { page-break-after: always; }
.toc h1 { border: none; }
.toc ol { list-style: none; padding-left: 0; font-size: 12pt; }
.toc li { margin: .5em 0; border-bottom: 1px dotted var(--rule); padding-bottom: .3em; }
.toc .num { color: var(--amber); font-weight: 700; display: inline-block; width: 2.2em; }
"""


def slug(title):
    return re.sub(r"[^a-z0-9]+", "-", title.lower()).strip("-")


def render():
    md = markdown.Markdown(extensions=["tables", "fenced_code", "toc", "sane_lists", "attr_list"])
    today = datetime.date.today().strftime("%B %Y")
    parts = [
        "<!doctype html><html><head><meta charset='utf-8'>",
        "<title>Polaron Language Reference " + VERSION + "</title>",
        "<style>" + CSS + "</style></head><body>",
        # Cover
        "<section class='cover'>",
        "<div class='flame'>&#128293;</div>",
        "<div class='mark'>Polaron</div>",
        "<div class='sub'>Language Reference</div>",
        "<div class='ver'>VERSION " + VERSION + "</div>",
        "<div class='by'>Linguagem De Programa&ccedil;&atilde;o 3 &mdash; Jo&atilde;o Victor Pereira Tavares</div>",
        "<div class='by'>" + today + "</div>",
        "</section>",
        # Contents
        "<section class='toc'><h1>Contents</h1><ol>",
    ]
    for i, (title, _path) in enumerate(DOCS, 1):
        parts.append(
            "<li><span class='num'>%d</span><a href='#%s'>%s</a></li>" % (i, slug(title), _html.escape(title))
        )
    parts.append("</ol></section>")

    for i, (title, path) in enumerate(DOCS, 1):
        full = os.path.join(HERE, path)
        with open(full, encoding="utf-8") as fh:
            text = fh.read()
        # Each chapter already carries its own "# N. Title" heading; keep it as the section's H1.
        md.reset()
        body = md.convert(text)
        parts.append("<section class='doc' id='%s'>" % slug(title))
        parts.append(body)
        parts.append("</section>")

    parts.append("</body></html>")
    out = os.path.join(HERE, "_reference.html")
    with open(out, "w", encoding="utf-8") as fh:
        fh.write("\n".join(parts))
    print("wrote", out)


if __name__ == "__main__":
    render()
