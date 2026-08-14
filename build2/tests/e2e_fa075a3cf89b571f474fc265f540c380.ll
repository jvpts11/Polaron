; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interpolation_math.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interpolation_math.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [50 x i8] c"lerp=%.2f inv=%.2f ss=%.2f remap=%.2f clamp=%.2f\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %16 = call double @Interpolation.lerp(double 0.000000e+00, double 1.000000e+01, double 5.000000e-01)
  %17 = call double @Interpolation.inverseLerp(double 0.000000e+00, double 1.000000e+01, double 7.500000e+00)
  %18 = call double @Interpolation.smoothstep(double 0.000000e+00, double 1.000000e+00, double 5.000000e-01)
  %19 = call double @Interpolation.remap(double 5.000000e+00, double 0.000000e+00, double 1.000000e+01, double 0.000000e+00, double 1.000000e+02)
  %20 = call double @Interpolation.clamp(double 1.500000e+01, double 0.000000e+00, double 1.000000e+01)
  %21 = call i32 (ptr, ...) @printf(ptr @.str, double %16, double %17, double %18, double %19, double %20)
  ret i32 0
}

define internal double @Interpolation.lerp(double %0, double %1, double %2) {
entry:
  %t = alloca double, align 8
  %b = alloca double, align 8
  %a = alloca double, align 8
  store double %0, ptr %a, align 8
  store double %1, ptr %b, align 8
  store double %2, ptr %t, align 8
  %a1 = load double, ptr %a, align 8
  %b2 = load double, ptr %b, align 8
  %a3 = load double, ptr %a, align 8
  %3 = fsub double %b2, %a3
  %t4 = load double, ptr %t, align 8
  %4 = fmul double %3, %t4
  %5 = fadd double %a1, %4
  ret double %5
}

define internal double @Interpolation.inverseLerp(double %0, double %1, double %2) {
entry:
  %v = alloca double, align 8
  %b = alloca double, align 8
  %a = alloca double, align 8
  store double %0, ptr %a, align 8
  store double %1, ptr %b, align 8
  store double %2, ptr %v, align 8
  %b1 = load double, ptr %b, align 8
  %a2 = load double, ptr %a, align 8
  %3 = fcmp oeq double %b1, %a2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret double 0.000000e+00

if.end:                                           ; preds = %entry
  %v3 = load double, ptr %v, align 8
  %a4 = load double, ptr %a, align 8
  %5 = fsub double %v3, %a4
  %b5 = load double, ptr %b, align 8
  %a6 = load double, ptr %a, align 8
  %6 = fsub double %b5, %a6
  %7 = fdiv double %5, %6
  ret double %7
}

define internal double @Interpolation.clamp(double %0, double %1, double %2) {
entry:
  %hi = alloca double, align 8
  %lo = alloca double, align 8
  %v = alloca double, align 8
  store double %0, ptr %v, align 8
  store double %1, ptr %lo, align 8
  store double %2, ptr %hi, align 8
  %v1 = load double, ptr %v, align 8
  %lo2 = load double, ptr %lo, align 8
  %3 = fcmp olt double %v1, %lo2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %lo3 = load double, ptr %lo, align 8
  ret double %lo3

if.end:                                           ; preds = %entry
  %v4 = load double, ptr %v, align 8
  %hi5 = load double, ptr %hi, align 8
  %5 = fcmp ogt double %v4, %hi5
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end
  %hi8 = load double, ptr %hi, align 8
  ret double %hi8

if.end7:                                          ; preds = %if.end
  %v9 = load double, ptr %v, align 8
  ret double %v9
}

define internal double @Interpolation.smoothstep(double %0, double %1, double %2) {
entry:
  %t = alloca double, align 8
  %x = alloca double, align 8
  %edge1 = alloca double, align 8
  %edge0 = alloca double, align 8
  store double %0, ptr %edge0, align 8
  store double %1, ptr %edge1, align 8
  store double %2, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %edge02 = load double, ptr %edge0, align 8
  %3 = fsub double %x1, %edge02
  %edge13 = load double, ptr %edge1, align 8
  %edge04 = load double, ptr %edge0, align 8
  %4 = fsub double %edge13, %edge04
  %5 = fdiv double %3, %4
  %6 = call double @Interpolation.clamp(double %5, double 0.000000e+00, double 1.000000e+00)
  store double %6, ptr %t, align 8
  %t5 = load double, ptr %t, align 8
  %t6 = load double, ptr %t, align 8
  %7 = fmul double %t5, %t6
  %t7 = load double, ptr %t, align 8
  %8 = fmul double 2.000000e+00, %t7
  %9 = fsub double 3.000000e+00, %8
  %10 = fmul double %7, %9
  ret double %10
}

define internal double @Interpolation.remap(double %0, double %1, double %2, double %3, double %4) {
entry:
  %t = alloca double, align 8
  %outHi = alloca double, align 8
  %outLo = alloca double, align 8
  %inHi = alloca double, align 8
  %inLo = alloca double, align 8
  %v = alloca double, align 8
  store double %0, ptr %v, align 8
  store double %1, ptr %inLo, align 8
  store double %2, ptr %inHi, align 8
  store double %3, ptr %outLo, align 8
  store double %4, ptr %outHi, align 8
  %inLo1 = load double, ptr %inLo, align 8
  %inHi2 = load double, ptr %inHi, align 8
  %v3 = load double, ptr %v, align 8
  %5 = call double @Interpolation.inverseLerp(double %inLo1, double %inHi2, double %v3)
  store double %5, ptr %t, align 8
  %outLo4 = load double, ptr %outLo, align 8
  %outHi5 = load double, ptr %outHi, align 8
  %t6 = load double, ptr %t, align 8
  %6 = call double @Interpolation.lerp(double %outLo4, double %outHi5, double %t6)
  ret double %6
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

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
