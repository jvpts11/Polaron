; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }
%class.Json = type { ptr, i32, i32, i64, ptr, ptr, ptr, ptr, ptr, i32 }
%class.JsonParser = type { ptr, ptr, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@Json.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @Json.size, ptr null, ptr null, ptr null, ptr @Json.put, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Json.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Json.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Json.kindOf, ptr @Json.asBool, ptr @Json.asNum, ptr @Json.asStr, ptr @Json.at, ptr @Json.field, ptr @Json.escapeInto, ptr @Json.writeInto, ptr @Json.pad, ptr @Json.prettyInto, ptr @Json.prettyString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@JsonParser.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @JsonParser.skipWs, ptr @JsonParser.parseString, ptr @JsonParser.parseValue, ptr @JsonParser.parseArray, ptr @JsonParser.parseObject, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [5 x i8] c"name\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [8 x i8] c"Polaron\00"
@.strobj.2 = private global %String { i64 7, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [8 x i8] c"version\00"
@.strobj.4 = private global %String { i64 7, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [5 x i8] c"cool\00"
@.strobj.6 = private global %String { i64 4, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [5 x i8] c"nums\00"
@.strobj.8 = private global %String { i64 4, ptr @.strdata.7, i64 0 }
@.str = private unnamed_addr constant [49 x i8] c"name=%d ver=%d cool=%d n0=%d n1=%d roundtrip=%d\0A\00", align 1
@.strdata.9 = private constant [5 x i8] c"name\00"
@.strobj.10 = private global %String { i64 4, ptr @.strdata.9, i64 0 }
@.panic = private unnamed_addr constant [131 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol:23:41  in main\0A\00", align 1
@.strdata.11 = private constant [8 x i8] c"Polaron\00"
@.strobj.12 = private global %String { i64 7, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [8 x i8] c"version\00"
@.strobj.14 = private global %String { i64 7, ptr @.strdata.13, i64 0 }
@.panic.15 = private unnamed_addr constant [131 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol:23:41  in main\0A\00", align 1
@.strdata.16 = private constant [5 x i8] c"cool\00"
@.strobj.17 = private global %String { i64 4, ptr @.strdata.16, i64 0 }
@.panic.18 = private unnamed_addr constant [131 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol:23:41  in main\0A\00", align 1
@.strdata.19 = private constant [5 x i8] c"nums\00"
@.strobj.20 = private global %String { i64 4, ptr @.strdata.19, i64 0 }
@.panic.21 = private unnamed_addr constant [131 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol:23:41  in main\0A\00", align 1
@.panic.22 = private unnamed_addr constant [131 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol:23:41  in main\0A\00", align 1
@.strdata.23 = private constant [5 x i8] c"nums\00"
@.strobj.24 = private global %String { i64 4, ptr @.strdata.23, i64 0 }
@.panic.25 = private unnamed_addr constant [131 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol:23:41  in main\0A\00", align 1
@.panic.26 = private unnamed_addr constant [131 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_stdlib.pol:23:41  in main\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1332 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1333 = private global %String { i64 16, ptr @.strdata.1332, i64 0 }
@.strdata.1334 = private constant [17 x i8] c"division by zero\00"
@.strobj.1335 = private global %String { i64 16, ptr @.strdata.1334, i64 0 }
@.strdata.3939 = private constant [1 x i8] zeroinitializer
@.strobj.3940 = private global %String { i64 0, ptr @.strdata.3939, i64 0 }
@.strdata.3941 = private constant [1 x i8] zeroinitializer
@.strobj.3942 = private global %String { i64 0, ptr @.strdata.3941, i64 0 }
@.panic.3943 = private unnamed_addr constant [81 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:7953:104  in Json.add\0A\00", align 1
@.panic.3944 = private unnamed_addr constant [79 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:7965:59  in Json.at\0A\00", align 1
@.panic.3945 = private unnamed_addr constant [82 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:7971:21  in Json.field\0A\00", align 1
@.panic.3946 = private unnamed_addr constant [82 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:7972:25  in Json.field\0A\00", align 1
@.strdata.3947 = private constant [5 x i8] c"null\00"
@.strobj.3948 = private global %String { i64 4, ptr @.strdata.3947, i64 0 }
@.strdata.3949 = private constant [5 x i8] c"true\00"
@.strobj.3950 = private global %String { i64 4, ptr @.strdata.3949, i64 0 }
@.strdata.3951 = private constant [6 x i8] c"false\00"
@.strobj.3952 = private global %String { i64 5, ptr @.strdata.3951, i64 0 }
@.panic.3953 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8003:38  in Json.writeInto\0A\00", align 1
@.panic.3954 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8004:29  in Json.writeInto\0A\00", align 1
@.panic.3955 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8015:36  in Json.writeInto\0A\00", align 1
@.panic.3956 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8017:32  in Json.writeInto\0A\00", align 1
@.panic.3957 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8018:23  in Json.writeInto\0A\00", align 1
@.strdata.3958 = private constant [5 x i8] c"null\00"
@.strobj.3959 = private global %String { i64 4, ptr @.strdata.3958, i64 0 }
@.strdata.3960 = private constant [5 x i8] c"true\00"
@.strobj.3961 = private global %String { i64 4, ptr @.strdata.3960, i64 0 }
@.strdata.3962 = private constant [6 x i8] c"false\00"
@.strobj.3963 = private global %String { i64 5, ptr @.strdata.3962, i64 0 }
@.strdata.3964 = private constant [3 x i8] c"[]\00"
@.strobj.3965 = private global %String { i64 2, ptr @.strdata.3964, i64 0 }
@.panic.3966 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8045:39  in Json.prettyInto\0A\00", align 1
@.panic.3967 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8046:29  in Json.prettyInto\0A\00", align 1
@.strdata.3968 = private constant [3 x i8] c"{}\00"
@.strobj.3969 = private global %String { i64 2, ptr @.strdata.3968, i64 0 }
@.panic.3970 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8059:36  in Json.prettyInto\0A\00", align 1
@.panic.3971 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8061:33  in Json.prettyInto\0A\00", align 1
@.panic.3972 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8062:23  in Json.prettyInto\0A\00", align 1
@.strdata.5334 = private constant [1 x i8] zeroinitializer
@.strobj.5335 = private global %String { i64 0, ptr @.strdata.5334, i64 0 }
@.strdata.5336 = private constant [1 x i8] zeroinitializer
@.strobj.5337 = private global %String { i64 0, ptr @.strdata.5336, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %p = alloca ptr, align 8
  %s = alloca ptr, align 8
  %arr = alloca ptr, align 8
  %obj = alloca ptr, align 8
  %args = alloca ptr, align 8
  %argv.i = alloca i64, align 8
  %2 = sext i32 %0 to i64
  %3 = sub i64 %2, 1
  %4 = icmp slt i64 %3, 0
  %5 = select i1 %4, i64 0, i64 %3
  %6 = mul i64 %5, 8
  %7 = add i64 8, %6
  %argv.arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %argv.arr, align 8
  %arr.data = getelementptr i8, ptr %argv.arr, i64 8
  store i64 0, ptr %argv.i, align 8
  br label %argv.cond

argv.cond:                                        ; preds = %argv.body, %entry
  %argv.iv = load i64, ptr %argv.i, align 8
  %8 = icmp slt i64 %argv.iv, %5
  br i1 %8, label %argv.body, label %argv.end

argv.body:                                        ; preds = %argv.cond
  %9 = add i64 %argv.iv, 1
  %10 = getelementptr ptr, ptr %1, i64 %9
  %argv.s = load ptr, ptr %10, align 8
  %argv.rawlen = call i64 @strlen(ptr %argv.s)
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %argv.rawlen, ptr %11, align 8
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %argv.s, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %13, align 8
  %14 = getelementptr ptr, ptr %arr.data, i64 %argv.iv
  store ptr %newstr, ptr %14, align 8
  %15 = add i64 %argv.iv, 1
  store i64 %15, ptr %argv.i, align 8
  br label %argv.cond

argv.end:                                         ; preds = %argv.cond
  store ptr %argv.arr, ptr %args, align 8
  call void @Test.__onClassLoad()
  %16 = call ptr @Json.object()
  store ptr %16, ptr %obj, align 8
  %obj1 = load ptr, ptr %obj, align 8
  %17 = call ptr @Json.ofStr(ptr @.strobj.2)
  call void @Json.put(ptr %obj1, ptr @.strobj, ptr %17)
  %obj2 = load ptr, ptr %obj, align 8
  %18 = call ptr @Json.ofNum(i64 1)
  call void @Json.put(ptr %obj2, ptr @.strobj.4, ptr %18)
  %obj3 = load ptr, ptr %obj, align 8
  %19 = call ptr @Json.ofBool(i32 1)
  call void @Json.put(ptr %obj3, ptr @.strobj.6, ptr %19)
  %20 = call ptr @Json.array()
  store ptr %20, ptr %arr, align 8
  %arr4 = load ptr, ptr %arr, align 8
  %21 = call ptr @Json.ofNum(i64 10)
  call void @Json.add(ptr %arr4, ptr %21)
  %arr5 = load ptr, ptr %arr, align 8
  %22 = call ptr @Json.ofNum(i64 20)
  call void @Json.add(ptr %arr5, ptr %22)
  %obj6 = load ptr, ptr %obj, align 8
  %arr7 = load ptr, ptr %arr, align 8
  call void @Json.put(ptr %obj6, ptr @.strobj.8, ptr %arr7)
  %obj8 = load ptr, ptr %obj, align 8
  %23 = call ptr @Json.toString(ptr %obj8)
  %strcpy = call ptr @__polaron_str_copy(ptr %23)
  store ptr %strcpy, ptr %s, align 8
  call void @__polaron_str_free(ptr %23)
  %s9 = load ptr, ptr %s, align 8
  %24 = call ptr @Json.parse(ptr %s9)
  store ptr %24, ptr %p, align 8
  %p10 = load ptr, ptr %p, align 8
  %25 = call ptr @Json.field(ptr %p10, ptr @.strobj.10)
  %26 = icmp eq ptr %25, null
  br i1 %26, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %argv.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %argv.end
  %27 = call ptr @Json.asStr(ptr %25)
  %str.data = getelementptr inbounds %String, ptr %27, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %data11 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.12, i32 0, i32 1), align 8
  %28 = call i32 @strcmp(ptr %data, ptr %data11)
  %29 = icmp eq i32 %28, 0
  %30 = zext i1 %29 to i32
  %p12 = load ptr, ptr %p, align 8
  %31 = call ptr @Json.field(ptr %p12, ptr @.strobj.14)
  %32 = icmp eq ptr %31, null
  br i1 %32, label %nullrecv13, label %nullrecv.ok14

nullrecv13:                                       ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.15)
  unreachable

nullrecv.ok14:                                    ; preds = %nullrecv.ok
  %33 = call i64 @Json.asNum(ptr %31)
  %34 = trunc i64 %33 to i32
  %p15 = load ptr, ptr %p, align 8
  %35 = call ptr @Json.field(ptr %p15, ptr @.strobj.17)
  %36 = icmp eq ptr %35, null
  br i1 %36, label %nullrecv16, label %nullrecv.ok17

nullrecv16:                                       ; preds = %nullrecv.ok14
  call void @__polaron_panic(ptr @.panic.18)
  unreachable

nullrecv.ok17:                                    ; preds = %nullrecv.ok14
  %37 = call i32 @Json.asBool(ptr %35)
  %p18 = load ptr, ptr %p, align 8
  %38 = call ptr @Json.field(ptr %p18, ptr @.strobj.20)
  %39 = icmp eq ptr %38, null
  br i1 %39, label %nullrecv19, label %nullrecv.ok20

nullrecv19:                                       ; preds = %nullrecv.ok17
  call void @__polaron_panic(ptr @.panic.21)
  unreachable

nullrecv.ok20:                                    ; preds = %nullrecv.ok17
  %40 = call ptr @Json.at(ptr %38, i32 0)
  %41 = icmp eq ptr %40, null
  br i1 %41, label %nullrecv21, label %nullrecv.ok22

nullrecv21:                                       ; preds = %nullrecv.ok20
  call void @__polaron_panic(ptr @.panic.22)
  unreachable

nullrecv.ok22:                                    ; preds = %nullrecv.ok20
  %42 = call i64 @Json.asNum(ptr %40)
  %43 = trunc i64 %42 to i32
  %p23 = load ptr, ptr %p, align 8
  %44 = call ptr @Json.field(ptr %p23, ptr @.strobj.24)
  %45 = icmp eq ptr %44, null
  br i1 %45, label %nullrecv24, label %nullrecv.ok25

nullrecv24:                                       ; preds = %nullrecv.ok22
  call void @__polaron_panic(ptr @.panic.25)
  unreachable

nullrecv.ok25:                                    ; preds = %nullrecv.ok22
  %46 = call ptr @Json.at(ptr %44, i32 1)
  %47 = icmp eq ptr %46, null
  br i1 %47, label %nullrecv26, label %nullrecv.ok27

nullrecv26:                                       ; preds = %nullrecv.ok25
  call void @__polaron_panic(ptr @.panic.26)
  unreachable

nullrecv.ok27:                                    ; preds = %nullrecv.ok25
  %48 = call i64 @Json.asNum(ptr %46)
  %49 = trunc i64 %48 to i32
  %s28 = load ptr, ptr %s, align 8
  %p29 = load ptr, ptr %p, align 8
  %50 = call ptr @Json.toString(ptr %p29)
  %str.data30 = getelementptr inbounds %String, ptr %s28, i32 0, i32 1
  %data31 = load ptr, ptr %str.data30, align 8
  %str.data32 = getelementptr inbounds %String, ptr %50, i32 0, i32 1
  %data33 = load ptr, ptr %str.data32, align 8
  %51 = call i32 @strcmp(ptr %data31, ptr %data33)
  %52 = icmp eq i32 %51, 0
  %53 = zext i1 %52 to i32
  %54 = call i32 (ptr, ...) @printf(ptr @.str, i32 %30, i32 %34, i32 %37, i32 %43, i32 %49, i32 %53)
  call void @__polaron_str_free(ptr %50)
  %55 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %55)
  ret i32 0
}

define internal i32 @Object.equals(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal i32 @Object.hashCode(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 0
}

define internal i32 @Object.equalsKey(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal void @Object.Object(ptr %0) {
entry:
  %vtbl.addr = getelementptr inbounds %class.Object, ptr %0, i32 0, i32 0
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @Exception.Exception(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  ret void
}

define internal void @ArithmeticException.ArithmeticException(ptr %0) {
entry:
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ArithmeticException, ptr %0, i32 0, i32 0
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1333)
  ret ptr %strcpy
}

define internal void @DivideByZeroException.DivideByZeroException(ptr %0) {
entry:
  call void @ArithmeticException.ArithmeticException(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DivideByZeroException, ptr %0, i32 0, i32 0
  store ptr @DivideByZeroException.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal ptr @DivideByZeroException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1335)
  ret ptr %strcpy
}

define internal void @StringBuilder.StringBuilder(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 0
  store ptr @StringBuilder.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  store i32 16, ptr %cap, align 4, !tbaa !4
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %1 = ptrtoint ptr %mem.alloc to i64
  store i64 %1, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @StringBuilder.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %nb = alloca i64, align 8
  %n = alloca i32, align 4
  %extra = alloca i32, align 4
  store i32 %1, ptr %extra, align 4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %extra2 = load i32, ptr %extra, align 4
  %2 = add i32 %count1, %extra2
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap3 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %2, %cap3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap5 = load i32, ptr %cap4, align 4, !tbaa !4
  %5 = mul i32 %cap5, 2
  store i32 %5, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %n6 = load i32, ptr %n, align 4
  %count7 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %extra9 = load i32, ptr %extra, align 4
  %6 = add i32 %count8, %extra9
  %7 = icmp slt i32 %n6, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n10 = load i32, ptr %n, align 4
  %9 = mul i32 %n10, 2
  store i32 %9, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n11 = load i32, ptr %n, align 4
  %10 = zext i32 %n11 to i64
  %mem.alloc = call ptr @__polaron_malloc(i64 %10)
  %11 = ptrtoint ptr %mem.alloc to i64
  store i64 %11, ptr %nb, align 8
  %nb12 = load i64, ptr %nb, align 8
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf13 = load i64, ptr %buf, align 8, !tbaa !6
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !6
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !6
  %cap20 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %n21 = load i32, ptr %n, align 4
  store i32 %n21, ptr %cap20, align 4, !tbaa !4
  ret void
}

define internal ptr @StringBuilder.append(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  call void @StringBuilder.ensure(ptr %0, i32 %n2)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !4
  %3 = sext i32 %count4 to i64
  %4 = add i64 %buf3, %3
  %s5 = load ptr, ptr %s, align 8
  %5 = inttoptr i64 %4 to ptr
  %str.len6 = getelementptr inbounds %String, ptr %s5, i32 0, i32 0
  %len7 = load i64, ptr %str.len6, align 8
  %str.data = getelementptr inbounds %String, ptr %s5, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %6 = call ptr @memcpy(ptr %5, ptr %data, i64 %len7)
  %count8 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count9 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %n11 = load i32, ptr %n, align 4
  %7 = add i32 %count10, %n11
  store i32 %7, ptr %count8, align 4, !tbaa !4
  ret ptr %0
}

define internal ptr @StringBuilder.appendChar(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  store i32 %1, ptr %c, align 4
  call void @StringBuilder.ensure(ptr %0, i32 1)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %2 = sext i32 %count2 to i64
  %3 = add i64 %buf1, %2
  %c3 = load i32, ptr %c, align 4
  %4 = trunc i32 %c3 to i8
  %5 = inttoptr i64 %3 to ptr
  store i8 %4, ptr %5, align 1
  %count4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count5 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count6 = load i32, ptr %count5, align 4, !tbaa !4
  %6 = add i32 %count6, 1
  store i32 %6, ptr %count4, align 4, !tbaa !4
  ret ptr %0
}

define internal ptr @StringBuilder.appendInt(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i8, align 1
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %exc.thrown15 = alloca ptr, align 8
  %d = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %start = alloca i32, align 4
  %v = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  call void @StringBuilder.ensure(ptr %0, i32 12)
  %value1 = load i32, ptr %value, align 4
  %2 = icmp eq i32 %value1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %4 = call ptr @StringBuilder.appendChar(ptr %0, i32 48)
  ret ptr %4

if.end:                                           ; preds = %entry
  %value2 = load i32, ptr %value, align 4
  store i32 %value2, ptr %v, align 4
  %v3 = load i32, ptr %v, align 4
  %5 = icmp sgt i32 %v3, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then4, label %if.else

if.then4:                                         ; preds = %if.end
  %v6 = load i32, ptr %v, align 4
  %7 = sub i32 0, %v6
  store i32 %7, ptr %v, align 4
  br label %if.end5

if.else:                                          ; preds = %if.end
  %8 = call ptr @StringBuilder.appendChar(ptr %0, i32 45)
  br label %if.end5

if.end5:                                          ; preds = %if.else, %if.then4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count, align 4, !tbaa !4
  store i32 %count7, ptr %start, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok13, %if.end5
  %v8 = load i32, ptr %v, align 4
  %9 = icmp ne i32 %v8, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v9 = load i32, ptr %v, align 4
  %11 = icmp eq i32 %v9, -2147483648
  %12 = and i1 %11, false
  %13 = or i1 false, %12
  br i1 %13, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  %start16 = load i32, ptr %start, align 4
  store i32 %start16, ptr %a, align 4
  %count17 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %14 = sub i32 %count18, 1
  store i32 %14, ptr %b, align 4
  br label %while.cond19

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %15 = srem i32 %v9, 10
  %16 = sub i32 0, %15
  store i32 %16, ptr %d, align 4
  %d10 = load i32, ptr %d, align 4
  %17 = add i32 48, %d10
  %18 = call ptr @StringBuilder.appendChar(ptr %0, i32 %17)
  %v11 = load i32, ptr %v, align 4
  %19 = icmp eq i32 %v11, -2147483648
  %20 = and i1 %19, false
  %21 = or i1 false, %20
  br i1 %21, label %div.bad12, label %div.ok13

div.bad12:                                        ; preds = %div.ok
  %exc14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc14)
  store ptr %exc14, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

div.ok13:                                         ; preds = %div.ok
  %22 = sdiv i32 %v11, 10
  store i32 %22, ptr %v, align 4
  br label %while.cond

while.cond19:                                     ; preds = %while.body20, %while.end
  %a22 = load i32, ptr %a, align 4
  %b23 = load i32, ptr %b, align 4
  %23 = icmp slt i32 %a22, %b23
  %24 = zext i1 %23 to i32
  br i1 %23, label %while.body20, label %while.end21

while.body20:                                     ; preds = %while.cond19
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf24 = load i64, ptr %buf, align 8, !tbaa !6
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !6
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !6
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !6
  %b35 = load i32, ptr %b, align 4
  %34 = sext i32 %b35 to i64
  %35 = add i64 %buf34, %34
  %t36 = load i8, ptr %t, align 1
  %36 = inttoptr i64 %35 to ptr
  store i8 %t36, ptr %36, align 1
  %a37 = load i32, ptr %a, align 4
  %37 = add i32 %a37, 1
  store i32 %37, ptr %a, align 4
  %b38 = load i32, ptr %b, align 4
  %38 = sub i32 %b38, 1
  store i32 %38, ptr %b, align 4
  br label %while.cond19

while.end21:                                      ; preds = %while.cond19
  ret ptr %0
}

define internal i32 @StringBuilder.length(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal ptr @StringBuilder.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count2 to i64
  %2 = inttoptr i64 %buf1 to ptr
  %3 = add i64 %1, 1
  %fb.buf = call ptr @__polaron_malloc(i64 %3)
  %4 = call ptr @memcpy(ptr %fb.buf, ptr %2, i64 %1)
  %5 = getelementptr i8, ptr %fb.buf, i64 %1
  store i8 0, ptr %5, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %1, ptr %6, align 8
  %7 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %fb.buf, ptr %7, align 8
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %8, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy
}

define internal ptr @StringBuilder.clear(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret ptr %0
}

define internal void @"StringBuilder.~StringBuilder"(ptr %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !6
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !6
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Json.Json(ptr %0, i32 %1) {
entry:
  %k = alloca i32, align 4
  store i32 %1, ptr %k, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 0
  store ptr @Json.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %str = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 4
  store ptr null, ptr %str, align 8, !tbaa !0
  %memberKey = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 5
  store ptr null, ptr %memberKey, align 8, !tbaa !0
  %kind = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %k1 = load i32, ptr %k, align 4
  store i32 %k1, ptr %kind, align 4, !tbaa !4
  %b = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 2
  store i32 0, ptr %b, align 4, !tbaa !4
  %num = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 3
  store i64 0, ptr %num, align 8, !tbaa !6
  %str2 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.3940)
  %2 = load ptr, ptr %str2, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %str2, align 8, !tbaa !0
  %memberKey3 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 5
  %strcpy4 = call ptr @__polaron_str_copy(ptr @.strobj.3942)
  %3 = load ptr, ptr %memberKey3, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy4, ptr %memberKey3, align 8, !tbaa !0
  %firstChild = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 6
  store ptr null, ptr %firstChild, align 8, !tbaa !0
  %lastChild = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 7
  store ptr null, ptr %lastChild, align 8, !tbaa !0
  %nextSibling = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 8
  store ptr null, ptr %nextSibling, align 8, !tbaa !0
  %childCount = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 9
  store i32 0, ptr %childCount, align 4, !tbaa !4
  ret void
}

define internal ptr @Json.ofNull() {
entry:
  %Json.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Json, ptr null, i64 1) to i64))
  call void @Json.Json(ptr %Json.obj, i32 0)
  ret ptr %Json.obj
}

define internal ptr @Json.ofBool(i32 %0) {
entry:
  %j = alloca ptr, align 8
  %v = alloca i32, align 4
  store i32 %0, ptr %v, align 4
  %Json.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Json, ptr null, i64 1) to i64))
  call void @Json.Json(ptr %Json.obj, i32 1)
  store ptr %Json.obj, ptr %j, align 8
  %j1 = load ptr, ptr %j, align 8
  %b = getelementptr inbounds %class.Json, ptr %j1, i32 0, i32 2
  %v2 = load i32, ptr %v, align 4
  store i32 %v2, ptr %b, align 4, !tbaa !4
  %j3 = load ptr, ptr %j, align 8
  ret ptr %j3
}

define internal ptr @Json.ofNum(i64 %0) {
entry:
  %j = alloca ptr, align 8
  %v = alloca i64, align 8
  store i64 %0, ptr %v, align 8
  %Json.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Json, ptr null, i64 1) to i64))
  call void @Json.Json(ptr %Json.obj, i32 2)
  store ptr %Json.obj, ptr %j, align 8
  %j1 = load ptr, ptr %j, align 8
  %num = getelementptr inbounds %class.Json, ptr %j1, i32 0, i32 3
  %v2 = load i64, ptr %v, align 8
  store i64 %v2, ptr %num, align 8, !tbaa !6
  %j3 = load ptr, ptr %j, align 8
  ret ptr %j3
}

define internal ptr @Json.ofStr(ptr %0) {
entry:
  %j = alloca ptr, align 8
  %v = alloca ptr, align 8
  store ptr %0, ptr %v, align 8
  %Json.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Json, ptr null, i64 1) to i64))
  call void @Json.Json(ptr %Json.obj, i32 3)
  store ptr %Json.obj, ptr %j, align 8
  %j1 = load ptr, ptr %j, align 8
  %str = getelementptr inbounds %class.Json, ptr %j1, i32 0, i32 4
  %v2 = load ptr, ptr %v, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %v2)
  %1 = load ptr, ptr %str, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy, ptr %str, align 8, !tbaa !0
  %j3 = load ptr, ptr %j, align 8
  ret ptr %j3
}

define internal ptr @Json.array() {
entry:
  %Json.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Json, ptr null, i64 1) to i64))
  call void @Json.Json(ptr %Json.obj, i32 4)
  ret ptr %Json.obj
}

