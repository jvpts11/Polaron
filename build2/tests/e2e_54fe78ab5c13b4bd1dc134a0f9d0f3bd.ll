; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_multi_dispatch.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_multi_dispatch.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [13 x i8] c"w1=%d w2=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %cat.res5 = alloca i32, align 4
  %cat.res = alloca i32, align 4
  %t2 = alloca i64, align 8
  %t1 = alloca i64, align 8
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
  store i64 0, ptr %t1, align 8
  store i64 4294967296, ptr %t2, align 8
  %t11 = load i64, ptr %t1, align 8
  %cat.ord = trunc i64 %t11 to i32
  %16 = lshr i64 %t11, 32
  %cat.id = trunc i64 %16 to i32
  store i32 0, ptr %cat.res, align 4
  switch i32 %cat.id, label %cat.default [
    i32 0, label %cat.AppLevel
    i32 1, label %cat.SysLevel
  ]

cat.cont:                                         ; preds = %cat.default, %cat.SysLevel, %cat.AppLevel
  %cat.result = load i32, ptr %cat.res, align 4
  %t22 = load i64, ptr %t2, align 8
  %cat.ord3 = trunc i64 %t22 to i32
  %17 = lshr i64 %t22, 32
  %cat.id4 = trunc i64 %17 to i32
  store i32 0, ptr %cat.res5, align 4
  switch i32 %cat.id4, label %cat.default7 [
    i32 0, label %cat.AppLevel8
    i32 1, label %cat.SysLevel9
  ]

cat.default:                                      ; preds = %argv.end
  br label %cat.cont

cat.AppLevel:                                     ; preds = %argv.end
  %18 = call i32 @AppLevel.weight(i32 %cat.ord)
  store i32 %18, ptr %cat.res, align 4
  br label %cat.cont

cat.SysLevel:                                     ; preds = %argv.end
  %19 = call i32 @SysLevel.weight(i32 %cat.ord)
  store i32 %19, ptr %cat.res, align 4
  br label %cat.cont

cat.cont6:                                        ; preds = %cat.default7, %cat.SysLevel9, %cat.AppLevel8
  %cat.result10 = load i32, ptr %cat.res5, align 4
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %cat.result, i32 %cat.result10)
  ret i32 0

cat.default7:                                     ; preds = %cat.cont
  br label %cat.cont6

cat.AppLevel8:                                    ; preds = %cat.cont
  %21 = call i32 @AppLevel.weight(i32 %cat.ord3)
  store i32 %21, ptr %cat.res5, align 4
  br label %cat.cont6

cat.SysLevel9:                                    ; preds = %cat.cont
  %22 = call i32 @SysLevel.weight(i32 %cat.ord3)
  store i32 %22, ptr %cat.res5, align 4
  br label %cat.cont6
}

define internal i32 @AppLevel.weight(i32 %0) {
entry:
  ret i32 7
}

define internal i32 @SysLevel.weight(i32 %0) {
entry:
  ret i32 42
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
