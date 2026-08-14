; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/base58.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/base58.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
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
@.fail = private unnamed_addr constant [125 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/base58.pol:12:24  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [125 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/base58.pol:12:36  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [125 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/base58.pol:12:49  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [125 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/base58.pol:12:62  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [125 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/base58.pol:12:75  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [30 x i8] c"enc=%s roundtrip=%d zeros=%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1319 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1320 = private global %String { i64 16, ptr @.strdata.1319, i64 0 }
@.strdata.1321 = private constant [17 x i8] c"division by zero\00"
@.strobj.1322 = private global %String { i64 16, ptr @.strdata.1321, i64 0 }
@.strdata.2908 = private constant [59 x i8] c"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz\00"
@.strobj.2909 = private global %String { i64 58, ptr @.strdata.2908, i64 0 }
@.strdata.2910 = private constant [59 x i8] c"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz\00"
@.strobj.2911 = private global %String { i64 58, ptr @.strdata.2910, i64 0 }
@.fail.2912 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4631:17  in Base58.encode\0A\00", align 1
@.faila.2913 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2914 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2915 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4633:62  in Base58.encode\0A\00", align 1
@.faila.2916 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2917 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2918 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4633:62  in Base58.encode\0A\00", align 1
@.faila.2919 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2920 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2921 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4639:25  in Base58.encode\0A\00", align 1
@.faila.2922 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2923 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2924 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4640:32  in Base58.encode\0A\00", align 1
@.faila.2925 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2926 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2927 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4644:21  in Base58.encode\0A\00", align 1
@.faila.2928 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2929 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2930 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4660:25  in Base58.decode\0A\00", align 1
@.faila.2931 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2932 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2933 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4661:32  in Base58.decode\0A\00", align 1
@.faila.2934 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2935 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2936 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4664:51  in Base58.decode\0A\00", align 1
@.faila.2937 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2938 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2939 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4667:73  in Base58.decode\0A\00", align 1
@.faila.2940 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2941 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2942 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4667:73  in Base58.decode\0A\00", align 1
@.faila.2943 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2944 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5320 = private constant [1 x i8] zeroinitializer
@.strobj.5321 = private global %String { i64 0, ptr @.strdata.5320, i64 0 }
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %z = alloca ptr, align 8
  %enc2 = alloca ptr, align 8
  %dec = alloca ptr, align 8
  %enc = alloca ptr, align 8
  %data = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 28)
  store i64 5, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 20)
  store ptr %arr, ptr %data, align 8
  %data2 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %data2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %data2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 72, ptr %arr.elem, align 4
  %data4 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %data4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %data4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 101, ptr %arr.elem10, align 4
  %data11 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %data11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %data11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 108, ptr %arr.elem17, align 4
  %data18 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %data18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %data18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 3
  store i32 108, ptr %arr.elem24, align 4
  %data25 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len26 = load i64, ptr %data25, align 8
  %arr.oob27 = icmp uge i64 4, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %data25, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 4
  store i32 111, ptr %arr.elem31, align 4
  %data32 = load ptr, ptr %data, align 8
  %17 = call ptr @Base58.encode(ptr %data32, i32 5)
  %strcpy = call ptr @__polaron_str_copy(ptr %17)
  store ptr %strcpy, ptr %enc, align 8
  call void @__polaron_str_free(ptr %17)
  %enc33 = load ptr, ptr %enc, align 8
  %18 = call ptr @Base58.decode(ptr %enc33)
  store ptr %18, ptr %dec, align 8
  %dec34 = load ptr, ptr %dec, align 8
  %dec35 = load ptr, ptr %dec, align 8
  %len = load i64, ptr %dec35, align 8
  %19 = trunc i64 %len to i32
  %20 = call ptr @Base58.encode(ptr %dec34, i32 %19)
  %strcpy36 = call ptr @__polaron_str_copy(ptr %20)
  store ptr %strcpy36, ptr %enc2, align 8
  call void @__polaron_str_free(ptr %20)
  %arr37 = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr37, align 8
  %arr.data38 = getelementptr i8, ptr %arr37, i64 8
  %21 = call ptr @memset(ptr %arr.data38, i32 0, i64 12)
  store ptr %arr37, ptr %z, align 8
  %enc39 = load ptr, ptr %enc, align 8
  %str.data = getelementptr inbounds %String, ptr %enc39, i32 0, i32 1
  %data40 = load ptr, ptr %str.data, align 8
  %enc41 = load ptr, ptr %enc, align 8
  %enc242 = load ptr, ptr %enc2, align 8
  %str.data43 = getelementptr inbounds %String, ptr %enc41, i32 0, i32 1
  %data44 = load ptr, ptr %str.data43, align 8
  %str.data45 = getelementptr inbounds %String, ptr %enc242, i32 0, i32 1
  %data46 = load ptr, ptr %str.data45, align 8
  %22 = call i32 @strcmp(ptr %data44, ptr %data46)
  %23 = icmp eq i32 %22, 0
  %24 = zext i1 %23 to i32
  %z47 = load ptr, ptr %z, align 8
  %25 = call ptr @Base58.encode(ptr %z47, i32 3)
  %str.data48 = getelementptr inbounds %String, ptr %25, i32 0, i32 1
  %data49 = load ptr, ptr %str.data48, align 8
  %26 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data40, i32 %24, ptr %data49)
  call void @__polaron_str_free(ptr %25)
  %27 = load ptr, ptr %enc2, align 8
  call void @__polaron_str_free(ptr %27)
  %28 = load ptr, ptr %enc, align 8
  call void @__polaron_str_free(ptr %28)
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !3
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
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1320)
  ret ptr %strcpy
}

