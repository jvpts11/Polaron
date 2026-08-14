; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/number_words.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/number_words.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@.str = private unnamed_addr constant [6 x i8] c"a=%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"b=%s\0A\00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"c=%s\0A\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"d=%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1307 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1308 = private global %String { i64 16, ptr @.strdata.1307, i64 0 }
@.strdata.1309 = private constant [17 x i8] c"division by zero\00"
@.strobj.1310 = private global %String { i64 16, ptr @.strdata.1309, i64 0 }
@.fail.2656 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4346:21  in NumberWords.ones\0A\00", align 1
@.faila.2657 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2658 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2659 = private constant [1 x i8] zeroinitializer
@.strobj.2660 = private global %String { i64 0, ptr @.strdata.2659, i64 0 }
@.fail.2661 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4346:30  in NumberWords.ones\0A\00", align 1
@.faila.2662 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2663 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2664 = private constant [4 x i8] c"one\00"
@.strobj.2665 = private global %String { i64 3, ptr @.strdata.2664, i64 0 }
@.fail.2666 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4346:42  in NumberWords.ones\0A\00", align 1
@.faila.2667 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2668 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2669 = private constant [4 x i8] c"two\00"
@.strobj.2670 = private global %String { i64 3, ptr @.strdata.2669, i64 0 }
@.fail.2671 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4346:54  in NumberWords.ones\0A\00", align 1
@.faila.2672 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2673 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2674 = private constant [6 x i8] c"three\00"
@.strobj.2675 = private global %String { i64 5, ptr @.strdata.2674, i64 0 }
@.fail.2676 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4346:68  in NumberWords.ones\0A\00", align 1
@.faila.2677 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2678 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2679 = private constant [5 x i8] c"four\00"
@.strobj.2680 = private global %String { i64 4, ptr @.strdata.2679, i64 0 }
@.fail.2681 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4347:21  in NumberWords.ones\0A\00", align 1
@.faila.2682 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2683 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2684 = private constant [5 x i8] c"five\00"
@.strobj.2685 = private global %String { i64 4, ptr @.strdata.2684, i64 0 }
@.fail.2686 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4347:34  in NumberWords.ones\0A\00", align 1
@.faila.2687 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2688 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2689 = private constant [4 x i8] c"six\00"
@.strobj.2690 = private global %String { i64 3, ptr @.strdata.2689, i64 0 }
@.fail.2691 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4347:46  in NumberWords.ones\0A\00", align 1
@.faila.2692 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2693 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2694 = private constant [6 x i8] c"seven\00"
@.strobj.2695 = private global %String { i64 5, ptr @.strdata.2694, i64 0 }
@.fail.2696 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4347:60  in NumberWords.ones\0A\00", align 1
@.faila.2697 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2698 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2699 = private constant [6 x i8] c"eight\00"
@.strobj.2700 = private global %String { i64 5, ptr @.strdata.2699, i64 0 }
@.fail.2701 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4347:74  in NumberWords.ones\0A\00", align 1
@.faila.2702 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2703 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2704 = private constant [5 x i8] c"nine\00"
@.strobj.2705 = private global %String { i64 4, ptr @.strdata.2704, i64 0 }
@.fail.2706 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4348:17  in NumberWords.ones\0A\00", align 1
@.faila.2707 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2708 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2709 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4352:21  in NumberWords.teens\0A\00", align 1
@.faila.2710 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2711 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2712 = private constant [4 x i8] c"ten\00"
@.strobj.2713 = private global %String { i64 3, ptr @.strdata.2712, i64 0 }
@.fail.2714 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4352:33  in NumberWords.teens\0A\00", align 1
@.faila.2715 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2716 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2717 = private constant [7 x i8] c"eleven\00"
@.strobj.2718 = private global %String { i64 6, ptr @.strdata.2717, i64 0 }
@.fail.2719 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4352:48  in NumberWords.teens\0A\00", align 1
@.faila.2720 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2721 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2722 = private constant [7 x i8] c"twelve\00"
@.strobj.2723 = private global %String { i64 6, ptr @.strdata.2722, i64 0 }
@.fail.2724 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4352:63  in NumberWords.teens\0A\00", align 1
@.faila.2725 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2726 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2727 = private constant [9 x i8] c"thirteen\00"
@.strobj.2728 = private global %String { i64 8, ptr @.strdata.2727, i64 0 }
@.fail.2729 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4352:80  in NumberWords.teens\0A\00", align 1
@.faila.2730 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2731 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2732 = private constant [9 x i8] c"fourteen\00"
@.strobj.2733 = private global %String { i64 8, ptr @.strdata.2732, i64 0 }
@.fail.2734 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4353:21  in NumberWords.teens\0A\00", align 1
@.faila.2735 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2736 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2737 = private constant [8 x i8] c"fifteen\00"
@.strobj.2738 = private global %String { i64 7, ptr @.strdata.2737, i64 0 }
@.fail.2739 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4353:37  in NumberWords.teens\0A\00", align 1
@.faila.2740 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2741 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2742 = private constant [8 x i8] c"sixteen\00"
@.strobj.2743 = private global %String { i64 7, ptr @.strdata.2742, i64 0 }
@.fail.2744 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4353:53  in NumberWords.teens\0A\00", align 1
@.faila.2745 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2746 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2747 = private constant [10 x i8] c"seventeen\00"
@.strobj.2748 = private global %String { i64 9, ptr @.strdata.2747, i64 0 }
@.fail.2749 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4353:71  in NumberWords.teens\0A\00", align 1
@.faila.2750 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2751 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2752 = private constant [9 x i8] c"eighteen\00"
@.strobj.2753 = private global %String { i64 8, ptr @.strdata.2752, i64 0 }
@.fail.2754 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4353:88  in NumberWords.teens\0A\00", align 1
@.faila.2755 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2756 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2757 = private constant [9 x i8] c"nineteen\00"
@.strobj.2758 = private global %String { i64 8, ptr @.strdata.2757, i64 0 }
@.fail.2759 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4354:17  in NumberWords.teens\0A\00", align 1
@.faila.2760 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2761 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2762 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4358:21  in NumberWords.tens\0A\00", align 1
@.faila.2763 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2764 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2765 = private constant [7 x i8] c"twenty\00"
@.strobj.2766 = private global %String { i64 6, ptr @.strdata.2765, i64 0 }
@.fail.2767 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4358:36  in NumberWords.tens\0A\00", align 1
@.faila.2768 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2769 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2770 = private constant [7 x i8] c"thirty\00"
@.strobj.2771 = private global %String { i64 6, ptr @.strdata.2770, i64 0 }
@.fail.2772 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4358:51  in NumberWords.tens\0A\00", align 1
@.faila.2773 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2774 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2775 = private constant [6 x i8] c"forty\00"
@.strobj.2776 = private global %String { i64 5, ptr @.strdata.2775, i64 0 }
@.fail.2777 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4358:65  in NumberWords.tens\0A\00", align 1
@.faila.2778 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2779 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2780 = private constant [6 x i8] c"fifty\00"
@.strobj.2781 = private global %String { i64 5, ptr @.strdata.2780, i64 0 }
@.fail.2782 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4359:21  in NumberWords.tens\0A\00", align 1
@.faila.2783 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2784 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2785 = private constant [6 x i8] c"sixty\00"
@.strobj.2786 = private global %String { i64 5, ptr @.strdata.2785, i64 0 }
@.fail.2787 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4359:35  in NumberWords.tens\0A\00", align 1
@.faila.2788 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2789 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2790 = private constant [8 x i8] c"seventy\00"
@.strobj.2791 = private global %String { i64 7, ptr @.strdata.2790, i64 0 }
@.fail.2792 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4359:51  in NumberWords.tens\0A\00", align 1
@.faila.2793 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2794 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2795 = private constant [7 x i8] c"eighty\00"
@.strobj.2796 = private global %String { i64 6, ptr @.strdata.2795, i64 0 }
@.fail.2797 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4359:66  in NumberWords.tens\0A\00", align 1
@.faila.2798 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2799 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2800 = private constant [7 x i8] c"ninety\00"
@.strobj.2801 = private global %String { i64 6, ptr @.strdata.2800, i64 0 }
@.fail.2802 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4360:17  in NumberWords.tens\0A\00", align 1
@.faila.2803 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2804 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2805 = private constant [2 x i8] c" \00"
@.strobj.2806 = private global %String { i64 1, ptr @.strdata.2805, i64 0 }
@.strdata.2807 = private constant [9 x i8] c" hundred\00"
@.strobj.2808 = private global %String { i64 8, ptr @.strdata.2807, i64 0 }
@.strdata.2809 = private constant [2 x i8] c" \00"
@.strobj.2810 = private global %String { i64 1, ptr @.strdata.2809, i64 0 }
@.strdata.2811 = private constant [5 x i8] c"zero\00"
@.strobj.2812 = private global %String { i64 4, ptr @.strdata.2811, i64 0 }
@.strdata.2813 = private constant [1 x i8] zeroinitializer
@.strobj.2814 = private global %String { i64 0, ptr @.strdata.2813, i64 0 }
@.strdata.2815 = private constant [7 x i8] c"minus \00"
@.strobj.2816 = private global %String { i64 6, ptr @.strdata.2815, i64 0 }
@.fail.2817 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4384:25  in NumberWords.toWords\0A\00", align 1
@.faila.2818 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2819 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2820 = private constant [1 x i8] zeroinitializer
@.strobj.2821 = private global %String { i64 0, ptr @.strdata.2820, i64 0 }
@.fail.2822 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4384:38  in NumberWords.toWords\0A\00", align 1
@.faila.2823 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2824 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2825 = private constant [10 x i8] c" thousand\00"
@.strobj.2826 = private global %String { i64 9, ptr @.strdata.2825, i64 0 }
@.fail.2827 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4384:60  in NumberWords.toWords\0A\00", align 1
@.faila.2828 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2829 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2830 = private constant [9 x i8] c" million\00"
@.strobj.2831 = private global %String { i64 8, ptr @.strdata.2830, i64 0 }
@.fail.2832 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4384:81  in NumberWords.toWords\0A\00", align 1
@.faila.2833 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2834 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2835 = private constant [9 x i8] c" billion\00"
@.strobj.2836 = private global %String { i64 8, ptr @.strdata.2835, i64 0 }
@.fail.2837 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4388:40  in NumberWords.toWords\0A\00", align 1
@.faila.2838 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2839 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2840 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4391:21  in NumberWords.toWords\0A\00", align 1
@.faila.2841 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2842 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2843 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4393:34  in NumberWords.toWords\0A\00", align 1
@.faila.2844 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2845 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2846 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4394:34  in NumberWords.toWords\0A\00", align 1
@.faila.2847 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2848 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %16 = call ptr @NumberWords.toWords(i32 0)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %17 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %16)
  %18 = call ptr @NumberWords.toWords(i32 42)
  %str.data1 = getelementptr inbounds %String, ptr %18, i32 0, i32 1
  %data2 = load ptr, ptr %str.data1, align 8
  %19 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data2)
  call void @__polaron_str_free(ptr %18)
  %20 = call ptr @NumberWords.toWords(i32 1234)
  %str.data3 = getelementptr inbounds %String, ptr %20, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %21 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr %data4)
  call void @__polaron_str_free(ptr %20)
  %22 = call ptr @NumberWords.toWords(i32 1234567)
  %str.data5 = getelementptr inbounds %String, ptr %22, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %23 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr %data6)
  call void @__polaron_str_free(ptr %22)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1308)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1310)
  ret ptr %strcpy
}

