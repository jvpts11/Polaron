; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/priority_queue.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/priority_queue.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.PriorityQueue$int" = type { ptr, ptr, i32 }
%class.DivideByZeroException = type { ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"PriorityQueue$int.vtable" = private constant [350 x ptr] [ptr null, ptr null, ptr @"PriorityQueue$int.peek", ptr null, ptr @"PriorityQueue$int.size", ptr @"PriorityQueue$int.isEmpty", ptr @"PriorityQueue$int.add", ptr @"PriorityQueue$int.poll", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"PriorityQueue$int.~PriorityQueue$int"]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [17 x i8] c"size=%d peek=%d\0A\00", align 1
@.strdata = private constant [1 x i8] zeroinitializer
@.strobj = private global %String { i64 0, ptr @.strdata, i64 0 }
@.ifmt = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.fail.41 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1504:78  in PriorityQueue$int.add\0A\00", align 1
@.faila.42 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.43 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.44 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1504:78  in PriorityQueue$int.add\0A\00", align 1
@.faila.45 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.46 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.47 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1508:39  in PriorityQueue$int.add\0A\00", align 1
@.faila.48 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.49 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.50 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1513:21  in PriorityQueue$int.add\0A\00", align 1
@.faila.51 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.52 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.53 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1513:21  in PriorityQueue$int.add\0A\00", align 1
@.faila.54 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.55 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.56 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1514:21  in PriorityQueue$int.add\0A\00", align 1
@.faila.57 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.58 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.59 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1515:34  in PriorityQueue$int.add\0A\00", align 1
@.faila.60 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.61 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.62 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1515:34  in PriorityQueue$int.add\0A\00", align 1
@.faila.63 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.64 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.65 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1516:39  in PriorityQueue$int.add\0A\00", align 1
@.faila.66 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.67 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.68 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1520:46  in PriorityQueue$int.peek\0A\00", align 1
@.faila.69 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.70 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.71 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1522:17  in PriorityQueue$int.poll\0A\00", align 1
@.faila.72 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.73 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.74 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1524:30  in PriorityQueue$int.poll\0A\00", align 1
@.faila.75 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.76 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.77 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1524:30  in PriorityQueue$int.poll\0A\00", align 1
@.faila.78 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.79 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.80 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1530:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.81 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.82 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.83 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1530:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.84 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.85 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.86 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1533:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.87 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.88 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.89 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1533:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.90 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.91 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.92 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1537:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.93 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.94 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.95 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1538:34  in PriorityQueue$int.poll\0A\00", align 1
@.faila.96 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.97 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.98 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1538:34  in PriorityQueue$int.poll\0A\00", align 1
@.faila.99 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.100 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.101 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1539:41  in PriorityQueue$int.poll\0A\00", align 1
@.faila.102 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.103 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1370 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1371 = private global %String { i64 16, ptr @.strdata.1370, i64 0 }
@.strdata.1372 = private constant [17 x i8] c"division by zero\00"
@.strobj.1373 = private global %String { i64 16, ptr @.strdata.1372, i64 0 }
@.strdata.5371 = private constant [1 x i8] zeroinitializer
@.strobj.5372 = private global %String { i64 0, ptr @.strdata.5371, i64 0 }
@.strdata.5373 = private constant [1 x i8] zeroinitializer
@.strobj.5374 = private global %String { i64 0, ptr @.strdata.5373, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %order = alloca ptr, align 8
  %pq = alloca ptr, align 8
  %"PriorityQueue$int.obj" = alloca %"class.PriorityQueue$int", align 8
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
  call void @"PriorityQueue$int.PriorityQueue$int"(ptr %"PriorityQueue$int.obj")
  store ptr %"PriorityQueue$int.obj", ptr %pq, align 8
  %pq1 = load ptr, ptr %pq, align 8
  call void @"PriorityQueue$int.add"(ptr %pq1, i32 5)
  %pq2 = load ptr, ptr %pq, align 8
  call void @"PriorityQueue$int.add"(ptr %pq2, i32 1)
  %pq3 = load ptr, ptr %pq, align 8
  call void @"PriorityQueue$int.add"(ptr %pq3, i32 3)
  %pq4 = load ptr, ptr %pq, align 8
  call void @"PriorityQueue$int.add"(ptr %pq4, i32 2)
  %pq5 = load ptr, ptr %pq, align 8
  call void @"PriorityQueue$int.add"(ptr %pq5, i32 4)
  %pq6 = load ptr, ptr %pq, align 8
  %16 = call i32 @"PriorityQueue$int.size"(ptr %pq6)
  %pq7 = load ptr, ptr %pq, align 8
  %17 = call i32 @"PriorityQueue$int.peek"(ptr %pq7)
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17)
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %order, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %argv.end
  %pq8 = load ptr, ptr %pq, align 8
  %19 = call i32 @"PriorityQueue$int.isEmpty"(ptr %pq8)
  %20 = icmp eq i32 %19, 0
  %21 = zext i1 %20 to i32
  br i1 %20, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %order9 = load ptr, ptr %order, align 8
  %pq10 = load ptr, ptr %pq, align 8
  %22 = call i32 @"PriorityQueue$int.poll"(ptr %pq10)
  %ilen = call i32 (ptr, i64, ptr, ...) @snprintf(ptr null, i64 0, ptr @.ifmt, i32 %22)
  %23 = sext i32 %ilen to i64
  %24 = add i64 %23, 1
  %ibuf = call ptr @__polaron_malloc(i64 %24)
  %25 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %ibuf, i64 %24, ptr @.ifmt, i32 %22)
  %newstr11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %26 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 0
  store i64 %23, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 1
  store ptr %ibuf, ptr %27, align 8
  %28 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 2
  store i64 0, ptr %28, align 8
  %str.len = getelementptr inbounds %String, ptr %order9, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.len12 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 0
  %len13 = load i64, ptr %str.len12, align 8
  %29 = add i64 %len, %len13
  %30 = add i64 %29, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %30)
  %str.data = getelementptr inbounds %String, ptr %order9, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %31 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data14 = getelementptr inbounds %String, ptr %newstr11, i32 0, i32 1
  %data15 = load ptr, ptr %str.data14, align 8
  %32 = getelementptr i8, ptr %cat.buf, i64 %len
  %33 = call ptr @memcpy(ptr %32, ptr %data15, i64 %len13)
  %34 = getelementptr i8, ptr %cat.buf, i64 %29
  store i8 0, ptr %34, align 1
  %newstr16 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  store i64 %29, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  store ptr %cat.buf, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %38 = getelementptr inbounds %String, ptr %order9, i32 0, i32 0
  %str.len17 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  store i64 %len18, ptr %38, align 8
  %39 = getelementptr inbounds %String, ptr %order9, i32 0, i32 1
  %str.data19 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  %data20 = load ptr, ptr %str.data19, align 8
  store ptr %data20, ptr %39, align 8
  %40 = getelementptr inbounds %String, ptr %order9, i32 0, i32 2
  store i64 0, ptr %40, align 8
  call void @__polaron_str_free(ptr %newstr11)
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %order21 = load ptr, ptr %order, align 8
  %str.data22 = getelementptr inbounds %String, ptr %order21, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %41 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data23)
  %42 = load ptr, ptr %order, align 8
  call void @__polaron_str_free(ptr %42)
  ret i32 0
}

