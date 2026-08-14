; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/http_parse.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/http_parse.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.HttpResponse = type { ptr, ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@HttpResponse.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @HttpResponse.raw, ptr @HttpResponse.status, ptr @HttpResponse.body, ptr @HttpResponse.header, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [70 x i8] c"HTTP/1.1 200 OK\0D\0AContent-Type: text/plain\0D\0AContent-Length: 5\0D\0A\0D\0Ahello\00"
@.strobj = private global %String { i64 69, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c"GET\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [12 x i8] c"example.com\00"
@.strobj.4 = private global %String { i64 11, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [7 x i8] c"/index\00"
@.strobj.6 = private global %String { i64 6, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [20 x i8] c"GET /index HTTP/1.1\00"
@.strobj.8 = private global %String { i64 19, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [18 x i8] c"Host: example.com\00"
@.strobj.10 = private global %String { i64 17, ptr @.strdata.9, i64 0 }
@.str = private unnamed_addr constant [47 x i8] c"status=%d body=%s ctype=%s reqOk=%d hostOk=%d\0A\00", align 1
@.strdata.11 = private constant [13 x i8] c"Content-Type\00"
@.strobj.12 = private global %String { i64 12, ptr @.strdata.11, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1318 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1319 = private global %String { i64 16, ptr @.strdata.1318, i64 0 }
@.strdata.1320 = private constant [17 x i8] c"division by zero\00"
@.strobj.1321 = private global %String { i64 16, ptr @.strdata.1320, i64 0 }
@.strdata.3900 = private constant [2 x i8] c" \00"
@.strobj.3901 = private global %String { i64 1, ptr @.strdata.3900, i64 0 }
@.strdata.3902 = private constant [5 x i8] c"\0D\0A\0D\0A\00"
@.strobj.3903 = private global %String { i64 4, ptr @.strdata.3902, i64 0 }
@.strdata.3904 = private constant [1 x i8] zeroinitializer
@.strobj.3905 = private global %String { i64 0, ptr @.strdata.3904, i64 0 }
@.strdata.3906 = private constant [3 x i8] c": \00"
@.strobj.3907 = private global %String { i64 2, ptr @.strdata.3906, i64 0 }
@.strdata.3908 = private constant [1 x i8] zeroinitializer
@.strobj.3909 = private global %String { i64 0, ptr @.strdata.3908, i64 0 }
@.strdata.3910 = private constant [2 x i8] c" \00"
@.strobj.3911 = private global %String { i64 1, ptr @.strdata.3910, i64 0 }
@.strdata.3912 = private constant [18 x i8] c" HTTP/1.1\0D\0AHost: \00"
@.strobj.3913 = private global %String { i64 17, ptr @.strdata.3912, i64 0 }
@.strdata.3914 = private constant [24 x i8] c"\0D\0AConnection: close\0D\0A\0D\0A\00"
@.strobj.3915 = private global %String { i64 23, ptr @.strdata.3914, i64 0 }
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %hostOk = alloca i32, align 4
  %reqOk = alloca i32, align 4
  %req = alloca ptr, align 8
  %r = alloca ptr, align 8
  %raw = alloca ptr, align 8
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %raw, align 8
  %HttpResponse.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.HttpResponse, ptr null, i64 1) to i64))
  %raw1 = load ptr, ptr %raw, align 8
  call void @HttpResponse.HttpResponse(ptr %HttpResponse.obj, ptr %raw1)
  store ptr %HttpResponse.obj, ptr %r, align 8
  %16 = call ptr @Http.buildRequest(ptr @.strobj.2, ptr @.strobj.4, ptr @.strobj.6)
  %strcpy2 = call ptr @__polaron_str_copy(ptr %16)
  store ptr %strcpy2, ptr %req, align 8
  call void @__polaron_str_free(ptr %16)
  store i32 0, ptr %reqOk, align 4
  %req3 = load ptr, ptr %req, align 8
  %str.data = getelementptr inbounds %String, ptr %req3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %req3, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %data4 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.8, i32 0, i32 1), align 8
  %len5 = load i64, ptr @.strobj.8, align 8
  %17 = call i64 @__polaron_str_index(ptr %data, i64 %len, ptr %data4, i64 %len5)
  %18 = trunc i64 %17 to i32
  %19 = icmp sge i32 %18, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  store i32 1, ptr %reqOk, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %argv.end
  store i32 0, ptr %hostOk, align 4
  %req6 = load ptr, ptr %req, align 8
  %str.data7 = getelementptr inbounds %String, ptr %req6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %str.len9 = getelementptr inbounds %String, ptr %req6, i32 0, i32 0
  %len10 = load i64, ptr %str.len9, align 8
  %data11 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.10, i32 0, i32 1), align 8
  %len12 = load i64, ptr @.strobj.10, align 8
  %21 = call i64 @__polaron_str_index(ptr %data8, i64 %len10, ptr %data11, i64 %len12)
  %22 = trunc i64 %21 to i32
  %23 = icmp sge i32 %22, 0
  %24 = zext i1 %23 to i32
  br i1 %23, label %if.then13, label %if.end14

if.then13:                                        ; preds = %if.end
  store i32 1, ptr %hostOk, align 4
  br label %if.end14

if.end14:                                         ; preds = %if.then13, %if.end
  %r15 = load ptr, ptr %r, align 8
  %25 = call i32 @HttpResponse.status(ptr %r15)
  %r16 = load ptr, ptr %r, align 8
  %26 = call ptr @HttpResponse.body(ptr %r16)
  %str.data17 = getelementptr inbounds %String, ptr %26, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %r19 = load ptr, ptr %r, align 8
  %27 = call ptr @HttpResponse.header(ptr %r19, ptr @.strobj.12)
  %str.data20 = getelementptr inbounds %String, ptr %27, i32 0, i32 1
  %data21 = load ptr, ptr %str.data20, align 8
  %reqOk22 = load i32, ptr %reqOk, align 4
  %hostOk23 = load i32, ptr %hostOk, align 4
  %28 = call i32 (ptr, ...) @printf(ptr @.str, i32 %25, ptr %data18, ptr %data21, i32 %reqOk22, i32 %hostOk23)
  call void @__polaron_str_free(ptr %26)
  call void @__polaron_str_free(ptr %27)
  %29 = load ptr, ptr %req, align 8
  call void @__polaron_str_free(ptr %29)
  %30 = load ptr, ptr %raw, align 8
  call void @__polaron_str_free(ptr %30)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1319)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1321)
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

