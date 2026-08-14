; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/number_theory.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/number_theory.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [22 x i8] c"gcd=%d lcm=%d inv=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [35 x i8] c"p97=%d p100=%d p7919=%d modpow=%d\0A\00", align 1
@.fail = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/number_theory.pol:20:24  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/number_theory.pol:20:35  in main\0A\00", align 1
@.faila.3 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/number_theory.pol:20:46  in main\0A\00", align 1
@.faila.6 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.7 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.8 = private unnamed_addr constant [36 x i8] c"fact5=%d c10_3=%d cat4=%d perms=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1315 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1316 = private global %String { i64 16, ptr @.strdata.1315, i64 0 }
@.strdata.1317 = private constant [17 x i8] c"division by zero\00"
@.strobj.1318 = private global %String { i64 16, ptr @.strdata.1317, i64 0 }
@.fail.3472 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6043:17  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3473 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3474 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3475 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6043:17  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3476 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3477 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3478 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6046:17  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3479 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3480 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3481 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6046:17  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3482 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3483 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3484 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6047:17  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3485 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3486 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3487 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6047:38  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3488 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3489 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3490 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6047:38  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3491 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3492 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3493 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6047:51  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3494 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3495 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3496 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6049:35  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3497 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3498 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3499 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6049:57  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3500 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3501 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3502 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6049:57  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3503 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3504 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3505 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6049:72  in Combinatorics.nextPermutation\0A\00", align 1
@.faila.3506 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3507 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }
@.strdata.5318 = private constant [1 x i8] zeroinitializer
@.strobj.5319 = private global %String { i64 0, ptr @.strdata.5318, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %cnt = alloca i32, align 4
  %perm = alloca ptr, align 8
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
  %16 = call i32 @NumberTheory.gcd(i32 48, i32 36)
  %17 = call i32 @NumberTheory.lcm(i32 4, i32 6)
  %18 = call i32 @NumberTheory.modInverse(i32 3, i32 11)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18)
  %20 = call i32 @NumberTheory.isPrime(i32 97)
  %21 = call i32 @NumberTheory.isPrime(i32 100)
  %22 = call i32 @NumberTheory.isPrime(i32 7919)
  %23 = call i64 @NumberTheory.modpow(i64 2, i64 10, i64 1000)
  %24 = trunc i64 %23 to i32
  %25 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %20, i32 %21, i32 %22, i32 %24)
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %26 = call ptr @memset(ptr %arr.data1, i32 0, i64 12)
  store ptr %arr, ptr %perm, align 8
  %perm2 = load ptr, ptr %perm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %perm2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %perm2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 1, ptr %arr.elem, align 4
  %perm4 = load ptr, ptr %perm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %perm4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2, ptr @.faila.3, i64 1, ptr @.failb.4, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %perm4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 2, ptr %arr.elem10, align 4
  %perm11 = load ptr, ptr %perm, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %perm11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.5, ptr @.faila.6, i64 2, ptr @.failb.7, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %perm11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 3, ptr %arr.elem17, align 4
  store i32 1, ptr %cnt, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok15
  %perm18 = load ptr, ptr %perm, align 8
  %27 = call i32 @Combinatorics.nextPermutation(ptr %perm18, i32 3)
  %28 = icmp ne i32 %27, 0
  br i1 %28, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %cnt19 = load i32, ptr %cnt, align 4
  %29 = add i32 %cnt19, 1
  store i32 %29, ptr %cnt, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %30 = call i64 @Combinatorics.factorial(i32 5)
  %31 = trunc i64 %30 to i32
  %32 = call i64 @Combinatorics.choose(i32 10, i32 3)
  %33 = trunc i64 %32 to i32
  %34 = call i64 @Combinatorics.catalan(i32 4)
  %35 = trunc i64 %34 to i32
  %cnt20 = load i32, ptr %cnt, align 4
  %36 = call i32 (ptr, ...) @printf(ptr @.str.8, i32 %31, i32 %33, i32 %35, i32 %cnt20)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1316)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1318)
  ret ptr %strcpy
}

define internal i32 @NumberTheory.gcd(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %t = alloca i32, align 4
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  store i32 %1, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  store i32 %a1, ptr %x, align 4
  %x2 = load i32, ptr %x, align 4
  %2 = icmp slt i32 %x2, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %x3 = load i32, ptr %x, align 4
  %4 = sub i32 0, %x3
  store i32 %4, ptr %x, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %b4 = load i32, ptr %b, align 4
  store i32 %b4, ptr %y, align 4
  %y5 = load i32, ptr %y, align 4
  %5 = icmp slt i32 %y5, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end
  %y8 = load i32, ptr %y, align 4
  %7 = sub i32 0, %y8
  store i32 %7, ptr %y, align 4
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.end
  br label %while.cond

while.cond:                                       ; preds = %div.ok, %if.end7
  %y9 = load i32, ptr %y, align 4
  %8 = icmp ne i32 %y9, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %y10 = load i32, ptr %y, align 4
  store i32 %y10, ptr %t, align 4
  %x11 = load i32, ptr %x, align 4
  %y12 = load i32, ptr %y, align 4
  %10 = icmp eq i32 %y12, 0
  %11 = icmp eq i32 %x11, -2147483648
  %12 = icmp eq i32 %y12, -1
  %13 = and i1 %11, %12
  %14 = or i1 %10, %13
  br i1 %14, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  %x14 = load i32, ptr %x, align 4
  ret i32 %x14

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %15 = srem i32 %x11, %y12
  store i32 %15, ptr %y, align 4
  %t13 = load i32, ptr %t, align 4
  store i32 %t13, ptr %x, align 4
  br label %while.cond
}

