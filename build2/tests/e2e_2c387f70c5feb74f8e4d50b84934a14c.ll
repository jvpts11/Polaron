; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Polynomial = type { ptr, ptr }
%class.IntVector = type { ptr, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Polynomial.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Polynomial.evaluate, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Polynomial.degree, ptr @Polynomial.coeff, ptr @Polynomial.derivative, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IntVector.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @IntVector.size, ptr null, ptr null, ptr null, ptr null, ptr @IntVector.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IntVector.dot, ptr @IntVector.normSquared, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:14:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:15:23  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:16:23  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:20:23  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:21:23  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:22:23  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:24:23  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:25:23  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/poly_vector.pol:26:23  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [39 x i8] c"eval=%d deg=%d dval=%d dot=%d norm=%d\0A\00", align 1
@.fail.3392 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5762:17  in Polynomial.coeff\0A\00", align 1
@.faila.3393 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3394 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3395 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5766:76  in Polynomial.evaluate\0A\00", align 1
@.faila.3396 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3397 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3398 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5775:78  in Polynomial.derivative\0A\00", align 1
@.faila.3399 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3400 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3401 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5775:78  in Polynomial.derivative\0A\00", align 1
@.faila.3402 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3403 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3404 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5784:52  in IntVector.get\0A\00", align 1
@.faila.3405 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3406 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3407 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5788:71  in IntVector.dot\0A\00", align 1
@.faila.3408 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3409 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3410 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5793:71  in IntVector.normSquared\0A\00", align 1
@.faila.3411 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3412 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3413 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5793:71  in IntVector.normSquared\0A\00", align 1
@.faila.3414 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3415 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5332 = private constant [1 x i8] zeroinitializer
@.strobj.5333 = private global %String { i64 0, ptr @.strdata.5332, i64 0 }
@.strdata.5334 = private constant [1 x i8] zeroinitializer
@.strobj.5335 = private global %String { i64 0, ptr @.strdata.5334, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %w = alloca ptr, align 8
  %u = alloca ptr, align 8
  %vb = alloca ptr, align 8
  %va = alloca ptr, align 8
  %dp = alloca ptr, align 8
  %p = alloca ptr, align 8
  %pc = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 12)
  store ptr %arr, ptr %pc, align 8
  %pc2 = load ptr, ptr %pc, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %pc2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %pc2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 1, ptr %arr.elem, align 4
  %pc4 = load ptr, ptr %pc, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %pc4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %pc4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 2, ptr %arr.elem10, align 4
  %pc11 = load ptr, ptr %pc, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %pc11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %pc11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 3, ptr %arr.elem17, align 4
  %Polynomial.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Polynomial, ptr null, i64 1) to i64))
  %pc18 = load ptr, ptr %pc, align 8
  call void @Polynomial.Polynomial(ptr %Polynomial.obj, ptr %pc18)
  store ptr %Polynomial.obj, ptr %p, align 8
  %p19 = load ptr, ptr %p, align 8
  %17 = call ptr @Polynomial.derivative(ptr %p19)
  store ptr %17, ptr %dp, align 8
  %arr20 = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr20, align 8
  %arr.data21 = getelementptr i8, ptr %arr20, i64 8
  %18 = call ptr @memset(ptr %arr.data21, i32 0, i64 12)
  store ptr %arr20, ptr %va, align 8
  %va22 = load ptr, ptr %va, align 8, !nonnull !0, !dereferenceable !1
  %arr.len23 = load i64, ptr %va22, align 8
  %arr.oob24 = icmp uge i64 0, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !2

idx.bad25:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 0, ptr @.failb.9, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok15
  %arr.data27 = getelementptr i8, ptr %va22, i64 8
  %arr.elem28 = getelementptr inbounds i32, ptr %arr.data27, i64 0
  store i32 1, ptr %arr.elem28, align 4
  %va29 = load ptr, ptr %va, align 8, !nonnull !0, !dereferenceable !1
  %arr.len30 = load i64, ptr %va29, align 8
  %arr.oob31 = icmp uge i64 1, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

