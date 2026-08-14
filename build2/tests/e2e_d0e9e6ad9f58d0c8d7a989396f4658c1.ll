; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Regression = type { ptr, double, double, double }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Regression.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Regression.getSlope, ptr @Regression.getIntercept, ptr @Regression.getR2, ptr @Regression.predict, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol:14:21  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol:14:31  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol:14:41  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol:14:51  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol:15:21  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol:15:31  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol:15:41  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regression.pol:15:51  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [62 x i8] c"slope=%.4f intercept=%.4f r2=%.4f predict5=%.4f pearson=%.4f\0A\00", align 1
@.fail.3740 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6510:24  in Regression.Regression\0A\00", align 1
@.faila.3741 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3742 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3743 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6510:40  in Regression.Regression\0A\00", align 1
@.faila.3744 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3745 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3746 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6510:57  in Regression.Regression\0A\00", align 1
@.faila.3747 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3748 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3749 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6510:57  in Regression.Regression\0A\00", align 1
@.faila.3750 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3751 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3752 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6511:25  in Regression.Regression\0A\00", align 1
@.faila.3753 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3754 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3755 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6511:25  in Regression.Regression\0A\00", align 1
@.faila.3756 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3757 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3758 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6511:50  in Regression.Regression\0A\00", align 1
@.faila.3759 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3760 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3761 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6511:50  in Regression.Regression\0A\00", align 1
@.faila.3762 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3763 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3764 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6531:24  in Correlation.pearson\0A\00", align 1
@.faila.3765 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3766 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3767 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6531:40  in Correlation.pearson\0A\00", align 1
@.faila.3768 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3769 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3770 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6531:57  in Correlation.pearson\0A\00", align 1
@.faila.3771 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3772 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3773 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6531:57  in Correlation.pearson\0A\00", align 1
@.faila.3774 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3775 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3776 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6532:25  in Correlation.pearson\0A\00", align 1
@.faila.3777 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3778 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3779 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6532:25  in Correlation.pearson\0A\00", align 1
@.faila.3780 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3781 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3782 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6532:50  in Correlation.pearson\0A\00", align 1
@.faila.3783 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3784 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3785 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6532:50  in Correlation.pearson\0A\00", align 1
@.faila.3786 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3787 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5329 = private constant [1 x i8] zeroinitializer
@.strobj.5330 = private global %String { i64 0, ptr @.strdata.5329, i64 0 }
@.strdata.5331 = private constant [1 x i8] zeroinitializer
@.strobj.5332 = private global %String { i64 0, ptr @.strdata.5331, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %rg = alloca ptr, align 8
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 32)
  store ptr %arr, ptr %x, align 8
  %arr2 = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr2, align 8
  %arr.data3 = getelementptr i8, ptr %arr2, i64 8
  %17 = call ptr @memset(ptr %arr.data3, i32 0, i64 32)
  store ptr %arr2, ptr %y, align 8
  %x4 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %x4, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data5 = getelementptr i8, ptr %x4, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data5, i64 0
  store double 1.000000e+00, ptr %arr.elem, align 8
  %x6 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %arr.len7 = load i64, ptr %x6, align 8
  %arr.oob8 = icmp uge i64 1, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %x6, i64 8
  %arr.elem12 = getelementptr inbounds double, ptr %arr.data11, i64 1
  store double 2.000000e+00, ptr %arr.elem12, align 8
  %x13 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %arr.len14 = load i64, ptr %x13, align 8
  %arr.oob15 = icmp uge i64 2, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad16:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok10
  %arr.data18 = getelementptr i8, ptr %x13, i64 8
  %arr.elem19 = getelementptr inbounds double, ptr %arr.data18, i64 2
  store double 3.000000e+00, ptr %arr.elem19, align 8
  %x20 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %arr.len21 = load i64, ptr %x20, align 8
  %arr.oob22 = icmp uge i64 3, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

idx.bad23:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok17
  %arr.data25 = getelementptr i8, ptr %x20, i64 8
  %arr.elem26 = getelementptr inbounds double, ptr %arr.data25, i64 3
  store double 4.000000e+00, ptr %arr.elem26, align 8
  %y27 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %arr.len28 = load i64, ptr %y27, align 8
  %arr.oob29 = icmp uge i64 0, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 0, ptr @.failb.12, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok24
  %arr.data32 = getelementptr i8, ptr %y27, i64 8
  %arr.elem33 = getelementptr inbounds double, ptr %arr.data32, i64 0
  store double 3.000000e+00, ptr %arr.elem33, align 8
  %y34 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %arr.len35 = load i64, ptr %y34, align 8
  %arr.oob36 = icmp uge i64 1, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !2

