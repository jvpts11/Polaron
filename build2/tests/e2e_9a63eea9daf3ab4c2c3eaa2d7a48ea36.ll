; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sorted_int_set.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sorted_int_set.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.SortedIntSet = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@SortedIntSet.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @SortedIntSet.size, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @SortedIntSet.add, ptr null, ptr null, ptr null, ptr @SortedIntSet.contains, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @SortedIntSet.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @SortedIntSet.lowerBound, ptr @SortedIntSet.rank, ptr @SortedIntSet.floor, ptr @SortedIntSet.ceiling, ptr @SortedIntSet.kth, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [65 x i8] c"size=%d has3=%d has4=%d floor4=%d ceil4=%d rank5=%d k0=%d k4=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1304 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1305 = private global %String { i64 16, ptr @.strdata.1304, i64 0 }
@.strdata.1306 = private constant [17 x i8] c"division by zero\00"
@.strobj.1307 = private global %String { i64 16, ptr @.strdata.1306, i64 0 }
@.fail.1616 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2053:21  in SortedIntSet.lowerBound\0A\00", align 1
@.faila.1617 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1618 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1619 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2060:74  in SortedIntSet.ensure\0A\00", align 1
@.faila.1620 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1621 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1622 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2060:74  in SortedIntSet.ensure\0A\00", align 1
@.faila.1623 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1624 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1625 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2066:17  in SortedIntSet.add\0A\00", align 1
@.faila.1626 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1627 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1628 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2068:83  in SortedIntSet.add\0A\00", align 1
@.faila.1629 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1630 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1631 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2068:83  in SortedIntSet.add\0A\00", align 1
@.faila.1632 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1633 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1634 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2069:30  in SortedIntSet.add\0A\00", align 1
@.faila.1635 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1636 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1637 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2075:17  in SortedIntSet.contains\0A\00", align 1
@.faila.1638 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1639 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1640 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2080:17  in SortedIntSet.floor\0A\00", align 1
@.faila.1641 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1642 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1643 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2082:17  in SortedIntSet.floor\0A\00", align 1
@.faila.1644 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1645 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1646 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2087:17  in SortedIntSet.ceiling\0A\00", align 1
@.faila.1647 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1648 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1649 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2089:52  in SortedIntSet.kth\0A\00", align 1
@.faila.1650 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1651 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %s = alloca ptr, align 8
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
  %SortedIntSet.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.SortedIntSet, ptr null, i64 1) to i64))
  call void @SortedIntSet.SortedIntSet(ptr %SortedIntSet.obj)
  store ptr %SortedIntSet.obj, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  call void @SortedIntSet.add(ptr %s1, i32 5)
  %s2 = load ptr, ptr %s, align 8
  call void @SortedIntSet.add(ptr %s2, i32 1)
  %s3 = load ptr, ptr %s, align 8
  call void @SortedIntSet.add(ptr %s3, i32 3)
  %s4 = load ptr, ptr %s, align 8
  call void @SortedIntSet.add(ptr %s4, i32 3)
  %s5 = load ptr, ptr %s, align 8
  call void @SortedIntSet.add(ptr %s5, i32 8)
  %s6 = load ptr, ptr %s, align 8
  call void @SortedIntSet.add(ptr %s6, i32 2)
  %s7 = load ptr, ptr %s, align 8
  %16 = call i32 @SortedIntSet.size(ptr %s7)
  %s8 = load ptr, ptr %s, align 8
  %17 = call i32 @SortedIntSet.contains(ptr %s8, i32 3)
  %s9 = load ptr, ptr %s, align 8
  %18 = call i32 @SortedIntSet.contains(ptr %s9, i32 4)
  %s10 = load ptr, ptr %s, align 8
  %19 = call i32 @SortedIntSet.floor(ptr %s10, i32 4)
  %s11 = load ptr, ptr %s, align 8
  %20 = call i32 @SortedIntSet.ceiling(ptr %s11, i32 4)
  %s12 = load ptr, ptr %s, align 8
  %21 = call i32 @SortedIntSet.rank(ptr %s12, i32 5)
  %s13 = load ptr, ptr %s, align 8
  %22 = call i32 @SortedIntSet.kth(ptr %s13, i32 0)
  %s14 = load ptr, ptr %s, align 8
  %23 = call i32 @SortedIntSet.kth(ptr %s14, i32 4)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22, i32 %23)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1305)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1307)
  ret ptr %strcpy
}