idx.bad32:                                        ; preds = %idx.ok26
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 1, ptr @.failb.12, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %idx.ok26
  %arr.data34 = getelementptr i8, ptr %va29, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 1
  store i32 2, ptr %arr.elem35, align 4
  %va36 = load ptr, ptr %va, align 8, !nonnull !0, !dereferenceable !1
  %arr.len37 = load i64, ptr %va36, align 8
  %arr.oob38 = icmp uge i64 2, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad39:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 2, ptr @.failb.15, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok33
  %arr.data41 = getelementptr i8, ptr %va36, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 2
  store i32 3, ptr %arr.elem42, align 4
  %arr43 = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr43, align 8
  %arr.data44 = getelementptr i8, ptr %arr43, i64 8
  %19 = call ptr @memset(ptr %arr.data44, i32 0, i64 12)
  store ptr %arr43, ptr %vb, align 8
  %vb45 = load ptr, ptr %vb, align 8, !nonnull !0, !dereferenceable !1
  %arr.len46 = load i64, ptr %vb45, align 8
  %arr.oob47 = icmp uge i64 0, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

idx.bad48:                                        ; preds = %idx.ok40
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 0, ptr @.failb.18, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %idx.ok40
  %arr.data50 = getelementptr i8, ptr %vb45, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 0
  store i32 4, ptr %arr.elem51, align 4
  %vb52 = load ptr, ptr %vb, align 8, !nonnull !0, !dereferenceable !1
  %arr.len53 = load i64, ptr %vb52, align 8
  %arr.oob54 = icmp uge i64 1, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !2

idx.bad55:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 1, ptr @.failb.21, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok49
  %arr.data57 = getelementptr i8, ptr %vb52, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 1
  store i32 5, ptr %arr.elem58, align 4
  %vb59 = load ptr, ptr %vb, align 8, !nonnull !0, !dereferenceable !1
  %arr.len60 = load i64, ptr %vb59, align 8
  %arr.oob61 = icmp uge i64 2, %arr.len60
  br i1 %arr.oob61, label %idx.bad62, label %idx.ok63, !prof !2

idx.bad62:                                        ; preds = %idx.ok56
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 2, ptr @.failb.24, i64 %arr.len60, i32 70)
  unreachable

idx.ok63:                                         ; preds = %idx.ok56
  %arr.data64 = getelementptr i8, ptr %vb59, i64 8
  %arr.elem65 = getelementptr inbounds i32, ptr %arr.data64, i64 2
  store i32 6, ptr %arr.elem65, align 4
  %IntVector.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IntVector, ptr null, i64 1) to i64))
  %va66 = load ptr, ptr %va, align 8
  call void @IntVector.IntVector(ptr %IntVector.obj, ptr %va66)
  store ptr %IntVector.obj, ptr %u, align 8
  %IntVector.obj67 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IntVector, ptr null, i64 1) to i64))
  %vb68 = load ptr, ptr %vb, align 8
  call void @IntVector.IntVector(ptr %IntVector.obj67, ptr %vb68)
  store ptr %IntVector.obj67, ptr %w, align 8
  %p69 = load ptr, ptr %p, align 8
  %20 = call i32 @Polynomial.evaluate(ptr %p69, i32 2)
  %p70 = load ptr, ptr %p, align 8
  %21 = call i32 @Polynomial.degree(ptr %p70)
  %dp71 = load ptr, ptr %dp, align 8
  %22 = call i32 @Polynomial.evaluate(ptr %dp71, i32 2)
  %u72 = load ptr, ptr %u, align 8
  %w73 = load ptr, ptr %w, align 8
  %23 = call i32 @IntVector.dot(ptr %u72, ptr %w73)
  %u74 = load ptr, ptr %u, align 8
  %24 = call i32 @IntVector.normSquared(ptr %u74)
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %20, i32 %21, i32 %22, i32 %23, i32 %24)
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal void @Polynomial.Polynomial(ptr %0, ptr %1) {
entry:
  %coeffs = alloca ptr, align 8
  store ptr %1, ptr %coeffs, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 0
  store ptr @Polynomial.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %c = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  store ptr null, ptr %c, align 8, !tbaa !3
  %c1 = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %coeffs2 = load ptr, ptr %coeffs, align 8
  store ptr %coeffs2, ptr %c1, align 8, !tbaa !3
  ret void
}

