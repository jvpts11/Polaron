; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_no_leaks.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_no_leaks.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32 }
%class.Object = type { ptr }

@Test.fails = private global i32 0
@Test.criterion = private global ptr null
@Test.skipping = private global i32 0
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [349 x ptr] [ptr @Node.value, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [40 x i8] c"allocate and free gives everything back\00"
@.strobj = private global %String { i64 39, ptr @.strdata, i64 0 }
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_0, ptr null]
@.strdata.1 = private constant [65 x i8] c"a live object raises the byte total, and freeing it puts it back\00"
@.strobj.2 = private global %String { i64 64, ptr @.strdata.1, i64 0 }
@.strdata.5198 = private constant [1 x i8] zeroinitializer
@.strobj.5199 = private global %String { i64 0, ptr @.strdata.5198, i64 0 }
@.strdata.5200 = private constant [1 x i8] zeroinitializer
@.strobj.5201 = private global %String { i64 0, ptr @.strdata.5200, i64 0 }
@.str.5203 = private unnamed_addr constant [8 x i8] c"  [%s] \00", align 1
@.str.5204 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5205 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@.str.5208 = private unnamed_addr constant [25 x i8] c"expected %lld, got %lld\0A\00", align 1
@.str.5210 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5211 = private unnamed_addr constant [14 x i8] c"expected true\00", align 1
@.str.5296 = private unnamed_addr constant [19 x i8] c"leaked %lld bytes\0A\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.test.name = private unnamed_addr constant [38 x i8] c"Probe.clean_round_trip_leaves_nothing\00", align 1
@.test.tags = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5318 = private unnamed_addr constant [40 x i8] c"Probe.a_leak_shows_up_in_the_live_total\00", align 1
@.test.tags.5319 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5320 = private unnamed_addr constant [38 x i8] c"Probe.clean_round_trip_leaves_nothing\00", align 1
@.test.name.5321 = private unnamed_addr constant [40 x i8] c"Probe.a_leak_shows_up_in_the_live_total\00", align 1

define internal void @Node.Node(ptr %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %value = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %v1 = load i32, ptr %v, align 4
  store i32 %v1, ptr %value, align 4, !tbaa !4
  ret void
}

define internal i32 @Node.value(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %value = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %value1 = load i32, ptr %value, align 4, !tbaa !4
  ret i32 %value1
}

define internal void @Probe.clean_round_trip_leaves_nothing() {
entry:
  call void @Test.checking(ptr @.strobj)
  call void @Test.assertNoLeaks(ptr @__polaron_closure)
  ret void
}

define internal void @Probe.a_leak_shows_up_in_the_live_total() {
entry:
  %after = alloca i64, align 8
  %held = alloca i64, align 8
  %leaked = alloca ptr, align 8
  %before = alloca i64, align 8
  call void @Test.checking(ptr @.strobj.2)
  %0 = call i64 @Test.liveBytes()
  store i64 %0, ptr %before, align 8
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj, i32 7)
  store ptr %Node.obj, ptr %leaked, align 8
  %1 = call i64 @Test.liveBytes()
  store i64 %1, ptr %held, align 8
  %leaked1 = load ptr, ptr %leaked, align 8
  call void @__polaron_check_live(ptr %leaked1)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %leaked1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %2 = icmp ne ptr %dtor.fn, null
  br i1 %2, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %leaked1)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %leaked1)
  %3 = call i64 @Test.liveBytes()
  store i64 %3, ptr %after, align 8
  %held2 = load i64, ptr %held, align 8
  %before3 = load i64, ptr %before, align 8
  %4 = icmp sgt i64 %held2, %before3
  %5 = zext i1 %4 to i32
  call void @Test.assertTrue(i32 %5)
  %after4 = load i64, ptr %after, align 8
  %before5 = load i64, ptr %before, align 8
  call void @Test.assertEqualLong(i64 %after4, i64 %before5)
  ret void
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

define internal void @Test.reset() {
entry:
  store i32 0, ptr @Test.fails, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5199)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  store i32 0, ptr @Test.skipping, align 4
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5201)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

define internal i32 @Test.failures() {
entry:
  %fails = load i32, ptr @Test.fails, align 4
  ret i32 %fails
}

