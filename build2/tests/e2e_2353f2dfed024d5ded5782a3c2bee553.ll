; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_pointer.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_pointer.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }
%class.Json = type { ptr, i32, i32, i64, ptr, ptr, ptr, ptr, ptr, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@Json.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @Json.size, ptr null, ptr null, ptr null, ptr @Json.put, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Json.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Json.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Json.kindOf, ptr @Json.asBool, ptr @Json.asNum, ptr @Json.asStr, ptr @Json.at, ptr @Json.field, ptr @Json.escapeInto, ptr @Json.writeInto, ptr @Json.pad, ptr @Json.prettyInto, ptr @Json.prettyString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [5 x i8] c"nums\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [5 x i8] c"name\00"
@.strobj.2 = private global %String { i64 4, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [4 x i8] c"bob\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [5 x i8] c"user\00"
@.strobj.6 = private global %String { i64 4, ptr @.strdata.5, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.7 = private constant [8 x i8] c"/nums/1\00"
@.strobj.8 = private global %String { i64 7, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [11 x i8] c"/user/name\00"
@.strobj.10 = private global %String { i64 10, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [8 x i8] c"/nums/5\00"
@.strobj.12 = private global %String { i64 7, ptr @.strdata.11, i64 0 }
@.str.13 = private unnamed_addr constant [22 x i8] c"n1=%d name=%s oob=%d\0A\00", align 1
@.panic = private unnamed_addr constant [132 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_pointer.pol:28:41  in main\0A\00", align 1
@.panic.14 = private unnamed_addr constant [132 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/json_pointer.pol:28:41  in main\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1320 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1321 = private global %String { i64 16, ptr @.strdata.1320, i64 0 }
@.strdata.1322 = private constant [17 x i8] c"division by zero\00"
@.strobj.1323 = private global %String { i64 16, ptr @.strdata.1322, i64 0 }
@.strdata.3927 = private constant [1 x i8] zeroinitializer
@.strobj.3928 = private global %String { i64 0, ptr @.strdata.3927, i64 0 }
@.strdata.3929 = private constant [1 x i8] zeroinitializer
@.strobj.3930 = private global %String { i64 0, ptr @.strdata.3929, i64 0 }
@.panic.3931 = private unnamed_addr constant [81 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:7953:104  in Json.add\0A\00", align 1
@.panic.3932 = private unnamed_addr constant [79 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:7965:59  in Json.at\0A\00", align 1
@.panic.3933 = private unnamed_addr constant [82 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:7971:21  in Json.field\0A\00", align 1
@.panic.3934 = private unnamed_addr constant [82 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:7972:25  in Json.field\0A\00", align 1
@.strdata.3935 = private constant [5 x i8] c"null\00"
@.strobj.3936 = private global %String { i64 4, ptr @.strdata.3935, i64 0 }
@.strdata.3937 = private constant [5 x i8] c"true\00"
@.strobj.3938 = private global %String { i64 4, ptr @.strdata.3937, i64 0 }
@.strdata.3939 = private constant [6 x i8] c"false\00"
@.strobj.3940 = private global %String { i64 5, ptr @.strdata.3939, i64 0 }
@.panic.3941 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8003:38  in Json.writeInto\0A\00", align 1
@.panic.3942 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8004:29  in Json.writeInto\0A\00", align 1
@.panic.3943 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8015:36  in Json.writeInto\0A\00", align 1
@.panic.3944 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8017:32  in Json.writeInto\0A\00", align 1
@.panic.3945 = private unnamed_addr constant [86 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8018:23  in Json.writeInto\0A\00", align 1
@.strdata.3946 = private constant [5 x i8] c"null\00"
@.strobj.3947 = private global %String { i64 4, ptr @.strdata.3946, i64 0 }
@.strdata.3948 = private constant [5 x i8] c"true\00"
@.strobj.3949 = private global %String { i64 4, ptr @.strdata.3948, i64 0 }
@.strdata.3950 = private constant [6 x i8] c"false\00"
@.strobj.3951 = private global %String { i64 5, ptr @.strdata.3950, i64 0 }
@.strdata.3952 = private constant [3 x i8] c"[]\00"
@.strobj.3953 = private global %String { i64 2, ptr @.strdata.3952, i64 0 }
@.panic.3954 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8045:39  in Json.prettyInto\0A\00", align 1
@.panic.3955 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8046:29  in Json.prettyInto\0A\00", align 1
@.strdata.3956 = private constant [3 x i8] c"{}\00"
@.strobj.3957 = private global %String { i64 2, ptr @.strdata.3956, i64 0 }
@.panic.3958 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8059:36  in Json.prettyInto\0A\00", align 1
@.panic.3959 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8061:33  in Json.prettyInto\0A\00", align 1
@.panic.3960 = private unnamed_addr constant [87 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8062:23  in Json.prettyInto\0A\00", align 1
@.panic.3961 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8101:25  in JsonPointer.resolve\0A\00", align 1
@.panic.3962 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8102:43  in JsonPointer.resolve\0A\00", align 1
@.panic.3963 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8106:33  in JsonPointer.resolve\0A\00", align 1
@.panic.3964 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:8107:37  in JsonPointer.resolve\0A\00", align 1
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %isNull = alloca i32, align 4
  %oob = alloca ptr, align 8
  %name = alloca ptr, align 8
  %n1 = alloca ptr, align 8
  %user = alloca ptr, align 8
  %arr = alloca ptr, align 8
  %root = alloca ptr, align 8
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
  store ptr %16, ptr %root, align 8
  %17 = call ptr @Json.array()
  store ptr %17, ptr %arr, align 8
  %arr1 = load ptr, ptr %arr, align 8
  %18 = call ptr @Json.ofNum(i64 10)
  call void @Json.add(ptr %arr1, ptr %18)
  %arr2 = load ptr, ptr %arr, align 8
  %19 = call ptr @Json.ofNum(i64 20)
  call void @Json.add(ptr %arr2, ptr %19)
  %root3 = load ptr, ptr %root, align 8
  %arr4 = load ptr, ptr %arr, align 8
  call void @Json.put(ptr %root3, ptr @.strobj, ptr %arr4)
  %20 = call ptr @Json.object()
  store ptr %20, ptr %user, align 8
  %user5 = load ptr, ptr %user, align 8
  %21 = call ptr @Json.ofStr(ptr @.strobj.4)
  call void @Json.put(ptr %user5, ptr @.strobj.2, ptr %21)
  %root6 = load ptr, ptr %root, align 8
  %user7 = load ptr, ptr %user, align 8
  call void @Json.put(ptr %root6, ptr @.strobj.6, ptr %user7)
  %root8 = load ptr, ptr %root, align 8
  %22 = call ptr @Json.prettyString(ptr %root8)
  %str.data = getelementptr inbounds %String, ptr %22, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %23 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %22)
  %root9 = load ptr, ptr %root, align 8
  %24 = call ptr @JsonPointer.resolve(ptr %root9, ptr @.strobj.8)
  store ptr %24, ptr %n1, align 8
  %root10 = load ptr, ptr %root, align 8
  %25 = call ptr @JsonPointer.resolve(ptr %root10, ptr @.strobj.10)
  store ptr %25, ptr %name, align 8
  %root11 = load ptr, ptr %root, align 8
  %26 = call ptr @JsonPointer.resolve(ptr %root11, ptr @.strobj.12)
  store ptr %26, ptr %oob, align 8
  %oob12 = load ptr, ptr %oob, align 8
  %27 = icmp eq ptr %oob12, null
  %28 = zext i1 %27 to i32
  store i32 %28, ptr %isNull, align 4
  %n113 = load ptr, ptr %n1, align 8
  %29 = icmp eq ptr %n113, null
  br i1 %29, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %argv.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %argv.end
  %30 = call i64 @Json.asNum(ptr %n113)
  %31 = trunc i64 %30 to i32
  %name14 = load ptr, ptr %name, align 8
  %32 = icmp eq ptr %name14, null
  br i1 %32, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.14)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok
  %33 = call ptr @Json.asStr(ptr %name14)
  %str.data17 = getelementptr inbounds %String, ptr %33, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %isNull19 = load i32, ptr %isNull, align 4
  %34 = call i32 (ptr, ...) @printf(ptr @.str.13, i32 %31, ptr %data18, i32 %isNull19)
  call void @__polaron_str_free(ptr %33)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1321)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1323)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.3928)
  %2 = load ptr, ptr %str2, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %str2, align 8, !tbaa !0
  %memberKey3 = getelementptr inbounds %class.Json, ptr %0, i32 0, i32 5
  %strcpy4 = call ptr @__polaron_str_copy(ptr @.strobj.3930)
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
  call void @__polaron_panic(ptr @.panic.3931)
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
  call void @__polaron_panic(ptr @.panic.3932)
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
  call void @__polaron_panic(ptr @.panic.3933)
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
  call void @__polaron_panic(ptr @.panic.3934)
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
  %4 = call ptr @StringBuilder.append(ptr %sb2, ptr @.strobj.3936)
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
  %10 = call ptr @StringBuilder.append(ptr %sb10, ptr @.strobj.3938)
  br label %if.end9

if.else:                                          ; preds = %if.then5
  %sb11 = load ptr, ptr %sb, align 8
  %11 = call ptr @StringBuilder.append(ptr %sb11, ptr @.strobj.3940)
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
  call void @__polaron_panic(ptr @.panic.3941)
  unreachable

nullrecv.ok:                                      ; preds = %if.end33
  %sb36 = load ptr, ptr %sb, align 8
  call void @Json.writeInto(ptr %cur35, ptr %sb36)
  %cur37 = load ptr, ptr %cur, align 8
  %30 = icmp eq ptr %cur37, null
  br i1 %30, label %nullrecv38, label %nullrecv.ok39

nullrecv38:                                       ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.3942)
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
  call void @__polaron_panic(ptr @.panic.3943)
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
  call void @__polaron_panic(ptr @.panic.3944)
  unreachable

nullrecv.ok61:                                    ; preds = %nullrecv.ok56
  %sb62 = load ptr, ptr %sb, align 8
  call void @Json.writeInto(ptr %m59, ptr %sb62)
  %m63 = load ptr, ptr %m, align 8
  %40 = icmp eq ptr %m63, null
  br i1 %40, label %nullrecv64, label %nullrecv.ok65

nullrecv64:                                       ; preds = %nullrecv.ok61
  call void @__polaron_panic(ptr @.panic.3945)
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
  %5 = call ptr @StringBuilder.append(ptr %sb2, ptr @.strobj.3947)
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
  %11 = call ptr @StringBuilder.append(ptr %sb10, ptr @.strobj.3949)
  br label %if.end9

if.else:                                          ; preds = %if.then5
  %sb11 = load ptr, ptr %sb, align 8
  %12 = call ptr @StringBuilder.append(ptr %sb11, ptr @.strobj.3951)
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
  %26 = call ptr @StringBuilder.append(ptr %sb31, ptr @.strobj.3953)
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
  call void @__polaron_panic(ptr @.panic.3954)
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
  call void @__polaron_panic(ptr @.panic.3955)
  unreachable

nullrecv.ok48:                                    ; preds = %nullrecv.ok
  %nextSibling = getelementptr inbounds %class.Json, ptr %cur46, i32 0, i32 8
  %nextSibling49 = load ptr, ptr %nextSibling, align 8, !tbaa !0
  store ptr %nextSibling49, ptr %cur, align 8
  br label %while.cond

if.then56:                                        ; preds = %if.end27
  %sb58 = load ptr, ptr %sb, align 8
  %41 = call ptr @StringBuilder.append(ptr %sb58, ptr @.strobj.3957)
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
  call void @__polaron_panic(ptr @.panic.3958)
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
  call void @__polaron_panic(ptr @.panic.3959)
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
  call void @__polaron_panic(ptr @.panic.3960)
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

define internal i32 @JsonPointer.parseIndex(ptr %0) {
entry:
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %v = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 -1

if.end:                                           ; preds = %entry
  store i32 0, ptr %v, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i2 = load i32, ptr %i, align 4
  %s3 = load ptr, ptr %s, align 8
  %str.len4 = getelementptr inbounds %String, ptr %s3, i32 0, i32 0
  %len5 = load i64, ptr %str.len4, align 8
  %4 = trunc i64 %len5 to i32
  %5 = icmp slt i32 %i2, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s6 = load ptr, ptr %s, align 8
  %i7 = load i32, ptr %i, align 4
  %7 = sext i32 %i7 to i64
  %str.data = getelementptr inbounds %String, ptr %s6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %7
  %ch = load i8, ptr %ch.addr, align 1
  %8 = zext i8 %ch to i32
  store i32 %8, ptr %c, align 4
  %c8 = load i32, ptr %c, align 4
  %9 = icmp slt i32 %c8, 48
  %10 = zext i1 %9 to i32
  %sc.a = icmp ne i32 %10, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

for.update:                                       ; preds = %if.end11
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %v14 = load i32, ptr %v, align 4
  ret i32 %v14

sc.rhs:                                           ; preds = %for.body
  %c9 = load i32, ptr %c, align 4
  %13 = icmp sgt i32 %c9, 57
  %14 = zext i1 %13 to i32
  %sc.b = icmp ne i32 %14, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %for.body
  %sc = phi i1 [ true, %for.body ], [ %sc.b, %sc.rhs ]
  %15 = zext i1 %sc to i32
  br i1 %sc, label %if.then10, label %if.end11

if.then10:                                        ; preds = %sc.end
  ret i32 -1

if.end11:                                         ; preds = %sc.end
  %v12 = load i32, ptr %v, align 4
  %16 = mul i32 %v12, 10
  %c13 = load i32, ptr %c, align 4
  %17 = sub i32 %c13, 48
  %18 = add i32 %16, %17
  store i32 %18, ptr %v, align 4
  br label %for.update
}

define internal ptr @JsonPointer.resolve(ptr %0, ptr %1) {
entry:
  %idx = alloca i32, align 4
  %k = alloca i32, align 4
  %t = alloca ptr, align 8
  %atEnd = alloca i32, align 4
  %tok = alloca ptr, align 8
  %i = alloca i32, align 4
  %cur = alloca ptr, align 8
  %ptr = alloca ptr, align 8
  %root = alloca ptr, align 8
  store ptr %0, ptr %root, align 8
  store ptr %1, ptr %ptr, align 8
  %root1 = load ptr, ptr %root, align 8
  store ptr %root1, ptr %cur, align 8
  %ptr2 = load ptr, ptr %ptr, align 8
  %str.len = getelementptr inbounds %String, ptr %ptr2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp eq i32 %2, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %cur3 = load ptr, ptr %cur, align 8
  ret ptr %cur3

if.end:                                           ; preds = %entry
  store i32 0, ptr %i, align 4
  %ptr4 = load ptr, ptr %ptr, align 8
  %str.data = getelementptr inbounds %String, ptr %ptr4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 0
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = icmp eq i32 %5, 47
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  store i32 1, ptr %i, align 4
  br label %if.end6

if.end6:                                          ; preds = %if.then5, %if.end
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %tok, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end23, %if.end6
  %i7 = load i32, ptr %i, align 4
  %ptr8 = load ptr, ptr %ptr, align 8
  %str.len9 = getelementptr inbounds %String, ptr %ptr8, i32 0, i32 0
  %len10 = load i64, ptr %str.len9, align 8
  %8 = trunc i64 %len10 to i32
  %9 = icmp sle i32 %i7, %8
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i11 = load i32, ptr %i, align 4
  %ptr12 = load ptr, ptr %ptr, align 8
  %str.len13 = getelementptr inbounds %String, ptr %ptr12, i32 0, i32 0
  %len14 = load i64, ptr %str.len13, align 8
  %11 = trunc i64 %len14 to i32
  %12 = icmp eq i32 %i11, %11
  %13 = zext i1 %12 to i32
  store i32 %13, ptr %atEnd, align 4
  %atEnd15 = load i32, ptr %atEnd, align 4
  %sc.a = icmp ne i32 %atEnd15, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

while.end:                                        ; preds = %while.cond
  %cur67 = load ptr, ptr %cur, align 8
  ret ptr %cur67

sc.rhs:                                           ; preds = %while.body
  %ptr16 = load ptr, ptr %ptr, align 8
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %str.data18 = getelementptr inbounds %String, ptr %ptr16, i32 0, i32 1
  %data19 = load ptr, ptr %str.data18, align 8
  %ch.addr20 = getelementptr i8, ptr %data19, i64 %14
  %ch21 = load i8, ptr %ch.addr20, align 1
  %15 = zext i8 %ch21 to i32
  %16 = icmp eq i32 %15, 47
  %17 = zext i1 %16 to i32
  %sc.b = icmp ne i32 %17, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.body
  %sc = phi i1 [ true, %while.body ], [ %sc.b, %sc.rhs ]
  %18 = zext i1 %sc to i32
  br i1 %sc, label %if.then22, label %if.else

if.then22:                                        ; preds = %sc.end
  %tok24 = load ptr, ptr %tok, align 8
  %19 = call ptr @StringBuilder.toString(ptr %tok24)
  %strcpy = call ptr @__polaron_str_copy(ptr %19)
  store ptr %strcpy, ptr %t, align 8
  call void @__polaron_str_free(ptr %19)
  %cur25 = load ptr, ptr %cur, align 8
  %20 = icmp eq ptr %cur25, null
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then26, label %if.end27

if.else:                                          ; preds = %sc.end
  %tok59 = load ptr, ptr %tok, align 8
  %ptr60 = load ptr, ptr %ptr, align 8
  %i61 = load i32, ptr %i, align 4
  %22 = sext i32 %i61 to i64
  %str.data62 = getelementptr inbounds %String, ptr %ptr60, i32 0, i32 1
  %data63 = load ptr, ptr %str.data62, align 8
  %ch.addr64 = getelementptr i8, ptr %data63, i64 %22
  %ch65 = load i8, ptr %ch.addr64, align 1
  %23 = zext i8 %ch65 to i32
  %24 = call ptr @StringBuilder.appendChar(ptr %tok59, i32 %23)
  br label %if.end23

if.end23:                                         ; preds = %if.else, %if.end32
  %i66 = load i32, ptr %i, align 4
  %25 = add i32 %i66, 1
  store i32 %25, ptr %i, align 4
  br label %while.cond

if.then26:                                        ; preds = %if.then22
  %26 = load ptr, ptr %t, align 8
  call void @__polaron_str_free(ptr %26)
  ret ptr null

if.end27:                                         ; preds = %if.then22
  %cur28 = load ptr, ptr %cur, align 8
  %27 = icmp eq ptr %cur28, null
  br i1 %27, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end27
  call void @__polaron_panic(ptr @.panic.3961)
  unreachable

nullrecv.ok:                                      ; preds = %if.end27
  %28 = call i32 @Json.kindOf(ptr %cur28)
  store i32 %28, ptr %k, align 4
  %k29 = load i32, ptr %k, align 4
  %29 = icmp eq i32 %k29, 5
  %30 = zext i1 %29 to i32
  br i1 %29, label %if.then30, label %if.else31

if.then30:                                        ; preds = %nullrecv.ok
  %cur33 = load ptr, ptr %cur, align 8
  %31 = icmp eq ptr %cur33, null
  br i1 %31, label %nullrecv34, label %nullrecv.ok35

if.else31:                                        ; preds = %nullrecv.ok
  %k37 = load i32, ptr %k, align 4
  %32 = icmp eq i32 %k37, 4
  %33 = zext i1 %32 to i32
  br i1 %32, label %if.then38, label %if.else39

if.end32:                                         ; preds = %if.end40, %nullrecv.ok35
  %StringBuilder.obj58 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj58)
  store ptr %StringBuilder.obj58, ptr %tok, align 8
  %34 = load ptr, ptr %t, align 8
  call void @__polaron_str_free(ptr %34)
  br label %if.end23

nullrecv34:                                       ; preds = %if.then30
  call void @__polaron_panic(ptr @.panic.3962)
  unreachable

nullrecv.ok35:                                    ; preds = %if.then30
  %t36 = load ptr, ptr %t, align 8
  %35 = call ptr @Json.field(ptr %cur33, ptr %t36)
  store ptr %35, ptr %cur, align 8
  br label %if.end32

if.then38:                                        ; preds = %if.else31
  %t41 = load ptr, ptr %t, align 8
  %36 = call i32 @JsonPointer.parseIndex(ptr %t41)
  store i32 %36, ptr %idx, align 4
  %idx42 = load i32, ptr %idx, align 4
  %37 = icmp slt i32 %idx42, 0
  %38 = zext i1 %37 to i32
  %sc.a43 = icmp ne i32 %38, 0
  br i1 %sc.a43, label %sc.end45, label %sc.rhs44

if.else39:                                        ; preds = %if.else31
  %39 = load ptr, ptr %t, align 8
  call void @__polaron_str_free(ptr %39)
  ret ptr null

if.end40:                                         ; preds = %nullrecv.ok56
  br label %if.end32

sc.rhs44:                                         ; preds = %if.then38
  %idx46 = load i32, ptr %idx, align 4
  %cur47 = load ptr, ptr %cur, align 8
  %40 = icmp eq ptr %cur47, null
  br i1 %40, label %nullrecv48, label %nullrecv.ok49

sc.end45:                                         ; preds = %nullrecv.ok49, %if.then38
  %sc51 = phi i1 [ true, %if.then38 ], [ %sc.b50, %nullrecv.ok49 ]
  %41 = zext i1 %sc51 to i32
  br i1 %sc51, label %if.then52, label %if.end53

nullrecv48:                                       ; preds = %sc.rhs44
  call void @__polaron_panic(ptr @.panic.3963)
  unreachable

nullrecv.ok49:                                    ; preds = %sc.rhs44
  %42 = call i32 @Json.size(ptr %cur47)
  %43 = icmp sge i32 %idx46, %42
  %44 = zext i1 %43 to i32
  %sc.b50 = icmp ne i32 %44, 0
  br label %sc.end45

if.then52:                                        ; preds = %sc.end45
  %45 = load ptr, ptr %t, align 8
  call void @__polaron_str_free(ptr %45)
  ret ptr null

if.end53:                                         ; preds = %sc.end45
  %cur54 = load ptr, ptr %cur, align 8
  %46 = icmp eq ptr %cur54, null
  br i1 %46, label %nullrecv55, label %nullrecv.ok56

nullrecv55:                                       ; preds = %if.end53
  call void @__polaron_panic(ptr @.panic.3964)
  unreachable

nullrecv.ok56:                                    ; preds = %if.end53
  %idx57 = load i32, ptr %idx, align 4
  %47 = call ptr @Json.at(ptr %cur54, i32 %idx57)
  store ptr %47, ptr %cur, align 8
  br label %if.end40
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5323)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5325)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare ptr @__polaron_str_copy(ptr)

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
