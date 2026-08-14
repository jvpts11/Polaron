; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interp_string.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interp_string.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [6 x i8] c"world\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.ifmt = private unnamed_addr constant [16 x i8] c"n=%d, hello %s!\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"len=%d\0A\00", align 1
@.ifmt.2 = private unnamed_addr constant [17 x i8] c"%d doubled is %d\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %t = alloca ptr, align 8
  %s = alloca ptr, align 8
  %who = alloca ptr, align 8
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
  call void @Test.__onClassLoad()
  store i32 7, ptr %n, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %who, align 8
  %n1 = load i32, ptr %n, align 4
  %who2 = load ptr, ptr %who, align 8
  %str.data = getelementptr inbounds %String, ptr %who2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ilen = call i32 (ptr, i64, ptr, ...) @snprintf(ptr null, i64 0, ptr @.ifmt, i32 %n1, ptr %data)
  %16 = sext i32 %ilen to i64
  %17 = add i64 %16, 1
  %ibuf = call ptr @__polaron_malloc(i64 %17)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %ibuf, i64 %17, ptr @.ifmt, i32 %n1, ptr %data)
  %newstr3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %19 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 0
  store i64 %16, ptr %19, align 8
  %20 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 1
  store ptr %ibuf, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 2
  store i64 0, ptr %21, align 8
  %strcpy4 = call ptr @__polaron_str_copy(ptr %newstr3)
  store ptr %strcpy4, ptr %s, align 8
  call void @__polaron_str_free(ptr %newstr3)
  %s5 = load ptr, ptr %s, align 8
  %str.data6 = getelementptr inbounds %String, ptr %s5, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %22 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data7)
  %s8 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s8, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %23 = trunc i64 %len to i32
  %24 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %23)
  %n9 = load i32, ptr %n, align 4
  %n10 = load i32, ptr %n, align 4
  %n11 = load i32, ptr %n, align 4
  %25 = add i32 %n10, %n11
  %ilen12 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr null, i64 0, ptr @.ifmt.2, i32 %n9, i32 %25)
  %26 = sext i32 %ilen12 to i64
  %27 = add i64 %26, 1
  %ibuf13 = call ptr @__polaron_malloc(i64 %27)
  %28 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %ibuf13, i64 %27, ptr @.ifmt.2, i32 %n9, i32 %25)
  %newstr14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %29 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 0
  store i64 %26, ptr %29, align 8
  %30 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 1
  store ptr %ibuf13, ptr %30, align 8
  %31 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 2
  store i64 0, ptr %31, align 8
  %strcpy15 = call ptr @__polaron_str_copy(ptr %newstr14)
  store ptr %strcpy15, ptr %t, align 8
  call void @__polaron_str_free(ptr %newstr14)
  %t16 = load ptr, ptr %t, align 8
  %str.data17 = getelementptr inbounds %String, ptr %t16, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %32 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr %data18)
  %33 = load ptr, ptr %t, align 8
  call void @__polaron_str_free(ptr %33)
  %34 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %34)
  %35 = load ptr, ptr %who, align 8
  call void @__polaron_str_free(ptr %35)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5311)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)