define internal void @HttpResponse.HttpResponse(ptr %0, ptr %1) {
entry:
  %raw = alloca ptr, align 8
  store ptr %1, ptr %raw, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 0
  store ptr @HttpResponse.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %raw1 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  store ptr null, ptr %raw1, align 8, !tbaa !0
  %raw2 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw3 = load ptr, ptr %raw, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %raw3)
  %2 = load ptr, ptr %raw2, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %raw2, align 8, !tbaa !0
  ret void
}

define internal ptr @HttpResponse.raw(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %raw = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw1 = load ptr, ptr %raw, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %raw1)
  ret ptr %strcpy
}

define internal i32 @HttpResponse.status(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %sp = alloca i32, align 4
  %raw = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw1 = load ptr, ptr %raw, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %raw1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %raw1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.3901, i32 0, i32 1), align 8
  %len3 = load i64, ptr @.strobj.3901, align 8
  %1 = call i64 @__polaron_str_index(ptr %data, i64 %len, ptr %data2, i64 %len3)
  %2 = trunc i64 %1 to i32
  store i32 %2, ptr %sp, align 4
  %sp4 = load i32, ptr %sp, align 4
  %3 = icmp slt i32 %sp4, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  store i32 0, ptr %n, align 4
  %sp5 = load i32, ptr %sp, align 4
  %5 = add i32 %sp5, 1
  store i32 %5, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %i6 = load i32, ptr %i, align 4
  %raw7 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw8 = load ptr, ptr %raw7, align 8, !tbaa !0
  %str.len9 = getelementptr inbounds %String, ptr %raw8, i32 0, i32 0
  %len10 = load i64, ptr %str.len9, align 8
  %6 = trunc i64 %len10 to i32
  %7 = icmp slt i32 %i6, %6
  %8 = zext i1 %7 to i32
  %sc.a = icmp ne i32 %8, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end18
  %n28 = load i32, ptr %n, align 4
  %9 = mul i32 %n28, 10
  %raw29 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw30 = load ptr, ptr %raw29, align 8, !tbaa !0
  %i31 = load i32, ptr %i, align 4
  %10 = sext i32 %i31 to i64
  %str.data32 = getelementptr inbounds %String, ptr %raw30, i32 0, i32 1
  %data33 = load ptr, ptr %str.data32, align 8
  %ch.addr34 = getelementptr i8, ptr %data33, i64 %10
  %ch35 = load i8, ptr %ch.addr34, align 1
  %11 = zext i8 %ch35 to i32
  %12 = sub i32 %11, 48
  %13 = add i32 %9, %12
  store i32 %13, ptr %n, align 4
  %i36 = load i32, ptr %i, align 4
  %14 = add i32 %i36, 1
  store i32 %14, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end18
  %n37 = load i32, ptr %n, align 4
  ret i32 %n37

