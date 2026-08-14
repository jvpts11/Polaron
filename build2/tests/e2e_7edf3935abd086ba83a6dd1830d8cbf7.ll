; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graphics_math.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graphics_math.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Vector2 = type { ptr, double, double }
%class.Vector4 = type { ptr, double, double, double, double }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Vector2.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector2.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @Vector2.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector2.sub, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector2.dot, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector2.scale, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Vector4.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector4.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @Vector4.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector4.dot, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [29 x i8] c"len=%.2f dot=%.2f addx=%.2f\0A\00", align 1
@.str.1 = private unnamed_addr constant [12 x i8] c"v4len=%.2f\0A\00", align 1
@.str.2 = private unnamed_addr constant [33 x i8] c"qi=%.3f qo=%.3f ci=%.3f co=%.3f\0A\00", align 1
@.str.3 = private unnamed_addr constant [19 x i8] c"rad=%.4f deg=%.1f\0A\00", align 1
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %v = alloca ptr, align 8
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
  %Vector2.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector2, ptr null, i64 1) to i64))
  call void @Vector2.Vector2(ptr %Vector2.obj, double 3.000000e+00, double 4.000000e+00)
  store ptr %Vector2.obj, ptr %a, align 8
  %Vector2.obj1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector2, ptr null, i64 1) to i64))
  call void @Vector2.Vector2(ptr %Vector2.obj1, double 1.000000e+00, double 2.000000e+00)
  store ptr %Vector2.obj1, ptr %b, align 8
  %a2 = load ptr, ptr %a, align 8
  %16 = call double @Vector2.length(ptr %a2)
  %a3 = load ptr, ptr %a, align 8
  %b4 = load ptr, ptr %b, align 8
  %17 = call double @Vector2.dot(ptr %a3, ptr %b4)
  %a5 = load ptr, ptr %a, align 8
  %b6 = load ptr, ptr %b, align 8
  %18 = call ptr @Vector2.add(ptr %a5, ptr %b6)
  %x = getelementptr inbounds %class.Vector2, ptr %18, i32 0, i32 1
  %x7 = load double, ptr %x, align 8, !tbaa !0
  %19 = call i32 (ptr, ...) @printf(ptr @.str, double %16, double %17, double %x7)
  %Vector4.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector4, ptr null, i64 1) to i64))
  call void @Vector4.Vector4(ptr %Vector4.obj, double 2.000000e+00, double 3.000000e+00, double 6.000000e+00, double 0.000000e+00)
  store ptr %Vector4.obj, ptr %v, align 8
  %v8 = load ptr, ptr %v, align 8
  %20 = call double @Vector4.length(ptr %v8)
  %21 = call i32 (ptr, ...) @printf(ptr @.str.1, double %20)
  %22 = call double @Easing.quadIn(double 5.000000e-01)
  %23 = call double @Easing.quadOut(double 5.000000e-01)
  %24 = call double @Easing.cubicIn(double 5.000000e-01)
  %25 = call double @Easing.cubicOut(double 5.000000e-01)
  %26 = call i32 (ptr, ...) @printf(ptr @.str.2, double %22, double %23, double %24, double %25)
  %27 = call double @Angle.toRadians(double 1.800000e+02)
  %28 = call double @Numerics.pi()
  %29 = call double @Angle.toDegrees(double %28)
  %30 = call i32 (ptr, ...) @printf(ptr @.str.3, double %27, double %29)
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  ret void
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

define internal void @Vector2.Vector2(ptr %0, double %1, double %2) {
entry:
  %y = alloca double, align 8
  %x = alloca double, align 8
  store double %1, ptr %x, align 8
  store double %2, ptr %y, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 0
  store ptr @Vector2.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  %x1 = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 1
  %x2 = load double, ptr %x, align 8
  store double %x2, ptr %x1, align 8, !tbaa !0
  %y3 = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 2
  %y4 = load double, ptr %y, align 8
  store double %y4, ptr %y3, align 8, !tbaa !0
  ret void
}

