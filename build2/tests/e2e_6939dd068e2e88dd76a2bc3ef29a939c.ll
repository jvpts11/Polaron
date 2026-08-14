; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/read_echo.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/read_echo.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [18 x i8] c"a=%d b=%d sum=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca i32, align 4
  %rlen2 = alloca i64, align 8
  %a = alloca i32, align 4
  %rlen = alloca i64, align 8
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
  %line = call ptr @polaron_read_line(ptr %rlen)
  %16 = load i64, ptr %rlen, align 8
  %newstr1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 0
  store i64 %16, ptr %17, align 8
  %18 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 1
  store ptr %line, ptr %18, align 8
  %19 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 2
  store i64 0, ptr %19, align 8
  %str.data = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %20 = call i32 @atoi(ptr %data)
  store i32 %20, ptr %a, align 4
  call void @__polaron_str_free(ptr %newstr1)
  %line3 = call ptr @polaron_read_line(ptr %rlen2)
  %21 = load i64, ptr %rlen2, align 8
  %newstr4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %22 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %21, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %line3, ptr %23, align 8
  %24 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %24, align 8
  %str.data5 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %25 = call i32 @atoi(ptr %data6)
  store i32 %25, ptr %b, align 4
  call void @__polaron_str_free(ptr %newstr4)
  %a7 = load i32, ptr %a, align 4
  %b8 = load i32, ptr %b, align 4
  %a9 = load i32, ptr %a, align 4
  %b10 = load i32, ptr %b, align 4
  %26 = add i32 %a9, %b10
  %27 = call i32 (ptr, ...) @printf(ptr @.str, i32 %a7, i32 %b8, i32 %26)
  ret i32 0
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

declare ptr @polaron_read_line(ptr)

declare i32 @atoi(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @__polaron_str_copy(ptr)
