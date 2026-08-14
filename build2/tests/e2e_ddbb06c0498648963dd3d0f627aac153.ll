; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.RunningStats = type { ptr, i32, double, double }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@RunningStats.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @RunningStats.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @RunningStats.count, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @RunningStats.getMean, ptr @RunningStats.populationVariance, ptr @RunningStats.sampleVariance, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:15:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:15:35  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:15:47  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:16:23  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:16:35  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:16:47  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:18:42  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:18:42  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [11 x i8] c"x=%g y=%g\0A\00", align 1
@.fail.22 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:22:22  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:22:31  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:22:40  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:22:49  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:22:58  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:22:67  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:22:76  in main\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:22:85  in main\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_sci.pol:23:61  in main\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.49 = private unnamed_addr constant [24 x i8] c"mean=%g popvar=%g n=%d\0A\00", align 1
@.fail.3453 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5857:25  in GaussSolver.solve\0A\00", align 1
@.faila.3454 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3455 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3456 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5857:25  in GaussSolver.solve\0A\00", align 1
@.faila.3457 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3458 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3459 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5861:29  in GaussSolver.solve\0A\00", align 1
@.faila.3460 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3461 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3462 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5862:44  in GaussSolver.solve\0A\00", align 1
@.faila.3463 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3464 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3465 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5862:44  in GaussSolver.solve\0A\00", align 1
@.faila.3466 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3467 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3468 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5863:44  in GaussSolver.solve\0A\00", align 1
@.faila.3469 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3470 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3471 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5866:21  in GaussSolver.solve\0A\00", align 1
@.faila.3472 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3473 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3474 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5868:25  in GaussSolver.solve\0A\00", align 1
@.faila.3475 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3476 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3477 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5870:42  in GaussSolver.solve\0A\00", align 1
@.faila.3478 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3479 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3480 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5870:42  in GaussSolver.solve\0A\00", align 1
@.faila.3481 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3482 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3483 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5870:42  in GaussSolver.solve\0A\00", align 1
@.faila.3484 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3485 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3486 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5876:21  in GaussSolver.solve\0A\00", align 1
@.faila.3487 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3488 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3489 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5877:65  in GaussSolver.solve\0A\00", align 1
@.faila.3490 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3491 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3492 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5877:65  in GaussSolver.solve\0A\00", align 1
@.faila.3493 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3494 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3495 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5878:26  in GaussSolver.solve\0A\00", align 1
@.faila.3496 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3497 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3498 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5878:26  in GaussSolver.solve\0A\00", align 1
@.faila.3499 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3500 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5357 = private constant [1 x i8] zeroinitializer
@.strobj.5358 = private global %String { i64 0, ptr @.strdata.5357, i64 0 }
@.strdata.5359 = private constant [1 x i8] zeroinitializer
@.strobj.5360 = private global %String { i64 0, ptr @.strdata.5359, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %xs = alloca ptr, align 8
  %st = alloca ptr, align 8
  %x = alloca ptr, align 8
  %aug = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 56)
  store i64 6, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 48)
  store ptr %arr, ptr %aug, align 8
  %aug2 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %aug2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %aug2, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data3, i64 0
  store double 2.000000e+00, ptr %arr.elem, align 8
  %aug4 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %aug4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %aug4, i64 8
  %arr.elem10 = getelementptr inbounds double, ptr %arr.data9, i64 1
  store double 1.000000e+00, ptr %arr.elem10, align 8
  %aug11 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %aug11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %aug11, i64 8
  %arr.elem17 = getelementptr inbounds double, ptr %arr.data16, i64 2
  store double 5.000000e+00, ptr %arr.elem17, align 8
  %aug18 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %aug18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %aug18, i64 8
  %arr.elem24 = getelementptr inbounds double, ptr %arr.data23, i64 3
  store double 1.000000e+00, ptr %arr.elem24, align 8
  %aug25 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %arr.len26 = load i64, ptr %aug25, align 8
  %arr.oob27 = icmp uge i64 4, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %aug25, i64 8
  %arr.elem31 = getelementptr inbounds double, ptr %arr.data30, i64 4
  store double 3.000000e+00, ptr %arr.elem31, align 8
  %aug32 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %arr.len33 = load i64, ptr %aug32, align 8
  %arr.oob34 = icmp uge i64 5, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 5, ptr @.failb.15, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok29
  %arr.data37 = getelementptr i8, ptr %aug32, i64 8
  %arr.elem38 = getelementptr inbounds double, ptr %arr.data37, i64 5
  store double 1.000000e+01, ptr %arr.elem38, align 8
  %aug39 = load ptr, ptr %aug, align 8
  %17 = call ptr @GaussSolver.solve(ptr %aug39, i32 2)
  store ptr %17, ptr %x, align 8
  %x40 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %arr.len41 = load i64, ptr %x40, align 8
  %arr.oob42 = icmp uge i64 0, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !2