sc.rhs:                                           ; preds = %while.cond
  %raw11 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw12 = load ptr, ptr %raw11, align 8, !tbaa !0
  %i13 = load i32, ptr %i, align 4
  %15 = sext i32 %i13 to i64
  %str.data14 = getelementptr inbounds %String, ptr %raw12, i32 0, i32 1
  %data15 = load ptr, ptr %str.data14, align 8
  %ch.addr = getelementptr i8, ptr %data15, i64 %15
  %ch = load i8, ptr %ch.addr, align 1
  %16 = zext i8 %ch to i32
  %17 = icmp sge i32 %16, 48
  %18 = zext i1 %17 to i32
  %sc.b = icmp ne i32 %18, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %19 = zext i1 %sc to i32
  %sc.a16 = icmp ne i32 %19, 0
  br i1 %sc.a16, label %sc.rhs17, label %sc.end18

sc.rhs17:                                         ; preds = %sc.end
  %raw19 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw20 = load ptr, ptr %raw19, align 8, !tbaa !0
  %i21 = load i32, ptr %i, align 4
  %20 = sext i32 %i21 to i64
  %str.data22 = getelementptr inbounds %String, ptr %raw20, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %ch.addr24 = getelementptr i8, ptr %data23, i64 %20
  %ch25 = load i8, ptr %ch.addr24, align 1
  %21 = zext i8 %ch25 to i32
  %22 = icmp sle i32 %21, 57
  %23 = zext i1 %22 to i32
  %sc.b26 = icmp ne i32 %23, 0
  br label %sc.end18

sc.end18:                                         ; preds = %sc.rhs17, %sc.end
  %sc27 = phi i1 [ false, %sc.end ], [ %sc.b26, %sc.rhs17 ]
  %24 = zext i1 %sc27 to i32
  br i1 %sc27, label %while.body, label %while.end
}

define internal ptr @HttpResponse.body(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %idx = alloca i32, align 4
  %raw = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw1 = load ptr, ptr %raw, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %raw1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %raw1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.3903, i32 0, i32 1), align 8
  %len3 = load i64, ptr @.strobj.3903, align 8
  %1 = call i64 @__polaron_str_index(ptr %data, i64 %len, ptr %data2, i64 %len3)
  %2 = trunc i64 %1 to i32
  store i32 %2, ptr %idx, align 4
  %idx4 = load i32, ptr %idx, align 4
  %3 = icmp slt i32 %idx4, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.3905)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %raw5 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw6 = load ptr, ptr %raw5, align 8, !tbaa !0
  %idx7 = load i32, ptr %idx, align 4
  %5 = add i32 %idx7, 4
  %6 = sext i32 %5 to i64
  %raw8 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw9 = load ptr, ptr %raw8, align 8, !tbaa !0
  %str.len10 = getelementptr inbounds %String, ptr %raw9, i32 0, i32 0
  %len11 = load i64, ptr %str.len10, align 8
  %7 = trunc i64 %len11 to i32
  %8 = sext i32 %7 to i64
  %9 = sub i64 %8, %6
  %10 = add i64 %9, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %10)
  %str.data12 = getelementptr inbounds %String, ptr %raw6, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %11 = getelementptr i8, ptr %data13, i64 %6
  %12 = call ptr @memcpy(ptr %sub.buf, ptr %11, i64 %9)
  %13 = getelementptr i8, ptr %sub.buf, i64 %9
  store i8 0, ptr %13, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %9, ptr %14, align 8
  %15 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %15, align 8
  %16 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %16, align 8
  %strcpy14 = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy14
}

