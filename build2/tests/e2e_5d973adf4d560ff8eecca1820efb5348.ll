; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/unions.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/unions.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Value = type { i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [11 x i8] c"bits = %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"back = %g\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define internal void @Value.Value(ptr %0) {
entry:
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %v = alloca ptr, align 8
  %Value.obj = alloca %class.Value, align 8
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
  %16 = call ptr @memset(ptr %Value.obj, i32 0, i64 ptrtoint (ptr getelementptr (%class.Value, ptr null, i64 1) to i64))
  call void @Value.Value(ptr %Value.obj)
  store ptr %Value.obj, ptr %v, align 8
  %v1 = load ptr, ptr %v, align 8
  %asFloat = getelementptr inbounds %class.Value, ptr %v1, i32 0, i32 0
  store float 1.500000e+00, ptr %asFloat, align 4
  %v2 = load ptr, ptr %v, align 8
  %asInt = getelementptr inbounds %class.Value, ptr %v2, i32 0, i32 0
  %asInt3 = load i32, ptr %asInt, align 4
  %17 = call i32 (ptr, ...) @printf(ptr @.str, i32 %asInt3)
  %v4 = load ptr, ptr %v, align 8
  %asInt5 = getelementptr inbounds %class.Value, ptr %v4, i32 0, i32 0
  store i32 1069547520, ptr %asInt5, align 4
  %v6 = load ptr, ptr %v, align 8
  %asFloat7 = getelementptr inbounds %class.Value, ptr %v6, i32 0, i32 0
  %asFloat8 = load float, ptr %asFloat7, align 4
  %18 = fpext float %asFloat8 to double
  %19 = call i32 (ptr, ...) @printf(ptr @.str.1, double %18)
  ret i32 0
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

declare ptr @memset(ptr, i32, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