define internal ptr @Json.object() {
entry:
  %Json.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Json, ptr null, i64 1) to i64))
  call void @Json.Json(ptr %Json.obj, i32 5)
  ret ptr %Json.obj
}

define internal void @Json.add(ptr nonnull align 8 dereferenceable(72) %0, ptr %1) {
entry:
  %v = alloca ptr, align 8
  store ptr %1, ptr %v, align 8
  %lastChild = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 7
  %lastChild1 = load ptr, ptr %lastChild, align 8, !tbaa !0
  %2 = icmp eq ptr %lastChild1, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %firstChild = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 6
  %v2 = load ptr, ptr %v, align 8
  store ptr %v2, ptr %firstChild, align 8, !tbaa !0
  br label %if.end

if.else:                                          ; preds = %entry
  %lastChild3 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 7
  %lastChild4 = load ptr, ptr %lastChild3, align 8, !tbaa !0
  %4 = icmp eq ptr %lastChild4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

if.end:                                           ; preds = %nullrecv.ok, %if.then
  %lastChild6 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 7
  %v7 = load ptr, ptr %v, align 8
  store ptr %v7, ptr %lastChild6, align 8, !tbaa !0
  %childCount = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 9
  %childCount8 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 9
  %childCount9 = load i32, ptr %childCount8, align 4, !tbaa !4
  %5 = add i32 %childCount9, 1
  store i32 %5, ptr %childCount, align 4, !tbaa !4
  ret void

nullrecv:                                         ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.3943)
  unreachable

