#include <doctest/doctest.h>

#include <string>

#include "lsp/json.h"

using namespace polaron::lsp;

TEST_CASE("json parses objects, arrays, strings, numbers and booleans") {
    Json j;
    REQUIRE(Json::parse(R"({"a":1,"b":[true,null,"x\ny"],"c":{"d":-2.5}})", j));
    CHECK(j.type == Json::Type::Object);
    CHECK(j.getInt("a") == 1);
    const Json* b = j.get("b");
    REQUIRE(b != nullptr);
    REQUIRE(b->type == Json::Type::Array);
    REQUIRE(b->arr.size() == 3);
    CHECK(b->arr[0].boolean);
    CHECK(b->arr[1].type == Json::Type::Null);
    CHECK(b->arr[2].str == "x\ny");
    const Json* c = j.get("c");
    REQUIRE(c != nullptr);
    CHECK(c->getString("d") == "");  // d is a number, not a string
    const Json* d = c->get("d");
    REQUIRE(d != nullptr);
    CHECK(d->number == doctest::Approx(-2.5));
}

TEST_CASE("json dump escapes control characters and quotes") {
    CHECK(Json::of(std::string("a\"b\n")).dump() == "\"a\\\"b\\n\"");
    CHECK(Json::of(42).dump() == "42");
    CHECK(Json::of(true).dump() == "true");
}

TEST_CASE("json builds then re-parses to the same shape") {
    Json obj = Json::makeObject();
    obj.set("name", Json::of(std::string("Foo")));
    Json arr = Json::makeArray();
    arr.push(Json::of(1));
    arr.push(Json::of(2));
    obj.set("items", std::move(arr));

    Json back;
    REQUIRE(Json::parse(obj.dump(), back));
    CHECK(back.getString("name") == "Foo");
    CHECK(back.get("items")->arr.size() == 2);
}

TEST_CASE("json rejects malformed input") {
    Json j;
    CHECK_FALSE(Json::parse("{unquoted:1}", j));
    CHECK_FALSE(Json::parse("[1,2", j));
    CHECK_FALSE(Json::parse("", j));
}
