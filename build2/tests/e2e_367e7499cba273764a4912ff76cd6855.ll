; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_equality.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_equality.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [6 x i8] c"r=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %r = alloca i32, align 4
  %c = alloca ptr, align 8
  %b = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 12)
  store ptr %arr, ptr %a, align 8
  %arr2 = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr2, align 8
  %arr.data3 = getelementptr i8, ptr %arr2, i64 8
  %17 = call ptr @memset(ptr %arr.data3, i32 0, i64 12)
  store ptr %arr2, ptr %b, align 8
  %a4 = load ptr, ptr %a, align 8
  store ptr %a4, ptr %c, align 8
  store i32 0, ptr %r, align 4
  %a5 = load ptr, ptr %a, align 8
  %a6 = load ptr, ptr %a, align 8
  %18 = icmp eq ptr %a5, %a6
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  %r7 = load i32, ptr %r, align 4
  %20 = add i32 %r7, 1
  store i32 %20, ptr %r, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %argv.end
  %a8 = load ptr, ptr %a, align 8
  %c9 = load ptr, ptr %c, align 8
  %21 = icmp eq ptr %a8, %c9
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then10, label %if.end11

if.then10:                                        ; preds = %if.end
  %r12 = load i32, ptr %r, align 4
  %23 = add i32 %r12, 10
  store i32 %23, ptr %r, align 4
  br label %if.end11

if.end11:                                         ; preds = %if.then10, %if.end
  %a13 = load ptr, ptr %a, align 8
  %b14 = load ptr, ptr %b, align 8
  %24 = icmp eq ptr %a13, %b14
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.end11
  %r17 = load i32, ptr %r, align 4
  %26 = add i32 %r17, 100
  store i32 %26, ptr %r, align 4
  br label %if.end16

if.end16:                                         ; preds = %if.then15, %if.end11
  %a18 = load ptr, ptr %a, align 8
  %b19 = load ptr, ptr %b, align 8
  %27 = icmp ne ptr %a18, %b19
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then20, label %if.end21

if.then20:                                        ; preds = %if.end16
  %r22 = load i32, ptr %r, align 4
  %29 = add i32 %r22, 1000
  store i32 %29, ptr %r, align 4
  br label %if.end21

if.end21:                                         ; preds = %if.then20, %if.end16
  %r23 = load i32, ptr %r, align 4
  %30 = call i32 (ptr, ...) @printf(ptr @.str, i32 %r23)
  %a24 = load ptr, ptr %a, align 8
  call void @__polaron_free(ptr %a24)
  %b25 = load ptr, ptr %b, align 8
  call void @__polaron_free(ptr %b25)
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

declare ptr @memset(ptr, i32, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
