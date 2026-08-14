; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matrixd.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matrixd.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.MatrixD = type { ptr, i32, i32, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@MatrixD.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @MatrixD.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @MatrixD.set, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @MatrixD.mul, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @MatrixD.transpose, ptr @MatrixD.determinant, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @MatrixD.rowCount, ptr @MatrixD.colCount, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [37 x i8] c"c00=%.1f c11=%.1f t01=%.1f det=%.1f\0A\00", align 1
@.fail.3764 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6583:99  in MatrixD.set\0A\00", align 1
@.faila.3765 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3766 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3767 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6584:62  in MatrixD.get\0A\00", align 1
@.faila.3768 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3769 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3770 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6608:64  in MatrixD.determinant\0A\00", align 1
@.faila.3771 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3772 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3773 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6608:64  in MatrixD.determinant\0A\00", align 1
@.faila.3774 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3775 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3776 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6613:25  in MatrixD.determinant\0A\00", align 1
@.faila.3777 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3778 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3779 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6613:25  in MatrixD.determinant\0A\00", align 1
@.faila.3780 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3781 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3782 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6615:21  in MatrixD.determinant\0A\00", align 1
@.faila.3783 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3784 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3785 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6618:29  in MatrixD.determinant\0A\00", align 1
@.faila.3786 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3787 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3788 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6618:67  in MatrixD.determinant\0A\00", align 1
@.faila.3789 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3790 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3791 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6618:67  in MatrixD.determinant\0A\00", align 1
@.faila.3792 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3793 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3794 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6618:96  in MatrixD.determinant\0A\00", align 1
@.faila.3795 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3796 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3797 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6622:25  in MatrixD.determinant\0A\00", align 1
@.faila.3798 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3799 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3800 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6624:25  in MatrixD.determinant\0A\00", align 1
@.faila.3801 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3802 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3803 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6624:25  in MatrixD.determinant\0A\00", align 1
@.faila.3804 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3805 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3806 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6625:76  in MatrixD.determinant\0A\00", align 1
@.faila.3807 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3808 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3809 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6625:76  in MatrixD.determinant\0A\00", align 1
@.faila.3810 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3811 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3812 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6625:76  in MatrixD.determinant\0A\00", align 1
@.faila.3813 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3814 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %t = alloca ptr, align 8
  %c = alloca ptr, align 8
  %b = alloca ptr, align 8
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
  %MatrixD.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.MatrixD, ptr null, i64 1) to i64))
  call void @MatrixD.MatrixD(ptr %MatrixD.obj, i32 2, i32 2)
  store ptr %MatrixD.obj, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  call void @MatrixD.set(ptr %a1, i32 0, i32 0, double 1.000000e+00)
  %a2 = load ptr, ptr %a, align 8
  call void @MatrixD.set(ptr %a2, i32 0, i32 1, double 2.000000e+00)
  %a3 = load ptr, ptr %a, align 8
  call void @MatrixD.set(ptr %a3, i32 1, i32 0, double 3.000000e+00)
  %a4 = load ptr, ptr %a, align 8
  call void @MatrixD.set(ptr %a4, i32 1, i32 1, double 4.000000e+00)
  %MatrixD.obj5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.MatrixD, ptr null, i64 1) to i64))
  call void @MatrixD.MatrixD(ptr %MatrixD.obj5, i32 2, i32 2)
  store ptr %MatrixD.obj5, ptr %b, align 8
  %b6 = load ptr, ptr %b, align 8
  call void @MatrixD.set(ptr %b6, i32 0, i32 0, double 5.000000e+00)
  %b7 = load ptr, ptr %b, align 8
  call void @MatrixD.set(ptr %b7, i32 0, i32 1, double 6.000000e+00)
  %b8 = load ptr, ptr %b, align 8
  call void @MatrixD.set(ptr %b8, i32 1, i32 0, double 7.000000e+00)
  %b9 = load ptr, ptr %b, align 8
  call void @MatrixD.set(ptr %b9, i32 1, i32 1, double 8.000000e+00)
  %a10 = load ptr, ptr %a, align 8
  %b11 = load ptr, ptr %b, align 8
  %16 = call ptr @MatrixD.mul(ptr %a10, ptr %b11)
  store ptr %16, ptr %c, align 8
  %a12 = load ptr, ptr %a, align 8
  %17 = call ptr @MatrixD.transpose(ptr %a12)
  store ptr %17, ptr %t, align 8
  %c13 = load ptr, ptr %c, align 8
  %18 = call double @MatrixD.get(ptr %c13, i32 0, i32 0)
  %c14 = load ptr, ptr %c, align 8
  %19 = call double @MatrixD.get(ptr %c14, i32 1, i32 1)
  %t15 = load ptr, ptr %t, align 8
  %20 = call double @MatrixD.get(ptr %t15, i32 0, i32 1)
  %a16 = load ptr, ptr %a, align 8
  %21 = call double @MatrixD.determinant(ptr %a16)
  %22 = call i32 (ptr, ...) @printf(ptr @.str, double %18, double %19, double %20, double %21)
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

