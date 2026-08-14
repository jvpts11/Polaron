; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/mat4.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/mat4.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Mat4 = type { ptr, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Mat4.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Mat4.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Mat4.set, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Mat4.multiply, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Mat4.transpose, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [58 x i8] c"id00=%.1f id12=%.1f prod03=%.1f prod22=%.1f trans01=%.1f\0A\00", align 1
@.fail.3644 = private unnamed_addr constant [79 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6421:62  in Mat4.get\0A\00", align 1
@.faila.3645 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3646 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3647 = private unnamed_addr constant [79 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6422:88  in Mat4.set\0A\00", align 1
@.faila.3648 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3649 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %at = alloca ptr, align 8
  %prod = alloca ptr, align 8
  %a = alloca ptr, align 8
  %id = alloca ptr, align 8
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
  %16 = call ptr @Mat4.identity()
  store ptr %16, ptr %id, align 8
  %Mat4.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Mat4, ptr null, i64 1) to i64))
  call void @Mat4.Mat4(ptr %Mat4.obj)
  store ptr %Mat4.obj, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  call void @Mat4.set(ptr %a1, i32 0, i32 3, double 5.000000e+00)
  %a2 = load ptr, ptr %a, align 8
  call void @Mat4.set(ptr %a2, i32 1, i32 0, double 7.000000e+00)
  %a3 = load ptr, ptr %a, align 8
  call void @Mat4.set(ptr %a3, i32 2, i32 2, double 3.000000e+00)
  %id4 = load ptr, ptr %id, align 8
  %a5 = load ptr, ptr %a, align 8
  %17 = call ptr @Mat4.multiply(ptr %id4, ptr %a5)
  store ptr %17, ptr %prod, align 8
  %a6 = load ptr, ptr %a, align 8
  %18 = call ptr @Mat4.transpose(ptr %a6)
  store ptr %18, ptr %at, align 8
  %id7 = load ptr, ptr %id, align 8
  %19 = call double @Mat4.get(ptr %id7, i32 0, i32 0)
  %id8 = load ptr, ptr %id, align 8
  %20 = call double @Mat4.get(ptr %id8, i32 1, i32 2)
  %prod9 = load ptr, ptr %prod, align 8
  %21 = call double @Mat4.get(ptr %prod9, i32 0, i32 3)
  %prod10 = load ptr, ptr %prod, align 8
  %22 = call double @Mat4.get(ptr %prod10, i32 2, i32 2)
  %at11 = load ptr, ptr %at, align 8
  %23 = call double @Mat4.get(ptr %at11, i32 0, i32 1)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, double %19, double %20, double %21, double %22, double %23)
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

define internal void @Mat4.Mat4(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Mat4, ptr %0, i32 0, i32 0
  store ptr @Mat4.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %m = getelementptr inbounds %class.Mat4, ptr %0, i32 0, i32 1
  store ptr null, ptr %m, align 8, !tbaa !0
  %m1 = getelementptr inbounds %class.Mat4, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 136)
  store i64 16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 128)
  store ptr %arr, ptr %m1, align 8, !tbaa !0
  ret void
}

define internal ptr @Mat4.identity() {
entry:
  %i = alloca i32, align 4
  %r = alloca ptr, align 8
  %Mat4.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Mat4, ptr null, i64 1) to i64))
  call void @Mat4.Mat4(ptr %Mat4.obj)
  store ptr %Mat4.obj, ptr %r, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %0 = icmp slt i32 %i1, 4
  %1 = zext i1 %0 to i32
  br i1 %0, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r2 = load ptr, ptr %r, align 8
  %i3 = load i32, ptr %i, align 4
  %i4 = load i32, ptr %i, align 4
  call void @Mat4.set(ptr %r2, i32 %i3, i32 %i4, double 1.000000e+00)
  br label %for.update

for.update:                                       ; preds = %for.body
  %2 = load i32, ptr %i, align 4
  %3 = add i32 %2, 1
  store i32 %3, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r5 = load ptr, ptr %r, align 8
  ret ptr %r5
}

define internal double @Mat4.get(ptr nonnull align 8 dereferenceable(16) %0, i32 %1, i32 %2) {
entry:
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  %m = getelementptr inbounds %class.Mat4, ptr %0, i32 0, i32 1
  %m1 = load ptr, ptr %m, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %r2 = load i32, ptr %r, align 4
  %3 = mul i32 %r2, 4
  %c3 = load i32, ptr %c, align 4
  %4 = add i32 %3, %c3
  %5 = sext i32 %4 to i64
  %arr.len = load i64, ptr %m1, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3644, ptr @.faila.3645, i64 %5, ptr @.failb.3646, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %m1, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %5
  %elem = load double, ptr %arr.elem, align 8
  ret double %elem
}

