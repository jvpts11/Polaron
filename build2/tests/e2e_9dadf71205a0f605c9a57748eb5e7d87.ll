; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_methods_stdlib.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_methods_stdlib.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [13 x i8] c"Hello, World\00"
@.strobj = private global %String { i64 12, ptr @.strdata, i64 0 }
@.str = private unnamed_addr constant [33 x i8] c"idx=%d has=%d sw=%d ew=%d nf=%d\0A\00", align 1
@.strdata.1 = private constant [6 x i8] c"World\00"
@.strobj.2 = private global %String { i64 5, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [4 x i8] c"lo,\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [6 x i8] c"Hello\00"
@.strobj.6 = private global %String { i64 5, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [6 x i8] c"World\00"
@.strobj.8 = private global %String { i64 5, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [4 x i8] c"xyz\00"
@.strobj.10 = private global %String { i64 3, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [7 x i8] c"  hi  \00"
@.strobj.12 = private global %String { i64 6, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [3 x i8] c"ab\00"
@.strobj.14 = private global %String { i64 2, ptr @.strdata.13, i64 0 }
@.str.15 = private unnamed_addr constant [44 x i8] c"up=%d lo=%d trlen=%d treq=%d rp=%d rpeq=%d\0A\00", align 1
@.strdata.16 = private constant [13 x i8] c"HELLO, WORLD\00"
@.strobj.17 = private global %String { i64 12, ptr @.strdata.16, i64 0 }
@.strdata.18 = private constant [13 x i8] c"hello, world\00"
@.strobj.19 = private global %String { i64 12, ptr @.strdata.18, i64 0 }
@.strdata.20 = private constant [3 x i8] c"hi\00"
@.strobj.21 = private global %String { i64 2, ptr @.strdata.20, i64 0 }
@.strdata.22 = private constant [7 x i8] c"ababab\00"
@.strobj.23 = private global %String { i64 6, ptr @.strdata.22, i64 0 }
@.strdata.5330 = private constant [1 x i8] zeroinitializer
@.strobj.5331 = private global %String { i64 0, ptr @.strdata.5330, i64 0 }
@.strdata.5332 = private constant [1 x i8] zeroinitializer
@.strobj.5333 = private global %String { i64 0, ptr @.strdata.5332, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %rp = alloca ptr, align 8
  %tr = alloca ptr, align 8
  %lo = alloca ptr, align 8
  %up = alloca ptr, align 8
  %s = alloca ptr, align 8
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
  store ptr %strcpy, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.data = getelementptr inbounds %String, ptr %s1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %len3 = load i64, ptr @.strobj.2, align 8
  %16 = call i64 @__polaron_str_index(ptr %data, i64 %len, ptr %data2, i64 %len3)
  %17 = trunc i64 %16 to i32
  %s4 = load ptr, ptr %s, align 8
  %str.data5 = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %str.len7 = getelementptr inbounds %String, ptr %s4, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %data9 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %len10 = load i64, ptr @.strobj.4, align 8
  %18 = call i64 @__polaron_str_index(ptr %data6, i64 %len8, ptr %data9, i64 %len10)
  %19 = icmp sge i64 %18, 0
  %20 = zext i1 %19 to i32
  %s11 = load ptr, ptr %s, align 8
  %str.data12 = getelementptr inbounds %String, ptr %s11, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %str.len14 = getelementptr inbounds %String, ptr %s11, i32 0, i32 0
  %len15 = load i64, ptr %str.len14, align 8
  %data16 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %len17 = load i64, ptr @.strobj.6, align 8
  %21 = call i64 @__polaron_str_index(ptr %data13, i64 %len15, ptr %data16, i64 %len17)
  %22 = icmp eq i64 %21, 0
  %23 = zext i1 %22 to i32
  %s18 = load ptr, ptr %s, align 8
  %str.data19 = getelementptr inbounds %String, ptr %s18, i32 0, i32 1
  %data20 = load ptr, ptr %str.data19, align 8
  %str.len21 = getelementptr inbounds %String, ptr %s18, i32 0, i32 0
  %len22 = load i64, ptr %str.len21, align 8
  %data23 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.8, i32 0, i32 1), align 8
  %len24 = load i64, ptr @.strobj.8, align 8
  %24 = call i32 @__polaron_str_ends(ptr %data20, i64 %len22, ptr %data23, i64 %len24)
  %s25 = load ptr, ptr %s, align 8
  %str.data26 = getelementptr inbounds %String, ptr %s25, i32 0, i32 1
  %data27 = load ptr, ptr %str.data26, align 8
  %str.len28 = getelementptr inbounds %String, ptr %s25, i32 0, i32 0
  %len29 = load i64, ptr %str.len28, align 8
  %data30 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.10, i32 0, i32 1), align 8
  %len31 = load i64, ptr @.strobj.10, align 8
  %25 = call i64 @__polaron_str_index(ptr %data27, i64 %len29, ptr %data30, i64 %len31)
  %26 = trunc i64 %25 to i32
  %27 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %20, i32 %23, i32 %24, i32 %26)
  %s32 = load ptr, ptr %s, align 8
  %str.len33 = getelementptr inbounds %String, ptr %s32, i32 0, i32 0
  %len34 = load i64, ptr %str.len33, align 8
  %str.data35 = getelementptr inbounds %String, ptr %s32, i32 0, i32 1
  %data36 = load ptr, ptr %str.data35, align 8
  %28 = call ptr @__polaron_str_upper(ptr %data36, i64 %len34)
  %newstr37 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %29 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 0
  store i64 %len34, ptr %29, align 8
  %30 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 1
  store ptr %28, ptr %30, align 8
  %31 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 2
  store i64 0, ptr %31, align 8
  %strcpy38 = call ptr @__polaron_str_copy(ptr %newstr37)
  store ptr %strcpy38, ptr %up, align 8
  call void @__polaron_str_free(ptr %newstr37)
  %s39 = load ptr, ptr %s, align 8
  %str.len40 = getelementptr inbounds %String, ptr %s39, i32 0, i32 0
  %len41 = load i64, ptr %str.len40, align 8
  %str.data42 = getelementptr inbounds %String, ptr %s39, i32 0, i32 1
  %data43 = load ptr, ptr %str.data42, align 8
  %32 = call ptr @__polaron_str_lower(ptr %data43, i64 %len41)
  %newstr44 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %33 = getelementptr inbounds %String, ptr %newstr44, i32 0, i32 0
  store i64 %len41, ptr %33, align 8
  %34 = getelementptr inbounds %String, ptr %newstr44, i32 0, i32 1
  store ptr %32, ptr %34, align 8
  %35 = getelementptr inbounds %String, ptr %newstr44, i32 0, i32 2
  store i64 0, ptr %35, align 8
  %strcpy45 = call ptr @__polaron_str_copy(ptr %newstr44)
  store ptr %strcpy45, ptr %lo, align 8
  call void @__polaron_str_free(ptr %newstr44)
  %trim.len = alloca i64, align 8
  %data46 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.12, i32 0, i32 1), align 8
  %len47 = load i64, ptr @.strobj.12, align 8
  %36 = call ptr @__polaron_str_trim(ptr %data46, i64 %len47, ptr %trim.len)
  %37 = load i64, ptr %trim.len, align 8
  %newstr48 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %38 = getelementptr inbounds %String, ptr %newstr48, i32 0, i32 0
  store i64 %37, ptr %38, align 8
  %39 = getelementptr inbounds %String, ptr %newstr48, i32 0, i32 1
  store ptr %36, ptr %39, align 8
  %40 = getelementptr inbounds %String, ptr %newstr48, i32 0, i32 2
  store i64 0, ptr %40, align 8
  %strcpy49 = call ptr @__polaron_str_copy(ptr %newstr48)
  store ptr %strcpy49, ptr %tr, align 8
  call void @__polaron_str_free(ptr %newstr48)
  %rep.len = alloca i64, align 8
  %data50 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.14, i32 0, i32 1), align 8
  %len51 = load i64, ptr @.strobj.14, align 8
  %41 = call ptr @__polaron_str_repeat(ptr %data50, i64 %len51, i64 3, ptr %rep.len)
  %42 = load i64, ptr %rep.len, align 8
  %newstr52 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %43 = getelementptr inbounds %String, ptr %newstr52, i32 0, i32 0
  store i64 %42, ptr %43, align 8
  %44 = getelementptr inbounds %String, ptr %newstr52, i32 0, i32 1
  store ptr %41, ptr %44, align 8
  %45 = getelementptr inbounds %String, ptr %newstr52, i32 0, i32 2
  store i64 0, ptr %45, align 8
  %strcpy53 = call ptr @__polaron_str_copy(ptr %newstr52)
  store ptr %strcpy53, ptr %rp, align 8
  call void @__polaron_str_free(ptr %newstr52)
  %up54 = load ptr, ptr %up, align 8
  %str.data55 = getelementptr inbounds %String, ptr %up54, i32 0, i32 1
  %data56 = load ptr, ptr %str.data55, align 8
  %data57 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.17, i32 0, i32 1), align 8
  %46 = call i32 @strcmp(ptr %data56, ptr %data57)
  %47 = icmp eq i32 %46, 0
  %48 = zext i1 %47 to i32
  %lo58 = load ptr, ptr %lo, align 8
  %str.data59 = getelementptr inbounds %String, ptr %lo58, i32 0, i32 1
  %data60 = load ptr, ptr %str.data59, align 8
  %data61 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.19, i32 0, i32 1), align 8
  %49 = call i32 @strcmp(ptr %data60, ptr %data61)
  %50 = icmp eq i32 %49, 0
  %51 = zext i1 %50 to i32
  %tr62 = load ptr, ptr %tr, align 8
  %str.len63 = getelementptr inbounds %String, ptr %tr62, i32 0, i32 0
  %len64 = load i64, ptr %str.len63, align 8
  %52 = trunc i64 %len64 to i32
  %tr65 = load ptr, ptr %tr, align 8
  %str.data66 = getelementptr inbounds %String, ptr %tr65, i32 0, i32 1
  %data67 = load ptr, ptr %str.data66, align 8
  %data68 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.21, i32 0, i32 1), align 8
  %53 = call i32 @strcmp(ptr %data67, ptr %data68)
  %54 = icmp eq i32 %53, 0
  %55 = zext i1 %54 to i32
  %rp69 = load ptr, ptr %rp, align 8
  %str.len70 = getelementptr inbounds %String, ptr %rp69, i32 0, i32 0
  %len71 = load i64, ptr %str.len70, align 8
  %56 = trunc i64 %len71 to i32
  %rp72 = load ptr, ptr %rp, align 8
  %str.data73 = getelementptr inbounds %String, ptr %rp72, i32 0, i32 1
  %data74 = load ptr, ptr %str.data73, align 8
  %data75 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.23, i32 0, i32 1), align 8
  %57 = call i32 @strcmp(ptr %data74, ptr %data75)
  %58 = icmp eq i32 %57, 0
  %59 = zext i1 %58 to i32
  %60 = call i32 (ptr, ...) @printf(ptr @.str.15, i32 %48, i32 %51, i32 %52, i32 %55, i32 %56, i32 %59)
  %61 = load ptr, ptr %rp, align 8
  call void @__polaron_str_free(ptr %61)
  %62 = load ptr, ptr %tr, align 8
  call void @__polaron_str_free(ptr %62)
  %63 = load ptr, ptr %lo, align 8
  call void @__polaron_str_free(ptr %63)
  %64 = load ptr, ptr %up, align 8
  call void @__polaron_str_free(ptr %64)
  %65 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %65)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5331)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5333)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i64 @__polaron_str_index(ptr, i64, ptr, i64)

declare i32 @__polaron_str_ends(ptr, i64, ptr, i64)

declare i32 @printf(ptr, ...)

declare ptr @__polaron_str_upper(ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_lower(ptr, i64)

declare ptr @__polaron_str_trim(ptr, i64, ptr)

declare ptr @__polaron_str_repeat(ptr, i64, i64, ptr)

declare i32 @strcmp(ptr, ptr)