idx.bad37:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 1, ptr @.failb.15, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %idx.ok31
  %arr.data39 = getelementptr i8, ptr %y34, i64 8
  %arr.elem40 = getelementptr inbounds double, ptr %arr.data39, i64 1
  store double 5.000000e+00, ptr %arr.elem40, align 8
  %y41 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %arr.len42 = load i64, ptr %y41, align 8
  %arr.oob43 = icmp uge i64 2, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !2

idx.bad44:                                        ; preds = %idx.ok38
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 2, ptr @.failb.18, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok38
  %arr.data46 = getelementptr i8, ptr %y41, i64 8
  %arr.elem47 = getelementptr inbounds double, ptr %arr.data46, i64 2
  store double 7.000000e+00, ptr %arr.elem47, align 8
  %y48 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %arr.len49 = load i64, ptr %y48, align 8
  %arr.oob50 = icmp uge i64 3, %arr.len49
  br i1 %arr.oob50, label %idx.bad51, label %idx.ok52, !prof !2

idx.bad51:                                        ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 3, ptr @.failb.21, i64 %arr.len49, i32 70)
  unreachable

idx.ok52:                                         ; preds = %idx.ok45
  %arr.data53 = getelementptr i8, ptr %y48, i64 8
  %arr.elem54 = getelementptr inbounds double, ptr %arr.data53, i64 3
  store double 9.000000e+00, ptr %arr.elem54, align 8
  %Regression.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Regression, ptr null, i64 1) to i64))
  %x55 = load ptr, ptr %x, align 8
  %y56 = load ptr, ptr %y, align 8
  call void @Regression.Regression(ptr %Regression.obj, ptr %x55, ptr %y56, i32 4)
  store ptr %Regression.obj, ptr %rg, align 8
  %rg57 = load ptr, ptr %rg, align 8
  %18 = call double @Regression.getSlope(ptr %rg57)
  %rg58 = load ptr, ptr %rg, align 8
  %19 = call double @Regression.getIntercept(ptr %rg58)
  %rg59 = load ptr, ptr %rg, align 8
  %20 = call double @Regression.getR2(ptr %rg59)
  %rg60 = load ptr, ptr %rg, align 8
  %21 = call double @Regression.predict(ptr %rg60, double 5.000000e+00)
  %x61 = load ptr, ptr %x, align 8
  %y62 = load ptr, ptr %y, align 8
  %22 = call double @Correlation.pearson(ptr %x61, ptr %y62, i32 4)
  %23 = call i32 (ptr, ...) @printf(ptr @.str, double %18, double %19, double %20, double %21, double %22)
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

define internal double @Numerics.sqrt(double %0) {
entry:
  %i = alloca i32, align 4
  %g = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = fcmp ole double %x1, 0.000000e+00
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret double 0.000000e+00

if.end:                                           ; preds = %entry
  %x2 = load double, ptr %x, align 8
  store double %x2, ptr %g, align 8
  %g3 = load double, ptr %g, align 8
  %3 = fcmp ogt double %g3, 1.000000e+00
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  %x6 = load double, ptr %x, align 8
  %5 = fdiv double %x6, 2.000000e+00
  store double %5, ptr %g, align 8
  br label %if.end5

if.end5:                                          ; preds = %if.then4, %if.end
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end5
  %i7 = load i32, ptr %i, align 4
  %6 = icmp slt i32 %i7, 40
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %g8 = load double, ptr %g, align 8
  %x9 = load double, ptr %x, align 8
  %g10 = load double, ptr %g, align 8
  %8 = fdiv double %x9, %g10
  %9 = fadd double %g8, %8
  %10 = fmul double 5.000000e-01, %9
  store double %10, ptr %g, align 8
  br label %for.update

for.update:                                       ; preds = %for.body
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %g11 = load double, ptr %g, align 8
  ret double %g11
}

