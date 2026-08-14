; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/vector3.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/vector3.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Vector3 = type { ptr, double, double, double }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Vector3.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector3.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @Vector3.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector3.sub, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector3.dot, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector3.scale, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Vector3.getX, ptr @Vector3.getY, ptr @Vector3.getZ, ptr null, ptr @Vector3.normalize, ptr null, ptr null, ptr @Vector3.cross, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [50 x i8] c"cross=%.1f,%.1f,%.1f dot=%.1f len=%.1f nlen=%.4f\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %v = alloca ptr, align 8
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
  %Vector3.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  call void @Vector3.Vector3(ptr %Vector3.obj, double 1.000000e+00, double 0.000000e+00, double 0.000000e+00)
  store ptr %Vector3.obj, ptr %a, align 8
  %Vector3.obj1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  call void @Vector3.Vector3(ptr %Vector3.obj1, double 0.000000e+00, double 1.000000e+00, double 0.000000e+00)
  store ptr %Vector3.obj1, ptr %b, align 8
  %a2 = load ptr, ptr %a, align 8
  %b3 = load ptr, ptr %b, align 8
  %16 = call ptr @Vector3.cross(ptr %a2, ptr %b3)
  store ptr %16, ptr %c, align 8
  %Vector3.obj4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  call void @Vector3.Vector3(ptr %Vector3.obj4, double 3.000000e+00, double 4.000000e+00, double 0.000000e+00)
  store ptr %Vector3.obj4, ptr %v, align 8
  %c5 = load ptr, ptr %c, align 8
  %17 = call double @Vector3.getX(ptr %c5)
  %c6 = load ptr, ptr %c, align 8
  %18 = call double @Vector3.getY(ptr %c6)
  %c7 = load ptr, ptr %c, align 8
  %19 = call double @Vector3.getZ(ptr %c7)
  %a8 = load ptr, ptr %a, align 8
  %b9 = load ptr, ptr %b, align 8
  %20 = call double @Vector3.dot(ptr %a8, ptr %b9)
  %v10 = load ptr, ptr %v, align 8
  %21 = call double @Vector3.length(ptr %v10)
  %v11 = load ptr, ptr %v, align 8
  %22 = call ptr @Vector3.normalize(ptr %v11)
  %23 = call double @Vector3.length(ptr %22)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, double %17, double %18, double %19, double %20, double %21, double %23)
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

define internal void @Vector3.Vector3(ptr %0, double %1, double %2, double %3) {
entry:
  %z = alloca double, align 8
  %y = alloca double, align 8
  %x = alloca double, align 8
  store double %1, ptr %x, align 8
  store double %2, ptr %y, align 8
  store double %3, ptr %z, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 0
  store ptr @Vector3.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %x1 = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 1
  %x2 = load double, ptr %x, align 8
  store double %x2, ptr %x1, align 8, !tbaa !4
  %y3 = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 2
  %y4 = load double, ptr %y, align 8
  store double %y4, ptr %y3, align 8, !tbaa !4
  %z5 = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 3
  %z6 = load double, ptr %z, align 8
  store double %z6, ptr %z5, align 8, !tbaa !4
  ret void
}

define internal double @Vector3.getX(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %x = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !4
  ret double %x1
}

define internal double @Vector3.getY(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %y = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 2
  %y1 = load double, ptr %y, align 8, !tbaa !4
  ret double %y1
}

define internal double @Vector3.getZ(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %z = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 3
  %z1 = load double, ptr %z, align 8, !tbaa !4
  ret double %z1
}

define internal ptr @Vector3.add(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %Vector3.copy = alloca %class.Vector3, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector3.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  store ptr %Vector3.copy, ptr %o, align 8
  %Vector3.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  %x = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Vector3.getX(ptr %o2)
  %4 = fadd double %x1, %3
  %y = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 2
  %y3 = load double, ptr %y, align 8, !tbaa !4
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Vector3.getY(ptr %o4)
  %6 = fadd double %y3, %5
  %z = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 3
  %z5 = load double, ptr %z, align 8, !tbaa !4
  %o6 = load ptr, ptr %o, align 8
  %7 = call double @Vector3.getZ(ptr %o6)
  %8 = fadd double %z5, %7
  call void @Vector3.Vector3(ptr %Vector3.obj, double %4, double %6, double %8)
  ret ptr %Vector3.obj
}

define internal ptr @Vector3.sub(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %Vector3.copy = alloca %class.Vector3, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector3.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  store ptr %Vector3.copy, ptr %o, align 8
  %Vector3.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  %x = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Vector3.getX(ptr %o2)
  %4 = fsub double %x1, %3
  %y = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 2
  %y3 = load double, ptr %y, align 8, !tbaa !4
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Vector3.getY(ptr %o4)
  %6 = fsub double %y3, %5
  %z = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 3
  %z5 = load double, ptr %z, align 8, !tbaa !4
  %o6 = load ptr, ptr %o, align 8
  %7 = call double @Vector3.getZ(ptr %o6)
  %8 = fsub double %z5, %7
  call void @Vector3.Vector3(ptr %Vector3.obj, double %4, double %6, double %8)
  ret ptr %Vector3.obj
}