define internal i32 @Polynomial.degree(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %c = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c1 = load ptr, ptr %c, align 8, !tbaa !3
  %len = load i64, ptr %c1, align 8
  %1 = trunc i64 %len to i32
  %2 = sub i32 %1, 1
  ret i32 %2
}

define internal i32 @Polynomial.coeff(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %i1 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %i1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i2 = load i32, ptr %i, align 4
  %c = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c3 = load ptr, ptr %c, align 8, !tbaa !3
  %len = load i64, ptr %c3, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sge i32 %i2, %4
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i32 0

if.end:                                           ; preds = %sc.end
  %c4 = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c5 = load ptr, ptr %c4, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %8 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %c5, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.3392, ptr @.faila.3393, i64 %8, ptr @.failb.3394, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %c5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @Polynomial.evaluate(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %r = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 0, ptr %r, align 4
  %c = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c1 = load ptr, ptr %c, align 8, !tbaa !3
  %len = load i64, ptr %c1, align 8
  %2 = trunc i64 %len to i32
  %3 = sub i32 %2, 1
  store i32 %3, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %4 = icmp sge i32 %i2, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r3 = load i32, ptr %r, align 4
  %x4 = load i32, ptr %x, align 4
  %6 = mul i32 %r3, %x4
  %c5 = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c6 = load ptr, ptr %c5, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %7 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %c6, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %8 = load i32, ptr %i, align 4
  %9 = sub i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r8 = load i32, ptr %r, align 4
  ret i32 %r8

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3395, ptr @.faila.3396, i64 %7, ptr @.failb.3397, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %c6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %7
  %elem = load i32, ptr %arr.elem, align 4
  %10 = add i32 %6, %elem
  store i32 %10, ptr %r, align 4
  br label %for.update
}

define internal ptr @Polynomial.derivative(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %i = alloca i32, align 4
  %d = alloca ptr, align 8
  %z = alloca ptr, align 8
  %c = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c1 = load ptr, ptr %c, align 8, !tbaa !3
  %len = load i64, ptr %c1, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp sle i32 %1, 1
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %arr = call ptr @__polaron_malloc(i64 12)
  store i64 1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 4)
  store ptr %arr, ptr %z, align 8
  %Polynomial.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Polynomial, ptr null, i64 1) to i64))
  %z2 = load ptr, ptr %z, align 8
  call void @Polynomial.Polynomial(ptr %Polynomial.obj, ptr %z2)
  ret ptr %Polynomial.obj

if.end:                                           ; preds = %entry
  %c3 = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c4 = load ptr, ptr %c3, align 8, !tbaa !3
  %len5 = load i64, ptr %c4, align 8
  %5 = trunc i64 %len5 to i32
  %6 = sub i32 %5, 1
  %7 = sext i32 %6 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr6 = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %10 = call ptr @memset(ptr %arr.data7, i32 0, i64 %8)
  store ptr %arr6, ptr %d, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i8 = load i32, ptr %i, align 4
  %c9 = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c10 = load ptr, ptr %c9, align 8, !tbaa !3
  %len11 = load i64, ptr %c10, align 8
  %11 = trunc i64 %len11 to i32
  %12 = icmp slt i32 %i8, %11
  %13 = zext i1 %12 to i32
  br i1 %12, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %d12 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %i13 = load i32, ptr %i, align 4
  %14 = sub i32 %i13, 1
  %15 = sext i32 %14 to i64
  %arr.len = load i64, ptr %d12, align 8
  %arr.oob = icmp uge i64 %15, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok21
  %16 = load i32, ptr %i, align 4
  %17 = add i32 %16, 1
  store i32 %17, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %Polynomial.obj25 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Polynomial, ptr null, i64 1) to i64))
  %d26 = load ptr, ptr %d, align 8
  call void @Polynomial.Polynomial(ptr %Polynomial.obj25, ptr %d26)
  ret ptr %Polynomial.obj25

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3398, ptr @.faila.3399, i64 %15, ptr @.failb.3400, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data14 = getelementptr i8, ptr %d12, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data14, i64 %15
  %c15 = getelementptr inbounds %class.Polynomial, ptr %0, i32 0, i32 1
  %c16 = load ptr, ptr %c15, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i17 = load i32, ptr %i, align 4
  %18 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %c16, align 8
  %arr.oob19 = icmp uge i64 %18, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !2