define internal double @Numerics.abs(double %0) {
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

define internal void @MatrixD.MatrixD(ptr %0, i32 %1, i32 %2) {
entry:
  %cols = alloca i32, align 4
  %rows = alloca i32, align 4
  store i32 %1, ptr %rows, align 4
  store i32 %2, ptr %cols, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 0
  store ptr @MatrixD.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 3
  store ptr null, ptr %data, align 8, !tbaa !0
  %rows1 = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 1
  %rows2 = load i32, ptr %rows, align 4
  store i32 %rows2, ptr %rows1, align 4, !tbaa !4
  %cols3 = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 2
  %cols4 = load i32, ptr %cols, align 4
  store i32 %cols4, ptr %cols3, align 4, !tbaa !4
  %data5 = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 3
  %rows6 = load i32, ptr %rows, align 4
  %cols7 = load i32, ptr %cols, align 4
  %3 = mul i32 %rows6, %cols7
  %4 = sext i32 %3 to i64
  %5 = mul i64 %4, 8
  %6 = add i64 8, %5
  %arr = call ptr @__polaron_malloc(i64 %6)
  store i64 %4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %7 = call ptr @memset(ptr %arr.data, i32 0, i64 %5)
  store ptr %arr, ptr %data5, align 8, !tbaa !0
  ret void
}

define internal void @MatrixD.set(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2, double %3) {
entry:
  %v = alloca double, align 8
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  store double %3, ptr %v, align 8
  %data = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 3
  %data1 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r2 = load i32, ptr %r, align 4
  %cols = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 2
  %cols3 = load i32, ptr %cols, align 4, !tbaa !4
  %4 = mul i32 %r2, %cols3
  %c4 = load i32, ptr %c, align 4
  %5 = add i32 %4, %c4
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %data1, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3764, ptr @.faila.3765, i64 %6, ptr @.failb.3766, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %6
  %v5 = load double, ptr %v, align 8
  store double %v5, ptr %arr.elem, align 8
  ret void
}

define internal double @MatrixD.get(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  %data = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 3
  %data1 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r2 = load i32, ptr %r, align 4
  %cols = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 2
  %cols3 = load i32, ptr %cols, align 4, !tbaa !4
  %3 = mul i32 %r2, %cols3
  %c4 = load i32, ptr %c, align 4
  %4 = add i32 %3, %c4
  %5 = sext i32 %4 to i64
  %arr.len = load i64, ptr %data1, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3767, ptr @.faila.3768, i64 %5, ptr @.failb.3769, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %5
  %elem = load double, ptr %arr.elem, align 8
  ret double %elem
}

define internal i32 @MatrixD.rowCount(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %rows = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 1
  %rows1 = load i32, ptr %rows, align 4, !tbaa !4
  ret i32 %rows1
}

define internal i32 @MatrixD.colCount(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %cols = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 2
  %cols1 = load i32, ptr %cols, align 4, !tbaa !4
  ret i32 %cols1
}

define internal ptr @MatrixD.mul(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %k = alloca i32, align 4
  %s = alloca double, align 8
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %res = alloca ptr, align 8
  %MatrixD.copy = alloca %class.MatrixD, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %MatrixD.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.MatrixD, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.MatrixD, ptr %1, i32 0, i32 3
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.MatrixD, ptr %MatrixD.copy, i32 0, i32 3
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %MatrixD.copy, ptr %o, align 8
  %MatrixD.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.MatrixD, ptr null, i64 1) to i64))
  %rows = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 1
  %rows1 = load i32, ptr %rows, align 4, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %9 = call i32 @MatrixD.colCount(ptr %o2)
  call void @MatrixD.MatrixD(ptr %MatrixD.obj, i32 %rows1, i32 %9)
  store ptr %MatrixD.obj, ptr %res, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %rows4 = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 1
  %rows5 = load i32, ptr %rows4, align 4, !tbaa !4
  %10 = icmp slt i32 %i3, %rows5
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %res28 = load ptr, ptr %res, align 8
  ret ptr %res28

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %o11 = load ptr, ptr %o, align 8
  %14 = call i32 @MatrixD.colCount(ptr %o11)
  %15 = icmp slt i32 %j10, %14
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  store double 0.000000e+00, ptr %s, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond12