define internal ptr @HttpResponse.header(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %end = alloca i32, align 4
  %start = alloca i32, align 4
  %idx = alloca i32, align 4
  %key = alloca ptr, align 8
  %name = alloca ptr, align 8
  store ptr %1, ptr %name, align 8
  %name1 = load ptr, ptr %name, align 8
  %str.len = getelementptr inbounds %String, ptr %name1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len2 = load i64, ptr @.strobj.3907, align 8
  %2 = add i64 %len, %len2
  %3 = add i64 %2, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %3)
  %str.data = getelementptr inbounds %String, ptr %name1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %4 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data3 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.3907, i32 0, i32 1), align 8
  %5 = getelementptr i8, ptr %cat.buf, i64 %len
  %6 = call ptr @memcpy(ptr %5, ptr %data3, i64 %len2)
  %7 = getelementptr i8, ptr %cat.buf, i64 %2
  store i8 0, ptr %7, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %2, ptr %8, align 8
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %9, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %10, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy, ptr %key, align 8
  call void @__polaron_str_free(ptr %newstr)
  %raw = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw4 = load ptr, ptr %raw, align 8, !tbaa !0
  %key5 = load ptr, ptr %key, align 8
  %str.data6 = getelementptr inbounds %String, ptr %raw4, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %str.len8 = getelementptr inbounds %String, ptr %raw4, i32 0, i32 0
  %len9 = load i64, ptr %str.len8, align 8
  %str.data10 = getelementptr inbounds %String, ptr %key5, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %str.len12 = getelementptr inbounds %String, ptr %key5, i32 0, i32 0
  %len13 = load i64, ptr %str.len12, align 8
  %11 = call i64 @__polaron_str_index(ptr %data7, i64 %len9, ptr %data11, i64 %len13)
  %12 = trunc i64 %11 to i32
  store i32 %12, ptr %idx, align 4
  %idx14 = load i32, ptr %idx, align 4
  %13 = icmp slt i32 %idx14, 0
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %strcpy15 = call ptr @__polaron_str_copy(ptr @.strobj.3909)
  %15 = load ptr, ptr %key, align 8
  call void @__polaron_str_free(ptr %15)
  ret ptr %strcpy15