define internal void @"PriorityQueue$int.PriorityQueue$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 0
  store ptr @"PriorityQueue$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %heap, align 8, !tbaa !0
  %heap1 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %heap1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"PriorityQueue$int.~PriorityQueue$int"(ptr %0) {
entry:
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap1 = load ptr, ptr %heap, align 8, !tbaa !0
  call void @__polaron_free(ptr %heap1)
  ret void
}

define internal void @"PriorityQueue$int.add"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %tmp = alloca i32, align 4
  %parent = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap2 = load ptr, ptr %heap, align 8, !tbaa !0
  %len = load i64, ptr %heap2, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp sge i32 %count1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %heap3 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap4 = load ptr, ptr %heap3, align 8, !tbaa !0
  %len5 = load i64, ptr %heap4, align 8
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
  store i32 0, ptr %j, align 4
  br label %for.cond

if.end:                                           ; preds = %for.end, %entry
  %heap25 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap26 = load ptr, ptr %heap25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count27 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %11 = sext i32 %count28 to i64
  %arr.len29 = load i64, ptr %heap26, align 8
  %arr.oob30 = icmp uge i64 %11, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %j6 = load i32, ptr %j, align 4
  %count7 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %12 = icmp slt i32 %j6, %count8
  %13 = zext i1 %12 to i32
  br i1 %12, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger9 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %j10 = load i32, ptr %j, align 4
  %14 = sext i32 %j10 to i64
  %arr.len = load i64, ptr %bigger9, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok18
  %15 = load i32, ptr %j, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %heap21 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap22 = load ptr, ptr %heap21, align 8, !tbaa !0
  call void @__polaron_free(ptr %heap22)
  %heap23 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %bigger24 = load ptr, ptr %bigger, align 8
  store ptr %bigger24, ptr %heap23, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.41, ptr @.faila.42, i64 %14, ptr @.failb.43, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %bigger9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 %14
  %heap12 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap13 = load ptr, ptr %heap12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j14 = load i32, ptr %j, align 4
  %17 = sext i32 %j14 to i64
  %arr.len15 = load i64, ptr %heap13, align 8
  %arr.oob16 = icmp uge i64 %17, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !8

