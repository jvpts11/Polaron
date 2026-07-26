#include "doc/htmldoc.h"
#include <algorithm>
#include <sstream>

namespace ldp3::doc {
namespace {

std::string esc(const std::string& s) {
    std::string o;
    for (char c : s) {
        switch (c) {
            case '&': o += "&amp;"; break;
            case '<': o += "&lt;"; break;
            case '>': o += "&gt;"; break;
            case '"': o += "&quot;"; break;
            default: o += c;
        }
    }
    return o;
}

// A readable rendering of a type: name<args>[]*&?.
std::string renderType(const ast::TypeRef& t) {
    std::string s = t.name;
    if (!t.typeArgs.empty()) {
        s += "<";
        for (std::size_t i = 0; i < t.typeArgs.size(); ++i) {
            if (i) s += ", ";
            s += t.typeArgs[i];
        }
        s += ">";
    }
    if (t.arrayElemPointer) s += "*";
    for (int i = 0; i < t.arrayDims; ++i) s += "[]";
    if (t.isPointer) s += "*";
    if (t.doublePointer) s += "*";
    if (t.isRef) s += "&";
    if (t.isNullable) s += "?";
    return s;
}

// A contiguous run of `///` lines forms one documentation block.
struct Block {
    int start;
    int end;
    std::string text;
};

std::vector<Block> buildBlocks(const std::vector<DocComment>& docs) {
    std::vector<Block> blocks;
    for (const DocComment& d : docs) {
        if (!blocks.empty() && d.line == blocks.back().end + 1) {
            blocks.back().end = d.line;
            blocks.back().text += "\n" + d.text;
        } else {
            blocks.push_back({d.line, d.line, d.text});
        }
    }
    return blocks;
}

// The line at which a declaration (with its annotations) begins.
int topLine(const SourceLocation& loc, const std::vector<ast::AnnotationUse>& anns) {
    int top = loc.line;
    for (const ast::AnnotationUse& a : anns) top = std::min(top, a.loc.line);
    return top;
}

// The doc block immediately above `top` (allowing one blank line), or "".
std::string docFor(const std::vector<Block>& blocks, int top) {
    const Block* best = nullptr;
    for (const Block& b : blocks) {
        if (b.end < top && top - b.end <= 2 && (best == nullptr || b.end > best->end)) best = &b;
    }
    return best ? best->text : std::string();
}

void emitDoc(std::ostringstream& o, const std::string& doc, const char* cls) {
    if (doc.empty()) return;
    o << "<div class=" << cls << ">";
    // Preserve line breaks between doc lines.
    std::size_t start = 0;
    for (std::size_t i = 0; i <= doc.size(); ++i) {
        if (i == doc.size() || doc[i] == '\n') {
            o << esc(doc.substr(start, i - start));
            if (i < doc.size()) o << "<br>";
            start = i + 1;
        }
    }
    o << "</div>";
}

}  // namespace

std::string generateHtml(const ast::Program& program, const std::vector<DocComment>& docs) {
    const std::vector<Block> blocks = buildBlocks(docs);
    std::ostringstream o;
    o << "<!doctype html><html lang=en><head><meta charset=utf-8><title>" << esc(program.name)
      << " \xE2\x80\x94 API</title><style>"
         "body{font-family:system-ui,-apple-system,sans-serif;max-width:60rem;margin:2rem auto;"
         "padding:0 1rem;line-height:1.5;color:#222}"
         "h1{border-bottom:2px solid #ddd;padding-bottom:.3rem}"
         ".cls{margin:1.5rem 0;padding:1rem 1.25rem;border:1px solid #eee;border-radius:10px}"
         ".mem{margin:.6rem 0;padding-left:1rem;border-left:3px solid #eef}"
         "code{background:#f6f8fa;padding:.12rem .35rem;border-radius:4px;font-size:.95em}"
         ".doc{color:#444;margin:.3rem 0}.muted{color:#999;font-weight:normal}"
         "</style></head><body>";
    o << "<h1>" << esc(program.name) << " <span class=muted>API documentation</span></h1>";

    bool any = false;
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isPrelude || bundle.isImported) continue;
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                if (cls.visibility != "public") continue;
                any = true;
                const char* kind = cls.isInterface ? "interface"
                                   : cls.isRecord  ? "record"
                                   : cls.isStruct  ? "struct"
                                                   : "class";
                o << "<div class=cls><h2><code>" << kind << " " << esc(cls.name) << "</code></h2>";
                emitDoc(o, docFor(blocks, topLine(cls.loc, cls.annotations)), "doc");

                for (const ast::MemberPtr& mp : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get())) {
                        if (m->visibility != "public") continue;
                        std::string sig = m->isStatic ? "static method " : "method ";
                        sig += m->name + "(";
                        for (std::size_t i = 0; i < m->params.size(); ++i) {
                            if (i) sig += ", ";
                            sig += renderType(m->params[i].type) + " " + m->params[i].name;
                        }
                        sig += ") returns " + renderType(m->returnType);
                        o << "<div class=mem><code>" << esc(sig) << "</code>";
                        emitDoc(o, docFor(blocks, topLine(m->loc, m->annotations)), "doc");
                        o << "</div>";
                    } else if (const auto* f = dynamic_cast<const ast::FieldDecl*>(mp.get())) {
                        if (f->visibility != "public") continue;
                        o << "<div class=mem><code>" << esc(renderType(f->type) + " " + f->name)
                          << "</code>";
                        emitDoc(o, docFor(blocks, topLine(f->loc, f->annotations)), "doc");
                        o << "</div>";
                    }
                }
                o << "</div>";
            }
        }
    }
    if (!any) o << "<p class=muted>No public types to document.</p>";
    o << "</body></html>";
    return o.str();
}

}  // namespace ldp3::doc
