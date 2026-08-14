; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/simd_vectors.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/simd_vectors.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [22 x i8] c"c=%d,%d,%d,%d d.z=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"dot=%d\0A\00", align 1
@.panic = private unnamed_addr constant [27 x i8] c"vector index out of bounds\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"idxsum=%d\0A\00", align 1
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

define internal float @Main.dot3(<3 x float> %0, <3 x float> %1) {
entry:
  %p = alloca <3 x float>, align 16
  %b = alloca <3 x float>, align 16
  %a = alloca <3 x float>, align 16
  store <3 x float> %0, ptr %a, align 16
  store <3 x float> %1, ptr %b, align 16
  %a1 = load <3 x float>, ptr %a, align 16
  %b2 = load <3 x float>, ptr %b, align 16
  %2 = fmul <3 x float> %a1, %b2
  store <3 x float> %2, ptr %p, align 16
  %p3 = load <3 x float>, ptr %p, align 16
  %x = extractelement <3 x float> %p3, i32 0
  %p4 = load <3 x float>, ptr %p, align 16
  %y = extractelement <3 x float> %p4, i32 1
  %3 = fadd float %x, %y
  %p5 = load <3 x float>, ptr %p, align 16
  %z = extractelement <3 x float> %p5, i32 2
  %4 = fadd float %3, %z
  ret float %4
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  %v = alloca <3 x float>, align 16
  %u = alloca <3 x float>, align 16
  %d = alloca <4 x float>, align 16
  %c = alloca <4 x float>, align 16
  %b = alloca <4 x float>, align 16
  %a = alloca <4 x float>, align 16
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
  store <4 x float> <float 1.000000e+00, float 2.000000e+00, float 3.000000e+00, float 4.000000e+00>, ptr %a, align 16
  store <4 x float> <float 1.000000e+01, float 2.000000e+01, float 3.000000e+01, float 4.000000e+01>, ptr %b, align 16
  %a1 = load <4 x float>, ptr %a, align 16
  %b2 = load <4 x float>, ptr %b, align 16
  %16 = fadd <4 x float> %a1, %b2
  store <4 x float> %16, ptr %c, align 16
  %a3 = load <4 x float>, ptr %a, align 16
  %17 = fmul <4 x float> %a3, <float 2.000000e+00, float 2.000000e+00, float 2.000000e+00, float 2.000000e+00>
  store <4 x float> %17, ptr %d, align 16
  %c4 = load <4 x float>, ptr %c, align 16
  %x = extractelement <4 x float> %c4, i32 0
  %18 = call i32 @llvm.fptosi.sat.i32.f32(float %x)
  %c5 = load <4 x float>, ptr %c, align 16
  %y = extractelement <4 x float> %c5, i32 1
  %19 = call i32 @llvm.fptosi.sat.i32.f32(float %y)
  %c6 = load <4 x float>, ptr %c, align 16
  %z = extractelement <4 x float> %c6, i32 2
  %20 = call i32 @llvm.fptosi.sat.i32.f32(float %z)
  %c7 = load <4 x float>, ptr %c, align 16
  %w = extractelement <4 x float> %c7, i32 3
  %21 = call i32 @llvm.fptosi.sat.i32.f32(float %w)
  %d8 = load <4 x float>, ptr %d, align 16
  %z9 = extractelement <4 x float> %d8, i32 2
  %22 = call i32 @llvm.fptosi.sat.i32.f32(float %z9)
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22)
  store <3 x float> <float 1.000000e+00, float 2.000000e+00, float 3.000000e+00>, ptr %u, align 16
  store <3 x float> <float 4.000000e+00, float 5.000000e+00, float 6.000000e+00>, ptr %v, align 16
  %u10 = load <3 x float>, ptr %u, align 16
  %v11 = load <3 x float>, ptr %v, align 16
  %24 = call float @Main.dot3(<3 x float> %u10, <3 x float> %v11)
  %25 = call i32 @llvm.fptosi.sat.i32.f32(float %24)
  %26 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %25)
  store i32 0, ptr %sum, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i12 = load i32, ptr %i, align 4
  %27 = icmp slt i32 %i12, 4
  %28 = zext i1 %27 to i32
  br i1 %27, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sum13 = load i32, ptr %sum, align 4
  %c14 = load <4 x float>, ptr %c, align 16
  %i15 = load i32, ptr %i, align 4
  %29 = sext i32 %i15 to i64
  %30 = icmp uge i64 %29, 4
  br i1 %30, label %vidx.bad, label %vidx.ok, !prof !0

for.update:                                       ; preds = %vidx.ok
  %31 = load i32, ptr %i, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sum16 = load i32, ptr %sum, align 4
  %33 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %sum16)
  ret i32 0

vidx.bad:                                         ; preds = %for.body
  call void @__polaron_panic(ptr @.panic)
  unreachable

vidx.ok:                                          ; preds = %for.body
  %vec.elem = extractelement <4 x float> %c14, i32 %i15
  %34 = call i32 @llvm.fptosi.sat.i32.f32(float %vec.elem)
  %35 = add i32 %sum13, %34
  store i32 %35, ptr %sum, align 4
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5311)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f32(float) #0

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #1

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #1 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!"branch_weights", i32 1, i32 1048576}