idx.bad43:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 0, ptr @.failb.18, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %idx.ok36
  %arr.data45 = getelementptr i8, ptr %x40, i64 8
  %arr.elem46 = getelementptr inbounds double, ptr %arr.data45, i64 0
  %elem = load double, ptr %arr.elem46, align 8
  %x47 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %arr.len48 = load i64, ptr %x47, align 8
  %arr.oob49 = icmp uge i64 1, %arr.len48
  br i1 %arr.oob49, label %idx.bad50, label %idx.ok51, !prof !2

idx.bad50:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 1, ptr @.failb.21, i64 %arr.len48, i32 70)
  unreachable

idx.ok51:                                         ; preds = %idx.ok44
  %arr.data52 = getelementptr i8, ptr %x47, i64 8
  %arr.elem53 = getelementptr inbounds double, ptr %arr.data52, i64 1
  %elem54 = load double, ptr %arr.elem53, align 8
  %18 = call i32 (ptr, ...) @printf(ptr @.str, double %elem, double %elem54)
  %RunningStats.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.RunningStats, ptr null, i64 1) to i64))
  call void @RunningStats.RunningStats(ptr %RunningStats.obj)
  store ptr %RunningStats.obj, ptr %st, align 8
  %arr55 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr55, align 8
  %arr.data56 = getelementptr i8, ptr %arr55, i64 8
  %19 = call ptr @memset(ptr %arr.data56, i32 0, i64 32)
  store ptr %arr55, ptr %xs, align 8
  %xs57 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len58 = load i64, ptr %xs57, align 8
  %arr.oob59 = icmp uge i64 0, %arr.len58
  br i1 %arr.oob59, label %idx.bad60, label %idx.ok61, !prof !2

idx.bad60:                                        ; preds = %idx.ok51
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 0, ptr @.failb.24, i64 %arr.len58, i32 70)
  unreachable

idx.ok61:                                         ; preds = %idx.ok51
  %arr.data62 = getelementptr i8, ptr %xs57, i64 8
  %arr.elem63 = getelementptr inbounds i32, ptr %arr.data62, i64 0
  store i32 2, ptr %arr.elem63, align 4
  %xs64 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len65 = load i64, ptr %xs64, align 8
  %arr.oob66 = icmp uge i64 1, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !2

idx.bad67:                                        ; preds = %idx.ok61
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 1, ptr @.failb.27, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %idx.ok61
  %arr.data69 = getelementptr i8, ptr %xs64, i64 8
  %arr.elem70 = getelementptr inbounds i32, ptr %arr.data69, i64 1
  store i32 4, ptr %arr.elem70, align 4
  %xs71 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len72 = load i64, ptr %xs71, align 8
  %arr.oob73 = icmp uge i64 2, %arr.len72
  br i1 %arr.oob73, label %idx.bad74, label %idx.ok75, !prof !2

idx.bad74:                                        ; preds = %idx.ok68
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 2, ptr @.failb.30, i64 %arr.len72, i32 70)
  unreachable

idx.ok75:                                         ; preds = %idx.ok68
  %arr.data76 = getelementptr i8, ptr %xs71, i64 8
  %arr.elem77 = getelementptr inbounds i32, ptr %arr.data76, i64 2
  store i32 4, ptr %arr.elem77, align 4
  %xs78 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len79 = load i64, ptr %xs78, align 8
  %arr.oob80 = icmp uge i64 3, %arr.len79
  br i1 %arr.oob80, label %idx.bad81, label %idx.ok82, !prof !2

idx.bad81:                                        ; preds = %idx.ok75
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 3, ptr @.failb.33, i64 %arr.len79, i32 70)
  unreachable

idx.ok82:                                         ; preds = %idx.ok75
  %arr.data83 = getelementptr i8, ptr %xs78, i64 8
  %arr.elem84 = getelementptr inbounds i32, ptr %arr.data83, i64 3
  store i32 4, ptr %arr.elem84, align 4
  %xs85 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len86 = load i64, ptr %xs85, align 8
  %arr.oob87 = icmp uge i64 4, %arr.len86
  br i1 %arr.oob87, label %idx.bad88, label %idx.ok89, !prof !2

idx.bad88:                                        ; preds = %idx.ok82
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 4, ptr @.failb.36, i64 %arr.len86, i32 70)
  unreachable

idx.ok89:                                         ; preds = %idx.ok82
  %arr.data90 = getelementptr i8, ptr %xs85, i64 8
  %arr.elem91 = getelementptr inbounds i32, ptr %arr.data90, i64 4
  store i32 5, ptr %arr.elem91, align 4
  %xs92 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len93 = load i64, ptr %xs92, align 8
  %arr.oob94 = icmp uge i64 5, %arr.len93
  br i1 %arr.oob94, label %idx.bad95, label %idx.ok96, !prof !2

idx.bad95:                                        ; preds = %idx.ok89
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 5, ptr @.failb.39, i64 %arr.len93, i32 70)
  unreachable