define internal void @DivideByZeroException.DivideByZeroException(ptr %0) {
entry:
  call void @ArithmeticException.ArithmeticException(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DivideByZeroException, ptr %0, i32 0, i32 0
  store ptr @DivideByZeroException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @DivideByZeroException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1322)
  ret ptr %strcpy
}

define internal void @StringBuilder.StringBuilder(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 0
  store ptr @StringBuilder.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  store i32 16, ptr %cap, align 4, !tbaa !7
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %1 = ptrtoint ptr %mem.alloc to i64
  store i64 %1, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !7
  ret void
}

define internal void @StringBuilder.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %nb = alloca i64, align 8
  %n = alloca i32, align 4
  %extra = alloca i32, align 4
  store i32 %1, ptr %extra, align 4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %extra2 = load i32, ptr %extra, align 4
  %2 = add i32 %count1, %extra2
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap3 = load i32, ptr %cap, align 4, !tbaa !7
  %3 = icmp sle i32 %2, %cap3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap5 = load i32, ptr %cap4, align 4, !tbaa !7
  %5 = mul i32 %cap5, 2
  store i32 %5, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %n6 = load i32, ptr %n, align 4
  %count7 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
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
  %buf13 = load i64, ptr %buf, align 8, !tbaa !9
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !7
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !9
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !9
  %cap20 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %n21 = load i32, ptr %n, align 4
  store i32 %n21, ptr %cap20, align 4, !tbaa !7
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
  %buf3 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !7
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
  %count10 = load i32, ptr %count9, align 4, !tbaa !7
  %n11 = load i32, ptr %n, align 4
  %7 = add i32 %count10, %n11
  store i32 %7, ptr %count8, align 4, !tbaa !7
  ret ptr %0
}

