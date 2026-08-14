; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_class_interchange.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_class_interchange.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.app__Matrix = type { ptr, i32, ptr }
%String = type { i64, ptr, i64 }
%class.Object = type { ptr }

@app__Matrix.vtable = private constant [351 x ptr] [ptr @app__Matrix.setAt, ptr @"app__Matrix.operator*", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"app__Matrix.~app__Matrix"]
@Object.vtable = private constant [351 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [156 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_class_interchange.pol:19:98  in app__Matrix.setAt\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [160 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_class_interchange.pol:26:33  in app__Matrix.operator*\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [160 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_class_interchange.pol:26:33  in app__Matrix.operator*\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [160 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_class_interchange.pol:28:48  in app__Matrix.operator*\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [143 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_class_interchange.pol:48:65  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"total=%d\0A\00", align 1

define internal void @app__Matrix.app__Matrix(ptr %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 0
  store ptr @app__Matrix.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 2
  store ptr null, ptr %data, align 8, !tbaa !0
  %n1 = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n2 = load i32, ptr %n, align 4
  store i32 %n2, ptr %n1, align 4, !tbaa !4
  %data3 = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 2
  %n4 = load i32, ptr %n, align 4
  %n5 = load i32, ptr %n, align 4
  %2 = mul i32 %n4, %n5
  %3 = sext i32 %2 to i64
  %4 = mul i64 %3, 8
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %data3, align 8, !tbaa !0
  ret void
}

define internal void @app__Matrix.setAt(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2, double %3) {
entry:
  %v = alloca double, align 8
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store i32 %2, ptr %j, align 4
  store double %3, ptr %v, align 8
  %data = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 2
  %data1 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %n = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n3 = load i32, ptr %n, align 4, !tbaa !4
  %4 = mul i32 %i2, %n3
  %j4 = load i32, ptr %j, align 4
  %5 = add i32 %4, %j4
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %data1, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %6, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %6
  %v5 = load double, ptr %v, align 8
  store double %v5, ptr %arr.elem, align 8
  ret void
}

define internal ptr @"app__Matrix.operator*"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %k = alloca i32, align 4
  %sum = alloca double, align 8
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %r = alloca ptr, align 8
  %app__Matrix.copy = alloca %class.app__Matrix, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %app__Matrix.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.app__Matrix, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.app__Matrix, ptr %1, i32 0, i32 2
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.app__Matrix, ptr %app__Matrix.copy, i32 0, i32 2
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %app__Matrix.copy, ptr %o, align 8
  %app__Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.app__Matrix, ptr null, i64 1) to i64))
  %n = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n1 = load i32, ptr %n, align 4, !tbaa !4
  call void @app__Matrix.app__Matrix(ptr %app__Matrix.obj, i32 %n1)
  store ptr %app__Matrix.obj, ptr %r, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %n3 = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n4 = load i32, ptr %n3, align 4, !tbaa !4
  %9 = icmp slt i32 %i2, %n4
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond5

for.update:                                       ; preds = %for.end8
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r54 = load ptr, ptr %r, align 8
  ret ptr %r54

for.cond5:                                        ; preds = %for.update7, %for.body
  %j9 = load i32, ptr %j, align 4
  %n10 = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n11 = load i32, ptr %n10, align 4, !tbaa !4
  %13 = icmp slt i32 %j9, %n11
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body6, label %for.end8

for.body6:                                        ; preds = %for.cond5
  store double 0.000000e+00, ptr %sum, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond12

for.update7:                                      ; preds = %idx.ok50
  %15 = load i32, ptr %j, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %j, align 4
  br label %for.cond5

for.end8:                                         ; preds = %for.cond5
  br label %for.update

for.cond12:                                       ; preds = %for.update14, %for.body6
  %k16 = load i32, ptr %k, align 4
  %n17 = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n18 = load i32, ptr %n17, align 4, !tbaa !4
  %17 = icmp slt i32 %k16, %n18
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body13, label %for.end15

for.body13:                                       ; preds = %for.cond12
  %sum19 = load double, ptr %sum, align 8
  %data = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 2
  %data20 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i21 = load i32, ptr %i, align 4
  %n22 = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n23 = load i32, ptr %n22, align 4, !tbaa !4
  %19 = mul i32 %i21, %n23
  %k24 = load i32, ptr %k, align 4
  %20 = add i32 %19, %k24
  %21 = sext i32 %20 to i64
  %arr.len25 = load i64, ptr %data20, align 8
  %arr.oob = icmp uge i64 %21, %arr.len25
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update14:                                     ; preds = %idx.ok36
  %22 = load i32, ptr %k, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %k, align 4
  br label %for.cond12

for.end15:                                        ; preds = %for.cond12
  %r40 = load ptr, ptr %r, align 8
  %data41 = getelementptr inbounds %class.app__Matrix, ptr %r40, i32 0, i32 2
  %data42 = load ptr, ptr %data41, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i43 = load i32, ptr %i, align 4
  %n44 = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n45 = load i32, ptr %n44, align 4, !tbaa !4
  %24 = mul i32 %i43, %n45
  %j46 = load i32, ptr %j, align 4
  %25 = add i32 %24, %j46
  %26 = sext i32 %25 to i64
  %arr.len47 = load i64, ptr %data42, align 8
  %arr.oob48 = icmp uge i64 %26, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !8

idx.bad:                                          ; preds = %for.body13
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %21, ptr @.failb.3, i64 %arr.len25, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body13
  %arr.data = getelementptr i8, ptr %data20, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %21
  %elem = load double, ptr %arr.elem, align 8
  %o26 = load ptr, ptr %o, align 8
  %data27 = getelementptr inbounds %class.app__Matrix, ptr %o26, i32 0, i32 2
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %k29 = load i32, ptr %k, align 4
  %n30 = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 1
  %n31 = load i32, ptr %n30, align 4, !tbaa !4
  %27 = mul i32 %k29, %n31
  %j32 = load i32, ptr %j, align 4
  %28 = add i32 %27, %j32
  %29 = sext i32 %28 to i64
  %arr.len33 = load i64, ptr %data28, align 8
  %arr.oob34 = icmp uge i64 %29, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

idx.bad35:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 %29, ptr @.failb.6, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok
  %arr.data37 = getelementptr i8, ptr %data28, i64 8
  %arr.elem38 = getelementptr inbounds double, ptr %arr.data37, i64 %29
  %elem39 = load double, ptr %arr.elem38, align 8
  %30 = fmul double %elem, %elem39
  %31 = fadd double %sum19, %30
  store double %31, ptr %sum, align 8
  br label %for.update14

idx.bad49:                                        ; preds = %for.end15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 %26, ptr @.failb.9, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %for.end15
  %arr.data51 = getelementptr i8, ptr %data42, i64 8
  %arr.elem52 = getelementptr inbounds double, ptr %arr.data51, i64 %26
  %sum53 = load double, ptr %sum, align 8
  store double %sum53, ptr %arr.elem52, align 8
  br label %for.update7
}

define internal void @"app__Matrix.~app__Matrix"(ptr %0) {
entry:
  %data = getelementptr inbounds %class.app__Matrix, ptr %0, i32 0, i32 2
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  call void @__polaron_free(ptr %data1)
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %i22 = alloca i32, align 4
  %total = alloca i32, align 4
  %c = alloca ptr, align 8
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %n = alloca i32, align 4
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
  store i32 10, ptr %n, align 4
  %app__Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.app__Matrix, ptr null, i64 1) to i64))
  %n1 = load i32, ptr %n, align 4
  call void @app__Matrix.app__Matrix(ptr %app__Matrix.obj, i32 %n1)
  store ptr %app__Matrix.obj, ptr %a, align 8
  %app__Matrix.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.app__Matrix, ptr null, i64 1) to i64))
  %n3 = load i32, ptr %n, align 4
  call void @app__Matrix.app__Matrix(ptr %app__Matrix.obj2, i32 %n3)
  store ptr %app__Matrix.obj2, ptr %b, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %16 = icmp slt i32 %i4, %n5
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %18 = load i32, ptr %i, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %a20 = load ptr, ptr %a, align 8
  %b21 = load ptr, ptr %b, align 8
  %20 = call ptr @"app__Matrix.operator*"(ptr %a20, ptr %b21)
  store ptr %20, ptr %c, align 8
  store i32 0, ptr %total, align 4
  store i32 0, ptr %i22, align 4
  br label %for.cond23

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %n11 = load i32, ptr %n, align 4
  %21 = icmp slt i32 %j10, %n11
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %a12 = load ptr, ptr %a, align 8
  %i13 = load i32, ptr %i, align 4
  %j14 = load i32, ptr %j, align 4
  %i15 = load i32, ptr %i, align 4
  %23 = mul i32 %i15, 10
  %j16 = load i32, ptr %j, align 4
  %24 = add i32 %23, %j16
  %25 = sitofp i32 %24 to double
  call void @app__Matrix.setAt(ptr %a12, i32 %i13, i32 %j14, double %25)
  %b17 = load ptr, ptr %b, align 8
  %i18 = load i32, ptr %i, align 4
  %j19 = load i32, ptr %j, align 4
  call void @app__Matrix.setAt(ptr %b17, i32 %i18, i32 %j19, double 1.000000e+00)
  br label %for.update8