define internal void @StringBuilder.StringBuilder(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 0
  store ptr @StringBuilder.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  store i32 16, ptr %cap, align 4, !tbaa !4
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %1 = ptrtoint ptr %mem.alloc to i64
  store i64 %1, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @StringBuilder.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %nb = alloca i64, align 8
  %n = alloca i32, align 4
  %extra = alloca i32, align 4
  store i32 %1, ptr %extra, align 4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %extra2 = load i32, ptr %extra, align 4
  %2 = add i32 %count1, %extra2
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap3 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %2, %cap3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap5 = load i32, ptr %cap4, align 4, !tbaa !4
  %5 = mul i32 %cap5, 2
  store i32 %5, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %n6 = load i32, ptr %n, align 4
  %count7 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %extra9 = load i32, ptr %extra, align 4
  %6 = add i32 %count8, %extra9
  %7 = icmp slt i32 %n6, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n10 = load i32, ptr %n, align 4
  %9 = mul i32 %n10, 2
  store i32 %9, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n11 = load i32, ptr %n, align 4
  %10 = zext i32 %n11 to i64
  %mem.alloc = call ptr @__polaron_malloc(i64 %10)
  %11 = ptrtoint ptr %mem.alloc to i64
  store i64 %11, ptr %nb, align 8
  %nb12 = load i64, ptr %nb, align 8
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf13 = load i64, ptr %buf, align 8, !tbaa !6
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !6
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !6
  %cap20 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %n21 = load i32, ptr %n, align 4
  store i32 %n21, ptr %cap20, align 4, !tbaa !4
  ret void
}

define internal ptr @StringBuilder.append(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  call void @StringBuilder.ensure(ptr %0, i32 %n2)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !4
  %3 = sext i32 %count4 to i64
  %4 = add i64 %buf3, %3
  %s5 = load ptr, ptr %s, align 8
  %5 = inttoptr i64 %4 to ptr
  %str.len6 = getelementptr inbounds %String, ptr %s5, i32 0, i32 0
  %len7 = load i64, ptr %str.len6, align 8
  %str.data = getelementptr inbounds %String, ptr %s5, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %6 = call ptr @memcpy(ptr %5, ptr %data, i64 %len7)
  %count8 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count9 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %n11 = load i32, ptr %n, align 4
  %7 = add i32 %count10, %n11
  store i32 %7, ptr %count8, align 4, !tbaa !4
  ret ptr %0
}

define internal ptr @StringBuilder.appendChar(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  store i32 %1, ptr %c, align 4
  call void @StringBuilder.ensure(ptr %0, i32 1)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %2 = sext i32 %count2 to i64
  %3 = add i64 %buf1, %2
  %c3 = load i32, ptr %c, align 4
  %4 = trunc i32 %c3 to i8
  %5 = inttoptr i64 %3 to ptr
  store i8 %4, ptr %5, align 1
  %count4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count5 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count6 = load i32, ptr %count5, align 4, !tbaa !4
  %6 = add i32 %count6, 1
  store i32 %6, ptr %count4, align 4, !tbaa !4
  ret ptr %0
}