idx.bad20:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3401, ptr @.faila.3402, i64 %18, ptr @.failb.3403, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %idx.ok
  %arr.data22 = getelementptr i8, ptr %c16, i64 8
  %arr.elem23 = getelementptr inbounds i32, ptr %arr.data22, i64 %18
  %elem = load i32, ptr %arr.elem23, align 4
  %i24 = load i32, ptr %i, align 4
  %19 = mul i32 %elem, %i24
  store i32 %19, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @IntVector.IntVector(ptr %0, ptr %1) {
entry:
  %elems = alloca ptr, align 8
  store ptr %1, ptr %elems, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 0
  store ptr @IntVector.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %e = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  store ptr null, ptr %e, align 8, !tbaa !3
  %e1 = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  %elems2 = load ptr, ptr %elems, align 8
  store ptr %elems2, ptr %e1, align 8, !tbaa !3
  ret void
}

define internal i32 @IntVector.get(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %e = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  %e1 = load ptr, ptr %e, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i2 = load i32, ptr %i, align 4
  %2 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %e1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3404, ptr @.faila.3405, i64 %2, ptr @.failb.3406, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %e1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @IntVector.size(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %e = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  %e1 = load ptr, ptr %e, align 8, !tbaa !3
  %len = load i64, ptr %e1, align 8
  %1 = trunc i64 %len to i32
  ret i32 %1
}

define internal i32 @IntVector.dot(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  %IntVector.copy = alloca %class.IntVector, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %IntVector.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.IntVector, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.IntVector, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !3
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.IntVector, ptr %IntVector.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !3
  store ptr %IntVector.copy, ptr %o, align 8
  store i32 0, ptr %s, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %e = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  %e2 = load ptr, ptr %e, align 8, !tbaa !3
  %len = load i64, ptr %e2, align 8
  %9 = trunc i64 %len to i32
  %10 = icmp slt i32 %i1, %9
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s3 = load i32, ptr %s, align 4
  %e4 = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  %e5 = load ptr, ptr %e4, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %12 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %e5, align 8
  %arr.oob = icmp uge i64 %12, %arr.len7
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s10 = load i32, ptr %s, align 4
  ret i32 %s10

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3407, ptr @.faila.3408, i64 %12, ptr @.failb.3409, i64 %arr.len7, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %e5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %12
  %elem = load i32, ptr %arr.elem, align 4
  %o8 = load ptr, ptr %o, align 8
  %i9 = load i32, ptr %i, align 4
  %15 = call i32 @IntVector.get(ptr %o8, i32 %i9)
  %16 = mul i32 %elem, %15
  %17 = add i32 %s3, %16
  store i32 %17, ptr %s, align 4
  br label %for.update
}

define internal i32 @IntVector.normSquared(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  store i32 0, ptr %s, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %e = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  %e2 = load ptr, ptr %e, align 8, !tbaa !3
  %len = load i64, ptr %e2, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s3 = load i32, ptr %s, align 4
  %e4 = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  %e5 = load ptr, ptr %e4, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %4 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %e5, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok13
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s17 = load i32, ptr %s, align 4
  ret i32 %s17

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3410, ptr @.faila.3411, i64 %4, ptr @.failb.3412, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %e5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %e7 = getelementptr inbounds %class.IntVector, ptr %0, i32 0, i32 1
  %e8 = load ptr, ptr %e7, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i9 = load i32, ptr %i, align 4
  %7 = sext i32 %i9 to i64
  %arr.len10 = load i64, ptr %e8, align 8
  %arr.oob11 = icmp uge i64 %7, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !2

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3413, ptr @.faila.3414, i64 %7, ptr @.failb.3415, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %e8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %7
  %elem16 = load i32, ptr %arr.elem15, align 4
  %8 = mul i32 %elem, %elem16
  %9 = add i32 %s3, %8
  store i32 %9, ptr %s, align 4
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5333)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5335)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
