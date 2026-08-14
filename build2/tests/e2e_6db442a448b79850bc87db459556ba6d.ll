; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/decimal.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/decimal.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [10 x i8] c"total=%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"tax=%s\0A\00", align 1
@.str.2 = private unnamed_addr constant [23 x i8] c"expensive=%d whole=%d\0A\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"half=%s\0A\00", align 1
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %half = alloca i128, align 16
  %tax = alloca i128, align 16
  %total = alloca i128, align 16
  %qty = alloca i128, align 16
  %price = alloca i128, align 16
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
  store i128 19990000000000000000, ptr %price, align 16
  store i128 3000000000000000000, ptr %qty, align 16
  %price1 = load i128, ptr %price, align 16
  %qty2 = load i128, ptr %qty, align 16
  %16 = sext i128 %qty2 to i256
  %17 = sext i128 %price1 to i256
  %18 = mul i256 %17, %16
  %19 = sdiv i256 %18, 1000000000000000000
  %20 = trunc i256 %19 to i128
  store i128 %20, ptr %total, align 16
  %total3 = load i128, ptr %total, align 16
  %21 = icmp slt i128 %total3, 0
  %22 = sub i128 0, %total3
  %23 = select i1 %21, i128 %22, i128 %total3
  %24 = sdiv i128 %23, 1000000000000000000
  %25 = trunc i128 %24 to i64
  %26 = srem i128 %23, 1000000000000000000
  %27 = trunc i128 %26 to i64
  %dbuf = call ptr @__polaron_malloc(i64 64)
  %28 = zext i1 %21 to i32
  %29 = call i64 @__polaron_decimal_str(i32 %28, i64 %25, i64 %27, ptr %dbuf)
  %newstr4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %30 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %29, ptr %30, align 8
  %31 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %dbuf, ptr %31, align 8
  %32 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %32, align 8
  %str.data = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %33 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %newstr4)
  %total5 = load i128, ptr %total, align 16
  %34 = sext i128 %total5 to i256
  %35 = mul i256 %34, 80000000000000000
  %36 = sdiv i256 %35, 1000000000000000000
  %37 = trunc i256 %36 to i128
  store i128 %37, ptr %tax, align 16
  %tax6 = load i128, ptr %tax, align 16
  %38 = icmp slt i128 %tax6, 0
  %39 = sub i128 0, %tax6
  %40 = select i1 %38, i128 %39, i128 %tax6
  %41 = sdiv i128 %40, 1000000000000000000
  %42 = trunc i128 %41 to i64
  %43 = srem i128 %40, 1000000000000000000
  %44 = trunc i128 %43 to i64
  %dbuf7 = call ptr @__polaron_malloc(i64 64)
  %45 = zext i1 %38 to i32
  %46 = call i64 @__polaron_decimal_str(i32 %45, i64 %42, i64 %44, ptr %dbuf7)
  %newstr8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %47 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 0
  store i64 %46, ptr %47, align 8
  %48 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  store ptr %dbuf7, ptr %48, align 8
  %49 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 2
  store i64 0, ptr %49, align 8
  %str.data9 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %50 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data10)
  call void @__polaron_str_free(ptr %newstr8)
  %total11 = load i128, ptr %total, align 16
  %51 = icmp sgt i128 %total11, 50000000000000000000
  %52 = zext i1 %51 to i32
  %total12 = load i128, ptr %total, align 16
  %53 = sdiv i128 %total12, 1000000000000000000
  %54 = trunc i128 %53 to i32
  %55 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %52, i32 %54)
  store i128 2500000000000000000, ptr %half, align 16
  %half13 = load i128, ptr %half, align 16
  %56 = icmp slt i128 %half13, 0
  %57 = sub i128 0, %half13
  %58 = select i1 %56, i128 %57, i128 %half13
  %59 = sdiv i128 %58, 1000000000000000000
  %60 = trunc i128 %59 to i64
  %61 = srem i128 %58, 1000000000000000000
  %62 = trunc i128 %61 to i64
  %dbuf14 = call ptr @__polaron_malloc(i64 64)
  %63 = zext i1 %56 to i32
  %64 = call i64 @__polaron_decimal_str(i32 %63, i64 %60, i64 %62, ptr %dbuf14)
  %newstr15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %65 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 0
  store i64 %64, ptr %65, align 8
  %66 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 1
  store ptr %dbuf14, ptr %66, align 8
  %67 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 2
  store i64 0, ptr %67, align 8
  %str.data16 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 1
  %data17 = load ptr, ptr %str.data16, align 8
  %68 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr %data17)
  call void @__polaron_str_free(ptr %newstr15)
  ret i32 0
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

declare i64 @__polaron_decimal_str(i32, i64, i64, ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