idx.bad17:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.44, ptr @.faila.45, i64 %17, ptr @.failb.46, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok
  %arr.data19 = getelementptr i8, ptr %heap13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %17
  %elem = load i32, ptr %arr.elem20, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

idx.bad31:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.47, ptr @.faila.48, i64 %11, ptr @.failb.49, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %if.end
  %arr.data33 = getelementptr i8, ptr %heap26, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %11
  %item35 = load i32, ptr %item, align 4
  store i32 %item35, ptr %arr.elem34, align 4
  %count36 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count37 = load i32, ptr %count36, align 4, !tbaa !4
  store i32 %count37, ptr %i, align 4
  %count38 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count39 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count40 = load i32, ptr %count39, align 4, !tbaa !4
  %18 = add i32 %count40, 1
  store i32 %18, ptr %count38, align 4, !tbaa !4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok100, %idx.ok32
  %i41 = load i32, ptr %i, align 4
  %19 = icmp sgt i32 %i41, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i42 = load i32, ptr %i, align 4
  %21 = sub i32 %i42, 1
  %22 = icmp eq i32 %21, -2147483648
  %23 = and i1 %22, false
  %24 = or i1 false, %23
  br i1 %24, label %div.bad, label %div.ok

while.end:                                        ; preds = %if.then63, %while.cond
  ret void

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %25 = sdiv i32 %21, 2
  store i32 %25, ptr %parent, align 4
  %heap43 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap44 = load ptr, ptr %heap43, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i45 = load i32, ptr %i, align 4
  %26 = sext i32 %i45 to i64
  %arr.len46 = load i64, ptr %heap44, align 8
  %arr.oob47 = icmp uge i64 %26, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !8

idx.bad48:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.50, ptr @.faila.51, i64 %26, ptr @.failb.52, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %div.ok
  %arr.data50 = getelementptr i8, ptr %heap44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %26
  %elem52 = load i32, ptr %arr.elem51, align 4
  %heap53 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap54 = load ptr, ptr %heap53, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %parent55 = load i32, ptr %parent, align 4
  %27 = sext i32 %parent55 to i64
  %arr.len56 = load i64, ptr %heap54, align 8
  %arr.oob57 = icmp uge i64 %27, %arr.len56
  br i1 %arr.oob57, label %idx.bad58, label %idx.ok59, !prof !8

