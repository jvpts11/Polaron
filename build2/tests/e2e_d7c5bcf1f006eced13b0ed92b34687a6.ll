; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/transformer_call.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/transformer_call.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Cat = type { ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Cat.vtable = private constant [352 x ptr] [ptr @Cat.label, ptr @Cat.describe, ptr @"Cat.TDescriber$describe", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [4 x i8] c"cat\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [2 x i8] c"[\00"
@.strobj.2 = private global %String { i64 1, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c"]\00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [2 x i8] c"<\00"
@.strobj.6 = private global %String { i64 1, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [2 x i8] c">\00"
@.strobj.8 = private global %String { i64 1, ptr @.strdata.7, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }

define internal ptr @Cat.label(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  ret ptr %strcpy
}

define internal ptr @Cat.describe(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %1 = call ptr @"Cat.TDescriber$describe"(ptr %0)
  %len = load i64, ptr @.strobj.2, align 8
  %str.len = getelementptr inbounds %String, ptr %1, i32 0, i32 0
  %len1 = load i64, ptr %str.len, align 8
  %2 = add i64 %len, %len1
  %3 = add i64 %2, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %3)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %4 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %1, i32 0, i32 1
  %data2 = load ptr, ptr %str.data, align 8
  %5 = getelementptr i8, ptr %cat.buf, i64 %len
  %6 = call ptr @memcpy(ptr %5, ptr %data2, i64 %len1)
  %7 = getelementptr i8, ptr %cat.buf, i64 %2
  store i8 0, ptr %7, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %2, ptr %8, align 8
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %9, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %10, align 8
  %str.len3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %len5 = load i64, ptr @.strobj.4, align 8
  %11 = add i64 %len4, %len5
  %12 = add i64 %11, 1
  %cat.buf6 = call ptr @__polaron_malloc(i64 %12)
  %str.data7 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %13 = call ptr @memcpy(ptr %cat.buf6, ptr %data8, i64 %len4)
  %data9 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %14 = getelementptr i8, ptr %cat.buf6, i64 %len4
  %15 = call ptr @memcpy(ptr %14, ptr %data9, i64 %len5)
  %16 = getelementptr i8, ptr %cat.buf6, i64 %11
  store i8 0, ptr %16, align 1
  %newstr10 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 0
  store i64 %11, ptr %17, align 8
  %18 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 1
  store ptr %cat.buf6, ptr %18, align 8
  %19 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 2
  store i64 0, ptr %19, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr10)
  call void @__polaron_str_free(ptr %1)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr10)
  ret ptr %strcpy
}

define internal ptr @"Cat.TDescriber$describe"(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %1 = call ptr @Cat.label(ptr %0)
  %len = load i64, ptr @.strobj.6, align 8
  %str.len = getelementptr inbounds %String, ptr %1, i32 0, i32 0
  %len1 = load i64, ptr %str.len, align 8
  %2 = add i64 %len, %len1
  %3 = add i64 %2, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %3)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %4 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %1, i32 0, i32 1
  %data2 = load ptr, ptr %str.data, align 8
  %5 = getelementptr i8, ptr %cat.buf, i64 %len
  %6 = call ptr @memcpy(ptr %5, ptr %data2, i64 %len1)
  %7 = getelementptr i8, ptr %cat.buf, i64 %2
  store i8 0, ptr %7, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %2, ptr %8, align 8
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %9, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %10, align 8
  %str.len3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %len5 = load i64, ptr @.strobj.8, align 8
  %11 = add i64 %len4, %len5
  %12 = add i64 %11, 1
  %cat.buf6 = call ptr @__polaron_malloc(i64 %12)
  %str.data7 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %13 = call ptr @memcpy(ptr %cat.buf6, ptr %data8, i64 %len4)
  %data9 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.8, i32 0, i32 1), align 8
  %14 = getelementptr i8, ptr %cat.buf6, i64 %len4
  %15 = call ptr @memcpy(ptr %14, ptr %data9, i64 %len5)
  %16 = getelementptr i8, ptr %cat.buf6, i64 %11
  store i8 0, ptr %16, align 1
  %newstr10 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 0
  store i64 %11, ptr %17, align 8
  %18 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 1
  store ptr %cat.buf6, ptr %18, align 8
  %19 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 2
  store i64 0, ptr %19, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr10)
  call void @__polaron_str_free(ptr %1)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr10)
  ret ptr %strcpy
}

define internal void @Cat.Cat(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Cat, ptr %0, i32 0, i32 0
  store ptr @Cat.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca ptr, align 8
  %Cat.obj = alloca %class.Cat, align 8
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
  call void @Cat.Cat(ptr %Cat.obj)
  store ptr %Cat.obj, ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  %16 = call ptr @Cat.describe(ptr %c1)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %17 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %16)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @__polaron_str_copy(ptr)

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