idx.ok96:                                         ; preds = %idx.ok89
  %arr.data97 = getelementptr i8, ptr %xs92, i64 8
  %arr.elem98 = getelementptr inbounds i32, ptr %arr.data97, i64 5
  store i32 5, ptr %arr.elem98, align 4
  %xs99 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len100 = load i64, ptr %xs99, align 8
  %arr.oob101 = icmp uge i64 6, %arr.len100
  br i1 %arr.oob101, label %idx.bad102, label %idx.ok103, !prof !2

idx.bad102:                                       ; preds = %idx.ok96
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 6, ptr @.failb.42, i64 %arr.len100, i32 70)
  unreachable

idx.ok103:                                        ; preds = %idx.ok96
  %arr.data104 = getelementptr i8, ptr %xs99, i64 8
  %arr.elem105 = getelementptr inbounds i32, ptr %arr.data104, i64 6
  store i32 7, ptr %arr.elem105, align 4
  %xs106 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len107 = load i64, ptr %xs106, align 8
  %arr.oob108 = icmp uge i64 7, %arr.len107
  br i1 %arr.oob108, label %idx.bad109, label %idx.ok110, !prof !2

idx.bad109:                                       ; preds = %idx.ok103
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 7, ptr @.failb.45, i64 %arr.len107, i32 70)
  unreachable

idx.ok110:                                        ; preds = %idx.ok103
  %arr.data111 = getelementptr i8, ptr %xs106, i64 8
  %arr.elem112 = getelementptr inbounds i32, ptr %arr.data111, i64 7
  store i32 9, ptr %arr.elem112, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok110
  %i113 = load i32, ptr %i, align 4
  %20 = icmp slt i32 %i113, 8
  %21 = zext i1 %20 to i32
  br i1 %20, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %st114 = load ptr, ptr %st, align 8
  %xs115 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i116 = load i32, ptr %i, align 4
  %22 = sext i32 %i116 to i64
  %arr.len117 = load i64, ptr %xs115, align 8
  %arr.oob118 = icmp uge i64 %22, %arr.len117
  br i1 %arr.oob118, label %idx.bad119, label %idx.ok120, !prof !2

for.update:                                       ; preds = %idx.ok120
  %23 = load i32, ptr %i, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %st124 = load ptr, ptr %st, align 8
  %25 = call double @RunningStats.getMean(ptr %st124)
  %st125 = load ptr, ptr %st, align 8
  %26 = call double @RunningStats.populationVariance(ptr %st125)
  %st126 = load ptr, ptr %st, align 8
  %27 = call i32 @RunningStats.count(ptr %st126)
  %28 = call i32 (ptr, ...) @printf(ptr @.str.49, double %25, double %26, i32 %27)
  ret i32 0

idx.bad119:                                       ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 %22, ptr @.failb.48, i64 %arr.len117, i32 70)
  unreachable

idx.ok120:                                        ; preds = %for.body
  %arr.data121 = getelementptr i8, ptr %xs115, i64 8
  %arr.elem122 = getelementptr inbounds i32, ptr %arr.data121, i64 %22
  %elem123 = load i32, ptr %arr.elem122, align 4
  %29 = sitofp i32 %elem123 to double
  call void @RunningStats.add(ptr %st114, double %29)
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

define internal double @GaussSolver.dabs(double %0) {
entry:
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = fcmp olt double %x1, 0.000000e+00
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %x2 = load double, ptr %x, align 8
  %3 = fsub double 0.000000e+00, %x2
  ret double %3

if.end:                                           ; preds = %entry
  %x3 = load double, ptr %x, align 8
  ret double %x3
}

