; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quaternion.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quaternion.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Quaternion = type { ptr, double, double, double, double }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Quaternion.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Quaternion.mul, ptr null, ptr null, ptr null, ptr @Quaternion.conjugate, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Quaternion.getW, ptr @Quaternion.getX, ptr @Quaternion.getY, ptr @Quaternion.getZ, ptr @Quaternion.magnitude, ptr @Quaternion.normalize, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [55 x i8] c"mag=%.4f pw=%.1f px=%.1f py=%.1f pz=%.1f normmag=%.4f\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %nn = alloca ptr, align 8
  %p = alloca ptr, align 8
  %b = alloca ptr, align 8
  %id = alloca ptr, align 8
  %q = alloca ptr, align 8
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
  %Quaternion.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Quaternion, ptr null, i64 1) to i64))
  call void @Quaternion.Quaternion(ptr %Quaternion.obj, double 1.000000e+00, double 2.000000e+00, double 3.000000e+00, double 4.000000e+00)
  store ptr %Quaternion.obj, ptr %q, align 8
  %Quaternion.obj1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Quaternion, ptr null, i64 1) to i64))
  call void @Quaternion.Quaternion(ptr %Quaternion.obj1, double 1.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00)
  store ptr %Quaternion.obj1, ptr %id, align 8
  %Quaternion.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Quaternion, ptr null, i64 1) to i64))
  call void @Quaternion.Quaternion(ptr %Quaternion.obj2, double 0.000000e+00, double 1.000000e+00, double 0.000000e+00, double 0.000000e+00)
  store ptr %Quaternion.obj2, ptr %b, align 8
  %id3 = load ptr, ptr %id, align 8
  %b4 = load ptr, ptr %b, align 8
  %16 = call ptr @Quaternion.mul(ptr %id3, ptr %b4)
  store ptr %16, ptr %p, align 8
  %q5 = load ptr, ptr %q, align 8
  %17 = call ptr @Quaternion.normalize(ptr %q5)
  store ptr %17, ptr %nn, align 8
  %q6 = load ptr, ptr %q, align 8
  %18 = call double @Quaternion.magnitude(ptr %q6)
  %p7 = load ptr, ptr %p, align 8
  %19 = call double @Quaternion.getW(ptr %p7)
  %p8 = load ptr, ptr %p, align 8
  %20 = call double @Quaternion.getX(ptr %p8)
  %p9 = load ptr, ptr %p, align 8
  %21 = call double @Quaternion.getY(ptr %p9)
  %p10 = load ptr, ptr %p, align 8
  %22 = call double @Quaternion.getZ(ptr %p10)
  %nn11 = load ptr, ptr %nn, align 8
  %23 = call double @Quaternion.magnitude(ptr %nn11)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, double %18, double %19, double %20, double %21, double %22, double %23)
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

define internal void @Quaternion.Quaternion(ptr %0, double %1, double %2, double %3, double %4) {
entry:
  %z = alloca double, align 8
  %y = alloca double, align 8
  %x = alloca double, align 8
  %w = alloca double, align 8
  store double %1, ptr %w, align 8
  store double %2, ptr %x, align 8
  store double %3, ptr %y, align 8
  store double %4, ptr %z, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 0
  store ptr @Quaternion.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %w1 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w2 = load double, ptr %w, align 8
  store double %w2, ptr %w1, align 8, !tbaa !4
  %x3 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x4 = load double, ptr %x, align 8
  store double %x4, ptr %x3, align 8, !tbaa !4
  %y5 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y6 = load double, ptr %y, align 8
  store double %y6, ptr %y5, align 8, !tbaa !4
  %z7 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z8 = load double, ptr %z, align 8
  store double %z8, ptr %z7, align 8, !tbaa !4
  ret void
}

define internal double @Quaternion.getW(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %w = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w1 = load double, ptr %w, align 8, !tbaa !4
  ret double %w1
}

define internal double @Quaternion.getX(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %x = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x1 = load double, ptr %x, align 8, !tbaa !4
  ret double %x1
}

define internal double @Quaternion.getY(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %y = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y1 = load double, ptr %y, align 8, !tbaa !4
  ret double %y1
}

define internal double @Quaternion.getZ(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %z = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z1 = load double, ptr %z, align 8, !tbaa !4
  ret double %z1
}