define internal i32 @NumberTheory.lcm(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  store i32 %1, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %2 = icmp eq i32 %a1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %b2 = load i32, ptr %b, align 4
  %4 = icmp eq i32 %b2, 0
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i32 0

if.end:                                           ; preds = %sc.end
  %a3 = load i32, ptr %a, align 4
  %a4 = load i32, ptr %a, align 4
  %b5 = load i32, ptr %b, align 4
  %7 = call i32 @NumberTheory.gcd(i32 %a4, i32 %b5)
  %8 = icmp eq i32 %7, 0
  %9 = icmp eq i32 %a3, -2147483648
  %10 = icmp eq i32 %7, -1
  %11 = and i1 %9, %10
  %12 = or i1 %8, %11
  br i1 %12, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end
  %13 = sdiv i32 %a3, %7
  %b6 = load i32, ptr %b, align 4
  %14 = mul i32 %13, %b6
  ret i32 %14
}

define internal i64 @NumberTheory.modpow(i64 %0, i64 %1, i64 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown19 = alloca ptr, align 8
  %exc.thrown12 = alloca ptr, align 8
  %e = alloca i64, align 8
  %b = alloca i64, align 8
  %exc.thrown = alloca ptr, align 8
  %result = alloca i64, align 8
  %mod = alloca i64, align 8
  %exp = alloca i64, align 8
  %base = alloca i64, align 8
  store i64 %0, ptr %base, align 8
  store i64 %1, ptr %exp, align 8
  store i64 %2, ptr %mod, align 8
  store i64 1, ptr %result, align 8
  %base1 = load i64, ptr %base, align 8
  %mod2 = load i64, ptr %mod, align 8
  %3 = icmp eq i64 %mod2, 0
  %4 = icmp eq i64 %base1, -9223372036854775808
  %5 = icmp eq i64 %mod2, -1
  %6 = and i1 %4, %5
  %7 = or i1 %3, %6
  br i1 %7, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %8 = srem i64 %base1, %mod2
  store i64 %8, ptr %b, align 8
  %exp3 = load i64, ptr %exp, align 8
  store i64 %exp3, ptr %e, align 8
  br label %while.cond

while.cond:                                       ; preds = %div.ok17, %div.ok
  %e4 = load i64, ptr %e, align 8
  %9 = icmp sgt i64 %e4, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %e5 = load i64, ptr %e, align 8
  %11 = and i64 %e5, 1
  %12 = icmp eq i64 %11, 1
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  %result21 = load i64, ptr %result, align 8
  ret i64 %result21

if.then:                                          ; preds = %while.body
  %result6 = load i64, ptr %result, align 8
  %b7 = load i64, ptr %b, align 8
  %14 = mul i64 %result6, %b7
  %mod8 = load i64, ptr %mod, align 8
  %15 = icmp eq i64 %mod8, 0
  %16 = icmp eq i64 %14, -9223372036854775808
  %17 = icmp eq i64 %mod8, -1
  %18 = and i1 %16, %17
  %19 = or i1 %15, %18
  br i1 %19, label %div.bad9, label %div.ok10

if.end:                                           ; preds = %div.ok10, %while.body
  %b13 = load i64, ptr %b, align 8
  %b14 = load i64, ptr %b, align 8
  %20 = mul i64 %b13, %b14
  %mod15 = load i64, ptr %mod, align 8
  %21 = icmp eq i64 %mod15, 0
  %22 = icmp eq i64 %20, -9223372036854775808
  %23 = icmp eq i64 %mod15, -1
  %24 = and i1 %22, %23
  %25 = or i1 %21, %24
  br i1 %25, label %div.bad16, label %div.ok17

div.bad9:                                         ; preds = %if.then
  %exc11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc11)
  store ptr %exc11, ptr %exc.thrown12, align 8
  call void @_CxxThrowException(ptr %exc.thrown12, ptr @_TI1PEAX)
  unreachable

div.ok10:                                         ; preds = %if.then
  %26 = srem i64 %14, %mod8
  store i64 %26, ptr %result, align 8
  br label %if.end

