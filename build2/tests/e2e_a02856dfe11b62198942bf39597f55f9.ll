; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_methods.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_methods.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [6 x i8] c"Hello\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [6 x i8] c"World\00"
@.strobj.2 = private global %String { i64 5, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [3 x i8] c", \00"
@.strobj.4 = private global %String { i64 2, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [2 x i8] c"!\00"
@.strobj.6 = private global %String { i64 1, ptr @.strdata.5, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.7 = private unnamed_addr constant [17 x i8] c"len=%d empty=%d\0A\00", align 1
@.str.8 = private unnamed_addr constant [19 x i8] c"char0=%c char7=%c\0A\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.10 = private unnamed_addr constant [13 x i8] c"eq=%d ne=%d\0A\00", align 1
@.strdata.11 = private constant [6 x i8] c"Hello\00"
@.strobj.12 = private global %String { i64 5, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [5 x i8] c"nope\00"
@.strobj.14 = private global %String { i64 4, ptr @.strdata.13, i64 0 }
@.strdata.15 = private constant [1 x i8] zeroinitializer
@.strobj.16 = private global %String { i64 0, ptr @.strdata.15, i64 0 }
@.str.17 = private unnamed_addr constant [17 x i8] c"emptyIsEmpty=%d\0A\00", align 1
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }
@.strdata.5326 = private constant [1 x i8] zeroinitializer
@.strobj.5327 = private global %String { i64 0, ptr @.strdata.5326, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %empty = alloca ptr, align 8
  %hw = alloca ptr, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
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
  store ptr %strcpy, ptr %a, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.2)
  store ptr %strcpy1, ptr %b, align 8
  %a2 = load ptr, ptr %a, align 8
  %str.len = getelementptr inbounds %String, ptr %a2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len3 = load i64, ptr @.strobj.4, align 8
  %16 = add i64 %len, %len3
  %17 = add i64 %16, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %17)
  %str.data = getelementptr inbounds %String, ptr %a2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %18 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data4 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %19 = getelementptr i8, ptr %cat.buf, i64 %len
  %20 = call ptr @memcpy(ptr %19, ptr %data4, i64 %len3)
  %21 = getelementptr i8, ptr %cat.buf, i64 %16
  store i8 0, ptr %21, align 1
  %newstr5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %22 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 0
  store i64 %16, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 1
  store ptr %cat.buf, ptr %23, align 8
  %24 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 2
  store i64 0, ptr %24, align 8
  %b6 = load ptr, ptr %b, align 8
  %str.len7 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %str.len9 = getelementptr inbounds %String, ptr %b6, i32 0, i32 0
  %len10 = load i64, ptr %str.len9, align 8
  %25 = add i64 %len8, %len10
  %26 = add i64 %25, 1
  %cat.buf11 = call ptr @__polaron_malloc(i64 %26)
  %str.data12 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %27 = call ptr @memcpy(ptr %cat.buf11, ptr %data13, i64 %len8)
  %str.data14 = getelementptr inbounds %String, ptr %b6, i32 0, i32 1
  %data15 = load ptr, ptr %str.data14, align 8
  %28 = getelementptr i8, ptr %cat.buf11, i64 %len8
  %29 = call ptr @memcpy(ptr %28, ptr %data15, i64 %len10)
  %30 = getelementptr i8, ptr %cat.buf11, i64 %25
  store i8 0, ptr %30, align 1
  %newstr16 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %31 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  store i64 %25, ptr %31, align 8
  %32 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  store ptr %cat.buf11, ptr %32, align 8
  %33 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 2
  store i64 0, ptr %33, align 8
  %str.len17 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  %len19 = load i64, ptr @.strobj.6, align 8
  %34 = add i64 %len18, %len19
  %35 = add i64 %34, 1
  %cat.buf20 = call ptr @__polaron_malloc(i64 %35)
  %str.data21 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %36 = call ptr @memcpy(ptr %cat.buf20, ptr %data22, i64 %len18)
  %data23 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %37 = getelementptr i8, ptr %cat.buf20, i64 %len18
  %38 = call ptr @memcpy(ptr %37, ptr %data23, i64 %len19)
  %39 = getelementptr i8, ptr %cat.buf20, i64 %34
  store i8 0, ptr %39, align 1
  %newstr24 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %40 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 0
  store i64 %34, ptr %40, align 8
  %41 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 1
  store ptr %cat.buf20, ptr %41, align 8
  %42 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 2
  store i64 0, ptr %42, align 8
  %strcpy25 = call ptr @__polaron_str_copy(ptr %newstr24)
  store ptr %strcpy25, ptr %hw, align 8
  call void @__polaron_str_free(ptr %newstr5)
  call void @__polaron_str_free(ptr %newstr16)
  call void @__polaron_str_free(ptr %newstr24)
  %hw26 = load ptr, ptr %hw, align 8
  %str.data27 = getelementptr inbounds %String, ptr %hw26, i32 0, i32 1
  %data28 = load ptr, ptr %str.data27, align 8
  %43 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data28)
  %hw29 = load ptr, ptr %hw, align 8
  %str.len30 = getelementptr inbounds %String, ptr %hw29, i32 0, i32 0
  %len31 = load i64, ptr %str.len30, align 8
  %44 = trunc i64 %len31 to i32
  %hw32 = load ptr, ptr %hw, align 8
  %str.len33 = getelementptr inbounds %String, ptr %hw32, i32 0, i32 0
  %len34 = load i64, ptr %str.len33, align 8
  %45 = icmp eq i64 %len34, 0
  %46 = zext i1 %45 to i32
  %47 = call i32 (ptr, ...) @printf(ptr @.str.7, i32 %44, i32 %46)
  %a35 = load ptr, ptr %a, align 8
  %str.data36 = getelementptr inbounds %String, ptr %a35, i32 0, i32 1
  %data37 = load ptr, ptr %str.data36, align 8
  %ch.addr = getelementptr i8, ptr %data37, i64 0
  %ch = load i8, ptr %ch.addr, align 1
  %48 = zext i8 %ch to i32
  %hw38 = load ptr, ptr %hw, align 8
  %str.data39 = getelementptr inbounds %String, ptr %hw38, i32 0, i32 1
  %data40 = load ptr, ptr %str.data39, align 8
  %ch.addr41 = getelementptr i8, ptr %data40, i64 7
  %ch42 = load i8, ptr %ch.addr41, align 1
  %49 = zext i8 %ch42 to i32
  %50 = call i32 (ptr, ...) @printf(ptr @.str.8, i32 %48, i32 %49)
  %hw43 = load ptr, ptr %hw, align 8
  %sub.buf = call ptr @__polaron_malloc(i64 6)
  %str.data44 = getelementptr inbounds %String, ptr %hw43, i32 0, i32 1
  %data45 = load ptr, ptr %str.data44, align 8
  %51 = getelementptr i8, ptr %data45, i64 7
  %52 = call ptr @memcpy(ptr %sub.buf, ptr %51, i64 5)
  %53 = getelementptr i8, ptr %sub.buf, i64 5
  store i8 0, ptr %53, align 1
  %newstr46 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %54 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 0
  store i64 5, ptr %54, align 8
  %55 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 1
  store ptr %sub.buf, ptr %55, align 8
  %56 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 2
  store i64 0, ptr %56, align 8
  %str.data47 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 1
  %data48 = load ptr, ptr %str.data47, align 8
  %57 = call i32 (ptr, ...) @printf(ptr @.str.9, ptr %data48)
  call void @__polaron_str_free(ptr %newstr46)
  %a49 = load ptr, ptr %a, align 8
  %str.data50 = getelementptr inbounds %String, ptr %a49, i32 0, i32 1
  %data51 = load ptr, ptr %str.data50, align 8
  %data52 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.12, i32 0, i32 1), align 8
  %58 = call i32 @strcmp(ptr %data51, ptr %data52)
  %59 = icmp eq i32 %58, 0
  %60 = zext i1 %59 to i32
  %a53 = load ptr, ptr %a, align 8
  %str.data54 = getelementptr inbounds %String, ptr %a53, i32 0, i32 1
  %data55 = load ptr, ptr %str.data54, align 8
  %data56 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.14, i32 0, i32 1), align 8
  %61 = call i32 @strcmp(ptr %data55, ptr %data56)
  %62 = icmp eq i32 %61, 0
  %63 = zext i1 %62 to i32
  %64 = call i32 (ptr, ...) @printf(ptr @.str.10, i32 %60, i32 %63)
  %strcpy57 = call ptr @__polaron_str_copy(ptr @.strobj.16)
  store ptr %strcpy57, ptr %empty, align 8
  %empty58 = load ptr, ptr %empty, align 8
  %str.len59 = getelementptr inbounds %String, ptr %empty58, i32 0, i32 0
  %len60 = load i64, ptr %str.len59, align 8
  %65 = icmp eq i64 %len60, 0
  %66 = zext i1 %65 to i32
  %67 = call i32 (ptr, ...) @printf(ptr @.str.17, i32 %66)
  %68 = load ptr, ptr %empty, align 8
  call void @__polaron_str_free(ptr %68)
  %69 = load ptr, ptr %hw, align 8
  call void @__polaron_str_free(ptr %69)
  %70 = load ptr, ptr %b, align 8
  call void @__polaron_str_free(ptr %70)
  %71 = load ptr, ptr %a, align 8
  call void @__polaron_str_free(ptr %71)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5325)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5327)
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