define internal i32 @Test.wasSkipped() {
entry:
  %skipping = load i32, ptr @Test.skipping, align 4
  ret i32 %skipping
}

define internal ptr @Test.skipReason() {
entry:
  %skipWhy = load ptr, ptr @Test.skipWhy, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %skipWhy)
  ret ptr %strcpy
}

define internal void @Test.checking(ptr %0) {
entry:
  %what = alloca ptr, align 8
  store ptr %0, ptr %what, align 8
  %what1 = load ptr, ptr %what, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %what1)
  %1 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy, ptr @Test.criterion, align 8
  ret void
}

declare void @__polaron_test_detail()

define internal void @Test.mark() {
entry:
  call void @__polaron_test_detail()
  %fails = load i32, ptr @Test.fails, align 4
  %0 = add i32 %fails, 1
  store i32 %0, ptr @Test.fails, align 4
  %criterion = load ptr, ptr @Test.criterion, align 8
  %str.len = getelementptr inbounds %String, ptr %criterion, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp sgt i32 %1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %criterion1 = load ptr, ptr @Test.criterion, align 8
  %str.data = getelementptr inbounds %String, ptr %criterion1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5203, ptr %data)
  br label %if.end

if.else:                                          ; preds = %entry
  %5 = call i32 (ptr, ...) @printf(ptr @.str.5204, ptr @.str.5205)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define internal void @Test.assertEqualLong(i64 %0, i64 %1) {
entry:
  %expected = alloca i64, align 8
  %actual = alloca i64, align 8
  store i64 %0, ptr %actual, align 8
  store i64 %1, ptr %expected, align 8
  %actual1 = load i64, ptr %actual, align 8
  %expected2 = load i64, ptr %expected, align 8
  %2 = icmp ne i64 %actual1, %expected2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected3 = load i64, ptr %expected, align 8
  %actual4 = load i64, ptr %actual, align 8
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5208, i64 %expected3, i64 %actual4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertTrue(i32 %0) {
entry:
  %condition = alloca i32, align 4
  store i32 %0, ptr %condition, align 4
  %condition1 = load i32, ptr %condition, align 4
  %1 = icmp eq i32 %condition1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %3 = call i32 (ptr, ...) @printf(ptr @.str.5210, ptr @.str.5211)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

declare i64 @__polaron_live_bytes()

define internal i64 @Test.liveBytes() {
entry:
  %0 = call i64 @__polaron_live_bytes()
  ret i64 %0
}

define internal void @Test.assertNoLeaks(ptr %0) {
entry:
  %after = alloca i64, align 8
  %before = alloca i64, align 8
  %action = alloca ptr, align 8
  store ptr %0, ptr %action, align 8
  %1 = call i64 @__polaron_live_bytes()
  store i64 %1, ptr %before, align 8
  %action1 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action1, align 8
  %2 = getelementptr ptr, ptr %action1, i32 1
  %env = load ptr, ptr %2, align 8
  call void %code(ptr %env)
  %3 = call i64 @__polaron_live_bytes()
  store i64 %3, ptr %after, align 8
  %after2 = load i64, ptr %after, align 8
  %before3 = load i64, ptr %before, align 8
  %4 = icmp sgt i64 %after2, %before3
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %after4 = load i64, ptr %after, align 8
  %before5 = load i64, ptr %before, align 8
  %6 = sub i64 %after4, %before5
  %7 = call i32 (ptr, ...) @printf(ptr @.str.5296, i64 %6)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
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

define internal void @__polaron_lambda_0(ptr %0) {
entry:
  %n = alloca ptr, align 8
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj, i32 7)
  store ptr %Node.obj, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  call void @__polaron_check_live(ptr %n1)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %n1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %1 = icmp ne ptr %dtor.fn, null
  br i1 %1, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %n1)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %n1)
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i64 @__polaron_now_ns()

define i32 @main(i32 %0, ptr %1) {
entry:
  call void @__polaron_test_begin(i32 %0, ptr %1)
  call void @Test.__onClassLoad()
  %2 = call i32 @__polaron_test_should_run(ptr @.test.name, ptr @.test.tags)
  %sel = icmp ne i32 %2, 0
  %any = or i1 false, %sel
  %3 = call i32 @__polaron_test_should_run(ptr @.test.name.5318, ptr @.test.tags.5319)
  %sel1 = icmp ne i32 %3, 0
  %any2 = or i1 %any, %sel1
  br i1 %any2, label %then, label %cont

then:                                             ; preds = %entry
  br label %cont

cont:                                             ; preds = %then, %entry
  %aborted = call i32 @__polaron_test_aborted()
  %4 = icmp eq i32 %aborted, 0
  %live = and i1 %sel, %4
  br i1 %live, label %then3, label %cont4

then3:                                            ; preds = %cont
  call void @__polaron_test_start(ptr @.test.name.5320, i32 0)
  %t0 = call i64 @__polaron_now_ns()
  %failcount = alloca i32, align 4
  store i32 0, ptr %failcount, align 4
  call void @Test.reset()
  call void @Probe.clean_round_trip_leaves_nothing()
  %fails = call i32 @Test.failures()
  %failed = icmp ne i32 %fails, 0
  %5 = zext i1 %failed to i32
  %6 = load i32, ptr %failcount, align 4
  %7 = add i32 %6, %5
  store i32 %7, ptr %failcount, align 4
  %8 = load i32, ptr %failcount, align 4
  %anyfailed = icmp ne i32 %8, 0
  %t1 = call i64 @__polaron_now_ns()
  %ns = sub i64 %t1, %t0
  %skipped = call i32 @Test.wasSkipped()
  %9 = icmp ne i32 %skipped, 0
  %why = call ptr @Test.skipReason()
  %10 = call ptr @__polaron_str_cstr(ptr %why)
  %11 = select i1 %anyfailed, i32 1, i32 0
  %verdict = select i1 %9, i32 2, i32 %11
  call void @__polaron_test_record(ptr @.test.name.5320, i32 %verdict, i64 %ns, ptr %10, i64 0)
  br label %cont4

cont4:                                            ; preds = %then3, %cont
  %aborted5 = call i32 @__polaron_test_aborted()
  %12 = icmp eq i32 %aborted5, 0
  %live6 = and i1 %sel1, %12
  br i1 %live6, label %then7, label %cont8

then7:                                            ; preds = %cont4
  call void @__polaron_test_start(ptr @.test.name.5321, i32 0)
  %t09 = call i64 @__polaron_now_ns()
  %failcount10 = alloca i32, align 4
  store i32 0, ptr %failcount10, align 4
  call void @Test.reset()
  call void @Probe.a_leak_shows_up_in_the_live_total()
  %fails11 = call i32 @Test.failures()
  %failed12 = icmp ne i32 %fails11, 0
  %13 = zext i1 %failed12 to i32
  %14 = load i32, ptr %failcount10, align 4
  %15 = add i32 %14, %13
  store i32 %15, ptr %failcount10, align 4
  %16 = load i32, ptr %failcount10, align 4
  %anyfailed13 = icmp ne i32 %16, 0
  %t114 = call i64 @__polaron_now_ns()
  %ns15 = sub i64 %t114, %t09
  %skipped16 = call i32 @Test.wasSkipped()
  %17 = icmp ne i32 %skipped16, 0
  %why17 = call ptr @Test.skipReason()
  %18 = call ptr @__polaron_str_cstr(ptr %why17)
  %19 = select i1 %anyfailed13, i32 1, i32 0
  %verdict18 = select i1 %17, i32 2, i32 %19
  call void @__polaron_test_record(ptr @.test.name.5321, i32 %verdict18, i64 %ns15, ptr %18, i64 0)
  br label %cont8

cont8:                                            ; preds = %then7, %cont4
  br i1 %any2, label %then19, label %cont20

then19:                                           ; preds = %cont8
  br label %cont20

cont20:                                           ; preds = %then19, %cont8
  %rc = call i32 @__polaron_test_summary()
  ret i32 %rc
}

declare void @__polaron_test_begin(i32, ptr)

declare i32 @__polaron_test_should_run(ptr, ptr)

declare void @__polaron_test_start(ptr, i32)

declare void @__polaron_test_record(ptr, i32, i64, ptr, i64)

declare i32 @__polaron_test_summary()

declare ptr @__polaron_str_cstr(ptr)

declare i32 @__polaron_test_aborted()

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