define internal ptr @Vector2.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Vector2.copy = alloca %class.Vector2, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector2.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector2, ptr null, i64 1) to i64))
  store ptr %Vector2.copy, ptr %o, align 8
  %Vector2.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector2, ptr null, i64 1) to i64))
  %x = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !0
  %o2 = load ptr, ptr %o, align 8
  %x3 = getelementptr inbounds %class.Vector2, ptr %o2, i32 0, i32 1
  %x4 = load double, ptr %x3, align 8, !tbaa !0
  %3 = fadd double %x1, %x4
  %y = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 2
  %y5 = load double, ptr %y, align 8, !tbaa !0
  %o6 = load ptr, ptr %o, align 8
  %y7 = getelementptr inbounds %class.Vector2, ptr %o6, i32 0, i32 2
  %y8 = load double, ptr %y7, align 8, !tbaa !0
  %4 = fadd double %y5, %y8
  call void @Vector2.Vector2(ptr %Vector2.obj, double %3, double %4)
  ret ptr %Vector2.obj
}

define internal ptr @Vector2.sub(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Vector2.copy = alloca %class.Vector2, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector2.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector2, ptr null, i64 1) to i64))
  store ptr %Vector2.copy, ptr %o, align 8
  %Vector2.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector2, ptr null, i64 1) to i64))
  %x = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !0
  %o2 = load ptr, ptr %o, align 8
  %x3 = getelementptr inbounds %class.Vector2, ptr %o2, i32 0, i32 1
  %x4 = load double, ptr %x3, align 8, !tbaa !0
  %3 = fsub double %x1, %x4
  %y = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 2
  %y5 = load double, ptr %y, align 8, !tbaa !0
  %o6 = load ptr, ptr %o, align 8
  %y7 = getelementptr inbounds %class.Vector2, ptr %o6, i32 0, i32 2
  %y8 = load double, ptr %y7, align 8, !tbaa !0
  %4 = fsub double %y5, %y8
  call void @Vector2.Vector2(ptr %Vector2.obj, double %3, double %4)
  ret ptr %Vector2.obj
}

define internal ptr @Vector2.scale(ptr nonnull align 8 dereferenceable(24) %0, double %1) {
entry:
  %s = alloca double, align 8
  store double %1, ptr %s, align 8
  %Vector2.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector2, ptr null, i64 1) to i64))
  %x = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !0
  %s2 = load double, ptr %s, align 8
  %2 = fmul double %x1, %s2
  %y = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 2
  %y3 = load double, ptr %y, align 8, !tbaa !0
  %s4 = load double, ptr %s, align 8
  %3 = fmul double %y3, %s4
  call void @Vector2.Vector2(ptr %Vector2.obj, double %2, double %3)
  ret ptr %Vector2.obj
}

define internal double @Vector2.dot(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Vector2.copy = alloca %class.Vector2, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector2.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector2, ptr null, i64 1) to i64))
  store ptr %Vector2.copy, ptr %o, align 8
  %x = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !0
  %o2 = load ptr, ptr %o, align 8
  %x3 = getelementptr inbounds %class.Vector2, ptr %o2, i32 0, i32 1
  %x4 = load double, ptr %x3, align 8, !tbaa !0
  %3 = fmul double %x1, %x4
  %y = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 2
  %y5 = load double, ptr %y, align 8, !tbaa !0
  %o6 = load ptr, ptr %o, align 8
  %y7 = getelementptr inbounds %class.Vector2, ptr %o6, i32 0, i32 2
  %y8 = load double, ptr %y7, align 8, !tbaa !0
  %4 = fmul double %y5, %y8
  %5 = fadd double %3, %4
  ret double %5
}

define internal double @Vector2.length(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %x = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !0
  %x2 = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 1
  %x3 = load double, ptr %x2, align 8, !tbaa !0
  %1 = fmul double %x1, %x3
  %y = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 2
  %y4 = load double, ptr %y, align 8, !tbaa !0
  %y5 = getelementptr inbounds %class.Vector2, ptr %0, i32 0, i32 2
  %y6 = load double, ptr %y5, align 8, !tbaa !0
  %2 = fmul double %y4, %y6
  %3 = fadd double %1, %2
  %4 = call double @Numerics.sqrt(double %3)
  ret double %4
}