nullrecv.ok:                                      ; preds = %if.else
  %nextSibling = getelementptr inbounds %class.Json, ptr %lastChild4, i32 0, i32 8
  %v5 = load ptr, ptr %v, align 8
  store ptr %v5, ptr %nextSibling, align 8, !tbaa !0
  br label %if.end
}

define internal void @Json.put(ptr nonnull align 8 dereferenceable(72) %0, ptr %1, ptr %2) {
entry:
  %v = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store ptr %2, ptr %v, align 8
  %v1 = load ptr, ptr %v, align 8
  %memberKey = getelementptr inbounds %class.Json, ptr %v1, i32 0, i32 5
  %key2 = load ptr, ptr %key, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %key2)
  %3 = load ptr, ptr %memberKey, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy, ptr %memberKey, align 8, !tbaa !0
  %v3 = load ptr, ptr %v, align 8
  call void @Json.add(ptr %0, ptr %v3)
  ret void
}

define internal i32 @Json.kindOf(ptr nonnull align 8 dereferenceable(72) %0) {
entry:
  %kind = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind1 = load i32, ptr %kind, align 4, !tbaa !4
  ret i32 %kind1
}

define internal i32 @Json.asBool(ptr nonnull align 8 dereferenceable(72) %0) {
entry:
  %b = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 2
  %b1 = load i32, ptr %b, align 4, !tbaa !4
  ret i32 %b1
}

