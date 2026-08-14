; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/numeric_widen.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/numeric_widen.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [16 x i8] c"b=%d s=%d i=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"total=%d eq=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %total = alloca i32, align 4
  %l = alloca i64, align 8
  %i = alloca i32, align 4
  %s = alloca i16, align 2
  %b = alloca i8, align 1
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
  store i8 5, ptr %b, align 1
  store i16 300, ptr %s, align 2
  %b1 = load i8, ptr %b, align 1
  %16 = sext i8 %b1 to i32
  store i32 %16, ptr %i, align 4
  %i2 = load i32, ptr %i, align 4
  %17 = sext i32 %i2 to i64
  store i64 %17, ptr %l, align 8
  %i3 = load i32, ptr %i, align 4
  %s4 = load i16, ptr %s, align 2
  %18 = sext i16 %s4 to i32
  %19 = add i32 %i3, %18
  store i32 %19, ptr %total, align 4
  store i8 9, ptr %b, align 1
  %b5 = load i8, ptr %b, align 1
  %20 = sext i8 %b5 to i32
  %s6 = load i16, ptr %s, align 2
  %21 = sext i16 %s6 to i32
  %i7 = load i32, ptr %i, align 4
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %20, i32 %21, i32 %i7)
  %total8 = load i32, ptr %total, align 4
  %l9 = load i64, ptr %l, align 8
  %23 = icmp eq i64 %l9, 5
  %24 = zext i1 %23 to i32
  %25 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %total8, i32 %24)
  ret i32 0
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
