#include "lsp/json.h"

#include <cctype>
#include <cmath>
#include <cstdio>
#include <sstream>

namespace polaron::lsp {
namespace {

// ---- serialization ----

void dumpString(std::string& o, const std::string& s) {
    o += '"';
    for (char c : s) {
        switch (c) {
            case '"': o += "\\\""; break;
            case '\\': o += "\\\\"; break;
            case '\n': o += "\\n"; break;
            case '\r': o += "\\r"; break;
            case '\t': o += "\\t"; break;
            default:
                if (static_cast<unsigned char>(c) < 0x20) {
                    char buf[8];
                    std::snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned char>(c));
                    o += buf;
                } else {
                    o += c;
                }
        }
    }
    o += '"';
}

void dumpValue(std::string& o, const Json& j) {
    switch (j.type) {
        case Json::Type::Null: o += "null"; break;
        case Json::Type::Bool: o += j.boolean ? "true" : "false"; break;
        case Json::Type::Number: {
            if (j.number == std::floor(j.number) && std::abs(j.number) < 1e15) {
                o += std::to_string(static_cast<long long>(j.number));
            } else {
                std::ostringstream ss;
                ss << j.number;
                o += ss.str();
            }
            break;
        }
        case Json::Type::String: dumpString(o, j.str); break;
        case Json::Type::Array: {
            o += '[';
            for (std::size_t i = 0; i < j.arr.size(); ++i) {
                if (i != 0) {
                    o += ',';
                }
                dumpValue(o, j.arr[i]);
            }
            o += ']';
            break;
        }
        case Json::Type::Object: {
            o += '{';
            for (std::size_t i = 0; i < j.obj.size(); ++i) {
                if (i != 0) {
                    o += ',';
                }
                dumpString(o, j.obj[i].first);
                o += ':';
                dumpValue(o, j.obj[i].second);
            }
            o += '}';
            break;
        }
    }
}

// ---- parsing ----

struct Parser {
    const std::string& s;
    std::size_t i = 0;
    bool ok = true;

    void skipWs() {
        while (i < s.size() && (s[i] == ' ' || s[i] == '\t' || s[i] == '\n' || s[i] == '\r')) {
            ++i;
        }
    }

    bool parseValue(Json& out) {
        skipWs();
        if (i >= s.size()) {
            return fail();
        }
        const char c = s[i];
        if (c == '{') {
            return parseObject(out);
        }
        if (c == '[') {
            return parseArray(out);
        }
        if (c == '"') {
            return parseString(out);
        }
        if (c == 't' || c == 'f') {
            return parseBool(out);
        }
        if (c == 'n') {
            return parseNull(out);
        }
        return parseNumber(out);
    }

    bool fail() {
        ok = false;
        return false;
    }

    bool parseString(Json& out) {
        std::string result;
        if (!parseRawString(result)) {
            return false;
        }
        out = Json::of(std::move(result));
        return true;
    }

    bool parseRawString(std::string& result) {
        if (i >= s.size() || s[i] != '"') {
            return fail();
        }
        ++i;
        while (i < s.size()) {
            const char c = s[i++];
            if (c == '"') {
                return true;
            }
            if (c == '\\') {
                if (i >= s.size()) {
                    return fail();
                }
                const char e = s[i++];
                switch (e) {
                    case '"': result += '"'; break;
                    case '\\': result += '\\'; break;
                    case '/': result += '/'; break;
                    case 'n': result += '\n'; break;
                    case 't': result += '\t'; break;
                    case 'r': result += '\r'; break;
                    case 'b': result += '\b'; break;
                    case 'f': result += '\f'; break;
                    case 'u': {
                        if (i + 4 > s.size()) {
                            return fail();
                        }
                        const int cp = std::stoi(s.substr(i, 4), nullptr, 16);
                        i += 4;
                        appendUtf8(result, cp);
                        break;
                    }
                    default: return fail();
                }
            } else {
                result += c;
            }
        }
        return fail();
    }

    static void appendUtf8(std::string& out, int cp) {
        if (cp < 0x80) {
            out += static_cast<char>(cp);
        } else if (cp < 0x800) {
            out += static_cast<char>(0xC0 | (cp >> 6));
            out += static_cast<char>(0x80 | (cp & 0x3F));
        } else {
            out += static_cast<char>(0xE0 | (cp >> 12));
            out += static_cast<char>(0x80 | ((cp >> 6) & 0x3F));
            out += static_cast<char>(0x80 | (cp & 0x3F));
        }
    }

    bool parseNumber(Json& out) {
        const std::size_t start = i;
        while (i < s.size() && (std::isdigit(static_cast<unsigned char>(s[i])) || s[i] == '-' || s[i] == '+' ||
                                s[i] == '.' || s[i] == 'e' || s[i] == 'E')) {
            ++i;
        }
        if (i == start) {
            return fail();
        }
        try {
            out = Json::of(std::stod(s.substr(start, i - start)));
        } catch (...) {
            return fail();
        }
        return true;
    }

    bool parseBool(Json& out) {
        if (s.compare(i, 4, "true") == 0) {
            i += 4;
            out = Json::of(true);
            return true;
        }
        if (s.compare(i, 5, "false") == 0) {
            i += 5;
            out = Json::of(false);
            return true;
        }
        return fail();
    }

    bool parseNull(Json& out) {
        if (s.compare(i, 4, "null") == 0) {
            i += 4;
            out = Json{};
            return true;
        }
        return fail();
    }

    bool parseArray(Json& out) {
        out = Json::makeArray();
        ++i;  // '['
        skipWs();
        if (i < s.size() && s[i] == ']') {
            ++i;
            return true;
        }
        while (true) {
            Json v;
            if (!parseValue(v)) {
                return false;
            }
            out.push(std::move(v));
            skipWs();
            if (i >= s.size()) {
                return fail();
            }
            if (s[i] == ',') {
                ++i;
                continue;
            }
            if (s[i] == ']') {
                ++i;
                return true;
            }
            return fail();
        }
    }

    bool parseObject(Json& out) {
        out = Json::makeObject();
        ++i;  // '{'
        skipWs();
        if (i < s.size() && s[i] == '}') {
            ++i;
            return true;
        }
        while (true) {
            skipWs();
            std::string key;
            if (!parseRawString(key)) {
                return false;
            }
            skipWs();
            if (i >= s.size() || s[i] != ':') {
                return fail();
            }
            ++i;
            Json v;
            if (!parseValue(v)) {
                return false;
            }
            out.set(key, std::move(v));
            skipWs();
            if (i >= s.size()) {
                return fail();
            }
            if (s[i] == ',') {
                ++i;
                continue;
            }
            if (s[i] == '}') {
                ++i;
                return true;
            }
            return fail();
        }
    }
};

}  // namespace

const Json* Json::get(const std::string& key) const {
    if (type != Type::Object) {
        return nullptr;
    }
    for (const auto& [k, v] : obj) {
        if (k == key) {
            return &v;
        }
    }
    return nullptr;
}

std::string Json::getString(const std::string& key, const std::string& def) const {
    const Json* v = get(key);
    return v ? v->asString(def) : def;
}

int Json::getInt(const std::string& key, int def) const {
    const Json* v = get(key);
    return v ? v->asInt(def) : def;
}

std::string Json::dump() const {
    std::string o;
    dumpValue(o, *this);
    return o;
}

bool Json::parse(const std::string& text, Json& out) {
    Parser p{text};
    if (!p.parseValue(out)) {
        return false;
    }
    return p.ok;
}

}  // namespace polaron::lsp
