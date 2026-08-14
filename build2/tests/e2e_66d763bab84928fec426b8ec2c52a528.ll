; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crt_factorize.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crt_factorize.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crt_factorize.pol:15:21  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crt_factorize.pol:15:29  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crt_factorize.pol:15:37  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crt_factorize.pol:15:45  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crt_factorize.pol:15:53  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crt_factorize.pol:15:61  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [8 x i8] c"crt=%d\0A\00", align 1
@.str.16 = private unnamed_addr constant [30 x i8] c"lpf360=%d cnt360=%d lpf13=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1323 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1324 = private global %String { i64 16, ptr @.strdata.1323, i64 0 }
@.strdata.1325 = private constant [17 x i8] c"division by zero\00"
@.strobj.1326 = private global %String { i64 16, ptr @.strdata.1325, i64 0 }
@.fail.3468 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5980:17  in Crt.solve\0A\00", align 1
@.faila.3469 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3470 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3471 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5981:17  in Crt.solve\0A\00", align 1
@.faila.3472 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3473 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3474 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5983:21  in Crt.solve\0A\00", align 1
@.faila.3475 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3476 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3477 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5985:21  in Crt.solve\0A\00", align 1
@.faila.3478 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3479 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }
@.strdata.5326 = private constant [1 x i8] zeroinitializer
@.strobj.5327 = private global %String { i64 0, ptr @.strdata.5326, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  %a = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 12)
  store ptr %arr, ptr %a, align 8
  %arr2 = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr2, align 8
  %arr.data3 = getelementptr i8, ptr %arr2, i64 8
  %17 = call ptr @memset(ptr %arr.data3, i32 0, i64 12)
  store ptr %arr2, ptr %n, align 8
  %a4 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a4, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data5 = getelementptr i8, ptr %a4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data5, i64 0
  store i32 2, ptr %arr.elem, align 4
  %n6 = load ptr, ptr %n, align 8, !nonnull !0, !dereferenceable !1
  %arr.len7 = load i64, ptr %n6, align 8
  %arr.oob8 = icmp uge i64 0, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 0, ptr @.failb.3, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %n6, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 0
  store i32 3, ptr %arr.elem12, align 4
  %a13 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len14 = load i64, ptr %a13, align 8
  %arr.oob15 = icmp uge i64 1, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad16:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 1, ptr @.failb.6, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok10
  %arr.data18 = getelementptr i8, ptr %a13, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 1
  store i32 3, ptr %arr.elem19, align 4
  %n20 = load ptr, ptr %n, align 8, !nonnull !0, !dereferenceable !1
  %arr.len21 = load i64, ptr %n20, align 8
  %arr.oob22 = icmp uge i64 1, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

idx.bad23:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 1, ptr @.failb.9, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok17
  %arr.data25 = getelementptr i8, ptr %n20, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 1
  store i32 5, ptr %arr.elem26, align 4
  %a27 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len28 = load i64, ptr %a27, align 8
  %arr.oob29 = icmp uge i64 2, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 2, ptr @.failb.12, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok24
  %arr.data32 = getelementptr i8, ptr %a27, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 2
  store i32 2, ptr %arr.elem33, align 4
  %n34 = load ptr, ptr %n, align 8, !nonnull !0, !dereferenceable !1
  %arr.len35 = load i64, ptr %n34, align 8
  %arr.oob36 = icmp uge i64 2, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !2

idx.bad37:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 2, ptr @.failb.15, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %idx.ok31
  %arr.data39 = getelementptr i8, ptr %n34, i64 8
  %arr.elem40 = getelementptr inbounds i32, ptr %arr.data39, i64 2
  store i32 7, ptr %arr.elem40, align 4
  %a41 = load ptr, ptr %a, align 8
  %n42 = load ptr, ptr %n, align 8
  %18 = call i64 @Crt.solve(ptr %a41, ptr %n42, i32 3)
  %19 = trunc i64 %18 to i32
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %19)
  %21 = call i32 @Factorize.largestPrimeFactor(i32 360)
  %22 = call i32 @Factorize.factorCount(i32 360)
  %23 = call i32 @Factorize.largestPrimeFactor(i32 13)
  %24 = call i32 (ptr, ...) @printf(ptr @.str.16, i32 %21, i32 %22, i32 %23)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1324)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1326)
  ret ptr %strcpy
}