define internal void @SortedIntSet.SortedIntSet(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 0
  store ptr @SortedIntSet.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal i32 @SortedIntSet.lowerBound(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %mid = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  store i32 0, ptr %lo, align 4
  %count = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  store i32 %count1, ptr %hi, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %lo2 = load i32, ptr %lo, align 4
  %hi3 = load i32, ptr %hi, align 4
  %2 = icmp slt i32 %lo2, %hi3
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %lo4 = load i32, ptr %lo, align 4
  %hi5 = load i32, ptr %hi, align 4
  %4 = add i32 %lo4, %hi5
  %5 = icmp eq i32 %4, -2147483648
  %6 = and i1 %5, false
  %7 = or i1 false, %6
  br i1 %7, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  %lo11 = load i32, ptr %lo, align 4
  ret i32 %lo11

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %8 = sdiv i32 %4, 2
  store i32 %8, ptr %mid, align 4
  %data = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data6 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid7 = load i32, ptr %mid, align 4
  %9 = sext i32 %mid7 to i64
  %arr.len = load i64, ptr %data6, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1616, ptr @.faila.1617, i64 %9, ptr @.failb.1618, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %data6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %9
  %elem = load i32, ptr %arr.elem, align 4
  %v8 = load i32, ptr %v, align 4
  %10 = icmp slt i32 %elem, %v8
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then, label %if.else

if.then:                                          ; preds = %idx.ok
  %mid9 = load i32, ptr %mid, align 4
  %12 = add i32 %mid9, 1
  store i32 %12, ptr %lo, align 4
  br label %if.end

if.else:                                          ; preds = %idx.ok
  %mid10 = load i32, ptr %mid, align 4
  store i32 %mid10, ptr %hi, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %while.cond
}

define internal void @SortedIntSet.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %need = alloca i32, align 4
  store i32 %1, ptr %need, align 4
  %need1 = load i32, ptr %need, align 4
  %data = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data2 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data2, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp sle i32 %need1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %data3 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data3, align 8, !tbaa !0
  %len5 = load i64, ptr %data4, align 8
  %5 = trunc i64 %len5 to i32
  %6 = mul i32 %5, 2
  %7 = sext i32 %6 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %10 = call ptr @memset(ptr %arr.data, i32 0, i64 %8)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i6 = load i32, ptr %i, align 4
  %count = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count, align 4, !tbaa !4
  %11 = icmp slt i32 %i6, %count7
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger8 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i9 = load i32, ptr %i, align 4
  %13 = sext i32 %i9 to i64
  %arr.len = load i64, ptr %bigger8, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok17
  %14 = load i32, ptr %i, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data20 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %bigger21 = load ptr, ptr %bigger, align 8
  store ptr %bigger21, ptr %data20, align 8, !tbaa !0
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1619, ptr @.faila.1620, i64 %13, ptr @.failb.1621, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data10 = getelementptr i8, ptr %bigger8, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data10, i64 %13
  %data11 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data12 = load ptr, ptr %data11, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i13 = load i32, ptr %i, align 4
  %16 = sext i32 %i13 to i64
  %arr.len14 = load i64, ptr %data12, align 8
  %arr.oob15 = icmp uge i64 %16, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !8

idx.bad16:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1622, ptr @.faila.1623, i64 %16, ptr @.failb.1624, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok
  %arr.data18 = getelementptr i8, ptr %data12, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 %16
  %elem = load i32, ptr %arr.elem19, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @SortedIntSet.add(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %p = alloca i32, align 4
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  %2 = call i32 @SortedIntSet.lowerBound(ptr %0, i32 %v1)
  store i32 %2, ptr %p, align 4
  %p2 = load i32, ptr %p, align 4
  %count = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp slt i32 %p2, %count3
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %data = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p5 = load i32, ptr %p, align 4
  %5 = sext i32 %p5 to i64
  %arr.len = load i64, ptr %data4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

sc.end:                                           ; preds = %idx.ok, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %idx.ok ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1625, ptr @.faila.1626, i64 %5, ptr @.failb.1627, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %data4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  %v6 = load i32, ptr %v, align 4
  %7 = icmp eq i32 %elem, %v6
  %8 = zext i1 %7 to i32
  %sc.b = icmp ne i32 %8, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  ret void

if.end:                                           ; preds = %sc.end
  %count7 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %9 = add i32 %count8, 1
  call void @SortedIntSet.ensure(ptr %0, i32 %9)
  %count9 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  store i32 %count10, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i11 = load i32, ptr %i, align 4
  %p12 = load i32, ptr %p, align 4
  %10 = icmp sgt i32 %i11, %p12
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data13 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %12 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %12, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

for.update:                                       ; preds = %idx.ok28
  %i32 = load i32, ptr %i, align 4
  %13 = sub i32 %i32, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data33 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data34 = load ptr, ptr %data33, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p35 = load i32, ptr %p, align 4
  %14 = sext i32 %p35 to i64
  %arr.len36 = load i64, ptr %data34, align 8
  %arr.oob37 = icmp uge i64 %14, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !8

idx.bad18:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1628, ptr @.faila.1629, i64 %12, ptr @.failb.1630, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %for.body
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %12
  %data22 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %15 = sub i32 %i24, 1
  %16 = sext i32 %15 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %16, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.1631, ptr @.faila.1632, i64 %16, ptr @.failb.1633, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok19
  %arr.data29 = getelementptr i8, ptr %data23, i64 8
  %arr.elem30 = getelementptr inbounds i32, ptr %arr.data29, i64 %16
  %elem31 = load i32, ptr %arr.elem30, align 4
  store i32 %elem31, ptr %arr.elem21, align 4
  br label %for.update

idx.bad38:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.1634, ptr @.faila.1635, i64 %14, ptr @.failb.1636, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %for.end
  %arr.data40 = getelementptr i8, ptr %data34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %14
  %v42 = load i32, ptr %v, align 4
  store i32 %v42, ptr %arr.elem41, align 4
  %count43 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count44 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count45 = load i32, ptr %count44, align 4, !tbaa !4
  %17 = add i32 %count45, 1
  store i32 %17, ptr %count43, align 4, !tbaa !4
  ret void
}

define internal i32 @SortedIntSet.contains(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %p = alloca i32, align 4
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  %2 = call i32 @SortedIntSet.lowerBound(ptr %0, i32 %v1)
  store i32 %2, ptr %p, align 4
  %p2 = load i32, ptr %p, align 4
  %count = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp slt i32 %p2, %count3
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %data = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p5 = load i32, ptr %p, align 4
  %5 = sext i32 %p5 to i64
  %arr.len = load i64, ptr %data4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

sc.end:                                           ; preds = %idx.ok, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %idx.ok ]
  %6 = zext i1 %sc to i32
  ret i32 %6

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1637, ptr @.faila.1638, i64 %5, ptr @.failb.1639, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %data4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  %v6 = load i32, ptr %v, align 4
  %7 = icmp eq i32 %elem, %v6
  %8 = zext i1 %7 to i32
  %sc.b = icmp ne i32 %8, 0
  br label %sc.end
}