define internal ptr @StringBuilder.appendInt(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i8, align 1
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %exc.thrown15 = alloca ptr, align 8
  %d = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %start = alloca i32, align 4
  %v = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  call void @StringBuilder.ensure(ptr %0, i32 12)
  %value1 = load i32, ptr %value, align 4
  %2 = icmp eq i32 %value1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %4 = call ptr @StringBuilder.appendChar(ptr %0, i32 48)
  ret ptr %4

if.end:                                           ; preds = %entry
  %value2 = load i32, ptr %value, align 4
  store i32 %value2, ptr %v, align 4
  %v3 = load i32, ptr %v, align 4
  %5 = icmp sgt i32 %v3, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then4, label %if.else

if.then4:                                         ; preds = %if.end
  %v6 = load i32, ptr %v, align 4
  %7 = sub i32 0, %v6
  store i32 %7, ptr %v, align 4
  br label %if.end5

if.else:                                          ; preds = %if.end
  %8 = call ptr @StringBuilder.appendChar(ptr %0, i32 45)
  br label %if.end5

if.end5:                                          ; preds = %if.else, %if.then4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count, align 4, !tbaa !4
  store i32 %count7, ptr %start, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok13, %if.end5
  %v8 = load i32, ptr %v, align 4
  %9 = icmp ne i32 %v8, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v9 = load i32, ptr %v, align 4
  %11 = icmp eq i32 %v9, -2147483648
  %12 = and i1 %11, false
  %13 = or i1 false, %12
  br i1 %13, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  %start16 = load i32, ptr %start, align 4
  store i32 %start16, ptr %a, align 4
  %count17 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %14 = sub i32 %count18, 1
  store i32 %14, ptr %b, align 4
  br label %while.cond19

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %15 = srem i32 %v9, 10
  %16 = sub i32 0, %15
  store i32 %16, ptr %d, align 4
  %d10 = load i32, ptr %d, align 4
  %17 = add i32 48, %d10
  %18 = call ptr @StringBuilder.appendChar(ptr %0, i32 %17)
  %v11 = load i32, ptr %v, align 4
  %19 = icmp eq i32 %v11, -2147483648
  %20 = and i1 %19, false
  %21 = or i1 false, %20
  br i1 %21, label %div.bad12, label %div.ok13

div.bad12:                                        ; preds = %div.ok
  %exc14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc14)
  store ptr %exc14, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

div.ok13:                                         ; preds = %div.ok
  %22 = sdiv i32 %v11, 10
  store i32 %22, ptr %v, align 4
  br label %while.cond

while.cond19:                                     ; preds = %while.body20, %while.end
  %a22 = load i32, ptr %a, align 4
  %b23 = load i32, ptr %b, align 4
  %23 = icmp slt i32 %a22, %b23
  %24 = zext i1 %23 to i32
  br i1 %23, label %while.body20, label %while.end21

while.body20:                                     ; preds = %while.cond19
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf24 = load i64, ptr %buf, align 8, !tbaa !6
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !6
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !6
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !6
  %b35 = load i32, ptr %b, align 4
  %34 = sext i32 %b35 to i64
  %35 = add i64 %buf34, %34
  %t36 = load i8, ptr %t, align 1
  %36 = inttoptr i64 %35 to ptr
  store i8 %t36, ptr %36, align 1
  %a37 = load i32, ptr %a, align 4
  %37 = add i32 %a37, 1
  store i32 %37, ptr %a, align 4
  %b38 = load i32, ptr %b, align 4
  %38 = sub i32 %b38, 1
  store i32 %38, ptr %b, align 4
  br label %while.cond19

while.end21:                                      ; preds = %while.cond19
  ret ptr %0
}

define internal i32 @StringBuilder.length(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal ptr @StringBuilder.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count2 to i64
  %2 = inttoptr i64 %buf1 to ptr
  %3 = add i64 %1, 1
  %fb.buf = call ptr @__polaron_malloc(i64 %3)
  %4 = call ptr @memcpy(ptr %fb.buf, ptr %2, i64 %1)
  %5 = getelementptr i8, ptr %fb.buf, i64 %1
  store i8 0, ptr %5, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %1, ptr %6, align 8
  %7 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %fb.buf, ptr %7, align 8
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %8, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy
}

define internal ptr @StringBuilder.clear(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret ptr %0
}

define internal void @"StringBuilder.~StringBuilder"(ptr %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !6
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !6
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal ptr @NumberWords.ones(i32 %0) {
entry:
  %w = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %arr = call ptr @__polaron_malloc(i64 88)
  store i64 10, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 80)
  store ptr %arr, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %w1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.2656, ptr @.faila.2657, i64 0, ptr @.failb.2658, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %w1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data2, i64 0
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2660)
  %2 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %arr.elem, align 8
  %w3 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len4 = load i64, ptr %w3, align 8
  %arr.oob5 = icmp uge i64 1, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !10

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2661, ptr @.faila.2662, i64 1, ptr @.failb.2663, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %w3, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 1
  %strcpy10 = call ptr @__polaron_str_copy(ptr @.strobj.2665)
  %3 = load ptr, ptr %arr.elem9, align 8
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy10, ptr %arr.elem9, align 8
  %w11 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len12 = load i64, ptr %w11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !10