define internal i32 @NumberTheory.modInverse(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %tmpr = alloca i32, align 4
  %tmpt = alloca i32, align 4
  %q = alloca i32, align 4
  %exc.thrown10 = alloca ptr, align 8
  %newr = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %r = alloca i32, align 4
  %newt = alloca i32, align 4
  %t = alloca i32, align 4
  %m = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  store i32 %1, ptr %m, align 4
  store i32 0, ptr %t, align 4
  store i32 1, ptr %newt, align 4
  %m1 = load i32, ptr %m, align 4
  store i32 %m1, ptr %r, align 4
  %a2 = load i32, ptr %a, align 4
  %m3 = load i32, ptr %m, align 4
  %2 = icmp eq i32 %m3, 0
  %3 = icmp eq i32 %a2, -2147483648
  %4 = icmp eq i32 %m3, -1
  %5 = and i1 %3, %4
  %6 = or i1 %2, %5
  br i1 %6, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %7 = srem i32 %a2, %m3
  store i32 %7, ptr %newr, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok8, %div.ok
  %newr4 = load i32, ptr %newr, align 4
  %8 = icmp ne i32 %newr4, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %r5 = load i32, ptr %r, align 4
  %newr6 = load i32, ptr %newr, align 4
  %10 = icmp eq i32 %newr6, 0
  %11 = icmp eq i32 %r5, -2147483648
  %12 = icmp eq i32 %newr6, -1
  %13 = and i1 %11, %12
  %14 = or i1 %10, %13
  br i1 %14, label %div.bad7, label %div.ok8

while.end:                                        ; preds = %while.cond
  %r21 = load i32, ptr %r, align 4
  %15 = icmp sgt i32 %r21, 1
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then, label %if.end

div.bad7:                                         ; preds = %while.body
  %exc9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc9)
  store ptr %exc9, ptr %exc.thrown10, align 8
  call void @_CxxThrowException(ptr %exc.thrown10, ptr @_TI1PEAX)
  unreachable

div.ok8:                                          ; preds = %while.body
  %17 = sdiv i32 %r5, %newr6
  store i32 %17, ptr %q, align 4
  %t11 = load i32, ptr %t, align 4
  %q12 = load i32, ptr %q, align 4
  %newt13 = load i32, ptr %newt, align 4
  %18 = mul i32 %q12, %newt13
  %19 = sub i32 %t11, %18
  store i32 %19, ptr %tmpt, align 4
  %newt14 = load i32, ptr %newt, align 4
  store i32 %newt14, ptr %t, align 4
  %tmpt15 = load i32, ptr %tmpt, align 4
  store i32 %tmpt15, ptr %newt, align 4
  %r16 = load i32, ptr %r, align 4
  %q17 = load i32, ptr %q, align 4
  %newr18 = load i32, ptr %newr, align 4
  %20 = mul i32 %q17, %newr18
  %21 = sub i32 %r16, %20
  store i32 %21, ptr %tmpr, align 4
  %newr19 = load i32, ptr %newr, align 4
  store i32 %newr19, ptr %r, align 4
  %tmpr20 = load i32, ptr %tmpr, align 4
  store i32 %tmpr20, ptr %newr, align 4
  br label %while.cond

if.then:                                          ; preds = %while.end
  ret i32 -1

if.end:                                           ; preds = %while.end
  %t22 = load i32, ptr %t, align 4
  %22 = icmp slt i32 %t22, 0
  %23 = zext i1 %22 to i32
  br i1 %22, label %if.then23, label %if.end24

if.then23:                                        ; preds = %if.end
  %t25 = load i32, ptr %t, align 4
  %m26 = load i32, ptr %m, align 4
  %24 = add i32 %t25, %m26
  store i32 %24, ptr %t, align 4
  br label %if.end24

if.end24:                                         ; preds = %if.then23, %if.end
  %t27 = load i32, ptr %t, align 4
  ret i32 %t27
}

define internal i64 @Crt.solve(ptr %0, ptr %1, i32 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown68 = alloca ptr, align 8
  %exc.thrown62 = alloca ptr, align 8
  %t = alloca i64, align 8
  %exc.thrown51 = alloca ptr, align 8
  %diff = alloca i64, align 8
  %exc.thrown44 = alloca ptr, align 8
  %exc.thrown38 = alloca ptr, align 8
  %inv = alloca i64, align 8
  %exc.thrown = alloca ptr, align 8
  %ni = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca i64, align 8
  %x = alloca i64, align 8
  %k = alloca i32, align 4
  %n = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %n, align 8
  store i32 %2, ptr %k, align 4
  %a1 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3468, ptr @.faila.3469, i64 0, ptr @.failb.3470, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %a1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %3 = sext i32 %elem to i64
  store i64 %3, ptr %x, align 8
  %n2 = load ptr, ptr %n, align 8, !nonnull !0, !dereferenceable !1
  %arr.len3 = load i64, ptr %n2, align 8
  %arr.oob4 = icmp uge i64 0, %arr.len3
  br i1 %arr.oob4, label %idx.bad5, label %idx.ok6, !prof !2

idx.bad5:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3471, ptr @.faila.3472, i64 0, ptr @.failb.3473, i64 %arr.len3, i32 70)
  unreachable