define internal ptr @StringBuilder.appendChar(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  store i32 %1, ptr %c, align 4
  call void @StringBuilder.ensure(ptr %0, i32 1)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !7
  %2 = sext i32 %count2 to i64
  %3 = add i64 %buf1, %2
  %c3 = load i32, ptr %c, align 4
  %4 = trunc i32 %c3 to i8
  %5 = inttoptr i64 %3 to ptr
  store i8 %4, ptr %5, align 1
  %count4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count5 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count6 = load i32, ptr %count5, align 4, !tbaa !7
  %6 = add i32 %count6, 1
  store i32 %6, ptr %count4, align 4, !tbaa !7
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
  %count7 = load i32, ptr %count, align 4, !tbaa !7
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
  %count18 = load i32, ptr %count17, align 4, !tbaa !7
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
  %buf24 = load i64, ptr %buf, align 8, !tbaa !9
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !9
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !9
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !9
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  ret i32 %count1
}

define internal ptr @StringBuilder.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !7
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
  store i32 0, ptr %count, align 4, !tbaa !7
  ret ptr %0
}

define internal void @"StringBuilder.~StringBuilder"(ptr %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !9
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !9
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal ptr @Base58.al() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2909)
  ret ptr %strcpy
}

define internal i32 @Base58.val(i32 %0) {
entry:
  %i = alloca i32, align 4
  %a = alloca ptr, align 8
  %c = alloca i32, align 4
  store i32 %0, ptr %c, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2911)
  store ptr %strcpy, ptr %a, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %a2 = load ptr, ptr %a, align 8
  %str.len = getelementptr inbounds %String, ptr %a2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %a3 = load ptr, ptr %a, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %a3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %c5 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %5, %c5
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.end

for.update:                                       ; preds = %if.end
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %10 = load ptr, ptr %a, align 8
  call void @__polaron_str_free(ptr %10)
  ret i32 0

if.then:                                          ; preds = %for.body
  %i6 = load i32, ptr %i, align 4
  %11 = load ptr, ptr %a, align 8
  call void @__polaron_str_free(ptr %11)
  ret i32 %i6

if.end:                                           ; preds = %for.body
  br label %for.update
}

define internal ptr @Base58.encode(ptr %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %i90 = alloca i32, align 4
  %r = alloca ptr, align 8
  %i79 = alloca i32, align 4
  %out = alloca ptr, align 8
  %exc.thrown64 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %acc = alloca i32, align 4
  %i34 = alloca i32, align 4
  %rem = alloca i32, align 4
  %start = alloca i32, align 4
  %rev = alloca ptr, align 8
  %i = alloca i32, align 4
  %buf = alloca ptr, align 8
  %zeros = alloca i32, align 4
  %a = alloca ptr, align 8
  %n = alloca i32, align 4
  %bytes = alloca ptr, align 8
  store ptr %0, ptr %bytes, align 8
  store i32 %1, ptr %n, align 4
  %2 = call ptr @Base58.al()
  %strcpy = call ptr @__polaron_str_copy(ptr %2)
  store ptr %strcpy, ptr %a, align 8
  call void @__polaron_str_free(ptr %2)
  store i32 0, ptr %zeros, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %zeros1 = load i32, ptr %zeros, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %zeros1, %n2
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %zeros5 = load i32, ptr %zeros, align 4
  %5 = add i32 %zeros5, 1
  store i32 %5, ptr %zeros, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %n6 = load i32, ptr %n, align 4
  %6 = add i32 %n6, 1
  %7 = sext i32 %6 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr, align 8
  %arr.data7 = getelementptr i8, ptr %arr, i64 8
  %10 = call ptr @memset(ptr %arr.data7, i32 0, i64 %8)
  store ptr %arr, ptr %buf, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

sc.rhs:                                           ; preds = %while.cond
  %bytes3 = load ptr, ptr %bytes, align 8, !nonnull !0, !dereferenceable !1
  %zeros4 = load i32, ptr %zeros, align 4
  %11 = sext i32 %zeros4 to i64
  %arr.len = load i64, ptr %bytes3, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

sc.end:                                           ; preds = %idx.ok, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok ]
  %12 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.2912, ptr @.faila.2913, i64 %11, ptr @.failb.2914, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %bytes3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %11
  %elem = load i32, ptr %arr.elem, align 4
  %13 = icmp eq i32 %elem, 0
  %14 = zext i1 %13 to i32
  %sc.b = icmp ne i32 %14, 0
  br label %sc.end