idx.bad14:                                        ; preds = %idx.ok7
  call void @__polaron_fail(ptr @.fail.2666, ptr @.faila.2667, i64 2, ptr @.failb.2668, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok7
  %arr.data16 = getelementptr i8, ptr %w11, i64 8
  %arr.elem17 = getelementptr inbounds ptr, ptr %arr.data16, i64 2
  %strcpy18 = call ptr @__polaron_str_copy(ptr @.strobj.2670)
  %4 = load ptr, ptr %arr.elem17, align 8
  call void @__polaron_str_free(ptr %4)
  store ptr %strcpy18, ptr %arr.elem17, align 8
  %w19 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len20 = load i64, ptr %w19, align 8
  %arr.oob21 = icmp uge i64 3, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

idx.bad22:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.2671, ptr @.faila.2672, i64 3, ptr @.failb.2673, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok15
  %arr.data24 = getelementptr i8, ptr %w19, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 3
  %strcpy26 = call ptr @__polaron_str_copy(ptr @.strobj.2675)
  %5 = load ptr, ptr %arr.elem25, align 8
  call void @__polaron_str_free(ptr %5)
  store ptr %strcpy26, ptr %arr.elem25, align 8
  %w27 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len28 = load i64, ptr %w27, align 8
  %arr.oob29 = icmp uge i64 4, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !10

idx.bad30:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.2676, ptr @.faila.2677, i64 4, ptr @.failb.2678, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok23
  %arr.data32 = getelementptr i8, ptr %w27, i64 8
  %arr.elem33 = getelementptr inbounds ptr, ptr %arr.data32, i64 4
  %strcpy34 = call ptr @__polaron_str_copy(ptr @.strobj.2680)
  %6 = load ptr, ptr %arr.elem33, align 8
  call void @__polaron_str_free(ptr %6)
  store ptr %strcpy34, ptr %arr.elem33, align 8
  %w35 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len36 = load i64, ptr %w35, align 8
  %arr.oob37 = icmp uge i64 5, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !10

idx.bad38:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.2681, ptr @.faila.2682, i64 5, ptr @.failb.2683, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok31
  %arr.data40 = getelementptr i8, ptr %w35, i64 8
  %arr.elem41 = getelementptr inbounds ptr, ptr %arr.data40, i64 5
  %strcpy42 = call ptr @__polaron_str_copy(ptr @.strobj.2685)
  %7 = load ptr, ptr %arr.elem41, align 8
  call void @__polaron_str_free(ptr %7)
  store ptr %strcpy42, ptr %arr.elem41, align 8
  %w43 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len44 = load i64, ptr %w43, align 8
  %arr.oob45 = icmp uge i64 6, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !10

idx.bad46:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.2686, ptr @.faila.2687, i64 6, ptr @.failb.2688, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %idx.ok39
  %arr.data48 = getelementptr i8, ptr %w43, i64 8
  %arr.elem49 = getelementptr inbounds ptr, ptr %arr.data48, i64 6
  %strcpy50 = call ptr @__polaron_str_copy(ptr @.strobj.2690)
  %8 = load ptr, ptr %arr.elem49, align 8
  call void @__polaron_str_free(ptr %8)
  store ptr %strcpy50, ptr %arr.elem49, align 8
  %w51 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len52 = load i64, ptr %w51, align 8
  %arr.oob53 = icmp uge i64 7, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !10

idx.bad54:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.2691, ptr @.faila.2692, i64 7, ptr @.failb.2693, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %idx.ok47
  %arr.data56 = getelementptr i8, ptr %w51, i64 8
  %arr.elem57 = getelementptr inbounds ptr, ptr %arr.data56, i64 7
  %strcpy58 = call ptr @__polaron_str_copy(ptr @.strobj.2695)
  %9 = load ptr, ptr %arr.elem57, align 8
  call void @__polaron_str_free(ptr %9)
  store ptr %strcpy58, ptr %arr.elem57, align 8
  %w59 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len60 = load i64, ptr %w59, align 8
  %arr.oob61 = icmp uge i64 8, %arr.len60
  br i1 %arr.oob61, label %idx.bad62, label %idx.ok63, !prof !10

idx.bad62:                                        ; preds = %idx.ok55
  call void @__polaron_fail(ptr @.fail.2696, ptr @.faila.2697, i64 8, ptr @.failb.2698, i64 %arr.len60, i32 70)
  unreachable

idx.ok63:                                         ; preds = %idx.ok55
  %arr.data64 = getelementptr i8, ptr %w59, i64 8
  %arr.elem65 = getelementptr inbounds ptr, ptr %arr.data64, i64 8
  %strcpy66 = call ptr @__polaron_str_copy(ptr @.strobj.2700)
  %10 = load ptr, ptr %arr.elem65, align 8
  call void @__polaron_str_free(ptr %10)
  store ptr %strcpy66, ptr %arr.elem65, align 8
  %w67 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len68 = load i64, ptr %w67, align 8
  %arr.oob69 = icmp uge i64 9, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !10

idx.bad70:                                        ; preds = %idx.ok63
  call void @__polaron_fail(ptr @.fail.2701, ptr @.faila.2702, i64 9, ptr @.failb.2703, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %idx.ok63
  %arr.data72 = getelementptr i8, ptr %w67, i64 8
  %arr.elem73 = getelementptr inbounds ptr, ptr %arr.data72, i64 9
  %strcpy74 = call ptr @__polaron_str_copy(ptr @.strobj.2705)
  %11 = load ptr, ptr %arr.elem73, align 8
  call void @__polaron_str_free(ptr %11)
  store ptr %strcpy74, ptr %arr.elem73, align 8
  %w75 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %n76 = load i32, ptr %n, align 4
  %12 = sext i32 %n76 to i64
  %arr.len77 = load i64, ptr %w75, align 8
  %arr.oob78 = icmp uge i64 %12, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !10

idx.bad79:                                        ; preds = %idx.ok71
  call void @__polaron_fail(ptr @.fail.2706, ptr @.faila.2707, i64 %12, ptr @.failb.2708, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %idx.ok71
  %arr.data81 = getelementptr i8, ptr %w75, i64 8
  %arr.elem82 = getelementptr inbounds ptr, ptr %arr.data81, i64 %12
  %elem = load ptr, ptr %arr.elem82, align 8
  %strcpy83 = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy83
}

define internal ptr @NumberWords.teens(i32 %0) {
entry:
  %w = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %arr = call ptr @__polaron_malloc(i64 88)
  store i64 10, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 80)
  store ptr %arr, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %w1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.2709, ptr @.faila.2710, i64 0, ptr @.failb.2711, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %w1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data2, i64 0
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2713)
  %2 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %arr.elem, align 8
  %w3 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len4 = load i64, ptr %w3, align 8
  %arr.oob5 = icmp uge i64 1, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !10

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2714, ptr @.faila.2715, i64 1, ptr @.failb.2716, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %w3, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 1
  %strcpy10 = call ptr @__polaron_str_copy(ptr @.strobj.2718)
  %3 = load ptr, ptr %arr.elem9, align 8
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy10, ptr %arr.elem9, align 8
  %w11 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len12 = load i64, ptr %w11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !10

idx.bad14:                                        ; preds = %idx.ok7
  call void @__polaron_fail(ptr @.fail.2719, ptr @.faila.2720, i64 2, ptr @.failb.2721, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok7
  %arr.data16 = getelementptr i8, ptr %w11, i64 8
  %arr.elem17 = getelementptr inbounds ptr, ptr %arr.data16, i64 2
  %strcpy18 = call ptr @__polaron_str_copy(ptr @.strobj.2723)
  %4 = load ptr, ptr %arr.elem17, align 8
  call void @__polaron_str_free(ptr %4)
  store ptr %strcpy18, ptr %arr.elem17, align 8
  %w19 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len20 = load i64, ptr %w19, align 8
  %arr.oob21 = icmp uge i64 3, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

idx.bad22:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.2724, ptr @.faila.2725, i64 3, ptr @.failb.2726, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok15
  %arr.data24 = getelementptr i8, ptr %w19, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 3
  %strcpy26 = call ptr @__polaron_str_copy(ptr @.strobj.2728)
  %5 = load ptr, ptr %arr.elem25, align 8
  call void @__polaron_str_free(ptr %5)
  store ptr %strcpy26, ptr %arr.elem25, align 8
  %w27 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len28 = load i64, ptr %w27, align 8
  %arr.oob29 = icmp uge i64 4, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !10

idx.bad30:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.2729, ptr @.faila.2730, i64 4, ptr @.failb.2731, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok23
  %arr.data32 = getelementptr i8, ptr %w27, i64 8
  %arr.elem33 = getelementptr inbounds ptr, ptr %arr.data32, i64 4
  %strcpy34 = call ptr @__polaron_str_copy(ptr @.strobj.2733)
  %6 = load ptr, ptr %arr.elem33, align 8
  call void @__polaron_str_free(ptr %6)
  store ptr %strcpy34, ptr %arr.elem33, align 8
  %w35 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len36 = load i64, ptr %w35, align 8
  %arr.oob37 = icmp uge i64 5, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !10

idx.bad38:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.2734, ptr @.faila.2735, i64 5, ptr @.failb.2736, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok31
  %arr.data40 = getelementptr i8, ptr %w35, i64 8
  %arr.elem41 = getelementptr inbounds ptr, ptr %arr.data40, i64 5
  %strcpy42 = call ptr @__polaron_str_copy(ptr @.strobj.2738)
  %7 = load ptr, ptr %arr.elem41, align 8
  call void @__polaron_str_free(ptr %7)
  store ptr %strcpy42, ptr %arr.elem41, align 8
  %w43 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len44 = load i64, ptr %w43, align 8
  %arr.oob45 = icmp uge i64 6, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !10

idx.bad46:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.2739, ptr @.faila.2740, i64 6, ptr @.failb.2741, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %idx.ok39
  %arr.data48 = getelementptr i8, ptr %w43, i64 8
  %arr.elem49 = getelementptr inbounds ptr, ptr %arr.data48, i64 6
  %strcpy50 = call ptr @__polaron_str_copy(ptr @.strobj.2743)
  %8 = load ptr, ptr %arr.elem49, align 8
  call void @__polaron_str_free(ptr %8)
  store ptr %strcpy50, ptr %arr.elem49, align 8
  %w51 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len52 = load i64, ptr %w51, align 8
  %arr.oob53 = icmp uge i64 7, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !10

idx.bad54:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.2744, ptr @.faila.2745, i64 7, ptr @.failb.2746, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %idx.ok47
  %arr.data56 = getelementptr i8, ptr %w51, i64 8
  %arr.elem57 = getelementptr inbounds ptr, ptr %arr.data56, i64 7
  %strcpy58 = call ptr @__polaron_str_copy(ptr @.strobj.2748)
  %9 = load ptr, ptr %arr.elem57, align 8
  call void @__polaron_str_free(ptr %9)
  store ptr %strcpy58, ptr %arr.elem57, align 8
  %w59 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len60 = load i64, ptr %w59, align 8
  %arr.oob61 = icmp uge i64 8, %arr.len60
  br i1 %arr.oob61, label %idx.bad62, label %idx.ok63, !prof !10

idx.bad62:                                        ; preds = %idx.ok55
  call void @__polaron_fail(ptr @.fail.2749, ptr @.faila.2750, i64 8, ptr @.failb.2751, i64 %arr.len60, i32 70)
  unreachable

idx.ok63:                                         ; preds = %idx.ok55
  %arr.data64 = getelementptr i8, ptr %w59, i64 8
  %arr.elem65 = getelementptr inbounds ptr, ptr %arr.data64, i64 8
  %strcpy66 = call ptr @__polaron_str_copy(ptr @.strobj.2753)
  %10 = load ptr, ptr %arr.elem65, align 8
  call void @__polaron_str_free(ptr %10)
  store ptr %strcpy66, ptr %arr.elem65, align 8
  %w67 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len68 = load i64, ptr %w67, align 8
  %arr.oob69 = icmp uge i64 9, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !10

idx.bad70:                                        ; preds = %idx.ok63
  call void @__polaron_fail(ptr @.fail.2754, ptr @.faila.2755, i64 9, ptr @.failb.2756, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %idx.ok63
  %arr.data72 = getelementptr i8, ptr %w67, i64 8
  %arr.elem73 = getelementptr inbounds ptr, ptr %arr.data72, i64 9
  %strcpy74 = call ptr @__polaron_str_copy(ptr @.strobj.2758)
  %11 = load ptr, ptr %arr.elem73, align 8
  call void @__polaron_str_free(ptr %11)
  store ptr %strcpy74, ptr %arr.elem73, align 8
  %w75 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %n76 = load i32, ptr %n, align 4
  %12 = sub i32 %n76, 10
  %13 = sext i32 %12 to i64
  %arr.len77 = load i64, ptr %w75, align 8
  %arr.oob78 = icmp uge i64 %13, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !10

idx.bad79:                                        ; preds = %idx.ok71
  call void @__polaron_fail(ptr @.fail.2759, ptr @.faila.2760, i64 %13, ptr @.failb.2761, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %idx.ok71
  %arr.data81 = getelementptr i8, ptr %w75, i64 8
  %arr.elem82 = getelementptr inbounds ptr, ptr %arr.data81, i64 %13
  %elem = load ptr, ptr %arr.elem82, align 8
  %strcpy83 = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy83
}

define internal ptr @NumberWords.tens(i32 %0) {
entry:
  %w = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %arr = call ptr @__polaron_malloc(i64 88)
  store i64 10, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 80)
  store ptr %arr, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %w1, align 8
  %arr.oob = icmp uge i64 2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.2762, ptr @.faila.2763, i64 2, ptr @.failb.2764, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %w1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data2, i64 2
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2766)
  %2 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %arr.elem, align 8
  %w3 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len4 = load i64, ptr %w3, align 8
  %arr.oob5 = icmp uge i64 3, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !10

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2767, ptr @.faila.2768, i64 3, ptr @.failb.2769, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %w3, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 3
  %strcpy10 = call ptr @__polaron_str_copy(ptr @.strobj.2771)
  %3 = load ptr, ptr %arr.elem9, align 8
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy10, ptr %arr.elem9, align 8
  %w11 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len12 = load i64, ptr %w11, align 8
  %arr.oob13 = icmp uge i64 4, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !10

idx.bad14:                                        ; preds = %idx.ok7
  call void @__polaron_fail(ptr @.fail.2772, ptr @.faila.2773, i64 4, ptr @.failb.2774, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok7
  %arr.data16 = getelementptr i8, ptr %w11, i64 8
  %arr.elem17 = getelementptr inbounds ptr, ptr %arr.data16, i64 4
  %strcpy18 = call ptr @__polaron_str_copy(ptr @.strobj.2776)
  %4 = load ptr, ptr %arr.elem17, align 8
  call void @__polaron_str_free(ptr %4)
  store ptr %strcpy18, ptr %arr.elem17, align 8
  %w19 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len20 = load i64, ptr %w19, align 8
  %arr.oob21 = icmp uge i64 5, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

idx.bad22:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.2777, ptr @.faila.2778, i64 5, ptr @.failb.2779, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok15
  %arr.data24 = getelementptr i8, ptr %w19, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 5
  %strcpy26 = call ptr @__polaron_str_copy(ptr @.strobj.2781)
  %5 = load ptr, ptr %arr.elem25, align 8
  call void @__polaron_str_free(ptr %5)
  store ptr %strcpy26, ptr %arr.elem25, align 8
  %w27 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len28 = load i64, ptr %w27, align 8
  %arr.oob29 = icmp uge i64 6, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !10

idx.bad30:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.2782, ptr @.faila.2783, i64 6, ptr @.failb.2784, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok23
  %arr.data32 = getelementptr i8, ptr %w27, i64 8
  %arr.elem33 = getelementptr inbounds ptr, ptr %arr.data32, i64 6
  %strcpy34 = call ptr @__polaron_str_copy(ptr @.strobj.2786)
  %6 = load ptr, ptr %arr.elem33, align 8
  call void @__polaron_str_free(ptr %6)
  store ptr %strcpy34, ptr %arr.elem33, align 8
  %w35 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len36 = load i64, ptr %w35, align 8
  %arr.oob37 = icmp uge i64 7, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !10

idx.bad38:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.2787, ptr @.faila.2788, i64 7, ptr @.failb.2789, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok31
  %arr.data40 = getelementptr i8, ptr %w35, i64 8
  %arr.elem41 = getelementptr inbounds ptr, ptr %arr.data40, i64 7
  %strcpy42 = call ptr @__polaron_str_copy(ptr @.strobj.2791)
  %7 = load ptr, ptr %arr.elem41, align 8
  call void @__polaron_str_free(ptr %7)
  store ptr %strcpy42, ptr %arr.elem41, align 8
  %w43 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len44 = load i64, ptr %w43, align 8
  %arr.oob45 = icmp uge i64 8, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !10

idx.bad46:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.2792, ptr @.faila.2793, i64 8, ptr @.failb.2794, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %idx.ok39
  %arr.data48 = getelementptr i8, ptr %w43, i64 8
  %arr.elem49 = getelementptr inbounds ptr, ptr %arr.data48, i64 8
  %strcpy50 = call ptr @__polaron_str_copy(ptr @.strobj.2796)
  %8 = load ptr, ptr %arr.elem49, align 8
  call void @__polaron_str_free(ptr %8)
  store ptr %strcpy50, ptr %arr.elem49, align 8
  %w51 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %arr.len52 = load i64, ptr %w51, align 8
  %arr.oob53 = icmp uge i64 9, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !10

idx.bad54:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.2797, ptr @.faila.2798, i64 9, ptr @.failb.2799, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %idx.ok47
  %arr.data56 = getelementptr i8, ptr %w51, i64 8
  %arr.elem57 = getelementptr inbounds ptr, ptr %arr.data56, i64 9
  %strcpy58 = call ptr @__polaron_str_copy(ptr @.strobj.2801)
  %9 = load ptr, ptr %arr.elem57, align 8
  call void @__polaron_str_free(ptr %9)
  store ptr %strcpy58, ptr %arr.elem57, align 8
  %w59 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %n60 = load i32, ptr %n, align 4
  %10 = sext i32 %n60 to i64
  %arr.len61 = load i64, ptr %w59, align 8
  %arr.oob62 = icmp uge i64 %10, %arr.len61
  br i1 %arr.oob62, label %idx.bad63, label %idx.ok64, !prof !10

idx.bad63:                                        ; preds = %idx.ok55
  call void @__polaron_fail(ptr @.fail.2802, ptr @.faila.2803, i64 %10, ptr @.failb.2804, i64 %arr.len61, i32 70)
  unreachable

idx.ok64:                                         ; preds = %idx.ok55
  %arr.data65 = getelementptr i8, ptr %w59, i64 8
  %arr.elem66 = getelementptr inbounds ptr, ptr %arr.data65, i64 %10
  %elem = load ptr, ptr %arr.elem66, align 8
  %strcpy67 = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy67
}

define internal ptr @NumberWords.under100(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %o = alloca i32, align 4
  %exc.thrown13 = alloca ptr, align 8
  %t = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = icmp slt i32 %n1, 10
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %n2 = load i32, ptr %n, align 4
  %3 = call ptr @NumberWords.ones(i32 %n2)
  %strcpy = call ptr @__polaron_str_copy(ptr %3)
  call void @__polaron_str_free(ptr %3)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %n3 = load i32, ptr %n, align 4
  %4 = icmp slt i32 %n3, 20
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  %n6 = load i32, ptr %n, align 4
  %6 = call ptr @NumberWords.teens(i32 %n6)
  %strcpy7 = call ptr @__polaron_str_copy(ptr %6)
  call void @__polaron_str_free(ptr %6)
  ret ptr %strcpy7

if.end5:                                          ; preds = %if.end
  %n8 = load i32, ptr %n, align 4
  %7 = icmp eq i32 %n8, -2147483648
  %8 = and i1 %7, false
  %9 = or i1 false, %8
  br i1 %9, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end5
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end5
  %10 = sdiv i32 %n8, 10
  store i32 %10, ptr %t, align 4
  %n9 = load i32, ptr %n, align 4
  %11 = icmp eq i32 %n9, -2147483648
  %12 = and i1 %11, false
  %13 = or i1 false, %12
  br i1 %13, label %div.bad10, label %div.ok11

div.bad10:                                        ; preds = %div.ok
  %exc12 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc12)
  store ptr %exc12, ptr %exc.thrown13, align 8
  call void @_CxxThrowException(ptr %exc.thrown13, ptr @_TI1PEAX)
  unreachable

div.ok11:                                         ; preds = %div.ok
  %14 = srem i32 %n9, 10
  store i32 %14, ptr %o, align 4
  %o14 = load i32, ptr %o, align 4
  %15 = icmp eq i32 %o14, 0
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then15, label %if.end16

if.then15:                                        ; preds = %div.ok11
  %t17 = load i32, ptr %t, align 4
  %17 = call ptr @NumberWords.tens(i32 %t17)
  %strcpy18 = call ptr @__polaron_str_copy(ptr %17)
  call void @__polaron_str_free(ptr %17)
  ret ptr %strcpy18

if.end16:                                         ; preds = %div.ok11
  %t19 = load i32, ptr %t, align 4
  %18 = call ptr @NumberWords.tens(i32 %t19)
  %str.len = getelementptr inbounds %String, ptr %18, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len20 = load i64, ptr @.strobj.2806, align 8
  %19 = add i64 %len, %len20
  %20 = add i64 %19, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %20)
  %str.data = getelementptr inbounds %String, ptr %18, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %21 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data21 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2806, i32 0, i32 1), align 8
  %22 = getelementptr i8, ptr %cat.buf, i64 %len
  %23 = call ptr @memcpy(ptr %22, ptr %data21, i64 %len20)
  %24 = getelementptr i8, ptr %cat.buf, i64 %19
  store i8 0, ptr %24, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %25 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %19, ptr %25, align 8
  %26 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %27, align 8
  %o22 = load i32, ptr %o, align 4
  %28 = call ptr @NumberWords.ones(i32 %o22)
  %str.len23 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  %len24 = load i64, ptr %str.len23, align 8
  %str.len25 = getelementptr inbounds %String, ptr %28, i32 0, i32 0
  %len26 = load i64, ptr %str.len25, align 8
  %29 = add i64 %len24, %len26
  %30 = add i64 %29, 1
  %cat.buf27 = call ptr @__polaron_malloc(i64 %30)
  %str.data28 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  %data29 = load ptr, ptr %str.data28, align 8
  %31 = call ptr @memcpy(ptr %cat.buf27, ptr %data29, i64 %len24)
  %str.data30 = getelementptr inbounds %String, ptr %28, i32 0, i32 1
  %data31 = load ptr, ptr %str.data30, align 8
  %32 = getelementptr i8, ptr %cat.buf27, i64 %len24
  %33 = call ptr @memcpy(ptr %32, ptr %data31, i64 %len26)
  %34 = getelementptr i8, ptr %cat.buf27, i64 %29
  store i8 0, ptr %34, align 1
  %newstr32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 0
  store i64 %29, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  store ptr %cat.buf27, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %strcpy33 = call ptr @__polaron_str_copy(ptr %newstr32)
  call void @__polaron_str_free(ptr %18)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %28)
  call void @__polaron_str_free(ptr %newstr32)
  ret ptr %strcpy33
}