idx.ok6:                                          ; preds = %idx.ok
  %arr.data7 = getelementptr i8, ptr %n2, i64 8
  %arr.elem8 = getelementptr inbounds i32, ptr %arr.data7, i64 0
  %elem9 = load i32, ptr %arr.elem8, align 4
  %4 = sext i32 %elem9 to i64
  store i64 %4, ptr %m, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok6
  %i10 = load i32, ptr %i, align 4
  %k11 = load i32, ptr %k, align 4
  %5 = icmp slt i32 %i10, %k11
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %n12 = load ptr, ptr %n, align 8, !nonnull !0, !dereferenceable !1
  %i13 = load i32, ptr %i, align 4
  %7 = sext i32 %i13 to i64
  %arr.len14 = load i64, ptr %n12, align 8
  %arr.oob15 = icmp uge i64 %7, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

for.update:                                       ; preds = %div.ok49
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %x57 = load i64, ptr %x, align 8
  %m58 = load i64, ptr %m, align 8
  %10 = icmp eq i64 %m58, 0
  %11 = icmp eq i64 %x57, -9223372036854775808
  %12 = icmp eq i64 %m58, -1
  %13 = and i1 %11, %12
  %14 = or i1 %10, %13
  br i1 %14, label %div.bad59, label %div.ok60

idx.bad16:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3474, ptr @.faila.3475, i64 %7, ptr @.failb.3476, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %for.body
  %arr.data18 = getelementptr i8, ptr %n12, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 %7
  %elem20 = load i32, ptr %arr.elem19, align 4
  store i32 %elem20, ptr %ni, align 4
  %m21 = load i64, ptr %m, align 8
  %ni22 = load i32, ptr %ni, align 4
  %15 = sext i32 %ni22 to i64
  %16 = icmp eq i64 %15, 0
  %17 = icmp eq i64 %m21, -9223372036854775808
  %18 = icmp eq i64 %15, -1
  %19 = and i1 %17, %18
  %20 = or i1 %16, %19
  br i1 %20, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok17
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok17
  %21 = srem i64 %m21, %15
  %22 = trunc i64 %21 to i32
  %ni23 = load i32, ptr %ni, align 4
  %23 = call i32 @NumberTheory.modInverse(i32 %22, i32 %ni23)
  %24 = sext i32 %23 to i64
  store i64 %24, ptr %inv, align 8
  %a24 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i25 = load i32, ptr %i, align 4
  %25 = sext i32 %i25 to i64
  %arr.len26 = load i64, ptr %a24, align 8
  %arr.oob27 = icmp uge i64 %25, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.3477, ptr @.faila.3478, i64 %25, ptr @.failb.3479, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %div.ok
  %arr.data30 = getelementptr i8, ptr %a24, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %25
  %elem32 = load i32, ptr %arr.elem31, align 4
  %26 = sext i32 %elem32 to i64
  %x33 = load i64, ptr %x, align 8
  %27 = sub i64 %26, %x33
  %ni34 = load i32, ptr %ni, align 4
  %28 = sext i32 %ni34 to i64
  %29 = icmp eq i64 %28, 0
  %30 = icmp eq i64 %27, -9223372036854775808
  %31 = icmp eq i64 %28, -1
  %32 = and i1 %30, %31
  %33 = or i1 %29, %32
  br i1 %33, label %div.bad35, label %div.ok36

div.bad35:                                        ; preds = %idx.ok29
  %exc37 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc37)
  store ptr %exc37, ptr %exc.thrown38, align 8
  call void @_CxxThrowException(ptr %exc.thrown38, ptr @_TI1PEAX)
  unreachable

div.ok36:                                         ; preds = %idx.ok29
  %34 = srem i64 %27, %28
  %ni39 = load i32, ptr %ni, align 4
  %35 = sext i32 %ni39 to i64
  %36 = add i64 %34, %35
  %ni40 = load i32, ptr %ni, align 4
  %37 = sext i32 %ni40 to i64
  %38 = icmp eq i64 %37, 0
  %39 = icmp eq i64 %36, -9223372036854775808
  %40 = icmp eq i64 %37, -1
  %41 = and i1 %39, %40
  %42 = or i1 %38, %41
  br i1 %42, label %div.bad41, label %div.ok42

