; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fast_inv_sqrt.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fast_inv_sqrt.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.FloatBits = type { float }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [62 x i8] c"rsqrt(4)~=%d/1000  rsqrt(0.25)~=%d/1000  rsqrt(100)~=%d/1000\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @FloatBits.FloatBits(ptr %0) {
entry:
  ret void
}

define internal float @FastMath.invSqrt(float %0) {
entry:
  %y = alloca float, align 4
  %conv = alloca ptr, align 8
  %FloatBits.obj = alloca %class.FloatBits, align 8
  %x2 = alloca float, align 4
  %number = alloca float, align 4
  store float %0, ptr %number, align 4
  %number1 = load float, ptr %number, align 4
  %1 = fpext float %number1 to double
  %2 = fmul double %1, 5.000000e-01
  %3 = fptrunc double %2 to float
  store float %3, ptr %x2, align 4
  %4 = call ptr @memset(ptr %FloatBits.obj, i32 0, i64 ptrtoint (ptr getelementptr (%class.FloatBits, ptr null, i64 1) to i64))
  call void @FloatBits.FloatBits(ptr %FloatBits.obj)
  store ptr %FloatBits.obj, ptr %conv, align 8
  %conv2 = load ptr, ptr %conv, align 8
  %f = getelementptr inbounds %class.FloatBits, ptr %conv2, i32 0, i32 0
  %number3 = load float, ptr %number, align 4
  store float %number3, ptr %f, align 4
  %conv4 = load ptr, ptr %conv, align 8
  %i = getelementptr inbounds %class.FloatBits, ptr %conv4, i32 0, i32 0
  %conv5 = load ptr, ptr %conv, align 8
  %i6 = getelementptr inbounds %class.FloatBits, ptr %conv5, i32 0, i32 0
  %i7 = load i32, ptr %i6, align 4
  %5 = ashr i32 %i7, 31
  %6 = ashr i32 %i7, 1
  %7 = sub i32 1597463007, %6
  store i32 %7, ptr %i, align 4
  %conv8 = load ptr, ptr %conv, align 8
  %f9 = getelementptr inbounds %class.FloatBits, ptr %conv8, i32 0, i32 0
  %f10 = load float, ptr %f9, align 4
  store float %f10, ptr %y, align 4
  %y11 = load float, ptr %y, align 4
  %x212 = load float, ptr %x2, align 4
  %y13 = load float, ptr %y, align 4
  %8 = fmul float %x212, %y13
  %y14 = load float, ptr %y, align 4
  %9 = fmul float %8, %y14
  %10 = fpext float %9 to double
  %11 = fsub double 1.500000e+00, %10
  %12 = fpext float %y11 to double
  %13 = fmul double %12, %11
  %14 = fptrunc double %13 to float
  store float %14, ptr %y, align 4
  %y15 = load float, ptr %y, align 4
  ret float %y15
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca float, align 4
  %b = alloca float, align 4
  %a = alloca float, align 4
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
  %16 = call float @FastMath.invSqrt(float 4.000000e+00)
  store float %16, ptr %a, align 4
  %17 = call float @FastMath.invSqrt(float 2.500000e-01)
  store float %17, ptr %b, align 4
  %18 = call float @FastMath.invSqrt(float 1.000000e+02)
  store float %18, ptr %c, align 4
  %a1 = load float, ptr %a, align 4
  %19 = fpext float %a1 to double
  %20 = fmul double %19, 1.000000e+03
  %21 = call i32 @llvm.fptosi.sat.i32.f64(double %20)
  %b2 = load float, ptr %b, align 4
  %22 = fpext float %b2 to double
  %23 = fmul double %22, 1.000000e+03
  %24 = call i32 @llvm.fptosi.sat.i32.f64(double %23)
  %c3 = load float, ptr %c, align 4
  %25 = fpext float %c3 to double
  %26 = fmul double %25, 1.000000e+03
  %27 = call i32 @llvm.fptosi.sat.i32.f64(double %26)
  %28 = call i32 (ptr, ...) @printf(ptr @.str, i32 %21, i32 %24, i32 %27)
  ret i32 0
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

declare ptr @memset(ptr, i32, i64)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #0

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