div.bad16:                                        ; preds = %if.end
  %exc18 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc18)
  store ptr %exc18, ptr %exc.thrown19, align 8
  call void @_CxxThrowException(ptr %exc.thrown19, ptr @_TI1PEAX)
  unreachable

div.ok17:                                         ; preds = %if.end
  %27 = srem i64 %20, %mod15
  store i64 %27, ptr %b, align 8
  %e20 = load i64, ptr %e, align 8
  %28 = ashr i64 %e20, 63
  %29 = ashr i64 %e20, 1
  store i64 %29, ptr %e, align 8
  br label %while.cond
}

define internal i32 @NumberTheory.millerTest(i64 %0, i64 %1, i64 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %dd = alloca i64, align 8
  %x = alloca i64, align 8
  %a = alloca i64, align 8
  %n = alloca i64, align 8
  %d = alloca i64, align 8
  store i64 %0, ptr %d, align 8
  store i64 %1, ptr %n, align 8
  store i64 %2, ptr %a, align 8
  %a1 = load i64, ptr %a, align 8
  %d2 = load i64, ptr %d, align 8
  %n3 = load i64, ptr %n, align 8
  %3 = call i64 @NumberTheory.modpow(i64 %a1, i64 %d2, i64 %n3)
  store i64 %3, ptr %x, align 8
  %x4 = load i64, ptr %x, align 8
  %4 = icmp eq i64 %x4, 1
  %5 = zext i1 %4 to i32
  %sc.a = icmp ne i32 %5, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %x5 = load i64, ptr %x, align 8
  %n6 = load i64, ptr %n, align 8
  %6 = sub i64 %n6, 1
  %7 = icmp eq i64 %x5, %6
  %8 = zext i1 %7 to i32
  %sc.b = icmp ne i32 %8, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %9 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i32 1

if.end:                                           ; preds = %sc.end
  %d7 = load i64, ptr %d, align 8
  store i64 %d7, ptr %dd, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end20, %if.end
  %dd8 = load i64, ptr %dd, align 8
  %n9 = load i64, ptr %n, align 8
  %10 = sub i64 %n9, 1
  %11 = icmp ne i64 %dd8, %10
  %12 = zext i1 %11 to i32
  br i1 %11, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %x10 = load i64, ptr %x, align 8
  %x11 = load i64, ptr %x, align 8
  %13 = mul i64 %x10, %x11
  %n12 = load i64, ptr %n, align 8
  %14 = icmp eq i64 %n12, 0
  %15 = icmp eq i64 %13, -9223372036854775808
  %16 = icmp eq i64 %n12, -1
  %17 = and i1 %15, %16
  %18 = or i1 %14, %17
  br i1 %18, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  ret i32 0

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %19 = srem i64 %13, %n12
  store i64 %19, ptr %x, align 8
  %dd13 = load i64, ptr %dd, align 8
  %20 = mul i64 %dd13, 2
  store i64 %20, ptr %dd, align 8
  %x14 = load i64, ptr %x, align 8
  %21 = icmp eq i64 %x14, 1
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then15, label %if.end16

if.then15:                                        ; preds = %div.ok
  ret i32 0

if.end16:                                         ; preds = %div.ok
  %x17 = load i64, ptr %x, align 8
  %n18 = load i64, ptr %n, align 8
  %23 = sub i64 %n18, 1
  %24 = icmp eq i64 %x17, %23
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then19, label %if.end20

if.then19:                                        ; preds = %if.end16
  ret i32 1

if.end20:                                         ; preds = %if.end16
  br label %while.cond
}

define internal i32 @NumberTheory.isPrime(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown19 = alloca ptr, align 8
  %exc.thrown14 = alloca ptr, align 8
  %d = alloca i64, align 8
  %exc.thrown = alloca ptr, align 8
  %n = alloca i64, align 8
  %num = alloca i32, align 4
  store i32 %0, ptr %num, align 4
  %num1 = load i32, ptr %num, align 4
  %1 = sext i32 %num1 to i64
  store i64 %1, ptr %n, align 8
  %n2 = load i64, ptr %n, align 8
  %2 = icmp slt i64 %n2, 2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %n3 = load i64, ptr %n, align 8
  %4 = icmp slt i64 %n3, 4
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  ret i32 1

if.end5:                                          ; preds = %if.end
  %n6 = load i64, ptr %n, align 8
  %6 = icmp eq i64 %n6, -9223372036854775808
  %7 = and i1 %6, false
  %8 = or i1 false, %7
  br i1 %8, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end5
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end5
  %9 = srem i64 %n6, 2
  %10 = icmp eq i64 %9, 0
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then7, label %if.end8

if.then7:                                         ; preds = %div.ok
  ret i32 0

if.end8:                                          ; preds = %div.ok
  %n9 = load i64, ptr %n, align 8
  %12 = sub i64 %n9, 1
  store i64 %12, ptr %d, align 8
  br label %while.cond

while.cond:                                       ; preds = %div.ok17, %if.end8
  %d10 = load i64, ptr %d, align 8
  %13 = icmp eq i64 %d10, -9223372036854775808
  %14 = and i1 %13, false
  %15 = or i1 false, %14
  br i1 %15, label %div.bad11, label %div.ok12

while.body:                                       ; preds = %div.ok12
  %d15 = load i64, ptr %d, align 8
  %16 = icmp eq i64 %d15, -9223372036854775808
  %17 = and i1 %16, false
  %18 = or i1 false, %17
  br i1 %18, label %div.bad16, label %div.ok17

while.end:                                        ; preds = %div.ok12
  %n20 = load i64, ptr %n, align 8
  %19 = icmp slt i64 2, %n20
  %20 = zext i1 %19 to i32
  %sc.a = icmp ne i32 %20, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

div.bad11:                                        ; preds = %while.cond
  %exc13 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc13)
  store ptr %exc13, ptr %exc.thrown14, align 8
  call void @_CxxThrowException(ptr %exc.thrown14, ptr @_TI1PEAX)
  unreachable