div.bad41:                                        ; preds = %div.ok36
  %exc43 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc43)
  store ptr %exc43, ptr %exc.thrown44, align 8
  call void @_CxxThrowException(ptr %exc.thrown44, ptr @_TI1PEAX)
  unreachable

div.ok42:                                         ; preds = %div.ok36
  %43 = srem i64 %36, %37
  store i64 %43, ptr %diff, align 8
  %diff45 = load i64, ptr %diff, align 8
  %inv46 = load i64, ptr %inv, align 8
  %44 = mul i64 %diff45, %inv46
  %ni47 = load i32, ptr %ni, align 4
  %45 = sext i32 %ni47 to i64
  %46 = icmp eq i64 %45, 0
  %47 = icmp eq i64 %44, -9223372036854775808
  %48 = icmp eq i64 %45, -1
  %49 = and i1 %47, %48
  %50 = or i1 %46, %49
  br i1 %50, label %div.bad48, label %div.ok49

div.bad48:                                        ; preds = %div.ok42
  %exc50 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc50)
  store ptr %exc50, ptr %exc.thrown51, align 8
  call void @_CxxThrowException(ptr %exc.thrown51, ptr @_TI1PEAX)
  unreachable

div.ok49:                                         ; preds = %div.ok42
  %51 = srem i64 %44, %45
  store i64 %51, ptr %t, align 8
  %x52 = load i64, ptr %x, align 8
  %m53 = load i64, ptr %m, align 8
  %t54 = load i64, ptr %t, align 8
  %52 = mul i64 %m53, %t54
  %53 = add i64 %x52, %52
  store i64 %53, ptr %x, align 8
  %m55 = load i64, ptr %m, align 8
  %ni56 = load i32, ptr %ni, align 4
  %54 = sext i32 %ni56 to i64
  %55 = mul i64 %m55, %54
  store i64 %55, ptr %m, align 8
  br label %for.update

div.bad59:                                        ; preds = %for.end
  %exc61 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc61)
  store ptr %exc61, ptr %exc.thrown62, align 8
  call void @_CxxThrowException(ptr %exc.thrown62, ptr @_TI1PEAX)
  unreachable

div.ok60:                                         ; preds = %for.end
  %56 = srem i64 %x57, %m58
  %m63 = load i64, ptr %m, align 8
  %57 = add i64 %56, %m63
  %m64 = load i64, ptr %m, align 8
  %58 = icmp eq i64 %m64, 0
  %59 = icmp eq i64 %57, -9223372036854775808
  %60 = icmp eq i64 %m64, -1
  %61 = and i1 %59, %60
  %62 = or i1 %58, %61
  br i1 %62, label %div.bad65, label %div.ok66

div.bad65:                                        ; preds = %div.ok60
  %exc67 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc67)
  store ptr %exc67, ptr %exc.thrown68, align 8
  call void @_CxxThrowException(ptr %exc.thrown68, ptr @_TI1PEAX)
  unreachable

div.ok66:                                         ; preds = %div.ok60
  %63 = srem i64 %57, %m64
  ret i64 %63
}

define internal i32 @Factorize.largestPrimeFactor(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown16 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %d = alloca i64, align 8
  %largest = alloca i32, align 4
  %m = alloca i64, align 8
  %num = alloca i32, align 4
  store i32 %0, ptr %num, align 4
  %num1 = load i32, ptr %num, align 4
  %1 = sext i32 %num1 to i64
  store i64 %1, ptr %m, align 8
  store i32 1, ptr %largest, align 4
  store i64 2, ptr %d, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.end7, %entry
  %d2 = load i64, ptr %d, align 8
  %d3 = load i64, ptr %d, align 8
  %2 = mul i64 %d2, %d3
  %m4 = load i64, ptr %m, align 8
  %3 = icmp sle i64 %2, %m4
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  br label %while.cond5

while.end:                                        ; preds = %while.cond
  %m18 = load i64, ptr %m, align 8
  %5 = icmp sgt i64 %m18, 1
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

while.cond5:                                      ; preds = %div.ok14, %while.body
  %m8 = load i64, ptr %m, align 8
  %d9 = load i64, ptr %d, align 8
  %7 = icmp eq i64 %d9, 0
  %8 = icmp eq i64 %m8, -9223372036854775808
  %9 = icmp eq i64 %d9, -1
  %10 = and i1 %8, %9
  %11 = or i1 %7, %10
  br i1 %11, label %div.bad, label %div.ok

while.body6:                                      ; preds = %div.ok
  %d10 = load i64, ptr %d, align 8
  %12 = trunc i64 %d10 to i32
  store i32 %12, ptr %largest, align 4
  %m11 = load i64, ptr %m, align 8
  %d12 = load i64, ptr %d, align 8
  %13 = icmp eq i64 %d12, 0
  %14 = icmp eq i64 %m11, -9223372036854775808
  %15 = icmp eq i64 %d12, -1
  %16 = and i1 %14, %15
  %17 = or i1 %13, %16
  br i1 %17, label %div.bad13, label %div.ok14

while.end7:                                       ; preds = %div.ok
  %d17 = load i64, ptr %d, align 8
  %18 = add i64 %d17, 1
  store i64 %18, ptr %d, align 8
  br label %while.cond

div.bad:                                          ; preds = %while.cond5
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.cond5
  %19 = srem i64 %m8, %d9
  %20 = icmp eq i64 %19, 0
  %21 = zext i1 %20 to i32
  br i1 %20, label %while.body6, label %while.end7

div.bad13:                                        ; preds = %while.body6
  %exc15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc15)
  store ptr %exc15, ptr %exc.thrown16, align 8
  call void @_CxxThrowException(ptr %exc.thrown16, ptr @_TI1PEAX)
  unreachable

