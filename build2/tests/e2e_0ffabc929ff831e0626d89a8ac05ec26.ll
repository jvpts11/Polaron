; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bitset_ops.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bitset_ops.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Bitset = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Bitset.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @Bitset.size, ptr null, ptr null, ptr null, ptr null, ptr @Bitset.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Bitset.set, ptr null, ptr null, ptr null, ptr null, ptr @Bitset.clear, ptr null, ptr null, ptr null, ptr null, ptr @Bitset.count, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Bitset.flip, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Bitset.~Bitset"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [29 x i8] c"g3=%d g4=%d g99=%d count=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"g40=%d g4=%d count=%d size=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1305 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1306 = private global %String { i64 16, ptr @.strdata.1305, i64 0 }
@.strdata.1307 = private constant [17 x i8] c"division by zero\00"
@.strobj.1308 = private global %String { i64 16, ptr @.strdata.1307, i64 0 }
@.fail.1456 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1558:36  in Bitset.set\0A\00", align 1
@.faila.1457 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1458 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1459 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1558:36  in Bitset.set\0A\00", align 1
@.faila.1460 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1461 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1462 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1562:36  in Bitset.clear\0A\00", align 1
@.faila.1463 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1464 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1465 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1562:36  in Bitset.clear\0A\00", align 1
@.faila.1466 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1467 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1468 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1566:36  in Bitset.flip\0A\00", align 1
@.faila.1469 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1470 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1471 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1566:36  in Bitset.flip\0A\00", align 1
@.faila.1472 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1473 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1474 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1570:17  in Bitset.get\0A\00", align 1
@.faila.1475 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1476 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1477 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1575:21  in Bitset.count\0A\00", align 1
@.faila.1478 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1479 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %bs = alloca ptr, align 8
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
  %Bitset.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Bitset, ptr null, i64 1) to i64))
  call void @Bitset.Bitset(ptr %Bitset.obj, i32 100)
  store ptr %Bitset.obj, ptr %bs, align 8
  %bs1 = load ptr, ptr %bs, align 8
  call void @Bitset.set(ptr %bs1, i32 3)
  %bs2 = load ptr, ptr %bs, align 8
  call void @Bitset.set(ptr %bs2, i32 40)
  %bs3 = load ptr, ptr %bs, align 8
  call void @Bitset.set(ptr %bs3, i32 99)
  %bs4 = load ptr, ptr %bs, align 8
  %16 = call i32 @Bitset.get(ptr %bs4, i32 3)
  %bs5 = load ptr, ptr %bs, align 8
  %17 = call i32 @Bitset.get(ptr %bs5, i32 4)
  %bs6 = load ptr, ptr %bs, align 8
  %18 = call i32 @Bitset.get(ptr %bs6, i32 99)
  %bs7 = load ptr, ptr %bs, align 8
  %19 = call i32 @Bitset.count(ptr %bs7)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19)
  %bs8 = load ptr, ptr %bs, align 8
  call void @Bitset.clear(ptr %bs8, i32 40)
  %bs9 = load ptr, ptr %bs, align 8
  call void @Bitset.flip(ptr %bs9, i32 4)
  %bs10 = load ptr, ptr %bs, align 8
  %21 = call i32 @Bitset.get(ptr %bs10, i32 40)
  %bs11 = load ptr, ptr %bs, align 8
  %22 = call i32 @Bitset.get(ptr %bs11, i32 4)
  %bs12 = load ptr, ptr %bs, align 8
  %23 = call i32 @Bitset.count(ptr %bs12)
  %bs13 = load ptr, ptr %bs, align 8
  %24 = call i32 @Bitset.size(ptr %bs13)
  %25 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %21, i32 %22, i32 %23, i32 %24)
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

define internal void @Exception.Exception(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  ret void
}

define internal void @ArithmeticException.ArithmeticException(ptr %0) {
entry:
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ArithmeticException, ptr %0, i32 0, i32 0
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1306)
  ret ptr %strcpy
}

