; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interp_percent.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interp_percent.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.ifmt = private unnamed_addr constant [14 x i8] c"50%% of %d | \00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.ifmt.2 = private unnamed_addr constant [11 x i8] c"%d.%d%% | \00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.ifmt.4 = private unnamed_addr constant [15 x i8] c"%d%% and %d | \00", align 1
@.str.5 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.ifmt.6 = private unnamed_addr constant [19 x i8] c"100%%success %d | \00", align 1
@.str.7 = private unnamed_addr constant [11 x i8] c"%d.%d%%%%\0A\00", align 1
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca i32, align 4
  %a = alloca i32, align 4
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
  store i32 1, ptr %a, align 4
  store i32 2, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %ilen = call i32 (ptr, i64, ptr, ...) @snprintf(ptr null, i64 0, ptr @.ifmt, i32 %a1)
  %16 = sext i32 %ilen to i64
  %17 = add i64 %16, 1
  %ibuf = call ptr @__polaron_malloc(i64 %17)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %ibuf, i64 %17, ptr @.ifmt, i32 %a1)
  %newstr2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %19 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 0
  store i64 %16, ptr %19, align 8
  %20 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 1
  store ptr %ibuf, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 2
  store i64 0, ptr %21, align 8
  %str.data = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %22 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %newstr2)
  %a3 = load i32, ptr %a, align 4
  %b4 = load i32, ptr %b, align 4
  %ilen5 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr null, i64 0, ptr @.ifmt.2, i32 %a3, i32 %b4)
  %23 = sext i32 %ilen5 to i64
  %24 = add i64 %23, 1
  %ibuf6 = call ptr @__polaron_malloc(i64 %24)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %ibuf6, i64 %24, ptr @.ifmt.2, i32 %a3, i32 %b4)
  %newstr7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %26 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 0
  store i64 %23, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 1
  store ptr %ibuf6, ptr %27, align 8
  %28 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 2
  store i64 0, ptr %28, align 8
  %str.data8 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %29 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data9)
  call void @__polaron_str_free(ptr %newstr7)
  %a10 = load i32, ptr %a, align 4
  %b11 = load i32, ptr %b, align 4
  %ilen12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr null, i64 0, ptr @.ifmt.4, i32 %a10, i32 %b11)
  %30 = sext i32 %ilen12 to i64
  %31 = add i64 %30, 1
  %ibuf13 = call ptr @__polaron_malloc(i64 %31)
  %32 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %ibuf13, i64 %31, ptr @.ifmt.4, i32 %a10, i32 %b11)
  %newstr14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %33 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 0
  store i64 %30, ptr %33, align 8
  %34 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 1
  store ptr %ibuf13, ptr %34, align 8
  %35 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 2
  store i64 0, ptr %35, align 8
  %str.data15 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 1
  %data16 = load ptr, ptr %str.data15, align 8
  %36 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr %data16)
  call void @__polaron_str_free(ptr %newstr14)
  %a17 = load i32, ptr %a, align 4
  %ilen18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr null, i64 0, ptr @.ifmt.6, i32 %a17)
  %37 = sext i32 %ilen18 to i64
  %38 = add i64 %37, 1
  %ibuf19 = call ptr @__polaron_malloc(i64 %38)
  %39 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %ibuf19, i64 %38, ptr @.ifmt.6, i32 %a17)
  %newstr20 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %40 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 0
  store i64 %37, ptr %40, align 8
  %41 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 1
  store ptr %ibuf19, ptr %41, align 8
  %42 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 2
  store i64 0, ptr %42, align 8
  %str.data21 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %43 = call i32 (ptr, ...) @printf(ptr @.str.5, ptr %data22)
  call void @__polaron_str_free(ptr %newstr20)
  %a23 = load i32, ptr %a, align 4
  %b24 = load i32, ptr %b, align 4
  %44 = call i32 (ptr, ...) @printf(ptr @.str.7, i32 %a23, i32 %b24)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5315)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
