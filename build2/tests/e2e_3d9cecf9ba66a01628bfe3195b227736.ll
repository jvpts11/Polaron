; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deprecated_and_at_annotations.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deprecated_and_at_annotations.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [3 x i8] c"a=\00"
@.strobj = private global %String { i64 2, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c" b=\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }

define internal i32 @Api.oldWay(i32 %0) {
entry:
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %1 = mul i32 %x1, 2
  ret i32 %1
}

define internal i32 @Api.newWay(i32 %0) {
entry:
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %1 = mul i32 %x1, 2
  ret i32 %1
}

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
  %16 = call i32 @Api.oldWay(i32 21)
  store i32 %16, ptr %a, align 4
  %17 = call i32 @Api.newWay(i32 21)
  store i32 %17, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %18 = sext i32 %a1 to i64
  %19 = call i64 @__polaron_itoa(i64 %18, ptr %itoa.buf)
  %newstr2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %20 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 0
  store i64 %19, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 1
  store ptr %itoa.buf, ptr %21, align 8
  %22 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 2
  store i64 0, ptr %22, align 8
  %len = load i64, ptr @.strobj, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 0
  %len3 = load i64, ptr %str.len, align 8
  %23 = add i64 %len, %len3
  %24 = add i64 %23, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %24)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %25 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data, align 8
  %26 = getelementptr i8, ptr %cat.buf, i64 %len
  %27 = call ptr @memcpy(ptr %26, ptr %data4, i64 %len3)
  %28 = getelementptr i8, ptr %cat.buf, i64 %23
  store i8 0, ptr %28, align 1
  %newstr5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %29 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 0
  store i64 %23, ptr %29, align 8
  %30 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 1
  store ptr %cat.buf, ptr %30, align 8
  %31 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 2
  store i64 0, ptr %31, align 8
  %str.len6 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 0
  %len7 = load i64, ptr %str.len6, align 8
  %len8 = load i64, ptr @.strobj.2, align 8
  %32 = add i64 %len7, %len8
  %33 = add i64 %32, 1
  %cat.buf9 = call ptr @__polaron_malloc(i64 %33)
  %str.data10 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %34 = call ptr @memcpy(ptr %cat.buf9, ptr %data11, i64 %len7)
  %data12 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %35 = getelementptr i8, ptr %cat.buf9, i64 %len7
  %36 = call ptr @memcpy(ptr %35, ptr %data12, i64 %len8)
  %37 = getelementptr i8, ptr %cat.buf9, i64 %32
  store i8 0, ptr %37, align 1
  %newstr13 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %38 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 0
  store i64 %32, ptr %38, align 8
  %39 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 1
  store ptr %cat.buf9, ptr %39, align 8
  %40 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 2
  store i64 0, ptr %40, align 8
  %b14 = load i32, ptr %b, align 4
  %itoa.buf15 = call ptr @__polaron_malloc(i64 24)
  %41 = sext i32 %b14 to i64
  %42 = call i64 @__polaron_itoa(i64 %41, ptr %itoa.buf15)
  %newstr16 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %43 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  store i64 %42, ptr %43, align 8
  %44 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  store ptr %itoa.buf15, ptr %44, align 8
  %45 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 2
  store i64 0, ptr %45, align 8
  %str.len17 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  %str.len19 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  %len20 = load i64, ptr %str.len19, align 8
  %46 = add i64 %len18, %len20
  %47 = add i64 %46, 1
  %cat.buf21 = call ptr @__polaron_malloc(i64 %47)
  %str.data22 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %48 = call ptr @memcpy(ptr %cat.buf21, ptr %data23, i64 %len18)
  %str.data24 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  %data25 = load ptr, ptr %str.data24, align 8
  %49 = getelementptr i8, ptr %cat.buf21, i64 %len18
  %50 = call ptr @memcpy(ptr %49, ptr %data25, i64 %len20)
  %51 = getelementptr i8, ptr %cat.buf21, i64 %46
  store i8 0, ptr %51, align 1
  %newstr26 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %52 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 0
  store i64 %46, ptr %52, align 8
  %53 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 1
  store ptr %cat.buf21, ptr %53, align 8
  %54 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 2
  store i64 0, ptr %54, align 8
  %str.data27 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 1
  %data28 = load ptr, ptr %str.data27, align 8
  %55 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data28)
  call void @__polaron_str_free(ptr %newstr2)
  call void @__polaron_str_free(ptr %newstr5)
  call void @__polaron_str_free(ptr %newstr13)
  call void @__polaron_str_free(ptr %newstr16)
  call void @__polaron_str_free(ptr %newstr26)
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

declare i64 @__polaron_itoa(i64, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