define internal ptr @GaussSolver.solve(ptr %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %s = alloca double, align 8
  %i = alloca i32, align 4
  %x = alloca ptr, align 8
  %c113 = alloca i32, align 4
  %factor = alloca double, align 8
  %r93 = alloca i32, align 4
  %d = alloca double, align 8
  %tmp = alloca double, align 8
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  %piv = alloca i32, align 4
  %col = alloca i32, align 4
  %w = alloca i32, align 4
  %n = alloca i32, align 4
  %aug = alloca ptr, align 8
  store ptr %0, ptr %aug, align 8
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %2 = add i32 %n1, 1
  store i32 %2, ptr %w, align 4
  store i32 0, ptr %col, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %col2 = load i32, ptr %col, align 4
  %n3 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %col2, %n3
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %col4 = load i32, ptr %col, align 4
  store i32 %col4, ptr %piv, align 4
  %col5 = load i32, ptr %col, align 4
  %5 = add i32 %col5, 1
  store i32 %5, ptr %r, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end97
  %6 = load i32, ptr %col, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %col, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %n153 = load i32, ptr %n, align 4
  %8 = sext i32 %n153 to i64
  %9 = mul i64 %8, 8
  %10 = add i64 8, %9
  %arr = call ptr @__polaron_malloc(i64 %10)
  store i64 %8, ptr %arr, align 8
  %arr.data154 = getelementptr i8, ptr %arr, i64 8
  %11 = call ptr @memset(ptr %arr.data154, i32 0, i64 %9)
  store ptr %arr, ptr %x, align 8
  %n155 = load i32, ptr %n, align 4
  %12 = sub i32 %n155, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond156

for.cond6:                                        ; preds = %for.update8, %for.body
  %r10 = load i32, ptr %r, align 4
  %n11 = load i32, ptr %n, align 4
  %13 = icmp slt i32 %r10, %n11
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %aug12 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %r13 = load i32, ptr %r, align 4
  %w14 = load i32, ptr %w, align 4
  %15 = mul i32 %r13, %w14
  %col15 = load i32, ptr %col, align 4
  %16 = add i32 %15, %col15
  %17 = sext i32 %16 to i64
  %arr.len = load i64, ptr %aug12, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update8:                                      ; preds = %if.end
  %18 = load i32, ptr %r, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %r, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  %piv28 = load i32, ptr %piv, align 4
  %col29 = load i32, ptr %col, align 4
  %20 = icmp ne i32 %piv28, %col29
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then30, label %if.end31

idx.bad:                                          ; preds = %for.body7
  call void @__polaron_fail(ptr @.fail.3453, ptr @.faila.3454, i64 %17, ptr @.failb.3455, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body7
  %arr.data = getelementptr i8, ptr %aug12, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %17
  %elem = load double, ptr %arr.elem, align 8
  %22 = call double @GaussSolver.dabs(double %elem)
  %aug16 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %piv17 = load i32, ptr %piv, align 4
  %w18 = load i32, ptr %w, align 4
  %23 = mul i32 %piv17, %w18
  %col19 = load i32, ptr %col, align 4
  %24 = add i32 %23, %col19
  %25 = sext i32 %24 to i64
  %arr.len20 = load i64, ptr %aug16, align 8
  %arr.oob21 = icmp uge i64 %25, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3456, ptr @.faila.3457, i64 %25, ptr @.failb.3458, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %aug16, i64 8
  %arr.elem25 = getelementptr inbounds double, ptr %arr.data24, i64 %25
  %elem26 = load double, ptr %arr.elem25, align 8
  %26 = call double @GaussSolver.dabs(double %elem26)
  %27 = fcmp ogt double %22, %26
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok23
  %r27 = load i32, ptr %r, align 4
  store i32 %r27, ptr %piv, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok23
  br label %for.update8

if.then30:                                        ; preds = %for.end9
  store i32 0, ptr %c, align 4
  br label %for.cond32

if.end31:                                         ; preds = %for.end35, %for.end9
  %aug81 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %col82 = load i32, ptr %col, align 4
  %w83 = load i32, ptr %w, align 4
  %29 = mul i32 %col82, %w83
  %col84 = load i32, ptr %col, align 4
  %30 = add i32 %29, %col84
  %31 = sext i32 %30 to i64
  %arr.len85 = load i64, ptr %aug81, align 8
  %arr.oob86 = icmp uge i64 %31, %arr.len85
  br i1 %arr.oob86, label %idx.bad87, label %idx.ok88, !prof !2

for.cond32:                                       ; preds = %for.update34, %if.then30
  %c36 = load i32, ptr %c, align 4
  %w37 = load i32, ptr %w, align 4
  %32 = icmp slt i32 %c36, %w37
  %33 = zext i1 %32 to i32
  br i1 %32, label %for.body33, label %for.end35

for.body33:                                       ; preds = %for.cond32
  %aug38 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %col39 = load i32, ptr %col, align 4
  %w40 = load i32, ptr %w, align 4
  %34 = mul i32 %col39, %w40
  %c41 = load i32, ptr %c, align 4
  %35 = add i32 %34, %c41
  %36 = sext i32 %35 to i64
  %arr.len42 = load i64, ptr %aug38, align 8
  %arr.oob43 = icmp uge i64 %36, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !2

for.update34:                                     ; preds = %idx.ok77
  %37 = load i32, ptr %c, align 4
  %38 = add i32 %37, 1
  store i32 %38, ptr %c, align 4
  br label %for.cond32

for.end35:                                        ; preds = %for.cond32
  br label %if.end31

idx.bad44:                                        ; preds = %for.body33
  call void @__polaron_fail(ptr @.fail.3459, ptr @.faila.3460, i64 %36, ptr @.failb.3461, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %for.body33
  %arr.data46 = getelementptr i8, ptr %aug38, i64 8
  %arr.elem47 = getelementptr inbounds double, ptr %arr.data46, i64 %36
  %elem48 = load double, ptr %arr.elem47, align 8
  store double %elem48, ptr %tmp, align 8
  %aug49 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %col50 = load i32, ptr %col, align 4
  %w51 = load i32, ptr %w, align 4
  %39 = mul i32 %col50, %w51
  %c52 = load i32, ptr %c, align 4
  %40 = add i32 %39, %c52
  %41 = sext i32 %40 to i64
  %arr.len53 = load i64, ptr %aug49, align 8
  %arr.oob54 = icmp uge i64 %41, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !2

idx.bad55:                                        ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.fail.3462, ptr @.faila.3463, i64 %41, ptr @.failb.3464, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok45
  %arr.data57 = getelementptr i8, ptr %aug49, i64 8
  %arr.elem58 = getelementptr inbounds double, ptr %arr.data57, i64 %41
  %aug59 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %piv60 = load i32, ptr %piv, align 4
  %w61 = load i32, ptr %w, align 4
  %42 = mul i32 %piv60, %w61
  %c62 = load i32, ptr %c, align 4
  %43 = add i32 %42, %c62
  %44 = sext i32 %43 to i64
  %arr.len63 = load i64, ptr %aug59, align 8
  %arr.oob64 = icmp uge i64 %44, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !2

idx.bad65:                                        ; preds = %idx.ok56
  call void @__polaron_fail(ptr @.fail.3465, ptr @.faila.3466, i64 %44, ptr @.failb.3467, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %idx.ok56
  %arr.data67 = getelementptr i8, ptr %aug59, i64 8
  %arr.elem68 = getelementptr inbounds double, ptr %arr.data67, i64 %44
  %elem69 = load double, ptr %arr.elem68, align 8
  store double %elem69, ptr %arr.elem58, align 8
  %aug70 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %piv71 = load i32, ptr %piv, align 4
  %w72 = load i32, ptr %w, align 4
  %45 = mul i32 %piv71, %w72
  %c73 = load i32, ptr %c, align 4
  %46 = add i32 %45, %c73
  %47 = sext i32 %46 to i64
  %arr.len74 = load i64, ptr %aug70, align 8
  %arr.oob75 = icmp uge i64 %47, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !2

idx.bad76:                                        ; preds = %idx.ok66
  call void @__polaron_fail(ptr @.fail.3468, ptr @.faila.3469, i64 %47, ptr @.failb.3470, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %idx.ok66
  %arr.data78 = getelementptr i8, ptr %aug70, i64 8
  %arr.elem79 = getelementptr inbounds double, ptr %arr.data78, i64 %47
  %tmp80 = load double, ptr %tmp, align 8
  store double %tmp80, ptr %arr.elem79, align 8
  br label %for.update34

idx.bad87:                                        ; preds = %if.end31
  call void @__polaron_fail(ptr @.fail.3471, ptr @.faila.3472, i64 %31, ptr @.failb.3473, i64 %arr.len85, i32 70)
  unreachable

idx.ok88:                                         ; preds = %if.end31
  %arr.data89 = getelementptr i8, ptr %aug81, i64 8
  %arr.elem90 = getelementptr inbounds double, ptr %arr.data89, i64 %31
  %elem91 = load double, ptr %arr.elem90, align 8
  store double %elem91, ptr %d, align 8
  %col92 = load i32, ptr %col, align 4
  %48 = add i32 %col92, 1
  store i32 %48, ptr %r93, align 4
  br label %for.cond94

for.cond94:                                       ; preds = %for.update96, %idx.ok88
  %r98 = load i32, ptr %r93, align 4
  %n99 = load i32, ptr %n, align 4
  %49 = icmp slt i32 %r98, %n99
  %50 = zext i1 %49 to i32
  br i1 %49, label %for.body95, label %for.end97

for.body95:                                       ; preds = %for.cond94
  %aug100 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %r101 = load i32, ptr %r93, align 4
  %w102 = load i32, ptr %w, align 4
  %51 = mul i32 %r101, %w102
  %col103 = load i32, ptr %col, align 4
  %52 = add i32 %51, %col103
  %53 = sext i32 %52 to i64
  %arr.len104 = load i64, ptr %aug100, align 8
  %arr.oob105 = icmp uge i64 %53, %arr.len104
  br i1 %arr.oob105, label %idx.bad106, label %idx.ok107, !prof !2

for.update96:                                     ; preds = %for.end117
  %54 = load i32, ptr %r93, align 4
  %55 = add i32 %54, 1
  store i32 %55, ptr %r93, align 4
  br label %for.cond94

for.end97:                                        ; preds = %for.cond94
  br label %for.update

idx.bad106:                                       ; preds = %for.body95
  call void @__polaron_fail(ptr @.fail.3474, ptr @.faila.3475, i64 %53, ptr @.failb.3476, i64 %arr.len104, i32 70)
  unreachable

idx.ok107:                                        ; preds = %for.body95
  %arr.data108 = getelementptr i8, ptr %aug100, i64 8
  %arr.elem109 = getelementptr inbounds double, ptr %arr.data108, i64 %53
  %elem110 = load double, ptr %arr.elem109, align 8
  %d111 = load double, ptr %d, align 8
  %56 = fdiv double %elem110, %d111
  store double %56, ptr %factor, align 8
  %col112 = load i32, ptr %col, align 4
  store i32 %col112, ptr %c113, align 4
  br label %for.cond114

for.cond114:                                      ; preds = %for.update116, %idx.ok107
  %c118 = load i32, ptr %c113, align 4
  %w119 = load i32, ptr %w, align 4
  %57 = icmp slt i32 %c118, %w119
  %58 = zext i1 %57 to i32
  br i1 %57, label %for.body115, label %for.end117

for.body115:                                      ; preds = %for.cond114
  %aug120 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %r121 = load i32, ptr %r93, align 4
  %w122 = load i32, ptr %w, align 4
  %59 = mul i32 %r121, %w122
  %c123 = load i32, ptr %c113, align 4
  %60 = add i32 %59, %c123
  %61 = sext i32 %60 to i64
  %arr.len124 = load i64, ptr %aug120, align 8
  %arr.oob125 = icmp uge i64 %61, %arr.len124
  br i1 %arr.oob125, label %idx.bad126, label %idx.ok127, !prof !2

for.update116:                                    ; preds = %idx.ok149
  %62 = load i32, ptr %c113, align 4
  %63 = add i32 %62, 1
  store i32 %63, ptr %c113, align 4
  br label %for.cond114

for.end117:                                       ; preds = %for.cond114
  br label %for.update96

idx.bad126:                                       ; preds = %for.body115
  call void @__polaron_fail(ptr @.fail.3477, ptr @.faila.3478, i64 %61, ptr @.failb.3479, i64 %arr.len124, i32 70)
  unreachable

idx.ok127:                                        ; preds = %for.body115
  %arr.data128 = getelementptr i8, ptr %aug120, i64 8
  %arr.elem129 = getelementptr inbounds double, ptr %arr.data128, i64 %61
  %aug130 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %r131 = load i32, ptr %r93, align 4
  %w132 = load i32, ptr %w, align 4
  %64 = mul i32 %r131, %w132
  %c133 = load i32, ptr %c113, align 4
  %65 = add i32 %64, %c133
  %66 = sext i32 %65 to i64
  %arr.len134 = load i64, ptr %aug130, align 8
  %arr.oob135 = icmp uge i64 %66, %arr.len134
  br i1 %arr.oob135, label %idx.bad136, label %idx.ok137, !prof !2

idx.bad136:                                       ; preds = %idx.ok127
  call void @__polaron_fail(ptr @.fail.3480, ptr @.faila.3481, i64 %66, ptr @.failb.3482, i64 %arr.len134, i32 70)
  unreachable

idx.ok137:                                        ; preds = %idx.ok127
  %arr.data138 = getelementptr i8, ptr %aug130, i64 8
  %arr.elem139 = getelementptr inbounds double, ptr %arr.data138, i64 %66
  %elem140 = load double, ptr %arr.elem139, align 8
  %factor141 = load double, ptr %factor, align 8
  %aug142 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %col143 = load i32, ptr %col, align 4
  %w144 = load i32, ptr %w, align 4
  %67 = mul i32 %col143, %w144
  %c145 = load i32, ptr %c113, align 4
  %68 = add i32 %67, %c145
  %69 = sext i32 %68 to i64
  %arr.len146 = load i64, ptr %aug142, align 8
  %arr.oob147 = icmp uge i64 %69, %arr.len146
  br i1 %arr.oob147, label %idx.bad148, label %idx.ok149, !prof !2

idx.bad148:                                       ; preds = %idx.ok137
  call void @__polaron_fail(ptr @.fail.3483, ptr @.faila.3484, i64 %69, ptr @.failb.3485, i64 %arr.len146, i32 70)
  unreachable

idx.ok149:                                        ; preds = %idx.ok137
  %arr.data150 = getelementptr i8, ptr %aug142, i64 8
  %arr.elem151 = getelementptr inbounds double, ptr %arr.data150, i64 %69
  %elem152 = load double, ptr %arr.elem151, align 8
  %70 = fmul double %factor141, %elem152
  %71 = fsub double %elem140, %70
  store double %71, ptr %arr.elem129, align 8
  br label %for.update116

for.cond156:                                      ; preds = %for.update158, %for.end
  %i160 = load i32, ptr %i, align 4
  %72 = icmp sge i32 %i160, 0
  %73 = zext i1 %72 to i32
  br i1 %72, label %for.body157, label %for.end159

for.body157:                                      ; preds = %for.cond156
  %aug161 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %i162 = load i32, ptr %i, align 4
  %w163 = load i32, ptr %w, align 4
  %74 = mul i32 %i162, %w163
  %n164 = load i32, ptr %n, align 4
  %75 = add i32 %74, %n164
  %76 = sext i32 %75 to i64
  %arr.len165 = load i64, ptr %aug161, align 8
  %arr.oob166 = icmp uge i64 %76, %arr.len165
  br i1 %arr.oob166, label %idx.bad167, label %idx.ok168, !prof !2

for.update158:                                    ; preds = %idx.ok216
  %i220 = load i32, ptr %i, align 4
  %77 = sub i32 %i220, 1
  store i32 %77, ptr %i, align 4
  br label %for.cond156

for.end159:                                       ; preds = %for.cond156
  %x221 = load ptr, ptr %x, align 8
  ret ptr %x221

idx.bad167:                                       ; preds = %for.body157
  call void @__polaron_fail(ptr @.fail.3486, ptr @.faila.3487, i64 %76, ptr @.failb.3488, i64 %arr.len165, i32 70)
  unreachable

idx.ok168:                                        ; preds = %for.body157
  %arr.data169 = getelementptr i8, ptr %aug161, i64 8
  %arr.elem170 = getelementptr inbounds double, ptr %arr.data169, i64 %76
  %elem171 = load double, ptr %arr.elem170, align 8
  store double %elem171, ptr %s, align 8
  %i172 = load i32, ptr %i, align 4
  %78 = add i32 %i172, 1
  store i32 %78, ptr %j, align 4
  br label %for.cond173

for.cond173:                                      ; preds = %for.update175, %idx.ok168
  %j177 = load i32, ptr %j, align 4
  %n178 = load i32, ptr %n, align 4
  %79 = icmp slt i32 %j177, %n178
  %80 = zext i1 %79 to i32
  br i1 %79, label %for.body174, label %for.end176

for.body174:                                      ; preds = %for.cond173
  %s179 = load double, ptr %s, align 8
  %aug180 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %i181 = load i32, ptr %i, align 4
  %w182 = load i32, ptr %w, align 4
  %81 = mul i32 %i181, %w182
  %j183 = load i32, ptr %j, align 4
  %82 = add i32 %81, %j183
  %83 = sext i32 %82 to i64
  %arr.len184 = load i64, ptr %aug180, align 8
  %arr.oob185 = icmp uge i64 %83, %arr.len184
  br i1 %arr.oob185, label %idx.bad186, label %idx.ok187, !prof !2

for.update175:                                    ; preds = %idx.ok196
  %84 = load i32, ptr %j, align 4
  %85 = add i32 %84, 1
  store i32 %85, ptr %j, align 4
  br label %for.cond173

for.end176:                                       ; preds = %for.cond173
  %x200 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i201 = load i32, ptr %i, align 4
  %86 = sext i32 %i201 to i64
  %arr.len202 = load i64, ptr %x200, align 8
  %arr.oob203 = icmp uge i64 %86, %arr.len202
  br i1 %arr.oob203, label %idx.bad204, label %idx.ok205, !prof !2

idx.bad186:                                       ; preds = %for.body174
  call void @__polaron_fail(ptr @.fail.3489, ptr @.faila.3490, i64 %83, ptr @.failb.3491, i64 %arr.len184, i32 70)
  unreachable

idx.ok187:                                        ; preds = %for.body174
  %arr.data188 = getelementptr i8, ptr %aug180, i64 8
  %arr.elem189 = getelementptr inbounds double, ptr %arr.data188, i64 %83
  %elem190 = load double, ptr %arr.elem189, align 8
  %x191 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %j192 = load i32, ptr %j, align 4
  %87 = sext i32 %j192 to i64
  %arr.len193 = load i64, ptr %x191, align 8
  %arr.oob194 = icmp uge i64 %87, %arr.len193
  br i1 %arr.oob194, label %idx.bad195, label %idx.ok196, !prof !2

idx.bad195:                                       ; preds = %idx.ok187
  call void @__polaron_fail(ptr @.fail.3492, ptr @.faila.3493, i64 %87, ptr @.failb.3494, i64 %arr.len193, i32 70)
  unreachable

idx.ok196:                                        ; preds = %idx.ok187
  %arr.data197 = getelementptr i8, ptr %x191, i64 8
  %arr.elem198 = getelementptr inbounds double, ptr %arr.data197, i64 %87
  %elem199 = load double, ptr %arr.elem198, align 8
  %88 = fmul double %elem190, %elem199
  %89 = fsub double %s179, %88
  store double %89, ptr %s, align 8
  br label %for.update175

idx.bad204:                                       ; preds = %for.end176
  call void @__polaron_fail(ptr @.fail.3495, ptr @.faila.3496, i64 %86, ptr @.failb.3497, i64 %arr.len202, i32 70)
  unreachable

idx.ok205:                                        ; preds = %for.end176
  %arr.data206 = getelementptr i8, ptr %x200, i64 8
  %arr.elem207 = getelementptr inbounds double, ptr %arr.data206, i64 %86
  %s208 = load double, ptr %s, align 8
  %aug209 = load ptr, ptr %aug, align 8, !nonnull !0, !dereferenceable !1
  %i210 = load i32, ptr %i, align 4
  %w211 = load i32, ptr %w, align 4
  %90 = mul i32 %i210, %w211
  %i212 = load i32, ptr %i, align 4
  %91 = add i32 %90, %i212
  %92 = sext i32 %91 to i64
  %arr.len213 = load i64, ptr %aug209, align 8
  %arr.oob214 = icmp uge i64 %92, %arr.len213
  br i1 %arr.oob214, label %idx.bad215, label %idx.ok216, !prof !2

idx.bad215:                                       ; preds = %idx.ok205
  call void @__polaron_fail(ptr @.fail.3498, ptr @.faila.3499, i64 %92, ptr @.failb.3500, i64 %arr.len213, i32 70)
  unreachable

idx.ok216:                                        ; preds = %idx.ok205
  %arr.data217 = getelementptr i8, ptr %aug209, i64 8
  %arr.elem218 = getelementptr inbounds double, ptr %arr.data217, i64 %92
  %elem219 = load double, ptr %arr.elem218, align 8
  %93 = fdiv double %s208, %elem219
  store double %93, ptr %arr.elem207, align 8
  br label %for.update158
}

define internal void @RunningStats.RunningStats(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 0
  store ptr @RunningStats.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %cnt = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  store i32 0, ptr %cnt, align 4, !tbaa !7
  %mean = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 2
  store double 0.000000e+00, ptr %mean, align 8, !tbaa !9
  %m2 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 3
  store double 0.000000e+00, ptr %m2, align 8, !tbaa !9
  ret void
}

define internal void @RunningStats.add(ptr nonnull align 8 dereferenceable(32) %0, double %1) {
entry:
  %delta2 = alloca double, align 8
  %delta = alloca double, align 8
  %x = alloca double, align 8
  store double %1, ptr %x, align 8
  %cnt = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  %cnt1 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  %cnt2 = load i32, ptr %cnt1, align 4, !tbaa !7
  %2 = add i32 %cnt2, 1
  store i32 %2, ptr %cnt, align 4, !tbaa !7
  %x3 = load double, ptr %x, align 8
  %mean = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 2
  %mean4 = load double, ptr %mean, align 8, !tbaa !9
  %3 = fsub double %x3, %mean4
  store double %3, ptr %delta, align 8
  %mean5 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 2
  %mean6 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 2
  %mean7 = load double, ptr %mean6, align 8, !tbaa !9
  %delta8 = load double, ptr %delta, align 8
  %cnt9 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  %cnt10 = load i32, ptr %cnt9, align 4, !tbaa !7
  %4 = sitofp i32 %cnt10 to double
  %5 = fdiv double %delta8, %4
  %6 = fadd double %mean7, %5
  store double %6, ptr %mean5, align 8, !tbaa !9
  %x11 = load double, ptr %x, align 8
  %mean12 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 2
  %mean13 = load double, ptr %mean12, align 8, !tbaa !9
  %7 = fsub double %x11, %mean13
  store double %7, ptr %delta2, align 8
  %m2 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 3
  %m214 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 3
  %m215 = load double, ptr %m214, align 8, !tbaa !9
  %delta16 = load double, ptr %delta, align 8
  %delta217 = load double, ptr %delta2, align 8
  %8 = fmul double %delta16, %delta217
  %9 = fadd double %m215, %8
  store double %9, ptr %m2, align 8, !tbaa !9
  ret void
}

define internal double @RunningStats.getMean(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %mean = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 2
  %mean1 = load double, ptr %mean, align 8, !tbaa !9
  ret double %mean1
}

define internal double @RunningStats.populationVariance(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %cnt = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  %cnt1 = load i32, ptr %cnt, align 4, !tbaa !7
  %1 = icmp slt i32 %cnt1, 1
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret double 0.000000e+00

if.end:                                           ; preds = %entry
  %m2 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 3
  %m22 = load double, ptr %m2, align 8, !tbaa !9
  %cnt3 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  %cnt4 = load i32, ptr %cnt3, align 4, !tbaa !7
  %3 = sitofp i32 %cnt4 to double
  %4 = fdiv double %m22, %3
  ret double %4
}

define internal double @RunningStats.sampleVariance(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %cnt = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  %cnt1 = load i32, ptr %cnt, align 4, !tbaa !7
  %1 = icmp slt i32 %cnt1, 2
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret double 0.000000e+00

if.end:                                           ; preds = %entry
  %m2 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 3
  %m22 = load double, ptr %m2, align 8, !tbaa !9
  %cnt3 = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  %cnt4 = load i32, ptr %cnt3, align 4, !tbaa !7
  %3 = sub i32 %cnt4, 1
  %4 = sitofp i32 %3 to double
  %5 = fdiv double %m22, %4
  ret double %5
}

define internal i32 @RunningStats.count(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %cnt = getelementptr inbounds %class.RunningStats, ptr %0, i32 0, i32 1
  %cnt1 = load i32, ptr %cnt, align 4, !tbaa !7
  ret i32 %cnt1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5358)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5360)
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
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !5, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"f64", !5, i64 0}
