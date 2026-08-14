; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/out_of_memory_bad.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/out_of_memory_bad.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [65 x i8] c"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef\00"
@.strobj = private global %String { i64 64, ptr @.strdata, i64 0 }
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %huge = alloca ptr, align 8
  %seed = alloca ptr, align 8
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
  store ptr %strcpy, ptr %seed, align 8
  %seed1 = load ptr, ptr %seed, align 8
  %rep.len = alloca i64, align 8
  %str.data = getelementptr inbounds %String, ptr %seed1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %seed1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %16 = call ptr @__polaron_str_repeat(ptr %data, i64 %len, i64 2000000000, ptr %rep.len)
  %17 = load i64, ptr %rep.len, align 8
  %newstr2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %18 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 0
  store i64 %17, ptr %18, align 8
  %19 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 1
  store ptr %16, ptr %19, align 8
  %20 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 2
  store i64 0, ptr %20, align 8
  %strcpy3 = call ptr @__polaron_str_copy(ptr %newstr2)
  store ptr %strcpy3, ptr %huge, align 8
  call void @__polaron_str_free(ptr %newstr2)
  %huge4 = load ptr, ptr %huge, align 8
  %str.len5 = getelementptr inbounds %String, ptr %huge4, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %21 = trunc i64 %len6 to i32
  %22 = load ptr, ptr %huge, align 8
  call void @__polaron_str_free(ptr %22)
  %23 = load ptr, ptr %seed, align 8
  call void @__polaron_str_free(ptr %23)
  ret i32 %21
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5307)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare ptr @__polaron_str_repeat(ptr, i64, i64, ptr)

declare void @__polaron_str_free(ptr)