define internal double @Quaternion.magnitude(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %w = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w1 = load double, ptr %w, align 8, !tbaa !4
  %w2 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w3 = load double, ptr %w2, align 8, !tbaa !4
  %1 = fmul double %w1, %w3
  %x = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x4 = load double, ptr %x, align 8, !tbaa !4
  %x5 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x6 = load double, ptr %x5, align 8, !tbaa !4
  %2 = fmul double %x4, %x6
  %3 = fadd double %1, %2
  %y = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y7 = load double, ptr %y, align 8, !tbaa !4
  %y8 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y9 = load double, ptr %y8, align 8, !tbaa !4
  %4 = fmul double %y7, %y9
  %5 = fadd double %3, %4
  %z = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z10 = load double, ptr %z, align 8, !tbaa !4
  %z11 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z12 = load double, ptr %z11, align 8, !tbaa !4
  %6 = fmul double %z10, %z12
  %7 = fadd double %5, %6
  %8 = call double @Numerics.sqrt(double %7)
  ret double %8
}

define internal ptr @Quaternion.conjugate(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %Quaternion.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Quaternion, ptr null, i64 1) to i64))
  %w = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w1 = load double, ptr %w, align 8, !tbaa !4
  %x = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x2 = load double, ptr %x, align 8, !tbaa !4
  %1 = fsub double 0.000000e+00, %x2
  %y = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y3 = load double, ptr %y, align 8, !tbaa !4
  %2 = fsub double 0.000000e+00, %y3
  %z = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z4 = load double, ptr %z, align 8, !tbaa !4
  %3 = fsub double 0.000000e+00, %z4
  call void @Quaternion.Quaternion(ptr %Quaternion.obj, double %w1, double %1, double %2, double %3)
  ret ptr %Quaternion.obj
}

