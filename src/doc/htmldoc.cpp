#include "doc/htmldoc.h"
#include <algorithm>
#include <sstream>

namespace polaron::doc {
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
            if (i) {
                s += ", ";
            }
            s += t.typeArgs[i];
        }
        s += ">";
    }
    if (t.arrayElemPointer) {
        s += "*";
    }
    for (int i = 0; i < t.arrayDims; ++i) {
        s += "[]";
    }
    for (int i = 0; i < t.pointerDepth; ++i) {
        s += "*";
    }
    if (t.isRef) {
        s += "&";
    }
    if (t.isNullable) {
        s += "?";
    }
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
    for (const ast::AnnotationUse& a : anns) {
        top = std::min(top, a.loc.line);
    }
    return top;
}

// The doc block immediately above `top` (allowing one blank line), or "".
std::string docFor(const std::vector<Block>& blocks, int top) {
    const Block* best = nullptr;
    for (const Block& b : blocks) {
        if (b.end < top && top - b.end <= 2 && (best == nullptr || b.end > best->end)) {
            best = &b;
        }
    }
    return best ? best->text : std::string();
}

void emitDoc(std::ostringstream& o, const std::string& doc, const char* cls) {
    if (doc.empty()) {
        return;
    }
    o << "<div class=" << cls << ">";
    // Preserve line breaks between doc lines.
    std::size_t start = 0;
    for (std::size_t i = 0; i <= doc.size(); ++i) {
        if (i == doc.size() || doc[i] == '\n') {
            o << esc(doc.substr(start, i - start));
            if (i < doc.size()) {
                o << "<br>";
            }
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
        if (bundle.isPrelude || bundle.isImported) {
            continue;
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                if (cls.visibility != "public") {
                    continue;
                }
                any = true;
                const char* kind = cls.isInterface ? "interface"
                                   : cls.isRecord  ? "record"
                                   : cls.isStruct  ? "struct"
                                                   : "class";
                std::string clsHead = std::string(kind) + " " + cls.name;
                for (std::size_t i = 0; i < cls.applies.size(); ++i) {
                    clsHead += (i == 0 ? " applies " : ", ") + cls.applies[i];
                }
                o << "<div class=cls><h2><code>" << esc(clsHead) << "</code></h2>";
                emitDoc(o, docFor(blocks, topLine(cls.loc, cls.annotations)), "doc");

                for (const ast::MemberPtr& mp : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get())) {
                        if (m->visibility != "public") {
                            continue;
                        }
                        // `into$Fahrenheit` is how a per-target procedure is spelled once it has
                        // been bound, and it is not how anybody writes or calls it. Rendered back
                        // to `into<Fahrenheit>`, which is what the call site says.
                        const std::size_t bound = m->name.find('$');
                        const bool perTarget = m->isEachFamily && bound != std::string::npos;
                        std::string sig = m->isStatic ? "static " : "";
                        sig += perTarget ? "procedure " : "method ";
                        sig += perTarget ? m->name.substr(0, bound) + "<" + m->name.substr(bound + 1) + ">"
                                         : m->name;
                        sig += "(";
                        for (std::size_t i = 0; i < m->params.size(); ++i) {
                            if (i) {
                                sig += ", ";
                            }
                            sig += renderType(m->params[i].type) + " " + m->params[i].name;
                        }
                        sig += ") returns " + renderType(m->returnType);
                        o << "<div class=mem><code>" << esc(sig) << "</code>";
                        // A COMPOSED CONVERSION IS SAID OUT LOUD, with the route it takes. It is the
                        // one member here that nobody wrote, so it is the one a reader cannot find by
                        // opening the file -- and a derived conversion that cannot be seen is one
                        // that cannot be audited. Naming the intermediates also answers the question
                        // that follows immediately: where the rounding went.
                        if (!m->composedVia.empty()) {
                            std::string via;
                            for (std::size_t i = 0; i < m->composedVia.size(); ++i) {
                                via += (i ? " -> " : "") + m->composedVia[i];
                            }
                            o << "<p class=doc>Composed by the collective relation, through " << esc(via)
                              << ". Nobody wrote this body; it chains the conversions that were "
                                 "written.</p>";
                        }
                        emitDoc(o, docFor(blocks, topLine(m->loc, m->annotations)), "doc");
                        o << "</div>";
                    } else if (const auto* f = dynamic_cast<const ast::FieldDecl*>(mp.get())) {
                        if (f->visibility != "public") {
                            continue;
                        }
                        o << "<div class=mem><code>" << esc(renderType(f->type) + " " + f->name)
                          << "</code>";
                        emitDoc(o, docFor(blocks, topLine(f->loc, f->annotations)), "doc");
                        o << "</div>";
                    }
                }
                o << "</div>";
            }
            // TRANSFORMERS. Left out until now because they live in their own list rather than in
            // `classes`, and a walk that only knew about classes therefore documented a program's
            // equipment as though it did not exist -- including, once it could cross a bundle, the
            // ones a library publishes for other people to apply.
            //
            // What is worth showing is not only its procedures but its RELATION: `mutual` and
            // `collective` are promises made to whoever applies it, and `collective` in particular
            // means conversions get composed. A derived conversion nobody can see is a conversion
            // nobody can audit, so the composed ones are listed on the applying type below.
            for (const ast::ClassDecl& t : ns.transformers) {
                if (t.visibility != "public") {
                    continue;
                }
                any = true;
                std::string head;
                if (t.isMutualTransformer) {
                    head += "mutual ";
                }
                if (t.isCollectiveTransformer) {
                    head += "collective ";
                }
                if (t.isExplicitTransformer) {
                    head += "explicit ";
                }
                if (t.isFreestandingTransformer) {
                    head += "freestanding ";
                }
                head += "transformer " + t.name;
                for (std::size_t i = 0; i < t.satisfies.size(); ++i) {
                    head += (i == 0 ? " satisfies " : ", ") + t.satisfies[i];
                }
                for (std::size_t i = 0; i < t.applies.size(); ++i) {
                    head += (i == 0 ? " applies " : ", ") + t.applies[i];
                }
                o << "<div class=cls><h2><code>" << esc(head) << "</code></h2>";
                emitDoc(o, docFor(blocks, topLine(t.loc, t.annotations)), "doc");
                if (t.isCollectiveTransformer) {
                    o << "<p class=doc>Every type that applies this transformer can become every "
                         "other one. The conversions not written by hand are composed along the "
                         "ones that are.</p>";
                }
                for (const ast::MemberPtr& mp : t.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get());
                    if (m == nullptr || (!m->visibility.empty() && m->visibility != "public" &&
                                         m->visibility != "protected")) {
                        continue;
                    }
                    std::string sig = m->isStatic ? "static procedure " : "procedure ";
                    sig += m->name;
                    if (m->isEachFamily && !m->typeParams.empty()) {
                        sig += "<each " + m->typeParams.front() + ">";
                    }
                    sig += "(";
                    for (std::size_t i = 0; i < m->params.size(); ++i) {
                        if (i) {
                            sig += ", ";
                        }
                        sig += renderType(m->params[i].type) + " " + m->params[i].name;
                    }
                    sig += ") returns " + renderType(m->returnType);
                    // A socket is the half a reader most needs to spot: it is what they must write.
                    sig += m->isAbstract ? "   [socket: the applying type supplies this]" : "";
                    o << "<div class=mem><code>" << esc(sig) << "</code>";
                    emitDoc(o, docFor(blocks, topLine(m->loc, m->annotations)), "doc");
                    o << "</div>";
                }
                o << "</div>";
            }
        }
    }
    if (!any) {
        o << "<p class=muted>No public types to document.</p>";
    }
    o << "</body></html>";
    return o.str();
}

}  // namespace polaron::doc