for.cond:                                         ; preds = %for.update, %while.end
  %i8 = load i32, ptr %i, align 4
  %n9 = load i32, ptr %n, align 4
  %15 = icmp slt i32 %i8, %n9
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %buf10 = load ptr, ptr %buf, align 8, !nonnull !0, !dereferenceable !1
  %i11 = load i32, ptr %i, align 4
  %17 = sext i32 %i11 to i64
  %arr.len12 = load i64, ptr %buf10, align 8
  %arr.oob13 = icmp uge i64 %17, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

for.update:                                       ; preds = %idx.ok23
  %18 = load i32, ptr %i, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %rev, align 8
  %zeros27 = load i32, ptr %zeros, align 4
  store i32 %zeros27, ptr %start, align 4
  br label %while.cond28

idx.bad14:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2915, ptr @.faila.2916, i64 %17, ptr @.failb.2917, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %buf10, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %17
  %bytes18 = load ptr, ptr %bytes, align 8, !nonnull !0, !dereferenceable !1
  %i19 = load i32, ptr %i, align 4
  %20 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %bytes18, align 8
  %arr.oob21 = icmp uge i64 %20, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

idx.bad22:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.2918, ptr @.faila.2919, i64 %20, ptr @.failb.2920, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok15
  %arr.data24 = getelementptr i8, ptr %bytes18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %20
  %elem26 = load i32, ptr %arr.elem25, align 4
  %21 = and i32 %elem26, 255
  store i32 %21, ptr %arr.elem17, align 4
  br label %for.update

while.cond28:                                     ; preds = %if.end, %for.end
  %start31 = load i32, ptr %start, align 4
  %n32 = load i32, ptr %n, align 4
  %22 = icmp slt i32 %start31, %n32
  %23 = zext i1 %22 to i32
  br i1 %22, label %while.body29, label %while.end30

while.body29:                                     ; preds = %while.cond28
  store i32 0, ptr %rem, align 4
  %start33 = load i32, ptr %start, align 4
  store i32 %start33, ptr %i34, align 4
  br label %for.cond35

while.end30:                                      ; preds = %while.cond28
  %StringBuilder.obj78 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj78)
  store ptr %StringBuilder.obj78, ptr %out, align 8
  store i32 0, ptr %i79, align 4
  br label %for.cond80

for.cond35:                                       ; preds = %for.update37, %while.body29
  %i39 = load i32, ptr %i34, align 4
  %n40 = load i32, ptr %n, align 4
  %24 = icmp slt i32 %i39, %n40
  %25 = zext i1 %24 to i32
  br i1 %24, label %for.body36, label %for.end38

for.body36:                                       ; preds = %for.cond35
  %rem41 = load i32, ptr %rem, align 4
  %26 = mul i32 %rem41, 256
  %buf42 = load ptr, ptr %buf, align 8, !nonnull !0, !dereferenceable !1
  %i43 = load i32, ptr %i34, align 4
  %27 = sext i32 %i43 to i64
  %arr.len44 = load i64, ptr %buf42, align 8
  %arr.oob45 = icmp uge i64 %27, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !2

for.update37:                                     ; preds = %div.ok62
  %28 = load i32, ptr %i34, align 4
  %29 = add i32 %28, 1
  store i32 %29, ptr %i34, align 4
  br label %for.cond35

for.end38:                                        ; preds = %for.cond35
  %rev65 = load ptr, ptr %rev, align 8
  %a66 = load ptr, ptr %a, align 8
  %rem67 = load i32, ptr %rem, align 4
  %30 = sext i32 %rem67 to i64
  %str.data = getelementptr inbounds %String, ptr %a66, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %30
  %ch = load i8, ptr %ch.addr, align 1
  %31 = zext i8 %ch to i32
  %32 = call ptr @StringBuilder.appendChar(ptr %rev65, i32 %31)
  %buf68 = load ptr, ptr %buf, align 8, !nonnull !0, !dereferenceable !1
  %start69 = load i32, ptr %start, align 4
  %33 = sext i32 %start69 to i64
  %arr.len70 = load i64, ptr %buf68, align 8
  %arr.oob71 = icmp uge i64 %33, %arr.len70
  br i1 %arr.oob71, label %idx.bad72, label %idx.ok73, !prof !2

