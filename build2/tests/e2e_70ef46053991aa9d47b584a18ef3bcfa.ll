; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_framework.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_framework.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.TestRunner = type { ptr, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@TestRunner.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @TestRunner.check, ptr @TestRunner.passed, ptr @TestRunner.failed, ptr @TestRunner.allPassed, ptr @TestRunner.report, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [10 x i8] c"int equal\00"
@.strobj = private global %String { i64 9, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [13 x i8] c"string equal\00"
@.strobj.2 = private global %String { i64 12, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [3 x i8] c"ab\00"
@.strobj.4 = private global %String { i64 2, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [2 x i8] c"c\00"
@.strobj.6 = private global %String { i64 1, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [4 x i8] c"abc\00"
@.strobj.8 = private global %String { i64 3, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [12 x i8] c"double near\00"
@.strobj.10 = private global %String { i64 11, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [8 x i8] c"boolean\00"
@.strobj.12 = private global %String { i64 7, ptr @.strdata.11, i64 0 }
@.str = private unnamed_addr constant [8 x i8] c"all=%d\0A\00", align 1
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }
@.str.5323 = private unnamed_addr constant [9 x i8] c"PASS %s\0A\00", align 1
@.str.5324 = private unnamed_addr constant [9 x i8] c"FAIL %s\0A\00", align 1
@.str.5325 = private unnamed_addr constant [22 x i8] c"%d passed, %d failed\0A\00", align 1

define i32 @main(i32 %0, ptr %1) {
entry:
  %t = alloca ptr, align 8
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
  %TestRunner.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.TestRunner, ptr null, i64 1) to i64))
  call void @TestRunner.TestRunner(ptr %TestRunner.obj)
  store ptr %TestRunner.obj, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %16 = call i32 @Assert.eq(i32 4, i32 4)
  call void @TestRunner.check(ptr %t1, ptr @.strobj, i32 %16)
  %t2 = load ptr, ptr %t, align 8
  %len = load i64, ptr @.strobj.4, align 8
  %len3 = load i64, ptr @.strobj.6, align 8
  %17 = add i64 %len, %len3
  %18 = add i64 %17, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %18)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %19 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data4 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %20 = getelementptr i8, ptr %cat.buf, i64 %len
  %21 = call ptr @memcpy(ptr %20, ptr %data4, i64 %len3)
  %22 = getelementptr i8, ptr %cat.buf, i64 %17
  store i8 0, ptr %22, align 1
  %newstr5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %23 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 0
  store i64 %17, ptr %23, align 8
  %24 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 1
  store ptr %cat.buf, ptr %24, align 8
  %25 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 2
  store i64 0, ptr %25, align 8
  %26 = call i32 @Assert.eqStr(ptr %newstr5, ptr @.strobj.8)
  call void @TestRunner.check(ptr %t2, ptr @.strobj.2, i32 %26)
  call void @__polaron_str_free(ptr %newstr5)
  %t6 = load ptr, ptr %t, align 8
  %27 = call i32 @Assert.near(double 0x3FD3333333333334, double 3.000000e-01, double 1.000000e-04)
  call void @TestRunner.check(ptr %t6, ptr @.strobj.10, i32 %27)
  %t7 = load ptr, ptr %t, align 8
  %28 = call i32 @Assert.isTrue(i32 1)
  call void @TestRunner.check(ptr %t7, ptr @.strobj.12, i32 %28)
  %t8 = load ptr, ptr %t, align 8
  call void @TestRunner.report(ptr %t8)
  %t9 = load ptr, ptr %t, align 8
  %29 = call i32 @TestRunner.allPassed(ptr %t9)
  %30 = call i32 (ptr, ...) @printf(ptr @.str, i32 %29)
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

define internal i32 @Assert.eq(i32 %0, i32 %1) {
entry:
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  store i32 %1, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %b2 = load i32, ptr %b, align 4
  %2 = icmp eq i32 %a1, %b2
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal i32 @Assert.eqStr(ptr %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %b2 = load ptr, ptr %b, align 8
  %str.data = getelementptr inbounds %String, ptr %a1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data3 = getelementptr inbounds %String, ptr %b2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %2 = call i32 @strcmp(ptr %data, ptr %data4)
  %3 = icmp eq i32 %2, 0
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal i32 @Assert.near(double %0, double %1, double %2) {
entry:
  %d = alloca double, align 8
  %eps = alloca double, align 8
  %b = alloca double, align 8
  %a = alloca double, align 8
  store double %0, ptr %a, align 8
  store double %1, ptr %b, align 8
  store double %2, ptr %eps, align 8
  %a1 = load double, ptr %a, align 8
  %b2 = load double, ptr %b, align 8
  %3 = fsub double %a1, %b2
  store double %3, ptr %d, align 8
  %d3 = load double, ptr %d, align 8
  %4 = fcmp olt double %d3, 0.000000e+00
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %d4 = load double, ptr %d, align 8
  %6 = fsub double 0.000000e+00, %d4
  store double %6, ptr %d, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %d5 = load double, ptr %d, align 8
  %eps6 = load double, ptr %eps, align 8
  %7 = fcmp ole double %d5, %eps6
  %8 = zext i1 %7 to i32
  ret i32 %8
}

define internal i32 @Assert.isTrue(i32 %0) {
entry:
  %c = alloca i32, align 4
  store i32 %0, ptr %c, align 4
  %c1 = load i32, ptr %c, align 4
  ret i32 %c1
}

define internal void @TestRunner.TestRunner(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 0
  store ptr @TestRunner.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %passed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 1
  store i32 0, ptr %passed, align 4, !tbaa !4
  %failed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 2
  store i32 0, ptr %failed, align 4, !tbaa !4
  ret void
}

define internal void @TestRunner.check(ptr nonnull align 8 dereferenceable(16) %0, ptr %1, i32 %2) {
entry:
  %cond = alloca i32, align 4
  %name = alloca ptr, align 8
  store ptr %1, ptr %name, align 8
  store i32 %2, ptr %cond, align 4
  %cond1 = load i32, ptr %cond, align 4
  %3 = icmp ne i32 %cond1, 0
  br i1 %3, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %passed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 1
  %passed2 = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 1
  %passed3 = load i32, ptr %passed2, align 4, !tbaa !4
  %4 = add i32 %passed3, 1
  store i32 %4, ptr %passed, align 4, !tbaa !4
  %name4 = load ptr, ptr %name, align 8
  %str.data = getelementptr inbounds %String, ptr %name4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %5 = call i32 (ptr, ...) @printf(ptr @.str.5323, ptr %data)
  br label %if.end

if.else:                                          ; preds = %entry
  %failed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 2
  %failed5 = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 2
  %failed6 = load i32, ptr %failed5, align 4, !tbaa !4
  %6 = add i32 %failed6, 1
  store i32 %6, ptr %failed, align 4, !tbaa !4
  %name7 = load ptr, ptr %name, align 8
  %str.data8 = getelementptr inbounds %String, ptr %name7, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %7 = call i32 (ptr, ...) @printf(ptr @.str.5324, ptr %data9)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define internal i32 @TestRunner.passed(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %passed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 1
  %passed1 = load i32, ptr %passed, align 4, !tbaa !4
  ret i32 %passed1
}

define internal i32 @TestRunner.failed(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %failed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 2
  %failed1 = load i32, ptr %failed, align 4, !tbaa !4
  ret i32 %failed1
}

define internal i32 @TestRunner.allPassed(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %failed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 2
  %failed1 = load i32, ptr %failed, align 4, !tbaa !4
  %1 = icmp eq i32 %failed1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @TestRunner.report(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %passed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 1
  %passed1 = load i32, ptr %passed, align 4, !tbaa !4
  %failed = getelementptr inbounds %class.TestRunner, ptr %0, i32 0, i32 2
  %failed2 = load i32, ptr %failed, align 4, !tbaa !4
  %1 = call i32 (ptr, ...) @printf(ptr @.str.5325, i32 %passed1, i32 %failed2)
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare i32 @strcmp(ptr, ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