define internal i64 @Json.asNum(ptr nonnull align 8 dereferenceable(72) %0) {
entry:
  %num = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 3
  %num1 = load i64, ptr %num, align 8, !tbaa !6
  ret i64 %num1
}

define internal ptr @Json.asStr(ptr nonnull align 8 dereferenceable(72) %0) {
entry:
  %str = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 4
  %str1 = load ptr, ptr %str, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %str1)
  ret ptr %strcpy
}

define internal i32 @Json.size(ptr nonnull align 8 dereferenceable(72) %0) {
entry:
  %childCount = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 9
  %childCount1 = load i32, ptr %childCount, align 4, !tbaa !4
  ret i32 %childCount1
}

define internal ptr @Json.at(ptr nonnull align 8 dereferenceable(72) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %cur = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %firstChild = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 6
  %firstChild1 = load ptr, ptr %firstChild, align 8, !tbaa !0
  store ptr %firstChild1, ptr %cur, align 8
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %j2 = load i32, ptr %j, align 4
  %i3 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %j2, %i3
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

for.update:                                       ; preds = %nullrecv.ok
  %5 = load i32, ptr %j, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %cur6 = load ptr, ptr %cur, align 8
  ret ptr %cur6

nullrecv:                                         ; preds = %for.body
  call void @__polaron_panic(ptr @.panic.3944)
  unreachable

nullrecv.ok:                                      ; preds = %for.body
  %nextSibling = getelementptr inbounds %class.Json, ptr %cur4, i32 0, i32 8
  %nextSibling5 = load ptr, ptr %nextSibling, align 8, !tbaa !0
  store ptr %nextSibling5, ptr %cur, align 8
  br label %for.update
}

define internal ptr @Json.field(ptr nonnull align 8 dereferenceable(72) %0, ptr %1) {
entry:
  %cur = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %firstChild = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 6
  %firstChild1 = load ptr, ptr %firstChild, align 8, !tbaa !0
  store ptr %firstChild1, ptr %cur, align 8
  br label %while.cond

while.cond:                                       ; preds = %nullrecv.ok11, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %cur3 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur3, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %5 = call ptr @Json.ofNull()
  ret ptr %5

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.3945)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %memberKey = getelementptr inbounds %class.Json, ptr %cur3, i32 0, i32 5
  %memberKey4 = load ptr, ptr %memberKey, align 8, !tbaa !0
  %key5 = load ptr, ptr %key, align 8
  %str.data = getelementptr inbounds %String, ptr %memberKey4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data6 = getelementptr inbounds %String, ptr %key5, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %6 = call i32 @strcmp(ptr %data, ptr %data7)
  %7 = icmp eq i32 %6, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  %cur8 = load ptr, ptr %cur, align 8
  ret ptr %cur8

if.end:                                           ; preds = %nullrecv.ok
  %cur9 = load ptr, ptr %cur, align 8
  %9 = icmp eq ptr %cur9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.3946)
  unreachable

nullrecv.ok11:                                    ; preds = %if.end
  %nextSibling = getelementptr inbounds %class.Json, ptr %cur9, i32 0, i32 8
  %nextSibling12 = load ptr, ptr %nextSibling, align 8, !tbaa !0
  store ptr %nextSibling12, ptr %cur, align 8
  br label %while.cond
}

define internal void @Json.escapeInto(ptr nonnull align 8 dereferenceable(72) %0, ptr %1, ptr %2) {
entry:
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca ptr, align 8
  %sb = alloca ptr, align 8
  store ptr %1, ptr %sb, align 8
  store ptr %2, ptr %s, align 8
  %sb1 = load ptr, ptr %sb, align 8
  %3 = call ptr @StringBuilder.appendChar(ptr %sb1, i32 34)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %s3 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s3, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp slt i32 %i2, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s4 = load ptr, ptr %s, align 8
  %i5 = load i32, ptr %i, align 4
  %7 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %7
  %ch = load i8, ptr %ch.addr, align 1
  %8 = zext i8 %ch to i32
  store i32 %8, ptr %c, align 4
  %c6 = load i32, ptr %c, align 4
  %9 = icmp eq i32 %c6, 34
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then, label %if.else

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb17 = load ptr, ptr %sb, align 8
  %13 = call ptr @StringBuilder.appendChar(ptr %sb17, i32 34)
  ret void

if.then:                                          ; preds = %for.body
  %sb7 = load ptr, ptr %sb, align 8
  %14 = call ptr @StringBuilder.appendChar(ptr %sb7, i32 92)
  %sb8 = load ptr, ptr %sb, align 8
  %15 = call ptr @StringBuilder.appendChar(ptr %sb8, i32 34)
  br label %if.end

if.else:                                          ; preds = %for.body
  %c9 = load i32, ptr %c, align 4
  %16 = icmp eq i32 %c9, 92
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then10, label %if.else11

if.end:                                           ; preds = %if.end12, %if.then
  br label %for.update

if.then10:                                        ; preds = %if.else
  %sb13 = load ptr, ptr %sb, align 8
  %18 = call ptr @StringBuilder.appendChar(ptr %sb13, i32 92)
  %sb14 = load ptr, ptr %sb, align 8
  %19 = call ptr @StringBuilder.appendChar(ptr %sb14, i32 92)
  br label %if.end12

if.else11:                                        ; preds = %if.else
  %sb15 = load ptr, ptr %sb, align 8
  %c16 = load i32, ptr %c, align 4
  %20 = call ptr @StringBuilder.appendChar(ptr %sb15, i32 %c16)
  br label %if.end12

if.end12:                                         ; preds = %if.else11, %if.then10
  br label %if.end
}

