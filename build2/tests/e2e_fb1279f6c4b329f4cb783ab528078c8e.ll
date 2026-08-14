; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ffi_struct.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ffi_struct.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Point = type { i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [18 x i8] c"s=%d qx=%d qy=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Point.Point(ptr %0, i32 %1, i32 %2) {
entry:
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 %2, ptr %y, align 4
  %x1 = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x2 = load i32, ptr %x, align 4
  store i32 %x2, ptr %x1, align 4, !tbaa !0
  %y3 = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y4 = load i32, ptr %y, align 4
  store i32 %y4, ptr %y3, align 4, !tbaa !0
  ret void
}

declare i32 @polaron_point_sum(i64)

declare i64 @polaron_point_scale(i64, i32)

define i32 @main(i32 %0, ptr %1) {
entry:
  %q = alloca ptr, align 8
  %s = alloca i32, align 4
  %p = alloca ptr, align 8
  %Point.obj = alloca %class.Point, align 8
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
  call void @Point.Point(ptr %Point.obj, i32 3, i32 4)
  store ptr %Point.obj, ptr %p, align 8
  %p1 = load ptr, ptr %p, align 8
  %ffi.byval = load i64, ptr %p1, align 8
  %16 = call i32 @polaron_point_sum(i64 %ffi.byval)
  store i32 %16, ptr %s, align 4
  %p2 = load ptr, ptr %p, align 8
  %ffi.byval3 = load i64, ptr %p2, align 8
  %17 = call i64 @polaron_point_scale(i64 %ffi.byval3, i32 10)
  %ffi.ret = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store i64 %17, ptr %ffi.ret, align 8
  store ptr %ffi.ret, ptr %q, align 8
  %s4 = load i32, ptr %s, align 4
  %q5 = load ptr, ptr %q, align 8
  %x = getelementptr inbounds %class.Point, ptr %q5, i32 0, i32 0
  %x6 = load i32, ptr %x, align 4, !tbaa !0
  %q7 = load ptr, ptr %q, align 8
  %y = getelementptr inbounds %class.Point, ptr %q7, i32 0, i32 1
  %y8 = load i32, ptr %y, align 4, !tbaa !0
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 %s4, i32 %x6, i32 %y8)
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

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
