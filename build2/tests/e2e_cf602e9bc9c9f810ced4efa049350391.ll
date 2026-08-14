; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cast_signedness.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cast_signedness.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [8 x i8] c"u = %u\0A\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"si = %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"wid = %u\0A\00", align 1
@.str.3 = private unnamed_addr constant [12 x i8] c"ext = %lld\0A\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"wide = %lld\0A\00", align 1
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %wide = alloca i64, align 8
  %umax = alloca i32, align 4
  %ext = alloca i64, align 8
  %ub = alloca i8, align 1
  %wid = alloca i32, align 4
  %sb = alloca i8, align 1
  %si = alloca i32, align 4
  %big = alloca i32, align 4
  %u = alloca i32, align 4
  %neg = alloca i32, align 4
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
  store i32 -1, ptr %neg, align 4
  %neg1 = load i32, ptr %neg, align 4
  store i32 %neg1, ptr %u, align 4
  %u2 = load i32, ptr %u, align 4
  %16 = call i32 (ptr, ...) @printf(ptr @.str, i32 %u2)
  store i32 -1294967296, ptr %big, align 4
  %big3 = load i32, ptr %big, align 4
  store i32 %big3, ptr %si, align 4
  %si4 = load i32, ptr %si, align 4
  %17 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %si4)
  store i8 -1, ptr %sb, align 1
  %sb5 = load i8, ptr %sb, align 1
  %18 = sext i8 %sb5 to i32
  store i32 %18, ptr %wid, align 4
  %wid6 = load i32, ptr %wid, align 4
  %19 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %wid6)
  store i8 -1, ptr %ub, align 1
  %ub7 = load i8, ptr %ub, align 1
  %20 = zext i8 %ub7 to i64
  store i64 %20, ptr %ext, align 8
  %ext8 = load i64, ptr %ext, align 8
  %21 = call i32 (ptr, ...) @printf(ptr @.str.3, i64 %ext8)
  store i32 -1, ptr %umax, align 4
  %umax9 = load i32, ptr %umax, align 4
  %22 = zext i32 %umax9 to i64
  store i64 %22, ptr %wide, align 8
  %wide10 = load i64, ptr %wide, align 8
  %23 = call i32 (ptr, ...) @printf(ptr @.str.4, i64 %wide10)
  ret i32 0
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

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