div.ok14:                                         ; preds = %while.body6
  %22 = sdiv i64 %m11, %d12
  store i64 %22, ptr %m, align 8
  br label %while.cond5

if.then:                                          ; preds = %while.end
  %m19 = load i64, ptr %m, align 8
  %23 = trunc i64 %m19 to i32
  store i32 %23, ptr %largest, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %while.end
  %largest20 = load i32, ptr %largest, align 4
  ret i32 %largest20
}

define internal i32 @Factorize.factorCount(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown16 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %d = alloca i32, align 4
  %count = alloca i32, align 4
  %m = alloca i32, align 4
  %num = alloca i32, align 4
  store i32 %0, ptr %num, align 4
  %num1 = load i32, ptr %num, align 4
  store i32 %num1, ptr %m, align 4
  store i32 0, ptr %count, align 4
  store i32 2, ptr %d, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.end7, %entry
  %d2 = load i32, ptr %d, align 4
  %d3 = load i32, ptr %d, align 4
  %1 = mul i32 %d2, %d3
  %m4 = load i32, ptr %m, align 4
  %2 = icmp sle i32 %1, %m4
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  br label %while.cond5

while.end:                                        ; preds = %while.cond
  %m18 = load i32, ptr %m, align 4
  %4 = icmp sgt i32 %m18, 1
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

while.cond5:                                      ; preds = %div.ok14, %while.body
  %m8 = load i32, ptr %m, align 4
  %d9 = load i32, ptr %d, align 4
  %6 = icmp eq i32 %d9, 0
  %7 = icmp eq i32 %m8, -2147483648
  %8 = icmp eq i32 %d9, -1
  %9 = and i1 %7, %8
  %10 = or i1 %6, %9
  br i1 %10, label %div.bad, label %div.ok

while.body6:                                      ; preds = %div.ok
  %count10 = load i32, ptr %count, align 4
  %11 = add i32 %count10, 1
  store i32 %11, ptr %count, align 4
  %m11 = load i32, ptr %m, align 4
  %d12 = load i32, ptr %d, align 4
  %12 = icmp eq i32 %d12, 0
  %13 = icmp eq i32 %m11, -2147483648
  %14 = icmp eq i32 %d12, -1
  %15 = and i1 %13, %14
  %16 = or i1 %12, %15
  br i1 %16, label %div.bad13, label %div.ok14

while.end7:                                       ; preds = %div.ok
  %d17 = load i32, ptr %d, align 4
  %17 = add i32 %d17, 1
  store i32 %17, ptr %d, align 4
  br label %while.cond

div.bad:                                          ; preds = %while.cond5
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.cond5
  %18 = srem i32 %m8, %d9
  %19 = icmp eq i32 %18, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %while.body6, label %while.end7

div.bad13:                                        ; preds = %while.body6
  %exc15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc15)
  store ptr %exc15, ptr %exc.thrown16, align 8
  call void @_CxxThrowException(ptr %exc.thrown16, ptr @_TI1PEAX)
  unreachable

div.ok14:                                         ; preds = %while.body6
  %21 = sdiv i32 %m11, %d12
  store i32 %21, ptr %m, align 4
  br label %while.cond5

if.then:                                          ; preds = %while.end
  %count19 = load i32, ptr %count, align 4
  %22 = add i32 %count19, 1
  store i32 %22, ptr %count, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %while.end
  %count20 = load i32, ptr %count, align 4
  ret i32 %count20
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5325)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5327)
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

declare i32 @printf(ptr, ...)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
