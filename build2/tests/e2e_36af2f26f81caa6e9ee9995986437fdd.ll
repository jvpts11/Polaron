; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/labeled.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/labeled.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [12 x i8] c"found = %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"sum = %d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  %sum = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %found = alloca i32, align 4
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
  store i32 0, ptr %found, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i1 = load i32, ptr %i, align 4
  %16 = icmp slt i32 %i1, 5
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond2

for.update:                                       ; preds = %for.end5
  %18 = load i32, ptr %i, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %if.then, %for.cond
  %found11 = load i32, ptr %found, align 4
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %found11)
  store i32 0, ptr %sum, align 4
  store i32 0, ptr %r, align 4
  br label %for.cond12

for.cond2:                                        ; preds = %for.update4, %for.body
  %j6 = load i32, ptr %j, align 4
  %21 = icmp slt i32 %j6, 5
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body3, label %for.end5

for.body3:                                        ; preds = %for.cond2
  %i7 = load i32, ptr %i, align 4
  %j8 = load i32, ptr %j, align 4
  %23 = mul i32 %i7, %j8
  %24 = icmp eq i32 %23, 6
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then, label %if.end

for.update4:                                      ; preds = %if.end
  %26 = load i32, ptr %j, align 4
  %27 = add i32 %26, 1
  store i32 %27, ptr %j, align 4
  br label %for.cond2

for.end5:                                         ; preds = %for.cond2
  br label %for.update

if.then:                                          ; preds = %for.body3
  %i9 = load i32, ptr %i, align 4
  %28 = mul i32 %i9, 10
  %j10 = load i32, ptr %j, align 4
  %29 = add i32 %28, %j10
  store i32 %29, ptr %found, align 4
  br label %for.end

if.end:                                           ; preds = %for.body3
  br label %for.update4

for.cond12:                                       ; preds = %for.update14, %for.end
  %r16 = load i32, ptr %r, align 4
  %30 = icmp slt i32 %r16, 3
  %31 = zext i1 %30 to i32
  br i1 %30, label %for.body13, label %for.end15

for.body13:                                       ; preds = %for.cond12
  store i32 0, ptr %c, align 4
  br label %for.cond17

for.update14:                                     ; preds = %for.end20, %if.then23
  %32 = load i32, ptr %r, align 4
  %33 = add i32 %32, 1
  store i32 %33, ptr %r, align 4
  br label %for.cond12

for.end15:                                        ; preds = %for.cond12
  %sum26 = load i32, ptr %sum, align 4
  %34 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %sum26)
  ret i32 0

for.cond17:                                       ; preds = %for.update19, %for.body13
  %c21 = load i32, ptr %c, align 4
  %35 = icmp slt i32 %c21, 3
  %36 = zext i1 %35 to i32
  br i1 %35, label %for.body18, label %for.end20

for.body18:                                       ; preds = %for.cond17
  %c22 = load i32, ptr %c, align 4
  %37 = icmp eq i32 %c22, 1
  %38 = zext i1 %37 to i32
  br i1 %37, label %if.then23, label %if.end24

for.update19:                                     ; preds = %if.end24
  %39 = load i32, ptr %c, align 4
  %40 = add i32 %39, 1
  store i32 %40, ptr %c, align 4
  br label %for.cond17

for.end20:                                        ; preds = %for.cond17
  br label %for.update14

if.then23:                                        ; preds = %for.body18
  br label %for.update14

if.end24:                                         ; preds = %for.body18
  %sum25 = load i32, ptr %sum, align 4
  %41 = add i32 %sum25, 1
  store i32 %41, ptr %sum, align 4
  br label %for.update19
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