div.ok12:                                         ; preds = %while.cond
  %21 = srem i64 %d10, 2
  %22 = icmp eq i64 %21, 0
  %23 = zext i1 %22 to i32
  br i1 %22, label %while.body, label %while.end

div.bad16:                                        ; preds = %while.body
  %exc18 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc18)
  store ptr %exc18, ptr %exc.thrown19, align 8
  call void @_CxxThrowException(ptr %exc.thrown19, ptr @_TI1PEAX)
  unreachable

div.ok17:                                         ; preds = %while.body
  %24 = sdiv i64 %d15, 2
  store i64 %24, ptr %d, align 8
  br label %while.cond

sc.rhs:                                           ; preds = %while.end
  %d21 = load i64, ptr %d, align 8
  %n22 = load i64, ptr %n, align 8
  %25 = call i32 @NumberTheory.millerTest(i64 %d21, i64 %n22, i64 2)
  %26 = icmp eq i32 %25, 0
  %27 = zext i1 %26 to i32
  %sc.b = icmp ne i32 %27, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.end
  %sc = phi i1 [ false, %while.end ], [ %sc.b, %sc.rhs ]
  %28 = zext i1 %sc to i32
  br i1 %sc, label %if.then23, label %if.end24

if.then23:                                        ; preds = %sc.end
  ret i32 0

if.end24:                                         ; preds = %sc.end
  %n25 = load i64, ptr %n, align 8
  %29 = icmp slt i64 3, %n25
  %30 = zext i1 %29 to i32
  %sc.a26 = icmp ne i32 %30, 0
  br i1 %sc.a26, label %sc.rhs27, label %sc.end28

sc.rhs27:                                         ; preds = %if.end24
  %d29 = load i64, ptr %d, align 8
  %n30 = load i64, ptr %n, align 8
  %31 = call i32 @NumberTheory.millerTest(i64 %d29, i64 %n30, i64 3)
  %32 = icmp eq i32 %31, 0
  %33 = zext i1 %32 to i32
  %sc.b31 = icmp ne i32 %33, 0
  br label %sc.end28

sc.end28:                                         ; preds = %sc.rhs27, %if.end24
  %sc32 = phi i1 [ false, %if.end24 ], [ %sc.b31, %sc.rhs27 ]
  %34 = zext i1 %sc32 to i32
  br i1 %sc32, label %if.then33, label %if.end34

if.then33:                                        ; preds = %sc.end28
  ret i32 0

if.end34:                                         ; preds = %sc.end28
  %n35 = load i64, ptr %n, align 8
  %35 = icmp slt i64 5, %n35
  %36 = zext i1 %35 to i32
  %sc.a36 = icmp ne i32 %36, 0
  br i1 %sc.a36, label %sc.rhs37, label %sc.end38

sc.rhs37:                                         ; preds = %if.end34
  %d39 = load i64, ptr %d, align 8
  %n40 = load i64, ptr %n, align 8
  %37 = call i32 @NumberTheory.millerTest(i64 %d39, i64 %n40, i64 5)
  %38 = icmp eq i32 %37, 0
  %39 = zext i1 %38 to i32
  %sc.b41 = icmp ne i32 %39, 0
  br label %sc.end38

sc.end38:                                         ; preds = %sc.rhs37, %if.end34
  %sc42 = phi i1 [ false, %if.end34 ], [ %sc.b41, %sc.rhs37 ]
  %40 = zext i1 %sc42 to i32
  br i1 %sc42, label %if.then43, label %if.end44

if.then43:                                        ; preds = %sc.end38
  ret i32 0