if.end:                                           ; preds = %entry
  %idx16 = load i32, ptr %idx, align 4
  %key17 = load ptr, ptr %key, align 8
  %str.len18 = getelementptr inbounds %String, ptr %key17, i32 0, i32 0
  %len19 = load i64, ptr %str.len18, align 8
  %16 = trunc i64 %len19 to i32
  %17 = add i32 %idx16, %16
  store i32 %17, ptr %start, align 4
  %start20 = load i32, ptr %start, align 4
  store i32 %start20, ptr %end, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %end21 = load i32, ptr %end, align 4
  %raw22 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw23 = load ptr, ptr %raw22, align 8, !tbaa !0
  %str.len24 = getelementptr inbounds %String, ptr %raw23, i32 0, i32 0
  %len25 = load i64, ptr %str.len24, align 8
  %18 = trunc i64 %len25 to i32
  %19 = icmp slt i32 %end21, %18
  %20 = zext i1 %19 to i32
  %sc.a = icmp ne i32 %20, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %end31 = load i32, ptr %end, align 4
  %21 = add i32 %end31, 1
  store i32 %21, ptr %end, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %raw32 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw33 = load ptr, ptr %raw32, align 8, !tbaa !0
  %start34 = load i32, ptr %start, align 4
  %22 = sext i32 %start34 to i64
  %end35 = load i32, ptr %end, align 4
  %23 = sext i32 %end35 to i64
  %24 = sub i64 %23, %22
  %25 = add i64 %24, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %25)
  %str.data36 = getelementptr inbounds %String, ptr %raw33, i32 0, i32 1
  %data37 = load ptr, ptr %str.data36, align 8
  %26 = getelementptr i8, ptr %data37, i64 %22
  %27 = call ptr @memcpy(ptr %sub.buf, ptr %26, i64 %24)
  %28 = getelementptr i8, ptr %sub.buf, i64 %24
  store i8 0, ptr %28, align 1
  %newstr38 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %29 = getelementptr inbounds %String, ptr %newstr38, i32 0, i32 0
  store i64 %24, ptr %29, align 8
  %30 = getelementptr inbounds %String, ptr %newstr38, i32 0, i32 1
  store ptr %sub.buf, ptr %30, align 8
  %31 = getelementptr inbounds %String, ptr %newstr38, i32 0, i32 2
  store i64 0, ptr %31, align 8
  %strcpy39 = call ptr @__polaron_str_copy(ptr %newstr38)
  call void @__polaron_str_free(ptr %newstr38)
  %32 = load ptr, ptr %key, align 8
  call void @__polaron_str_free(ptr %32)
  ret ptr %strcpy39

sc.rhs:                                           ; preds = %while.cond
  %raw26 = getelementptr inbounds %class.HttpResponse, ptr %0, i32 0, i32 1
  %raw27 = load ptr, ptr %raw26, align 8, !tbaa !0
  %end28 = load i32, ptr %end, align 4
  %33 = sext i32 %end28 to i64
  %str.data29 = getelementptr inbounds %String, ptr %raw27, i32 0, i32 1
  %data30 = load ptr, ptr %str.data29, align 8
  %ch.addr = getelementptr i8, ptr %data30, i64 %33
  %ch = load i8, ptr %ch.addr, align 1
  %34 = zext i8 %ch to i32
  %35 = icmp ne i32 %34, 13
  %36 = zext i1 %35 to i32
  %sc.b = icmp ne i32 %36, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %37 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end
}

define internal ptr @Http.buildRequest(ptr %0, ptr %1, ptr %2) {
entry:
  %sb = alloca ptr, align 8
  %path = alloca ptr, align 8
  %host = alloca ptr, align 8
  %verb = alloca ptr, align 8
  store ptr %0, ptr %verb, align 8
  store ptr %1, ptr %host, align 8
  store ptr %2, ptr %path, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb1 = load ptr, ptr %sb, align 8
  %verb2 = load ptr, ptr %verb, align 8
  %3 = call ptr @StringBuilder.append(ptr %sb1, ptr %verb2)
  %sb3 = load ptr, ptr %sb, align 8
  %4 = call ptr @StringBuilder.append(ptr %sb3, ptr @.strobj.3911)
  %sb4 = load ptr, ptr %sb, align 8
  %path5 = load ptr, ptr %path, align 8
  %5 = call ptr @StringBuilder.append(ptr %sb4, ptr %path5)
  %sb6 = load ptr, ptr %sb, align 8
  %6 = call ptr @StringBuilder.append(ptr %sb6, ptr @.strobj.3913)
  %sb7 = load ptr, ptr %sb, align 8
  %host8 = load ptr, ptr %host, align 8
  %7 = call ptr @StringBuilder.append(ptr %sb7, ptr %host8)
  %sb9 = load ptr, ptr %sb, align 8
  %8 = call ptr @StringBuilder.append(ptr %sb9, ptr @.strobj.3915)
  %sb10 = load ptr, ptr %sb, align 8
  %9 = call ptr @StringBuilder.toString(ptr %sb10)
  %strcpy = call ptr @__polaron_str_copy(ptr %9)
  call void @__polaron_str_free(ptr %9)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5320)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5322)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i64 @__polaron_str_index(ptr, i64, ptr, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
