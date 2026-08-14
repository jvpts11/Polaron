; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_semicolon_methods.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_semicolon_methods.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [11 x i8] c"a=%s b=%s\0A\00", align 1
@.strdata = private constant [6 x i8] c"angry\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.strdata.1296 = private constant [5 x i8] c"calm\00"
@.strobj.1297 = private global %String { i64 4, ptr @.strdata.1296, i64 0 }
@.strdata.1298 = private constant [5 x i8] c"high\00"
@.strobj.1299 = private global %String { i64 4, ptr @.strdata.1298, i64 0 }
@.strdata.1300 = private constant [4 x i8] c"low\00"
@.strobj.1301 = private global %String { i64 3, ptr @.strdata.1300, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }

define internal ptr @Main.describe(i64 %0) {
entry:
  %cat.res = alloca ptr, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %n1 = load i64, ptr %n, align 8
  %cat.ord = trunc i64 %n1 to i32
  %1 = lshr i64 %n1, 32
  %cat.id = trunc i64 %1 to i32
  store ptr null, ptr %cat.res, align 8
  switch i32 %cat.id, label %cat.default [
    i32 0, label %cat.Mood
    i32 1, label %cat.Rank
  ]

cat.cont:                                         ; preds = %cat.default, %cat.Rank, %cat.Mood
  %cat.result = load ptr, ptr %cat.res, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %cat.result)
  call void @__polaron_str_free(ptr %cat.result)
  ret ptr %strcpy

cat.default:                                      ; preds = %entry
  br label %cat.cont

cat.Mood:                                         ; preds = %entry
  %2 = call ptr @Mood.label(i32 %cat.ord)
  store ptr %2, ptr %cat.res, align 8
  br label %cat.cont

cat.Rank:                                         ; preds = %entry
  %3 = call ptr @Rank.label(i32 %cat.ord)
  store ptr %3, ptr %cat.res, align 8
  br label %cat.cont
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca i64, align 8
  %a = alloca i64, align 8
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
  store i64 1, ptr %a, align 8
  store i64 4294967297, ptr %b, align 8
  %a1 = load i64, ptr %a, align 8
  %16 = call ptr @Main.describe(i64 %a1)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %b2 = load i64, ptr %b, align 8
  %17 = call ptr @Main.describe(i64 %b2)
  %str.data3 = getelementptr inbounds %String, ptr %17, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %18 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, ptr %data4)
  call void @__polaron_str_free(ptr %16)
  call void @__polaron_str_free(ptr %17)
  ret i32 0
}

define internal ptr @Mood.label(i32 %0) {
entry:
  %1 = icmp eq i32 %0, 1
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.1297)
  ret ptr %strcpy1
}

define internal ptr @Rank.label(i32 %0) {
entry:
  %1 = icmp eq i32 %0, 1
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1299)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.1301)
  ret ptr %strcpy1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)
