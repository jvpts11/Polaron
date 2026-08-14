; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/low_level_memory.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/low_level_memory.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"read=%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"addr=%d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %back = alloca i64, align 8
  %p = alloca ptr, align 8
  %mem = alloca i64, align 8
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
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %16 = ptrtoint ptr %mem.alloc to i64
  store i64 %16, ptr %mem, align 8
  %mem1 = load i64, ptr %mem, align 8
  %17 = inttoptr i64 %mem1 to ptr
  store ptr %17, ptr %p, align 8
  %p2 = load ptr, ptr %p, align 8
  %ptr.elem = getelementptr i32, ptr %p2, i64 0
  store i32 100, ptr %ptr.elem, align 1
  %p3 = load ptr, ptr %p, align 8
  %ptr.elem4 = getelementptr i32, ptr %p3, i64 1
  store i32 200, ptr %ptr.elem4, align 1
  %p5 = load ptr, ptr %p, align 8
  %ptr.elem6 = getelementptr i32, ptr %p5, i64 0
  %elem = load i32, ptr %ptr.elem6, align 1
  %p7 = load ptr, ptr %p, align 8
  %ptr.elem8 = getelementptr i32, ptr %p7, i64 1
  %elem9 = load i32, ptr %ptr.elem8, align 1
  %18 = add i32 %elem, %elem9
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %18)
  %mem10 = load i64, ptr %mem, align 8
  %20 = inttoptr i64 %mem10 to ptr
  store i32 999, ptr %20, align 4
  %mem11 = load i64, ptr %mem, align 8
  %21 = inttoptr i64 %mem11 to ptr
  %mem.read = load i32, ptr %21, align 4
  %22 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %mem.read)
  %p12 = load ptr, ptr %p, align 8
  %23 = ptrtoint ptr %p12 to i64
  store i64 %23, ptr %back, align 8
  %back13 = load i64, ptr %back, align 8
  %mem14 = load i64, ptr %mem, align 8
  %24 = sub i64 %back13, %mem14
  %25 = trunc i64 %24 to i32
  %26 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %25)
  %mem15 = load i64, ptr %mem, align 8
  %27 = inttoptr i64 %mem15 to ptr
  call void @__polaron_free(ptr %27)
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

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
