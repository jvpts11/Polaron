; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_class_load.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_class_load.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Palette.table = private global ptr null
@Palette.loads = private global i32 0
@Test.fails = private global i32 0
@Test.criterion = private global ptr null
@Test.skipping = private global i32 0
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [140 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_class_load.pol:30:17  in Palette.at\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [151 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_class_load.pol:23:38  in Palette.__onClassLoad\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata = private constant [29 x i8] c"onClassLoad ran exactly once\00"
@.strobj = private global %String { i64 28, ptr @.strdata, i64 0 }
@.strdata.4 = private constant [44 x i8] c"and it filled the table it is there to fill\00"
@.strobj.5 = private global %String { i64 43, ptr @.strdata.4, i64 0 }
@.strdata.5203 = private constant [1 x i8] zeroinitializer
@.strobj.5204 = private global %String { i64 0, ptr @.strdata.5203, i64 0 }
@.strdata.5205 = private constant [1 x i8] zeroinitializer
@.strobj.5206 = private global %String { i64 0, ptr @.strdata.5205, i64 0 }
@.str.5208 = private unnamed_addr constant [8 x i8] c"  [%s] \00", align 1
@.str.5209 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5210 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@.str.5211 = private unnamed_addr constant [21 x i8] c"expected %d, got %d\0A\00", align 1
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }
@.strdata.5318 = private constant [1 x i8] zeroinitializer
@.strobj.5319 = private global %String { i64 0, ptr @.strdata.5318, i64 0 }
@.test.name = private unnamed_addr constant [50 x i8] c"Loading.the_class_was_loaded_before_the_tests_ran\00", align 1
@.test.tags = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5323 = private unnamed_addr constant [50 x i8] c"Loading.the_class_was_loaded_before_the_tests_ran\00", align 1

define internal i32 @Palette.at(i32 %0) {
entry:
  %i = alloca i32, align 4
  store i32 %0, ptr %i, align 4
  %table = load ptr, ptr @Palette.table, align 8, !nonnull !0, !dereferenceable !1
  %i1 = load i32, ptr %i, align 4
  %1 = sext i32 %i1 to i64
  %arr.len = load i64, ptr %table, align 8
  %arr.oob = icmp uge i64 %1, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %1, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %table, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %1
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @Palette.loadCount() {
entry:
  %loads = load i32, ptr @Palette.loads, align 4
  ret i32 %loads
}

define internal void @Palette.__onClassLoad() {
entry:
  %i = alloca i32, align 4
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %0 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr @Palette.table, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok, %entry
  %i1 = load i32, ptr %i, align 4
  %1 = icmp slt i32 %i1, 8
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %table = load ptr, ptr @Palette.table, align 8, !nonnull !0, !dereferenceable !1
  %i2 = load i32, ptr %i, align 4
  %3 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %table, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  %loads = load i32, ptr @Palette.loads, align 4
  %4 = add i32 %loads, 1
  store i32 %4, ptr @Palette.loads, align 4
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %3, ptr @.failb.3, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data3 = getelementptr i8, ptr %table, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 %3
  %i4 = load i32, ptr %i, align 4
  %5 = mul i32 %i4, 11
  store i32 %5, ptr %arr.elem, align 4
  %i5 = load i32, ptr %i, align 4
  %6 = add i32 %i5, 1
  store i32 %6, ptr %i, align 4
  br label %while.cond
}

define internal void @Loading.the_class_was_loaded_before_the_tests_ran() {
entry:
  call void @Test.checking(ptr @.strobj)
  %0 = call i32 @Palette.loadCount()
  call void @Test.assertEqual(i32 %0, i32 1)
  call void @Test.checking(ptr @.strobj.5)
  %1 = call i32 @Palette.at(i32 0)
  call void @Test.assertEqual(i32 %1, i32 0)
  %2 = call i32 @Palette.at(i32 7)
  call void @Test.assertEqual(i32 %2, i32 77)
  ret void
}

define internal void @Test.reset() {
entry:
  store i32 0, ptr @Test.fails, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5204)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  store i32 0, ptr @Test.skipping, align 4
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5206)
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
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5208, ptr %data)
  br label %if.end

if.else:                                          ; preds = %entry
  %5 = call i32 (ptr, ...) @printf(ptr @.str.5209, ptr @.str.5210)
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
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5211, i32 %expected3, i32 %actual4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5317)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5319)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memset(ptr, i32, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i64 @__polaron_now_ns()

define i32 @main(i32 %0, ptr %1) {
entry:
  call void @__polaron_test_begin(i32 %0, ptr %1)
  call void @Palette.__onClassLoad()
  call void @Test.__onClassLoad()
  %2 = call i32 @__polaron_test_should_run(ptr @.test.name, ptr @.test.tags)
  %sel = icmp ne i32 %2, 0
  %any = or i1 false, %sel
  br i1 %any, label %then, label %cont

then:                                             ; preds = %entry
  br label %cont

cont:                                             ; preds = %then, %entry
  %aborted = call i32 @__polaron_test_aborted()
  %3 = icmp eq i32 %aborted, 0
  %live = and i1 %sel, %3
  br i1 %live, label %then1, label %cont2

then1:                                            ; preds = %cont
  call void @__polaron_test_start(ptr @.test.name.5323, i32 0)
  %t0 = call i64 @__polaron_now_ns()
  %failcount = alloca i32, align 4
  store i32 0, ptr %failcount, align 4
  call void @Test.reset()
  call void @Loading.the_class_was_loaded_before_the_tests_ran()
  %fails = call i32 @Test.failures()
  %failed = icmp ne i32 %fails, 0
  %4 = zext i1 %failed to i32
  %5 = load i32, ptr %failcount, align 4
  %6 = add i32 %5, %4
  store i32 %6, ptr %failcount, align 4
  %7 = load i32, ptr %failcount, align 4
  %anyfailed = icmp ne i32 %7, 0
  %t1 = call i64 @__polaron_now_ns()
  %ns = sub i64 %t1, %t0
  %skipped = call i32 @Test.wasSkipped()
  %8 = icmp ne i32 %skipped, 0
  %why = call ptr @Test.skipReason()
  %9 = call ptr @__polaron_str_cstr(ptr %why)
  %10 = select i1 %anyfailed, i32 1, i32 0
  %verdict = select i1 %8, i32 2, i32 %10
  call void @__polaron_test_record(ptr @.test.name.5323, i32 %verdict, i64 %ns, ptr %9, i64 0)
  br label %cont2

cont2:                                            ; preds = %then1, %cont
  br i1 %any, label %then3, label %cont4

then3:                                            ; preds = %cont2
  br label %cont4

cont4:                                            ; preds = %then3, %cont2
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

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