define internal void @DivideByZeroException.DivideByZeroException(ptr %0) {
entry:
  call void @ArithmeticException.ArithmeticException(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DivideByZeroException, ptr %0, i32 0, i32 0
  store ptr @DivideByZeroException.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal ptr @DivideByZeroException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1308)
  ret ptr %strcpy
}

define internal void @Bitset.Bitset(ptr %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %size = alloca i32, align 4
  store i32 %1, ptr %size, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 0
  store ptr @Bitset.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %words = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  store ptr null, ptr %words, align 8, !tbaa !0
  %nbits = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 2
  %size1 = load i32, ptr %size, align 4
  store i32 %size1, ptr %nbits, align 4, !tbaa !4
  %words2 = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %size3 = load i32, ptr %size, align 4
  %2 = add i32 %size3, 31
  %3 = icmp eq i32 %2, -2147483648
  %4 = and i1 %3, false
  %5 = or i1 false, %4
  br i1 %5, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %6 = sdiv i32 %2, 32
  %7 = sext i32 %6 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %10 = call ptr @memset(ptr %arr.data, i32 0, i64 %8)
  store ptr %arr, ptr %words2, align 8, !tbaa !0
  ret void
}

define internal void @"Bitset.~Bitset"(ptr %0) {
entry:
  %words = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words1 = load ptr, ptr %words, align 8, !tbaa !0
  call void @__polaron_free(ptr %words1)
  ret void
}

define internal void @Bitset.set(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %words = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words1 = load ptr, ptr %words, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = ashr i32 %i2, 31
  %3 = ashr i32 %i2, 5
  %4 = sext i32 %3 to i64
  %arr.len = load i64, ptr %words1, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1456, ptr @.faila.1457, i64 %4, ptr @.failb.1458, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %words1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %words3 = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words4 = load ptr, ptr %words3, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %5 = ashr i32 %i5, 31
  %6 = ashr i32 %i5, 5
  %7 = sext i32 %6 to i64
  %arr.len6 = load i64, ptr %words4, align 8
  %arr.oob7 = icmp uge i64 %7, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !8

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1459, ptr @.faila.1460, i64 %7, ptr @.failb.1461, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %words4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %7
  %elem = load i32, ptr %arr.elem11, align 4
  %i12 = load i32, ptr %i, align 4
  %8 = and i32 %i12, 31
  %9 = icmp ult i32 %8, 32
  %10 = select i1 %9, i32 %8, i32 0
  %11 = shl i32 1, %10
  %12 = select i1 %9, i32 %11, i32 0
  %13 = or i32 %elem, %12
  store i32 %13, ptr %arr.elem, align 4
  ret void
}

define internal void @Bitset.clear(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %words = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words1 = load ptr, ptr %words, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = ashr i32 %i2, 31
  %3 = ashr i32 %i2, 5
  %4 = sext i32 %3 to i64
  %arr.len = load i64, ptr %words1, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1462, ptr @.faila.1463, i64 %4, ptr @.failb.1464, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %words1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %words3 = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words4 = load ptr, ptr %words3, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %5 = ashr i32 %i5, 31
  %6 = ashr i32 %i5, 5
  %7 = sext i32 %6 to i64
  %arr.len6 = load i64, ptr %words4, align 8
  %arr.oob7 = icmp uge i64 %7, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !8

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1465, ptr @.faila.1466, i64 %7, ptr @.failb.1467, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %words4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %7
  %elem = load i32, ptr %arr.elem11, align 4
  %i12 = load i32, ptr %i, align 4
  %8 = and i32 %i12, 31
  %9 = icmp ult i32 %8, 32
  %10 = select i1 %9, i32 %8, i32 0
  %11 = shl i32 1, %10
  %12 = select i1 %9, i32 %11, i32 0
  %13 = xor i32 %12, -1
  %14 = and i32 %elem, %13
  store i32 %14, ptr %arr.elem, align 4
  ret void
}

