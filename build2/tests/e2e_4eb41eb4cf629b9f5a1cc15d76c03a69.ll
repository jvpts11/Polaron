; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/inline_tests.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/inline_tests.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.fails = private global i32 0
@Test.criterion = private global ptr null
@Test.skipping = private global i32 0
@Test.skipWhy = private global ptr null
@.strdata = private constant [3 x i8] c"ab\00"
@.strobj = private global %String { i64 2, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [2 x i8] c"c\00"
@.strobj.2 = private global %String { i64 1, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [4 x i8] c"abc\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@.strdata.5198 = private constant [1 x i8] zeroinitializer
@.strobj.5199 = private global %String { i64 0, ptr @.strdata.5198, i64 0 }
@.strdata.5200 = private constant [1 x i8] zeroinitializer
@.strobj.5201 = private global %String { i64 0, ptr @.strdata.5200, i64 0 }
@.str.5203 = private unnamed_addr constant [8 x i8] c"  [%s] \00", align 1
@.str.5204 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5205 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@.str.5206 = private unnamed_addr constant [21 x i8] c"expected %d, got %d\0A\00", align 1
@.str.5208 = private unnamed_addr constant [25 x i8] c"expected %lld, got %lld\0A\00", align 1
@.str.5209 = private unnamed_addr constant [21 x i8] c"expected %s, got %s\0A\00", align 1
@.str.5210 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5211 = private unnamed_addr constant [14 x i8] c"expected true\00", align 1
@.str.5212 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5213 = private unnamed_addr constant [15 x i8] c"expected false\00", align 1
@.str.5218 = private unnamed_addr constant [28 x i8] c"expected %f +/- %f, got %f\0A\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.test.name = private unnamed_addr constant [20 x i8] c"MathUtils.add_basic\00", align 1
@.test.tags = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5318 = private unnamed_addr constant [35 x i8] c"MathUtils.predicates_and_tolerance\00", align 1
@.test.tags.5319 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5320 = private unnamed_addr constant [24 x i8] c"MathUtils.still_boolean\00", align 1
@.test.tags.5321 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5322 = private unnamed_addr constant [20 x i8] c"MathUtils.add_basic\00", align 1
@.test.name.5323 = private unnamed_addr constant [35 x i8] c"MathUtils.predicates_and_tolerance\00", align 1
@.test.name.5324 = private unnamed_addr constant [24 x i8] c"MathUtils.still_boolean\00", align 1

define internal i32 @MathUtils.add(i32 %0, i32 %1) {
entry:
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  store i32 %1, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %b2 = load i32, ptr %b, align 4
  %2 = add i32 %a1, %b2
  ret i32 %2
}

define internal double @MathUtils.half(i32 %0) {
entry:
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  %a1 = load i32, ptr %a, align 4
  %1 = sitofp i32 %a1 to double
  %2 = fdiv double %1, 2.000000e+00
  ret double %2
}

define internal void @MathUtils.add_basic() {
entry:
  %0 = call i32 @MathUtils.add(i32 2, i32 2)
  call void @Test.assertEqual(i32 %0, i32 4)
  %1 = call i32 @MathUtils.add(i32 0, i32 0)
  call void @Test.assertEqual(i32 %1, i32 0)
  %2 = call i32 @MathUtils.add(i32 -1, i32 1)
  call void @Test.assertEqual(i32 %2, i32 0)
  ret void
}

define internal void @MathUtils.predicates_and_tolerance() {
entry:
  %0 = call i32 @MathUtils.add(i32 1, i32 1)
  %1 = icmp eq i32 %0, 2
  %2 = zext i1 %1 to i32
  call void @Test.assertTrue(i32 %2)
  %3 = call i32 @MathUtils.add(i32 1, i32 1)
  %4 = icmp eq i32 %3, 3
  %5 = zext i1 %4 to i32
  call void @Test.assertFalse(i32 %5)
  %6 = call double @MathUtils.half(i32 1)
  call void @Test.assertWithin(double %6, double 5.000000e-01, double 1.000000e-04)
  %len = load i64, ptr @.strobj, align 8
  %len1 = load i64, ptr @.strobj.2, align 8
  %7 = add i64 %len, %len1
  %8 = add i64 %7, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %8)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %9 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %10 = getelementptr i8, ptr %cat.buf, i64 %len
  %11 = call ptr @memcpy(ptr %10, ptr %data2, i64 %len1)
  %12 = getelementptr i8, ptr %cat.buf, i64 %7
  store i8 0, ptr %12, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %7, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %14, align 8
  %15 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %15, align 8
  call void @Test.assertEqualString(ptr %newstr, ptr @.strobj.4)
  call void @__polaron_str_free(ptr %newstr)
  call void @Test.assertEqualLong(i64 6, i64 6)
  ret void
}

define internal i32 @MathUtils.still_boolean() {
entry:
  %0 = call i32 @MathUtils.add(i32 20, i32 22)
  %1 = icmp eq i32 %0, 42
  %2 = zext i1 %1 to i32
  ret i32 %2
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

define internal void @Test.assertEqual(i32 %0, i32 %1) {
entry:
  %expected = alloca i32, align 4
  %actual = alloca i32, align 4
  store i32 %0, ptr %actual, align 4
  store i32 %1, ptr %expected, align 4
  %actual1 = load i32, ptr %actual, align 4
  %expected2 = load i32, ptr %expected, align 4
  %2 = icmp ne i32 %actual1, %expected2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected3 = load i32, ptr %expected, align 4
  %actual4 = load i32, ptr %actual, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5206, i32 %expected3, i32 %actual4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
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

define internal void @Test.assertEqualString(ptr %0, ptr %1) {
entry:
  %expected = alloca ptr, align 8
  %actual = alloca ptr, align 8
  store ptr %0, ptr %actual, align 8
  store ptr %1, ptr %expected, align 8
  %actual1 = load ptr, ptr %actual, align 8
  %expected2 = load ptr, ptr %expected, align 8
  %str.data = getelementptr inbounds %String, ptr %actual1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data3 = getelementptr inbounds %String, ptr %expected2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %2 = call i32 @strcmp(ptr %data, ptr %data4)
  %3 = icmp eq i32 %2, 0
  %4 = zext i1 %3 to i32
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected5 = load ptr, ptr %expected, align 8
  %str.data6 = getelementptr inbounds %String, ptr %expected5, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %actual8 = load ptr, ptr %actual, align 8
  %str.data9 = getelementptr inbounds %String, ptr %actual8, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %7 = call i32 (ptr, ...) @printf(ptr @.str.5209, ptr %data7, ptr %data10)
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

define internal void @Test.assertFalse(i32 %0) {
entry:
  %condition = alloca i32, align 4
  store i32 %0, ptr %condition, align 4
  %condition1 = load i32, ptr %condition, align 4
  %1 = icmp ne i32 %condition1, 0
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %2 = call i32 (ptr, ...) @printf(ptr @.str.5212, ptr @.str.5213)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertWithin(double %0, double %1, double %2) {
entry:
  %d = alloca double, align 8
  %tolerance = alloca double, align 8
  %expected = alloca double, align 8
  %actual = alloca double, align 8
  store double %0, ptr %actual, align 8
  store double %1, ptr %expected, align 8
  store double %2, ptr %tolerance, align 8
  %actual1 = load double, ptr %actual, align 8
  %expected2 = load double, ptr %expected, align 8
  %3 = fsub double %actual1, %expected2
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
  %tolerance6 = load double, ptr %tolerance, align 8
  %7 = fcmp ogt double %d5, %tolerance6
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end
  call void @Test.mark()
  %expected9 = load double, ptr %expected, align 8
  %tolerance10 = load double, ptr %tolerance, align 8
  %actual11 = load double, ptr %actual, align 8
  %9 = call i32 (ptr, ...) @printf(ptr @.str.5218, double %expected9, double %tolerance10, double %actual11)
  br label %if.end8

if.end8:                                          ; preds = %if.then7, %if.end
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

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare i32 @strcmp(ptr, ptr)

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
  %4 = call i32 @__polaron_test_should_run(ptr @.test.name.5320, ptr @.test.tags.5321)
  %sel3 = icmp ne i32 %4, 0
  %any4 = or i1 %any2, %sel3
  br i1 %any4, label %then, label %cont

then:                                             ; preds = %entry
  br label %cont

cont:                                             ; preds = %then, %entry
  %aborted = call i32 @__polaron_test_aborted()
  %5 = icmp eq i32 %aborted, 0
  %live = and i1 %sel, %5
  br i1 %live, label %then5, label %cont6

then5:                                            ; preds = %cont
  call void @__polaron_test_start(ptr @.test.name.5322, i32 0)
  %t0 = call i64 @__polaron_now_ns()
  %failcount = alloca i32, align 4
  store i32 0, ptr %failcount, align 4
  call void @Test.reset()
  call void @MathUtils.add_basic()
  %fails = call i32 @Test.failures()
  %failed = icmp ne i32 %fails, 0
  %6 = zext i1 %failed to i32
  %7 = load i32, ptr %failcount, align 4
  %8 = add i32 %7, %6
  store i32 %8, ptr %failcount, align 4
  %9 = load i32, ptr %failcount, align 4
  %anyfailed = icmp ne i32 %9, 0
  %t1 = call i64 @__polaron_now_ns()
  %ns = sub i64 %t1, %t0
  %skipped = call i32 @Test.wasSkipped()
  %10 = icmp ne i32 %skipped, 0
  %why = call ptr @Test.skipReason()
  %11 = call ptr @__polaron_str_cstr(ptr %why)
  %12 = select i1 %anyfailed, i32 1, i32 0
  %verdict = select i1 %10, i32 2, i32 %12
  call void @__polaron_test_record(ptr @.test.name.5322, i32 %verdict, i64 %ns, ptr %11, i64 0)
  br label %cont6

cont6:                                            ; preds = %then5, %cont
  %aborted7 = call i32 @__polaron_test_aborted()
  %13 = icmp eq i32 %aborted7, 0
  %live8 = and i1 %sel1, %13
  br i1 %live8, label %then9, label %cont10

then9:                                            ; preds = %cont6
  call void @__polaron_test_start(ptr @.test.name.5323, i32 0)
  %t011 = call i64 @__polaron_now_ns()
  %failcount12 = alloca i32, align 4
  store i32 0, ptr %failcount12, align 4
  call void @Test.reset()
  call void @MathUtils.predicates_and_tolerance()
  %fails13 = call i32 @Test.failures()
  %failed14 = icmp ne i32 %fails13, 0
  %14 = zext i1 %failed14 to i32
  %15 = load i32, ptr %failcount12, align 4
  %16 = add i32 %15, %14
  store i32 %16, ptr %failcount12, align 4
  %17 = load i32, ptr %failcount12, align 4
  %anyfailed15 = icmp ne i32 %17, 0
  %t116 = call i64 @__polaron_now_ns()
  %ns17 = sub i64 %t116, %t011
  %skipped18 = call i32 @Test.wasSkipped()
  %18 = icmp ne i32 %skipped18, 0
  %why19 = call ptr @Test.skipReason()
  %19 = call ptr @__polaron_str_cstr(ptr %why19)
  %20 = select i1 %anyfailed15, i32 1, i32 0
  %verdict20 = select i1 %18, i32 2, i32 %20
  call void @__polaron_test_record(ptr @.test.name.5323, i32 %verdict20, i64 %ns17, ptr %19, i64 0)
  br label %cont10

cont10:                                           ; preds = %then9, %cont6
  %aborted21 = call i32 @__polaron_test_aborted()
  %21 = icmp eq i32 %aborted21, 0
  %live22 = and i1 %sel3, %21
  br i1 %live22, label %then23, label %cont24

then23:                                           ; preds = %cont10
  call void @__polaron_test_start(ptr @.test.name.5324, i32 0)
  %t025 = call i64 @__polaron_now_ns()
  %failcount26 = alloca i32, align 4
  store i32 0, ptr %failcount26, align 4
  call void @Test.reset()
  %verdict27 = call i32 @MathUtils.still_boolean()
  %failed28 = icmp eq i32 %verdict27, 0
  %22 = zext i1 %failed28 to i32
  %23 = load i32, ptr %failcount26, align 4
  %24 = add i32 %23, %22
  store i32 %24, ptr %failcount26, align 4
  %25 = load i32, ptr %failcount26, align 4
  %anyfailed29 = icmp ne i32 %25, 0
  %t130 = call i64 @__polaron_now_ns()
  %ns31 = sub i64 %t130, %t025
  %skipped32 = call i32 @Test.wasSkipped()
  %26 = icmp ne i32 %skipped32, 0
  %why33 = call ptr @Test.skipReason()
  %27 = call ptr @__polaron_str_cstr(ptr %why33)
  %28 = select i1 %anyfailed29, i32 1, i32 0
  %verdict34 = select i1 %26, i32 2, i32 %28
  call void @__polaron_test_record(ptr @.test.name.5324, i32 %verdict34, i64 %ns31, ptr %27, i64 0)
  br label %cont24

cont24:                                           ; preds = %then23, %cont10
  br i1 %any4, label %then35, label %cont36

then35:                                           ; preds = %cont24
  br label %cont36

cont36:                                           ; preds = %then35, %cont24
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