define internal void @Mat4.set(ptr nonnull align 8 dereferenceable(16) %0, i32 %1, i32 %2, double %3) {
entry:
  %v = alloca double, align 8
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  store double %3, ptr %v, align 8
  %m = getelementptr inbounds %class.Mat4, ptr %0, i32 0, i32 1
  %m1 = load ptr, ptr %m, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %r2 = load i32, ptr %r, align 4
  %4 = mul i32 %r2, 4
  %c3 = load i32, ptr %c, align 4
  %5 = add i32 %4, %c3
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %m1, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3647, ptr @.faila.3648, i64 %6, ptr @.failb.3649, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %m1, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %6
  %v4 = load double, ptr %v, align 8
  store double %v4, ptr %arr.elem, align 8
  ret void
}

define internal ptr @Mat4.multiply(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %k = alloca i32, align 4
  %s = alloca double, align 8
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %r = alloca ptr, align 8
  %Mat4.copy = alloca %class.Mat4, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Mat4.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Mat4, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Mat4, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.Mat4, ptr %Mat4.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %Mat4.copy, ptr %o, align 8
  %Mat4.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Mat4, ptr null, i64 1) to i64))
  call void @Mat4.Mat4(ptr %Mat4.obj)
  store ptr %Mat4.obj, ptr %r, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %9 = icmp slt i32 %i1, 4
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond2

for.update:                                       ; preds = %for.end5
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r22 = load ptr, ptr %r, align 8
  ret ptr %r22

for.cond2:                                        ; preds = %for.update4, %for.body
  %j6 = load i32, ptr %j, align 4
  %13 = icmp slt i32 %j6, 4
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body3, label %for.end5

for.body3:                                        ; preds = %for.cond2
  store double 0.000000e+00, ptr %s, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond7

for.update4:                                      ; preds = %for.end10
  %15 = load i32, ptr %j, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %j, align 4
  br label %for.cond2

for.end5:                                         ; preds = %for.cond2
  br label %for.update

for.cond7:                                        ; preds = %for.update9, %for.body3
  %k11 = load i32, ptr %k, align 4
  %17 = icmp slt i32 %k11, 4
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body8, label %for.end10

for.body8:                                        ; preds = %for.cond7
  %s12 = load double, ptr %s, align 8
  %i13 = load i32, ptr %i, align 4
  %k14 = load i32, ptr %k, align 4
  %19 = call double @Mat4.get(ptr %0, i32 %i13, i32 %k14)
  %o15 = load ptr, ptr %o, align 8
  %k16 = load i32, ptr %k, align 4
  %j17 = load i32, ptr %j, align 4
  %20 = call double @Mat4.get(ptr %o15, i32 %k16, i32 %j17)
  %21 = fmul double %19, %20
  %22 = fadd double %s12, %21
  store double %22, ptr %s, align 8
  br label %for.update9

for.update9:                                      ; preds = %for.body8
  %23 = load i32, ptr %k, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %k, align 4
  br label %for.cond7

for.end10:                                        ; preds = %for.cond7
  %r18 = load ptr, ptr %r, align 8
  %i19 = load i32, ptr %i, align 4
  %j20 = load i32, ptr %j, align 4
  %s21 = load double, ptr %s, align 8
  call void @Mat4.set(ptr %r18, i32 %i19, i32 %j20, double %s21)
  br label %for.update4
}

define internal ptr @Mat4.transpose(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %r = alloca ptr, align 8
  %Mat4.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Mat4, ptr null, i64 1) to i64))
  call void @Mat4.Mat4(ptr %Mat4.obj)
  store ptr %Mat4.obj, ptr %r, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %1 = icmp slt i32 %i1, 4
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond2

for.update:                                       ; preds = %for.end5
  %3 = load i32, ptr %i, align 4
  %4 = add i32 %3, 1
  store i32 %4, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r12 = load ptr, ptr %r, align 8
  ret ptr %r12

for.cond2:                                        ; preds = %for.update4, %for.body
  %j6 = load i32, ptr %j, align 4
  %5 = icmp slt i32 %j6, 4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body3, label %for.end5

for.body3:                                        ; preds = %for.cond2
  %r7 = load ptr, ptr %r, align 8
  %j8 = load i32, ptr %j, align 4
  %i9 = load i32, ptr %i, align 4
  %i10 = load i32, ptr %i, align 4
  %j11 = load i32, ptr %j, align 4
  %7 = call double @Mat4.get(ptr %0, i32 %i10, i32 %j11)
  call void @Mat4.set(ptr %r7, i32 %j8, i32 %i9, double %7)
  br label %for.update4

for.update4:                                      ; preds = %for.body3
  %8 = load i32, ptr %j, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %j, align 4
  br label %for.cond2

for.end5:                                         ; preds = %for.cond2
  br label %for.update
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
!4 = !{}
!5 = !{i64 8}
!6 = !{!"branch_weights", i32 1, i32 1048576}
