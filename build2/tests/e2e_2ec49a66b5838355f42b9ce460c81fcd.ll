; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/numerics.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/numerics.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [32 x i8] c"sqrt2=%.6f exp1=%.6f ln_e=%.6f\0A\00", align 1
@.str.1 = private unnamed_addr constant [28 x i8] c"sin=%.6f cos=%.6f pow=%.4f\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

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
  %16 = call double @Numerics.sqrt(double 2.000000e+00)
  %17 = call double @Numerics.exp(double 1.000000e+00)
  %18 = call double @Numerics.ln(double 0x4005BF0A8B145769)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, double %16, double %17, double %18)
  %20 = call double @Numerics.pi()
  %21 = fdiv double %20, 2.000000e+00
  %22 = call double @Numerics.sin(double %21)
  %23 = call double @Numerics.cos(double 0.000000e+00)
  %24 = call double @Numerics.pow(double 2.000000e+00, double 1.000000e+01)
  %25 = call i32 (ptr, ...) @printf(ptr @.str.1, double %22, double %23, double %24)
  ret i32 0
}

define internal double @Numerics.pi() {
entry:
  ret double 0x400921FB54442D18
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

define internal double @Numerics.ln(double %0) {
entry:
  %k = alloca i32, align 4
  %sum = alloca double, align 8
  %term = alloca double, align 8
  %t2 = alloca double, align 8
  %t = alloca double, align 8
  %e = alloca i32, align 4
  %v = alloca double, align 8
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
  store double %x2, ptr %v, align 8
  store i32 0, ptr %e, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %v3 = load double, ptr %v, align 8
  %3 = fcmp oge double %v3, 2.000000e+00
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v4 = load double, ptr %v, align 8
  %5 = fdiv double %v4, 2.000000e+00
  store double %5, ptr %v, align 8
  %e5 = load i32, ptr %e, align 4
  %6 = add i32 %e5, 1
  store i32 %6, ptr %e, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %while.cond6

while.cond6:                                      ; preds = %while.body7, %while.end
  %v9 = load double, ptr %v, align 8
  %7 = fcmp olt double %v9, 1.000000e+00
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body7, label %while.end8

while.body7:                                      ; preds = %while.cond6
  %v10 = load double, ptr %v, align 8
  %9 = fmul double %v10, 2.000000e+00
  store double %9, ptr %v, align 8
  %e11 = load i32, ptr %e, align 4
  %10 = sub i32 %e11, 1
  store i32 %10, ptr %e, align 4
  br label %while.cond6

while.end8:                                       ; preds = %while.cond6
  %v12 = load double, ptr %v, align 8
  %11 = fsub double %v12, 1.000000e+00
  %v13 = load double, ptr %v, align 8
  %12 = fadd double %v13, 1.000000e+00
  %13 = fdiv double %11, %12
  store double %13, ptr %t, align 8
  %t14 = load double, ptr %t, align 8
  %t15 = load double, ptr %t, align 8
  %14 = fmul double %t14, %t15
  store double %14, ptr %t2, align 8
  %t16 = load double, ptr %t, align 8
  store double %t16, ptr %term, align 8
  store double 0.000000e+00, ptr %sum, align 8
  store i32 1, ptr %k, align 4
  br label %while.cond17

while.cond17:                                     ; preds = %while.body18, %while.end8
  %k20 = load i32, ptr %k, align 4
  %15 = icmp sle i32 %k20, 25
  %16 = zext i1 %15 to i32
  br i1 %15, label %while.body18, label %while.end19

while.body18:                                     ; preds = %while.cond17
  %sum21 = load double, ptr %sum, align 8
  %term22 = load double, ptr %term, align 8
  %k23 = load i32, ptr %k, align 4
  %17 = sitofp i32 %k23 to double
  %18 = fdiv double %term22, %17
  %19 = fadd double %sum21, %18
  store double %19, ptr %sum, align 8
  %term24 = load double, ptr %term, align 8
  %t225 = load double, ptr %t2, align 8
  %20 = fmul double %term24, %t225
  store double %20, ptr %term, align 8
  %k26 = load i32, ptr %k, align 4
  %21 = add i32 %k26, 2
  store i32 %21, ptr %k, align 4
  br label %while.cond17

while.end19:                                      ; preds = %while.cond17
  %sum27 = load double, ptr %sum, align 8
  %22 = fmul double 2.000000e+00, %sum27
  %e28 = load i32, ptr %e, align 4
  %23 = sitofp i32 %e28 to double
  %24 = fmul double %23, 0x3FE62E42FEFA39EF
  %25 = fadd double %22, %24
  ret double %25
}

define internal double @Numerics.exp(double %0) {
entry:
  %i27 = alloca i32, align 4
  %i19 = alloca i32, align 4
  %kk = alloca i32, align 4
  %p = alloca double, align 8
  %i = alloca i32, align 4
  %sum = alloca double, align 8
  %term = alloca double, align 8
  %r = alloca double, align 8
  %k = alloca i32, align 4
  %xr = alloca double, align 8
  %ln2 = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  store double 0x3FE62E42FEFA39EF, ptr %ln2, align 8
  %x1 = load double, ptr %x, align 8
  %ln22 = load double, ptr %ln2, align 8
  %1 = fdiv double %x1, %ln22
  store double %1, ptr %xr, align 8
  %xr3 = load double, ptr %xr, align 8
  %2 = fadd double %xr3, 5.000000e-01
  %3 = call i32 @llvm.fptosi.sat.i32.f64(double %2)
  store i32 %3, ptr %k, align 4
  %x4 = load double, ptr %x, align 8
  %4 = fcmp olt double %x4, 0.000000e+00
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %xr5 = load double, ptr %xr, align 8
  %6 = fsub double %xr5, 5.000000e-01
  %7 = call i32 @llvm.fptosi.sat.i32.f64(double %6)
  store i32 %7, ptr %k, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %x6 = load double, ptr %x, align 8
  %k7 = load i32, ptr %k, align 4
  %8 = sitofp i32 %k7 to double
  %ln28 = load double, ptr %ln2, align 8
  %9 = fmul double %8, %ln28
  %10 = fsub double %x6, %9
  store double %10, ptr %r, align 8
  store double 1.000000e+00, ptr %term, align 8
  store double 1.000000e+00, ptr %sum, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i9 = load i32, ptr %i, align 4
  %11 = icmp sle i32 %i9, 18
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %term10 = load double, ptr %term, align 8
  %r11 = load double, ptr %r, align 8
  %13 = fmul double %term10, %r11
  %i12 = load i32, ptr %i, align 4
  %14 = sitofp i32 %i12 to double
  %15 = fdiv double %13, %14
  store double %15, ptr %term, align 8
  %sum13 = load double, ptr %sum, align 8
  %term14 = load double, ptr %term, align 8
  %16 = fadd double %sum13, %term14
  store double %16, ptr %sum, align 8
  br label %for.update

for.update:                                       ; preds = %for.body
  %17 = load i32, ptr %i, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store double 1.000000e+00, ptr %p, align 8
  %k15 = load i32, ptr %k, align 4
  store i32 %k15, ptr %kk, align 4
  %kk16 = load i32, ptr %kk, align 4
  %19 = icmp sge i32 %kk16, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then17, label %if.else

if.then17:                                        ; preds = %for.end
  store i32 0, ptr %i19, align 4
  br label %for.cond20

if.else:                                          ; preds = %for.end
  store i32 0, ptr %i27, align 4
  br label %for.cond28

if.end18:                                         ; preds = %for.end31, %for.end23
  %sum35 = load double, ptr %sum, align 8
  %p36 = load double, ptr %p, align 8
  %21 = fmul double %sum35, %p36
  ret double %21

for.cond20:                                       ; preds = %for.update22, %if.then17
  %i24 = load i32, ptr %i19, align 4
  %kk25 = load i32, ptr %kk, align 4
  %22 = icmp slt i32 %i24, %kk25
  %23 = zext i1 %22 to i32
  br i1 %22, label %for.body21, label %for.end23

for.body21:                                       ; preds = %for.cond20
  %p26 = load double, ptr %p, align 8
  %24 = fmul double %p26, 2.000000e+00
  store double %24, ptr %p, align 8
  br label %for.update22

for.update22:                                     ; preds = %for.body21
  %25 = load i32, ptr %i19, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %i19, align 4
  br label %for.cond20

for.end23:                                        ; preds = %for.cond20
  br label %if.end18

for.cond28:                                       ; preds = %for.update30, %if.else
  %i32 = load i32, ptr %i27, align 4
  %kk33 = load i32, ptr %kk, align 4
  %27 = sub i32 0, %kk33
  %28 = icmp slt i32 %i32, %27
  %29 = zext i1 %28 to i32
  br i1 %28, label %for.body29, label %for.end31

for.body29:                                       ; preds = %for.cond28
  %p34 = load double, ptr %p, align 8
  %30 = fdiv double %p34, 2.000000e+00
  store double %30, ptr %p, align 8
  br label %for.update30

for.update30:                                     ; preds = %for.body29
  %31 = load i32, ptr %i27, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %i27, align 4
  br label %for.cond28

for.end31:                                        ; preds = %for.cond28
  br label %if.end18
}

define internal double @Numerics.reduce(double %0) {
entry:
  %r = alloca double, align 8
  %tau = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  store double 0x401921FB54442D18, ptr %tau, align 8
  %x1 = load double, ptr %x, align 8
  store double %x1, ptr %r, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %r2 = load double, ptr %r, align 8
  %1 = fcmp ogt double %r2, 0x400921FB54442D18
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %r3 = load double, ptr %r, align 8
  %tau4 = load double, ptr %tau, align 8
  %3 = fsub double %r3, %tau4
  store double %3, ptr %r, align 8
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %while.cond5

while.cond5:                                      ; preds = %while.body6, %while.end
  %r8 = load double, ptr %r, align 8
  %4 = fcmp olt double %r8, 0xC00921FB54442D18
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body6, label %while.end7

while.body6:                                      ; preds = %while.cond5
  %r9 = load double, ptr %r, align 8
  %tau10 = load double, ptr %tau, align 8
  %6 = fadd double %r9, %tau10
  store double %6, ptr %r, align 8
  br label %while.cond5

while.end7:                                       ; preds = %while.cond5
  %r11 = load double, ptr %r, align 8
  ret double %r11
}

define internal double @Numerics.sin(double %0) {
entry:
  %n = alloca i32, align 4
  %sum = alloca double, align 8
  %term = alloca double, align 8
  %r24 = alloca double, align 8
  %r = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = call double @Numerics.reduce(double %x1)
  store double %1, ptr %r, align 8
  %r2 = load double, ptr %r, align 8
  %r3 = load double, ptr %r, align 8
  %2 = fmul double %r2, %r3
  store double %2, ptr %r24, align 8
  %r5 = load double, ptr %r, align 8
  store double %r5, ptr %term, align 8
  %r6 = load double, ptr %r, align 8
  store double %r6, ptr %sum, align 8
  store i32 1, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %n7 = load i32, ptr %n, align 4
  %3 = icmp sle i32 %n7, 12
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %term8 = load double, ptr %term, align 8
  %r29 = load double, ptr %r24, align 8
  %5 = fmul double %term8, %r29
  %n10 = load i32, ptr %n, align 4
  %6 = mul i32 2, %n10
  %n11 = load i32, ptr %n, align 4
  %7 = mul i32 2, %n11
  %8 = add i32 %7, 1
  %9 = mul i32 %6, %8
  %10 = sitofp i32 %9 to double
  %11 = fdiv double %5, %10
  %12 = fsub double 0.000000e+00, %11
  store double %12, ptr %term, align 8
  %sum12 = load double, ptr %sum, align 8
  %term13 = load double, ptr %term, align 8
  %13 = fadd double %sum12, %term13
  store double %13, ptr %sum, align 8
  %n14 = load i32, ptr %n, align 4
  %14 = add i32 %n14, 1
  store i32 %14, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %sum15 = load double, ptr %sum, align 8
  ret double %sum15
}

define internal double @Numerics.cos(double %0) {
entry:
  %n = alloca i32, align 4
  %sum = alloca double, align 8
  %term = alloca double, align 8
  %r24 = alloca double, align 8
  %r = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = call double @Numerics.reduce(double %x1)
  store double %1, ptr %r, align 8
  %r2 = load double, ptr %r, align 8
  %r3 = load double, ptr %r, align 8
  %2 = fmul double %r2, %r3
  store double %2, ptr %r24, align 8
  store double 1.000000e+00, ptr %term, align 8
  store double 1.000000e+00, ptr %sum, align 8
  store i32 1, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %n5 = load i32, ptr %n, align 4
  %3 = icmp sle i32 %n5, 12
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %term6 = load double, ptr %term, align 8
  %r27 = load double, ptr %r24, align 8
  %5 = fmul double %term6, %r27
  %n8 = load i32, ptr %n, align 4
  %6 = mul i32 2, %n8
  %7 = sub i32 %6, 1
  %n9 = load i32, ptr %n, align 4
  %8 = mul i32 2, %n9
  %9 = mul i32 %7, %8
  %10 = sitofp i32 %9 to double
  %11 = fdiv double %5, %10
  %12 = fsub double 0.000000e+00, %11
  store double %12, ptr %term, align 8
  %sum10 = load double, ptr %sum, align 8
  %term11 = load double, ptr %term, align 8
  %13 = fadd double %sum10, %term11
  store double %13, ptr %sum, align 8
  %n12 = load i32, ptr %n, align 4
  %14 = add i32 %n12, 1
  store i32 %14, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %sum13 = load double, ptr %sum, align 8
  ret double %sum13
}

define internal double @Numerics.pow(double %0, double %1) {
entry:
  %e = alloca double, align 8
  %b = alloca double, align 8
  store double %0, ptr %b, align 8
  store double %1, ptr %e, align 8
  %b1 = load double, ptr %b, align 8
  %2 = fcmp ole double %b1, 0.000000e+00
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret double 0.000000e+00

if.end:                                           ; preds = %entry
  %e2 = load double, ptr %e, align 8
  %b3 = load double, ptr %b, align 8
  %4 = call double @Numerics.ln(double %b3)
  %5 = fmul double %e2, %4
  %6 = call double @Numerics.exp(double %5)
  ret double %6
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5307)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5309)
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

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