idx.bad58:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.53, ptr @.faila.54, i64 %27, ptr @.failb.55, i64 %arr.len56, i32 70)
  unreachable

idx.ok59:                                         ; preds = %idx.ok49
  %arr.data60 = getelementptr i8, ptr %heap54, i64 8
  %arr.elem61 = getelementptr inbounds i32, ptr %arr.data60, i64 %27
  %elem62 = load i32, ptr %arr.elem61, align 4
  %28 = icmp slt i32 %elem52, %elem62
  %29 = icmp sgt i32 %elem52, %elem62
  %30 = select i1 %29, i32 1, i32 0
  %31 = select i1 %28, i32 -1, i32 %30
  %32 = icmp sge i32 %31, 0
  %33 = zext i1 %32 to i32
  br i1 %32, label %if.then63, label %if.end64

if.then63:                                        ; preds = %idx.ok59
  br label %while.end

if.end64:                                         ; preds = %idx.ok59
  %heap65 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap66 = load ptr, ptr %heap65, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i67 = load i32, ptr %i, align 4
  %34 = sext i32 %i67 to i64
  %arr.len68 = load i64, ptr %heap66, align 8
  %arr.oob69 = icmp uge i64 %34, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !8

idx.bad70:                                        ; preds = %if.end64
  call void @__polaron_fail(ptr @.fail.56, ptr @.faila.57, i64 %34, ptr @.failb.58, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %if.end64
  %arr.data72 = getelementptr i8, ptr %heap66, i64 8
  %arr.elem73 = getelementptr inbounds i32, ptr %arr.data72, i64 %34
  %elem74 = load i32, ptr %arr.elem73, align 4
  store i32 %elem74, ptr %tmp, align 4
  %heap75 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap76 = load ptr, ptr %heap75, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i77 = load i32, ptr %i, align 4
  %35 = sext i32 %i77 to i64
  %arr.len78 = load i64, ptr %heap76, align 8
  %arr.oob79 = icmp uge i64 %35, %arr.len78
  br i1 %arr.oob79, label %idx.bad80, label %idx.ok81, !prof !8

idx.bad80:                                        ; preds = %idx.ok71
  call void @__polaron_fail(ptr @.fail.59, ptr @.faila.60, i64 %35, ptr @.failb.61, i64 %arr.len78, i32 70)
  unreachable

idx.ok81:                                         ; preds = %idx.ok71
  %arr.data82 = getelementptr i8, ptr %heap76, i64 8
  %arr.elem83 = getelementptr inbounds i32, ptr %arr.data82, i64 %35
  %heap84 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap85 = load ptr, ptr %heap84, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %parent86 = load i32, ptr %parent, align 4
  %36 = sext i32 %parent86 to i64
  %arr.len87 = load i64, ptr %heap85, align 8
  %arr.oob88 = icmp uge i64 %36, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !8

idx.bad89:                                        ; preds = %idx.ok81
  call void @__polaron_fail(ptr @.fail.62, ptr @.faila.63, i64 %36, ptr @.failb.64, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok81
  %arr.data91 = getelementptr i8, ptr %heap85, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 %36
  %elem93 = load i32, ptr %arr.elem92, align 4
  store i32 %elem93, ptr %arr.elem83, align 4
  %heap94 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap95 = load ptr, ptr %heap94, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %parent96 = load i32, ptr %parent, align 4
  %37 = sext i32 %parent96 to i64
  %arr.len97 = load i64, ptr %heap95, align 8
  %arr.oob98 = icmp uge i64 %37, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !8

idx.bad99:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.65, ptr @.faila.66, i64 %37, ptr @.failb.67, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok90
  %arr.data101 = getelementptr i8, ptr %heap95, i64 8
  %arr.elem102 = getelementptr inbounds i32, ptr %arr.data101, i64 %37
  %tmp103 = load i32, ptr %tmp, align 4
  store i32 %tmp103, ptr %arr.elem102, align 4
  %parent104 = load i32, ptr %parent, align 4
  store i32 %parent104, ptr %i, align 4
  br label %while.cond
}

define internal i32 @"PriorityQueue$int.peek"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap1 = load ptr, ptr %heap, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %heap1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.68, ptr @.faila.69, i64 0, ptr @.failb.70, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %heap1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @"PriorityQueue$int.poll"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %tmp = alloca i32, align 4
  %smallest = alloca i32, align 4
  %r = alloca i32, align 4
  %l = alloca i32, align 4
  %i = alloca i32, align 4
  %top = alloca i32, align 4
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap1 = load ptr, ptr %heap, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %heap1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.71, ptr @.faila.72, i64 0, ptr @.failb.73, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %heap1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %top, align 4
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count2 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %1 = sub i32 %count3, 1
  store i32 %1, ptr %count, align 4, !tbaa !4
  %heap4 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap5 = load ptr, ptr %heap4, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len6 = load i64, ptr %heap5, align 8
  %arr.oob7 = icmp uge i64 0, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !8

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.74, ptr @.faila.75, i64 0, ptr @.failb.76, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %heap5, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 0
  %heap12 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap13 = load ptr, ptr %heap12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count14 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %2 = sext i32 %count15 to i64
  %arr.len16 = load i64, ptr %heap13, align 8
  %arr.oob17 = icmp uge i64 %2, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

idx.bad18:                                        ; preds = %idx.ok9
  call void @__polaron_fail(ptr @.fail.77, ptr @.faila.78, i64 %2, ptr @.failb.79, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok9
  %arr.data20 = getelementptr i8, ptr %heap13, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %2
  %elem22 = load i32, ptr %arr.elem21, align 4
  store i32 %elem22, ptr %arr.elem11, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok120, %idx.ok19
  br i1 true, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i23 = load i32, ptr %i, align 4
  %3 = mul i32 2, %i23
  %4 = add i32 %3, 1
  store i32 %4, ptr %l, align 4
  %i24 = load i32, ptr %i, align 4
  %5 = mul i32 2, %i24
  %6 = add i32 %5, 2
  store i32 %6, ptr %r, align 4
  %i25 = load i32, ptr %i, align 4
  store i32 %i25, ptr %smallest, align 4
  %l26 = load i32, ptr %l, align 4
  %count27 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %7 = icmp slt i32 %l26, %count28
  %8 = zext i1 %7 to i32
  %sc.a = icmp ne i32 %8, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.end:                                        ; preds = %if.then83, %while.cond
  %top125 = load i32, ptr %top, align 4
  ret i32 %top125

sc.rhs:                                           ; preds = %while.body
  %heap29 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap30 = load ptr, ptr %heap29, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %l31 = load i32, ptr %l, align 4
  %9 = sext i32 %l31 to i64
  %arr.len32 = load i64, ptr %heap30, align 8
  %arr.oob33 = icmp uge i64 %9, %arr.len32
  br i1 %arr.oob33, label %idx.bad34, label %idx.ok35, !prof !8

sc.end:                                           ; preds = %idx.ok45, %while.body
  %sc = phi i1 [ false, %while.body ], [ %sc.b, %idx.ok45 ]
  %10 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad34:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.80, ptr @.faila.81, i64 %9, ptr @.failb.82, i64 %arr.len32, i32 70)
  unreachable

idx.ok35:                                         ; preds = %sc.rhs
  %arr.data36 = getelementptr i8, ptr %heap30, i64 8
  %arr.elem37 = getelementptr inbounds i32, ptr %arr.data36, i64 %9
  %elem38 = load i32, ptr %arr.elem37, align 4
  %heap39 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap40 = load ptr, ptr %heap39, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %smallest41 = load i32, ptr %smallest, align 4
  %11 = sext i32 %smallest41 to i64
  %arr.len42 = load i64, ptr %heap40, align 8
  %arr.oob43 = icmp uge i64 %11, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !8

idx.bad44:                                        ; preds = %idx.ok35
  call void @__polaron_fail(ptr @.fail.83, ptr @.faila.84, i64 %11, ptr @.failb.85, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok35
  %arr.data46 = getelementptr i8, ptr %heap40, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 %11
  %elem48 = load i32, ptr %arr.elem47, align 4
  %12 = icmp slt i32 %elem38, %elem48
  %13 = icmp sgt i32 %elem38, %elem48
  %14 = select i1 %13, i32 1, i32 0
  %15 = select i1 %12, i32 -1, i32 %14
  %16 = icmp slt i32 %15, 0
  %17 = zext i1 %16 to i32
  %sc.b = icmp ne i32 %17, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %l49 = load i32, ptr %l, align 4
  store i32 %l49, ptr %smallest, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  %r50 = load i32, ptr %r, align 4
  %count51 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !4
  %18 = icmp slt i32 %r50, %count52
  %19 = zext i1 %18 to i32
  %sc.a53 = icmp ne i32 %19, 0
  br i1 %sc.a53, label %sc.rhs54, label %sc.end55

sc.rhs54:                                         ; preds = %if.end
  %heap56 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap57 = load ptr, ptr %heap56, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r58 = load i32, ptr %r, align 4
  %20 = sext i32 %r58 to i64
  %arr.len59 = load i64, ptr %heap57, align 8
  %arr.oob60 = icmp uge i64 %20, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !8

sc.end55:                                         ; preds = %idx.ok72, %if.end
  %sc77 = phi i1 [ false, %if.end ], [ %sc.b76, %idx.ok72 ]
  %21 = zext i1 %sc77 to i32
  br i1 %sc77, label %if.then78, label %if.end79

idx.bad61:                                        ; preds = %sc.rhs54
  call void @__polaron_fail(ptr @.fail.86, ptr @.faila.87, i64 %20, ptr @.failb.88, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %sc.rhs54
  %arr.data63 = getelementptr i8, ptr %heap57, i64 8
  %arr.elem64 = getelementptr inbounds i32, ptr %arr.data63, i64 %20
  %elem65 = load i32, ptr %arr.elem64, align 4
  %heap66 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap67 = load ptr, ptr %heap66, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %smallest68 = load i32, ptr %smallest, align 4
  %22 = sext i32 %smallest68 to i64
  %arr.len69 = load i64, ptr %heap67, align 8
  %arr.oob70 = icmp uge i64 %22, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !8

idx.bad71:                                        ; preds = %idx.ok62
  call void @__polaron_fail(ptr @.fail.89, ptr @.faila.90, i64 %22, ptr @.failb.91, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok62
  %arr.data73 = getelementptr i8, ptr %heap67, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %22
  %elem75 = load i32, ptr %arr.elem74, align 4
  %23 = icmp slt i32 %elem65, %elem75
  %24 = icmp sgt i32 %elem65, %elem75
  %25 = select i1 %24, i32 1, i32 0
  %26 = select i1 %23, i32 -1, i32 %25
  %27 = icmp slt i32 %26, 0
  %28 = zext i1 %27 to i32
  %sc.b76 = icmp ne i32 %28, 0
  br label %sc.end55

if.then78:                                        ; preds = %sc.end55
  %r80 = load i32, ptr %r, align 4
  store i32 %r80, ptr %smallest, align 4
  br label %if.end79

if.end79:                                         ; preds = %if.then78, %sc.end55
  %smallest81 = load i32, ptr %smallest, align 4
  %i82 = load i32, ptr %i, align 4
  %29 = icmp eq i32 %smallest81, %i82
  %30 = zext i1 %29 to i32
  br i1 %29, label %if.then83, label %if.end84

if.then83:                                        ; preds = %if.end79
  br label %while.end

if.end84:                                         ; preds = %if.end79
  %heap85 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap86 = load ptr, ptr %heap85, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i87 = load i32, ptr %i, align 4
  %31 = sext i32 %i87 to i64
  %arr.len88 = load i64, ptr %heap86, align 8
  %arr.oob89 = icmp uge i64 %31, %arr.len88
  br i1 %arr.oob89, label %idx.bad90, label %idx.ok91, !prof !8

idx.bad90:                                        ; preds = %if.end84
  call void @__polaron_fail(ptr @.fail.92, ptr @.faila.93, i64 %31, ptr @.failb.94, i64 %arr.len88, i32 70)
  unreachable

idx.ok91:                                         ; preds = %if.end84
  %arr.data92 = getelementptr i8, ptr %heap86, i64 8
  %arr.elem93 = getelementptr inbounds i32, ptr %arr.data92, i64 %31
  %elem94 = load i32, ptr %arr.elem93, align 4
  store i32 %elem94, ptr %tmp, align 4
  %heap95 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap96 = load ptr, ptr %heap95, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i97 = load i32, ptr %i, align 4
  %32 = sext i32 %i97 to i64
  %arr.len98 = load i64, ptr %heap96, align 8
  %arr.oob99 = icmp uge i64 %32, %arr.len98
  br i1 %arr.oob99, label %idx.bad100, label %idx.ok101, !prof !8

idx.bad100:                                       ; preds = %idx.ok91
  call void @__polaron_fail(ptr @.fail.95, ptr @.faila.96, i64 %32, ptr @.failb.97, i64 %arr.len98, i32 70)
  unreachable

idx.ok101:                                        ; preds = %idx.ok91
  %arr.data102 = getelementptr i8, ptr %heap96, i64 8
  %arr.elem103 = getelementptr inbounds i32, ptr %arr.data102, i64 %32
  %heap104 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap105 = load ptr, ptr %heap104, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %smallest106 = load i32, ptr %smallest, align 4
  %33 = sext i32 %smallest106 to i64
  %arr.len107 = load i64, ptr %heap105, align 8
  %arr.oob108 = icmp uge i64 %33, %arr.len107
  br i1 %arr.oob108, label %idx.bad109, label %idx.ok110, !prof !8

idx.bad109:                                       ; preds = %idx.ok101
  call void @__polaron_fail(ptr @.fail.98, ptr @.faila.99, i64 %33, ptr @.failb.100, i64 %arr.len107, i32 70)
  unreachable

idx.ok110:                                        ; preds = %idx.ok101
  %arr.data111 = getelementptr i8, ptr %heap105, i64 8
  %arr.elem112 = getelementptr inbounds i32, ptr %arr.data111, i64 %33
  %elem113 = load i32, ptr %arr.elem112, align 4
  store i32 %elem113, ptr %arr.elem103, align 4
  %heap114 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap115 = load ptr, ptr %heap114, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %smallest116 = load i32, ptr %smallest, align 4
  %34 = sext i32 %smallest116 to i64
  %arr.len117 = load i64, ptr %heap115, align 8
  %arr.oob118 = icmp uge i64 %34, %arr.len117
  br i1 %arr.oob118, label %idx.bad119, label %idx.ok120, !prof !8

idx.bad119:                                       ; preds = %idx.ok110
  call void @__polaron_fail(ptr @.fail.101, ptr @.faila.102, i64 %34, ptr @.failb.103, i64 %arr.len117, i32 70)
  unreachable

idx.ok120:                                        ; preds = %idx.ok110
  %arr.data121 = getelementptr i8, ptr %heap115, i64 8
  %arr.elem122 = getelementptr inbounds i32, ptr %arr.data121, i64 %34
  %tmp123 = load i32, ptr %tmp, align 4
  store i32 %tmp123, ptr %arr.elem122, align 4
  %smallest124 = load i32, ptr %smallest, align 4
  store i32 %smallest124, ptr %i, align 4
  br label %while.cond
}

define internal i32 @"PriorityQueue$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"PriorityQueue$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1371)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1373)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5372)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5374)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @__polaron_str_copy(ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

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
