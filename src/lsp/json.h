#pragma once
#include <cstdint>
#include <string>
#include <utility>
#include <vector>

// A small, dependency-free JSON value used by the Polaron language server for LSP (JSON-RPC) messages. Objects
// keep insertion order; numbers are stored as doubles (LSP integers fit exactly).
namespace polaron::lsp {

struct Json {
    enum class Type : std::uint8_t { Null, Bool, Number, String, Array, Object };

    Type type = Type::Null;
    bool boolean = false;
    double number = 0;
    std::string str;
    std::vector<Json> arr;
    std::vector<std::pair<std::string, Json>> obj;

    Json() = default;
    static Json makeObject() {
        Json j;
        j.type = Type::Object;
        return j;
    }
    static Json makeArray() {
        Json j;
        j.type = Type::Array;
        return j;
    }
    static Json of(std::string s) {
        Json j;
        j.type = Type::String;
        j.str = std::move(s);
        return j;
    }
    static Json of(double n) {
        Json j;
        j.type = Type::Number;
        j.number = n;
        return j;
    }
    static Json of(int n) { return of(static_cast<double>(n)); }
    static Json of(bool b) {
        Json j;
        j.type = Type::Bool;
        j.boolean = b;
        return j;
    }

    void set(const std::string& key, Json value) { obj.emplace_back(key, std::move(value)); }
    void push(Json value) { arr.push_back(std::move(value)); }

    // Object lookup; returns nullptr if absent or not an object.
    const Json* get(const std::string& key) const;
    // Convenience typed reads with defaults.
    std::string asString(const std::string& def = "") const { return type == Type::String ? str : def; }
    int asInt(int def = 0) const { return type == Type::Number ? static_cast<int>(number) : def; }
    std::string getString(const std::string& key, const std::string& def = "") const;
    int getInt(const std::string& key, int def = 0) const;

    std::string dump() const;
    static bool parse(const std::string& text, Json& out);
};

}  // namespace polaron::lsp