if.end44:                                         ; preds = %sc.end38
  %n45 = load i64, ptr %n, align 8
  %41 = icmp slt i64 7, %n45
  %42 = zext i1 %41 to i32
  %sc.a46 = icmp ne i32 %42, 0
  br i1 %sc.a46, label %sc.rhs47, label %sc.end48

sc.rhs47:                                         ; preds = %if.end44
  %d49 = load i64, ptr %d, align 8
  %n50 = load i64, ptr %n, align 8
  %43 = call i32 @NumberTheory.millerTest(i64 %d49, i64 %n50, i64 7)
  %44 = icmp eq i32 %43, 0
  %45 = zext i1 %44 to i32
  %sc.b51 = icmp ne i32 %45, 0
  br label %sc.end48

sc.end48:                                         ; preds = %sc.rhs47, %if.end44
  %sc52 = phi i1 [ false, %if.end44 ], [ %sc.b51, %sc.rhs47 ]
  %46 = zext i1 %sc52 to i32
  br i1 %sc52, label %if.then53, label %if.end54

if.then53:                                        ; preds = %sc.end48
  ret i32 0

if.end54:                                         ; preds = %sc.end48
  ret i32 1
}

define internal i32 @NumberTheory.modInverse(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %tmpr = alloca i32, align 4
  %tmpt = alloca i32, align 4
  %q = alloca i32, align 4
  %exc.thrown10 = alloca ptr, align 8
  %newr = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %r = alloca i32, align 4
  %newt = alloca i32, align 4
  %t = alloca i32, align 4
  %m = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  store i32 %1, ptr %m, align 4
  store i32 0, ptr %t, align 4
  store i32 1, ptr %newt, align 4
  %m1 = load i32, ptr %m, align 4
  store i32 %m1, ptr %r, align 4
  %a2 = load i32, ptr %a, align 4
  %m3 = load i32, ptr %m, align 4
  %2 = icmp eq i32 %m3, 0
  %3 = icmp eq i32 %a2, -2147483648
  %4 = icmp eq i32 %m3, -1
  %5 = and i1 %3, %4
  %6 = or i1 %2, %5
  br i1 %6, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %7 = srem i32 %a2, %m3
  store i32 %7, ptr %newr, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok8, %div.ok
  %newr4 = load i32, ptr %newr, align 4
  %8 = icmp ne i32 %newr4, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %r5 = load i32, ptr %r, align 4
  %newr6 = load i32, ptr %newr, align 4
  %10 = icmp eq i32 %newr6, 0
  %11 = icmp eq i32 %r5, -2147483648
  %12 = icmp eq i32 %newr6, -1
  %13 = and i1 %11, %12
  %14 = or i1 %10, %13
  br i1 %14, label %div.bad7, label %div.ok8

while.end:                                        ; preds = %while.cond
  %r21 = load i32, ptr %r, align 4
  %15 = icmp sgt i32 %r21, 1
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then, label %if.end

div.bad7:                                         ; preds = %while.body
  %exc9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc9)
  store ptr %exc9, ptr %exc.thrown10, align 8
  call void @_CxxThrowException(ptr %exc.thrown10, ptr @_TI1PEAX)
  unreachable

div.ok8:                                          ; preds = %while.body
  %17 = sdiv i32 %r5, %newr6
  store i32 %17, ptr %q, align 4
  %t11 = load i32, ptr %t, align 4
  %q12 = load i32, ptr %q, align 4
  %newt13 = load i32, ptr %newt, align 4
  %18 = mul i32 %q12, %newt13
  %19 = sub i32 %t11, %18
  store i32 %19, ptr %tmpt, align 4
  %newt14 = load i32, ptr %newt, align 4
  store i32 %newt14, ptr %t, align 4
  %tmpt15 = load i32, ptr %tmpt, align 4
  store i32 %tmpt15, ptr %newt, align 4
  %r16 = load i32, ptr %r, align 4
  %q17 = load i32, ptr %q, align 4
  %newr18 = load i32, ptr %newr, align 4
  %20 = mul i32 %q17, %newr18
  %21 = sub i32 %r16, %20
  store i32 %21, ptr %tmpr, align 4
  %newr19 = load i32, ptr %newr, align 4
  store i32 %newr19, ptr %r, align 4
  %tmpr20 = load i32, ptr %tmpr, align 4
  store i32 %tmpr20, ptr %newr, align 4
  br label %while.cond

if.then:                                          ; preds = %while.end
  ret i32 -1

if.end:                                           ; preds = %while.end
  %t22 = load i32, ptr %t, align 4
  %22 = icmp slt i32 %t22, 0
  %23 = zext i1 %22 to i32
  br i1 %22, label %if.then23, label %if.end24

if.then23:                                        ; preds = %if.end
  %t25 = load i32, ptr %t, align 4
  %m26 = load i32, ptr %m, align 4
  %24 = add i32 %t25, %m26
  store i32 %24, ptr %t, align 4
  br label %if.end24

