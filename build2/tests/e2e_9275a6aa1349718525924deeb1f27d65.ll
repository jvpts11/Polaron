; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/switch.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/switch.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"zero \00", align 1
@.str.2 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"one \00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"two \00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c"other \00", align 1
@.str.8 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.9 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %x = alloca i32, align 4
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
  store i32 0, ptr %x, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %x1 = load i32, ptr %x, align 4
  %16 = icmp slt i32 %x1, 4
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %x2 = load i32, ptr %x, align 4
  %switch.is = icmp eq i32 %x2, 0
  br i1 %switch.is, label %switch.case, label %switch.test

for.update:                                       ; preds = %switch.end
  %18 = load i32, ptr %x, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %x, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %20 = call i32 (ptr, ...) @printf(ptr @.str.8, ptr @.str.9)
  ret i32 0

switch.end:                                       ; preds = %switch.default, %switch.case4, %switch.case3
  br label %for.update

switch.case:                                      ; preds = %for.body
  %21 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.1)
  br label %switch.case3

switch.case3:                                     ; preds = %switch.case, %switch.test
  %22 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr @.str.3)
  br label %switch.end

switch.case4:                                     ; preds = %switch.test6
  %23 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr @.str.5)
  br label %switch.end

switch.default:                                   ; preds = %switch.test8
  %24 = call i32 (ptr, ...) @printf(ptr @.str.6, ptr @.str.7)
  br label %switch.end

switch.test:                                      ; preds = %for.body
  %switch.is5 = icmp eq i32 %x2, 1
  br i1 %switch.is5, label %switch.case3, label %switch.test6

switch.test6:                                     ; preds = %switch.test
  %switch.is7 = icmp eq i32 %x2, 2
  br i1 %switch.is7, label %switch.case4, label %switch.test8

switch.test8:                                     ; preds = %switch.test6
  br label %switch.default
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5315)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5317)
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