define internal ptr @NumberWords.under1000(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %s = alloca ptr, align 8
  %r = alloca i32, align 4
  %exc.thrown8 = alloca ptr, align 8
  %h = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = icmp slt i32 %n1, 100
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %n2 = load i32, ptr %n, align 4
  %3 = call ptr @NumberWords.under100(i32 %n2)
  %strcpy = call ptr @__polaron_str_copy(ptr %3)
  call void @__polaron_str_free(ptr %3)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %n3 = load i32, ptr %n, align 4
  %4 = icmp eq i32 %n3, -2147483648
  %5 = and i1 %4, false
  %6 = or i1 false, %5
  br i1 %6, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end
  %7 = sdiv i32 %n3, 100
  store i32 %7, ptr %h, align 4
  %n4 = load i32, ptr %n, align 4
  %8 = icmp eq i32 %n4, -2147483648
  %9 = and i1 %8, false
  %10 = or i1 false, %9
  br i1 %10, label %div.bad5, label %div.ok6

div.bad5:                                         ; preds = %div.ok
  %exc7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc7)
  store ptr %exc7, ptr %exc.thrown8, align 8
  call void @_CxxThrowException(ptr %exc.thrown8, ptr @_TI1PEAX)
  unreachable

div.ok6:                                          ; preds = %div.ok
  %11 = srem i32 %n4, 100
  store i32 %11, ptr %r, align 4
  %h9 = load i32, ptr %h, align 4
  %12 = call ptr @NumberWords.ones(i32 %h9)
  %str.len = getelementptr inbounds %String, ptr %12, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len10 = load i64, ptr @.strobj.2808, align 8
  %13 = add i64 %len, %len10
  %14 = add i64 %13, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %14)
  %str.data = getelementptr inbounds %String, ptr %12, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %15 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data11 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2808, i32 0, i32 1), align 8
  %16 = getelementptr i8, ptr %cat.buf, i64 %len
  %17 = call ptr @memcpy(ptr %16, ptr %data11, i64 %len10)
  %18 = getelementptr i8, ptr %cat.buf, i64 %13
  store i8 0, ptr %18, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %19 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %13, ptr %19, align 8
  %20 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %21, align 8
  %strcpy12 = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy12, ptr %s, align 8
  call void @__polaron_str_free(ptr %12)
  call void @__polaron_str_free(ptr %newstr)
  %r13 = load i32, ptr %r, align 4
  %22 = icmp sgt i32 %r13, 0
  %23 = zext i1 %22 to i32
  br i1 %22, label %if.then14, label %if.end15

