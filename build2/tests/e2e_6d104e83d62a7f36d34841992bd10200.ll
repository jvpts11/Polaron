; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/records.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/records.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Point = type { i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [10 x i8] c"sum = %d\0A\00", align 1
@.str.5 = private unnamed_addr constant [17 x i8] c"p==q %d p==r %d\0A\00", align 1
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }

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

define internal i32 @Point.equals(ptr nonnull align 4 dereferenceable(8) %0, ptr %1) {
entry:
  %Point.copy = alloca %class.Point, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %other, align 8
  %x = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x1 = load i32, ptr %x, align 4, !tbaa !0
  %other2 = load ptr, ptr %other, align 8
  %x3 = getelementptr inbounds %class.Point, ptr %other2, i32 0, i32 0
  %x4 = load i32, ptr %x3, align 4, !tbaa !0
  %3 = icmp eq i32 %x1, %x4
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %y = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y5 = load i32, ptr %y, align 4, !tbaa !0
  %other6 = load ptr, ptr %other, align 8
  %y7 = getelementptr inbounds %class.Point, ptr %other6, i32 0, i32 1
  %y8 = load i32, ptr %y7, align 4, !tbaa !0
  %5 = icmp eq i32 %y5, %y8
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  ret i32 %7
}

define internal i32 @Point.sum(ptr nonnull align 4 dereferenceable(8) %0) {
entry:
  %x = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x1 = load i32, ptr %x, align 4, !tbaa !0
  %y = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y2 = load i32, ptr %y, align 4, !tbaa !0
  %1 = add i32 %x1, %y2
  ret i32 %1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %r = alloca ptr, align 8
  %Point.obj2 = alloca %class.Point, align 8
  %q = alloca ptr, align 8
  %Point.obj1 = alloca %class.Point, align 8
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
  call void @Point.Point(ptr %Point.obj1, i32 3, i32 4)
  store ptr %Point.obj1, ptr %q, align 8
  call void @Point.Point(ptr %Point.obj2, i32 5, i32 6)
  store ptr %Point.obj2, ptr %r, align 8
  %p3 = load ptr, ptr %p, align 8
  %16 = call i32 @Point.sum(ptr %p3)
  %17 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16)
  %p4 = load ptr, ptr %p, align 8
  %q5 = load ptr, ptr %q, align 8
  %18 = call i32 @Point.equals(ptr %p4, ptr %q5)
  %p6 = load ptr, ptr %p, align 8
  %r7 = load ptr, ptr %r, align 8
  %19 = call i32 @Point.equals(ptr %p6, ptr %r7)
  %20 = call i32 (ptr, ...) @printf(ptr @.str.5, i32 %18, i32 %19)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5315)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @memcpy(ptr, ptr, i64)

declare noalias ptr @__polaron_malloc(i64)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
