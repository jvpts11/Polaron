; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ascii85.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ascii85.pol"
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
@.fail = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ascii85.pol:12:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ascii85.pol:12:34  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ascii85.pol:12:45  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ascii85.pol:12:57  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata = private constant [14 x i8] c"Hello, World!\00"
@.strobj = private global %String { i64 13, ptr @.strdata, i64 0 }
@.fail.10 = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ascii85.pol:17:64  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [21 x i8] c"man=%s roundtrip=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1321 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1322 = private global %String { i64 16, ptr @.strdata.1321, i64 0 }
@.strdata.1323 = private constant [17 x i8] c"division by zero\00"
@.strobj.1324 = private global %String { i64 16, ptr @.strdata.1323, i64 0 }
@.fail.2947 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4683:46  in Ascii85.encode\0A\00", align 1
@.faila.2948 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2949 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2950 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4687:73  in Ascii85.encode\0A\00", align 1
@.faila.2951 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2952 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2953 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4688:78  in Ascii85.encode\0A\00", align 1
@.faila.2954 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2955 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2956 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4711:34  in Ascii85.decode\0A\00", align 1
@.faila.2957 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2958 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %e3 = alloca ptr, align 8
  %dec = alloca ptr, align 8
  %e2 = alloca ptr, align 8
  %i = alloca i32, align 4
  %src = alloca ptr, align 8
  %data = alloca ptr, align 8
  %enc = alloca ptr, align 8
  %man = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 16)
  store ptr %arr, ptr %man, align 8
  %man2 = load ptr, ptr %man, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %man2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %man2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 77, ptr %arr.elem, align 4
  %man4 = load ptr, ptr %man, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %man4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %man4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 97, ptr %arr.elem10, align 4
  %man11 = load ptr, ptr %man, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %man11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %man11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 110, ptr %arr.elem17, align 4
  %man18 = load ptr, ptr %man, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %man18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %man18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 3
  store i32 32, ptr %arr.elem24, align 4
  %man25 = load ptr, ptr %man, align 8
  %17 = call ptr @Ascii85.encode(ptr %man25, i32 4)
  %strcpy = call ptr @__polaron_str_copy(ptr %17)
  store ptr %strcpy, ptr %enc, align 8
  call void @__polaron_str_free(ptr %17)
  %arr26 = call ptr @__polaron_malloc(i64 60)
  store i64 13, ptr %arr26, align 8
  %arr.data27 = getelementptr i8, ptr %arr26, i64 8
  %18 = call ptr @memset(ptr %arr.data27, i32 0, i64 52)
  store ptr %arr26, ptr %data, align 8
  %strcpy28 = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy28, ptr %src, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok22
  %i29 = load i32, ptr %i, align 4
  %19 = icmp slt i32 %i29, 13
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data30 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %i31 = load i32, ptr %i, align 4
  %21 = sext i32 %i31 to i64
  %arr.len32 = load i64, ptr %data30, align 8
  %arr.oob33 = icmp uge i64 %21, %arr.len32
  br i1 %arr.oob33, label %idx.bad34, label %idx.ok35, !prof !2