define internal void @Vector4.Vector4(ptr %0, double %1, double %2, double %3, double %4) {
entry:
  %w = alloca double, align 8
  %z = alloca double, align 8
  %y = alloca double, align 8
  %x = alloca double, align 8
  store double %1, ptr %x, align 8
  store double %2, ptr %y, align 8
  store double %3, ptr %z, align 8
  store double %4, ptr %w, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 0
  store ptr @Vector4.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  %x1 = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 1
  %x2 = load double, ptr %x, align 8
  store double %x2, ptr %x1, align 8, !tbaa !0
  %y3 = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 2
  %y4 = load double, ptr %y, align 8
  store double %y4, ptr %y3, align 8, !tbaa !0
  %z5 = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 3
  %z6 = load double, ptr %z, align 8
  store double %z6, ptr %z5, align 8, !tbaa !0
  %w7 = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 4
  %w8 = load double, ptr %w, align 8
  store double %w8, ptr %w7, align 8, !tbaa !0
  ret void
}

define internal ptr @Vector4.add(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %Vector4.copy = alloca %class.Vector4, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector4.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector4, ptr null, i64 1) to i64))
  store ptr %Vector4.copy, ptr %o, align 8
  %Vector4.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector4, ptr null, i64 1) to i64))
  %x = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !0
  %o2 = load ptr, ptr %o, align 8
  %x3 = getelementptr inbounds %class.Vector4, ptr %o2, i32 0, i32 1
  %x4 = load double, ptr %x3, align 8, !tbaa !0
  %3 = fadd double %x1, %x4
  %y = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 2
  %y5 = load double, ptr %y, align 8, !tbaa !0
  %o6 = load ptr, ptr %o, align 8
  %y7 = getelementptr inbounds %class.Vector4, ptr %o6, i32 0, i32 2
  %y8 = load double, ptr %y7, align 8, !tbaa !0
  %4 = fadd double %y5, %y8
  %z = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 3
  %z9 = load double, ptr %z, align 8, !tbaa !0
  %o10 = load ptr, ptr %o, align 8
  %z11 = getelementptr inbounds %class.Vector4, ptr %o10, i32 0, i32 3
  %z12 = load double, ptr %z11, align 8, !tbaa !0
  %5 = fadd double %z9, %z12
  %w = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 4
  %w13 = load double, ptr %w, align 8, !tbaa !0
  %o14 = load ptr, ptr %o, align 8
  %w15 = getelementptr inbounds %class.Vector4, ptr %o14, i32 0, i32 4
  %w16 = load double, ptr %w15, align 8, !tbaa !0
  %6 = fadd double %w13, %w16
  call void @Vector4.Vector4(ptr %Vector4.obj, double %3, double %4, double %5, double %6)
  ret ptr %Vector4.obj
}

define internal double @Vector4.dot(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %Vector4.copy = alloca %class.Vector4, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector4.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector4, ptr null, i64 1) to i64))
  store ptr %Vector4.copy, ptr %o, align 8
  %x = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !0
  %o2 = load ptr, ptr %o, align 8
  %x3 = getelementptr inbounds %class.Vector4, ptr %o2, i32 0, i32 1
  %x4 = load double, ptr %x3, align 8, !tbaa !0
  %3 = fmul double %x1, %x4
  %y = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 2
  %y5 = load double, ptr %y, align 8, !tbaa !0
  %o6 = load ptr, ptr %o, align 8
  %y7 = getelementptr inbounds %class.Vector4, ptr %o6, i32 0, i32 2
  %y8 = load double, ptr %y7, align 8, !tbaa !0
  %4 = fmul double %y5, %y8
  %5 = fadd double %3, %4
  %z = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 3
  %z9 = load double, ptr %z, align 8, !tbaa !0
  %o10 = load ptr, ptr %o, align 8
  %z11 = getelementptr inbounds %class.Vector4, ptr %o10, i32 0, i32 3
  %z12 = load double, ptr %z11, align 8, !tbaa !0
  %6 = fmul double %z9, %z12
  %7 = fadd double %5, %6
  %w = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 4
  %w13 = load double, ptr %w, align 8, !tbaa !0
  %o14 = load ptr, ptr %o, align 8
  %w15 = getelementptr inbounds %class.Vector4, ptr %o14, i32 0, i32 4
  %w16 = load double, ptr %w15, align 8, !tbaa !0
  %8 = fmul double %w13, %w16
  %9 = fadd double %7, %8
  ret double %9
}

