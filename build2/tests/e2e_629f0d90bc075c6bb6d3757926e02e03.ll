; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/simd_vec_ops.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/simd_vec_ops.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [39 x i8] c"dot=%d len=%d nx=%d cx=%d cy=%d cz=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca <3 x float>, align 16
  %n = alloca <3 x float>, align 16
  %len = alloca float, align 4
  %d = alloca float, align 4
  %b = alloca <3 x float>, align 16
  %a = alloca <3 x float>, align 16
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
  store <3 x float> <float 1.000000e+00, float 2.000000e+00, float 2.000000e+00>, ptr %a, align 16
  store <3 x float> <float 3.000000e+00, float 0.000000e+00, float 0.000000e+00>, ptr %b, align 16
  %a1 = load <3 x float>, ptr %a, align 16
  %b2 = load <3 x float>, ptr %b, align 16
  %16 = fmul <3 x float> %a1, %b2
  %17 = extractelement <3 x float> %16, i32 0
  %18 = extractelement <3 x float> %16, i32 1
  %19 = fadd float %17, %18
  %20 = extractelement <3 x float> %16, i32 2
  %21 = fadd float %19, %20
  store float %21, ptr %d, align 4
  %a3 = load <3 x float>, ptr %a, align 16
  %22 = fmul <3 x float> %a3, %a3
  %23 = extractelement <3 x float> %22, i32 0
  %24 = extractelement <3 x float> %22, i32 1
  %25 = fadd float %23, %24
  %26 = extractelement <3 x float> %22, i32 2
  %27 = fadd float %25, %26
  %28 = call float @llvm.sqrt.f32(float %27)
  store float %28, ptr %len, align 4
  %a4 = load <3 x float>, ptr %a, align 16
  %29 = fmul <3 x float> %a4, %a4
  %30 = extractelement <3 x float> %29, i32 0
  %31 = extractelement <3 x float> %29, i32 1
  %32 = fadd float %30, %31
  %33 = extractelement <3 x float> %29, i32 2
  %34 = fadd float %32, %33
  %35 = call float @llvm.sqrt.f32(float %34)
  %.splatinsert = insertelement <3 x float> poison, float %35, i64 0
  %.splat = shufflevector <3 x float> %.splatinsert, <3 x float> poison, <3 x i32> zeroinitializer
  %36 = fdiv <3 x float> %a4, %.splat
  store <3 x float> %36, ptr %n, align 16
  %a5 = load <3 x float>, ptr %a, align 16
  %b6 = load <3 x float>, ptr %b, align 16
  %37 = extractelement <3 x float> %a5, i32 0
  %38 = extractelement <3 x float> %a5, i32 1
  %39 = extractelement <3 x float> %a5, i32 2
  %40 = extractelement <3 x float> %b6, i32 0
  %41 = extractelement <3 x float> %b6, i32 1
  %42 = extractelement <3 x float> %b6, i32 2
  %43 = fmul float %39, %41
  %44 = fmul float %38, %42
  %45 = fsub float %44, %43
  %46 = fmul float %37, %42
  %47 = fmul float %39, %40
  %48 = fsub float %47, %46
  %49 = fmul float %38, %40
  %50 = fmul float %37, %41
  %51 = fsub float %50, %49
  %52 = insertelement <3 x float> undef, float %45, i32 0
  %53 = insertelement <3 x float> %52, float %48, i32 1
  %54 = insertelement <3 x float> %53, float %51, i32 2
  store <3 x float> %54, ptr %c, align 16
  %d7 = load float, ptr %d, align 4
  %55 = call i32 @llvm.fptosi.sat.i32.f32(float %d7)
  %len8 = load float, ptr %len, align 4
  %56 = call i32 @llvm.fptosi.sat.i32.f32(float %len8)
  %n9 = load <3 x float>, ptr %n, align 16
  %x = extractelement <3 x float> %n9, i32 0
  %57 = fpext float %x to double
  %58 = fmul double %57, 3.000000e+01
  %59 = call i32 @llvm.fptosi.sat.i32.f64(double %58)
  %c10 = load <3 x float>, ptr %c, align 16
  %x11 = extractelement <3 x float> %c10, i32 0
  %60 = call i32 @llvm.fptosi.sat.i32.f32(float %x11)
  %c12 = load <3 x float>, ptr %c, align 16
  %y = extractelement <3 x float> %c12, i32 1
  %61 = call i32 @llvm.fptosi.sat.i32.f32(float %y)
  %c13 = load <3 x float>, ptr %c, align 16
  %z = extractelement <3 x float> %c13, i32 2
  %62 = call i32 @llvm.fptosi.sat.i32.f32(float %z)
  %63 = call i32 (ptr, ...) @printf(ptr @.str, i32 %55, i32 %56, i32 %59, i32 %60, i32 %61, i32 %62)
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

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.sqrt.f32(float) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f32(float) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #0

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