for.update:                                       ; preds = %idx.ok35
  %22 = load i32, ptr %i, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data41 = load ptr, ptr %data, align 8
  %24 = call ptr @Ascii85.encode(ptr %data41, i32 13)
  %strcpy42 = call ptr @__polaron_str_copy(ptr %24)
  store ptr %strcpy42, ptr %e2, align 8
  call void @__polaron_str_free(ptr %24)
  %e243 = load ptr, ptr %e2, align 8
  %25 = call ptr @Ascii85.decode(ptr %e243)
  store ptr %25, ptr %dec, align 8
  %dec44 = load ptr, ptr %dec, align 8
  %dec45 = load ptr, ptr %dec, align 8
  %len = load i64, ptr %dec45, align 8
  %26 = trunc i64 %len to i32
  %27 = call ptr @Ascii85.encode(ptr %dec44, i32 %26)
  %strcpy46 = call ptr @__polaron_str_copy(ptr %27)
  store ptr %strcpy46, ptr %e3, align 8
  call void @__polaron_str_free(ptr %27)
  %enc47 = load ptr, ptr %enc, align 8
  %str.data48 = getelementptr inbounds %String, ptr %enc47, i32 0, i32 1
  %data49 = load ptr, ptr %str.data48, align 8
  %e250 = load ptr, ptr %e2, align 8
  %e351 = load ptr, ptr %e3, align 8
  %str.data52 = getelementptr inbounds %String, ptr %e250, i32 0, i32 1
  %data53 = load ptr, ptr %str.data52, align 8
  %str.data54 = getelementptr inbounds %String, ptr %e351, i32 0, i32 1
  %data55 = load ptr, ptr %str.data54, align 8
  %28 = call i32 @strcmp(ptr %data53, ptr %data55)
  %29 = icmp eq i32 %28, 0
  %30 = zext i1 %29 to i32
  %31 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data49, i32 %30)
  %32 = load ptr, ptr %e3, align 8
  call void @__polaron_str_free(ptr %32)
  %33 = load ptr, ptr %e2, align 8
  call void @__polaron_str_free(ptr %33)
  %34 = load ptr, ptr %src, align 8
  call void @__polaron_str_free(ptr %34)
  %35 = load ptr, ptr %enc, align 8
  call void @__polaron_str_free(ptr %35)
  ret i32 0

idx.bad34:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 %21, ptr @.failb.12, i64 %arr.len32, i32 70)
  unreachable

idx.ok35:                                         ; preds = %for.body
  %arr.data36 = getelementptr i8, ptr %data30, i64 8
  %arr.elem37 = getelementptr inbounds i32, ptr %arr.data36, i64 %21
  %src38 = load ptr, ptr %src, align 8
  %i39 = load i32, ptr %i, align 4
  %36 = sext i32 %i39 to i64
  %str.data = getelementptr inbounds %String, ptr %src38, i32 0, i32 1
  %data40 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data40, i64 %36
  %ch = load i8, ptr %ch.addr, align 1
  %37 = zext i8 %ch to i32
  %38 = and i32 %37, 255
  store i32 %38, ptr %arr.elem37, align 4
  br label %for.update
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1322)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1324)
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