for.update8:                                      ; preds = %for.end15
  %17 = load i32, ptr %j, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update

for.cond12:                                       ; preds = %for.update14, %for.body7
  %k16 = load i32, ptr %k, align 4
  %cols = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 2
  %cols17 = load i32, ptr %cols, align 4, !tbaa !4
  %19 = icmp slt i32 %k16, %cols17
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body13, label %for.end15

for.body13:                                       ; preds = %for.cond12
  %s18 = load double, ptr %s, align 8
  %i19 = load i32, ptr %i, align 4
  %k20 = load i32, ptr %k, align 4
  %21 = call double @MatrixD.get(ptr %0, i32 %i19, i32 %k20)
  %o21 = load ptr, ptr %o, align 8
  %k22 = load i32, ptr %k, align 4
  %j23 = load i32, ptr %j, align 4
  %22 = call double @MatrixD.get(ptr %o21, i32 %k22, i32 %j23)
  %23 = fmul double %21, %22
  %24 = fadd double %s18, %23
  store double %24, ptr %s, align 8
  br label %for.update14

for.update14:                                     ; preds = %for.body13
  %25 = load i32, ptr %k, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %k, align 4
  br label %for.cond12

for.end15:                                        ; preds = %for.cond12
  %res24 = load ptr, ptr %res, align 8
  %i25 = load i32, ptr %i, align 4
  %j26 = load i32, ptr %j, align 4
  %s27 = load double, ptr %s, align 8
  call void @MatrixD.set(ptr %res24, i32 %i25, i32 %j26, double %s27)
  br label %for.update8
}

define internal ptr @MatrixD.transpose(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %res = alloca ptr, align 8
  %MatrixD.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.MatrixD, ptr null, i64 1) to i64))
  %cols = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 2
  %cols1 = load i32, ptr %cols, align 4, !tbaa !4
  %rows = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 1
  %rows2 = load i32, ptr %rows, align 4, !tbaa !4
  call void @MatrixD.MatrixD(ptr %MatrixD.obj, i32 %cols1, i32 %rows2)
  store ptr %MatrixD.obj, ptr %res, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %rows4 = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 1
  %rows5 = load i32, ptr %rows4, align 4, !tbaa !4
  %1 = icmp slt i32 %i3, %rows5
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %3 = load i32, ptr %i, align 4
  %4 = add i32 %3, 1
  store i32 %4, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %res18 = load ptr, ptr %res, align 8
  ret ptr %res18

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %cols11 = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 2
  %cols12 = load i32, ptr %cols11, align 4, !tbaa !4
  %5 = icmp slt i32 %j10, %cols12
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %res13 = load ptr, ptr %res, align 8
  %j14 = load i32, ptr %j, align 4
  %i15 = load i32, ptr %i, align 4
  %i16 = load i32, ptr %i, align 4
  %j17 = load i32, ptr %j, align 4
  %7 = call double @MatrixD.get(ptr %0, i32 %i16, i32 %j17)
  call void @MatrixD.set(ptr %res13, i32 %j14, i32 %i15, double %7)
  br label %for.update8

