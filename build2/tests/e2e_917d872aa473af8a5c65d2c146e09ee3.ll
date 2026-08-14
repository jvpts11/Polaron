; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_java_enum.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_java_enum.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Medal = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Medal.vtable = private constant [350 x ptr] [ptr @Medal.score, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Medal.paper.__inst = private global ptr null
@Medal.bronze.__inst = private global ptr null
@Medal.gold.__inst = private global ptr null
@.str = private unnamed_addr constant [21 x i8] c"p=%d b=%d g=%d n=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Medal.Medal(ptr %0, i32 %1) {
entry:
  %points = alloca i32, align 4
  store i32 %1, ptr %points, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Medal, ptr %0, i32 0, i32 0
  store ptr @Medal.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %points1 = getelementptr inbounds %class.Medal, ptr %0, i32 0, i32 1
  %points2 = load i32, ptr %points, align 4
  store i32 %points2, ptr %points1, align 4, !tbaa !4
  ret void
}

define internal i32 @Medal.score(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %points = getelementptr inbounds %class.Medal, ptr %0, i32 0, i32 1
  %points1 = load i32, ptr %points, align 4, !tbaa !4
  ret i32 %points1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %s2 = alloca i64, align 8
  %s1 = alloca i64, align 8
  %m = alloca ptr, align 8
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
  %enum.cur = load ptr, ptr @Medal.paper.__inst, align 8
  %16 = icmp eq ptr %enum.cur, null
  br i1 %16, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %argv.end
  %Medal = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal, i32 1)
  store ptr %Medal, ptr @Medal.paper.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %argv.end
  %Medal1 = load ptr, ptr @Medal.paper.__inst, align 8
  store ptr %Medal1, ptr %m, align 8
  %enum.cur2 = load ptr, ptr @Medal.bronze.__inst, align 8
  %17 = icmp eq ptr %enum.cur2, null
  br i1 %17, label %enumc.init3, label %enumc.done4

enumc.init3:                                      ; preds = %enumc.done
  %Medal5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal5, i32 10)
  store ptr %Medal5, ptr @Medal.bronze.__inst, align 8
  br label %enumc.done4

enumc.done4:                                      ; preds = %enumc.init3, %enumc.done
  %Medal6 = load ptr, ptr @Medal.bronze.__inst, align 8
  %enum.ord.cur = load ptr, ptr @Medal.paper.__inst, align 8
  %18 = icmp eq ptr %Medal6, %enum.ord.cur
  %enum.ord = select i1 %18, i32 0, i32 -1
  %enum.ord.cur7 = load ptr, ptr @Medal.bronze.__inst, align 8
  %19 = icmp eq ptr %Medal6, %enum.ord.cur7
  %enum.ord8 = select i1 %19, i32 1, i32 %enum.ord
  %enum.ord.cur9 = load ptr, ptr @Medal.gold.__inst, align 8
  %20 = icmp eq ptr %Medal6, %enum.ord.cur9
  %enum.ord10 = select i1 %20, i32 2, i32 %enum.ord8
  %21 = zext i32 %enum.ord10 to i64
  %22 = or i64 %21, 0
  store i64 %22, ptr %s1, align 8
  %enum.cur11 = load ptr, ptr @Medal.gold.__inst, align 8
  %23 = icmp eq ptr %enum.cur11, null
  br i1 %23, label %enumc.init12, label %enumc.done13

enumc.init12:                                     ; preds = %enumc.done4
  %Medal14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal14, i32 95)
  store ptr %Medal14, ptr @Medal.gold.__inst, align 8
  br label %enumc.done13

enumc.done13:                                     ; preds = %enumc.init12, %enumc.done4
  %Medal15 = load ptr, ptr @Medal.gold.__inst, align 8
  %enum.ord.cur16 = load ptr, ptr @Medal.paper.__inst, align 8
  %24 = icmp eq ptr %Medal15, %enum.ord.cur16
  %enum.ord17 = select i1 %24, i32 0, i32 -1
  %enum.ord.cur18 = load ptr, ptr @Medal.bronze.__inst, align 8
  %25 = icmp eq ptr %Medal15, %enum.ord.cur18
  %enum.ord19 = select i1 %25, i32 1, i32 %enum.ord17
  %enum.ord.cur20 = load ptr, ptr @Medal.gold.__inst, align 8
  %26 = icmp eq ptr %Medal15, %enum.ord.cur20
  %enum.ord21 = select i1 %26, i32 2, i32 %enum.ord19
  %27 = zext i32 %enum.ord21 to i64
  %28 = or i64 %27, 0
  store i64 %28, ptr %s2, align 8
  %m22 = load ptr, ptr %m, align 8
  %29 = call i32 @Medal.score(ptr %m22)
  %s123 = load i64, ptr %s1, align 8
  %cat.ord = trunc i64 %s123 to i32
  %enum.cur24 = load ptr, ptr @Medal.paper.__inst, align 8
  %30 = icmp eq ptr %enum.cur24, null
  br i1 %30, label %enumc.init25, label %enumc.done26