define internal double @Vector4.length(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %x = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !0
  %x2 = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 1
  %x3 = load double, ptr %x2, align 8, !tbaa !0
  %1 = fmul double %x1, %x3
  %y = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 2
  %y4 = load double, ptr %y, align 8, !tbaa !0
  %y5 = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 2
  %y6 = load double, ptr %y5, align 8, !tbaa !0
  %2 = fmul double %y4, %y6
  %3 = fadd double %1, %2
  %z = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 3
  %z7 = load double, ptr %z, align 8, !tbaa !0
  %z8 = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 3
  %z9 = load double, ptr %z8, align 8, !tbaa !0
  %4 = fmul double %z7, %z9
  %5 = fadd double %3, %4
  %w = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 4
  %w10 = load double, ptr %w, align 8, !tbaa !0
  %w11 = getelementptr inbounds %class.Vector4, ptr %0, i32 0, i32 4
  %w12 = load double, ptr %w11, align 8, !tbaa !0
  %6 = fmul double %w10, %w12
  %7 = fadd double %5, %6
  %8 = call double @Numerics.sqrt(double %7)
  ret double %8
}

define internal double @Easing.quadIn(double %0) {
entry:
  %t = alloca double, align 8
  store double %0, ptr %t, align 8
  %t1 = load double, ptr %t, align 8
  %t2 = load double, ptr %t, align 8
  %1 = fmul double %t1, %t2
  ret double %1
}

define internal double @Easing.quadOut(double %0) {
entry:
  %t = alloca double, align 8
  store double %0, ptr %t, align 8
  %t1 = load double, ptr %t, align 8
  %t2 = load double, ptr %t, align 8
  %1 = fsub double 2.000000e+00, %t2
  %2 = fmul double %t1, %1
  ret double %2
}

define internal double @Easing.cubicIn(double %0) {
entry:
  %t = alloca double, align 8
  store double %0, ptr %t, align 8
  %t1 = load double, ptr %t, align 8
  %t2 = load double, ptr %t, align 8
  %1 = fmul double %t1, %t2
  %t3 = load double, ptr %t, align 8
  %2 = fmul double %1, %t3
  ret double %2
}

define internal double @Easing.cubicOut(double %0) {
entry:
  %u = alloca double, align 8
  %t = alloca double, align 8
  store double %0, ptr %t, align 8
  %t1 = load double, ptr %t, align 8
  %1 = fsub double 1.000000e+00, %t1
  store double %1, ptr %u, align 8
  %u2 = load double, ptr %u, align 8
  %u3 = load double, ptr %u, align 8
  %2 = fmul double %u2, %u3
  %u4 = load double, ptr %u, align 8
  %3 = fmul double %2, %u4
  %4 = fsub double 1.000000e+00, %3
  ret double %4
}

define internal double @Angle.toRadians(double %0) {
entry:
  %deg = alloca double, align 8
  store double %0, ptr %deg, align 8
  %deg1 = load double, ptr %deg, align 8
  %1 = call double @Numerics.pi()
  %2 = fmul double %deg1, %1
  %3 = fdiv double %2, 1.800000e+02
  ret double %3
}

define internal double @Angle.toDegrees(double %0) {
entry:
  %rad = alloca double, align 8
  store double %0, ptr %rad, align 8
  %rad1 = load double, ptr %rad, align 8
  %1 = fmul double %rad1, 1.800000e+02
  %2 = call double @Numerics.pi()
  %3 = fdiv double %1, %2
  ret double %3
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

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"f64", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"ptr", !2, i64 0}