define internal void @Bitset.flip(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %words = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words1 = load ptr, ptr %words, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = ashr i32 %i2, 31
  %3 = ashr i32 %i2, 5
  %4 = sext i32 %3 to i64
  %arr.len = load i64, ptr %words1, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1468, ptr @.faila.1469, i64 %4, ptr @.failb.1470, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %words1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %words3 = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words4 = load ptr, ptr %words3, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %5 = ashr i32 %i5, 31
  %6 = ashr i32 %i5, 5
  %7 = sext i32 %6 to i64
  %arr.len6 = load i64, ptr %words4, align 8
  %arr.oob7 = icmp uge i64 %7, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !8

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1471, ptr @.faila.1472, i64 %7, ptr @.failb.1473, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %words4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %7
  %elem = load i32, ptr %arr.elem11, align 4
  %i12 = load i32, ptr %i, align 4
  %8 = and i32 %i12, 31
  %9 = icmp ult i32 %8, 32
  %10 = select i1 %9, i32 %8, i32 0
  %11 = shl i32 1, %10
  %12 = select i1 %9, i32 %11, i32 0
  %13 = xor i32 %elem, %12
  store i32 %13, ptr %arr.elem, align 4
  ret void
}

define internal i32 @Bitset.get(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %words = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words1 = load ptr, ptr %words, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = ashr i32 %i2, 31
  %3 = ashr i32 %i2, 5
  %4 = sext i32 %3 to i64
  %arr.len = load i64, ptr %words1, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1474, ptr @.faila.1475, i64 %4, ptr @.failb.1476, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %words1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %i3 = load i32, ptr %i, align 4
  %5 = and i32 %i3, 31
  %6 = icmp ult i32 %5, 32
  %7 = select i1 %6, i32 %5, i32 0
  %8 = shl i32 1, %7
  %9 = select i1 %6, i32 %8, i32 0
  %10 = and i32 %elem, %9
  %11 = icmp ne i32 %10, 0
  %12 = zext i1 %11 to i32
  ret i32 %12
}

define internal i32 @Bitset.count(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %b = alloca i32, align 4
  %x = alloca i32, align 4
  %w = alloca i32, align 4
  %total = alloca i32, align 4
  store i32 0, ptr %total, align 4
  store i32 0, ptr %w, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %w1 = load i32, ptr %w, align 4
  %words = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words2 = load ptr, ptr %words, align 8, !tbaa !0
  %len = load i64, ptr %words2, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %w1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %words3 = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 1
  %words4 = load ptr, ptr %words3, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %w5 = load i32, ptr %w, align 4
  %4 = sext i32 %w5 to i64
  %arr.len = load i64, ptr %words4, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %for.end9
  %5 = load i32, ptr %w, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %w, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %total14 = load i32, ptr %total, align 4
  ret i32 %total14

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1477, ptr @.faila.1478, i64 %4, ptr @.failb.1479, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %words4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %x, align 4
  store i32 0, ptr %b, align 4
  br label %for.cond6

for.cond6:                                        ; preds = %for.update8, %idx.ok
  %b10 = load i32, ptr %b, align 4
  %7 = icmp slt i32 %b10, 32
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %x11 = load i32, ptr %x, align 4
  %b12 = load i32, ptr %b, align 4
  %9 = icmp ult i32 %b12, 32
  %10 = select i1 %9, i32 %b12, i32 0
  %11 = shl i32 1, %10
  %12 = select i1 %9, i32 %11, i32 0
  %13 = and i32 %x11, %12
  %14 = icmp ne i32 %13, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then, label %if.end

for.update8:                                      ; preds = %if.end
  %16 = load i32, ptr %b, align 4
  %17 = add i32 %16, 1
  store i32 %17, ptr %b, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update

if.then:                                          ; preds = %for.body7
  %total13 = load i32, ptr %total, align 4
  %18 = add i32 %total13, 1
  store i32 %18, ptr %total, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body7
  br label %for.update8
}

define internal i32 @Bitset.size(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %nbits = getelementptr inbounds %class.Bitset, ptr %0, i32 0, i32 2
  %nbits1 = load i32, ptr %nbits, align 4, !tbaa !4
  ret i32 %nbits1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5307)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5309)
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

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
