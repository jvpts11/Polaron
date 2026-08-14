; ModuleID = 'C:\Users\jvpts\Documents\GitHub\LDP3\build2\tests\testcmd_app\src/main.pol'
source_filename = "C:\\Users\\jvpts\\Documents\\GitHub\\LDP3\\build2\\tests\\testcmd_app\\src/main.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private unnamed_addr global ptr null
@Test.skipWhy = private unnamed_addr global ptr null
@.strobj.5333 = private global %String { i64 0, ptr @.test.tags, i64 0 }
@.strdata.5334 = private constant [1 x i8] zeroinitializer
@.strobj.5335 = private global %String { i64 0, ptr @.strdata.5334, i64 0 }
@.strdata.5445 = private constant [1 x i8] zeroinitializer
@.strobj.5446 = private global %String { i64 0, ptr @.strdata.5445, i64 0 }
@.strdata.5447 = private constant [1 x i8] zeroinitializer
@.strobj.5448 = private global %String { i64 0, ptr @.strdata.5447, i64 0 }
@.test.tags = private constant [1 x i8] zeroinitializer, align 1
@.test.name.5452 = private unnamed_addr constant [13 x i8] c"Tests.passes\00", align 1

declare void @__polaron_str_free(ptr) local_unnamed_addr

declare ptr @__polaron_str_copy(ptr) local_unnamed_addr

declare i64 @__polaron_now_ns() local_unnamed_addr

define i32 @main(i32 %0, ptr %1) local_unnamed_addr {
entry:
  tail call void @__polaron_test_begin(i32 %0, ptr %1)
  %strcpy.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5446)
  %2 = load ptr, ptr @Test.criterion, align 8
  tail call void @__polaron_str_free(ptr %2)
  store ptr %strcpy.i, ptr @Test.criterion, align 8
  %strcpy1.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5448)
  %3 = load ptr, ptr @Test.skipWhy, align 8
  tail call void @__polaron_str_free(ptr %3)
  store ptr %strcpy1.i, ptr @Test.skipWhy, align 8
  %4 = tail call i32 @__polaron_test_should_run(ptr nonnull @.test.name.5452, ptr nonnull @.test.tags)
  %sel = icmp ne i32 %4, 0
  %aborted = tail call i32 @__polaron_test_aborted()
  %5 = icmp eq i32 %aborted, 0
  %live = and i1 %sel, %5
  br i1 %live, label %then1, label %cont2

then1:                                            ; preds = %entry
  tail call void @__polaron_test_start(ptr nonnull @.test.name.5452, i32 0)
  %t0 = tail call i64 @__polaron_now_ns()
  %strcpy.i6 = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5333)
  %6 = load ptr, ptr @Test.criterion, align 8
  tail call void @__polaron_str_free(ptr %6)
  store ptr %strcpy.i6, ptr @Test.criterion, align 8
  %strcpy1.i7 = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5335)
  %7 = load ptr, ptr @Test.skipWhy, align 8
  tail call void @__polaron_str_free(ptr %7)
  store ptr %strcpy1.i7, ptr @Test.skipWhy, align 8
  %t1 = tail call i64 @__polaron_now_ns()
  %ns = sub i64 %t1, %t0
  %skipWhy.i = load ptr, ptr @Test.skipWhy, align 8
  %strcpy.i8 = tail call ptr @__polaron_str_copy(ptr %skipWhy.i)
  %8 = tail call ptr @__polaron_str_cstr(ptr %strcpy.i8)
  tail call void @__polaron_test_record(ptr nonnull @.test.name.5452, i32 0, i64 %ns, ptr %8, i64 0)
  br label %cont2

cont2:                                            ; preds = %then1, %entry
  %rc = tail call i32 @__polaron_test_summary()
  ret i32 %rc
}

declare void @__polaron_test_begin(i32, ptr) local_unnamed_addr

declare i32 @__polaron_test_should_run(ptr, ptr) local_unnamed_addr

declare void @__polaron_test_start(ptr, i32) local_unnamed_addr

declare void @__polaron_test_record(ptr, i32, i64, ptr, i64) local_unnamed_addr

declare i32 @__polaron_test_summary() local_unnamed_addr

declare ptr @__polaron_str_cstr(ptr) local_unnamed_addr

declare i32 @__polaron_test_aborted() local_unnamed_addr