if.then14:                                        ; preds = %div.ok6
  %s16 = load ptr, ptr %s, align 8
  %str.len17 = getelementptr inbounds %String, ptr %s16, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  %len19 = load i64, ptr @.strobj.2810, align 8
  %24 = add i64 %len18, %len19
  %25 = add i64 %24, 1
  %cat.buf20 = call ptr @__polaron_malloc(i64 %25)
  %str.data21 = getelementptr inbounds %String, ptr %s16, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %26 = call ptr @memcpy(ptr %cat.buf20, ptr %data22, i64 %len18)
  %data23 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2810, i32 0, i32 1), align 8
  %27 = getelementptr i8, ptr %cat.buf20, i64 %len18
  %28 = call ptr @memcpy(ptr %27, ptr %data23, i64 %len19)
  %29 = getelementptr i8, ptr %cat.buf20, i64 %24
  store i8 0, ptr %29, align 1
  %newstr24 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %30 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 0
  store i64 %24, ptr %30, align 8
  %31 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 1
  store ptr %cat.buf20, ptr %31, align 8
  %32 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 2
  store i64 0, ptr %32, align 8
  %r25 = load i32, ptr %r, align 4
  %33 = call ptr @NumberWords.under100(i32 %r25)
  %str.len26 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 0
  %len27 = load i64, ptr %str.len26, align 8
  %str.len28 = getelementptr inbounds %String, ptr %33, i32 0, i32 0
  %len29 = load i64, ptr %str.len28, align 8
  %34 = add i64 %len27, %len29
  %35 = add i64 %34, 1
  %cat.buf30 = call ptr @__polaron_malloc(i64 %35)
  %str.data31 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 1
  %data32 = load ptr, ptr %str.data31, align 8
  %36 = call ptr @memcpy(ptr %cat.buf30, ptr %data32, i64 %len27)
  %str.data33 = getelementptr inbounds %String, ptr %33, i32 0, i32 1
  %data34 = load ptr, ptr %str.data33, align 8
  %37 = getelementptr i8, ptr %cat.buf30, i64 %len27
  %38 = call ptr @memcpy(ptr %37, ptr %data34, i64 %len29)
  %39 = getelementptr i8, ptr %cat.buf30, i64 %34
  store i8 0, ptr %39, align 1
  %newstr35 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %40 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 0
  store i64 %34, ptr %40, align 8
  %41 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 1
  store ptr %cat.buf30, ptr %41, align 8
  %42 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 2
  store i64 0, ptr %42, align 8
  %strcpy36 = call ptr @__polaron_str_copy(ptr %newstr35)
  %43 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %43)
  store ptr %strcpy36, ptr %s, align 8
  call void @__polaron_str_free(ptr %newstr24)
  call void @__polaron_str_free(ptr %33)
  call void @__polaron_str_free(ptr %newstr35)
  br label %if.end15