if.end24:                                         ; preds = %if.then23, %if.end
  %t27 = load i32, ptr %t, align 4
  ret i32 %t27
}

define internal i64 @Combinatorics.factorial(i32 %0) {
entry:
  %i = alloca i32, align 4
  %r = alloca i64, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  store i64 1, ptr %r, align 8
  store i32 2, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %1 = icmp sle i32 %i1, %n2
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r3 = load i64, ptr %r, align 8
  %i4 = load i32, ptr %i, align 4
  %3 = sext i32 %i4 to i64
  %4 = mul i64 %r3, %3
  store i64 %4, ptr %r, align 8
  br label %for.update

for.update:                                       ; preds = %for.body
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r5 = load i64, ptr %r, align 8
  ret i64 %r5
}

define internal i64 @Combinatorics.choose(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %r = alloca i64, align 8
  %kk = alloca i32, align 4
  %k = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  store i32 %1, ptr %k, align 4
  %k1 = load i32, ptr %k, align 4
  %2 = icmp slt i32 %k1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %k2 = load i32, ptr %k, align 4
  %n3 = load i32, ptr %n, align 4
  %4 = icmp sgt i32 %k2, %n3
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i64 0

if.end:                                           ; preds = %sc.end
  %k4 = load i32, ptr %k, align 4
  store i32 %k4, ptr %kk, align 4
  %kk5 = load i32, ptr %kk, align 4
  %n6 = load i32, ptr %n, align 4
  %kk7 = load i32, ptr %kk, align 4
  %7 = sub i32 %n6, %kk7
  %8 = icmp sgt i32 %kk5, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end
  %n10 = load i32, ptr %n, align 4
  %kk11 = load i32, ptr %kk, align 4
  %10 = sub i32 %n10, %kk11
  store i32 %10, ptr %kk, align 4
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.end
  store i64 1, ptr %r, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end9
  %i12 = load i32, ptr %i, align 4
  %kk13 = load i32, ptr %kk, align 4
  %11 = icmp slt i32 %i12, %kk13
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r14 = load i64, ptr %r, align 8
  %n15 = load i32, ptr %n, align 4
  %i16 = load i32, ptr %i, align 4
  %13 = sub i32 %n15, %i16
  %14 = sext i32 %13 to i64
  %15 = mul i64 %r14, %14
  store i64 %15, ptr %r, align 8
  %r17 = load i64, ptr %r, align 8
  %i18 = load i32, ptr %i, align 4
  %16 = add i32 %i18, 1
  %17 = sext i32 %16 to i64
  %18 = icmp eq i64 %17, 0
  %19 = icmp eq i64 %r17, -9223372036854775808
  %20 = icmp eq i64 %17, -1
  %21 = and i1 %19, %20
  %22 = or i1 %18, %21
  br i1 %22, label %div.bad, label %div.ok

for.update:                                       ; preds = %div.ok
  %23 = load i32, ptr %i, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r19 = load i64, ptr %r, align 8
  ret i64 %r19

div.bad:                                          ; preds = %for.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.body
  %25 = sdiv i64 %r17, %17
  store i64 %25, ptr %r, align 8
  br label %for.update
}

define internal i64 @Combinatorics.catalan(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = mul i32 2, %n1
  %n2 = load i32, ptr %n, align 4
  %2 = call i64 @Combinatorics.choose(i32 %1, i32 %n2)
  %n3 = load i32, ptr %n, align 4
  %3 = add i32 %n3, 1
  %4 = sext i32 %3 to i64
  %5 = icmp eq i64 %4, 0
  %6 = icmp eq i64 %2, -9223372036854775808
  %7 = icmp eq i64 %4, -1
  %8 = and i1 %6, %7
  %9 = or i1 %5, %8
  br i1 %9, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %10 = sdiv i64 %2, %4
  ret i64 %10
}

define internal i32 @Combinatorics.nextPermutation(ptr %0, i32 %1) {
entry:
  %t2 = alloca i32, align 4
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %tmp = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %2 = sub i32 %n1, 2
  store i32 %2, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i2 = load i32, ptr %i, align 4
  %3 = icmp sge i32 %i2, 0
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %i14 = load i32, ptr %i, align 4
  %5 = sub i32 %i14, 1
  store i32 %5, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %i15 = load i32, ptr %i, align 4
  %6 = icmp slt i32 %i15, 0
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.end

sc.rhs:                                           ; preds = %while.cond
  %a3 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i4 = load i32, ptr %i, align 4
  %8 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %a3, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

sc.end:                                           ; preds = %idx.ok10, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok10 ]
  %9 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3472, ptr @.faila.3473, i64 %8, ptr @.failb.3474, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %a3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %elem = load i32, ptr %arr.elem, align 4
  %a5 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %10 = add i32 %i6, 1
  %11 = sext i32 %10 to i64
  %arr.len7 = load i64, ptr %a5, align 8
  %arr.oob8 = icmp uge i64 %11, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3475, ptr @.faila.3476, i64 %11, ptr @.failb.3477, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %a5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %11
  %elem13 = load i32, ptr %arr.elem12, align 4
  %12 = icmp sge i32 %elem, %elem13
  %13 = zext i1 %12 to i32
  %sc.b = icmp ne i32 %13, 0
  br label %sc.end