define internal void @Json.writeInto(ptr nonnull align 8 dereferenceable(72) %0, ptr %1) {
entry:
  %firstM = alloca i32, align 4
  %m = alloca ptr, align 8
  %first = alloca i32, align 4
  %cur = alloca ptr, align 8
  %sb = alloca ptr, align 8
  store ptr %1, ptr %sb, align 8
  %kind = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind1 = load i32, ptr %kind, align 4, !tbaa !4
  %2 = icmp eq i32 %kind1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %sb2 = load ptr, ptr %sb, align 8
  %4 = call ptr @StringBuilder.append(ptr %sb2, ptr @.strobj.3948)
  ret void

if.end:                                           ; preds = %entry
  %kind3 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind4 = load i32, ptr %kind3, align 4, !tbaa !4
  %5 = icmp eq i32 %kind4, 1
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  %b = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 2
  %b7 = load i32, ptr %b, align 4, !tbaa !4
  %7 = icmp ne i32 %b7, 0
  br i1 %7, label %if.then8, label %if.else

if.end6:                                          ; preds = %if.end
  %kind12 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind13 = load i32, ptr %kind12, align 4, !tbaa !4
  %8 = icmp eq i32 %kind13, 2
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then14, label %if.end15

if.then8:                                         ; preds = %if.then5
  %sb10 = load ptr, ptr %sb, align 8
  %10 = call ptr @StringBuilder.append(ptr %sb10, ptr @.strobj.3950)
  br label %if.end9

if.else:                                          ; preds = %if.then5
  %sb11 = load ptr, ptr %sb, align 8
  %11 = call ptr @StringBuilder.append(ptr %sb11, ptr @.strobj.3952)
  br label %if.end9

if.end9:                                          ; preds = %if.else, %if.then8
  ret void

if.then14:                                        ; preds = %if.end6
  %sb16 = load ptr, ptr %sb, align 8
  %num = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 3
  %num17 = load i64, ptr %num, align 8, !tbaa !6
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %12 = call i64 @__polaron_itoa(i64 %num17, ptr %itoa.buf)
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %12, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %itoa.buf, ptr %14, align 8
  %15 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %15, align 8
  %16 = call ptr @StringBuilder.append(ptr %sb16, ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret void

if.end15:                                         ; preds = %if.end6
  %kind18 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind19 = load i32, ptr %kind18, align 4, !tbaa !4
  %17 = icmp eq i32 %kind19, 3
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then20, label %if.end21

if.then20:                                        ; preds = %if.end15
  %sb22 = load ptr, ptr %sb, align 8
  %str = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 4
  %str23 = load ptr, ptr %str, align 8, !tbaa !0
  call void @Json.escapeInto(ptr %0, ptr %sb22, ptr %str23)
  ret void

if.end21:                                         ; preds = %if.end15
  %kind24 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind25 = load i32, ptr %kind24, align 4, !tbaa !4
  %19 = icmp eq i32 %kind25, 4
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then26, label %if.end27

if.then26:                                        ; preds = %if.end21
  %sb28 = load ptr, ptr %sb, align 8
  %21 = call ptr @StringBuilder.appendChar(ptr %sb28, i32 91)
  %firstChild = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 6
  %firstChild29 = load ptr, ptr %firstChild, align 8, !tbaa !0
  store ptr %firstChild29, ptr %cur, align 8
  store i32 1, ptr %first, align 4
  br label %while.cond

if.end27:                                         ; preds = %if.end21
  %sb42 = load ptr, ptr %sb, align 8
  %22 = call ptr @StringBuilder.appendChar(ptr %sb42, i32 123)
  %firstChild43 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 6
  %firstChild44 = load ptr, ptr %firstChild43, align 8, !tbaa !0
  store ptr %firstChild44, ptr %m, align 8
  store i32 1, ptr %firstM, align 4
  br label %while.cond45

while.cond:                                       ; preds = %nullrecv.ok39, %if.then26
  %cur30 = load ptr, ptr %cur, align 8
  %23 = icmp ne ptr %cur30, null
  %24 = zext i1 %23 to i32
  br i1 %23, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %first31 = load i32, ptr %first, align 4
  %25 = icmp eq i32 %first31, 0
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then32, label %if.end33

while.end:                                        ; preds = %while.cond
  %sb41 = load ptr, ptr %sb, align 8
  %27 = call ptr @StringBuilder.appendChar(ptr %sb41, i32 93)
  ret void

if.then32:                                        ; preds = %while.body
  %sb34 = load ptr, ptr %sb, align 8
  %28 = call ptr @StringBuilder.appendChar(ptr %sb34, i32 44)
  br label %if.end33

if.end33:                                         ; preds = %if.then32, %while.body
  store i32 0, ptr %first, align 4
  %cur35 = load ptr, ptr %cur, align 8
  %29 = icmp eq ptr %cur35, null
  br i1 %29, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end33
  call void @__polaron_panic(ptr @.panic.3953)
  unreachable

nullrecv.ok:                                      ; preds = %if.end33
  %sb36 = load ptr, ptr %sb, align 8
  call void @Json.writeInto(ptr %cur35, ptr %sb36)
  %cur37 = load ptr, ptr %cur, align 8
  %30 = icmp eq ptr %cur37, null
  br i1 %30, label %nullrecv38, label %nullrecv.ok39

nullrecv38:                                       ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.3954)
  unreachable

nullrecv.ok39:                                    ; preds = %nullrecv.ok
  %nextSibling = getelementptr inbounds %class.Json, ptr %cur37, i32 0, i32 8
  %nextSibling40 = load ptr, ptr %nextSibling, align 8, !tbaa !0
  store ptr %nextSibling40, ptr %cur, align 8
  br label %while.cond

while.cond45:                                     ; preds = %nullrecv.ok65, %if.end27
  %m48 = load ptr, ptr %m, align 8
  %31 = icmp ne ptr %m48, null
  %32 = zext i1 %31 to i32
  br i1 %31, label %while.body46, label %while.end47

while.body46:                                     ; preds = %while.cond45
  %firstM49 = load i32, ptr %firstM, align 4
  %33 = icmp eq i32 %firstM49, 0
  %34 = zext i1 %33 to i32
  br i1 %33, label %if.then50, label %if.end51

while.end47:                                      ; preds = %while.cond45
  %sb68 = load ptr, ptr %sb, align 8
  %35 = call ptr @StringBuilder.appendChar(ptr %sb68, i32 125)
  ret void

if.then50:                                        ; preds = %while.body46
  %sb52 = load ptr, ptr %sb, align 8
  %36 = call ptr @StringBuilder.appendChar(ptr %sb52, i32 44)
  br label %if.end51

if.end51:                                         ; preds = %if.then50, %while.body46
  store i32 0, ptr %firstM, align 4
  %sb53 = load ptr, ptr %sb, align 8
  %m54 = load ptr, ptr %m, align 8
  %37 = icmp eq ptr %m54, null
  br i1 %37, label %nullrecv55, label %nullrecv.ok56

nullrecv55:                                       ; preds = %if.end51
  call void @__polaron_panic(ptr @.panic.3955)
  unreachable

nullrecv.ok56:                                    ; preds = %if.end51
  %memberKey = getelementptr inbounds %class.Json, ptr %m54, i32 0, i32 5
  %memberKey57 = load ptr, ptr %memberKey, align 8, !tbaa !0
  call void @Json.escapeInto(ptr %0, ptr %sb53, ptr %memberKey57)
  %sb58 = load ptr, ptr %sb, align 8
  %38 = call ptr @StringBuilder.appendChar(ptr %sb58, i32 58)
  %m59 = load ptr, ptr %m, align 8
  %39 = icmp eq ptr %m59, null
  br i1 %39, label %nullrecv60, label %nullrecv.ok61

nullrecv60:                                       ; preds = %nullrecv.ok56
  call void @__polaron_panic(ptr @.panic.3956)
  unreachable

nullrecv.ok61:                                    ; preds = %nullrecv.ok56
  %sb62 = load ptr, ptr %sb, align 8
  call void @Json.writeInto(ptr %m59, ptr %sb62)
  %m63 = load ptr, ptr %m, align 8
  %40 = icmp eq ptr %m63, null
  br i1 %40, label %nullrecv64, label %nullrecv.ok65

nullrecv64:                                       ; preds = %nullrecv.ok61
  call void @__polaron_panic(ptr @.panic.3957)
  unreachable

nullrecv.ok65:                                    ; preds = %nullrecv.ok61
  %nextSibling66 = getelementptr inbounds %class.Json, ptr %m63, i32 0, i32 8
  %nextSibling67 = load ptr, ptr %nextSibling66, align 8, !tbaa !0
  store ptr %nextSibling67, ptr %m, align 8
  br label %while.cond45
}

define internal ptr @Json.toString(ptr nonnull align 8 dereferenceable(72) %0) {
entry:
  %sb = alloca ptr, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb1 = load ptr, ptr %sb, align 8
  call void @Json.writeInto(ptr %0, ptr %sb1)
  %sb2 = load ptr, ptr %sb, align 8
  %1 = call ptr @StringBuilder.toString(ptr %sb2)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  call void @__polaron_str_free(ptr %1)
  ret ptr %strcpy
}