if.end15:                                         ; preds = %if.then14, %div.ok6
  %s37 = load ptr, ptr %s, align 8
  %strcpy38 = call ptr @__polaron_str_copy(ptr %s37)
  %44 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %44)
  ret ptr %strcpy38
}

define internal ptr @NumberWords.toWords(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %exc.thrown53 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %m = alloca i32, align 4
  %g = alloca i32, align 4
  %grp = alloca ptr, align 8
  %scale = alloca ptr, align 8
  %sign = alloca ptr, align 8
  %n = alloca i32, align 4
  %num = alloca i32, align 4
  store i32 %0, ptr %num, align 4
  %num1 = load i32, ptr %num, align 4
  %1 = icmp eq i32 %num1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2812)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %num2 = load i32, ptr %num, align 4
  store i32 %num2, ptr %n, align 4
  %strcpy3 = call ptr @__polaron_str_copy(ptr @.strobj.2814)
  store ptr %strcpy3, ptr %sign, align 8
  %n4 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %n4, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  %strcpy7 = call ptr @__polaron_str_copy(ptr @.strobj.2816)
  %5 = load ptr, ptr %sign, align 8
  call void @__polaron_str_free(ptr %5)
  store ptr %strcpy7, ptr %sign, align 8
  %n8 = load i32, ptr %n, align 4
  %6 = sub i32 0, %n8
  store i32 %6, ptr %n, align 4
  br label %if.end6

if.end6:                                          ; preds = %if.then5, %if.end
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %7 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %scale, align 8
  %scale9 = load ptr, ptr %scale, align 8, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %scale9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %if.end6
  call void @__polaron_fail(ptr @.fail.2817, ptr @.faila.2818, i64 0, ptr @.failb.2819, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end6
  %arr.data10 = getelementptr i8, ptr %scale9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data10, i64 0
  %strcpy11 = call ptr @__polaron_str_copy(ptr @.strobj.2821)
  %8 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %8)
  store ptr %strcpy11, ptr %arr.elem, align 8
  %scale12 = load ptr, ptr %scale, align 8, !nonnull !8, !dereferenceable !9
  %arr.len13 = load i64, ptr %scale12, align 8
  %arr.oob14 = icmp uge i64 1, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !10

idx.bad15:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2822, ptr @.faila.2823, i64 1, ptr @.failb.2824, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok
  %arr.data17 = getelementptr i8, ptr %scale12, i64 8
  %arr.elem18 = getelementptr inbounds ptr, ptr %arr.data17, i64 1
  %strcpy19 = call ptr @__polaron_str_copy(ptr @.strobj.2826)
  %9 = load ptr, ptr %arr.elem18, align 8
  call void @__polaron_str_free(ptr %9)
  store ptr %strcpy19, ptr %arr.elem18, align 8
  %scale20 = load ptr, ptr %scale, align 8, !nonnull !8, !dereferenceable !9
  %arr.len21 = load i64, ptr %scale20, align 8
  %arr.oob22 = icmp uge i64 2, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !10

