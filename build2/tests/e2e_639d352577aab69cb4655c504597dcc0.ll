; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/switch_enum.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/switch_enum.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [11 x i8] c"code = %d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %code = alloca i32, align 4
  %d = alloca i32, align 4
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
  store i32 1, ptr %d, align 4
  store i32 -1, ptr %code, align 4
  %d1 = load i32, ptr %d, align 4
  %switch.is = icmp eq i32 %d1, 0
  br i1 %switch.is, label %switch.case, label %switch.test

switch.end:                                       ; preds = %switch.default, %switch.case3, %switch.case2, %switch.case
  %code8 = load i32, ptr %code, align 4
  %16 = call i32 (ptr, ...) @printf(ptr @.str, i32 %code8)
  ret i32 0

switch.case:                                      ; preds = %argv.end
  store i32 0, ptr %code, align 4
  br label %switch.end

switch.case2:                                     ; preds = %switch.test
  store i32 1, ptr %code, align 4
  br label %switch.end

switch.case3:                                     ; preds = %switch.test5
  store i32 2, ptr %code, align 4
  br label %switch.end

switch.default:                                   ; preds = %switch.test7
  store i32 9, ptr %code, align 4
  br label %switch.end

switch.test:                                      ; preds = %argv.end
  %switch.is4 = icmp eq i32 %d1, 1
  br i1 %switch.is4, label %switch.case2, label %switch.test5

switch.test5:                                     ; preds = %switch.test
  %switch.is6 = icmp eq i32 %d1, 2
  br i1 %switch.is6, label %switch.case3, label %switch.test7

switch.test7:                                     ; preds = %switch.test5
  br label %switch.default
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
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