define internal void @Json.pad(ptr nonnull align 8 dereferenceable(72) %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %sb = alloca ptr, align 8
  store ptr %1, ptr %sb, align 8
  store i32 %2, ptr %n, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %i1, %n2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sb3 = load ptr, ptr %sb, align 8
  %5 = call ptr @StringBuilder.appendChar(ptr %sb3, i32 32)
  br label %for.update

for.update:                                       ; preds = %for.body
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

define internal void @Json.prettyInto(ptr nonnull align 8 dereferenceable(72) %0, ptr %1, i32 %2) {
entry:
  %firstM = alloca i32, align 4
  %m = alloca ptr, align 8
  %first = alloca i32, align 4
  %cur = alloca ptr, align 8
  %depth = alloca i32, align 4
  %sb = alloca ptr, align 8
  store ptr %1, ptr %sb, align 8
  store i32 %2, ptr %depth, align 4
  %kind = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind1 = load i32, ptr %kind, align 4, !tbaa !4
  %3 = icmp eq i32 %kind1, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %sb2 = load ptr, ptr %sb, align 8
  %5 = call ptr @StringBuilder.append(ptr %sb2, ptr @.strobj.3959)
  ret void

if.end:                                           ; preds = %entry
  %kind3 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind4 = load i32, ptr %kind3, align 4, !tbaa !4
  %6 = icmp eq i32 %kind4, 1
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  %b = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 2
  %b7 = load i32, ptr %b, align 4, !tbaa !4
  %8 = icmp ne i32 %b7, 0
  br i1 %8, label %if.then8, label %if.else

if.end6:                                          ; preds = %if.end
  %kind12 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind13 = load i32, ptr %kind12, align 4, !tbaa !4
  %9 = icmp eq i32 %kind13, 2
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then14, label %if.end15

if.then8:                                         ; preds = %if.then5
  %sb10 = load ptr, ptr %sb, align 8
  %11 = call ptr @StringBuilder.append(ptr %sb10, ptr @.strobj.3961)
  br label %if.end9

if.else:                                          ; preds = %if.then5
  %sb11 = load ptr, ptr %sb, align 8
  %12 = call ptr @StringBuilder.append(ptr %sb11, ptr @.strobj.3963)
  br label %if.end9

if.end9:                                          ; preds = %if.else, %if.then8
  ret void

if.then14:                                        ; preds = %if.end6
  %sb16 = load ptr, ptr %sb, align 8
  %num = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 3
  %num17 = load i64, ptr %num, align 8, !tbaa !6
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %13 = call i64 @__polaron_itoa(i64 %num17, ptr %itoa.buf)
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %13, ptr %14, align 8
  %15 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %itoa.buf, ptr %15, align 8
  %16 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %16, align 8
  %17 = call ptr @StringBuilder.append(ptr %sb16, ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret void

if.end15:                                         ; preds = %if.end6
  %kind18 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind19 = load i32, ptr %kind18, align 4, !tbaa !4
  %18 = icmp eq i32 %kind19, 3
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then20, label %if.end21

if.then20:                                        ; preds = %if.end15
  %sb22 = load ptr, ptr %sb, align 8
  %str = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 4
  %str23 = load ptr, ptr %str, align 8, !tbaa !0
  call void @Json.escapeInto(ptr %0, ptr %sb22, ptr %str23)
  ret void

if.end21:                                         ; preds = %if.end15
  %kind24 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 1
  %kind25 = load i32, ptr %kind24, align 4, !tbaa !4
  %20 = icmp eq i32 %kind25, 4
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then26, label %if.end27

if.then26:                                        ; preds = %if.end21
  %childCount = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 9
  %childCount28 = load i32, ptr %childCount, align 4, !tbaa !4
  %22 = icmp eq i32 %childCount28, 0
  %23 = zext i1 %22 to i32
  br i1 %22, label %if.then29, label %if.end30

if.end27:                                         ; preds = %if.end21
  %childCount54 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 9
  %childCount55 = load i32, ptr %childCount54, align 4, !tbaa !4
  %24 = icmp eq i32 %childCount55, 0
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then56, label %if.end57

if.then29:                                        ; preds = %if.then26
  %sb31 = load ptr, ptr %sb, align 8
  %26 = call ptr @StringBuilder.append(ptr %sb31, ptr @.strobj.3965)
  ret void

if.end30:                                         ; preds = %if.then26
  %sb32 = load ptr, ptr %sb, align 8
  %27 = call ptr @StringBuilder.appendChar(ptr %sb32, i32 91)
  %sb33 = load ptr, ptr %sb, align 8
  %28 = call ptr @StringBuilder.appendChar(ptr %sb33, i32 10)
  %firstChild = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 6
  %firstChild34 = load ptr, ptr %firstChild, align 8, !tbaa !0
  store ptr %firstChild34, ptr %cur, align 8
  store i32 1, ptr %first, align 4
  br label %while.cond

while.cond:                                       ; preds = %nullrecv.ok48, %if.end30
  %cur35 = load ptr, ptr %cur, align 8
  %29 = icmp ne ptr %cur35, null
  %30 = zext i1 %29 to i32
  br i1 %29, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %first36 = load i32, ptr %first, align 4
  %31 = icmp eq i32 %first36, 0
  %32 = zext i1 %31 to i32
  br i1 %31, label %if.then37, label %if.end38

while.end:                                        ; preds = %while.cond
  %sb50 = load ptr, ptr %sb, align 8
  %33 = call ptr @StringBuilder.appendChar(ptr %sb50, i32 10)
  %sb51 = load ptr, ptr %sb, align 8
  %depth52 = load i32, ptr %depth, align 4
  call void @Json.pad(ptr %0, ptr %sb51, i32 %depth52)
  %sb53 = load ptr, ptr %sb, align 8
  %34 = call ptr @StringBuilder.appendChar(ptr %sb53, i32 93)
  ret void

if.then37:                                        ; preds = %while.body
  %sb39 = load ptr, ptr %sb, align 8
  %35 = call ptr @StringBuilder.appendChar(ptr %sb39, i32 44)
  %sb40 = load ptr, ptr %sb, align 8
  %36 = call ptr @StringBuilder.appendChar(ptr %sb40, i32 10)
  br label %if.end38

if.end38:                                         ; preds = %if.then37, %while.body
  store i32 0, ptr %first, align 4
  %sb41 = load ptr, ptr %sb, align 8
  %depth42 = load i32, ptr %depth, align 4
  %37 = add i32 %depth42, 2
  call void @Json.pad(ptr %0, ptr %sb41, i32 %37)
  %cur43 = load ptr, ptr %cur, align 8
  %38 = icmp eq ptr %cur43, null
  br i1 %38, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end38
  call void @__polaron_panic(ptr @.panic.3966)
  unreachable

nullrecv.ok:                                      ; preds = %if.end38
  %sb44 = load ptr, ptr %sb, align 8
  %depth45 = load i32, ptr %depth, align 4
  %39 = add i32 %depth45, 2
  call void @Json.prettyInto(ptr %cur43, ptr %sb44, i32 %39)
  %cur46 = load ptr, ptr %cur, align 8
  %40 = icmp eq ptr %cur46, null
  br i1 %40, label %nullrecv47, label %nullrecv.ok48

nullrecv47:                                       ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.3967)
  unreachable

nullrecv.ok48:                                    ; preds = %nullrecv.ok
  %nextSibling = getelementptr inbounds %class.Json, ptr %cur46, i32 0, i32 8
  %nextSibling49 = load ptr, ptr %nextSibling, align 8, !tbaa !0
  store ptr %nextSibling49, ptr %cur, align 8
  br label %while.cond

if.then56:                                        ; preds = %if.end27
  %sb58 = load ptr, ptr %sb, align 8
  %41 = call ptr @StringBuilder.append(ptr %sb58, ptr @.strobj.3969)
  ret void

if.end57:                                         ; preds = %if.end27
  %sb59 = load ptr, ptr %sb, align 8
  %42 = call ptr @StringBuilder.appendChar(ptr %sb59, i32 123)
  %sb60 = load ptr, ptr %sb, align 8
  %43 = call ptr @StringBuilder.appendChar(ptr %sb60, i32 10)
  %firstChild61 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 6
  %firstChild62 = load ptr, ptr %firstChild61, align 8, !tbaa !0
  store ptr %firstChild62, ptr %m, align 8
  store i32 1, ptr %firstM, align 4
  br label %while.cond63

while.cond63:                                     ; preds = %nullrecv.ok88, %if.end57
  %m66 = load ptr, ptr %m, align 8
  %44 = icmp ne ptr %m66, null
  %45 = zext i1 %44 to i32
  br i1 %44, label %while.body64, label %while.end65

while.body64:                                     ; preds = %while.cond63
  %firstM67 = load i32, ptr %firstM, align 4
  %46 = icmp eq i32 %firstM67, 0
  %47 = zext i1 %46 to i32
  br i1 %46, label %if.then68, label %if.end69

while.end65:                                      ; preds = %while.cond63
  %sb91 = load ptr, ptr %sb, align 8
  %48 = call ptr @StringBuilder.appendChar(ptr %sb91, i32 10)
  %sb92 = load ptr, ptr %sb, align 8
  %depth93 = load i32, ptr %depth, align 4
  call void @Json.pad(ptr %0, ptr %sb92, i32 %depth93)
  %sb94 = load ptr, ptr %sb, align 8
  %49 = call ptr @StringBuilder.appendChar(ptr %sb94, i32 125)
  ret void

if.then68:                                        ; preds = %while.body64
  %sb70 = load ptr, ptr %sb, align 8
  %50 = call ptr @StringBuilder.appendChar(ptr %sb70, i32 44)
  %sb71 = load ptr, ptr %sb, align 8
  %51 = call ptr @StringBuilder.appendChar(ptr %sb71, i32 10)
  br label %if.end69

if.end69:                                         ; preds = %if.then68, %while.body64
  store i32 0, ptr %firstM, align 4
  %sb72 = load ptr, ptr %sb, align 8
  %depth73 = load i32, ptr %depth, align 4
  %52 = add i32 %depth73, 2
  call void @Json.pad(ptr %0, ptr %sb72, i32 %52)
  %sb74 = load ptr, ptr %sb, align 8
  %m75 = load ptr, ptr %m, align 8
  %53 = icmp eq ptr %m75, null
  br i1 %53, label %nullrecv76, label %nullrecv.ok77

nullrecv76:                                       ; preds = %if.end69
  call void @__polaron_panic(ptr @.panic.3970)
  unreachable

nullrecv.ok77:                                    ; preds = %if.end69
  %memberKey = getelementptr inbounds %class.Json, ptr %m75, i32 0, i32 5
  %memberKey78 = load ptr, ptr %memberKey, align 8, !tbaa !0
  call void @Json.escapeInto(ptr %0, ptr %sb74, ptr %memberKey78)
  %sb79 = load ptr, ptr %sb, align 8
  %54 = call ptr @StringBuilder.appendChar(ptr %sb79, i32 58)
  %sb80 = load ptr, ptr %sb, align 8
  %55 = call ptr @StringBuilder.appendChar(ptr %sb80, i32 32)
  %m81 = load ptr, ptr %m, align 8
  %56 = icmp eq ptr %m81, null
  br i1 %56, label %nullrecv82, label %nullrecv.ok83

nullrecv82:                                       ; preds = %nullrecv.ok77
  call void @__polaron_panic(ptr @.panic.3971)
  unreachable

nullrecv.ok83:                                    ; preds = %nullrecv.ok77
  %sb84 = load ptr, ptr %sb, align 8
  %depth85 = load i32, ptr %depth, align 4
  %57 = add i32 %depth85, 2
  call void @Json.prettyInto(ptr %m81, ptr %sb84, i32 %57)
  %m86 = load ptr, ptr %m, align 8
  %58 = icmp eq ptr %m86, null
  br i1 %58, label %nullrecv87, label %nullrecv.ok88

nullrecv87:                                       ; preds = %nullrecv.ok83
  call void @__polaron_panic(ptr @.panic.3972)
  unreachable

nullrecv.ok88:                                    ; preds = %nullrecv.ok83
  %nextSibling89 = getelementptr inbounds %class.Json, ptr %m86, i32 0, i32 8
  %nextSibling90 = load ptr, ptr %nextSibling89, align 8, !tbaa !0
  store ptr %nextSibling90, ptr %m, align 8
  br label %while.cond63
}

define internal ptr @Json.prettyString(ptr nonnull align 8 dereferenceable(72) %0) {
entry:
  %sb = alloca ptr, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb1 = load ptr, ptr %sb, align 8
  call void @Json.prettyInto(ptr %0, ptr %sb1, i32 0)
  %sb2 = load ptr, ptr %sb, align 8
  %1 = call ptr @StringBuilder.toString(ptr %sb2)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  call void @__polaron_str_free(ptr %1)
  ret ptr %strcpy
}

define internal ptr @Json.parse(ptr %0) {
entry:
  %p = alloca ptr, align 8
  %src = alloca ptr, align 8
  store ptr %0, ptr %src, align 8
  %JsonParser.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.JsonParser, ptr null, i64 1) to i64))
  %src1 = load ptr, ptr %src, align 8
  call void @JsonParser.JsonParser(ptr %JsonParser.obj, ptr %src1)
  store ptr %JsonParser.obj, ptr %p, align 8
  %p2 = load ptr, ptr %p, align 8
  %1 = call ptr @JsonParser.parseValue(ptr %p2)
  ret ptr %1
}

