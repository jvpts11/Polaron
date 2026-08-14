; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/loops.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/loops.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [14 x i8] c"for sum = %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"while total = %d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %total = alloca i32, align 4
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
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
  store i32 0, ptr %sum, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i1 = load i32, ptr %i, align 4
  %16 = icmp slt i32 %i1, 10
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i2 = load i32, ptr %i, align 4
  %18 = icmp eq i32 %i2, 5
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then, label %if.end

for.update:                                       ; preds = %if.end5, %if.then4
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %if.then, %for.cond
  %sum8 = load i32, ptr %sum, align 4
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %sum8)
  store i32 0, ptr %n, align 4
  store i32 0, ptr %total, align 4
  br label %while.cond

if.then:                                          ; preds = %for.body
  br label %for.end

if.end:                                           ; preds = %for.body
  %i3 = load i32, ptr %i, align 4
  %23 = icmp eq i32 %i3, 2
  %24 = zext i1 %23 to i32
  br i1 %23, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  br label %for.update

if.end5:                                          ; preds = %if.end
  %sum6 = load i32, ptr %sum, align 4
  %i7 = load i32, ptr %i, align 4
  %25 = add i32 %sum6, %i7
  store i32 %25, ptr %sum, align 4
  br label %for.update

while.cond:                                       ; preds = %if.end16, %if.then12, %for.end
  %n9 = load i32, ptr %n, align 4
  %26 = icmp slt i32 %n9, 100
  %27 = zext i1 %26 to i32
  br i1 %26, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n10 = load i32, ptr %n, align 4
  %28 = add i32 %n10, 1
  store i32 %28, ptr %n, align 4
  %n11 = load i32, ptr %n, align 4
  %29 = icmp eq i32 %n11, 3
  %30 = zext i1 %29 to i32
  br i1 %29, label %if.then12, label %if.end13

while.end:                                        ; preds = %if.then15, %while.cond
  %total19 = load i32, ptr %total, align 4
  %31 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %total19)
  ret i32 0

if.then12:                                        ; preds = %while.body
  br label %while.cond

if.end13:                                         ; preds = %while.body
  %n14 = load i32, ptr %n, align 4
  %32 = icmp eq i32 %n14, 6
  %33 = zext i1 %32 to i32
  br i1 %32, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.end13
  br label %while.end

if.end16:                                         ; preds = %if.end13
  %total17 = load i32, ptr %total, align 4
  %n18 = load i32, ptr %n, align 4
  %34 = add i32 %total17, %n18
  store i32 %34, ptr %total, align 4
  br label %while.cond
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

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