if.then:                                          ; preds = %while.end
  ret i32 0

if.end:                                           ; preds = %while.end
  %n16 = load i32, ptr %n, align 4
  %14 = sub i32 %n16, 1
  store i32 %14, ptr %j, align 4
  br label %while.cond17

while.cond17:                                     ; preds = %while.body18, %if.end
  %a20 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j21 = load i32, ptr %j, align 4
  %15 = sext i32 %j21 to i64
  %arr.len22 = load i64, ptr %a20, align 8
  %arr.oob23 = icmp uge i64 %15, %arr.len22
  br i1 %arr.oob23, label %idx.bad24, label %idx.ok25, !prof !2

while.body18:                                     ; preds = %idx.ok34
  %j38 = load i32, ptr %j, align 4
  %16 = sub i32 %j38, 1
  store i32 %16, ptr %j, align 4
  br label %while.cond17

while.end19:                                      ; preds = %idx.ok34
  %a39 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i40 = load i32, ptr %i, align 4
  %17 = sext i32 %i40 to i64
  %arr.len41 = load i64, ptr %a39, align 8
  %arr.oob42 = icmp uge i64 %17, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !2

idx.bad24:                                        ; preds = %while.cond17
  call void @__polaron_fail(ptr @.fail.3478, ptr @.faila.3479, i64 %15, ptr @.failb.3480, i64 %arr.len22, i32 70)
  unreachable

idx.ok25:                                         ; preds = %while.cond17
  %arr.data26 = getelementptr i8, ptr %a20, i64 8
  %arr.elem27 = getelementptr inbounds i32, ptr %arr.data26, i64 %15
  %elem28 = load i32, ptr %arr.elem27, align 4
  %a29 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i30 = load i32, ptr %i, align 4
  %18 = sext i32 %i30 to i64
  %arr.len31 = load i64, ptr %a29, align 8
  %arr.oob32 = icmp uge i64 %18, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !2