idx.bad46:                                        ; preds = %for.body36
  call void @__polaron_fail(ptr @.fail.2921, ptr @.faila.2922, i64 %27, ptr @.failb.2923, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %for.body36
  %arr.data48 = getelementptr i8, ptr %buf42, i64 8
  %arr.elem49 = getelementptr inbounds i32, ptr %arr.data48, i64 %27
  %elem50 = load i32, ptr %arr.elem49, align 4
  %34 = add i32 %26, %elem50
  store i32 %34, ptr %acc, align 4
  %buf51 = load ptr, ptr %buf, align 8, !nonnull !0, !dereferenceable !1
  %i52 = load i32, ptr %i34, align 4
  %35 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %buf51, align 8
  %arr.oob54 = icmp uge i64 %35, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !2

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.2924, ptr @.faila.2925, i64 %35, ptr @.failb.2926, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok47
  %arr.data57 = getelementptr i8, ptr %buf51, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 %35
  %acc59 = load i32, ptr %acc, align 4
  %36 = icmp eq i32 %acc59, -2147483648
  %37 = and i1 %36, false
  %38 = or i1 false, %37
  br i1 %38, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok56
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok56
  %39 = sdiv i32 %acc59, 58
  store i32 %39, ptr %arr.elem58, align 4
  %acc60 = load i32, ptr %acc, align 4
  %40 = icmp eq i32 %acc60, -2147483648
  %41 = and i1 %40, false
  %42 = or i1 false, %41
  br i1 %42, label %div.bad61, label %div.ok62

div.bad61:                                        ; preds = %div.ok
  %exc63 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc63)
  store ptr %exc63, ptr %exc.thrown64, align 8
  call void @_CxxThrowException(ptr %exc.thrown64, ptr @_TI1PEAX)
  unreachable

div.ok62:                                         ; preds = %div.ok
  %43 = srem i32 %acc60, 58
  store i32 %43, ptr %rem, align 4
  br label %for.update37

idx.bad72:                                        ; preds = %for.end38
  call void @__polaron_fail(ptr @.fail.2927, ptr @.faila.2928, i64 %33, ptr @.failb.2929, i64 %arr.len70, i32 70)
  unreachable

idx.ok73:                                         ; preds = %for.end38
  %arr.data74 = getelementptr i8, ptr %buf68, i64 8
  %arr.elem75 = getelementptr inbounds i32, ptr %arr.data74, i64 %33
  %elem76 = load i32, ptr %arr.elem75, align 4
  %44 = icmp eq i32 %elem76, 0
  %45 = zext i1 %44 to i32
  br i1 %44, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok73
  %start77 = load i32, ptr %start, align 4
  %46 = add i32 %start77, 1
  store i32 %46, ptr %start, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok73
  br label %while.cond28

for.cond80:                                       ; preds = %for.update82, %while.end30
  %i84 = load i32, ptr %i79, align 4
  %zeros85 = load i32, ptr %zeros, align 4
  %47 = icmp slt i32 %i84, %zeros85
  %48 = zext i1 %47 to i32
  br i1 %47, label %for.body81, label %for.end83

for.body81:                                       ; preds = %for.cond80
  %out86 = load ptr, ptr %out, align 8
  %49 = call ptr @StringBuilder.appendChar(ptr %out86, i32 49)
  br label %for.update82

for.update82:                                     ; preds = %for.body81
  %50 = load i32, ptr %i79, align 4
  %51 = add i32 %50, 1
  store i32 %51, ptr %i79, align 4
  br label %for.cond80