for.update8:                                      ; preds = %for.body7
  %8 = load i32, ptr %j, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update
}

define internal double @MatrixD.determinant(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %c165 = alloca i32, align 4
  %f = alloca double, align 8
  %r135 = alloca i32, align 4
  %t = alloca double, align 8
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  %piv = alloca i32, align 4
  %col = alloca i32, align 4
  %det = alloca double, align 8
  %i = alloca i32, align 4
  %a = alloca ptr, align 8
  %n = alloca i32, align 4
  %rows = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 1
  %rows1 = load i32, ptr %rows, align 4, !tbaa !4
  store i32 %rows1, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  %n3 = load i32, ptr %n, align 4
  %1 = mul i32 %n2, %n3
  %2 = sext i32 %1 to i64
  %3 = mul i64 %2, 8
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %a, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %n6 = load i32, ptr %n, align 4
  %6 = mul i32 %n5, %n6
  %7 = icmp slt i32 %i4, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %a7 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %i8 = load i32, ptr %i, align 4
  %9 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %a7, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok15
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store double 1.000000e+00, ptr %det, align 8
  store i32 0, ptr %col, align 4
  br label %for.cond18

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3770, ptr @.faila.3771, i64 %9, ptr @.failb.3772, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data9 = getelementptr i8, ptr %a7, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data9, i64 %9
  %data = getelementptr inbounds %class.MatrixD, ptr %0, i32 0, i32 3
  %data10 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i11 = load i32, ptr %i, align 4
  %12 = sext i32 %i11 to i64
  %arr.len12 = load i64, ptr %data10, align 8
  %arr.oob13 = icmp uge i64 %12, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !8

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3773, ptr @.faila.3774, i64 %12, ptr @.failb.3775, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %data10, i64 8
  %arr.elem17 = getelementptr inbounds double, ptr %arr.data16, i64 %12
  %elem = load double, ptr %arr.elem17, align 8
  store double %elem, ptr %arr.elem, align 8
  br label %for.update

for.cond18:                                       ; preds = %for.update20, %for.end
  %col22 = load i32, ptr %col, align 4
  %n23 = load i32, ptr %n, align 4
  %13 = icmp slt i32 %col22, %n23
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body19, label %for.end21

for.body19:                                       ; preds = %for.cond18
  %col24 = load i32, ptr %col, align 4
  store i32 %col24, ptr %piv, align 4
  %col25 = load i32, ptr %col, align 4
  %15 = add i32 %col25, 1
  store i32 %15, ptr %r, align 4
  br label %for.cond26

for.update20:                                     ; preds = %for.end139
  %16 = load i32, ptr %col, align 4
  %17 = add i32 %16, 1
  store i32 %17, ptr %col, align 4
  br label %for.cond18

for.end21:                                        ; preds = %for.cond18
  %det205 = load double, ptr %det, align 8
  ret double %det205

for.cond26:                                       ; preds = %for.update28, %for.body19
  %r30 = load i32, ptr %r, align 4
  %n31 = load i32, ptr %n, align 4
  %18 = icmp slt i32 %r30, %n31
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body27, label %for.end29

for.body27:                                       ; preds = %for.cond26
  %a32 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %r33 = load i32, ptr %r, align 4
  %n34 = load i32, ptr %n, align 4
  %20 = mul i32 %r33, %n34
  %col35 = load i32, ptr %col, align 4
  %21 = add i32 %20, %col35
  %22 = sext i32 %21 to i64
  %arr.len36 = load i64, ptr %a32, align 8
  %arr.oob37 = icmp uge i64 %22, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !8

for.update28:                                     ; preds = %if.end
  %23 = load i32, ptr %r, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %r, align 4
  br label %for.cond26

for.end29:                                        ; preds = %for.cond26
  %a55 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %piv56 = load i32, ptr %piv, align 4
  %n57 = load i32, ptr %n, align 4
  %25 = mul i32 %piv56, %n57
  %col58 = load i32, ptr %col, align 4
  %26 = add i32 %25, %col58
  %27 = sext i32 %26 to i64
  %arr.len59 = load i64, ptr %a55, align 8
  %arr.oob60 = icmp uge i64 %27, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !8

idx.bad38:                                        ; preds = %for.body27
  call void @__polaron_fail(ptr @.fail.3776, ptr @.faila.3777, i64 %22, ptr @.failb.3778, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %for.body27
  %arr.data40 = getelementptr i8, ptr %a32, i64 8
  %arr.elem41 = getelementptr inbounds double, ptr %arr.data40, i64 %22
  %elem42 = load double, ptr %arr.elem41, align 8
  %28 = call double @Numerics.abs(double %elem42)
  %a43 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %piv44 = load i32, ptr %piv, align 4
  %n45 = load i32, ptr %n, align 4
  %29 = mul i32 %piv44, %n45
  %col46 = load i32, ptr %col, align 4
  %30 = add i32 %29, %col46
  %31 = sext i32 %30 to i64
  %arr.len47 = load i64, ptr %a43, align 8
  %arr.oob48 = icmp uge i64 %31, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !8

idx.bad49:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.3779, ptr @.faila.3780, i64 %31, ptr @.failb.3781, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %idx.ok39
  %arr.data51 = getelementptr i8, ptr %a43, i64 8
  %arr.elem52 = getelementptr inbounds double, ptr %arr.data51, i64 %31
  %elem53 = load double, ptr %arr.elem52, align 8
  %32 = call double @Numerics.abs(double %elem53)
  %33 = fcmp ogt double %28, %32
  %34 = zext i1 %33 to i32
  br i1 %33, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok50
  %r54 = load i32, ptr %r, align 4
  store i32 %r54, ptr %piv, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok50
  br label %for.update28

idx.bad61:                                        ; preds = %for.end29
  call void @__polaron_fail(ptr @.fail.3782, ptr @.faila.3783, i64 %27, ptr @.failb.3784, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %for.end29
  %arr.data63 = getelementptr i8, ptr %a55, i64 8
  %arr.elem64 = getelementptr inbounds double, ptr %arr.data63, i64 %27
  %elem65 = load double, ptr %arr.elem64, align 8
  %35 = call double @Numerics.abs(double %elem65)
  %36 = fcmp oeq double %35, 0.000000e+00
  %37 = zext i1 %36 to i32
  br i1 %36, label %if.then66, label %if.end67

if.then66:                                        ; preds = %idx.ok62
  ret double 0.000000e+00

if.end67:                                         ; preds = %idx.ok62
  %piv68 = load i32, ptr %piv, align 4
  %col69 = load i32, ptr %col, align 4
  %38 = icmp ne i32 %piv68, %col69
  %39 = zext i1 %38 to i32
  br i1 %38, label %if.then70, label %if.end71

if.then70:                                        ; preds = %if.end67
  store i32 0, ptr %c, align 4
  br label %for.cond72

if.end71:                                         ; preds = %for.end75, %if.end67
  %det122 = load double, ptr %det, align 8
  %a123 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %col124 = load i32, ptr %col, align 4
  %n125 = load i32, ptr %n, align 4
  %40 = mul i32 %col124, %n125
  %col126 = load i32, ptr %col, align 4
  %41 = add i32 %40, %col126
  %42 = sext i32 %41 to i64
  %arr.len127 = load i64, ptr %a123, align 8
  %arr.oob128 = icmp uge i64 %42, %arr.len127
  br i1 %arr.oob128, label %idx.bad129, label %idx.ok130, !prof !8

for.cond72:                                       ; preds = %for.update74, %if.then70
  %c76 = load i32, ptr %c, align 4
  %n77 = load i32, ptr %n, align 4
  %43 = icmp slt i32 %c76, %n77
  %44 = zext i1 %43 to i32
  br i1 %43, label %for.body73, label %for.end75

for.body73:                                       ; preds = %for.cond72
  %a78 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %col79 = load i32, ptr %col, align 4
  %n80 = load i32, ptr %n, align 4
  %45 = mul i32 %col79, %n80
  %c81 = load i32, ptr %c, align 4
  %46 = add i32 %45, %c81
  %47 = sext i32 %46 to i64
  %arr.len82 = load i64, ptr %a78, align 8
  %arr.oob83 = icmp uge i64 %47, %arr.len82
  br i1 %arr.oob83, label %idx.bad84, label %idx.ok85, !prof !8

for.update74:                                     ; preds = %idx.ok117
  %48 = load i32, ptr %c, align 4
  %49 = add i32 %48, 1
  store i32 %49, ptr %c, align 4
  br label %for.cond72

for.end75:                                        ; preds = %for.cond72
  %det121 = load double, ptr %det, align 8
  %50 = fsub double 0.000000e+00, %det121
  store double %50, ptr %det, align 8
  br label %if.end71

idx.bad84:                                        ; preds = %for.body73
  call void @__polaron_fail(ptr @.fail.3785, ptr @.faila.3786, i64 %47, ptr @.failb.3787, i64 %arr.len82, i32 70)
  unreachable

idx.ok85:                                         ; preds = %for.body73
  %arr.data86 = getelementptr i8, ptr %a78, i64 8
  %arr.elem87 = getelementptr inbounds double, ptr %arr.data86, i64 %47
  %elem88 = load double, ptr %arr.elem87, align 8
  store double %elem88, ptr %t, align 8
  %a89 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %col90 = load i32, ptr %col, align 4
  %n91 = load i32, ptr %n, align 4
  %51 = mul i32 %col90, %n91
  %c92 = load i32, ptr %c, align 4
  %52 = add i32 %51, %c92
  %53 = sext i32 %52 to i64
  %arr.len93 = load i64, ptr %a89, align 8
  %arr.oob94 = icmp uge i64 %53, %arr.len93
  br i1 %arr.oob94, label %idx.bad95, label %idx.ok96, !prof !8

idx.bad95:                                        ; preds = %idx.ok85
  call void @__polaron_fail(ptr @.fail.3788, ptr @.faila.3789, i64 %53, ptr @.failb.3790, i64 %arr.len93, i32 70)
  unreachable

idx.ok96:                                         ; preds = %idx.ok85
  %arr.data97 = getelementptr i8, ptr %a89, i64 8
  %arr.elem98 = getelementptr inbounds double, ptr %arr.data97, i64 %53
  %a99 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %piv100 = load i32, ptr %piv, align 4
  %n101 = load i32, ptr %n, align 4
  %54 = mul i32 %piv100, %n101
  %c102 = load i32, ptr %c, align 4
  %55 = add i32 %54, %c102
  %56 = sext i32 %55 to i64
  %arr.len103 = load i64, ptr %a99, align 8
  %arr.oob104 = icmp uge i64 %56, %arr.len103
  br i1 %arr.oob104, label %idx.bad105, label %idx.ok106, !prof !8

idx.bad105:                                       ; preds = %idx.ok96
  call void @__polaron_fail(ptr @.fail.3791, ptr @.faila.3792, i64 %56, ptr @.failb.3793, i64 %arr.len103, i32 70)
  unreachable

idx.ok106:                                        ; preds = %idx.ok96
  %arr.data107 = getelementptr i8, ptr %a99, i64 8
  %arr.elem108 = getelementptr inbounds double, ptr %arr.data107, i64 %56
  %elem109 = load double, ptr %arr.elem108, align 8
  store double %elem109, ptr %arr.elem98, align 8
  %a110 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %piv111 = load i32, ptr %piv, align 4
  %n112 = load i32, ptr %n, align 4
  %57 = mul i32 %piv111, %n112
  %c113 = load i32, ptr %c, align 4
  %58 = add i32 %57, %c113
  %59 = sext i32 %58 to i64
  %arr.len114 = load i64, ptr %a110, align 8
  %arr.oob115 = icmp uge i64 %59, %arr.len114
  br i1 %arr.oob115, label %idx.bad116, label %idx.ok117, !prof !8

idx.bad116:                                       ; preds = %idx.ok106
  call void @__polaron_fail(ptr @.fail.3794, ptr @.faila.3795, i64 %59, ptr @.failb.3796, i64 %arr.len114, i32 70)
  unreachable

idx.ok117:                                        ; preds = %idx.ok106
  %arr.data118 = getelementptr i8, ptr %a110, i64 8
  %arr.elem119 = getelementptr inbounds double, ptr %arr.data118, i64 %59
  %t120 = load double, ptr %t, align 8
  store double %t120, ptr %arr.elem119, align 8
  br label %for.update74

idx.bad129:                                       ; preds = %if.end71
  call void @__polaron_fail(ptr @.fail.3797, ptr @.faila.3798, i64 %42, ptr @.failb.3799, i64 %arr.len127, i32 70)
  unreachable

idx.ok130:                                        ; preds = %if.end71
  %arr.data131 = getelementptr i8, ptr %a123, i64 8
  %arr.elem132 = getelementptr inbounds double, ptr %arr.data131, i64 %42
  %elem133 = load double, ptr %arr.elem132, align 8
  %60 = fmul double %det122, %elem133
  store double %60, ptr %det, align 8
  %col134 = load i32, ptr %col, align 4
  %61 = add i32 %col134, 1
  store i32 %61, ptr %r135, align 4
  br label %for.cond136

for.cond136:                                      ; preds = %for.update138, %idx.ok130
  %r140 = load i32, ptr %r135, align 4
  %n141 = load i32, ptr %n, align 4
  %62 = icmp slt i32 %r140, %n141
  %63 = zext i1 %62 to i32
  br i1 %62, label %for.body137, label %for.end139

for.body137:                                      ; preds = %for.cond136
  %a142 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %r143 = load i32, ptr %r135, align 4
  %n144 = load i32, ptr %n, align 4
  %64 = mul i32 %r143, %n144
  %col145 = load i32, ptr %col, align 4
  %65 = add i32 %64, %col145
  %66 = sext i32 %65 to i64
  %arr.len146 = load i64, ptr %a142, align 8
  %arr.oob147 = icmp uge i64 %66, %arr.len146
  br i1 %arr.oob147, label %idx.bad148, label %idx.ok149, !prof !8

for.update138:                                    ; preds = %for.end169
  %67 = load i32, ptr %r135, align 4
  %68 = add i32 %67, 1
  store i32 %68, ptr %r135, align 4
  br label %for.cond136

for.end139:                                       ; preds = %for.cond136
  br label %for.update20

idx.bad148:                                       ; preds = %for.body137
  call void @__polaron_fail(ptr @.fail.3800, ptr @.faila.3801, i64 %66, ptr @.failb.3802, i64 %arr.len146, i32 70)
  unreachable

idx.ok149:                                        ; preds = %for.body137
  %arr.data150 = getelementptr i8, ptr %a142, i64 8
  %arr.elem151 = getelementptr inbounds double, ptr %arr.data150, i64 %66
  %elem152 = load double, ptr %arr.elem151, align 8
  %a153 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %col154 = load i32, ptr %col, align 4
  %n155 = load i32, ptr %n, align 4
  %69 = mul i32 %col154, %n155
  %col156 = load i32, ptr %col, align 4
  %70 = add i32 %69, %col156
  %71 = sext i32 %70 to i64
  %arr.len157 = load i64, ptr %a153, align 8
  %arr.oob158 = icmp uge i64 %71, %arr.len157
  br i1 %arr.oob158, label %idx.bad159, label %idx.ok160, !prof !8

idx.bad159:                                       ; preds = %idx.ok149
  call void @__polaron_fail(ptr @.fail.3803, ptr @.faila.3804, i64 %71, ptr @.failb.3805, i64 %arr.len157, i32 70)
  unreachable

idx.ok160:                                        ; preds = %idx.ok149
  %arr.data161 = getelementptr i8, ptr %a153, i64 8
  %arr.elem162 = getelementptr inbounds double, ptr %arr.data161, i64 %71
  %elem163 = load double, ptr %arr.elem162, align 8
  %72 = fdiv double %elem152, %elem163
  store double %72, ptr %f, align 8
  %col164 = load i32, ptr %col, align 4
  store i32 %col164, ptr %c165, align 4
  br label %for.cond166

for.cond166:                                      ; preds = %for.update168, %idx.ok160
  %c170 = load i32, ptr %c165, align 4
  %n171 = load i32, ptr %n, align 4
  %73 = icmp slt i32 %c170, %n171
  %74 = zext i1 %73 to i32
  br i1 %73, label %for.body167, label %for.end169

for.body167:                                      ; preds = %for.cond166
  %a172 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %r173 = load i32, ptr %r135, align 4
  %n174 = load i32, ptr %n, align 4
  %75 = mul i32 %r173, %n174
  %c175 = load i32, ptr %c165, align 4
  %76 = add i32 %75, %c175
  %77 = sext i32 %76 to i64
  %arr.len176 = load i64, ptr %a172, align 8
  %arr.oob177 = icmp uge i64 %77, %arr.len176
  br i1 %arr.oob177, label %idx.bad178, label %idx.ok179, !prof !8

for.update168:                                    ; preds = %idx.ok201
  %78 = load i32, ptr %c165, align 4
  %79 = add i32 %78, 1
  store i32 %79, ptr %c165, align 4
  br label %for.cond166

for.end169:                                       ; preds = %for.cond166
  br label %for.update138

idx.bad178:                                       ; preds = %for.body167
  call void @__polaron_fail(ptr @.fail.3806, ptr @.faila.3807, i64 %77, ptr @.failb.3808, i64 %arr.len176, i32 70)
  unreachable

idx.ok179:                                        ; preds = %for.body167
  %arr.data180 = getelementptr i8, ptr %a172, i64 8
  %arr.elem181 = getelementptr inbounds double, ptr %arr.data180, i64 %77
  %a182 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %r183 = load i32, ptr %r135, align 4
  %n184 = load i32, ptr %n, align 4
  %80 = mul i32 %r183, %n184
  %c185 = load i32, ptr %c165, align 4
  %81 = add i32 %80, %c185
  %82 = sext i32 %81 to i64
  %arr.len186 = load i64, ptr %a182, align 8
  %arr.oob187 = icmp uge i64 %82, %arr.len186
  br i1 %arr.oob187, label %idx.bad188, label %idx.ok189, !prof !8

idx.bad188:                                       ; preds = %idx.ok179
  call void @__polaron_fail(ptr @.fail.3809, ptr @.faila.3810, i64 %82, ptr @.failb.3811, i64 %arr.len186, i32 70)
  unreachable

idx.ok189:                                        ; preds = %idx.ok179
  %arr.data190 = getelementptr i8, ptr %a182, i64 8
  %arr.elem191 = getelementptr inbounds double, ptr %arr.data190, i64 %82
  %elem192 = load double, ptr %arr.elem191, align 8
  %f193 = load double, ptr %f, align 8
  %a194 = load ptr, ptr %a, align 8, !nonnull !6, !dereferenceable !7
  %col195 = load i32, ptr %col, align 4
  %n196 = load i32, ptr %n, align 4
  %83 = mul i32 %col195, %n196
  %c197 = load i32, ptr %c165, align 4
  %84 = add i32 %83, %c197
  %85 = sext i32 %84 to i64
  %arr.len198 = load i64, ptr %a194, align 8
  %arr.oob199 = icmp uge i64 %85, %arr.len198
  br i1 %arr.oob199, label %idx.bad200, label %idx.ok201, !prof !8

idx.bad200:                                       ; preds = %idx.ok189
  call void @__polaron_fail(ptr @.fail.3812, ptr @.faila.3813, i64 %85, ptr @.failb.3814, i64 %arr.len198, i32 70)
  unreachable

idx.ok201:                                        ; preds = %idx.ok189
  %arr.data202 = getelementptr i8, ptr %a194, i64 8
  %arr.elem203 = getelementptr inbounds double, ptr %arr.data202, i64 %85
  %elem204 = load double, ptr %arr.elem203, align 8
  %86 = fmul double %f193, %elem204
  %87 = fsub double %elem192, %86
  store double %87, ptr %arr.elem181, align 8
  br label %for.update168
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