define internal ptr @Quaternion.mul(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %nz = alloca double, align 8
  %ny = alloca double, align 8
  %nx = alloca double, align 8
  %nw = alloca double, align 8
  %Quaternion.copy = alloca %class.Quaternion, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Quaternion.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Quaternion, ptr null, i64 1) to i64))
  store ptr %Quaternion.copy, ptr %o, align 8
  %w = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w1 = load double, ptr %w, align 8, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Quaternion.getW(ptr %o2)
  %4 = fmul double %w1, %3
  %x = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x3 = load double, ptr %x, align 8, !tbaa !4
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Quaternion.getX(ptr %o4)
  %6 = fmul double %x3, %5
  %7 = fsub double %4, %6
  %y = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y5 = load double, ptr %y, align 8, !tbaa !4
  %o6 = load ptr, ptr %o, align 8
  %8 = call double @Quaternion.getY(ptr %o6)
  %9 = fmul double %y5, %8
  %10 = fsub double %7, %9
  %z = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z7 = load double, ptr %z, align 8, !tbaa !4
  %o8 = load ptr, ptr %o, align 8
  %11 = call double @Quaternion.getZ(ptr %o8)
  %12 = fmul double %z7, %11
  %13 = fsub double %10, %12
  store double %13, ptr %nw, align 8
  %w9 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w10 = load double, ptr %w9, align 8, !tbaa !4
  %o11 = load ptr, ptr %o, align 8
  %14 = call double @Quaternion.getX(ptr %o11)
  %15 = fmul double %w10, %14
  %x12 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x13 = load double, ptr %x12, align 8, !tbaa !4
  %o14 = load ptr, ptr %o, align 8
  %16 = call double @Quaternion.getW(ptr %o14)
  %17 = fmul double %x13, %16
  %18 = fadd double %15, %17
  %y15 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y16 = load double, ptr %y15, align 8, !tbaa !4
  %o17 = load ptr, ptr %o, align 8
  %19 = call double @Quaternion.getZ(ptr %o17)
  %20 = fmul double %y16, %19
  %21 = fadd double %18, %20
  %z18 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z19 = load double, ptr %z18, align 8, !tbaa !4
  %o20 = load ptr, ptr %o, align 8
  %22 = call double @Quaternion.getY(ptr %o20)
  %23 = fmul double %z19, %22
  %24 = fsub double %21, %23
  store double %24, ptr %nx, align 8
  %w21 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w22 = load double, ptr %w21, align 8, !tbaa !4
  %o23 = load ptr, ptr %o, align 8
  %25 = call double @Quaternion.getY(ptr %o23)
  %26 = fmul double %w22, %25
  %x24 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x25 = load double, ptr %x24, align 8, !tbaa !4
  %o26 = load ptr, ptr %o, align 8
  %27 = call double @Quaternion.getZ(ptr %o26)
  %28 = fmul double %x25, %27
  %29 = fsub double %26, %28
  %y27 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y28 = load double, ptr %y27, align 8, !tbaa !4
  %o29 = load ptr, ptr %o, align 8
  %30 = call double @Quaternion.getW(ptr %o29)
  %31 = fmul double %y28, %30
  %32 = fadd double %29, %31
  %z30 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z31 = load double, ptr %z30, align 8, !tbaa !4
  %o32 = load ptr, ptr %o, align 8
  %33 = call double @Quaternion.getX(ptr %o32)
  %34 = fmul double %z31, %33
  %35 = fadd double %32, %34
  store double %35, ptr %ny, align 8
  %w33 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w34 = load double, ptr %w33, align 8, !tbaa !4
  %o35 = load ptr, ptr %o, align 8
  %36 = call double @Quaternion.getZ(ptr %o35)
  %37 = fmul double %w34, %36
  %x36 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x37 = load double, ptr %x36, align 8, !tbaa !4
  %o38 = load ptr, ptr %o, align 8
  %38 = call double @Quaternion.getY(ptr %o38)
  %39 = fmul double %x37, %38
  %40 = fadd double %37, %39
  %y39 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y40 = load double, ptr %y39, align 8, !tbaa !4
  %o41 = load ptr, ptr %o, align 8
  %41 = call double @Quaternion.getX(ptr %o41)
  %42 = fmul double %y40, %41
  %43 = fsub double %40, %42
  %z42 = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z43 = load double, ptr %z42, align 8, !tbaa !4
  %o44 = load ptr, ptr %o, align 8
  %44 = call double @Quaternion.getW(ptr %o44)
  %45 = fmul double %z43, %44
  %46 = fadd double %43, %45
  store double %46, ptr %nz, align 8
  %Quaternion.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Quaternion, ptr null, i64 1) to i64))
  %nw45 = load double, ptr %nw, align 8
  %nx46 = load double, ptr %nx, align 8
  %ny47 = load double, ptr %ny, align 8
  %nz48 = load double, ptr %nz, align 8
  call void @Quaternion.Quaternion(ptr %Quaternion.obj, double %nw45, double %nx46, double %ny47, double %nz48)
  ret ptr %Quaternion.obj
}

define internal ptr @Quaternion.normalize(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %m = alloca double, align 8
  %1 = call double @Quaternion.magnitude(ptr %0)
  store double %1, ptr %m, align 8
  %m1 = load double, ptr %m, align 8
  %2 = fcmp oeq double %m1, 0.000000e+00
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %Quaternion.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Quaternion, ptr null, i64 1) to i64))
  call void @Quaternion.Quaternion(ptr %Quaternion.obj, double 1.000000e+00, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00)
  ret ptr %Quaternion.obj

if.end:                                           ; preds = %entry
  %Quaternion.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Quaternion, ptr null, i64 1) to i64))
  %w = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 1
  %w3 = load double, ptr %w, align 8, !tbaa !4
  %m4 = load double, ptr %m, align 8
  %4 = fdiv double %w3, %m4
  %x = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 2
  %x5 = load double, ptr %x, align 8, !tbaa !4
  %m6 = load double, ptr %m, align 8
  %5 = fdiv double %x5, %m6
  %y = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 3
  %y7 = load double, ptr %y, align 8, !tbaa !4
  %m8 = load double, ptr %m, align 8
  %6 = fdiv double %y7, %m8
  %z = getelementptr inbounds %class.Quaternion, ptr %0, i32 0, i32 4
  %z9 = load double, ptr %z, align 8, !tbaa !4
  %m10 = load double, ptr %m, align 8
  %7 = fdiv double %z9, %m10
  call void @Quaternion.Quaternion(ptr %Quaternion.obj2, double %4, double %5, double %6, double %7)
  ret ptr %Quaternion.obj2
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

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"f64", !2, i64 0}