for.end83:                                        ; preds = %for.cond80
  %rev87 = load ptr, ptr %rev, align 8
  %52 = call ptr @StringBuilder.toString(ptr %rev87)
  %strcpy88 = call ptr @__polaron_str_copy(ptr %52)
  store ptr %strcpy88, ptr %r, align 8
  call void @__polaron_str_free(ptr %52)
  %r89 = load ptr, ptr %r, align 8
  %str.len = getelementptr inbounds %String, ptr %r89, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %53 = trunc i64 %len to i32
  %54 = sub i32 %53, 1
  store i32 %54, ptr %i90, align 4
  br label %for.cond91

for.cond91:                                       ; preds = %for.update93, %for.end83
  %i95 = load i32, ptr %i90, align 4
  %55 = icmp sge i32 %i95, 0
  %56 = zext i1 %55 to i32
  br i1 %55, label %for.body92, label %for.end94

for.body92:                                       ; preds = %for.cond91
  %out96 = load ptr, ptr %out, align 8
  %r97 = load ptr, ptr %r, align 8
  %i98 = load i32, ptr %i90, align 4
  %57 = sext i32 %i98 to i64
  %str.data99 = getelementptr inbounds %String, ptr %r97, i32 0, i32 1
  %data100 = load ptr, ptr %str.data99, align 8
  %ch.addr101 = getelementptr i8, ptr %data100, i64 %57
  %ch102 = load i8, ptr %ch.addr101, align 1
  %58 = zext i8 %ch102 to i32
  %59 = call ptr @StringBuilder.appendChar(ptr %out96, i32 %58)
  br label %for.update93

for.update93:                                     ; preds = %for.body92
  %i103 = load i32, ptr %i90, align 4
  %60 = sub i32 %i103, 1
  store i32 %60, ptr %i90, align 4
  br label %for.cond91

for.end94:                                        ; preds = %for.cond91
  %out104 = load ptr, ptr %out, align 8
  %61 = call ptr @StringBuilder.toString(ptr %out104)
  %strcpy105 = call ptr @__polaron_str_copy(ptr %61)
  call void @__polaron_str_free(ptr %61)
  %62 = load ptr, ptr %r, align 8
  call void @__polaron_str_free(ptr %62)
  %63 = load ptr, ptr %a, align 8
  call void @__polaron_str_free(ptr %63)
  ret ptr %strcpy105
}

