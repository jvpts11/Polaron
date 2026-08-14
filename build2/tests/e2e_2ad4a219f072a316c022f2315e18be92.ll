; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/strings.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/strings.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [8 x i8] c"Hello, \00"
@.strobj = private global %String { i64 7, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [6 x i8] c"world\00"
@.strobj.2 = private global %String { i64 5, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c"!\00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"len=%d\0A\00", align 1
@.str.6 = private unnamed_addr constant [6 x i8] c"c=%c\0A\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"sub=\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.10 = private unnamed_addr constant [13 x i8] c"eq=%d ne=%d\0A\00", align 1
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %sub = alloca ptr, align 8
  %msg = alloca ptr, align 8
  %who = alloca ptr, align 8
  %hello = alloca ptr, align 8
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
  store ptr %strcpy, ptr %hello, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.2)
  store ptr %strcpy1, ptr %who, align 8
  %hello2 = load ptr, ptr %hello, align 8
  %who3 = load ptr, ptr %who, align 8
  %str.len = getelementptr inbounds %String, ptr %hello2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.len4 = getelementptr inbounds %String, ptr %who3, i32 0, i32 0
  %len5 = load i64, ptr %str.len4, align 8
  %16 = add i64 %len, %len5
  %17 = add i64 %16, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %17)
  %str.data = getelementptr inbounds %String, ptr %hello2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %18 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data6 = getelementptr inbounds %String, ptr %who3, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %19 = getelementptr i8, ptr %cat.buf, i64 %len
  %20 = call ptr @memcpy(ptr %19, ptr %data7, i64 %len5)
  %21 = getelementptr i8, ptr %cat.buf, i64 %16
  store i8 0, ptr %21, align 1
  %newstr8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %22 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 0
  store i64 %16, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  store ptr %cat.buf, ptr %23, align 8
  %24 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 2
  store i64 0, ptr %24, align 8
  %str.len9 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 0
  %len10 = load i64, ptr %str.len9, align 8
  %len11 = load i64, ptr @.strobj.4, align 8
  %25 = add i64 %len10, %len11
  %26 = add i64 %25, 1
  %cat.buf12 = call ptr @__polaron_malloc(i64 %26)
  %str.data13 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  %data14 = load ptr, ptr %str.data13, align 8
  %27 = call ptr @memcpy(ptr %cat.buf12, ptr %data14, i64 %len10)
  %data15 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %28 = getelementptr i8, ptr %cat.buf12, i64 %len10
  %29 = call ptr @memcpy(ptr %28, ptr %data15, i64 %len11)
  %30 = getelementptr i8, ptr %cat.buf12, i64 %25
  store i8 0, ptr %30, align 1
  %newstr16 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %31 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  store i64 %25, ptr %31, align 8
  %32 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  store ptr %cat.buf12, ptr %32, align 8
  %33 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 2
  store i64 0, ptr %33, align 8
  %strcpy17 = call ptr @__polaron_str_copy(ptr %newstr16)
  store ptr %strcpy17, ptr %msg, align 8
  call void @__polaron_str_free(ptr %newstr8)
  call void @__polaron_str_free(ptr %newstr16)
  %msg18 = load ptr, ptr %msg, align 8
  %str.data19 = getelementptr inbounds %String, ptr %msg18, i32 0, i32 1
  %data20 = load ptr, ptr %str.data19, align 8
  %34 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data20)
  %msg21 = load ptr, ptr %msg, align 8
  %str.len22 = getelementptr inbounds %String, ptr %msg21, i32 0, i32 0
  %len23 = load i64, ptr %str.len22, align 8
  %35 = trunc i64 %len23 to i32
  %36 = call i32 (ptr, ...) @printf(ptr @.str.5, i32 %35)
  %msg24 = load ptr, ptr %msg, align 8
  %str.data25 = getelementptr inbounds %String, ptr %msg24, i32 0, i32 1
  %data26 = load ptr, ptr %str.data25, align 8
  %ch.addr = getelementptr i8, ptr %data26, i64 7
  %ch = load i8, ptr %ch.addr, align 1
  %37 = zext i8 %ch to i32
  %38 = call i32 (ptr, ...) @printf(ptr @.str.6, i32 %37)
  %msg27 = load ptr, ptr %msg, align 8
  %sub.buf = call ptr @__polaron_malloc(i64 6)
  %str.data28 = getelementptr inbounds %String, ptr %msg27, i32 0, i32 1
  %data29 = load ptr, ptr %str.data28, align 8
  %39 = getelementptr i8, ptr %data29, i64 7
  %40 = call ptr @memcpy(ptr %sub.buf, ptr %39, i64 5)
  %41 = getelementptr i8, ptr %sub.buf, i64 5
  store i8 0, ptr %41, align 1
  %newstr30 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %42 = getelementptr inbounds %String, ptr %newstr30, i32 0, i32 0
  store i64 5, ptr %42, align 8
  %43 = getelementptr inbounds %String, ptr %newstr30, i32 0, i32 1
  store ptr %sub.buf, ptr %43, align 8
  %44 = getelementptr inbounds %String, ptr %newstr30, i32 0, i32 2
  store i64 0, ptr %44, align 8
  %strcpy31 = call ptr @__polaron_str_copy(ptr %newstr30)
  store ptr %strcpy31, ptr %sub, align 8
  call void @__polaron_str_free(ptr %newstr30)
  %45 = call i32 (ptr, ...) @printf(ptr @.str.7, ptr @.str.8)
  %sub32 = load ptr, ptr %sub, align 8
  %str.data33 = getelementptr inbounds %String, ptr %sub32, i32 0, i32 1
  %data34 = load ptr, ptr %str.data33, align 8
  %46 = call i32 (ptr, ...) @printf(ptr @.str.9, ptr %data34)
  %sub35 = load ptr, ptr %sub, align 8
  %who36 = load ptr, ptr %who, align 8
  %str.data37 = getelementptr inbounds %String, ptr %sub35, i32 0, i32 1
  %data38 = load ptr, ptr %str.data37, align 8
  %str.data39 = getelementptr inbounds %String, ptr %who36, i32 0, i32 1
  %data40 = load ptr, ptr %str.data39, align 8
  %47 = call i32 @strcmp(ptr %data38, ptr %data40)
  %48 = icmp eq i32 %47, 0
  %49 = zext i1 %48 to i32
  %sub41 = load ptr, ptr %sub, align 8
  %hello42 = load ptr, ptr %hello, align 8
  %str.data43 = getelementptr inbounds %String, ptr %sub41, i32 0, i32 1
  %data44 = load ptr, ptr %str.data43, align 8
  %str.data45 = getelementptr inbounds %String, ptr %hello42, i32 0, i32 1
  %data46 = load ptr, ptr %str.data45, align 8
  %50 = call i32 @strcmp(ptr %data44, ptr %data46)
  %51 = icmp eq i32 %50, 0
  %52 = zext i1 %51 to i32
  %53 = call i32 (ptr, ...) @printf(ptr @.str.10, i32 %49, i32 %52)
  %54 = load ptr, ptr %sub, align 8
  call void @__polaron_str_free(ptr %54)
  %55 = load ptr, ptr %msg, align 8
  call void @__polaron_str_free(ptr %55)
  %56 = load ptr, ptr %who, align 8
  call void @__polaron_str_free(ptr %56)
  %57 = load ptr, ptr %hello, align 8
  call void @__polaron_str_free(ptr %57)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5320)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare i32 @strcmp(ptr, ptr)