define internal void @JsonParser.JsonParser(ptr %0, ptr %1) {
entry:
  %src = alloca ptr, align 8
  store ptr %1, ptr %src, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 0
  store ptr @JsonParser.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %s = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  store ptr null, ptr %s, align 8, !tbaa !0
  %s1 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %src2 = load ptr, ptr %src, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %src2)
  %2 = load ptr, ptr %s1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %s1, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal void @JsonParser.skipWs(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %c = alloca i32, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %pos = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %s = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s2 = load ptr, ptr %s, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %s3 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s4 = load ptr, ptr %s3, align 8, !tbaa !0
  %pos5 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos6 = load i32, ptr %pos5, align 4, !tbaa !4
  %4 = sext i32 %pos6 to i64
  %str.data = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %c, align 4
  %c7 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %c7, 32
  %7 = zext i1 %6 to i32
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

while.end:                                        ; preds = %while.cond
  ret void

sc.rhs:                                           ; preds = %while.body
  %c8 = load i32, ptr %c, align 4
  %8 = icmp eq i32 %c8, 9
  %9 = zext i1 %8 to i32
  %sc.b = icmp ne i32 %9, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.body
  %sc = phi i1 [ true, %while.body ], [ %sc.b, %sc.rhs ]
  %10 = zext i1 %sc to i32
  %sc.a9 = icmp ne i32 %10, 0
  br i1 %sc.a9, label %sc.end11, label %sc.rhs10

sc.rhs10:                                         ; preds = %sc.end
  %c12 = load i32, ptr %c, align 4
  %11 = icmp eq i32 %c12, 10
  %12 = zext i1 %11 to i32
  %sc.b13 = icmp ne i32 %12, 0
  br label %sc.end11

sc.end11:                                         ; preds = %sc.rhs10, %sc.end
  %sc14 = phi i1 [ true, %sc.end ], [ %sc.b13, %sc.rhs10 ]
  %13 = zext i1 %sc14 to i32
  %sc.a15 = icmp ne i32 %13, 0
  br i1 %sc.a15, label %sc.end17, label %sc.rhs16

sc.rhs16:                                         ; preds = %sc.end11
  %c18 = load i32, ptr %c, align 4
  %14 = icmp eq i32 %c18, 13
  %15 = zext i1 %14 to i32
  %sc.b19 = icmp ne i32 %15, 0
  br label %sc.end17

sc.end17:                                         ; preds = %sc.rhs16, %sc.end11
  %sc20 = phi i1 [ true, %sc.end11 ], [ %sc.b19, %sc.rhs16 ]
  %16 = zext i1 %sc20 to i32
  br i1 %sc20, label %if.then, label %if.else

if.then:                                          ; preds = %sc.end17
  %pos21 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos22 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos23 = load i32, ptr %pos22, align 4, !tbaa !4
  %17 = add i32 %pos23, 1
  store i32 %17, ptr %pos21, align 4, !tbaa !4
  br label %if.end

if.else:                                          ; preds = %sc.end17
  ret void

if.end:                                           ; preds = %if.then
  br label %while.cond
}

define internal ptr @JsonParser.parseString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %e = alloca i32, align 4
  %c = alloca i32, align 4
  %sb = alloca ptr, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %pos = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos1 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos1, align 4, !tbaa !4
  %1 = add i32 %pos2, 1
  store i32 %1, ptr %pos, align 4, !tbaa !4
  br label %while.cond

while.cond:                                       ; preds = %if.end17, %entry
  %pos3 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos4 = load i32, ptr %pos3, align 4, !tbaa !4
  %s = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s5 = load ptr, ptr %s, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %s5, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp slt i32 %pos4, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %s6 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s7 = load ptr, ptr %s6, align 8, !tbaa !0
  %pos8 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos9 = load i32, ptr %pos8, align 4, !tbaa !4
  %5 = sext i32 %pos9 to i64
  %str.data = getelementptr inbounds %String, ptr %s7, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  store i32 %6, ptr %c, align 4
  %pos10 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos11 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos12 = load i32, ptr %pos11, align 4, !tbaa !4
  %7 = add i32 %pos12, 1
  store i32 %7, ptr %pos10, align 4, !tbaa !4
  %c13 = load i32, ptr %c, align 4
  %8 = icmp eq i32 %c13, 34
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  %sb43 = load ptr, ptr %sb, align 8
  %10 = call ptr @StringBuilder.toString(ptr %sb43)
  %strcpy44 = call ptr @__polaron_str_copy(ptr %10)
  call void @__polaron_str_free(ptr %10)
  ret ptr %strcpy44

if.then:                                          ; preds = %while.body
  %sb14 = load ptr, ptr %sb, align 8
  %11 = call ptr @StringBuilder.toString(ptr %sb14)
  %strcpy = call ptr @__polaron_str_copy(ptr %11)
  call void @__polaron_str_free(ptr %11)
  ret ptr %strcpy

if.end:                                           ; preds = %while.body
  %c15 = load i32, ptr %c, align 4
  %12 = icmp eq i32 %c15, 92
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then16, label %if.else

if.then16:                                        ; preds = %if.end
  %s18 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s19 = load ptr, ptr %s18, align 8, !tbaa !0
  %pos20 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos21 = load i32, ptr %pos20, align 4, !tbaa !4
  %14 = sext i32 %pos21 to i64
  %str.data22 = getelementptr inbounds %String, ptr %s19, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %ch.addr24 = getelementptr i8, ptr %data23, i64 %14
  %ch25 = load i8, ptr %ch.addr24, align 1
  %15 = zext i8 %ch25 to i32
  store i32 %15, ptr %e, align 4
  %pos26 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos27 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos28 = load i32, ptr %pos27, align 4, !tbaa !4
  %16 = add i32 %pos28, 1
  store i32 %16, ptr %pos26, align 4, !tbaa !4
  %e29 = load i32, ptr %e, align 4
  %17 = icmp eq i32 %e29, 110
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then30, label %if.else31

if.else:                                          ; preds = %if.end
  %sb41 = load ptr, ptr %sb, align 8
  %c42 = load i32, ptr %c, align 4
  %19 = call ptr @StringBuilder.appendChar(ptr %sb41, i32 %c42)
  br label %if.end17

if.end17:                                         ; preds = %if.else, %if.end32
  br label %while.cond

if.then30:                                        ; preds = %if.then16
  %sb33 = load ptr, ptr %sb, align 8
  %20 = call ptr @StringBuilder.appendChar(ptr %sb33, i32 10)
  br label %if.end32

if.else31:                                        ; preds = %if.then16
  %e34 = load i32, ptr %e, align 4
  %21 = icmp eq i32 %e34, 116
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then35, label %if.else36

if.end32:                                         ; preds = %if.end37, %if.then30
  br label %if.end17

if.then35:                                        ; preds = %if.else31
  %sb38 = load ptr, ptr %sb, align 8
  %23 = call ptr @StringBuilder.appendChar(ptr %sb38, i32 9)
  br label %if.end37

if.else36:                                        ; preds = %if.else31
  %sb39 = load ptr, ptr %sb, align 8
  %e40 = load i32, ptr %e, align 4
  %24 = call ptr @StringBuilder.appendChar(ptr %sb39, i32 %e40)
  br label %if.end37

if.end37:                                         ; preds = %if.else36, %if.then35
  br label %if.end32
}

define internal ptr @JsonParser.parseValue(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %d = alloca i32, align 4
  %more = alloca i32, align 4
  %acc = alloca i64, align 8
  %neg = alloca i32, align 4
  %c = alloca i32, align 4
  call void @JsonParser.skipWs(ptr %0)
  %s = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s1 = load ptr, ptr %s, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = sext i32 %pos2 to i64
  %str.data = getelementptr inbounds %String, ptr %s1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %1
  %ch = load i8, ptr %ch.addr, align 1
  %2 = zext i8 %ch to i32
  store i32 %2, ptr %c, align 4
  %c3 = load i32, ptr %c, align 4
  %3 = icmp eq i32 %c3, 123
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %5 = call ptr @JsonParser.parseObject(ptr %0)
  ret ptr %5

if.end:                                           ; preds = %entry
  %c4 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %c4, 91
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  %8 = call ptr @JsonParser.parseArray(ptr %0)
  ret ptr %8

if.end6:                                          ; preds = %if.end
  %c7 = load i32, ptr %c, align 4
  %9 = icmp eq i32 %c7, 34
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end6
  %11 = call ptr @JsonParser.parseString(ptr %0)
  %12 = call ptr @Json.ofStr(ptr %11)
  call void @__polaron_str_free(ptr %11)
  ret ptr %12

if.end9:                                          ; preds = %if.end6
  %c10 = load i32, ptr %c, align 4
  %13 = icmp eq i32 %c10, 116
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then11, label %if.end12

if.then11:                                        ; preds = %if.end9
  %pos13 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos14 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos15 = load i32, ptr %pos14, align 4, !tbaa !4
  %15 = add i32 %pos15, 4
  store i32 %15, ptr %pos13, align 4, !tbaa !4
  %16 = call ptr @Json.ofBool(i32 1)
  ret ptr %16

if.end12:                                         ; preds = %if.end9
  %c16 = load i32, ptr %c, align 4
  %17 = icmp eq i32 %c16, 102
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then17, label %if.end18

if.then17:                                        ; preds = %if.end12
  %pos19 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos20 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos21 = load i32, ptr %pos20, align 4, !tbaa !4
  %19 = add i32 %pos21, 5
  store i32 %19, ptr %pos19, align 4, !tbaa !4
  %20 = call ptr @Json.ofBool(i32 0)
  ret ptr %20

if.end18:                                         ; preds = %if.end12
  %c22 = load i32, ptr %c, align 4
  %21 = icmp eq i32 %c22, 110
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then23, label %if.end24

if.then23:                                        ; preds = %if.end18
  %pos25 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos26 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos27 = load i32, ptr %pos26, align 4, !tbaa !4
  %23 = add i32 %pos27, 4
  store i32 %23, ptr %pos25, align 4, !tbaa !4
  %24 = call ptr @Json.ofNull()
  ret ptr %24

if.end24:                                         ; preds = %if.end18
  store i32 0, ptr %neg, align 4
  %c28 = load i32, ptr %c, align 4
  %25 = icmp eq i32 %c28, 45
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then29, label %if.end30

if.then29:                                        ; preds = %if.end24
  store i32 1, ptr %neg, align 4
  %pos31 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos32 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos33 = load i32, ptr %pos32, align 4, !tbaa !4
  %27 = add i32 %pos33, 1
  store i32 %27, ptr %pos31, align 4, !tbaa !4
  br label %if.end30

if.end30:                                         ; preds = %if.then29, %if.end24
  store i64 0, ptr %acc, align 8
  store i32 1, ptr %more, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end55, %if.end30
  %more34 = load i32, ptr %more, align 4
  %sc.a = icmp ne i32 %more34, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %s39 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s40 = load ptr, ptr %s39, align 8, !tbaa !0
  %pos41 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos42 = load i32, ptr %pos41, align 4, !tbaa !4
  %28 = sext i32 %pos42 to i64
  %str.data43 = getelementptr inbounds %String, ptr %s40, i32 0, i32 1
  %data44 = load ptr, ptr %str.data43, align 8
  %ch.addr45 = getelementptr i8, ptr %data44, i64 %28
  %ch46 = load i8, ptr %ch.addr45, align 1
  %29 = zext i8 %ch46 to i32
  store i32 %29, ptr %d, align 4
  %d47 = load i32, ptr %d, align 4
  %30 = icmp sge i32 %d47, 48
  %31 = zext i1 %30 to i32
  %sc.a48 = icmp ne i32 %31, 0
  br i1 %sc.a48, label %sc.rhs49, label %sc.end50

while.end:                                        ; preds = %sc.end
  %neg61 = load i32, ptr %neg, align 4
  %32 = icmp ne i32 %neg61, 0
  br i1 %32, label %if.then62, label %if.end63

sc.rhs:                                           ; preds = %while.cond
  %pos35 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos36 = load i32, ptr %pos35, align 4, !tbaa !4
  %s37 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s38 = load ptr, ptr %s37, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %s38, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %33 = trunc i64 %len to i32
  %34 = icmp slt i32 %pos36, %33
  %35 = zext i1 %34 to i32
  %sc.b = icmp ne i32 %35, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %36 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

sc.rhs49:                                         ; preds = %while.body
  %d51 = load i32, ptr %d, align 4
  %37 = icmp sle i32 %d51, 57
  %38 = zext i1 %37 to i32
  %sc.b52 = icmp ne i32 %38, 0
  br label %sc.end50

sc.end50:                                         ; preds = %sc.rhs49, %while.body
  %sc53 = phi i1 [ false, %while.body ], [ %sc.b52, %sc.rhs49 ]
  %39 = zext i1 %sc53 to i32
  br i1 %sc53, label %if.then54, label %if.else

if.then54:                                        ; preds = %sc.end50
  %acc56 = load i64, ptr %acc, align 8
  %40 = mul i64 %acc56, 10
  %d57 = load i32, ptr %d, align 4
  %41 = sub i32 %d57, 48
  %42 = sext i32 %41 to i64
  %43 = add i64 %40, %42
  store i64 %43, ptr %acc, align 8
  %pos58 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos59 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos60 = load i32, ptr %pos59, align 4, !tbaa !4
  %44 = add i32 %pos60, 1
  store i32 %44, ptr %pos58, align 4, !tbaa !4
  br label %if.end55

if.else:                                          ; preds = %sc.end50
  store i32 0, ptr %more, align 4
  br label %if.end55

if.end55:                                         ; preds = %if.else, %if.then54
  br label %while.cond

if.then62:                                        ; preds = %while.end
  %acc64 = load i64, ptr %acc, align 8
  %45 = sub i64 0, %acc64
  store i64 %45, ptr %acc, align 8
  br label %if.end63

if.end63:                                         ; preds = %if.then62, %while.end
  %acc65 = load i64, ptr %acc, align 8
  %46 = call ptr @Json.ofNum(i64 %acc65)
  ret ptr %46
}