define internal ptr @Base58.decode(ptr %0) {
entry:
  %i58 = alloca i32, align 4
  %out = alloca ptr, align 8
  %acc = alloca i32, align 4
  %j = alloca i32, align 4
  %carry = alloca i32, align 4
  %i = alloca i32, align 4
  %blen = alloca i32, align 4
  %tmp = alloca ptr, align 8
  %zeros = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store i32 0, ptr %zeros, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %zeros1 = load i32, ptr %zeros, align 4
  %s2 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %zeros1, %1
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %zeros5 = load i32, ptr %zeros, align 4
  %4 = add i32 %zeros5, 1
  store i32 %4, ptr %zeros, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %s6 = load ptr, ptr %s, align 8
  %str.len7 = getelementptr inbounds %String, ptr %s6, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %5 = trunc i64 %len8 to i32
  %6 = add i32 %5, 1
  %7 = sext i32 %6 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %10 = call ptr @memset(ptr %arr.data, i32 0, i64 %8)
  store ptr %arr, ptr %tmp, align 8
  store i32 0, ptr %blen, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

sc.rhs:                                           ; preds = %while.cond
  %s3 = load ptr, ptr %s, align 8
  %zeros4 = load i32, ptr %zeros, align 4
  %11 = sext i32 %zeros4 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %11
  %ch = load i8, ptr %ch.addr, align 1
  %12 = zext i8 %ch to i32
  %13 = icmp eq i32 %12, 49
  %14 = zext i1 %13 to i32
  %sc.b = icmp ne i32 %14, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %15 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

for.cond:                                         ; preds = %for.update, %while.end
  %i9 = load i32, ptr %i, align 4
  %s10 = load ptr, ptr %s, align 8
  %str.len11 = getelementptr inbounds %String, ptr %s10, i32 0, i32 0
  %len12 = load i64, ptr %str.len11, align 8
  %16 = trunc i64 %len12 to i32
  %17 = icmp slt i32 %i9, %16
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s13 = load ptr, ptr %s, align 8
  %i14 = load i32, ptr %i, align 4
  %19 = sext i32 %i14 to i64
  %str.data15 = getelementptr inbounds %String, ptr %s13, i32 0, i32 1
  %data16 = load ptr, ptr %str.data15, align 8
  %ch.addr17 = getelementptr i8, ptr %data16, i64 %19
  %ch18 = load i8, ptr %ch.addr17, align 1
  %20 = zext i8 %ch18 to i32
  %21 = call i32 @Base58.val(i32 %20)
  store i32 %21, ptr %carry, align 4
  store i32 0, ptr %j, align 4
  br label %for.cond19

for.update:                                       ; preds = %while.end41
  %22 = load i32, ptr %i, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %zeros54 = load i32, ptr %zeros, align 4
  %blen55 = load i32, ptr %blen, align 4
  %24 = add i32 %zeros54, %blen55
  %25 = sext i32 %24 to i64
  %26 = mul i64 %25, 4
  %27 = add i64 8, %26
  %arr56 = call ptr @__polaron_malloc(i64 %27)
  store i64 %25, ptr %arr56, align 8
  %arr.data57 = getelementptr i8, ptr %arr56, i64 8
  %28 = call ptr @memset(ptr %arr.data57, i32 0, i64 %26)
  store ptr %arr56, ptr %out, align 8
  store i32 0, ptr %i58, align 4
  br label %for.cond59

for.cond19:                                       ; preds = %for.update21, %for.body
  %j23 = load i32, ptr %j, align 4
  %blen24 = load i32, ptr %blen, align 4
  %29 = icmp slt i32 %j23, %blen24
  %30 = zext i1 %29 to i32
  br i1 %29, label %for.body20, label %for.end22

for.body20:                                       ; preds = %for.cond19
  %tmp25 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %j26 = load i32, ptr %j, align 4
  %31 = sext i32 %j26 to i64
  %arr.len = load i64, ptr %tmp25, align 8
  %arr.oob = icmp uge i64 %31, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update21:                                     ; preds = %idx.ok34
  %32 = load i32, ptr %j, align 4
  %33 = add i32 %32, 1
  store i32 %33, ptr %j, align 4
  br label %for.cond19

for.end22:                                        ; preds = %for.cond19
  br label %while.cond39

idx.bad:                                          ; preds = %for.body20
  call void @__polaron_fail(ptr @.fail.2930, ptr @.faila.2931, i64 %31, ptr @.failb.2932, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body20
  %arr.data27 = getelementptr i8, ptr %tmp25, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data27, i64 %31
  %elem = load i32, ptr %arr.elem, align 4
  %34 = mul i32 %elem, 58
  %carry28 = load i32, ptr %carry, align 4
  %35 = add i32 %34, %carry28
  store i32 %35, ptr %acc, align 4
  %tmp29 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %j30 = load i32, ptr %j, align 4
  %36 = sext i32 %j30 to i64
  %arr.len31 = load i64, ptr %tmp29, align 8
  %arr.oob32 = icmp uge i64 %36, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !2

idx.bad33:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2933, ptr @.faila.2934, i64 %36, ptr @.failb.2935, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %idx.ok
  %arr.data35 = getelementptr i8, ptr %tmp29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %36
  %acc37 = load i32, ptr %acc, align 4
  %37 = and i32 %acc37, 255
  store i32 %37, ptr %arr.elem36, align 4
  %acc38 = load i32, ptr %acc, align 4
  %38 = ashr i32 %acc38, 31
  %39 = ashr i32 %acc38, 8
  store i32 %39, ptr %carry, align 4
  br label %for.update21

while.cond39:                                     ; preds = %idx.ok48, %for.end22
  %carry42 = load i32, ptr %carry, align 4
  %40 = icmp sgt i32 %carry42, 0
  %41 = zext i1 %40 to i32
  br i1 %40, label %while.body40, label %while.end41

while.body40:                                     ; preds = %while.cond39
  %tmp43 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %blen44 = load i32, ptr %blen, align 4
  %42 = sext i32 %blen44 to i64
  %arr.len45 = load i64, ptr %tmp43, align 8
  %arr.oob46 = icmp uge i64 %42, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

while.end41:                                      ; preds = %while.cond39
  br label %for.update

idx.bad47:                                        ; preds = %while.body40
  call void @__polaron_fail(ptr @.fail.2936, ptr @.faila.2937, i64 %42, ptr @.failb.2938, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %while.body40
  %arr.data49 = getelementptr i8, ptr %tmp43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %42
  %carry51 = load i32, ptr %carry, align 4
  %43 = and i32 %carry51, 255
  store i32 %43, ptr %arr.elem50, align 4
  %blen52 = load i32, ptr %blen, align 4
  %44 = add i32 %blen52, 1
  store i32 %44, ptr %blen, align 4
  %carry53 = load i32, ptr %carry, align 4
  %45 = ashr i32 %carry53, 31
  %46 = ashr i32 %carry53, 8
  store i32 %46, ptr %carry, align 4
  br label %while.cond39

for.cond59:                                       ; preds = %for.update61, %for.end
  %i63 = load i32, ptr %i58, align 4
  %blen64 = load i32, ptr %blen, align 4
  %47 = icmp slt i32 %i63, %blen64
  %48 = zext i1 %47 to i32
  br i1 %47, label %for.body60, label %for.end62

for.body60:                                       ; preds = %for.cond59
  %out65 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %zeros66 = load i32, ptr %zeros, align 4
  %i67 = load i32, ptr %i58, align 4
  %49 = add i32 %zeros66, %i67
  %50 = sext i32 %49 to i64
  %arr.len68 = load i64, ptr %out65, align 8
  %arr.oob69 = icmp uge i64 %50, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !2

for.update61:                                     ; preds = %idx.ok80
  %51 = load i32, ptr %i58, align 4
  %52 = add i32 %51, 1
  store i32 %52, ptr %i58, align 4
  br label %for.cond59

for.end62:                                        ; preds = %for.cond59
  %out84 = load ptr, ptr %out, align 8
  ret ptr %out84

idx.bad70:                                        ; preds = %for.body60
  call void @__polaron_fail(ptr @.fail.2939, ptr @.faila.2940, i64 %50, ptr @.failb.2941, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %for.body60
  %arr.data72 = getelementptr i8, ptr %out65, i64 8
  %arr.elem73 = getelementptr inbounds i32, ptr %arr.data72, i64 %50
  %tmp74 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %blen75 = load i32, ptr %blen, align 4
  %53 = sub i32 %blen75, 1
  %i76 = load i32, ptr %i58, align 4
  %54 = sub i32 %53, %i76
  %55 = sext i32 %54 to i64
  %arr.len77 = load i64, ptr %tmp74, align 8
  %arr.oob78 = icmp uge i64 %55, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !2

idx.bad79:                                        ; preds = %idx.ok71
  call void @__polaron_fail(ptr @.fail.2942, ptr @.faila.2943, i64 %55, ptr @.failb.2944, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %idx.ok71
  %arr.data81 = getelementptr i8, ptr %tmp74, i64 8
  %arr.elem82 = getelementptr inbounds i32, ptr %arr.data81, i64 %55
  %elem83 = load i32, ptr %arr.elem82, align 4
  store i32 %elem83, ptr %arr.elem73, align 4
  br label %for.update61
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5321)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5323)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @strcmp(ptr, ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !5, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"i64", !5, i64 0}
