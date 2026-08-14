; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_lifecycle.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_lifecycle.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.DivideByZeroException = type { ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Census.cells = private global ptr null
@Census.scratch = private global ptr null
@Census.builds = private global i32 0
@Census.setups = private global i32 0
@Test.fails = private global i32 0
@Test.criterion = private global ptr null
@Test.skipping = private global i32 0
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [146 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_lifecycle.pol:29:37  in Census.buildWorld\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata = private constant [40 x i8] c"the class fixture is built exactly once\00"
@.strobj = private global %String { i64 39, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [33 x i8] c"every cell holds a value in 0..6\00"
@.strobj.2 = private global %String { i64 32, ptr @.strdata.1, i64 0 }
@.fail.3 = private unnamed_addr constant [155 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_lifecycle.pol:69:39  in Census.values_stay_in_band\0A\00", align 1
@.faila.4 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.6 = private unnamed_addr constant [155 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_lifecycle.pol:70:27  in Census.values_stay_in_band\0A\00", align 1
@.faila.7 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.8 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.9 = private constant [21 x i8] c"the mean sits near 3\00"
@.strobj.10 = private global %String { i64 20, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [47 x i8] c"[Setup] gives each test a fresh scratch buffer\00"
@.strobj.12 = private global %String { i64 46, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [44 x i8] c"needs a 4096-cell world; this fixture is 64\00"
@.strobj.14 = private global %String { i64 43, ptr @.strdata.13, i64 0 }
@.strdata.15 = private constant [46 x i8] c"the guard above should have skipped this test\00"
@.strobj.16 = private global %String { i64 45, ptr @.strdata.15, i64 0 }
@.strdata.19 = private constant [31 x i8] c"two equal arrays compare equal\00"
@.strobj.20 = private global %String { i64 30, ptr @.strdata.19, i64 0 }
@.fail.21 = private unnamed_addr constant [156 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_lifecycle.pol:124:26  in Arithmetic.arrays_and_text\0A\00", align 1
@.faila.22 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.23 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.24 = private unnamed_addr constant [156 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_lifecycle.pol:125:26  in Arithmetic.arrays_and_text\0A\00", align 1
@.faila.25 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.26 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.27 = private constant [25 x i8] c"substring and inequality\00"
@.strobj.28 = private global %String { i64 24, ptr @.strdata.27, i64 0 }
@.strdata.29 = private constant [27 x i8] c"mountain share out of band\00"
@.strobj.30 = private global %String { i64 26, ptr @.strdata.29, i64 0 }
@.strdata.31 = private constant [6 x i8] c"share\00"
@.strobj.32 = private global %String { i64 5, ptr @.strdata.31, i64 0 }
@.strdata.1342 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1343 = private global %String { i64 16, ptr @.strdata.1342, i64 0 }
@.strdata.1344 = private constant [17 x i8] c"division by zero\00"
@.strobj.1345 = private global %String { i64 16, ptr @.strdata.1344, i64 0 }
@.strdata.5230 = private constant [1 x i8] zeroinitializer
@.strobj.5231 = private global %String { i64 0, ptr @.strdata.5230, i64 0 }
@.strdata.5232 = private constant [1 x i8] zeroinitializer
@.strobj.5233 = private global %String { i64 0, ptr @.strdata.5232, i64 0 }
@.str.5234 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5235 = private unnamed_addr constant [8 x i8] c"  [%s] \00", align 1
@.str.5236 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5237 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@.str.5238 = private unnamed_addr constant [21 x i8] c"expected %d, got %d\0A\00", align 1
@.str.5239 = private unnamed_addr constant [26 x i8] c"expected anything but %d\0A\00", align 1
@.str.5246 = private unnamed_addr constant [25 x i8] c"expected %d..%d, got %d\0A\00", align 1
@.str.5247 = private unnamed_addr constant [30 x i8] c"expected at least %d, got %d\0A\00", align 1
@.str.5248 = private unnamed_addr constant [29 x i8] c"expected at most %d, got %d\0A\00", align 1
@.str.5251 = private unnamed_addr constant [42 x i8] c"expected %f within %f (relative), got %f\0A\00", align 1
@.str.5252 = private unnamed_addr constant [32 x i8] c"expected to contain %s, got %s\0A\00", align 1
@.str.5259 = private unnamed_addr constant [30 x i8] c"expected %d elements, got %d\0A\00", align 1
@.fail.5260 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9522:21  in Test.assertEqualIntArray\0A\00", align 1
@.faila.5261 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5262 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5263 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9522:21  in Test.assertEqualIntArray\0A\00", align 1
@.faila.5264 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5265 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.5266 = private unnamed_addr constant [42 x i8] c"differs at index %d: expected %d, got %d\0A\00", align 1
@.fail.5267 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9524:49  in Test.assertEqualIntArray\0A\00", align 1
@.faila.5268 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5269 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5270 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9524:49  in Test.assertEqualIntArray\0A\00", align 1
@.faila.5271 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5272 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5343 = private constant [1 x i8] zeroinitializer
@.strobj.5344 = private global %String { i64 0, ptr @.strdata.5343, i64 0 }
@.strdata.5345 = private constant [1 x i8] zeroinitializer
@.strobj.5346 = private global %String { i64 0, ptr @.strdata.5345, i64 0 }
@.test.name = private unnamed_addr constant [26 x i8] c"Census.fixture_built_once\00", align 1
@.test.tags = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5350 = private unnamed_addr constant [27 x i8] c"Census.values_stay_in_band\00", align 1
@.test.tags.5351 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5352 = private unnamed_addr constant [31 x i8] c"Census.setup_ran_for_this_test\00", align 1
@.test.tags.5353 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5354 = private unnamed_addr constant [28 x i8] c"Census.needs_a_bigger_world\00", align 1
@.test.tags.5355 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5356 = private unnamed_addr constant [22 x i8] c"Census.forest_regrows\00", align 1
@.test.tags.5357 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5358 = private unnamed_addr constant [32 x i8] c"Census.boolean_form_still_works\00", align 1
@.test.tags.5359 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5360 = private unnamed_addr constant [26 x i8] c"Census.fixture_built_once\00", align 1
@.test.name.5361 = private unnamed_addr constant [27 x i8] c"Census.values_stay_in_band\00", align 1
@.test.name.5362 = private unnamed_addr constant [31 x i8] c"Census.setup_ran_for_this_test\00", align 1
@.test.name.5363 = private unnamed_addr constant [28 x i8] c"Census.needs_a_bigger_world\00", align 1
@.test.name.5364 = private unnamed_addr constant [22 x i8] c"Census.forest_regrows\00", align 1
@.test.why = private unnamed_addr constant [32 x i8] c"regrowth is not implemented yet\00", align 1
@.test.name.5365 = private unnamed_addr constant [32 x i8] c"Census.boolean_form_still_works\00", align 1
@.test.name.5366 = private unnamed_addr constant [27 x i8] c"Arithmetic.arrays_and_text\00", align 1
@.test.tags.5367 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5368 = private unnamed_addr constant [27 x i8] c"Arithmetic.arrays_and_text\00", align 1

define internal void @Census.buildWorld() personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %arr = call ptr @__polaron_malloc(i64 264)
  store i64 64, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %0 = call ptr @memset(ptr %arr.data, i32 0, i64 256)
  store ptr %arr, ptr @Census.cells, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok, %entry
  %i1 = load i32, ptr %i, align 4
  %1 = icmp slt i32 %i1, 64
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %cells = load ptr, ptr @Census.cells, align 8, !nonnull !0, !dereferenceable !1
  %i2 = load i32, ptr %i, align 4
  %3 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %cells, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  %builds = load i32, ptr @Census.builds, align 4
  %4 = add i32 %builds, 1
  store i32 %4, ptr @Census.builds, align 4
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %3, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data3 = getelementptr i8, ptr %cells, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 %3
  %i4 = load i32, ptr %i, align 4
  %5 = icmp eq i32 %i4, -2147483648
  %6 = and i1 %5, false
  %7 = or i1 false, %6
  br i1 %7, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %8 = srem i32 %i4, 7
  store i32 %8, ptr %arr.elem, align 4
  %i5 = load i32, ptr %i, align 4
  %9 = add i32 %i5, 1
  store i32 %9, ptr %i, align 4
  br label %while.cond
}

define internal void @Census.dropWorld() {
entry:
  %cells = load ptr, ptr @Census.cells, align 8
  call void @__polaron_free(ptr %cells)
  ret void
}

define internal void @Census.openScratch() {
entry:
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %0 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr @Census.scratch, align 8
  %setups = load i32, ptr @Census.setups, align 4
  %1 = add i32 %setups, 1
  store i32 %1, ptr @Census.setups, align 4
  ret void
}

define internal void @Census.closeScratch() {
entry:
  %scratch = load ptr, ptr @Census.scratch, align 8
  call void @__polaron_free(ptr %scratch)
  ret void
}

define internal void @Census.fixture_built_once() {
entry:
  call void @Test.checking(ptr @.strobj)
  %builds = load i32, ptr @Census.builds, align 4
  call void @Test.assertEqual(i32 %builds, i32 1)
  %cells = load ptr, ptr @Census.cells, align 8
  %len = load i64, ptr %cells, align 8
  %0 = trunc i64 %len to i32
  call void @Test.assertEqual(i32 %0, i32 64)
  ret void
}

define internal void @Census.values_stay_in_band() {
entry:
  %total = alloca i32, align 4
  %i = alloca i32, align 4
  call void @Test.checking(ptr @.strobj.2)
  store i32 0, ptr %i, align 4
  store i32 0, ptr %total, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok10, %entry
  %i1 = load i32, ptr %i, align 4
  %cells = load ptr, ptr @Census.cells, align 8
  %len = load i64, ptr %cells, align 8
  %0 = trunc i64 %len to i32
  %1 = icmp slt i32 %i1, %0
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %cells2 = load ptr, ptr @Census.cells, align 8, !nonnull !0, !dereferenceable !1
  %i3 = load i32, ptr %i, align 4
  %3 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %cells2, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  call void @Test.checking(ptr @.strobj.10)
  %total15 = load i32, ptr %total, align 4
  %4 = sitofp i32 %total15 to double
  %5 = fdiv double %4, 6.400000e+01
  call void @Test.assertNear(double %5, double 3.000000e+00, double 1.000000e-01)
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.3, ptr @.faila.4, i64 %3, ptr @.failb.5, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %cells2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %3
  %elem = load i32, ptr %arr.elem, align 4
  call void @Test.assertBetween(i32 %elem, i32 0, i32 6)
  %total4 = load i32, ptr %total, align 4
  %cells5 = load ptr, ptr @Census.cells, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %6 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %cells5, align 8
  %arr.oob8 = icmp uge i64 %6, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.6, ptr @.faila.7, i64 %6, ptr @.failb.8, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %cells5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %6
  %elem13 = load i32, ptr %arr.elem12, align 4
  %7 = add i32 %total4, %elem13
  store i32 %7, ptr %total, align 4
  %i14 = load i32, ptr %i, align 4
  %8 = add i32 %i14, 1
  store i32 %8, ptr %i, align 4
  br label %while.cond
}

define internal void @Census.setup_ran_for_this_test() {
entry:
  call void @Test.checking(ptr @.strobj.12)
  %scratch = load ptr, ptr @Census.scratch, align 8
  %len = load i64, ptr %scratch, align 8
  %0 = trunc i64 %len to i32
  call void @Test.assertEqual(i32 %0, i32 8)
  %setups = load i32, ptr @Census.setups, align 4
  call void @Test.assertAtLeast(i32 %setups, i32 1)
  %builds = load i32, ptr @Census.builds, align 4
  call void @Test.assertAtMost(i32 %builds, i32 1)
  ret void
}

define internal void @Census.needs_a_bigger_world() {
entry:
  %cells = load ptr, ptr @Census.cells, align 8
  %len = load i64, ptr %cells, align 8
  %0 = trunc i64 %len to i32
  %1 = icmp slt i32 %0, 4096
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.skip(ptr @.strobj.14)
  ret void

if.end:                                           ; preds = %entry
  call void @Test.fail(ptr @.strobj.16)
  ret void
}

define internal i32 @Census.boolean_form_still_works() {
entry:
  %cells = load ptr, ptr @Census.cells, align 8
  %len = load i64, ptr %cells, align 8
  %0 = trunc i64 %len to i32
  %1 = icmp eq i32 %0, 64
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @Arithmetic.arrays_and_text() {
entry:
  %i = alloca i32, align 4
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  call void @Test.checking(ptr @.strobj.20)
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %0 = call ptr @memset(ptr %arr.data, i32 0, i64 12)
  store ptr %arr, ptr %a, align 8
  %arr1 = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr1, align 8
  %arr.data2 = getelementptr i8, ptr %arr1, i64 8
  %1 = call ptr @memset(ptr %arr.data2, i32 0, i64 12)
  store ptr %arr1, ptr %b, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok13, %entry
  %i3 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %i3, 3
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %a4 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %a4, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  %a18 = load ptr, ptr %a, align 8
  %b19 = load ptr, ptr %b, align 8
  call void @Test.assertEqualIntArray(ptr %a18, ptr %b19)
  %a20 = load ptr, ptr %a, align 8
  call void @__polaron_free(ptr %a20)
  %b21 = load ptr, ptr %b, align 8
  call void @__polaron_free(ptr %b21)
  call void @Test.checking(ptr @.strobj.28)
  call void @Test.assertContains(ptr @.strobj.30, ptr @.strobj.32)
  call void @Test.assertNotEqual(i32 7, i32 8)
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.21, ptr @.faila.22, i64 %4, ptr @.failb.23, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data6 = getelementptr i8, ptr %a4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data6, i64 %4
  %i7 = load i32, ptr %i, align 4
  %5 = mul i32 %i7, 2
  store i32 %5, ptr %arr.elem, align 4
  %b8 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %i9 = load i32, ptr %i, align 4
  %6 = sext i32 %i9 to i64
  %arr.len10 = load i64, ptr %b8, align 8
  %arr.oob11 = icmp uge i64 %6, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !2

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.24, ptr @.faila.25, i64 %6, ptr @.failb.26, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %b8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %6
  %i16 = load i32, ptr %i, align 4
  %7 = mul i32 %i16, 2
  store i32 %7, ptr %arr.elem15, align 4
  %i17 = load i32, ptr %i, align 4
  %8 = add i32 %i17, 1
  store i32 %8, ptr %i, align 4
  br label %while.cond
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal void @Exception.Exception(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  ret void
}

define internal void @ArithmeticException.ArithmeticException(ptr %0) {
entry:
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ArithmeticException, ptr %0, i32 0, i32 0
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1343)
  ret ptr %strcpy
}

define internal void @DivideByZeroException.DivideByZeroException(ptr %0) {
entry:
  call void @ArithmeticException.ArithmeticException(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DivideByZeroException, ptr %0, i32 0, i32 0
  store ptr @DivideByZeroException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @DivideByZeroException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1345)
  ret ptr %strcpy
}

define internal void @Test.reset() {
entry:
  store i32 0, ptr @Test.fails, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5231)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  store i32 0, ptr @Test.skipping, align 4
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5233)
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

define internal void @Test.skip(ptr %0) {
entry:
  %why = alloca ptr, align 8
  store ptr %0, ptr %why, align 8
  store i32 1, ptr @Test.skipping, align 4
  %why1 = load ptr, ptr %why, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %why1)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy, ptr @Test.skipWhy, align 8
  ret void
}

define internal void @Test.fail(ptr %0) {
entry:
  %why = alloca ptr, align 8
  store ptr %0, ptr %why, align 8
  call void @Test.mark()
  %why1 = load ptr, ptr %why, align 8
  %str.data = getelementptr inbounds %String, ptr %why1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %1 = call i32 (ptr, ...) @printf(ptr @.str.5234, ptr %data)
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
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5235, ptr %data)
  br label %if.end

if.else:                                          ; preds = %entry
  %5 = call i32 (ptr, ...) @printf(ptr @.str.5236, ptr @.str.5237)
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
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5238, i32 %expected3, i32 %actual4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertNotEqual(i32 %0, i32 %1) {
entry:
  %unexpected = alloca i32, align 4
  %actual = alloca i32, align 4
  store i32 %0, ptr %actual, align 4
  store i32 %1, ptr %unexpected, align 4
  %actual1 = load i32, ptr %actual, align 4
  %unexpected2 = load i32, ptr %unexpected, align 4
  %2 = icmp eq i32 %actual1, %unexpected2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %unexpected3 = load i32, ptr %unexpected, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5239, i32 %unexpected3)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertBetween(i32 %0, i32 %1, i32 %2) {
entry:
  %high = alloca i32, align 4
  %low = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %0, ptr %value, align 4
  store i32 %1, ptr %low, align 4
  store i32 %2, ptr %high, align 4
  %value1 = load i32, ptr %value, align 4
  %low2 = load i32, ptr %low, align 4
  %3 = icmp slt i32 %value1, %low2
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %value3 = load i32, ptr %value, align 4
  %high4 = load i32, ptr %high, align 4
  %5 = icmp sgt i32 %value3, %high4
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  call void @Test.mark()
  %low5 = load i32, ptr %low, align 4
  %high6 = load i32, ptr %high, align 4
  %value7 = load i32, ptr %value, align 4
  %8 = call i32 (ptr, ...) @printf(ptr @.str.5246, i32 %low5, i32 %high6, i32 %value7)
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  ret void
}

define internal void @Test.assertAtLeast(i32 %0, i32 %1) {
entry:
  %minimum = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %0, ptr %value, align 4
  store i32 %1, ptr %minimum, align 4
  %value1 = load i32, ptr %value, align 4
  %minimum2 = load i32, ptr %minimum, align 4
  %2 = icmp slt i32 %value1, %minimum2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %minimum3 = load i32, ptr %minimum, align 4
  %value4 = load i32, ptr %value, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5247, i32 %minimum3, i32 %value4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertAtMost(i32 %0, i32 %1) {
entry:
  %maximum = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %0, ptr %value, align 4
  store i32 %1, ptr %maximum, align 4
  %value1 = load i32, ptr %value, align 4
  %maximum2 = load i32, ptr %maximum, align 4
  %2 = icmp sgt i32 %value1, %maximum2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %maximum3 = load i32, ptr %maximum, align 4
  %value4 = load i32, ptr %value, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5248, i32 %maximum3, i32 %value4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertNear(double %0, double %1, double %2) {
entry:
  %d = alloca double, align 8
  %allowed = alloca double, align 8
  %scale = alloca double, align 8
  %relativeTolerance = alloca double, align 8
  %expected = alloca double, align 8
  %actual = alloca double, align 8
  store double %0, ptr %actual, align 8
  store double %1, ptr %expected, align 8
  store double %2, ptr %relativeTolerance, align 8
  %expected1 = load double, ptr %expected, align 8
  store double %expected1, ptr %scale, align 8
  %scale2 = load double, ptr %scale, align 8
  %3 = fcmp olt double %scale2, 0.000000e+00
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %scale3 = load double, ptr %scale, align 8
  %5 = fsub double 0.000000e+00, %scale3
  store double %5, ptr %scale, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %relativeTolerance4 = load double, ptr %relativeTolerance, align 8
  %scale5 = load double, ptr %scale, align 8
  %6 = fmul double %relativeTolerance4, %scale5
  store double %6, ptr %allowed, align 8
  %scale6 = load double, ptr %scale, align 8
  %7 = fcmp oeq double %scale6, 0.000000e+00
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end
  %relativeTolerance9 = load double, ptr %relativeTolerance, align 8
  store double %relativeTolerance9, ptr %allowed, align 8
  br label %if.end8

if.end8:                                          ; preds = %if.then7, %if.end
  %actual10 = load double, ptr %actual, align 8
  %expected11 = load double, ptr %expected, align 8
  %9 = fsub double %actual10, %expected11
  store double %9, ptr %d, align 8
  %d12 = load double, ptr %d, align 8
  %10 = fcmp olt double %d12, 0.000000e+00
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then13, label %if.end14

if.then13:                                        ; preds = %if.end8
  %d15 = load double, ptr %d, align 8
  %12 = fsub double 0.000000e+00, %d15
  store double %12, ptr %d, align 8
  br label %if.end14

if.end14:                                         ; preds = %if.then13, %if.end8
  %d16 = load double, ptr %d, align 8
  %allowed17 = load double, ptr %allowed, align 8
  %13 = fcmp ogt double %d16, %allowed17
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then18, label %if.end19

if.then18:                                        ; preds = %if.end14
  call void @Test.mark()
  %expected20 = load double, ptr %expected, align 8
  %relativeTolerance21 = load double, ptr %relativeTolerance, align 8
  %actual22 = load double, ptr %actual, align 8
  %15 = call i32 (ptr, ...) @printf(ptr @.str.5251, double %expected20, double %relativeTolerance21, double %actual22)
  br label %if.end19

if.end19:                                         ; preds = %if.then18, %if.end14
  ret void
}

define internal void @Test.assertContains(ptr %0, ptr %1) {
entry:
  %needle = alloca ptr, align 8
  %haystack = alloca ptr, align 8
  store ptr %0, ptr %haystack, align 8
  store ptr %1, ptr %needle, align 8
  %haystack1 = load ptr, ptr %haystack, align 8
  %needle2 = load ptr, ptr %needle, align 8
  %str.data = getelementptr inbounds %String, ptr %haystack1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %haystack1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.data3 = getelementptr inbounds %String, ptr %needle2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %str.len5 = getelementptr inbounds %String, ptr %needle2, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %2 = call i64 @__polaron_str_index(ptr %data, i64 %len, ptr %data4, i64 %len6)
  %3 = icmp sge i64 %2, 0
  %4 = zext i1 %3 to i32
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %needle7 = load ptr, ptr %needle, align 8
  %str.data8 = getelementptr inbounds %String, ptr %needle7, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %haystack10 = load ptr, ptr %haystack, align 8
  %str.data11 = getelementptr inbounds %String, ptr %haystack10, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %7 = call i32 (ptr, ...) @printf(ptr @.str.5252, ptr %data9, ptr %data12)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertEqualIntArray(ptr %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %expected = alloca ptr, align 8
  %actual = alloca ptr, align 8
  store ptr %0, ptr %actual, align 8
  store ptr %1, ptr %expected, align 8
  %actual1 = load ptr, ptr %actual, align 8
  %len = load i64, ptr %actual1, align 8
  %2 = trunc i64 %len to i32
  %expected2 = load ptr, ptr %expected, align 8
  %len3 = load i64, ptr %expected2, align 8
  %3 = trunc i64 %len3 to i32
  %4 = icmp ne i32 %2, %3
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected4 = load ptr, ptr %expected, align 8
  %len5 = load i64, ptr %expected4, align 8
  %6 = trunc i64 %len5 to i32
  %actual6 = load ptr, ptr %actual, align 8
  %len7 = load i64, ptr %actual6, align 8
  %7 = trunc i64 %len7 to i32
  %8 = call i32 (ptr, ...) @printf(ptr @.str.5259, i32 %6, i32 %7)
  ret void

if.end:                                           ; preds = %entry
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end23, %if.end
  %i8 = load i32, ptr %i, align 4
  %actual9 = load ptr, ptr %actual, align 8
  %len10 = load i64, ptr %actual9, align 8
  %9 = trunc i64 %len10 to i32
  %10 = icmp slt i32 %i8, %9
  %11 = zext i1 %10 to i32
  br i1 %10, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %actual11 = load ptr, ptr %actual, align 8, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %12 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %actual11, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.5260, ptr @.faila.5261, i64 %12, ptr @.failb.5262, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %actual11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %12
  %elem = load i32, ptr %arr.elem, align 4
  %expected13 = load ptr, ptr %expected, align 8, !nonnull !0, !dereferenceable !1
  %i14 = load i32, ptr %i, align 4
  %13 = sext i32 %i14 to i64
  %arr.len15 = load i64, ptr %expected13, align 8
  %arr.oob16 = icmp uge i64 %13, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5263, ptr @.faila.5264, i64 %13, ptr @.failb.5265, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok
  %arr.data19 = getelementptr i8, ptr %expected13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %13
  %elem21 = load i32, ptr %arr.elem20, align 4
  %14 = icmp ne i32 %elem, %elem21
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then22, label %if.end23

if.then22:                                        ; preds = %idx.ok18
  call void @Test.mark()
  %i24 = load i32, ptr %i, align 4
  %expected25 = load ptr, ptr %expected, align 8, !nonnull !0, !dereferenceable !1
  %i26 = load i32, ptr %i, align 4
  %16 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %expected25, align 8
  %arr.oob28 = icmp uge i64 %16, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !2

if.end23:                                         ; preds = %idx.ok18
  %i43 = load i32, ptr %i, align 4
  %17 = add i32 %i43, 1
  store i32 %17, ptr %i, align 4
  br label %while.cond

idx.bad29:                                        ; preds = %if.then22
  call void @__polaron_fail(ptr @.fail.5267, ptr @.faila.5268, i64 %16, ptr @.failb.5269, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then22
  %arr.data31 = getelementptr i8, ptr %expected25, i64 8
  %arr.elem32 = getelementptr inbounds i32, ptr %arr.data31, i64 %16
  %elem33 = load i32, ptr %arr.elem32, align 4
  %actual34 = load ptr, ptr %actual, align 8, !nonnull !0, !dereferenceable !1
  %i35 = load i32, ptr %i, align 4
  %18 = sext i32 %i35 to i64
  %arr.len36 = load i64, ptr %actual34, align 8
  %arr.oob37 = icmp uge i64 %18, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad38:                                        ; preds = %idx.ok30
  call void @__polaron_fail(ptr @.fail.5270, ptr @.faila.5271, i64 %18, ptr @.failb.5272, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok30
  %arr.data40 = getelementptr i8, ptr %actual34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %18
  %elem42 = load i32, ptr %arr.elem41, align 4
  %19 = call i32 (ptr, ...) @printf(ptr @.str.5266, i32 %i24, i32 %elem33, i32 %elem42)
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5344)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5346)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare void @__polaron_free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i64 @__polaron_str_index(ptr, i64, ptr, i64)

declare i64 @__polaron_now_ns()

define i32 @main(i32 %0, ptr %1) {
entry:
  call void @__polaron_test_begin(i32 %0, ptr %1)
  call void @Test.__onClassLoad()
  %2 = call i32 @__polaron_test_should_run(ptr @.test.name, ptr @.test.tags)
  %sel = icmp ne i32 %2, 0
  %any = or i1 false, %sel
  %3 = call i32 @__polaron_test_should_run(ptr @.test.name.5350, ptr @.test.tags.5351)
  %sel1 = icmp ne i32 %3, 0
  %any2 = or i1 %any, %sel1
  %4 = call i32 @__polaron_test_should_run(ptr @.test.name.5352, ptr @.test.tags.5353)
  %sel3 = icmp ne i32 %4, 0
  %any4 = or i1 %any2, %sel3
  %5 = call i32 @__polaron_test_should_run(ptr @.test.name.5354, ptr @.test.tags.5355)
  %sel5 = icmp ne i32 %5, 0
  %any6 = or i1 %any4, %sel5
  %6 = call i32 @__polaron_test_should_run(ptr @.test.name.5356, ptr @.test.tags.5357)
  %sel7 = icmp ne i32 %6, 0
  %any8 = or i1 %any6, %sel7
  %7 = call i32 @__polaron_test_should_run(ptr @.test.name.5358, ptr @.test.tags.5359)
  %sel9 = icmp ne i32 %7, 0
  %any10 = or i1 %any8, %sel9
  br i1 %any10, label %then, label %cont

then:                                             ; preds = %entry
  call void @Census.buildWorld()
  br label %cont

cont:                                             ; preds = %then, %entry
  %aborted = call i32 @__polaron_test_aborted()
  %8 = icmp eq i32 %aborted, 0
  %live = and i1 %sel, %8
  br i1 %live, label %then11, label %cont12

then11:                                           ; preds = %cont
  call void @__polaron_test_start(ptr @.test.name.5360, i32 0)
  %t0 = call i64 @__polaron_now_ns()
  %failcount = alloca i32, align 4
  store i32 0, ptr %failcount, align 4
  call void @Test.reset()
  call void @Census.openScratch()
  call void @Census.fixture_built_once()
  %fails = call i32 @Test.failures()
  %failed = icmp ne i32 %fails, 0
  call void @Census.closeScratch()
  %9 = zext i1 %failed to i32
  %10 = load i32, ptr %failcount, align 4
  %11 = add i32 %10, %9
  store i32 %11, ptr %failcount, align 4
  %12 = load i32, ptr %failcount, align 4
  %anyfailed = icmp ne i32 %12, 0
  %t1 = call i64 @__polaron_now_ns()
  %ns = sub i64 %t1, %t0
  %skipped = call i32 @Test.wasSkipped()
  %13 = icmp ne i32 %skipped, 0
  %why = call ptr @Test.skipReason()
  %14 = call ptr @__polaron_str_cstr(ptr %why)
  %15 = select i1 %anyfailed, i32 1, i32 0
  %verdict = select i1 %13, i32 2, i32 %15
  call void @__polaron_test_record(ptr @.test.name.5360, i32 %verdict, i64 %ns, ptr %14, i64 0)
  br label %cont12

cont12:                                           ; preds = %then11, %cont
  %aborted13 = call i32 @__polaron_test_aborted()
  %16 = icmp eq i32 %aborted13, 0
  %live14 = and i1 %sel1, %16
  br i1 %live14, label %then15, label %cont16

then15:                                           ; preds = %cont12
  call void @__polaron_test_start(ptr @.test.name.5361, i32 0)
  %t017 = call i64 @__polaron_now_ns()
  %failcount18 = alloca i32, align 4
  store i32 0, ptr %failcount18, align 4
  call void @Test.reset()
  call void @Census.openScratch()
  call void @Census.values_stay_in_band()
  %fails19 = call i32 @Test.failures()
  %failed20 = icmp ne i32 %fails19, 0
  call void @Census.closeScratch()
  %17 = zext i1 %failed20 to i32
  %18 = load i32, ptr %failcount18, align 4
  %19 = add i32 %18, %17
  store i32 %19, ptr %failcount18, align 4
  %20 = load i32, ptr %failcount18, align 4
  %anyfailed21 = icmp ne i32 %20, 0
  %t122 = call i64 @__polaron_now_ns()
  %ns23 = sub i64 %t122, %t017
  %skipped24 = call i32 @Test.wasSkipped()
  %21 = icmp ne i32 %skipped24, 0
  %why25 = call ptr @Test.skipReason()
  %22 = call ptr @__polaron_str_cstr(ptr %why25)
  %23 = select i1 %anyfailed21, i32 1, i32 0
  %verdict26 = select i1 %21, i32 2, i32 %23
  call void @__polaron_test_record(ptr @.test.name.5361, i32 %verdict26, i64 %ns23, ptr %22, i64 0)
  br label %cont16

cont16:                                           ; preds = %then15, %cont12
  %aborted27 = call i32 @__polaron_test_aborted()
  %24 = icmp eq i32 %aborted27, 0
  %live28 = and i1 %sel3, %24
  br i1 %live28, label %then29, label %cont30

then29:                                           ; preds = %cont16
  call void @__polaron_test_start(ptr @.test.name.5362, i32 0)
  %t031 = call i64 @__polaron_now_ns()
  %failcount32 = alloca i32, align 4
  store i32 0, ptr %failcount32, align 4
  call void @Test.reset()
  call void @Census.openScratch()
  call void @Census.setup_ran_for_this_test()
  %fails33 = call i32 @Test.failures()
  %failed34 = icmp ne i32 %fails33, 0
  call void @Census.closeScratch()
  %25 = zext i1 %failed34 to i32
  %26 = load i32, ptr %failcount32, align 4
  %27 = add i32 %26, %25
  store i32 %27, ptr %failcount32, align 4
  %28 = load i32, ptr %failcount32, align 4
  %anyfailed35 = icmp ne i32 %28, 0
  %t136 = call i64 @__polaron_now_ns()
  %ns37 = sub i64 %t136, %t031
  %skipped38 = call i32 @Test.wasSkipped()
  %29 = icmp ne i32 %skipped38, 0
  %why39 = call ptr @Test.skipReason()
  %30 = call ptr @__polaron_str_cstr(ptr %why39)
  %31 = select i1 %anyfailed35, i32 1, i32 0
  %verdict40 = select i1 %29, i32 2, i32 %31
  call void @__polaron_test_record(ptr @.test.name.5362, i32 %verdict40, i64 %ns37, ptr %30, i64 0)
  br label %cont30

cont30:                                           ; preds = %then29, %cont16
  %aborted41 = call i32 @__polaron_test_aborted()
  %32 = icmp eq i32 %aborted41, 0
  %live42 = and i1 %sel5, %32
  br i1 %live42, label %then43, label %cont44

then43:                                           ; preds = %cont30
  call void @__polaron_test_start(ptr @.test.name.5363, i32 0)
  %t045 = call i64 @__polaron_now_ns()
  %failcount46 = alloca i32, align 4
  store i32 0, ptr %failcount46, align 4
  call void @Test.reset()
  call void @Census.openScratch()
  call void @Census.needs_a_bigger_world()
  %fails47 = call i32 @Test.failures()
  %failed48 = icmp ne i32 %fails47, 0
  call void @Census.closeScratch()
  %33 = zext i1 %failed48 to i32
  %34 = load i32, ptr %failcount46, align 4
  %35 = add i32 %34, %33
  store i32 %35, ptr %failcount46, align 4
  %36 = load i32, ptr %failcount46, align 4
  %anyfailed49 = icmp ne i32 %36, 0
  %t150 = call i64 @__polaron_now_ns()
  %ns51 = sub i64 %t150, %t045
  %skipped52 = call i32 @Test.wasSkipped()
  %37 = icmp ne i32 %skipped52, 0
  %why53 = call ptr @Test.skipReason()
  %38 = call ptr @__polaron_str_cstr(ptr %why53)
  %39 = select i1 %anyfailed49, i32 1, i32 0
  %verdict54 = select i1 %37, i32 2, i32 %39
  call void @__polaron_test_record(ptr @.test.name.5363, i32 %verdict54, i64 %ns51, ptr %38, i64 0)
  br label %cont44

cont44:                                           ; preds = %then43, %cont30
  %aborted55 = call i32 @__polaron_test_aborted()
  %40 = icmp eq i32 %aborted55, 0
  %live56 = and i1 %sel7, %40
  br i1 %live56, label %then57, label %cont58

then57:                                           ; preds = %cont44
  call void @__polaron_test_record(ptr @.test.name.5364, i32 2, i64 0, ptr @.test.why, i64 0)
  br label %cont58

cont58:                                           ; preds = %then57, %cont44
  %aborted59 = call i32 @__polaron_test_aborted()
  %41 = icmp eq i32 %aborted59, 0
  %live60 = and i1 %sel9, %41
  br i1 %live60, label %then61, label %cont62

then61:                                           ; preds = %cont58
  call void @__polaron_test_start(ptr @.test.name.5365, i32 0)
  %t063 = call i64 @__polaron_now_ns()
  %failcount64 = alloca i32, align 4
  store i32 0, ptr %failcount64, align 4
  call void @Test.reset()
  call void @Census.openScratch()
  %verdict65 = call i32 @Census.boolean_form_still_works()
  %failed66 = icmp eq i32 %verdict65, 0
  call void @Census.closeScratch()
  %42 = zext i1 %failed66 to i32
  %43 = load i32, ptr %failcount64, align 4
  %44 = add i32 %43, %42
  store i32 %44, ptr %failcount64, align 4
  %45 = load i32, ptr %failcount64, align 4
  %anyfailed67 = icmp ne i32 %45, 0
  %t168 = call i64 @__polaron_now_ns()
  %ns69 = sub i64 %t168, %t063
  %skipped70 = call i32 @Test.wasSkipped()
  %46 = icmp ne i32 %skipped70, 0
  %why71 = call ptr @Test.skipReason()
  %47 = call ptr @__polaron_str_cstr(ptr %why71)
  %48 = select i1 %anyfailed67, i32 1, i32 0
  %verdict72 = select i1 %46, i32 2, i32 %48
  call void @__polaron_test_record(ptr @.test.name.5365, i32 %verdict72, i64 %ns69, ptr %47, i64 0)
  br label %cont62

cont62:                                           ; preds = %then61, %cont58
  br i1 %any10, label %then73, label %cont74

then73:                                           ; preds = %cont62
  call void @Census.dropWorld()
  br label %cont74

cont74:                                           ; preds = %then73, %cont62
  %49 = call i32 @__polaron_test_should_run(ptr @.test.name.5366, ptr @.test.tags.5367)
  %sel75 = icmp ne i32 %49, 0
  %any76 = or i1 false, %sel75
  br i1 %any76, label %then77, label %cont78

then77:                                           ; preds = %cont74
  br label %cont78

cont78:                                           ; preds = %then77, %cont74
  %aborted79 = call i32 @__polaron_test_aborted()
  %50 = icmp eq i32 %aborted79, 0
  %live80 = and i1 %sel75, %50
  br i1 %live80, label %then81, label %cont82

then81:                                           ; preds = %cont78
  call void @__polaron_test_start(ptr @.test.name.5368, i32 0)
  %t083 = call i64 @__polaron_now_ns()
  %failcount84 = alloca i32, align 4
  store i32 0, ptr %failcount84, align 4
  call void @Test.reset()
  call void @Arithmetic.arrays_and_text()
  %fails85 = call i32 @Test.failures()
  %failed86 = icmp ne i32 %fails85, 0
  %51 = zext i1 %failed86 to i32
  %52 = load i32, ptr %failcount84, align 4
  %53 = add i32 %52, %51
  store i32 %53, ptr %failcount84, align 4
  %54 = load i32, ptr %failcount84, align 4
  %anyfailed87 = icmp ne i32 %54, 0
  %t188 = call i64 @__polaron_now_ns()
  %ns89 = sub i64 %t188, %t083
  %skipped90 = call i32 @Test.wasSkipped()
  %55 = icmp ne i32 %skipped90, 0
  %why91 = call ptr @Test.skipReason()
  %56 = call ptr @__polaron_str_cstr(ptr %why91)
  %57 = select i1 %anyfailed87, i32 1, i32 0
  %verdict92 = select i1 %55, i32 2, i32 %57
  call void @__polaron_test_record(ptr @.test.name.5368, i32 %verdict92, i64 %ns89, ptr %56, i64 0)
  br label %cont82

cont82:                                           ; preds = %then81, %cont78
  br i1 %any76, label %then93, label %cont94

then93:                                           ; preds = %cont82
  br label %cont94

cont94:                                           ; preds = %then93, %cont82
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
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