define internal ptr @Vector3.scale(ptr nonnull align 8 dereferenceable(32) %0, double %1) {
entry:
  %s = alloca double, align 8
  store double %1, ptr %s, align 8
  %Vector3.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  %x = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !4
  %s2 = load double, ptr %s, align 8
  %2 = fmul double %x1, %s2
  %y = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 2
  %y3 = load double, ptr %y, align 8, !tbaa !4
  %s4 = load double, ptr %s, align 8
  %3 = fmul double %y3, %s4
  %z = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 3
  %z5 = load double, ptr %z, align 8, !tbaa !4
  %s6 = load double, ptr %s, align 8
  %4 = fmul double %z5, %s6
  call void @Vector3.Vector3(ptr %Vector3.obj, double %2, double %3, double %4)
  ret ptr %Vector3.obj
}

define internal double @Vector3.dot(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %Vector3.copy = alloca %class.Vector3, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector3.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  store ptr %Vector3.copy, ptr %o, align 8
  %x = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 1
  %x1 = load double, ptr %x, align 8, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Vector3.getX(ptr %o2)
  %4 = fmul double %x1, %3
  %y = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 2
  %y3 = load double, ptr %y, align 8, !tbaa !4
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Vector3.getY(ptr %o4)
  %6 = fmul double %y3, %5
  %7 = fadd double %4, %6
  %z = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 3
  %z5 = load double, ptr %z, align 8, !tbaa !4
  %o6 = load ptr, ptr %o, align 8
  %8 = call double @Vector3.getZ(ptr %o6)
  %9 = fmul double %z5, %8
  %10 = fadd double %7, %9
  ret double %10
}

define internal ptr @Vector3.cross(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %Vector3.copy = alloca %class.Vector3, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Vector3.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  store ptr %Vector3.copy, ptr %o, align 8
  %Vector3.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  %y = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 2
  %y1 = load double, ptr %y, align 8, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Vector3.getZ(ptr %o2)
  %4 = fmul double %y1, %3
  %z = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 3
  %z3 = load double, ptr %z, align 8, !tbaa !4
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Vector3.getY(ptr %o4)
  %6 = fmul double %z3, %5
  %7 = fsub double %4, %6
  %z5 = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 3
  %z6 = load double, ptr %z5, align 8, !tbaa !4
  %o7 = load ptr, ptr %o, align 8
  %8 = call double @Vector3.getX(ptr %o7)
  %9 = fmul double %z6, %8
  %x = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 1
  %x8 = load double, ptr %x, align 8, !tbaa !4
  %o9 = load ptr, ptr %o, align 8
  %10 = call double @Vector3.getZ(ptr %o9)
  %11 = fmul double %x8, %10
  %12 = fsub double %9, %11
  %x10 = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 1
  %x11 = load double, ptr %x10, align 8, !tbaa !4
  %o12 = load ptr, ptr %o, align 8
  %13 = call double @Vector3.getY(ptr %o12)
  %14 = fmul double %x11, %13
  %y13 = getelementptr inbounds %class.Vector3, ptr %0, i32 0, i32 2
  %y14 = load double, ptr %y13, align 8, !tbaa !4
  %o15 = load ptr, ptr %o, align 8
  %15 = call double @Vector3.getX(ptr %o15)
  %16 = fmul double %y14, %15
  %17 = fsub double %14, %16
  call void @Vector3.Vector3(ptr %Vector3.obj, double %7, double %12, double %17)
  ret ptr %Vector3.obj
}

define internal double @Vector3.length(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %1 = call double @Vector3.dot(ptr %0, ptr %0)
  %2 = call double @Numerics.sqrt(double %1)
  ret double %2
}

define internal ptr @Vector3.normalize(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %m = alloca double, align 8
  %1 = call double @Vector3.length(ptr %0)
  store double %1, ptr %m, align 8
  %m1 = load double, ptr %m, align 8
  %2 = fcmp oeq double %m1, 0.000000e+00
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %Vector3.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Vector3, ptr null, i64 1) to i64))
  call void @Vector3.Vector3(ptr %Vector3.obj, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00)
  ret ptr %Vector3.obj

if.end:                                           ; preds = %entry
  %m2 = load double, ptr %m, align 8
  %4 = fdiv double 1.000000e+00, %m2
  %5 = call ptr @Vector3.scale(ptr %0, double %4)
  ret ptr %5
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