idx.bad23:                                        ; preds = %idx.ok16
  call void @__polaron_fail(ptr @.fail.2827, ptr @.faila.2828, i64 2, ptr @.failb.2829, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok16
  %arr.data25 = getelementptr i8, ptr %scale20, i64 8
  %arr.elem26 = getelementptr inbounds ptr, ptr %arr.data25, i64 2
  %strcpy27 = call ptr @__polaron_str_copy(ptr @.strobj.2831)
  %10 = load ptr, ptr %arr.elem26, align 8
  call void @__polaron_str_free(ptr %10)
  store ptr %strcpy27, ptr %arr.elem26, align 8
  %scale28 = load ptr, ptr %scale, align 8, !nonnull !8, !dereferenceable !9
  %arr.len29 = load i64, ptr %scale28, align 8
  %arr.oob30 = icmp uge i64 3, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !10

idx.bad31:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.2832, ptr @.faila.2833, i64 3, ptr @.failb.2834, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok24
  %arr.data33 = getelementptr i8, ptr %scale28, i64 8
  %arr.elem34 = getelementptr inbounds ptr, ptr %arr.data33, i64 3
  %strcpy35 = call ptr @__polaron_str_copy(ptr @.strobj.2836)
  %11 = load ptr, ptr %arr.elem34, align 8
  call void @__polaron_str_free(ptr %11)
  store ptr %strcpy35, ptr %arr.elem34, align 8
  %arr36 = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr36, align 8
  %arr.data37 = getelementptr i8, ptr %arr36, i64 8
  %12 = call ptr @memset(ptr %arr.data37, i32 0, i64 16)
  store ptr %arr36, ptr %grp, align 8
  store i32 0, ptr %g, align 4
  %n38 = load i32, ptr %n, align 4
  store i32 %n38, ptr %m, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok51, %idx.ok32
  %m39 = load i32, ptr %m, align 4
  %13 = icmp sgt i32 %m39, 0
  %14 = zext i1 %13 to i32
  br i1 %13, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %grp40 = load ptr, ptr %grp, align 8, !nonnull !8, !dereferenceable !9
  %g41 = load i32, ptr %g, align 4
  %15 = sext i32 %g41 to i64
  %arr.len42 = load i64, ptr %grp40, align 8
  %arr.oob43 = icmp uge i64 %15, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !10

while.end:                                        ; preds = %while.cond
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %g55 = load i32, ptr %g, align 4
  %16 = sub i32 %g55, 1
  store i32 %16, ptr %i, align 4
  br label %for.cond

idx.bad44:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.2837, ptr @.faila.2838, i64 %15, ptr @.failb.2839, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %while.body
  %arr.data46 = getelementptr i8, ptr %grp40, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 %15
  %m48 = load i32, ptr %m, align 4
  %17 = icmp eq i32 %m48, -2147483648
  %18 = and i1 %17, false
  %19 = or i1 false, %18
  br i1 %19, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok45
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok45
  %20 = srem i32 %m48, 1000
  store i32 %20, ptr %arr.elem47, align 4
  %m49 = load i32, ptr %m, align 4
  %21 = icmp eq i32 %m49, -2147483648
  %22 = and i1 %21, false
  %23 = or i1 false, %22
  br i1 %23, label %div.bad50, label %div.ok51

div.bad50:                                        ; preds = %div.ok
  %exc52 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc52)
  store ptr %exc52, ptr %exc.thrown53, align 8
  call void @_CxxThrowException(ptr %exc.thrown53, ptr @_TI1PEAX)
  unreachable

div.ok51:                                         ; preds = %div.ok
  %24 = sdiv i32 %m49, 1000
  store i32 %24, ptr %m, align 4
  %g54 = load i32, ptr %g, align 4
  %25 = add i32 %g54, 1
  store i32 %25, ptr %g, align 4
  br label %while.cond

for.cond:                                         ; preds = %for.update, %while.end
  %i56 = load i32, ptr %i, align 4
  %26 = icmp sge i32 %i56, 0
  %27 = zext i1 %26 to i32
  br i1 %26, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %grp57 = load ptr, ptr %grp, align 8, !nonnull !8, !dereferenceable !9
  %i58 = load i32, ptr %i, align 4
  %28 = sext i32 %i58 to i64
  %arr.len59 = load i64, ptr %grp57, align 8
  %arr.oob60 = icmp uge i64 %28, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !10

for.update:                                       ; preds = %if.end66
  %i91 = load i32, ptr %i, align 4
  %29 = sub i32 %i91, 1
  store i32 %29, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sign92 = load ptr, ptr %sign, align 8
  %sb93 = load ptr, ptr %sb, align 8
  %30 = call ptr @StringBuilder.toString(ptr %sb93)
  %str.len = getelementptr inbounds %String, ptr %sign92, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.len94 = getelementptr inbounds %String, ptr %30, i32 0, i32 0
  %len95 = load i64, ptr %str.len94, align 8
  %31 = add i64 %len, %len95
  %32 = add i64 %31, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %32)
  %str.data = getelementptr inbounds %String, ptr %sign92, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %33 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data96 = getelementptr inbounds %String, ptr %30, i32 0, i32 1
  %data97 = load ptr, ptr %str.data96, align 8
  %34 = getelementptr i8, ptr %cat.buf, i64 %len
  %35 = call ptr @memcpy(ptr %34, ptr %data97, i64 %len95)
  %36 = getelementptr i8, ptr %cat.buf, i64 %31
  store i8 0, ptr %36, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %37 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %31, ptr %37, align 8
  %38 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %38, align 8
  %39 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %39, align 8
  %strcpy98 = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %30)
  call void @__polaron_str_free(ptr %newstr)
  %40 = load ptr, ptr %sign, align 8
  call void @__polaron_str_free(ptr %40)
  ret ptr %strcpy98

idx.bad61:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2840, ptr @.faila.2841, i64 %28, ptr @.failb.2842, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %for.body
  %arr.data63 = getelementptr i8, ptr %grp57, i64 8
  %arr.elem64 = getelementptr inbounds i32, ptr %arr.data63, i64 %28
  %elem = load i32, ptr %arr.elem64, align 4
  %41 = icmp sgt i32 %elem, 0
  %42 = zext i1 %41 to i32
  br i1 %41, label %if.then65, label %if.end66

if.then65:                                        ; preds = %idx.ok62
  %sb67 = load ptr, ptr %sb, align 8
  %43 = call i32 @StringBuilder.length(ptr %sb67)
  %44 = icmp sgt i32 %43, 0
  %45 = zext i1 %44 to i32
  br i1 %44, label %if.then68, label %if.end69

if.end66:                                         ; preds = %idx.ok87, %idx.ok62
  br label %for.update

if.then68:                                        ; preds = %if.then65
  %sb70 = load ptr, ptr %sb, align 8
  %46 = call ptr @StringBuilder.appendChar(ptr %sb70, i32 32)
  br label %if.end69

if.end69:                                         ; preds = %if.then68, %if.then65
  %sb71 = load ptr, ptr %sb, align 8
  %grp72 = load ptr, ptr %grp, align 8, !nonnull !8, !dereferenceable !9
  %i73 = load i32, ptr %i, align 4
  %47 = sext i32 %i73 to i64
  %arr.len74 = load i64, ptr %grp72, align 8
  %arr.oob75 = icmp uge i64 %47, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !10

idx.bad76:                                        ; preds = %if.end69
  call void @__polaron_fail(ptr @.fail.2843, ptr @.faila.2844, i64 %47, ptr @.failb.2845, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %if.end69
  %arr.data78 = getelementptr i8, ptr %grp72, i64 8
  %arr.elem79 = getelementptr inbounds i32, ptr %arr.data78, i64 %47
  %elem80 = load i32, ptr %arr.elem79, align 4
  %48 = call ptr @NumberWords.under1000(i32 %elem80)
  %49 = call ptr @StringBuilder.append(ptr %sb71, ptr %48)
  call void @__polaron_str_free(ptr %48)
  %sb81 = load ptr, ptr %sb, align 8
  %scale82 = load ptr, ptr %scale, align 8, !nonnull !8, !dereferenceable !9
  %i83 = load i32, ptr %i, align 4
  %50 = sext i32 %i83 to i64
  %arr.len84 = load i64, ptr %scale82, align 8
  %arr.oob85 = icmp uge i64 %50, %arr.len84
  br i1 %arr.oob85, label %idx.bad86, label %idx.ok87, !prof !10

idx.bad86:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.2846, ptr @.faila.2847, i64 %50, ptr @.failb.2848, i64 %arr.len84, i32 70)
  unreachable

idx.ok87:                                         ; preds = %idx.ok77
  %arr.data88 = getelementptr i8, ptr %scale82, i64 8
  %arr.elem89 = getelementptr inbounds ptr, ptr %arr.data88, i64 %50
  %elem90 = load ptr, ptr %arr.elem89, align 8
  %51 = call ptr @StringBuilder.append(ptr %sb81, ptr %elem90)
  br label %if.end66
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5311)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
!8 = !{}
!9 = !{i64 8}
!10 = !{!"branch_weights", i32 1, i32 1048576}
