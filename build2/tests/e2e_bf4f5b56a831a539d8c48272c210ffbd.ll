; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_struct_hash.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_struct_hash.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Wide = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%class.Link = type { ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Link.vtable = private constant [349 x ptr] [ptr @Link.next, ptr @Link.value, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [26 x i8] c"same=%d diff=%d chain=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Wide.Wide(ptr %0, i32 %1) {
entry:
  %seed = alloca i32, align 4
  store i32 %1, ptr %seed, align 4
  %f00 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 0
  %seed1 = load i32, ptr %seed, align 4
  store i32 %seed1, ptr %f00, align 4, !tbaa !0
  %f01 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 1
  %seed2 = load i32, ptr %seed, align 4
  %2 = add i32 %seed2, 1
  store i32 %2, ptr %f01, align 4, !tbaa !0
  %f02 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 2
  %seed3 = load i32, ptr %seed, align 4
  %3 = add i32 %seed3, 2
  store i32 %3, ptr %f02, align 4, !tbaa !0
  %f03 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 3
  %seed4 = load i32, ptr %seed, align 4
  %4 = add i32 %seed4, 3
  store i32 %4, ptr %f03, align 4, !tbaa !0
  %f04 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 4
  %seed5 = load i32, ptr %seed, align 4
  %5 = add i32 %seed5, 4
  store i32 %5, ptr %f04, align 4, !tbaa !0
  %f05 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 5
  %seed6 = load i32, ptr %seed, align 4
  %6 = add i32 %seed6, 5
  store i32 %6, ptr %f05, align 4, !tbaa !0
  %f06 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 6
  %seed7 = load i32, ptr %seed, align 4
  %7 = add i32 %seed7, 6
  store i32 %7, ptr %f06, align 4, !tbaa !0
  %f07 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 7
  %seed8 = load i32, ptr %seed, align 4
  %8 = add i32 %seed8, 7
  store i32 %8, ptr %f07, align 4, !tbaa !0
  %f08 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 8
  %seed9 = load i32, ptr %seed, align 4
  %9 = add i32 %seed9, 8
  store i32 %9, ptr %f08, align 4, !tbaa !0
  %f09 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 9
  %seed10 = load i32, ptr %seed, align 4
  %10 = add i32 %seed10, 9
  store i32 %10, ptr %f09, align 4, !tbaa !0
  %f10 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 10
  %seed11 = load i32, ptr %seed, align 4
  %11 = add i32 %seed11, 10
  store i32 %11, ptr %f10, align 4, !tbaa !0
  %f11 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 11
  %seed12 = load i32, ptr %seed, align 4
  %12 = add i32 %seed12, 11
  store i32 %12, ptr %f11, align 4, !tbaa !0
  %f12 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 12
  %seed13 = load i32, ptr %seed, align 4
  %13 = add i32 %seed13, 12
  store i32 %13, ptr %f12, align 4, !tbaa !0
  %f13 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 13
  %seed14 = load i32, ptr %seed, align 4
  %14 = add i32 %seed14, 13
  store i32 %14, ptr %f13, align 4, !tbaa !0
  %f14 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 14
  %seed15 = load i32, ptr %seed, align 4
  %15 = add i32 %seed15, 14
  store i32 %15, ptr %f14, align 4, !tbaa !0
  %f15 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 15
  %seed16 = load i32, ptr %seed, align 4
  %16 = add i32 %seed16, 15
  store i32 %16, ptr %f15, align 4, !tbaa !0
  %f16 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 16
  %seed17 = load i32, ptr %seed, align 4
  %17 = add i32 %seed17, 16
  store i32 %17, ptr %f16, align 4, !tbaa !0
  %f17 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 17
  %seed18 = load i32, ptr %seed, align 4
  %18 = add i32 %seed18, 17
  store i32 %18, ptr %f17, align 4, !tbaa !0
  %f18 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 18
  %seed19 = load i32, ptr %seed, align 4
  %19 = add i32 %seed19, 18
  store i32 %19, ptr %f18, align 4, !tbaa !0
  %f19 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 19
  %seed20 = load i32, ptr %seed, align 4
  %20 = add i32 %seed20, 19
  store i32 %20, ptr %f19, align 4, !tbaa !0
  ret void
}

define internal i64 @Wide.hash(ptr nonnull align 4 dereferenceable(80) %0) {
entry:
  %f00 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 0
  %f001 = load i32, ptr %f00, align 4, !tbaa !0
  %1 = sext i32 %f001 to i64
  %2 = add i64 527, %1
  %3 = mul i64 %2, 31
  %f01 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 1
  %f012 = load i32, ptr %f01, align 4, !tbaa !0
  %4 = sext i32 %f012 to i64
  %5 = add i64 %3, %4
  %6 = mul i64 %5, 31
  %f02 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 2
  %f023 = load i32, ptr %f02, align 4, !tbaa !0
  %7 = sext i32 %f023 to i64
  %8 = add i64 %6, %7
  %9 = mul i64 %8, 31
  %f03 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 3
  %f034 = load i32, ptr %f03, align 4, !tbaa !0
  %10 = sext i32 %f034 to i64
  %11 = add i64 %9, %10
  %12 = mul i64 %11, 31
  %f04 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 4
  %f045 = load i32, ptr %f04, align 4, !tbaa !0
  %13 = sext i32 %f045 to i64
  %14 = add i64 %12, %13
  %15 = mul i64 %14, 31
  %f05 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 5
  %f056 = load i32, ptr %f05, align 4, !tbaa !0
  %16 = sext i32 %f056 to i64
  %17 = add i64 %15, %16
  %18 = mul i64 %17, 31
  %f06 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 6
  %f067 = load i32, ptr %f06, align 4, !tbaa !0
  %19 = sext i32 %f067 to i64
  %20 = add i64 %18, %19
  %21 = mul i64 %20, 31
  %f07 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 7
  %f078 = load i32, ptr %f07, align 4, !tbaa !0
  %22 = sext i32 %f078 to i64
  %23 = add i64 %21, %22
  %24 = mul i64 %23, 31
  %f08 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 8
  %f089 = load i32, ptr %f08, align 4, !tbaa !0
  %25 = sext i32 %f089 to i64
  %26 = add i64 %24, %25
  %27 = mul i64 %26, 31
  %f09 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 9
  %f0910 = load i32, ptr %f09, align 4, !tbaa !0
  %28 = sext i32 %f0910 to i64
  %29 = add i64 %27, %28
  %30 = mul i64 %29, 31
  %f10 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 10
  %f1011 = load i32, ptr %f10, align 4, !tbaa !0
  %31 = sext i32 %f1011 to i64
  %32 = add i64 %30, %31
  %33 = mul i64 %32, 31
  %f11 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 11
  %f1112 = load i32, ptr %f11, align 4, !tbaa !0
  %34 = sext i32 %f1112 to i64
  %35 = add i64 %33, %34
  %36 = mul i64 %35, 31
  %f12 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 12
  %f1213 = load i32, ptr %f12, align 4, !tbaa !0
  %37 = sext i32 %f1213 to i64
  %38 = add i64 %36, %37
  %39 = mul i64 %38, 31
  %f13 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 13
  %f1314 = load i32, ptr %f13, align 4, !tbaa !0
  %40 = sext i32 %f1314 to i64
  %41 = add i64 %39, %40
  %42 = mul i64 %41, 31
  %f14 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 14
  %f1415 = load i32, ptr %f14, align 4, !tbaa !0
  %43 = sext i32 %f1415 to i64
  %44 = add i64 %42, %43
  %45 = mul i64 %44, 31
  %f15 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 15
  %f1516 = load i32, ptr %f15, align 4, !tbaa !0
  %46 = sext i32 %f1516 to i64
  %47 = add i64 %45, %46
  %48 = mul i64 %47, 31
  %f16 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 16
  %f1617 = load i32, ptr %f16, align 4, !tbaa !0
  %49 = sext i32 %f1617 to i64
  %50 = add i64 %48, %49
  %51 = mul i64 %50, 31
  %f17 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 17
  %f1718 = load i32, ptr %f17, align 4, !tbaa !0
  %52 = sext i32 %f1718 to i64
  %53 = add i64 %51, %52
  %54 = mul i64 %53, 31
  %f18 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 18
  %f1819 = load i32, ptr %f18, align 4, !tbaa !0
  %55 = sext i32 %f1819 to i64
  %56 = add i64 %54, %55
  %57 = mul i64 %56, 31
  %f19 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 19
  %f1920 = load i32, ptr %f19, align 4, !tbaa !0
  %58 = sext i32 %f1920 to i64
  %59 = add i64 %57, %58
  ret i64 %59
}

define internal ptr @Link.next(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret ptr %0
}

define internal i32 @Link.value(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 7
}

define internal void @Link.Link(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Link, ptr %0, i32 0, i32 0
  store ptr @Link.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %chain = alloca i32, align 4
  %l = alloca ptr, align 8
  %Link.obj = alloca %class.Link, align 8
  %c = alloca ptr, align 8
  %Wide.obj2 = alloca %class.Wide, align 8
  %b = alloca ptr, align 8
  %Wide.obj1 = alloca %class.Wide, align 8
  %a = alloca ptr, align 8
  %Wide.obj = alloca %class.Wide, align 8
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
  call void @Wide.Wide(ptr %Wide.obj, i32 1)
  store ptr %Wide.obj, ptr %a, align 8
  call void @Wide.Wide(ptr %Wide.obj1, i32 1)
  store ptr %Wide.obj1, ptr %b, align 8
  call void @Wide.Wide(ptr %Wide.obj2, i32 2)
  store ptr %Wide.obj2, ptr %c, align 8
  call void @Link.Link(ptr %Link.obj)
  store ptr %Link.obj, ptr %l, align 8
  %l3 = load ptr, ptr %l, align 8
  %16 = call ptr @Link.next(ptr %l3)
  %17 = call ptr @Link.next(ptr %16)
  %18 = call ptr @Link.next(ptr %17)
  %19 = call ptr @Link.next(ptr %18)
  %20 = call ptr @Link.next(ptr %19)
  %21 = call ptr @Link.next(ptr %20)
  %22 = call ptr @Link.next(ptr %21)
  %23 = call ptr @Link.next(ptr %22)
  %24 = call ptr @Link.next(ptr %23)
  %25 = call ptr @Link.next(ptr %24)
  %26 = call ptr @Link.next(ptr %25)
  %27 = call ptr @Link.next(ptr %26)
  %28 = call i32 @Link.value(ptr %27)
  store i32 %28, ptr %chain, align 4
  %a4 = load ptr, ptr %a, align 8
  %29 = call i64 @Wide.hash(ptr %a4)
  %b5 = load ptr, ptr %b, align 8
  %30 = call i64 @Wide.hash(ptr %b5)
  %31 = icmp eq i64 %29, %30
  %32 = zext i1 %31 to i32
  %a6 = load ptr, ptr %a, align 8
  %33 = call i64 @Wide.hash(ptr %a6)
  %c7 = load ptr, ptr %c, align 8
  %34 = call i64 @Wide.hash(ptr %c7)
  %35 = icmp eq i64 %33, %34
  %36 = zext i1 %35 to i32
  %chain8 = load i32, ptr %chain, align 4
  %37 = call i32 (ptr, ...) @printf(ptr @.str, i32 %32, i32 %36, i32 %chain8)
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

declare ptr @memcpy(ptr, ptr, i64)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"ptr", !2, i64 0}
