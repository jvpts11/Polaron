; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bytes_literal.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bytes_literal.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.bytes = private constant [11 x i8] c"/HELLO.ELF\00"
@.str = private unnamed_addr constant [34 x i8] c"len=%d first=%d last=%d ident=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal i32 @Main.len(ptr %0) {
entry:
  %n = alloca i32, align 4
  %p = alloca ptr, align 8
  store ptr %0, ptr %p, align 8
  store i32 0, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %p1 = load ptr, ptr %p, align 8
  %n2 = load i32, ptr %n, align 4
  %1 = sext i32 %n2 to i64
  %ptr.elem = getelementptr i8, ptr %p1, i64 %1
  %elem = load i8, ptr %ptr.elem, align 1
  %2 = icmp ne i8 %elem, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n3 = load i32, ptr %n, align 4
  %4 = add i32 %n3, 1
  store i32 %4, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n4 = load i32, ptr %n, align 4
  ret i32 %n4
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca i32, align 4
  %path = alloca ptr, align 8
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
  store ptr @.bytes, ptr %path, align 8
  store i32 5, ptr %b, align 4
  %path1 = load ptr, ptr %path, align 8
  %16 = call i32 @Main.len(ptr %path1)
  %path2 = load ptr, ptr %path, align 8
  %ptr.elem = getelementptr i8, ptr %path2, i64 0
  %elem = load i8, ptr %ptr.elem, align 1
  %17 = sext i8 %elem to i32
  %path3 = load ptr, ptr %path, align 8
  %ptr.elem4 = getelementptr i8, ptr %path3, i64 9
  %elem5 = load i8, ptr %ptr.elem4, align 1
  %18 = sext i8 %elem5 to i32
  %b6 = load i32, ptr %b, align 4
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %b6)
  ret i32 0
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
