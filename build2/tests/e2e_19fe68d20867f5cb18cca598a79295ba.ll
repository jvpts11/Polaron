; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/file_io_stdlib.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/file_io_stdlib.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [25 x i8] c"polaron_file_io_test.txt\00"
@.strobj = private global %String { i64 24, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [11 x i8] c"hello file\00"
@.strobj.2 = private global %String { i64 10, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c"!\00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [45 x i8] c"w=%d ex=%d len=%d eq=%d len2=%d d=%d ex2=%d\0A\00", align 1
@.strdata.5 = private constant [11 x i8] c"hello file\00"
@.strobj.6 = private global %String { i64 10, ptr @.strdata.5, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %ex2 = alloca i32, align 4
  %d = alloca i32, align 4
  %content2 = alloca ptr, align 8
  %a = alloca i32, align 4
  %content = alloca ptr, align 8
  %ex = alloca i32, align 4
  %w = alloca i32, align 4
  %path = alloca ptr, align 8
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %path, align 8
  %path1 = load ptr, ptr %path, align 8
  %str.data = getelementptr inbounds %String, ptr %path1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %len = load i64, ptr @.strobj.2, align 8
  %16 = call i32 @__polaron_file_write_all(ptr %data, ptr %data2, i64 %len, i32 0)
  store i32 %16, ptr %w, align 4
  %path3 = load ptr, ptr %path, align 8
  %str.data4 = getelementptr inbounds %String, ptr %path3, i32 0, i32 1
  %data5 = load ptr, ptr %str.data4, align 8
  %17 = call i32 @__polaron_file_exists(ptr %data5)
  store i32 %17, ptr %ex, align 4
  %path6 = load ptr, ptr %path, align 8
  %fr.len = alloca i64, align 8
  %str.data7 = getelementptr inbounds %String, ptr %path6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %18 = call ptr @__polaron_file_read_all(ptr %data8, ptr %fr.len)
  %fr.n = load i64, ptr %fr.len, align 8
  %newstr9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %19 = getelementptr inbounds %String, ptr %newstr9, i32 0, i32 0
  store i64 %fr.n, ptr %19, align 8
  %20 = getelementptr inbounds %String, ptr %newstr9, i32 0, i32 1
  store ptr %18, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr9, i32 0, i32 2
  store i64 0, ptr %21, align 8
  %strcpy10 = call ptr @__polaron_str_copy(ptr %newstr9)
  store ptr %strcpy10, ptr %content, align 8
  call void @__polaron_str_free(ptr %newstr9)
  %path11 = load ptr, ptr %path, align 8
  %str.data12 = getelementptr inbounds %String, ptr %path11, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %data14 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %len15 = load i64, ptr @.strobj.4, align 8
  %22 = call i32 @__polaron_file_write_all(ptr %data13, ptr %data14, i64 %len15, i32 1)
  store i32 %22, ptr %a, align 4
  %path16 = load ptr, ptr %path, align 8
  %fr.len17 = alloca i64, align 8
  %str.data18 = getelementptr inbounds %String, ptr %path16, i32 0, i32 1
  %data19 = load ptr, ptr %str.data18, align 8
  %23 = call ptr @__polaron_file_read_all(ptr %data19, ptr %fr.len17)
  %fr.n20 = load i64, ptr %fr.len17, align 8
  %newstr21 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %24 = getelementptr inbounds %String, ptr %newstr21, i32 0, i32 0
  store i64 %fr.n20, ptr %24, align 8
  %25 = getelementptr inbounds %String, ptr %newstr21, i32 0, i32 1
  store ptr %23, ptr %25, align 8
  %26 = getelementptr inbounds %String, ptr %newstr21, i32 0, i32 2
  store i64 0, ptr %26, align 8
  %strcpy22 = call ptr @__polaron_str_copy(ptr %newstr21)
  store ptr %strcpy22, ptr %content2, align 8
  call void @__polaron_str_free(ptr %newstr21)
  %path23 = load ptr, ptr %path, align 8
  %str.data24 = getelementptr inbounds %String, ptr %path23, i32 0, i32 1
  %data25 = load ptr, ptr %str.data24, align 8
  %27 = call i32 @__polaron_file_delete(ptr %data25)
  store i32 %27, ptr %d, align 4
  %path26 = load ptr, ptr %path, align 8
  %str.data27 = getelementptr inbounds %String, ptr %path26, i32 0, i32 1
  %data28 = load ptr, ptr %str.data27, align 8
  %28 = call i32 @__polaron_file_exists(ptr %data28)
  store i32 %28, ptr %ex2, align 4
  %w29 = load i32, ptr %w, align 4
  %ex30 = load i32, ptr %ex, align 4
  %content31 = load ptr, ptr %content, align 8
  %str.len = getelementptr inbounds %String, ptr %content31, i32 0, i32 0
  %len32 = load i64, ptr %str.len, align 8
  %29 = trunc i64 %len32 to i32
  %content33 = load ptr, ptr %content, align 8
  %str.data34 = getelementptr inbounds %String, ptr %content33, i32 0, i32 1
  %data35 = load ptr, ptr %str.data34, align 8
  %data36 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %30 = call i32 @strcmp(ptr %data35, ptr %data36)
  %31 = icmp eq i32 %30, 0
  %32 = zext i1 %31 to i32
  %content237 = load ptr, ptr %content2, align 8
  %str.len38 = getelementptr inbounds %String, ptr %content237, i32 0, i32 0
  %len39 = load i64, ptr %str.len38, align 8
  %33 = trunc i64 %len39 to i32
  %d40 = load i32, ptr %d, align 4
  %ex241 = load i32, ptr %ex2, align 4
  %34 = call i32 (ptr, ...) @printf(ptr @.str, i32 %w29, i32 %ex30, i32 %29, i32 %32, i32 %33, i32 %d40, i32 %ex241)
  %35 = load ptr, ptr %content2, align 8
  call void @__polaron_str_free(ptr %35)
  %36 = load ptr, ptr %content, align 8
  call void @__polaron_str_free(ptr %36)
  %37 = load ptr, ptr %path, align 8
  call void @__polaron_str_free(ptr %37)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i32 @__polaron_file_write_all(ptr, ptr, i64, i32)

declare i32 @__polaron_file_exists(ptr)

declare ptr @__polaron_file_read_all(ptr, ptr)

declare void @__polaron_str_free(ptr)

declare i32 @__polaron_file_delete(ptr)

declare i32 @strcmp(ptr, ptr)

declare i32 @printf(ptr, ...)