define internal ptr @Ascii85.encode(ptr %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %k36 = alloca i32, align 4
  %exc.thrown34 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %k15 = alloca i32, align 4
  %v = alloca i64, align 8
  %dig = alloca ptr, align 8
  %k = alloca i32, align 4
  %cnt = alloca i32, align 4
  %val = alloca i64, align 8
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %n = alloca i32, align 4
  %bytes = alloca ptr, align 8
  store ptr %0, ptr %bytes, align 8
  store i32 %1, ptr %n, align 4
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %for.end40, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %2 = icmp slt i32 %i1, %n2
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  store i64 0, ptr %val, align 8
  store i32 0, ptr %cnt, align 4
  store i32 0, ptr %k, align 4
  br label %for.cond

while.end:                                        ; preds = %while.cond
  %sb54 = load ptr, ptr %sb, align 8
  %4 = call ptr @StringBuilder.toString(ptr %sb54)
  %strcpy = call ptr @__polaron_str_copy(ptr %4)
  call void @__polaron_str_free(ptr %4)
  ret ptr %strcpy

for.cond:                                         ; preds = %for.update, %while.body
  %k3 = load i32, ptr %k, align 4
  %5 = icmp slt i32 %k3, 4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %val4 = load i64, ptr %val, align 8
  %7 = mul i64 %val4, 256
  store i64 %7, ptr %val, align 8
  %i5 = load i32, ptr %i, align 4
  %k6 = load i32, ptr %k, align 4
  %8 = add i32 %i5, %k6
  %n7 = load i32, ptr %n, align 4
  %9 = icmp slt i32 %8, %n7
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then, label %if.end

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %k, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %arr = call ptr @__polaron_malloc(i64 28)
  store i64 5, ptr %arr, align 8
  %arr.data13 = getelementptr i8, ptr %arr, i64 8
  %13 = call ptr @memset(ptr %arr.data13, i32 0, i64 20)
  store ptr %arr, ptr %dig, align 8
  %val14 = load i64, ptr %val, align 8
  store i64 %val14, ptr %v, align 8
  store i32 4, ptr %k15, align 4
  br label %for.cond16

if.then:                                          ; preds = %for.body
  %val8 = load i64, ptr %val, align 8
  %bytes9 = load ptr, ptr %bytes, align 8, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %k11 = load i32, ptr %k, align 4
  %14 = add i32 %i10, %k11
  %15 = sext i32 %14 to i64
  %arr.len = load i64, ptr %bytes9, align 8
  %arr.oob = icmp uge i64 %15, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %idx.ok, %for.body
  br label %for.update

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2947, ptr @.faila.2948, i64 %15, ptr @.failb.2949, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %bytes9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %15
  %elem = load i32, ptr %arr.elem, align 4
  %16 = and i32 %elem, 255
  %17 = sext i32 %16 to i64
  %18 = add i64 %val8, %17
  store i64 %18, ptr %val, align 8
  %cnt12 = load i32, ptr %cnt, align 4
  %19 = add i32 %cnt12, 1
  store i32 %19, ptr %cnt, align 4
  br label %if.end

for.cond16:                                       ; preds = %for.update18, %for.end
  %k20 = load i32, ptr %k15, align 4
  %20 = icmp sge i32 %k20, 0
  %21 = zext i1 %20 to i32
  br i1 %20, label %for.body17, label %for.end19

for.body17:                                       ; preds = %for.cond16
  %dig21 = load ptr, ptr %dig, align 8, !nonnull !0, !dereferenceable !1
  %k22 = load i32, ptr %k15, align 4
  %22 = sext i32 %k22 to i64
  %arr.len23 = load i64, ptr %dig21, align 8
  %arr.oob24 = icmp uge i64 %22, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !2

for.update18:                                     ; preds = %div.ok32
  %k35 = load i32, ptr %k15, align 4
  %23 = sub i32 %k35, 1
  store i32 %23, ptr %k15, align 4
  br label %for.cond16

for.end19:                                        ; preds = %for.cond16
  store i32 0, ptr %k36, align 4
  br label %for.cond37

idx.bad25:                                        ; preds = %for.body17
  call void @__polaron_fail(ptr @.fail.2950, ptr @.faila.2951, i64 %22, ptr @.failb.2952, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %for.body17
  %arr.data27 = getelementptr i8, ptr %dig21, i64 8
  %arr.elem28 = getelementptr inbounds i32, ptr %arr.data27, i64 %22
  %v29 = load i64, ptr %v, align 8
  %24 = icmp eq i64 %v29, -9223372036854775808
  %25 = and i1 %24, false
  %26 = or i1 false, %25
  br i1 %26, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok26
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok26
  %27 = srem i64 %v29, 85
  %28 = trunc i64 %27 to i32
  store i32 %28, ptr %arr.elem28, align 4
  %v30 = load i64, ptr %v, align 8
  %29 = icmp eq i64 %v30, -9223372036854775808
  %30 = and i1 %29, false
  %31 = or i1 false, %30
  br i1 %31, label %div.bad31, label %div.ok32

div.bad31:                                        ; preds = %div.ok
  %exc33 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc33)
  store ptr %exc33, ptr %exc.thrown34, align 8
  call void @_CxxThrowException(ptr %exc.thrown34, ptr @_TI1PEAX)
  unreachable

div.ok32:                                         ; preds = %div.ok
  %32 = sdiv i64 %v30, 85
  store i64 %32, ptr %v, align 8
  br label %for.update18

for.cond37:                                       ; preds = %for.update39, %for.end19
  %k41 = load i32, ptr %k36, align 4
  %cnt42 = load i32, ptr %cnt, align 4
  %33 = add i32 %cnt42, 1
  %34 = icmp slt i32 %k41, %33
  %35 = zext i1 %34 to i32
  br i1 %34, label %for.body38, label %for.end40

for.body38:                                       ; preds = %for.cond37
  %sb43 = load ptr, ptr %sb, align 8
  %dig44 = load ptr, ptr %dig, align 8, !nonnull !0, !dereferenceable !1
  %k45 = load i32, ptr %k36, align 4
  %36 = sext i32 %k45 to i64
  %arr.len46 = load i64, ptr %dig44, align 8
  %arr.oob47 = icmp uge i64 %36, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

for.update39:                                     ; preds = %idx.ok49
  %37 = load i32, ptr %k36, align 4
  %38 = add i32 %37, 1
  store i32 %38, ptr %k36, align 4
  br label %for.cond37

for.end40:                                        ; preds = %for.cond37
  %i53 = load i32, ptr %i, align 4
  %39 = add i32 %i53, 4
  store i32 %39, ptr %i, align 4
  br label %while.cond

idx.bad48:                                        ; preds = %for.body38
  call void @__polaron_fail(ptr @.fail.2953, ptr @.faila.2954, i64 %36, ptr @.failb.2955, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %for.body38
  %arr.data50 = getelementptr i8, ptr %dig44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %36
  %elem52 = load i32, ptr %arr.elem51, align 4
  %40 = add i32 33, %elem52
  %41 = call ptr @StringBuilder.appendChar(ptr %sb43, i32 %40)
  br label %for.update39
}

define internal ptr @Ascii85.decode(ptr %0) {
entry:
  %shift = alloca i32, align 4
  %k32 = alloca i32, align 4
  %d = alloca i32, align 4
  %k = alloca i32, align 4
  %val = alloca i64, align 8
  %c18 = alloca i32, align 4
  %i = alloca i32, align 4
  %pos = alloca i32, align 4
  %out = alloca ptr, align 8
  %c = alloca i32, align 4
  %gi = alloca i32, align 4
  %total = alloca i32, align 4
  %n = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %n, align 4
  store i32 0, ptr %total, align 4
  store i32 0, ptr %gi, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %gi2 = load i32, ptr %gi, align 4
  %n3 = load i32, ptr %n, align 4
  %2 = icmp slt i32 %gi2, %n3
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n4 = load i32, ptr %n, align 4
  %gi5 = load i32, ptr %gi, align 4
  %4 = sub i32 %n4, %gi5
  store i32 %4, ptr %c, align 4
  %c6 = load i32, ptr %c, align 4
  %5 = icmp sgt i32 %c6, 5
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  %total10 = load i32, ptr %total, align 4
  %7 = sext i32 %total10 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %10 = call ptr @memset(ptr %arr.data, i32 0, i64 %8)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %pos, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond11

if.then:                                          ; preds = %while.body
  store i32 5, ptr %c, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %while.body
  %total7 = load i32, ptr %total, align 4
  %c8 = load i32, ptr %c, align 4
  %11 = sub i32 %c8, 1
  %12 = add i32 %total7, %11
  store i32 %12, ptr %total, align 4
  %gi9 = load i32, ptr %gi, align 4
  %13 = add i32 %gi9, 5
  store i32 %13, ptr %gi, align 4
  br label %while.cond

while.cond11:                                     ; preds = %for.end36, %while.end
  %i14 = load i32, ptr %i, align 4
  %n15 = load i32, ptr %n, align 4
  %14 = icmp slt i32 %i14, %n15
  %15 = zext i1 %14 to i32
  br i1 %14, label %while.body12, label %while.end13

while.body12:                                     ; preds = %while.cond11
  %n16 = load i32, ptr %n, align 4
  %i17 = load i32, ptr %i, align 4
  %16 = sub i32 %n16, %i17
  store i32 %16, ptr %c18, align 4
  %c19 = load i32, ptr %c18, align 4
  %17 = icmp sgt i32 %c19, 5
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then20, label %if.end21

while.end13:                                      ; preds = %while.cond11
  %out47 = load ptr, ptr %out, align 8
  ret ptr %out47

if.then20:                                        ; preds = %while.body12
  store i32 5, ptr %c18, align 4
  br label %if.end21

if.end21:                                         ; preds = %if.then20, %while.body12
  store i64 0, ptr %val, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end21
  %k22 = load i32, ptr %k, align 4
  %19 = icmp slt i32 %k22, 5
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 84, ptr %d, align 4
  %k23 = load i32, ptr %k, align 4
  %c24 = load i32, ptr %c18, align 4
  %21 = icmp slt i32 %k23, %c24
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then25, label %if.end26

for.update:                                       ; preds = %if.end26
  %23 = load i32, ptr %k, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %k32, align 4
  br label %for.cond33

if.then25:                                        ; preds = %for.body
  %s27 = load ptr, ptr %s, align 8
  %i28 = load i32, ptr %i, align 4
  %k29 = load i32, ptr %k, align 4
  %25 = add i32 %i28, %k29
  %26 = sext i32 %25 to i64
  %str.data = getelementptr inbounds %String, ptr %s27, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %26
  %ch = load i8, ptr %ch.addr, align 1
  %27 = zext i8 %ch to i32
  %28 = sub i32 %27, 33
  store i32 %28, ptr %d, align 4
  br label %if.end26

if.end26:                                         ; preds = %if.then25, %for.body
  %val30 = load i64, ptr %val, align 8
  %29 = mul i64 %val30, 85
  %d31 = load i32, ptr %d, align 4
  %30 = sext i32 %d31 to i64
  %31 = add i64 %29, %30
  store i64 %31, ptr %val, align 8
  br label %for.update

for.cond33:                                       ; preds = %for.update35, %for.end
  %k37 = load i32, ptr %k32, align 4
  %c38 = load i32, ptr %c18, align 4
  %32 = sub i32 %c38, 1
  %33 = icmp slt i32 %k37, %32
  %34 = zext i1 %33 to i32
  br i1 %33, label %for.body34, label %for.end36

for.body34:                                       ; preds = %for.cond33
  %k39 = load i32, ptr %k32, align 4
  %35 = sub i32 3, %k39
  %36 = mul i32 %35, 8
  store i32 %36, ptr %shift, align 4
  %out40 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %pos41 = load i32, ptr %pos, align 4
  %37 = sext i32 %pos41 to i64
  %arr.len = load i64, ptr %out40, align 8
  %arr.oob = icmp uge i64 %37, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update35:                                     ; preds = %idx.ok
  %38 = load i32, ptr %k32, align 4
  %39 = add i32 %38, 1
  store i32 %39, ptr %k32, align 4
  br label %for.cond33

for.end36:                                        ; preds = %for.cond33
  %i46 = load i32, ptr %i, align 4
  %40 = add i32 %i46, 5
  store i32 %40, ptr %i, align 4
  br label %while.cond11

idx.bad:                                          ; preds = %for.body34
  call void @__polaron_fail(ptr @.fail.2956, ptr @.faila.2957, i64 %37, ptr @.failb.2958, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body34
  %arr.data42 = getelementptr i8, ptr %out40, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data42, i64 %37
  %val43 = load i64, ptr %val, align 8
  %shift44 = load i32, ptr %shift, align 4
  %41 = sext i32 %shift44 to i64
  %42 = ashr i64 %val43, 63
  %43 = icmp ult i64 %41, 64
  %44 = select i1 %43, i64 %41, i64 0
  %45 = ashr i64 %val43, %44
  %46 = select i1 %43, i64 %45, i64 %42
  %47 = and i64 %46, 255
  %48 = trunc i64 %47 to i32
  store i32 %48, ptr %arr.elem, align 4
  %pos45 = load i32, ptr %pos, align 4
  %49 = add i32 %pos45, 1
  store i32 %49, ptr %pos, align 4
  br label %for.update35
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
