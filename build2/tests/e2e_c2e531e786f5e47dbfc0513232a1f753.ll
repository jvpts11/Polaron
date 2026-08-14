; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/record_tostring.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/record_tostring.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Point = type { i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [7 x i8] c"Point(\00"
@.strobj = private global %String { i64 6, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [3 x i8] c", \00"
@.strobj.2 = private global %String { i64 2, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c")\00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }

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

define internal ptr @Point.toString(ptr nonnull align 4 dereferenceable(8) %0) {
entry:
  %x = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x1 = load i32, ptr %x, align 4, !tbaa !0
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %1 = sext i32 %x1 to i64
  %2 = call i64 @__polaron_itoa(i64 %1, ptr %itoa.buf)
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %2, ptr %3, align 8
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %itoa.buf, ptr %4, align 8
  %5 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %5, align 8
  %len = load i64, ptr @.strobj, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  %len2 = load i64, ptr %str.len, align 8
  %6 = add i64 %len, %len2
  %7 = add i64 %6, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %7)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %8 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  %data3 = load ptr, ptr %str.data, align 8
  %9 = getelementptr i8, ptr %cat.buf, i64 %len
  %10 = call ptr @memcpy(ptr %9, ptr %data3, i64 %len2)
  %11 = getelementptr i8, ptr %cat.buf, i64 %6
  store i8 0, ptr %11, align 1
  %newstr4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %12 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %6, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %cat.buf, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %14, align 8
  %str.len5 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %len7 = load i64, ptr @.strobj.2, align 8
  %15 = add i64 %len6, %len7
  %16 = add i64 %15, 1
  %cat.buf8 = call ptr @__polaron_malloc(i64 %16)
  %str.data9 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %17 = call ptr @memcpy(ptr %cat.buf8, ptr %data10, i64 %len6)
  %data11 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %18 = getelementptr i8, ptr %cat.buf8, i64 %len6
  %19 = call ptr @memcpy(ptr %18, ptr %data11, i64 %len7)
  %20 = getelementptr i8, ptr %cat.buf8, i64 %15
  store i8 0, ptr %20, align 1
  %newstr12 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %21 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 0
  store i64 %15, ptr %21, align 8
  %22 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 1
  store ptr %cat.buf8, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 2
  store i64 0, ptr %23, align 8
  %y = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y13 = load i32, ptr %y, align 4, !tbaa !0
  %itoa.buf14 = call ptr @__polaron_malloc(i64 24)
  %24 = sext i32 %y13 to i64
  %25 = call i64 @__polaron_itoa(i64 %24, ptr %itoa.buf14)
  %newstr15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %26 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 0
  store i64 %25, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 1
  store ptr %itoa.buf14, ptr %27, align 8
  %28 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 2
  store i64 0, ptr %28, align 8
  %str.len16 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 0
  %len17 = load i64, ptr %str.len16, align 8
  %str.len18 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 0
  %len19 = load i64, ptr %str.len18, align 8
  %29 = add i64 %len17, %len19
  %30 = add i64 %29, 1
  %cat.buf20 = call ptr @__polaron_malloc(i64 %30)
  %str.data21 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %31 = call ptr @memcpy(ptr %cat.buf20, ptr %data22, i64 %len17)
  %str.data23 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 1
  %data24 = load ptr, ptr %str.data23, align 8
  %32 = getelementptr i8, ptr %cat.buf20, i64 %len17
  %33 = call ptr @memcpy(ptr %32, ptr %data24, i64 %len19)
  %34 = getelementptr i8, ptr %cat.buf20, i64 %29
  store i8 0, ptr %34, align 1
  %newstr25 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr25, i32 0, i32 0
  store i64 %29, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr25, i32 0, i32 1
  store ptr %cat.buf20, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr25, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %str.len26 = getelementptr inbounds %String, ptr %newstr25, i32 0, i32 0
  %len27 = load i64, ptr %str.len26, align 8
  %len28 = load i64, ptr @.strobj.4, align 8
  %38 = add i64 %len27, %len28
  %39 = add i64 %38, 1
  %cat.buf29 = call ptr @__polaron_malloc(i64 %39)
  %str.data30 = getelementptr inbounds %String, ptr %newstr25, i32 0, i32 1
  %data31 = load ptr, ptr %str.data30, align 8
  %40 = call ptr @memcpy(ptr %cat.buf29, ptr %data31, i64 %len27)
  %data32 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %41 = getelementptr i8, ptr %cat.buf29, i64 %len27
  %42 = call ptr @memcpy(ptr %41, ptr %data32, i64 %len28)
  %43 = getelementptr i8, ptr %cat.buf29, i64 %38
  store i8 0, ptr %43, align 1
  %newstr33 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %44 = getelementptr inbounds %String, ptr %newstr33, i32 0, i32 0
  store i64 %38, ptr %44, align 8
  %45 = getelementptr inbounds %String, ptr %newstr33, i32 0, i32 1
  store ptr %cat.buf29, ptr %45, align 8
  %46 = getelementptr inbounds %String, ptr %newstr33, i32 0, i32 2
  store i64 0, ptr %46, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr33)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr4)
  call void @__polaron_str_free(ptr %newstr12)
  call void @__polaron_str_free(ptr %newstr15)
  call void @__polaron_str_free(ptr %newstr25)
  call void @__polaron_str_free(ptr %newstr33)
  ret ptr %strcpy
}

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %16 = call ptr @Point.toString(ptr %p1)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %17 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %16)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @memcpy(ptr, ptr, i64)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @__polaron_itoa(i64, ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