for.update8:                                      ; preds = %for.body7
  %26 = load i32, ptr %j, align 4
  %27 = add i32 %26, 1
  store i32 %27, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update

for.cond23:                                       ; preds = %for.update25, %for.end
  %i27 = load i32, ptr %i22, align 4
  %n28 = load i32, ptr %n, align 4
  %n29 = load i32, ptr %n, align 4
  %28 = mul i32 %n28, %n29
  %29 = icmp slt i32 %i27, %28
  %30 = zext i1 %29 to i32
  br i1 %29, label %for.body24, label %for.end26

for.body24:                                       ; preds = %for.cond23
  %total30 = load i32, ptr %total, align 4
  %c31 = load ptr, ptr %c, align 8
  %data = getelementptr inbounds %class.app__Matrix, ptr %c31, i32 0, i32 2
  %data32 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i33 = load i32, ptr %i22, align 4
  %31 = sext i32 %i33 to i64
  %arr.len = load i64, ptr %data32, align 8
  %arr.oob = icmp uge i64 %31, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update25:                                     ; preds = %idx.ok
  %32 = load i32, ptr %i22, align 4
  %33 = add i32 %32, 1
  store i32 %33, ptr %i22, align 4
  br label %for.cond23

for.end26:                                        ; preds = %for.cond23
  %total35 = load i32, ptr %total, align 4
  %34 = call i32 (ptr, ...) @printf(ptr @.str, i32 %total35)
  %a36 = load ptr, ptr %a, align 8
  call void @__polaron_check_live(ptr %a36)
  %vtbl.addr = getelementptr inbounds %class.app__Matrix, ptr %a36, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [351 x ptr], ptr %vtbl, i64 0, i64 350
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %35 = icmp ne ptr %dtor.fn, null
  br i1 %35, label %dtor.call, label %dtor.free

