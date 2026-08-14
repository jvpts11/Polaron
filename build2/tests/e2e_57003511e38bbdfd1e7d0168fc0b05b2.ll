; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/mutable_string.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/mutable_string.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [3 x i8] c"hi\00"
@.strobj = private global %String { i64 2, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [2 x i8] c"!\00"
@.strobj.2 = private global %String { i64 1, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [7 x i8] c" there\00"
@.strobj.4 = private global %String { i64 6, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5 = private constant [2 x i8] c"x\00"
@.strobj.6 = private global %String { i64 1, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [2 x i8] c"y\00"
@.strobj.8 = private global %String { i64 1, ptr @.strdata.7, i64 0 }
@.str.9 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.10 = private unnamed_addr constant [3 x i8] c"a=\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.12 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.13 = private unnamed_addr constant [3 x i8] c"b=\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %m = alloca ptr, align 8
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
  store ptr %strcpy, ptr %m, align 8
  %m1 = load ptr, ptr %m, align 8
  %str.len = getelementptr inbounds %String, ptr %m1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len2 = load i64, ptr @.strobj.2, align 8
  %16 = add i64 %len, %len2
  %17 = add i64 %16, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %17)
  %str.data = getelementptr inbounds %String, ptr %m1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %18 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data3 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %19 = getelementptr i8, ptr %cat.buf, i64 %len
  %20 = call ptr @memcpy(ptr %19, ptr %data3, i64 %len2)
  %21 = getelementptr i8, ptr %cat.buf, i64 %16
  store i8 0, ptr %21, align 1
  %newstr4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %22 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %16, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %cat.buf, ptr %23, align 8
  %24 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %24, align 8
  %25 = getelementptr inbounds %String, ptr %m1, i32 0, i32 0
  %str.len5 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  store i64 %len6, ptr %25, align 8
  %26 = getelementptr inbounds %String, ptr %m1, i32 0, i32 1
  %str.data7 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  store ptr %data8, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %m1, i32 0, i32 2
  store i64 0, ptr %27, align 8
  %m9 = load ptr, ptr %m, align 8
  %str.len10 = getelementptr inbounds %String, ptr %m9, i32 0, i32 0
  %len11 = load i64, ptr %str.len10, align 8
  %len12 = load i64, ptr @.strobj.4, align 8
  %28 = add i64 %len11, %len12
  %29 = add i64 %28, 1
  %cat.buf13 = call ptr @__polaron_malloc(i64 %29)
  %str.data14 = getelementptr inbounds %String, ptr %m9, i32 0, i32 1
  %data15 = load ptr, ptr %str.data14, align 8
  %30 = call ptr @memcpy(ptr %cat.buf13, ptr %data15, i64 %len11)
  %data16 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %31 = getelementptr i8, ptr %cat.buf13, i64 %len11
  %32 = call ptr @memcpy(ptr %31, ptr %data16, i64 %len12)
  %33 = getelementptr i8, ptr %cat.buf13, i64 %28
  store i8 0, ptr %33, align 1
  %newstr17 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %34 = getelementptr inbounds %String, ptr %newstr17, i32 0, i32 0
  store i64 %28, ptr %34, align 8
  %35 = getelementptr inbounds %String, ptr %newstr17, i32 0, i32 1
  store ptr %cat.buf13, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr17, i32 0, i32 2
  store i64 0, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %m9, i32 0, i32 0
  %str.len18 = getelementptr inbounds %String, ptr %newstr17, i32 0, i32 0
  %len19 = load i64, ptr %str.len18, align 8
  store i64 %len19, ptr %37, align 8
  %38 = getelementptr inbounds %String, ptr %m9, i32 0, i32 1
  %str.data20 = getelementptr inbounds %String, ptr %newstr17, i32 0, i32 1
  %data21 = load ptr, ptr %str.data20, align 8
  store ptr %data21, ptr %38, align 8
  %39 = getelementptr inbounds %String, ptr %m9, i32 0, i32 2
  store i64 0, ptr %39, align 8
  %m22 = load ptr, ptr %m, align 8
  %str.data23 = getelementptr inbounds %String, ptr %m22, i32 0, i32 1
  %data24 = load ptr, ptr %str.data23, align 8
  %40 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data24)
  %strcpy25 = call ptr @__polaron_str_copy(ptr @.strobj.6)
  store ptr %strcpy25, ptr %a, align 8
  %a26 = load ptr, ptr %a, align 8
  %strcpy27 = call ptr @__polaron_str_copy(ptr %a26)
  store ptr %strcpy27, ptr %b, align 8
  %b28 = load ptr, ptr %b, align 8
  %str.len29 = getelementptr inbounds %String, ptr %b28, i32 0, i32 0
  %len30 = load i64, ptr %str.len29, align 8
  %len31 = load i64, ptr @.strobj.8, align 8
  %41 = add i64 %len30, %len31
  %42 = add i64 %41, 1
  %cat.buf32 = call ptr @__polaron_malloc(i64 %42)
  %str.data33 = getelementptr inbounds %String, ptr %b28, i32 0, i32 1
  %data34 = load ptr, ptr %str.data33, align 8
  %43 = call ptr @memcpy(ptr %cat.buf32, ptr %data34, i64 %len30)
  %data35 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.8, i32 0, i32 1), align 8
  %44 = getelementptr i8, ptr %cat.buf32, i64 %len30
  %45 = call ptr @memcpy(ptr %44, ptr %data35, i64 %len31)
  %46 = getelementptr i8, ptr %cat.buf32, i64 %41
  store i8 0, ptr %46, align 1
  %newstr36 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %47 = getelementptr inbounds %String, ptr %newstr36, i32 0, i32 0
  store i64 %41, ptr %47, align 8
  %48 = getelementptr inbounds %String, ptr %newstr36, i32 0, i32 1
  store ptr %cat.buf32, ptr %48, align 8
  %49 = getelementptr inbounds %String, ptr %newstr36, i32 0, i32 2
  store i64 0, ptr %49, align 8
  %50 = getelementptr inbounds %String, ptr %b28, i32 0, i32 0
  %str.len37 = getelementptr inbounds %String, ptr %newstr36, i32 0, i32 0
  %len38 = load i64, ptr %str.len37, align 8
  store i64 %len38, ptr %50, align 8
  %51 = getelementptr inbounds %String, ptr %b28, i32 0, i32 1
  %str.data39 = getelementptr inbounds %String, ptr %newstr36, i32 0, i32 1
  %data40 = load ptr, ptr %str.data39, align 8
  store ptr %data40, ptr %51, align 8
  %52 = getelementptr inbounds %String, ptr %b28, i32 0, i32 2
  store i64 0, ptr %52, align 8
  %53 = call i32 (ptr, ...) @printf(ptr @.str.9, ptr @.str.10)
  %a41 = load ptr, ptr %a, align 8
  %str.data42 = getelementptr inbounds %String, ptr %a41, i32 0, i32 1
  %data43 = load ptr, ptr %str.data42, align 8
  %54 = call i32 (ptr, ...) @printf(ptr @.str.11, ptr %data43)
  %55 = call i32 (ptr, ...) @printf(ptr @.str.12, ptr @.str.13)
  %b44 = load ptr, ptr %b, align 8
  %str.data45 = getelementptr inbounds %String, ptr %b44, i32 0, i32 1
  %data46 = load ptr, ptr %str.data45, align 8
  %56 = call i32 (ptr, ...) @printf(ptr @.str.14, ptr %data46)
  %57 = load ptr, ptr %b, align 8
  call void @__polaron_str_free(ptr %57)
  %58 = load ptr, ptr %a, align 8
  call void @__polaron_str_free(ptr %58)
  %59 = load ptr, ptr %m, align 8
  call void @__polaron_str_free(ptr %59)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5322)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5324)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)
