; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/closures.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/closures.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_2, ptr null]
@.str = private unnamed_addr constant [28 x i8] c"add5=%d dbl=%d composed=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define internal ptr @Fns.makeAdder(i32 %0) {
entry:
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %env = call ptr @__polaron_malloc(i64 8)
  %1 = getelementptr ptr, ptr %env, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %2 = load i32, ptr %n, align 4
  store i32 %2, ptr %cap, align 4
  store ptr %cap, ptr %1, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_0, ptr %closure, align 8
  %3 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env, ptr %3, align 8
  ret ptr %closure
}

define internal ptr @Fns.compose(ptr %0, ptr %1) {
entry:
  %g = alloca ptr, align 8
  %f = alloca ptr, align 8
  store ptr %0, ptr %f, align 8
  store ptr %1, ptr %g, align 8
  %env = call ptr @__polaron_malloc(i64 16)
  %2 = getelementptr ptr, ptr %env, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %3 = load ptr, ptr %f, align 8
  store ptr %3, ptr %cap, align 8
  store ptr %cap, ptr %2, align 8
  %4 = getelementptr ptr, ptr %env, i32 1
  %cap1 = call ptr @__polaron_malloc(i64 8)
  %5 = load ptr, ptr %g, align 8
  store ptr %5, ptr %cap1, align 8
  store ptr %cap1, ptr %4, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_1, ptr %closure, align 8
  %6 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env, ptr %6, align 8
  ret ptr %closure
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %add5thenDbl = alloca ptr, align 8
  %dbl = alloca ptr, align 8
  %add5 = alloca ptr, align 8
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
  %16 = call ptr @Fns.makeAdder(i32 5)
  store ptr %16, ptr %add5, align 8
  store ptr @__polaron_closure, ptr %dbl, align 8
  %dbl1 = load ptr, ptr %dbl, align 8
  %add52 = load ptr, ptr %add5, align 8
  %17 = call ptr @Fns.compose(ptr %dbl1, ptr %add52)
  store ptr %17, ptr %add5thenDbl, align 8
  %add53 = load ptr, ptr %add5, align 8
  %code = load ptr, ptr %add53, align 8
  %18 = getelementptr ptr, ptr %add53, i32 1
  %env = load ptr, ptr %18, align 8
  %19 = call i32 %code(ptr %env, i32 10)
  %dbl4 = load ptr, ptr %dbl, align 8
  %code5 = load ptr, ptr %dbl4, align 8
  %20 = getelementptr ptr, ptr %dbl4, i32 1
  %env6 = load ptr, ptr %20, align 8
  %21 = call i32 %code5(ptr %env6, i32 10)
  %add5thenDbl7 = load ptr, ptr %add5thenDbl, align 8
  %code8 = load ptr, ptr %add5thenDbl7, align 8
  %22 = getelementptr ptr, ptr %add5thenDbl7, i32 1
  %env9 = load ptr, ptr %22, align 8
  %23 = call i32 %code8(ptr %env9, i32 10)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %19, i32 %21, i32 %23)
  ret i32 0
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

define internal i32 @__polaron_lambda_0(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %2 = getelementptr ptr, ptr %0, i32 0
  %n = load ptr, ptr %2, align 8
  %x1 = load i32, ptr %x, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = add i32 %x1, %n2
  ret i32 %3
}

declare noalias ptr @__polaron_malloc(i64)

define internal i32 @__polaron_lambda_1(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %2 = getelementptr ptr, ptr %0, i32 0
  %f = load ptr, ptr %2, align 8
  %3 = getelementptr ptr, ptr %0, i32 1
  %g = load ptr, ptr %3, align 8
  %f1 = load ptr, ptr %f, align 8
  %code = load ptr, ptr %f1, align 8
  %4 = getelementptr ptr, ptr %f1, i32 1
  %env = load ptr, ptr %4, align 8
  %g2 = load ptr, ptr %g, align 8
  %code3 = load ptr, ptr %g2, align 8
  %5 = getelementptr ptr, ptr %g2, i32 1
  %env4 = load ptr, ptr %5, align 8
  %x5 = load i32, ptr %x, align 4
  %6 = call i32 %code3(ptr %env4, i32 %x5)
  %7 = call i32 %code(ptr %env, i32 %6)
  ret i32 %7
}

declare i64 @strlen(ptr)

define internal i32 @__polaron_lambda_2(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %2 = mul i32 %x1, 2
  ret i32 %2
}

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