define internal i32 @SortedIntSet.rank(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  %2 = call i32 @SortedIntSet.lowerBound(ptr %0, i32 %v1)
  ret i32 %2
}

define internal i32 @SortedIntSet.floor(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %p = alloca i32, align 4
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  %2 = call i32 @SortedIntSet.lowerBound(ptr %0, i32 %v1)
  store i32 %2, ptr %p, align 4
  %p2 = load i32, ptr %p, align 4
  %count = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp slt i32 %p2, %count3
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %data = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p5 = load i32, ptr %p, align 4
  %5 = sext i32 %p5 to i64
  %arr.len = load i64, ptr %data4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

sc.end:                                           ; preds = %idx.ok, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %idx.ok ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1640, ptr @.faila.1641, i64 %5, ptr @.failb.1642, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %data4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  %v6 = load i32, ptr %v, align 4
  %7 = icmp eq i32 %elem, %v6
  %8 = zext i1 %7 to i32
  %sc.b = icmp ne i32 %8, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %v7 = load i32, ptr %v, align 4
  ret i32 %v7

if.end:                                           ; preds = %sc.end
  %p8 = load i32, ptr %p, align 4
  %9 = icmp eq i32 %p8, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then9, label %if.end10

if.then9:                                         ; preds = %if.end
  ret i32 -2147483648

if.end10:                                         ; preds = %if.end
  %data11 = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data12 = load ptr, ptr %data11, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p13 = load i32, ptr %p, align 4
  %11 = sub i32 %p13, 1
  %12 = sext i32 %11 to i64
  %arr.len14 = load i64, ptr %data12, align 8
  %arr.oob15 = icmp uge i64 %12, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !8

idx.bad16:                                        ; preds = %if.end10
  call void @__polaron_fail(ptr @.fail.1643, ptr @.faila.1644, i64 %12, ptr @.failb.1645, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %if.end10
  %arr.data18 = getelementptr i8, ptr %data12, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 %12
  %elem20 = load i32, ptr %arr.elem19, align 4
  ret i32 %elem20
}

define internal i32 @SortedIntSet.ceiling(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %p = alloca i32, align 4
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  %2 = call i32 @SortedIntSet.lowerBound(ptr %0, i32 %v1)
  store i32 %2, ptr %p, align 4
  %p2 = load i32, ptr %p, align 4
  %count = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp eq i32 %p2, %count3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 2147483647

if.end:                                           ; preds = %entry
  %data = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p5 = load i32, ptr %p, align 4
  %5 = sext i32 %p5 to i64
  %arr.len = load i64, ptr %data4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1646, ptr @.faila.1647, i64 %5, ptr @.failb.1648, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @SortedIntSet.kth(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %data = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %data1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1649, ptr @.faila.1650, i64 %2, ptr @.failb.1651, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @SortedIntSet.size(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.SortedIntSet, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
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

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