idx.bad:                                          ; preds = %for.body24
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 %31, ptr @.failb.12, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body24
  %arr.data34 = getelementptr i8, ptr %data32, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data34, i64 %31
  %elem = load double, ptr %arr.elem, align 8
  %36 = call i32 @llvm.fptosi.sat.i32.f64(double %elem)
  %37 = add i32 %total30, %36
  store i32 %37, ptr %total, align 4
  br label %for.update25

dtor.call:                                        ; preds = %for.end26
  call void %dtor.fn(ptr %a36)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %for.end26
  call void @__polaron_free(ptr %a36)
  %b37 = load ptr, ptr %b, align 8
  call void @__polaron_check_live(ptr %b37)
  %vtbl.addr38 = getelementptr inbounds %class.app__Matrix, ptr %b37, i32 0, i32 0
  %vtbl39 = load ptr, ptr %vtbl.addr38, align 8, !tbaa !0
  %dtor.slot40 = getelementptr [351 x ptr], ptr %vtbl39, i64 0, i64 350
  %dtor.fn41 = load ptr, ptr %dtor.slot40, align 8
  %38 = icmp ne ptr %dtor.fn41, null
  br i1 %38, label %dtor.call42, label %dtor.free43

dtor.call42:                                      ; preds = %dtor.free
  call void %dtor.fn41(ptr %b37)
  br label %dtor.free43

dtor.free43:                                      ; preds = %dtor.call42, %dtor.free
  call void @__polaron_free(ptr %b37)
  %c44 = load ptr, ptr %c, align 8
  call void @__polaron_check_live(ptr %c44)
  %vtbl.addr45 = getelementptr inbounds %class.app__Matrix, ptr %c44, i32 0, i32 0
  %vtbl46 = load ptr, ptr %vtbl.addr45, align 8, !tbaa !0
  %dtor.slot47 = getelementptr [351 x ptr], ptr %vtbl46, i64 0, i64 350
  %dtor.fn48 = load ptr, ptr %dtor.slot47, align 8
  %39 = icmp ne ptr %dtor.fn48, null
  br i1 %39, label %dtor.call49, label %dtor.free50

dtor.call49:                                      ; preds = %dtor.free43
  call void %dtor.fn48(ptr %c44)
  br label %dtor.free50

dtor.free50:                                      ; preds = %dtor.call49, %dtor.free43
  call void @__polaron_free(ptr %c44)
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

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_free(ptr)

declare i64 @strlen(ptr)

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #1

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
