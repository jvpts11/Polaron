; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/generic_method_constraints.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/generic_method_constraints.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Square = type { ptr, i32 }
%class.Circle = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Square.vtable = private constant [350 x ptr] [ptr @Square.area, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Circle.vtable = private constant [350 x ptr] [ptr @Circle.area, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [4 x i8] c"sq=\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [5 x i8] c" ci=\00"
@.strobj.2 = private global %String { i64 4, ptr @.strdata.1, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }

define internal void @Square.Square(ptr %0, i32 %1) {
entry:
  %side = alloca i32, align 4
  store i32 %1, ptr %side, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 0
  store ptr @Square.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %side1 = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 1
  %side2 = load i32, ptr %side, align 4
  store i32 %side2, ptr %side1, align 4, !tbaa !4
  ret void
}

define internal i32 @Square.area(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %side = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 1
  %side1 = load i32, ptr %side, align 4, !tbaa !4
  %side2 = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 1
  %side3 = load i32, ptr %side2, align 4, !tbaa !4
  %1 = mul i32 %side1, %side3
  ret i32 %1
}

define internal void @Circle.Circle(ptr %0, i32 %1) {
entry:
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 0
  store ptr @Circle.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %r1 = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 1
  %r2 = load i32, ptr %r, align 4
  store i32 %r2, ptr %r1, align 4, !tbaa !4
  ret void
}

define internal i32 @Circle.area(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %r = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 1
  %r1 = load i32, ptr %r, align 4, !tbaa !4
  %1 = mul i32 3, %r1
  %r2 = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 1
  %r3 = load i32, ptr %r2, align 4, !tbaa !4
  %2 = mul i32 %1, %r3
  ret i32 %2
}

define internal i32 @"Geometry.totalArea$Circle"(ptr %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %2 = call i32 @Circle.area(ptr %a1)
  %b2 = load ptr, ptr %b, align 8
  %3 = call i32 @Circle.area(ptr %b2)
  %4 = add i32 %2, %3
  ret i32 %4
}

define internal i32 @"Geometry.totalArea$Square"(ptr %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %2 = call i32 @Square.area(ptr %a1)
  %b2 = load ptr, ptr %b, align 8
  %3 = call i32 @Square.area(ptr %b2)
  %4 = add i32 %2, %3
  ret i32 %4
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %ci = alloca i32, align 4
  %sq = alloca i32, align 4
  %c2 = alloca ptr, align 8
  %c1 = alloca ptr, align 8
  %s2 = alloca ptr, align 8
  %s1 = alloca ptr, align 8
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
  %Square.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Square, ptr null, i64 1) to i64))
  call void @Square.Square(ptr %Square.obj, i32 3)
  store ptr %Square.obj, ptr %s1, align 8
  %Square.obj1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Square, ptr null, i64 1) to i64))
  call void @Square.Square(ptr %Square.obj1, i32 4)
  store ptr %Square.obj1, ptr %s2, align 8
  %Circle.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Circle, ptr null, i64 1) to i64))
  call void @Circle.Circle(ptr %Circle.obj, i32 2)
  store ptr %Circle.obj, ptr %c1, align 8
  %Circle.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Circle, ptr null, i64 1) to i64))
  call void @Circle.Circle(ptr %Circle.obj2, i32 1)
  store ptr %Circle.obj2, ptr %c2, align 8
  %s13 = load ptr, ptr %s1, align 8
  %s24 = load ptr, ptr %s2, align 8
  %16 = call i32 @"Geometry.totalArea$Square"(ptr %s13, ptr %s24)
  store i32 %16, ptr %sq, align 4
  %c15 = load ptr, ptr %c1, align 8
  %c26 = load ptr, ptr %c2, align 8
  %17 = call i32 @"Geometry.totalArea$Circle"(ptr %c15, ptr %c26)
  store i32 %17, ptr %ci, align 4
  %sq7 = load i32, ptr %sq, align 4
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %18 = sext i32 %sq7 to i64
  %19 = call i64 @__polaron_itoa(i64 %18, ptr %itoa.buf)
  %newstr8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %20 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 0
  store i64 %19, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  store ptr %itoa.buf, ptr %21, align 8
  %22 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 2
  store i64 0, ptr %22, align 8
  %len = load i64, ptr @.strobj, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 0
  %len9 = load i64, ptr %str.len, align 8
  %23 = add i64 %len, %len9
  %24 = add i64 %23, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %24)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %25 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  %data10 = load ptr, ptr %str.data, align 8
  %26 = getelementptr i8, ptr %cat.buf, i64 %len
  %27 = call ptr @memcpy(ptr %26, ptr %data10, i64 %len9)
  %28 = getelementptr i8, ptr %cat.buf, i64 %23
  store i8 0, ptr %28, align 1
  %newstr11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %29 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 0
  store i64 %23, ptr %29, align 8
  %30 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 1
  store ptr %cat.buf, ptr %30, align 8
  %31 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 2
  store i64 0, ptr %31, align 8
  %str.len12 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 0
  %len13 = load i64, ptr %str.len12, align 8
  %len14 = load i64, ptr @.strobj.2, align 8
  %32 = add i64 %len13, %len14
  %33 = add i64 %32, 1
  %cat.buf15 = call ptr @__polaron_malloc(i64 %33)
  %str.data16 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 1
  %data17 = load ptr, ptr %str.data16, align 8
  %34 = call ptr @memcpy(ptr %cat.buf15, ptr %data17, i64 %len13)
  %data18 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %35 = getelementptr i8, ptr %cat.buf15, i64 %len13
  %36 = call ptr @memcpy(ptr %35, ptr %data18, i64 %len14)
  %37 = getelementptr i8, ptr %cat.buf15, i64 %32
  store i8 0, ptr %37, align 1
  %newstr19 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %38 = getelementptr inbounds %String, ptr %newstr19, i32 0, i32 0
  store i64 %32, ptr %38, align 8
  %39 = getelementptr inbounds %String, ptr %newstr19, i32 0, i32 1
  store ptr %cat.buf15, ptr %39, align 8
  %40 = getelementptr inbounds %String, ptr %newstr19, i32 0, i32 2
  store i64 0, ptr %40, align 8
  %ci20 = load i32, ptr %ci, align 4
  %itoa.buf21 = call ptr @__polaron_malloc(i64 24)
  %41 = sext i32 %ci20 to i64
  %42 = call i64 @__polaron_itoa(i64 %41, ptr %itoa.buf21)
  %newstr22 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %43 = getelementptr inbounds %String, ptr %newstr22, i32 0, i32 0
  store i64 %42, ptr %43, align 8
  %44 = getelementptr inbounds %String, ptr %newstr22, i32 0, i32 1
  store ptr %itoa.buf21, ptr %44, align 8
  %45 = getelementptr inbounds %String, ptr %newstr22, i32 0, i32 2
  store i64 0, ptr %45, align 8
  %str.len23 = getelementptr inbounds %String, ptr %newstr19, i32 0, i32 0
  %len24 = load i64, ptr %str.len23, align 8
  %str.len25 = getelementptr inbounds %String, ptr %newstr22, i32 0, i32 0
  %len26 = load i64, ptr %str.len25, align 8
  %46 = add i64 %len24, %len26
  %47 = add i64 %46, 1
  %cat.buf27 = call ptr @__polaron_malloc(i64 %47)
  %str.data28 = getelementptr inbounds %String, ptr %newstr19, i32 0, i32 1
  %data29 = load ptr, ptr %str.data28, align 8
  %48 = call ptr @memcpy(ptr %cat.buf27, ptr %data29, i64 %len24)
  %str.data30 = getelementptr inbounds %String, ptr %newstr22, i32 0, i32 1
  %data31 = load ptr, ptr %str.data30, align 8
  %49 = getelementptr i8, ptr %cat.buf27, i64 %len24
  %50 = call ptr @memcpy(ptr %49, ptr %data31, i64 %len26)
  %51 = getelementptr i8, ptr %cat.buf27, i64 %46
  store i8 0, ptr %51, align 1
  %newstr32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %52 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 0
  store i64 %46, ptr %52, align 8
  %53 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  store ptr %cat.buf27, ptr %53, align 8
  %54 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 2
  store i64 0, ptr %54, align 8
  %str.data33 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  %data34 = load ptr, ptr %str.data33, align 8
  %55 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data34)
  call void @__polaron_str_free(ptr %newstr8)
  call void @__polaron_str_free(ptr %newstr11)
  call void @__polaron_str_free(ptr %newstr19)
  call void @__polaron_str_free(ptr %newstr22)
  call void @__polaron_str_free(ptr %newstr32)
  %s135 = load ptr, ptr %s1, align 8
  call void @__polaron_check_live(ptr %s135)
  %vtbl.addr = getelementptr inbounds %class.Square, ptr %s135, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %56 = icmp ne ptr %dtor.fn, null
  br i1 %56, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %argv.end
  call void %dtor.fn(ptr %s135)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %argv.end
  call void @__polaron_free(ptr %s135)
  %s236 = load ptr, ptr %s2, align 8
  call void @__polaron_check_live(ptr %s236)
  %vtbl.addr37 = getelementptr inbounds %class.Square, ptr %s236, i32 0, i32 0
  %vtbl38 = load ptr, ptr %vtbl.addr37, align 8, !tbaa !0
  %dtor.slot39 = getelementptr [350 x ptr], ptr %vtbl38, i64 0, i64 349
  %dtor.fn40 = load ptr, ptr %dtor.slot39, align 8
  %57 = icmp ne ptr %dtor.fn40, null
  br i1 %57, label %dtor.call41, label %dtor.free42

