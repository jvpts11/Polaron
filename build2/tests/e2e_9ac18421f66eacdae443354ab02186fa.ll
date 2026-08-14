; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_mutable_lifetime.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_mutable_lifetime.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Box = type { ptr, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Box.vtable = private constant [351 x ptr] [ptr @Box.setTag, ptr @Box.getTag, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [351 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [5 x i8] c"init\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [2 x i8] c"n\00"
@.strobj.2 = private global %String { i64 1, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c"!\00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [4 x i8] c"foo\00"
@.strobj.6 = private global %String { i64 3, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [4 x i8] c"bar\00"
@.strobj.8 = private global %String { i64 3, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [2 x i8] c"x\00"
@.strobj.10 = private global %String { i64 1, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [1 x i8] zeroinitializer
@.strobj.12 = private global %String { i64 0, ptr @.strdata.11, i64 0 }
@.str = private unnamed_addr constant [16 x i8] c"%s|%s|%s|%s|%s\0A\00", align 1
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }

define internal void @Box.Box(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 0
  store ptr @Box.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %tag = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  %1 = load ptr, ptr %tag, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy, ptr %tag, align 8, !tbaa !0
  ret void
}

define internal void @Box.setTag(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  %tag = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %s1 = load ptr, ptr %s, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %s1)
  %2 = load ptr, ptr %tag, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %tag, align 8, !tbaa !0
  ret void
}

define internal ptr @Box.getTag(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %tag = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %tag1 = load ptr, ptr %tag, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %tag1)
  ret ptr %strcpy
}

define internal ptr @Main.mk() {
entry:
  %s = alloca ptr, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2)
  store ptr %strcpy, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len2 = load i64, ptr @.strobj.4, align 8
  %0 = add i64 %len, %len2
  %1 = add i64 %0, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %1)
  %str.data = getelementptr inbounds %String, ptr %s1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %2 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data3 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %3 = getelementptr i8, ptr %cat.buf, i64 %len
  %4 = call ptr @memcpy(ptr %3, ptr %data3, i64 %len2)
  %5 = getelementptr i8, ptr %cat.buf, i64 %0
  store i8 0, ptr %5, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %0, ptr %6, align 8
  %7 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %7, align 8
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %8, align 8
  %strcpy4 = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  %9 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %9)
  ret ptr %strcpy4
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %box = alloca ptr, align 8
  %m = alloca ptr, align 8
  %i = alloca i32, align 4
  %acc = alloca ptr, align 8
  %e = alloca ptr, align 8
  %d = alloca ptr, align 8
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.6)
  store ptr %strcpy, ptr %a, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.8)
  store ptr %strcpy1, ptr %b, align 8
  %a2 = load ptr, ptr %a, align 8
  %b3 = load ptr, ptr %b, align 8
  %str.len = getelementptr inbounds %String, ptr %a2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.len4 = getelementptr inbounds %String, ptr %b3, i32 0, i32 0
  %len5 = load i64, ptr %str.len4, align 8
  %16 = add i64 %len, %len5
  %17 = add i64 %16, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %17)
  %str.data = getelementptr inbounds %String, ptr %a2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %18 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data6 = getelementptr inbounds %String, ptr %b3, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %19 = getelementptr i8, ptr %cat.buf, i64 %len
  %20 = call ptr @memcpy(ptr %19, ptr %data7, i64 %len5)
  %21 = getelementptr i8, ptr %cat.buf, i64 %16
  store i8 0, ptr %21, align 1
  %newstr8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %22 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 0
  store i64 %16, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  store ptr %cat.buf, ptr %23, align 8
  %24 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 2
  store i64 0, ptr %24, align 8
  %strcpy9 = call ptr @__polaron_str_copy(ptr %newstr8)
  store ptr %strcpy9, ptr %d, align 8
  call void @__polaron_str_free(ptr %newstr8)
  %strcpy10 = call ptr @__polaron_str_copy(ptr @.strobj.10)
  store ptr %strcpy10, ptr %e, align 8
  %a11 = load ptr, ptr %a, align 8
  %b12 = load ptr, ptr %b, align 8
  %str.len13 = getelementptr inbounds %String, ptr %a11, i32 0, i32 0
  %len14 = load i64, ptr %str.len13, align 8
  %str.len15 = getelementptr inbounds %String, ptr %b12, i32 0, i32 0
  %len16 = load i64, ptr %str.len15, align 8
  %25 = add i64 %len14, %len16
  %26 = add i64 %25, 1
  %cat.buf17 = call ptr @__polaron_malloc(i64 %26)
  %str.data18 = getelementptr inbounds %String, ptr %a11, i32 0, i32 1
  %data19 = load ptr, ptr %str.data18, align 8
  %27 = call ptr @memcpy(ptr %cat.buf17, ptr %data19, i64 %len14)
  %str.data20 = getelementptr inbounds %String, ptr %b12, i32 0, i32 1
  %data21 = load ptr, ptr %str.data20, align 8
  %28 = getelementptr i8, ptr %cat.buf17, i64 %len14
  %29 = call ptr @memcpy(ptr %28, ptr %data21, i64 %len16)
  %30 = getelementptr i8, ptr %cat.buf17, i64 %25
  store i8 0, ptr %30, align 1
  %newstr22 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %31 = getelementptr inbounds %String, ptr %newstr22, i32 0, i32 0
  store i64 %25, ptr %31, align 8
  %32 = getelementptr inbounds %String, ptr %newstr22, i32 0, i32 1
  store ptr %cat.buf17, ptr %32, align 8
  %33 = getelementptr inbounds %String, ptr %newstr22, i32 0, i32 2
  store i64 0, ptr %33, align 8
  %strcpy23 = call ptr @__polaron_str_copy(ptr %newstr22)
  %34 = load ptr, ptr %e, align 8
  call void @__polaron_str_free(ptr %34)
  store ptr %strcpy23, ptr %e, align 8
  call void @__polaron_str_free(ptr %newstr22)
  %e24 = load ptr, ptr %e, align 8
  %a25 = load ptr, ptr %a, align 8
  %str.len26 = getelementptr inbounds %String, ptr %e24, i32 0, i32 0
  %len27 = load i64, ptr %str.len26, align 8
  %str.len28 = getelementptr inbounds %String, ptr %a25, i32 0, i32 0
  %len29 = load i64, ptr %str.len28, align 8
  %35 = add i64 %len27, %len29
  %36 = add i64 %35, 1
  %cat.buf30 = call ptr @__polaron_malloc(i64 %36)
  %str.data31 = getelementptr inbounds %String, ptr %e24, i32 0, i32 1
  %data32 = load ptr, ptr %str.data31, align 8
  %37 = call ptr @memcpy(ptr %cat.buf30, ptr %data32, i64 %len27)
  %str.data33 = getelementptr inbounds %String, ptr %a25, i32 0, i32 1
  %data34 = load ptr, ptr %str.data33, align 8
  %38 = getelementptr i8, ptr %cat.buf30, i64 %len27
  %39 = call ptr @memcpy(ptr %38, ptr %data34, i64 %len29)
  %40 = getelementptr i8, ptr %cat.buf30, i64 %35
  store i8 0, ptr %40, align 1
  %newstr35 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %41 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 0
  store i64 %35, ptr %41, align 8
  %42 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 1
  store ptr %cat.buf30, ptr %42, align 8
  %43 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 2
  store i64 0, ptr %43, align 8
  %strcpy36 = call ptr @__polaron_str_copy(ptr %newstr35)
  %44 = load ptr, ptr %e, align 8
  call void @__polaron_str_free(ptr %44)
  store ptr %strcpy36, ptr %e, align 8
  call void @__polaron_str_free(ptr %newstr35)
  %strcpy37 = call ptr @__polaron_str_copy(ptr @.strobj.12)
  store ptr %strcpy37, ptr %acc, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i38 = load i32, ptr %i, align 4
  %45 = icmp slt i32 %i38, 500
  %46 = zext i1 %45 to i32
  br i1 %45, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %a39 = load ptr, ptr %a, align 8
  %b40 = load ptr, ptr %b, align 8
  %str.len41 = getelementptr inbounds %String, ptr %a39, i32 0, i32 0
  %len42 = load i64, ptr %str.len41, align 8
  %str.len43 = getelementptr inbounds %String, ptr %b40, i32 0, i32 0
  %len44 = load i64, ptr %str.len43, align 8
  %47 = add i64 %len42, %len44
  %48 = add i64 %47, 1
  %cat.buf45 = call ptr @__polaron_malloc(i64 %48)
  %str.data46 = getelementptr inbounds %String, ptr %a39, i32 0, i32 1
  %data47 = load ptr, ptr %str.data46, align 8
  %49 = call ptr @memcpy(ptr %cat.buf45, ptr %data47, i64 %len42)
  %str.data48 = getelementptr inbounds %String, ptr %b40, i32 0, i32 1
  %data49 = load ptr, ptr %str.data48, align 8
  %50 = getelementptr i8, ptr %cat.buf45, i64 %len42
  %51 = call ptr @memcpy(ptr %50, ptr %data49, i64 %len44)
  %52 = getelementptr i8, ptr %cat.buf45, i64 %47
  store i8 0, ptr %52, align 1
  %newstr50 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %53 = getelementptr inbounds %String, ptr %newstr50, i32 0, i32 0
  store i64 %47, ptr %53, align 8
  %54 = getelementptr inbounds %String, ptr %newstr50, i32 0, i32 1
  store ptr %cat.buf45, ptr %54, align 8
  %55 = getelementptr inbounds %String, ptr %newstr50, i32 0, i32 2
  store i64 0, ptr %55, align 8
  %strcpy51 = call ptr @__polaron_str_copy(ptr %newstr50)
  %56 = load ptr, ptr %acc, align 8
  call void @__polaron_str_free(ptr %56)
  store ptr %strcpy51, ptr %acc, align 8
  call void @__polaron_str_free(ptr %newstr50)
  br label %for.update