enumc.init25:                                     ; preds = %enumc.done13
  %Medal27 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal27, i32 1)
  store ptr %Medal27, ptr @Medal.paper.__inst, align 8
  br label %enumc.done26

enumc.done26:                                     ; preds = %enumc.init25, %enumc.done13
  %Medal28 = load ptr, ptr @Medal.paper.__inst, align 8
  %31 = icmp eq i32 %cat.ord, 0
  %enum.singleton = select i1 %31, ptr %Medal28, ptr null
  %enum.cur29 = load ptr, ptr @Medal.bronze.__inst, align 8
  %32 = icmp eq ptr %enum.cur29, null
  br i1 %32, label %enumc.init30, label %enumc.done31

enumc.init30:                                     ; preds = %enumc.done26
  %Medal32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal32, i32 10)
  store ptr %Medal32, ptr @Medal.bronze.__inst, align 8
  br label %enumc.done31

enumc.done31:                                     ; preds = %enumc.init30, %enumc.done26
  %Medal33 = load ptr, ptr @Medal.bronze.__inst, align 8
  %33 = icmp eq i32 %cat.ord, 1
  %enum.singleton34 = select i1 %33, ptr %Medal33, ptr %enum.singleton
  %enum.cur35 = load ptr, ptr @Medal.gold.__inst, align 8
  %34 = icmp eq ptr %enum.cur35, null
  br i1 %34, label %enumc.init36, label %enumc.done37

enumc.init36:                                     ; preds = %enumc.done31
  %Medal38 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal38, i32 95)
  store ptr %Medal38, ptr @Medal.gold.__inst, align 8
  br label %enumc.done37

enumc.done37:                                     ; preds = %enumc.init36, %enumc.done31
  %Medal39 = load ptr, ptr @Medal.gold.__inst, align 8
  %35 = icmp eq i32 %cat.ord, 2
  %enum.singleton40 = select i1 %35, ptr %Medal39, ptr %enum.singleton34
  %36 = call i32 @Medal.score(ptr %enum.singleton40)
  %s241 = load i64, ptr %s2, align 8
  %cat.ord42 = trunc i64 %s241 to i32
  %enum.cur43 = load ptr, ptr @Medal.paper.__inst, align 8
  %37 = icmp eq ptr %enum.cur43, null
  br i1 %37, label %enumc.init44, label %enumc.done45

enumc.init44:                                     ; preds = %enumc.done37
  %Medal46 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal46, i32 1)
  store ptr %Medal46, ptr @Medal.paper.__inst, align 8
  br label %enumc.done45

enumc.done45:                                     ; preds = %enumc.init44, %enumc.done37
  %Medal47 = load ptr, ptr @Medal.paper.__inst, align 8
  %38 = icmp eq i32 %cat.ord42, 0
  %enum.singleton48 = select i1 %38, ptr %Medal47, ptr null
  %enum.cur49 = load ptr, ptr @Medal.bronze.__inst, align 8
  %39 = icmp eq ptr %enum.cur49, null
  br i1 %39, label %enumc.init50, label %enumc.done51

enumc.init50:                                     ; preds = %enumc.done45
  %Medal52 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal52, i32 10)
  store ptr %Medal52, ptr @Medal.bronze.__inst, align 8
  br label %enumc.done51

enumc.done51:                                     ; preds = %enumc.init50, %enumc.done45
  %Medal53 = load ptr, ptr @Medal.bronze.__inst, align 8
  %40 = icmp eq i32 %cat.ord42, 1
  %enum.singleton54 = select i1 %40, ptr %Medal53, ptr %enum.singleton48
  %enum.cur55 = load ptr, ptr @Medal.gold.__inst, align 8
  %41 = icmp eq ptr %enum.cur55, null
  br i1 %41, label %enumc.init56, label %enumc.done57

enumc.init56:                                     ; preds = %enumc.done51
  %Medal58 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Medal, ptr null, i64 1) to i64))
  call void @Medal.Medal(ptr %Medal58, i32 95)
  store ptr %Medal58, ptr @Medal.gold.__inst, align 8
  br label %enumc.done57

enumc.done57:                                     ; preds = %enumc.init56, %enumc.done51
  %Medal59 = load ptr, ptr @Medal.gold.__inst, align 8
  %42 = icmp eq i32 %cat.ord42, 2
  %enum.singleton60 = select i1 %42, ptr %Medal59, ptr %enum.singleton54
  %43 = call i32 @Medal.score(ptr %enum.singleton60)
  %44 = call i32 (ptr, ...) @printf(ptr @.str, i32 %29, i32 %36, i32 %43, i32 3)
  ret i32 0
}

define internal i32 @Object.equals(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal i32 @Object.hashCode(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 0
}

define internal i32 @Object.equalsKey(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal void @Object.Object(ptr %0) {
entry:
  %vtbl.addr = getelementptr inbounds %class.Object, ptr %0, i32 0, i32 0
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
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

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