define internal void @Regression.Regression(ptr %0, ptr %1, ptr %2, i32 %3) {
entry:
  %den = alloca double, align 8
  %num = alloca double, align 8
  %dn = alloca double, align 8
  %i = alloca i32, align 4
  %syy = alloca double, align 8
  %sxx = alloca double, align 8
  %sxy = alloca double, align 8
  %sy = alloca double, align 8
  %sx = alloca double, align 8
  %n = alloca i32, align 4
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
  store ptr %1, ptr %x, align 8
  store ptr %2, ptr %y, align 8
  store i32 %3, ptr %n, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 0
  store ptr @Regression.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  store double 0.000000e+00, ptr %sx, align 8
  store double 0.000000e+00, ptr %sy, align 8
  store double 0.000000e+00, ptr %sxy, align 8
  store double 0.000000e+00, ptr %sxx, align 8
  store double 0.000000e+00, ptr %syy, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %4 = icmp slt i32 %i1, %n2
  %5 = zext i1 %4 to i32
  br i1 %4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sx3 = load double, ptr %sx, align 8
  %x4 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %6 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %x4, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok69
  %7 = load i32, ptr %i, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %n73 = load i32, ptr %n, align 4
  %9 = sitofp i32 %n73 to double
  store double %9, ptr %dn, align 8
  %slope = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 1
  %dn74 = load double, ptr %dn, align 8
  %sxy75 = load double, ptr %sxy, align 8
  %10 = fmul double %dn74, %sxy75
  %sx76 = load double, ptr %sx, align 8
  %sy77 = load double, ptr %sy, align 8
  %11 = fmul double %sx76, %sy77
  %12 = fsub double %10, %11
  %dn78 = load double, ptr %dn, align 8
  %sxx79 = load double, ptr %sxx, align 8
  %13 = fmul double %dn78, %sxx79
  %sx80 = load double, ptr %sx, align 8
  %sx81 = load double, ptr %sx, align 8
  %14 = fmul double %sx80, %sx81
  %15 = fsub double %13, %14
  %16 = fdiv double %12, %15
  store double %16, ptr %slope, align 8, !tbaa !7
  %intercept = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 2
  %sy82 = load double, ptr %sy, align 8
  %slope83 = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 1
  %slope84 = load double, ptr %slope83, align 8, !tbaa !7
  %sx85 = load double, ptr %sx, align 8
  %17 = fmul double %slope84, %sx85
  %18 = fsub double %sy82, %17
  %dn86 = load double, ptr %dn, align 8
  %19 = fdiv double %18, %dn86
  store double %19, ptr %intercept, align 8, !tbaa !7
  %dn87 = load double, ptr %dn, align 8
  %sxy88 = load double, ptr %sxy, align 8
  %20 = fmul double %dn87, %sxy88
  %sx89 = load double, ptr %sx, align 8
  %sy90 = load double, ptr %sy, align 8
  %21 = fmul double %sx89, %sy90
  %22 = fsub double %20, %21
  store double %22, ptr %num, align 8
  %dn91 = load double, ptr %dn, align 8
  %sxx92 = load double, ptr %sxx, align 8
  %23 = fmul double %dn91, %sxx92
  %sx93 = load double, ptr %sx, align 8
  %sx94 = load double, ptr %sx, align 8
  %24 = fmul double %sx93, %sx94
  %25 = fsub double %23, %24
  %dn95 = load double, ptr %dn, align 8
  %syy96 = load double, ptr %syy, align 8
  %26 = fmul double %dn95, %syy96
  %sy97 = load double, ptr %sy, align 8
  %sy98 = load double, ptr %sy, align 8
  %27 = fmul double %sy97, %sy98
  %28 = fsub double %26, %27
  %29 = fmul double %25, %28
  store double %29, ptr %den, align 8
  %r2 = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 3
  %num99 = load double, ptr %num, align 8
  %num100 = load double, ptr %num, align 8
  %30 = fmul double %num99, %num100
  %den101 = load double, ptr %den, align 8
  %31 = fdiv double %30, %den101
  store double %31, ptr %r2, align 8, !tbaa !7
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3740, ptr @.faila.3741, i64 %6, ptr @.failb.3742, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %x4, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %6
  %elem = load double, ptr %arr.elem, align 8
  %32 = fadd double %sx3, %elem
  store double %32, ptr %sx, align 8
  %sy6 = load double, ptr %sy, align 8
  %y7 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %i8 = load i32, ptr %i, align 4
  %33 = sext i32 %i8 to i64
  %arr.len9 = load i64, ptr %y7, align 8
  %arr.oob10 = icmp uge i64 %33, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

idx.bad11:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3743, ptr @.faila.3744, i64 %33, ptr @.failb.3745, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %idx.ok
  %arr.data13 = getelementptr i8, ptr %y7, i64 8
  %arr.elem14 = getelementptr inbounds double, ptr %arr.data13, i64 %33
  %elem15 = load double, ptr %arr.elem14, align 8
  %34 = fadd double %sy6, %elem15
  store double %34, ptr %sy, align 8
  %sxy16 = load double, ptr %sxy, align 8
  %x17 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i18 = load i32, ptr %i, align 4
  %35 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %x17, align 8
  %arr.oob20 = icmp uge i64 %35, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok12
  call void @__polaron_fail(ptr @.fail.3746, ptr @.faila.3747, i64 %35, ptr @.failb.3748, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok12
  %arr.data23 = getelementptr i8, ptr %x17, i64 8
  %arr.elem24 = getelementptr inbounds double, ptr %arr.data23, i64 %35
  %elem25 = load double, ptr %arr.elem24, align 8
  %y26 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %36 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %y26, align 8
  %arr.oob29 = icmp uge i64 %36, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.3749, ptr @.faila.3750, i64 %36, ptr @.failb.3751, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok22
  %arr.data32 = getelementptr i8, ptr %y26, i64 8
  %arr.elem33 = getelementptr inbounds double, ptr %arr.data32, i64 %36
  %elem34 = load double, ptr %arr.elem33, align 8
  %37 = fmul double %elem25, %elem34
  %38 = fadd double %sxy16, %37
  store double %38, ptr %sxy, align 8
  %sxx35 = load double, ptr %sxx, align 8
  %x36 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i37 = load i32, ptr %i, align 4
  %39 = sext i32 %i37 to i64
  %arr.len38 = load i64, ptr %x36, align 8
  %arr.oob39 = icmp uge i64 %39, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !2

idx.bad40:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.3752, ptr @.faila.3753, i64 %39, ptr @.failb.3754, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %idx.ok31
  %arr.data42 = getelementptr i8, ptr %x36, i64 8
  %arr.elem43 = getelementptr inbounds double, ptr %arr.data42, i64 %39
  %elem44 = load double, ptr %arr.elem43, align 8
  %x45 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i46 = load i32, ptr %i, align 4
  %40 = sext i32 %i46 to i64
  %arr.len47 = load i64, ptr %x45, align 8
  %arr.oob48 = icmp uge i64 %40, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

idx.bad49:                                        ; preds = %idx.ok41
  call void @__polaron_fail(ptr @.fail.3755, ptr @.faila.3756, i64 %40, ptr @.failb.3757, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %idx.ok41
  %arr.data51 = getelementptr i8, ptr %x45, i64 8
  %arr.elem52 = getelementptr inbounds double, ptr %arr.data51, i64 %40
  %elem53 = load double, ptr %arr.elem52, align 8
  %41 = fmul double %elem44, %elem53
  %42 = fadd double %sxx35, %41
  store double %42, ptr %sxx, align 8
  %syy54 = load double, ptr %syy, align 8
  %y55 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %i56 = load i32, ptr %i, align 4
  %43 = sext i32 %i56 to i64
  %arr.len57 = load i64, ptr %y55, align 8
  %arr.oob58 = icmp uge i64 %43, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

idx.bad59:                                        ; preds = %idx.ok50
  call void @__polaron_fail(ptr @.fail.3758, ptr @.faila.3759, i64 %43, ptr @.failb.3760, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok50
  %arr.data61 = getelementptr i8, ptr %y55, i64 8
  %arr.elem62 = getelementptr inbounds double, ptr %arr.data61, i64 %43
  %elem63 = load double, ptr %arr.elem62, align 8
  %y64 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %i65 = load i32, ptr %i, align 4
  %44 = sext i32 %i65 to i64
  %arr.len66 = load i64, ptr %y64, align 8
  %arr.oob67 = icmp uge i64 %44, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !2

idx.bad68:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.3761, ptr @.faila.3762, i64 %44, ptr @.failb.3763, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %idx.ok60
  %arr.data70 = getelementptr i8, ptr %y64, i64 8
  %arr.elem71 = getelementptr inbounds double, ptr %arr.data70, i64 %44
  %elem72 = load double, ptr %arr.elem71, align 8
  %45 = fmul double %elem63, %elem72
  %46 = fadd double %syy54, %45
  store double %46, ptr %syy, align 8
  br label %for.update
}

define internal double @Regression.getSlope(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %slope = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 1
  %slope1 = load double, ptr %slope, align 8, !tbaa !7
  ret double %slope1
}

define internal double @Regression.getIntercept(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %intercept = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 2
  %intercept1 = load double, ptr %intercept, align 8, !tbaa !7
  ret double %intercept1
}

define internal double @Regression.getR2(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %r2 = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 3
  %r21 = load double, ptr %r2, align 8, !tbaa !7
  ret double %r21
}

define internal double @Regression.predict(ptr nonnull align 8 dereferenceable(32) %0, double %1) {
entry:
  %x = alloca double, align 8
  store double %1, ptr %x, align 8
  %slope = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 1
  %slope1 = load double, ptr %slope, align 8, !tbaa !7
  %x2 = load double, ptr %x, align 8
  %2 = fmul double %slope1, %x2
  %intercept = getelementptr inbounds %class.Regression, ptr %0, i32 0, i32 2
  %intercept3 = load double, ptr %intercept, align 8, !tbaa !7
  %3 = fadd double %2, %intercept3
  ret double %3
}

define internal double @Correlation.pearson(ptr %0, ptr %1, i32 %2) {
entry:
  %den = alloca double, align 8
  %num = alloca double, align 8
  %dn = alloca double, align 8
  %i = alloca i32, align 4
  %syy = alloca double, align 8
  %sxx = alloca double, align 8
  %sxy = alloca double, align 8
  %sy = alloca double, align 8
  %sx = alloca double, align 8
  %n = alloca i32, align 4
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
  store ptr %0, ptr %x, align 8
  store ptr %1, ptr %y, align 8
  store i32 %2, ptr %n, align 4
  store double 0.000000e+00, ptr %sx, align 8
  store double 0.000000e+00, ptr %sy, align 8
  store double 0.000000e+00, ptr %sxy, align 8
  store double 0.000000e+00, ptr %sxx, align 8
  store double 0.000000e+00, ptr %syy, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %i1, %n2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sx3 = load double, ptr %sx, align 8
  %x4 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %5 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %x4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok69
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %n73 = load i32, ptr %n, align 4
  %8 = sitofp i32 %n73 to double
  store double %8, ptr %dn, align 8
  %dn74 = load double, ptr %dn, align 8
  %sxy75 = load double, ptr %sxy, align 8
  %9 = fmul double %dn74, %sxy75
  %sx76 = load double, ptr %sx, align 8
  %sy77 = load double, ptr %sy, align 8
  %10 = fmul double %sx76, %sy77
  %11 = fsub double %9, %10
  store double %11, ptr %num, align 8
  %dn78 = load double, ptr %dn, align 8
  %sxx79 = load double, ptr %sxx, align 8
  %12 = fmul double %dn78, %sxx79
  %sx80 = load double, ptr %sx, align 8
  %sx81 = load double, ptr %sx, align 8
  %13 = fmul double %sx80, %sx81
  %14 = fsub double %12, %13
  %dn82 = load double, ptr %dn, align 8
  %syy83 = load double, ptr %syy, align 8
  %15 = fmul double %dn82, %syy83
  %sy84 = load double, ptr %sy, align 8
  %sy85 = load double, ptr %sy, align 8
  %16 = fmul double %sy84, %sy85
  %17 = fsub double %15, %16
  %18 = fmul double %14, %17
  %19 = call double @Numerics.sqrt(double %18)
  store double %19, ptr %den, align 8
  %den86 = load double, ptr %den, align 8
  %20 = fcmp oeq double %den86, 0.000000e+00
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3764, ptr @.faila.3765, i64 %5, ptr @.failb.3766, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %x4, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %5
  %elem = load double, ptr %arr.elem, align 8
  %22 = fadd double %sx3, %elem
  store double %22, ptr %sx, align 8
  %sy6 = load double, ptr %sy, align 8
  %y7 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %i8 = load i32, ptr %i, align 4
  %23 = sext i32 %i8 to i64
  %arr.len9 = load i64, ptr %y7, align 8
  %arr.oob10 = icmp uge i64 %23, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

idx.bad11:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3767, ptr @.faila.3768, i64 %23, ptr @.failb.3769, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %idx.ok
  %arr.data13 = getelementptr i8, ptr %y7, i64 8
  %arr.elem14 = getelementptr inbounds double, ptr %arr.data13, i64 %23
  %elem15 = load double, ptr %arr.elem14, align 8
  %24 = fadd double %sy6, %elem15
  store double %24, ptr %sy, align 8
  %sxy16 = load double, ptr %sxy, align 8
  %x17 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i18 = load i32, ptr %i, align 4
  %25 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %x17, align 8
  %arr.oob20 = icmp uge i64 %25, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok12
  call void @__polaron_fail(ptr @.fail.3770, ptr @.faila.3771, i64 %25, ptr @.failb.3772, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok12
  %arr.data23 = getelementptr i8, ptr %x17, i64 8
  %arr.elem24 = getelementptr inbounds double, ptr %arr.data23, i64 %25
  %elem25 = load double, ptr %arr.elem24, align 8
  %y26 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %26 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %y26, align 8
  %arr.oob29 = icmp uge i64 %26, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.3773, ptr @.faila.3774, i64 %26, ptr @.failb.3775, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok22
  %arr.data32 = getelementptr i8, ptr %y26, i64 8
  %arr.elem33 = getelementptr inbounds double, ptr %arr.data32, i64 %26
  %elem34 = load double, ptr %arr.elem33, align 8
  %27 = fmul double %elem25, %elem34
  %28 = fadd double %sxy16, %27
  store double %28, ptr %sxy, align 8
  %sxx35 = load double, ptr %sxx, align 8
  %x36 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i37 = load i32, ptr %i, align 4
  %29 = sext i32 %i37 to i64
  %arr.len38 = load i64, ptr %x36, align 8
  %arr.oob39 = icmp uge i64 %29, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !2

idx.bad40:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.3776, ptr @.faila.3777, i64 %29, ptr @.failb.3778, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %idx.ok31
  %arr.data42 = getelementptr i8, ptr %x36, i64 8
  %arr.elem43 = getelementptr inbounds double, ptr %arr.data42, i64 %29
  %elem44 = load double, ptr %arr.elem43, align 8
  %x45 = load ptr, ptr %x, align 8, !nonnull !0, !dereferenceable !1
  %i46 = load i32, ptr %i, align 4
  %30 = sext i32 %i46 to i64
  %arr.len47 = load i64, ptr %x45, align 8
  %arr.oob48 = icmp uge i64 %30, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

idx.bad49:                                        ; preds = %idx.ok41
  call void @__polaron_fail(ptr @.fail.3779, ptr @.faila.3780, i64 %30, ptr @.failb.3781, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %idx.ok41
  %arr.data51 = getelementptr i8, ptr %x45, i64 8
  %arr.elem52 = getelementptr inbounds double, ptr %arr.data51, i64 %30
  %elem53 = load double, ptr %arr.elem52, align 8
  %31 = fmul double %elem44, %elem53
  %32 = fadd double %sxx35, %31
  store double %32, ptr %sxx, align 8
  %syy54 = load double, ptr %syy, align 8
  %y55 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %i56 = load i32, ptr %i, align 4
  %33 = sext i32 %i56 to i64
  %arr.len57 = load i64, ptr %y55, align 8
  %arr.oob58 = icmp uge i64 %33, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

idx.bad59:                                        ; preds = %idx.ok50
  call void @__polaron_fail(ptr @.fail.3782, ptr @.faila.3783, i64 %33, ptr @.failb.3784, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok50
  %arr.data61 = getelementptr i8, ptr %y55, i64 8
  %arr.elem62 = getelementptr inbounds double, ptr %arr.data61, i64 %33
  %elem63 = load double, ptr %arr.elem62, align 8
  %y64 = load ptr, ptr %y, align 8, !nonnull !0, !dereferenceable !1
  %i65 = load i32, ptr %i, align 4
  %34 = sext i32 %i65 to i64
  %arr.len66 = load i64, ptr %y64, align 8
  %arr.oob67 = icmp uge i64 %34, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !2

idx.bad68:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.3785, ptr @.faila.3786, i64 %34, ptr @.failb.3787, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %idx.ok60
  %arr.data70 = getelementptr i8, ptr %y64, i64 8
  %arr.elem71 = getelementptr inbounds double, ptr %arr.data70, i64 %34
  %elem72 = load double, ptr %arr.elem71, align 8
  %35 = fmul double %elem63, %elem72
  %36 = fadd double %syy54, %35
  store double %36, ptr %syy, align 8
  br label %for.update

if.then:                                          ; preds = %for.end
  ret double 0.000000e+00

if.end:                                           ; preds = %for.end
  %num87 = load double, ptr %num, align 8
  %den88 = load double, ptr %den, align 8
  %37 = fdiv double %num87, %den88
  ret double %37
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5330)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5332)
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
!8 = !{!"f64", !5, i64 0}
