; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/lambda_hof.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/lambda_hof.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_1, ptr null]
@__polaron_closure.1 = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_0, ptr null]
@.str = private unnamed_addr constant [6 x i8] c"d=%d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %dbl = alloca ptr, align 8
  %makeDoubler = alloca ptr, align 8
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
  store ptr @__polaron_closure.1, ptr %makeDoubler, align 8
  %makeDoubler1 = load ptr, ptr %makeDoubler, align 8
  %code = load ptr, ptr %makeDoubler1, align 8
  %16 = getelementptr ptr, ptr %makeDoubler1, i32 1
  %env = load ptr, ptr %16, align 8
  %17 = call ptr %code(ptr %env)
  store ptr %17, ptr %dbl, align 8
  %dbl2 = load ptr, ptr %dbl, align 8
  %code3 = load ptr, ptr %dbl2, align 8
  %18 = getelementptr ptr, ptr %dbl2, i32 1
  %env4 = load ptr, ptr %18, align 8
  %19 = call i32 %code3(ptr %env4, i32 21)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %19)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal ptr @__polaron_lambda_0(ptr %0) {
entry:
  ret ptr @__polaron_closure
}

define internal i32 @__polaron_lambda_1(ptr %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %2 = mul i32 %n1, 2
  ret i32 %2
}

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