define internal ptr @JsonParser.parseArray(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %c = alloca i32, align 4
  %arr = alloca ptr, align 8
  %1 = call ptr @Json.array()
  store ptr %1, ptr %arr, align 8
  %pos = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos1 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos1, align 4, !tbaa !4
  %2 = add i32 %pos2, 1
  store i32 %2, ptr %pos, align 4, !tbaa !4
  call void @JsonParser.skipWs(ptr %0)
  %s = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s3 = load ptr, ptr %s, align 8, !tbaa !0
  %pos4 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %3 = sext i32 %pos5 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %3
  %ch = load i8, ptr %ch.addr, align 1
  %4 = zext i8 %ch to i32
  %5 = icmp eq i32 %4, 93
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %pos6 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos7 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos8 = load i32, ptr %pos7, align 4, !tbaa !4
  %7 = add i32 %pos8, 1
  store i32 %7, ptr %pos6, align 4, !tbaa !4
  %arr9 = load ptr, ptr %arr, align 8
  ret ptr %arr9

if.end:                                           ; preds = %entry
  br label %while.cond

while.cond:                                       ; preds = %if.end24, %if.end
  br i1 true, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %arr10 = load ptr, ptr %arr, align 8
  %8 = call ptr @JsonParser.parseValue(ptr %0)
  call void @Json.add(ptr %arr10, ptr %8)
  call void @JsonParser.skipWs(ptr %0)
  %s11 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s12 = load ptr, ptr %s11, align 8, !tbaa !0
  %pos13 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos14 = load i32, ptr %pos13, align 4, !tbaa !4
  %9 = sext i32 %pos14 to i64
  %str.data15 = getelementptr inbounds %String, ptr %s12, i32 0, i32 1
  %data16 = load ptr, ptr %str.data15, align 8
  %ch.addr17 = getelementptr i8, ptr %data16, i64 %9
  %ch18 = load i8, ptr %ch.addr17, align 1
  %10 = zext i8 %ch18 to i32
  store i32 %10, ptr %c, align 4
  %pos19 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos20 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos21 = load i32, ptr %pos20, align 4, !tbaa !4
  %11 = add i32 %pos21, 1
  store i32 %11, ptr %pos19, align 4, !tbaa !4
  %c22 = load i32, ptr %c, align 4
  %12 = icmp eq i32 %c22, 93
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then23, label %if.end24

while.end:                                        ; preds = %while.cond
  %arr26 = load ptr, ptr %arr, align 8
  ret ptr %arr26

if.then23:                                        ; preds = %while.body
  %arr25 = load ptr, ptr %arr, align 8
  ret ptr %arr25

if.end24:                                         ; preds = %while.body
  br label %while.cond
}

define internal ptr @JsonParser.parseObject(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %c = alloca i32, align 4
  %key = alloca ptr, align 8
  %obj = alloca ptr, align 8
  %1 = call ptr @Json.object()
  store ptr %1, ptr %obj, align 8
  %pos = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos1 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos1, align 4, !tbaa !4
  %2 = add i32 %pos2, 1
  store i32 %2, ptr %pos, align 4, !tbaa !4
  call void @JsonParser.skipWs(ptr %0)
  %s = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s3 = load ptr, ptr %s, align 8, !tbaa !0
  %pos4 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %3 = sext i32 %pos5 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %3
  %ch = load i8, ptr %ch.addr, align 1
  %4 = zext i8 %ch to i32
  %5 = icmp eq i32 %4, 125
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %pos6 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos7 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos8 = load i32, ptr %pos7, align 4, !tbaa !4
  %7 = add i32 %pos8, 1
  store i32 %7, ptr %pos6, align 4, !tbaa !4
  %obj9 = load ptr, ptr %obj, align 8
  ret ptr %obj9

if.end:                                           ; preds = %entry
  br label %while.cond

while.cond:                                       ; preds = %if.end28, %if.end
  br i1 true, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  call void @JsonParser.skipWs(ptr %0)
  %8 = call ptr @JsonParser.parseString(ptr %0)
  %strcpy = call ptr @__polaron_str_copy(ptr %8)
  store ptr %strcpy, ptr %key, align 8
  call void @__polaron_str_free(ptr %8)
  call void @JsonParser.skipWs(ptr %0)
  %pos10 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos11 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos12 = load i32, ptr %pos11, align 4, !tbaa !4
  %9 = add i32 %pos12, 1
  store i32 %9, ptr %pos10, align 4, !tbaa !4
  %obj13 = load ptr, ptr %obj, align 8
  %key14 = load ptr, ptr %key, align 8
  %10 = call ptr @JsonParser.parseValue(ptr %0)
  call void @Json.put(ptr %obj13, ptr %key14, ptr %10)
  call void @JsonParser.skipWs(ptr %0)
  %s15 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 1
  %s16 = load ptr, ptr %s15, align 8, !tbaa !0
  %pos17 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos18 = load i32, ptr %pos17, align 4, !tbaa !4
  %11 = sext i32 %pos18 to i64
  %str.data19 = getelementptr inbounds %String, ptr %s16, i32 0, i32 1
  %data20 = load ptr, ptr %str.data19, align 8
  %ch.addr21 = getelementptr i8, ptr %data20, i64 %11
  %ch22 = load i8, ptr %ch.addr21, align 1
  %12 = zext i8 %ch22 to i32
  store i32 %12, ptr %c, align 4
  %pos23 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos24 = getelementptr inbounds %class.JsonParser, ptr %0, i32 0, i32 2
  %pos25 = load i32, ptr %pos24, align 4, !tbaa !4
  %13 = add i32 %pos25, 1
  store i32 %13, ptr %pos23, align 4, !tbaa !4
  %c26 = load i32, ptr %c, align 4
  %14 = icmp eq i32 %c26, 125
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then27, label %if.end28

while.end:                                        ; preds = %while.cond
  %obj30 = load ptr, ptr %obj, align 8
  ret ptr %obj30

if.then27:                                        ; preds = %while.body
  %obj29 = load ptr, ptr %obj, align 8
  %16 = load ptr, ptr %key, align 8
  call void @__polaron_str_free(ptr %16)
  ret ptr %obj29

if.end28:                                         ; preds = %while.body
  %17 = load ptr, ptr %key, align 8
  call void @__polaron_str_free(ptr %17)
  br label %while.cond
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5335)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5337)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare i32 @strcmp(ptr, ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @__polaron_itoa(i64, ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