dtor.call41:                                      ; preds = %dtor.free
  call void %dtor.fn40(ptr %s236)
  br label %dtor.free42

dtor.free42:                                      ; preds = %dtor.call41, %dtor.free
  call void @__polaron_free(ptr %s236)
  %c143 = load ptr, ptr %c1, align 8
  call void @__polaron_check_live(ptr %c143)
  %vtbl.addr44 = getelementptr inbounds %class.Circle, ptr %c143, i32 0, i32 0
  %vtbl45 = load ptr, ptr %vtbl.addr44, align 8, !tbaa !0
  %dtor.slot46 = getelementptr [350 x ptr], ptr %vtbl45, i64 0, i64 349
  %dtor.fn47 = load ptr, ptr %dtor.slot46, align 8
  %58 = icmp ne ptr %dtor.fn47, null
  br i1 %58, label %dtor.call48, label %dtor.free49

dtor.call48:                                      ; preds = %dtor.free42
  call void %dtor.fn47(ptr %c143)
  br label %dtor.free49

dtor.free49:                                      ; preds = %dtor.call48, %dtor.free42
  call void @__polaron_free(ptr %c143)
  %c250 = load ptr, ptr %c2, align 8
  call void @__polaron_check_live(ptr %c250)
  %vtbl.addr51 = getelementptr inbounds %class.Circle, ptr %c250, i32 0, i32 0
  %vtbl52 = load ptr, ptr %vtbl.addr51, align 8, !tbaa !0
  %dtor.slot53 = getelementptr [350 x ptr], ptr %vtbl52, i64 0, i64 349
  %dtor.fn54 = load ptr, ptr %dtor.slot53, align 8
  %59 = icmp ne ptr %dtor.fn54, null
  br i1 %59, label %dtor.call55, label %dtor.free56

dtor.call55:                                      ; preds = %dtor.free49
  call void %dtor.fn54(ptr %c250)
  br label %dtor.free56

dtor.free56:                                      ; preds = %dtor.call55, %dtor.free49
  call void @__polaron_free(ptr %c250)
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

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i64 @__polaron_itoa(i64, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
