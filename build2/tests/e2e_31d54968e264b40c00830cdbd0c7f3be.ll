; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/switch_string.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/switch_string.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [3 x i8] c"hi\00"
@.strobj = private global %String { i64 2, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [6 x i8] c"hello\00"
@.strobj.2 = private global %String { i64 5, ptr @.strdata.1, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"HI\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"HELLO\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.7 = private unnamed_addr constant [8 x i8] c"DEFAULT\00", align 1
@.strdata.8 = private constant [3 x i8] c"he\00"
@.strobj.9 = private global %String { i64 2, ptr @.strdata.8, i64 0 }
@.strdata.10 = private constant [4 x i8] c"llo\00"
@.strobj.11 = private global %String { i64 3, ptr @.strdata.10, i64 0 }
@.str.12 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.13 = private unnamed_addr constant [4 x i8] c"one\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"two\00", align 1
@.str.16 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.17 = private unnamed_addr constant [5 x i8] c"many\00", align 1
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }
@.strdata.5326 = private constant [1 x i8] zeroinitializer
@.strobj.5327 = private global %String { i64 0, ptr @.strdata.5326, i64 0 }

define internal void @Main.classify(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.data = getelementptr inbounds %String, ptr %s1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %data3 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %1 = call i32 @strcmp(ptr %data, ptr %data3)
  %switch.streq = icmp eq i32 %1, 0
  br i1 %switch.streq, label %switch.case, label %switch.test

switch.end:                                       ; preds = %switch.default, %switch.case2, %switch.case
  ret void

switch.case:                                      ; preds = %entry
  %2 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.3)
  br label %switch.end

switch.case2:                                     ; preds = %switch.test
  %3 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr @.str.5)
  br label %switch.end

switch.default:                                   ; preds = %switch.test8
  %4 = call i32 (ptr, ...) @printf(ptr @.str.6, ptr @.str.7)
  br label %switch.end

switch.test:                                      ; preds = %entry
  %str.data4 = getelementptr inbounds %String, ptr %s1, i32 0, i32 1
  %data5 = load ptr, ptr %str.data4, align 8
  %data6 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %5 = call i32 @strcmp(ptr %data5, ptr %data6)
  %switch.streq7 = icmp eq i32 %5, 0
  br i1 %switch.streq7, label %switch.case2, label %switch.test8

switch.test8:                                     ; preds = %switch.test
  br label %switch.default
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %n = alloca i32, align 4
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
  %len = load i64, ptr @.strobj.9, align 8
  %len1 = load i64, ptr @.strobj.11, align 8
  %16 = add i64 %len, %len1
  %17 = add i64 %16, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %17)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.9, i32 0, i32 1), align 8
  %18 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.11, i32 0, i32 1), align 8
  %19 = getelementptr i8, ptr %cat.buf, i64 %len
  %20 = call ptr @memcpy(ptr %19, ptr %data2, i64 %len1)
  %21 = getelementptr i8, ptr %cat.buf, i64 %16
  store i8 0, ptr %21, align 1
  %newstr3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %22 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 0
  store i64 %16, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 1
  store ptr %cat.buf, ptr %23, align 8
  %24 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 2
  store i64 0, ptr %24, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr3)
  store ptr %strcpy, ptr %a, align 8
  call void @__polaron_str_free(ptr %newstr3)
  %a4 = load ptr, ptr %a, align 8
  call void @Main.classify(ptr %a4)
  store i32 2, ptr %n, align 4
  %n5 = load i32, ptr %n, align 4
  %switch.is = icmp eq i32 %n5, 1
  br i1 %switch.is, label %switch.case, label %switch.test

switch.end:                                       ; preds = %switch.default, %switch.case6, %switch.case
  %25 = load ptr, ptr %a, align 8
  call void @__polaron_str_free(ptr %25)
  ret i32 0

switch.case:                                      ; preds = %argv.end
  %26 = call i32 (ptr, ...) @printf(ptr @.str.12, ptr @.str.13)
  br label %switch.end

switch.case6:                                     ; preds = %switch.test
  %27 = call i32 (ptr, ...) @printf(ptr @.str.14, ptr @.str.15)
  br label %switch.end

switch.default:                                   ; preds = %switch.test8
  %28 = call i32 (ptr, ...) @printf(ptr @.str.16, ptr @.str.17)
  br label %switch.end

switch.test:                                      ; preds = %argv.end
  %switch.is7 = icmp eq i32 %n5, 2
  br i1 %switch.is7, label %switch.case6, label %switch.test8

switch.test8:                                     ; preds = %switch.test
  br label %switch.default
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

declare i32 @strcmp(ptr, ptr)

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)