idx.bad33:                                        ; preds = %idx.ok25
  call void @__polaron_fail(ptr @.fail.3481, ptr @.faila.3482, i64 %18, ptr @.failb.3483, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %idx.ok25
  %arr.data35 = getelementptr i8, ptr %a29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %18
  %elem37 = load i32, ptr %arr.elem36, align 4
  %19 = icmp sle i32 %elem28, %elem37
  %20 = zext i1 %19 to i32
  br i1 %19, label %while.body18, label %while.end19

idx.bad43:                                        ; preds = %while.end19
  call void @__polaron_fail(ptr @.fail.3484, ptr @.faila.3485, i64 %17, ptr @.failb.3486, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.end19
  %arr.data45 = getelementptr i8, ptr %a39, i64 8
  %arr.elem46 = getelementptr inbounds i32, ptr %arr.data45, i64 %17
  %elem47 = load i32, ptr %arr.elem46, align 4
  store i32 %elem47, ptr %tmp, align 4
  %a48 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i49 = load i32, ptr %i, align 4
  %21 = sext i32 %i49 to i64
  %arr.len50 = load i64, ptr %a48, align 8
  %arr.oob51 = icmp uge i64 %21, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !2

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.3487, ptr @.faila.3488, i64 %21, ptr @.failb.3489, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %a48, i64 8
  %arr.elem55 = getelementptr inbounds i32, ptr %arr.data54, i64 %21
  %a56 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j57 = load i32, ptr %j, align 4
  %22 = sext i32 %j57 to i64
  %arr.len58 = load i64, ptr %a56, align 8
  %arr.oob59 = icmp uge i64 %22, %arr.len58
  br i1 %arr.oob59, label %idx.bad60, label %idx.ok61, !prof !2

idx.bad60:                                        ; preds = %idx.ok53
  call void @__polaron_fail(ptr @.fail.3490, ptr @.faila.3491, i64 %22, ptr @.failb.3492, i64 %arr.len58, i32 70)
  unreachable

idx.ok61:                                         ; preds = %idx.ok53
  %arr.data62 = getelementptr i8, ptr %a56, i64 8
  %arr.elem63 = getelementptr inbounds i32, ptr %arr.data62, i64 %22
  %elem64 = load i32, ptr %arr.elem63, align 4
  store i32 %elem64, ptr %arr.elem55, align 4
  %a65 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j66 = load i32, ptr %j, align 4
  %23 = sext i32 %j66 to i64
  %arr.len67 = load i64, ptr %a65, align 8
  %arr.oob68 = icmp uge i64 %23, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !2

idx.bad69:                                        ; preds = %idx.ok61
  call void @__polaron_fail(ptr @.fail.3493, ptr @.faila.3494, i64 %23, ptr @.failb.3495, i64 %arr.len67, i32 70)
  unreachable

idx.ok70:                                         ; preds = %idx.ok61
  %arr.data71 = getelementptr i8, ptr %a65, i64 8
  %arr.elem72 = getelementptr inbounds i32, ptr %arr.data71, i64 %23
  %tmp73 = load i32, ptr %tmp, align 4
  store i32 %tmp73, ptr %arr.elem72, align 4
  %i74 = load i32, ptr %i, align 4
  %24 = add i32 %i74, 1
  store i32 %24, ptr %lo, align 4
  %n75 = load i32, ptr %n, align 4
  %25 = sub i32 %n75, 1
  store i32 %25, ptr %hi, align 4
  br label %while.cond76

while.cond76:                                     ; preds = %idx.ok112, %idx.ok70
  %lo79 = load i32, ptr %lo, align 4
  %hi80 = load i32, ptr %hi, align 4
  %26 = icmp slt i32 %lo79, %hi80
  %27 = zext i1 %26 to i32
  br i1 %26, label %while.body77, label %while.end78

while.body77:                                     ; preds = %while.cond76
  %a81 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %lo82 = load i32, ptr %lo, align 4
  %28 = sext i32 %lo82 to i64
  %arr.len83 = load i64, ptr %a81, align 8
  %arr.oob84 = icmp uge i64 %28, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !2

while.end78:                                      ; preds = %while.cond76
  ret i32 1

idx.bad85:                                        ; preds = %while.body77
  call void @__polaron_fail(ptr @.fail.3496, ptr @.faila.3497, i64 %28, ptr @.failb.3498, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %while.body77
  %arr.data87 = getelementptr i8, ptr %a81, i64 8
  %arr.elem88 = getelementptr inbounds i32, ptr %arr.data87, i64 %28
  %elem89 = load i32, ptr %arr.elem88, align 4
  store i32 %elem89, ptr %t2, align 4
  %a90 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %lo91 = load i32, ptr %lo, align 4
  %29 = sext i32 %lo91 to i64
  %arr.len92 = load i64, ptr %a90, align 8
  %arr.oob93 = icmp uge i64 %29, %arr.len92
  br i1 %arr.oob93, label %idx.bad94, label %idx.ok95, !prof !2

idx.bad94:                                        ; preds = %idx.ok86
  call void @__polaron_fail(ptr @.fail.3499, ptr @.faila.3500, i64 %29, ptr @.failb.3501, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %idx.ok86
  %arr.data96 = getelementptr i8, ptr %a90, i64 8
  %arr.elem97 = getelementptr inbounds i32, ptr %arr.data96, i64 %29
  %a98 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %hi99 = load i32, ptr %hi, align 4
  %30 = sext i32 %hi99 to i64
  %arr.len100 = load i64, ptr %a98, align 8
  %arr.oob101 = icmp uge i64 %30, %arr.len100
  br i1 %arr.oob101, label %idx.bad102, label %idx.ok103, !prof !2

idx.bad102:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.3502, ptr @.faila.3503, i64 %30, ptr @.failb.3504, i64 %arr.len100, i32 70)
  unreachable

idx.ok103:                                        ; preds = %idx.ok95
  %arr.data104 = getelementptr i8, ptr %a98, i64 8
  %arr.elem105 = getelementptr inbounds i32, ptr %arr.data104, i64 %30
  %elem106 = load i32, ptr %arr.elem105, align 4
  store i32 %elem106, ptr %arr.elem97, align 4
  %a107 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %hi108 = load i32, ptr %hi, align 4
  %31 = sext i32 %hi108 to i64
  %arr.len109 = load i64, ptr %a107, align 8
  %arr.oob110 = icmp uge i64 %31, %arr.len109
  br i1 %arr.oob110, label %idx.bad111, label %idx.ok112, !prof !2

idx.bad111:                                       ; preds = %idx.ok103
  call void @__polaron_fail(ptr @.fail.3505, ptr @.faila.3506, i64 %31, ptr @.failb.3507, i64 %arr.len109, i32 70)
  unreachable

idx.ok112:                                        ; preds = %idx.ok103
  %arr.data113 = getelementptr i8, ptr %a107, i64 8
  %arr.elem114 = getelementptr inbounds i32, ptr %arr.data113, i64 %31
  %t2115 = load i32, ptr %t2, align 4
  store i32 %t2115, ptr %arr.elem114, align 4
  %lo116 = load i32, ptr %lo, align 4
  %32 = add i32 %lo116, 1
  store i32 %32, ptr %lo, align 4
  %hi117 = load i32, ptr %hi, align 4
  %33 = sub i32 %hi117, 1
  store i32 %33, ptr %hi, align 4
  br label %while.cond76
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

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

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