for.update:                                       ; preds = %for.body
  %57 = load i32, ptr %i, align 4
  %58 = add i32 %57, 1
  store i32 %58, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %59 = call ptr @Main.mk()
  %strcpy52 = call ptr @__polaron_str_copy(ptr %59)
  store ptr %strcpy52, ptr %m, align 8
  call void @__polaron_str_free(ptr %59)
  %Box.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  call void @Box.Box(ptr %Box.obj)
  store ptr %Box.obj, ptr %box, align 8
  %box53 = load ptr, ptr %box, align 8
  %a54 = load ptr, ptr %a, align 8
  %b55 = load ptr, ptr %b, align 8
  %str.len56 = getelementptr inbounds %String, ptr %a54, i32 0, i32 0
  %len57 = load i64, ptr %str.len56, align 8
  %str.len58 = getelementptr inbounds %String, ptr %b55, i32 0, i32 0
  %len59 = load i64, ptr %str.len58, align 8
  %60 = add i64 %len57, %len59
  %61 = add i64 %60, 1
  %cat.buf60 = call ptr @__polaron_malloc(i64 %61)
  %str.data61 = getelementptr inbounds %String, ptr %a54, i32 0, i32 1
  %data62 = load ptr, ptr %str.data61, align 8
  %62 = call ptr @memcpy(ptr %cat.buf60, ptr %data62, i64 %len57)
  %str.data63 = getelementptr inbounds %String, ptr %b55, i32 0, i32 1
  %data64 = load ptr, ptr %str.data63, align 8
  %63 = getelementptr i8, ptr %cat.buf60, i64 %len57
  %64 = call ptr @memcpy(ptr %63, ptr %data64, i64 %len59)
  %65 = getelementptr i8, ptr %cat.buf60, i64 %60
  store i8 0, ptr %65, align 1
  %newstr65 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %66 = getelementptr inbounds %String, ptr %newstr65, i32 0, i32 0
  store i64 %60, ptr %66, align 8
  %67 = getelementptr inbounds %String, ptr %newstr65, i32 0, i32 1
  store ptr %cat.buf60, ptr %67, align 8
  %68 = getelementptr inbounds %String, ptr %newstr65, i32 0, i32 2
  store i64 0, ptr %68, align 8
  call void @Box.setTag(ptr %box53, ptr %newstr65)
  call void @__polaron_str_free(ptr %newstr65)
  %d66 = load ptr, ptr %d, align 8
  %str.data67 = getelementptr inbounds %String, ptr %d66, i32 0, i32 1
  %data68 = load ptr, ptr %str.data67, align 8
  %e69 = load ptr, ptr %e, align 8
  %str.data70 = getelementptr inbounds %String, ptr %e69, i32 0, i32 1
  %data71 = load ptr, ptr %str.data70, align 8
  %acc72 = load ptr, ptr %acc, align 8
  %str.data73 = getelementptr inbounds %String, ptr %acc72, i32 0, i32 1
  %data74 = load ptr, ptr %str.data73, align 8
  %m75 = load ptr, ptr %m, align 8
  %str.data76 = getelementptr inbounds %String, ptr %m75, i32 0, i32 1
  %data77 = load ptr, ptr %str.data76, align 8
  %box78 = load ptr, ptr %box, align 8
  %69 = call ptr @Box.getTag(ptr %box78)
  %str.data79 = getelementptr inbounds %String, ptr %69, i32 0, i32 1
  %data80 = load ptr, ptr %str.data79, align 8
  %70 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data68, ptr %data71, ptr %data74, ptr %data77, ptr %data80)
  call void @__polaron_str_free(ptr %69)
  %box81 = load ptr, ptr %box, align 8
  call void @__polaron_check_live(ptr %box81)
  %vtbl.addr = getelementptr inbounds %class.Box, ptr %box81, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [351 x ptr], ptr %vtbl, i64 0, i64 350
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %71 = icmp ne ptr %dtor.fn, null
  br i1 %71, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %for.end
  call void %dtor.fn(ptr %box81)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %for.end
  %tag.sfree = getelementptr inbounds %class.Box, ptr %box81, i32 0, i32 1
  %72 = load ptr, ptr %tag.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %72)
  call void @__polaron_free(ptr %box81)
  %73 = load ptr, ptr %m, align 8
  call void @__polaron_str_free(ptr %73)
  %74 = load ptr, ptr %acc, align 8
  call void @__polaron_str_free(ptr %74)
  %75 = load ptr, ptr %e, align 8
  call void @__polaron_str_free(ptr %75)
  %76 = load ptr, ptr %d, align 8
  call void @__polaron_str_free(ptr %76)
  %77 = load ptr, ptr %b, align 8
  call void @__polaron_str_free(ptr %77)
  %78 = load ptr, ptr %a, align 8
  call void @__polaron_str_free(ptr %78)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5320)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5322)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
