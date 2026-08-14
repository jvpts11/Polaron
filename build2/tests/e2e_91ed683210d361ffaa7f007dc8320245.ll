; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol"
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
@.fail = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol:16:21  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata = private constant [2 x i8] c"a\00"
@.strobj = private global %String { i64 1, ptr @.strdata, i64 0 }
@.fail.1 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol:16:31  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.4 = private constant [2 x i8] c"b\00"
@.strobj.5 = private global %String { i64 1, ptr @.strdata.4, i64 0 }
@.fail.6 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol:16:41  in main\0A\00", align 1
@.faila.7 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.8 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.9 = private constant [2 x i8] c"c\00"
@.strobj.10 = private global %String { i64 1, ptr @.strdata.9, i64 0 }
@.fail.11 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol:16:51  in main\0A\00", align 1
@.faila.12 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.13 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.14 = private constant [2 x i8] c"d\00"
@.strobj.15 = private global %String { i64 1, ptr @.strdata.14, i64 0 }
@.fail.16 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol:18:21  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.19 = private constant [2 x i8] c"a\00"
@.strobj.20 = private global %String { i64 1, ptr @.strdata.19, i64 0 }
@.fail.21 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol:18:31  in main\0A\00", align 1
@.faila.22 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.23 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.24 = private constant [2 x i8] c"x\00"
@.strobj.25 = private global %String { i64 1, ptr @.strdata.24, i64 0 }
@.fail.26 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol:18:41  in main\0A\00", align 1
@.faila.27 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.28 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.29 = private constant [2 x i8] c"c\00"
@.strobj.30 = private global %String { i64 1, ptr @.strdata.29, i64 0 }
@.fail.31 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/text_diff_validators.pol:18:51  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.34 = private constant [2 x i8] c"d\00"
@.strobj.35 = private global %String { i64 1, ptr @.strdata.34, i64 0 }
@.str = private unnamed_addr constant [31 x i8] c"common=%d added=%d removed=%d\0A\00", align 1
@.str.36 = private unnamed_addr constant [22 x i8] c"em1=%d em2=%d em3=%d\0A\00", align 1
@.strdata.37 = private constant [8 x i8] c"a@b.com\00"
@.strobj.38 = private global %String { i64 7, ptr @.strdata.37, i64 0 }
@.strdata.39 = private constant [7 x i8] c"ab.com\00"
@.strobj.40 = private global %String { i64 6, ptr @.strdata.39, i64 0 }
@.strdata.41 = private constant [7 x i8] c"a@bcom\00"
@.strobj.42 = private global %String { i64 6, ptr @.strdata.41, i64 0 }
@.str.43 = private unnamed_addr constant [25 x i8] c"url1=%d url2=%d url3=%d\0A\00", align 1
@.strdata.44 = private constant [14 x i8] c"https://x.com\00"
@.strobj.45 = private global %String { i64 13, ptr @.strdata.44, i64 0 }
@.strdata.46 = private constant [8 x i8] c"ftp://x\00"
@.strobj.47 = private global %String { i64 7, ptr @.strdata.46, i64 0 }
@.strdata.48 = private constant [8 x i8] c"http://\00"
@.strobj.49 = private global %String { i64 7, ptr @.strdata.48, i64 0 }
@.str.50 = private unnamed_addr constant [19 x i8] c"iban1=%d iban2=%d\0A\00", align 1
@.strdata.51 = private constant [23 x i8] c"GB82WEST12345698765432\00"
@.strobj.52 = private global %String { i64 22, ptr @.strdata.51, i64 0 }
@.strdata.53 = private constant [23 x i8] c"GB82WEST12345698765433\00"
@.strobj.54 = private global %String { i64 22, ptr @.strdata.53, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1363 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1364 = private global %String { i64 16, ptr @.strdata.1363, i64 0 }
@.strdata.1365 = private constant [17 x i8] c"division by zero\00"
@.strobj.1366 = private global %String { i64 16, ptr @.strdata.1365, i64 0 }
@.fail.2669 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4280:25  in TextDiff.lcsLen\0A\00", align 1
@.faila.2670 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2671 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2672 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4280:25  in TextDiff.lcsLen\0A\00", align 1
@.faila.2673 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2674 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2675 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4280:65  in TextDiff.lcsLen\0A\00", align 1
@.faila.2676 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2677 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2678 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4280:65  in TextDiff.lcsLen\0A\00", align 1
@.faila.2679 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2680 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2681 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4282:29  in TextDiff.lcsLen\0A\00", align 1
@.faila.2682 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2683 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2684 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4283:29  in TextDiff.lcsLen\0A\00", align 1
@.faila.2685 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2686 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2687 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4283:53  in TextDiff.lcsLen\0A\00", align 1
@.faila.2688 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2689 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2690 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4284:36  in TextDiff.lcsLen\0A\00", align 1
@.faila.2691 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2692 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2693 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4287:69  in TextDiff.lcsLen\0A\00", align 1
@.faila.2694 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2695 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2696 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4287:69  in TextDiff.lcsLen\0A\00", align 1
@.faila.2697 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2698 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2699 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4289:17  in TextDiff.lcsLen\0A\00", align 1
@.faila.2700 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2701 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2702 = private constant [9 x i8] c"https://\00"
@.strobj.2703 = private global %String { i64 8, ptr @.strdata.2702, i64 0 }
@.strdata.2704 = private constant [8 x i8] c"http://\00"
@.strobj.2705 = private global %String { i64 7, ptr @.strdata.2704, i64 0 }
@.fail.2706 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4324:46  in Validators.isIban\0A\00", align 1
@.faila.2707 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2708 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2709 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4331:21  in Validators.isIban\0A\00", align 1
@.faila.2710 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2711 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5364 = private constant [1 x i8] zeroinitializer
@.strobj.5365 = private global %String { i64 0, ptr @.strdata.5364, i64 0 }
@.strdata.5366 = private constant [1 x i8] zeroinitializer
@.strobj.5367 = private global %String { i64 0, ptr @.strdata.5366, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 32)
  store ptr %arr, ptr %a, align 8
  %a2 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %a2, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data3, i64 0
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  %17 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %17)
  store ptr %strcpy, ptr %arr.elem, align 8
  %a4 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %a4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %a4, i64 8
  %arr.elem10 = getelementptr inbounds ptr, ptr %arr.data9, i64 1
  %strcpy11 = call ptr @__polaron_str_copy(ptr @.strobj.5)
  %18 = load ptr, ptr %arr.elem10, align 8
  call void @__polaron_str_free(ptr %18)
  store ptr %strcpy11, ptr %arr.elem10, align 8
  %a12 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len13 = load i64, ptr %a12, align 8
  %arr.oob14 = icmp uge i64 2, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !2

idx.bad15:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.6, ptr @.faila.7, i64 2, ptr @.failb.8, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok8
  %arr.data17 = getelementptr i8, ptr %a12, i64 8
  %arr.elem18 = getelementptr inbounds ptr, ptr %arr.data17, i64 2
  %strcpy19 = call ptr @__polaron_str_copy(ptr @.strobj.10)
  %19 = load ptr, ptr %arr.elem18, align 8
  call void @__polaron_str_free(ptr %19)
  store ptr %strcpy19, ptr %arr.elem18, align 8
  %a20 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len21 = load i64, ptr %a20, align 8
  %arr.oob22 = icmp uge i64 3, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

idx.bad23:                                        ; preds = %idx.ok16
  call void @__polaron_fail(ptr @.fail.11, ptr @.faila.12, i64 3, ptr @.failb.13, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok16
  %arr.data25 = getelementptr i8, ptr %a20, i64 8
  %arr.elem26 = getelementptr inbounds ptr, ptr %arr.data25, i64 3
  %strcpy27 = call ptr @__polaron_str_copy(ptr @.strobj.15)
  %20 = load ptr, ptr %arr.elem26, align 8
  call void @__polaron_str_free(ptr %20)
  store ptr %strcpy27, ptr %arr.elem26, align 8
  %arr28 = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr28, align 8
  %arr.data29 = getelementptr i8, ptr %arr28, i64 8
  %21 = call ptr @memset(ptr %arr.data29, i32 0, i64 32)
  store ptr %arr28, ptr %b, align 8
  %b30 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len31 = load i64, ptr %b30, align 8
  %arr.oob32 = icmp uge i64 0, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !2

idx.bad33:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 0, ptr @.failb.18, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %idx.ok24
  %arr.data35 = getelementptr i8, ptr %b30, i64 8
  %arr.elem36 = getelementptr inbounds ptr, ptr %arr.data35, i64 0
  %strcpy37 = call ptr @__polaron_str_copy(ptr @.strobj.20)
  %22 = load ptr, ptr %arr.elem36, align 8
  call void @__polaron_str_free(ptr %22)
  store ptr %strcpy37, ptr %arr.elem36, align 8
  %b38 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len39 = load i64, ptr %b38, align 8
  %arr.oob40 = icmp uge i64 1, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !2

idx.bad41:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.21, ptr @.faila.22, i64 1, ptr @.failb.23, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %idx.ok34
  %arr.data43 = getelementptr i8, ptr %b38, i64 8
  %arr.elem44 = getelementptr inbounds ptr, ptr %arr.data43, i64 1
  %strcpy45 = call ptr @__polaron_str_copy(ptr @.strobj.25)
  %23 = load ptr, ptr %arr.elem44, align 8
  call void @__polaron_str_free(ptr %23)
  store ptr %strcpy45, ptr %arr.elem44, align 8
  %b46 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len47 = load i64, ptr %b46, align 8
  %arr.oob48 = icmp uge i64 2, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

idx.bad49:                                        ; preds = %idx.ok42
  call void @__polaron_fail(ptr @.fail.26, ptr @.faila.27, i64 2, ptr @.failb.28, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %idx.ok42
  %arr.data51 = getelementptr i8, ptr %b46, i64 8
  %arr.elem52 = getelementptr inbounds ptr, ptr %arr.data51, i64 2
  %strcpy53 = call ptr @__polaron_str_copy(ptr @.strobj.30)
  %24 = load ptr, ptr %arr.elem52, align 8
  call void @__polaron_str_free(ptr %24)
  store ptr %strcpy53, ptr %arr.elem52, align 8
  %b54 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len55 = load i64, ptr %b54, align 8
  %arr.oob56 = icmp uge i64 3, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

idx.bad57:                                        ; preds = %idx.ok50
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 3, ptr @.failb.33, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok50
  %arr.data59 = getelementptr i8, ptr %b54, i64 8
  %arr.elem60 = getelementptr inbounds ptr, ptr %arr.data59, i64 3
  %strcpy61 = call ptr @__polaron_str_copy(ptr @.strobj.35)
  %25 = load ptr, ptr %arr.elem60, align 8
  call void @__polaron_str_free(ptr %25)
  store ptr %strcpy61, ptr %arr.elem60, align 8
  %a62 = load ptr, ptr %a, align 8
  %b63 = load ptr, ptr %b, align 8
  %26 = call i32 @TextDiff.common(ptr %a62, i32 4, ptr %b63, i32 4)
  %a64 = load ptr, ptr %a, align 8
  %b65 = load ptr, ptr %b, align 8
  %27 = call i32 @TextDiff.added(ptr %a64, i32 4, ptr %b65, i32 4)
  %a66 = load ptr, ptr %a, align 8
  %b67 = load ptr, ptr %b, align 8
  %28 = call i32 @TextDiff.removed(ptr %a66, i32 4, ptr %b67, i32 4)
  %29 = call i32 (ptr, ...) @printf(ptr @.str, i32 %26, i32 %27, i32 %28)
  %30 = call i32 @Validators.isEmail(ptr @.strobj.38)
  %31 = call i32 @Validators.isEmail(ptr @.strobj.40)
  %32 = call i32 @Validators.isEmail(ptr @.strobj.42)
  %33 = call i32 (ptr, ...) @printf(ptr @.str.36, i32 %30, i32 %31, i32 %32)
  %34 = call i32 @Validators.isUrl(ptr @.strobj.45)
  %35 = call i32 @Validators.isUrl(ptr @.strobj.47)
  %36 = call i32 @Validators.isUrl(ptr @.strobj.49)
  %37 = call i32 (ptr, ...) @printf(ptr @.str.43, i32 %34, i32 %35, i32 %36)
  %38 = call i32 @Validators.isIban(ptr @.strobj.52)
  %39 = call i32 @Validators.isIban(ptr @.strobj.54)
  %40 = call i32 (ptr, ...) @printf(ptr @.str.50, i32 %38, i32 %39)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1364)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1366)
  ret ptr %strcpy
}

define internal i32 @TextDiff.lcsLen(ptr %0, i32 %1, ptr %2, i32 %3) {
entry:
  %j83 = alloca i32, align 4
  %m = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %cur = alloca ptr, align 8
  %prev = alloca ptr, align 8
  %nb = alloca i32, align 4
  %b = alloca ptr, align 8
  %na = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %na, align 4
  store ptr %2, ptr %b, align 8
  store i32 %3, ptr %nb, align 4
  %nb1 = load i32, ptr %nb, align 4
  %4 = add i32 %nb1, 1
  %5 = sext i32 %4 to i64
  %6 = mul i64 %5, 4
  %7 = add i64 8, %6
  %arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %8 = call ptr @memset(ptr %arr.data, i32 0, i64 %6)
  store ptr %arr, ptr %prev, align 8
  %nb2 = load i32, ptr %nb, align 4
  %9 = add i32 %nb2, 1
  %10 = sext i32 %9 to i64
  %11 = mul i64 %10, 4
  %12 = add i64 8, %11
  %arr3 = call ptr @__polaron_malloc(i64 %12)
  store i64 %10, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %13 = call ptr @memset(ptr %arr.data4, i32 0, i64 %11)
  store ptr %arr3, ptr %cur, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i5 = load i32, ptr %i, align 4
  %na6 = load i32, ptr %na, align 4
  %14 = icmp sle i32 %i5, %na6
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 1, ptr %j, align 4
  br label %for.cond7

for.update:                                       ; preds = %for.end87
  %16 = load i32, ptr %i, align 4
  %17 = add i32 %16, 1
  store i32 %17, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %prev107 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %nb108 = load i32, ptr %nb, align 4
  %18 = sext i32 %nb108 to i64
  %arr.len109 = load i64, ptr %prev107, align 8
  %arr.oob110 = icmp uge i64 %18, %arr.len109
  br i1 %arr.oob110, label %idx.bad111, label %idx.ok112, !prof !2

for.cond7:                                        ; preds = %for.update9, %for.body
  %j11 = load i32, ptr %j, align 4
  %nb12 = load i32, ptr %nb, align 4
  %19 = icmp sle i32 %j11, %nb12
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body8, label %for.end10

for.body8:                                        ; preds = %for.cond7
  %a13 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i14 = load i32, ptr %i, align 4
  %21 = sub i32 %i14, 1
  %22 = sext i32 %21 to i64
  %arr.len = load i64, ptr %a13, align 8
  %arr.oob = icmp uge i64 %22, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update9:                                      ; preds = %if.end
  %23 = load i32, ptr %j, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %j, align 4
  br label %for.cond7

for.end10:                                        ; preds = %for.cond7
  store i32 0, ptr %j83, align 4
  br label %for.cond84

idx.bad:                                          ; preds = %for.body8
  call void @__polaron_fail(ptr @.fail.2669, ptr @.faila.2670, i64 %22, ptr @.failb.2671, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body8
  %arr.data15 = getelementptr i8, ptr %a13, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data15, i64 %22
  %elem = load ptr, ptr %arr.elem, align 8
  %b16 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %j17 = load i32, ptr %j, align 4
  %25 = sub i32 %j17, 1
  %26 = sext i32 %25 to i64
  %arr.len18 = load i64, ptr %b16, align 8
  %arr.oob19 = icmp uge i64 %26, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !2

idx.bad20:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2672, ptr @.faila.2673, i64 %26, ptr @.failb.2674, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %idx.ok
  %arr.data22 = getelementptr i8, ptr %b16, i64 8
  %arr.elem23 = getelementptr inbounds ptr, ptr %arr.data22, i64 %26
  %elem24 = load ptr, ptr %arr.elem23, align 8
  %str.data = getelementptr inbounds %String, ptr %elem, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data25 = getelementptr inbounds %String, ptr %elem24, i32 0, i32 1
  %data26 = load ptr, ptr %str.data25, align 8
  %27 = call i32 @strcmp(ptr %data, ptr %data26)
  %28 = icmp eq i32 %27, 0
  %29 = zext i1 %28 to i32
  br i1 %28, label %if.then, label %if.else

if.then:                                          ; preds = %idx.ok21
  %cur27 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j28 = load i32, ptr %j, align 4
  %30 = sext i32 %j28 to i64
  %arr.len29 = load i64, ptr %cur27, align 8
  %arr.oob30 = icmp uge i64 %30, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !2

if.else:                                          ; preds = %idx.ok21
  %prev44 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j45 = load i32, ptr %j, align 4
  %31 = sext i32 %j45 to i64
  %arr.len46 = load i64, ptr %prev44, align 8
  %arr.oob47 = icmp uge i64 %31, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

if.end:                                           ; preds = %idx.ok79, %idx.ok40
  br label %for.update9

idx.bad31:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2675, ptr @.faila.2676, i64 %30, ptr @.failb.2677, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %if.then
  %arr.data33 = getelementptr i8, ptr %cur27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %30
  %prev35 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j36 = load i32, ptr %j, align 4
  %32 = sub i32 %j36, 1
  %33 = sext i32 %32 to i64
  %arr.len37 = load i64, ptr %prev35, align 8
  %arr.oob38 = icmp uge i64 %33, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad39:                                        ; preds = %idx.ok32
  call void @__polaron_fail(ptr @.fail.2678, ptr @.faila.2679, i64 %33, ptr @.failb.2680, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok32
  %arr.data41 = getelementptr i8, ptr %prev35, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %33
  %elem43 = load i32, ptr %arr.elem42, align 4
  %34 = add i32 %elem43, 1
  store i32 %34, ptr %arr.elem34, align 4
  br label %if.end

idx.bad48:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.2681, ptr @.faila.2682, i64 %31, ptr @.failb.2683, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %if.else
  %arr.data50 = getelementptr i8, ptr %prev44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %31
  %elem52 = load i32, ptr %arr.elem51, align 4
  store i32 %elem52, ptr %m, align 4
  %cur53 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j54 = load i32, ptr %j, align 4
  %35 = sub i32 %j54, 1
  %36 = sext i32 %35 to i64
  %arr.len55 = load i64, ptr %cur53, align 8
  %arr.oob56 = icmp uge i64 %36, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

idx.bad57:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.2684, ptr @.faila.2685, i64 %36, ptr @.failb.2686, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok49
  %arr.data59 = getelementptr i8, ptr %cur53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %36
  %elem61 = load i32, ptr %arr.elem60, align 4
  %m62 = load i32, ptr %m, align 4
  %37 = icmp sgt i32 %elem61, %m62
  %38 = zext i1 %37 to i32
  br i1 %37, label %if.then63, label %if.end64

if.then63:                                        ; preds = %idx.ok58
  %cur65 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j66 = load i32, ptr %j, align 4
  %39 = sub i32 %j66, 1
  %40 = sext i32 %39 to i64
  %arr.len67 = load i64, ptr %cur65, align 8
  %arr.oob68 = icmp uge i64 %40, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !2

if.end64:                                         ; preds = %idx.ok70, %idx.ok58
  %cur74 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j75 = load i32, ptr %j, align 4
  %41 = sext i32 %j75 to i64
  %arr.len76 = load i64, ptr %cur74, align 8
  %arr.oob77 = icmp uge i64 %41, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !2

idx.bad69:                                        ; preds = %if.then63
  call void @__polaron_fail(ptr @.fail.2687, ptr @.faila.2688, i64 %40, ptr @.failb.2689, i64 %arr.len67, i32 70)
  unreachable

idx.ok70:                                         ; preds = %if.then63
  %arr.data71 = getelementptr i8, ptr %cur65, i64 8
  %arr.elem72 = getelementptr inbounds i32, ptr %arr.data71, i64 %40
  %elem73 = load i32, ptr %arr.elem72, align 4
  store i32 %elem73, ptr %m, align 4
  br label %if.end64

idx.bad78:                                        ; preds = %if.end64
  call void @__polaron_fail(ptr @.fail.2690, ptr @.faila.2691, i64 %41, ptr @.failb.2692, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %if.end64
  %arr.data80 = getelementptr i8, ptr %cur74, i64 8
  %arr.elem81 = getelementptr inbounds i32, ptr %arr.data80, i64 %41
  %m82 = load i32, ptr %m, align 4
  store i32 %m82, ptr %arr.elem81, align 4
  br label %if.end

for.cond84:                                       ; preds = %for.update86, %for.end10
  %j88 = load i32, ptr %j83, align 4
  %nb89 = load i32, ptr %nb, align 4
  %42 = icmp sle i32 %j88, %nb89
  %43 = zext i1 %42 to i32
  br i1 %42, label %for.body85, label %for.end87

for.body85:                                       ; preds = %for.cond84
  %prev90 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j91 = load i32, ptr %j83, align 4
  %44 = sext i32 %j91 to i64
  %arr.len92 = load i64, ptr %prev90, align 8
  %arr.oob93 = icmp uge i64 %44, %arr.len92
  br i1 %arr.oob93, label %idx.bad94, label %idx.ok95, !prof !2

for.update86:                                     ; preds = %idx.ok103
  %45 = load i32, ptr %j83, align 4
  %46 = add i32 %45, 1
  store i32 %46, ptr %j83, align 4
  br label %for.cond84

for.end87:                                        ; preds = %for.cond84
  br label %for.update

idx.bad94:                                        ; preds = %for.body85
  call void @__polaron_fail(ptr @.fail.2693, ptr @.faila.2694, i64 %44, ptr @.failb.2695, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %for.body85
  %arr.data96 = getelementptr i8, ptr %prev90, i64 8
  %arr.elem97 = getelementptr inbounds i32, ptr %arr.data96, i64 %44
  %cur98 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j99 = load i32, ptr %j83, align 4
  %47 = sext i32 %j99 to i64
  %arr.len100 = load i64, ptr %cur98, align 8
  %arr.oob101 = icmp uge i64 %47, %arr.len100
  br i1 %arr.oob101, label %idx.bad102, label %idx.ok103, !prof !2

idx.bad102:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.2696, ptr @.faila.2697, i64 %47, ptr @.failb.2698, i64 %arr.len100, i32 70)
  unreachable

idx.ok103:                                        ; preds = %idx.ok95
  %arr.data104 = getelementptr i8, ptr %cur98, i64 8
  %arr.elem105 = getelementptr inbounds i32, ptr %arr.data104, i64 %47
  %elem106 = load i32, ptr %arr.elem105, align 4
  store i32 %elem106, ptr %arr.elem97, align 4
  br label %for.update86

idx.bad111:                                       ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.2699, ptr @.faila.2700, i64 %18, ptr @.failb.2701, i64 %arr.len109, i32 70)
  unreachable

idx.ok112:                                        ; preds = %for.end
  %arr.data113 = getelementptr i8, ptr %prev107, i64 8
  %arr.elem114 = getelementptr inbounds i32, ptr %arr.data113, i64 %18
  %elem115 = load i32, ptr %arr.elem114, align 4
  ret i32 %elem115
}

define internal i32 @TextDiff.common(ptr %0, i32 %1, ptr %2, i32 %3) {
entry:
  %nb = alloca i32, align 4
  %b = alloca ptr, align 8
  %na = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %na, align 4
  store ptr %2, ptr %b, align 8
  store i32 %3, ptr %nb, align 4
  %a1 = load ptr, ptr %a, align 8
  %na2 = load i32, ptr %na, align 4
  %b3 = load ptr, ptr %b, align 8
  %nb4 = load i32, ptr %nb, align 4
  %4 = call i32 @TextDiff.lcsLen(ptr %a1, i32 %na2, ptr %b3, i32 %nb4)
  ret i32 %4
}

define internal i32 @TextDiff.removed(ptr %0, i32 %1, ptr %2, i32 %3) {
entry:
  %nb = alloca i32, align 4
  %b = alloca ptr, align 8
  %na = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %na, align 4
  store ptr %2, ptr %b, align 8
  store i32 %3, ptr %nb, align 4
  %na1 = load i32, ptr %na, align 4
  %a2 = load ptr, ptr %a, align 8
  %na3 = load i32, ptr %na, align 4
  %b4 = load ptr, ptr %b, align 8
  %nb5 = load i32, ptr %nb, align 4
  %4 = call i32 @TextDiff.lcsLen(ptr %a2, i32 %na3, ptr %b4, i32 %nb5)
  %5 = sub i32 %na1, %4
  ret i32 %5
}

define internal i32 @TextDiff.added(ptr %0, i32 %1, ptr %2, i32 %3) {
entry:
  %nb = alloca i32, align 4
  %b = alloca ptr, align 8
  %na = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %na, align 4
  store ptr %2, ptr %b, align 8
  store i32 %3, ptr %nb, align 4
  %nb1 = load i32, ptr %nb, align 4
  %a2 = load ptr, ptr %a, align 8
  %na3 = load i32, ptr %na, align 4
  %b4 = load ptr, ptr %b, align 8
  %nb5 = load i32, ptr %nb, align 4
  %4 = call i32 @TextDiff.lcsLen(ptr %a2, i32 %na3, ptr %b4, i32 %nb5)
  %5 = sub i32 %nb1, %4
  ret i32 %5
}

define internal i32 @Validators.isEmail(ptr %0) {
entry:
  %i25 = alloca i32, align 4
  %dot = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %atCount = alloca i32, align 4
  %at = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store i32 -1, ptr %at, align 4
  store i32 0, ptr %atCount, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %s2 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s3 = load ptr, ptr %s, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %c, align 4
  %c5 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %c5, 32
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.end

for.update:                                       ; preds = %if.end8
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %atCount11 = load i32, ptr %atCount, align 4
  %10 = icmp ne i32 %atCount11, 1
  %11 = zext i1 %10 to i32
  %sc.a = icmp ne i32 %11, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

if.then:                                          ; preds = %for.body
  ret i32 0

if.end:                                           ; preds = %for.body
  %c6 = load i32, ptr %c, align 4
  %12 = icmp eq i32 %c6, 64
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end
  %i9 = load i32, ptr %i, align 4
  store i32 %i9, ptr %at, align 4
  %atCount10 = load i32, ptr %atCount, align 4
  %14 = add i32 %atCount10, 1
  store i32 %14, ptr %atCount, align 4
  br label %if.end8

if.end8:                                          ; preds = %if.then7, %if.end
  br label %for.update

sc.rhs:                                           ; preds = %for.end
  %at12 = load i32, ptr %at, align 4
  %15 = icmp eq i32 %at12, 0
  %16 = zext i1 %15 to i32
  %sc.b = icmp ne i32 %16, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %for.end
  %sc = phi i1 [ true, %for.end ], [ %sc.b, %sc.rhs ]
  %17 = zext i1 %sc to i32
  %sc.a13 = icmp ne i32 %17, 0
  br i1 %sc.a13, label %sc.end15, label %sc.rhs14

sc.rhs14:                                         ; preds = %sc.end
  %at16 = load i32, ptr %at, align 4
  %s17 = load ptr, ptr %s, align 8
  %str.len18 = getelementptr inbounds %String, ptr %s17, i32 0, i32 0
  %len19 = load i64, ptr %str.len18, align 8
  %18 = trunc i64 %len19 to i32
  %19 = sub i32 %18, 1
  %20 = icmp eq i32 %at16, %19
  %21 = zext i1 %20 to i32
  %sc.b20 = icmp ne i32 %21, 0
  br label %sc.end15

sc.end15:                                         ; preds = %sc.rhs14, %sc.end
  %sc21 = phi i1 [ true, %sc.end ], [ %sc.b20, %sc.rhs14 ]
  %22 = zext i1 %sc21 to i32
  br i1 %sc21, label %if.then22, label %if.end23

if.then22:                                        ; preds = %sc.end15
  ret i32 0

if.end23:                                         ; preds = %sc.end15
  store i32 0, ptr %dot, align 4
  %at24 = load i32, ptr %at, align 4
  %23 = add i32 %at24, 1
  store i32 %23, ptr %i25, align 4
  br label %for.cond26

for.cond26:                                       ; preds = %for.update28, %if.end23
  %i30 = load i32, ptr %i25, align 4
  %s31 = load ptr, ptr %s, align 8
  %str.len32 = getelementptr inbounds %String, ptr %s31, i32 0, i32 0
  %len33 = load i64, ptr %str.len32, align 8
  %24 = trunc i64 %len33 to i32
  %25 = icmp slt i32 %i30, %24
  %26 = zext i1 %25 to i32
  br i1 %25, label %for.body27, label %for.end29

for.body27:                                       ; preds = %for.cond26
  %s34 = load ptr, ptr %s, align 8
  %i35 = load i32, ptr %i25, align 4
  %27 = sext i32 %i35 to i64
  %str.data36 = getelementptr inbounds %String, ptr %s34, i32 0, i32 1
  %data37 = load ptr, ptr %str.data36, align 8
  %ch.addr38 = getelementptr i8, ptr %data37, i64 %27
  %ch39 = load i8, ptr %ch.addr38, align 1
  %28 = zext i8 %ch39 to i32
  %29 = icmp eq i32 %28, 46
  %30 = zext i1 %29 to i32
  br i1 %29, label %if.then40, label %if.end41

for.update28:                                     ; preds = %if.end41
  %31 = load i32, ptr %i25, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %i25, align 4
  br label %for.cond26

for.end29:                                        ; preds = %for.cond26
  %dot42 = load i32, ptr %dot, align 4
  ret i32 %dot42

if.then40:                                        ; preds = %for.body27
  store i32 1, ptr %dot, align 4
  br label %if.end41

if.end41:                                         ; preds = %if.then40, %for.body27
  br label %for.update28
}

define internal i32 @Validators.isUrl(ptr %0) {
entry:
  %start = alloca i32, align 4
  %http = alloca i32, align 4
  %https = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.data = getelementptr inbounds %String, ptr %s1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2703, i32 0, i32 1), align 8
  %len3 = load i64, ptr @.strobj.2703, align 8
  %1 = call i64 @__polaron_str_index(ptr %data, i64 %len, ptr %data2, i64 %len3)
  %2 = icmp eq i64 %1, 0
  %3 = zext i1 %2 to i32
  store i32 %3, ptr %https, align 4
  %s4 = load ptr, ptr %s, align 8
  %str.data5 = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %str.len7 = getelementptr inbounds %String, ptr %s4, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %data9 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2705, i32 0, i32 1), align 8
  %len10 = load i64, ptr @.strobj.2705, align 8
  %4 = call i64 @__polaron_str_index(ptr %data6, i64 %len8, ptr %data9, i64 %len10)
  %5 = icmp eq i64 %4, 0
  %6 = zext i1 %5 to i32
  store i32 %6, ptr %http, align 4
  %http11 = load i32, ptr %http, align 4
  %7 = icmp eq i32 %http11, 0
  %8 = zext i1 %7 to i32
  %sc.a = icmp ne i32 %8, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %https12 = load i32, ptr %https, align 4
  %9 = icmp eq i32 %https12, 0
  %10 = zext i1 %9 to i32
  %sc.b = icmp ne i32 %10, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %11 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i32 0

if.end:                                           ; preds = %sc.end
  store i32 7, ptr %start, align 4
  %https13 = load i32, ptr %https, align 4
  %12 = icmp ne i32 %https13, 0
  br i1 %12, label %if.then14, label %if.end15

if.then14:                                        ; preds = %if.end
  store i32 8, ptr %start, align 4
  br label %if.end15

if.end15:                                         ; preds = %if.then14, %if.end
  %s16 = load ptr, ptr %s, align 8
  %str.len17 = getelementptr inbounds %String, ptr %s16, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  %13 = trunc i64 %len18 to i32
  %start19 = load i32, ptr %start, align 4
  %14 = icmp sgt i32 %13, %start19
  %15 = zext i1 %14 to i32
  ret i32 %15
}

define internal i32 @Validators.isIban(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown58 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %c36 = alloca i32, align 4
  %idx = alloca i32, align 4
  %k = alloca i32, align 4
  %running = alloca i64, align 8
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %buf = alloca ptr, align 8
  %len = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store i32 0, ptr %len, align 4
  %arr = call ptr @__polaron_malloc(i64 264)
  store i64 64, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 256)
  store ptr %arr, ptr %buf, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %s2 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len3 = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len3 to i32
  %3 = icmp slt i32 %i1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s4 = load ptr, ptr %s, align 8
  %i5 = load i32, ptr %i, align 4
  %5 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  store i32 %6, ptr %c, align 4
  %c6 = load i32, ptr %c, align 4
  %7 = icmp ne i32 %c6, 32
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

for.update:                                       ; preds = %if.end
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %len12 = load i32, ptr %len, align 4
  %11 = icmp slt i32 %len12, 5
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then13, label %if.end14

if.then:                                          ; preds = %for.body
  %buf7 = load ptr, ptr %buf, align 8, !nonnull !0, !dereferenceable !1
  %len8 = load i32, ptr %len, align 4
  %13 = sext i32 %len8 to i64
  %arr.len = load i64, ptr %buf7, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %idx.ok, %for.body
  br label %for.update

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2706, ptr @.faila.2707, i64 %13, ptr @.failb.2708, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data9 = getelementptr i8, ptr %buf7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 %13
  %c10 = load i32, ptr %c, align 4
  store i32 %c10, ptr %arr.elem, align 4
  %len11 = load i32, ptr %len, align 4
  %14 = add i32 %len11, 1
  store i32 %14, ptr %len, align 4
  br label %if.end

if.then13:                                        ; preds = %for.end
  ret i32 0

if.end14:                                         ; preds = %for.end
  store i64 0, ptr %running, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond15

for.cond15:                                       ; preds = %for.update17, %if.end14
  %k19 = load i32, ptr %k, align 4
  %len20 = load i32, ptr %len, align 4
  %15 = icmp slt i32 %k19, %len20
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body16, label %for.end18

for.body16:                                       ; preds = %for.cond15
  %k21 = load i32, ptr %k, align 4
  %17 = add i32 %k21, 4
  store i32 %17, ptr %idx, align 4
  %idx22 = load i32, ptr %idx, align 4
  %len23 = load i32, ptr %len, align 4
  %18 = icmp sge i32 %idx22, %len23
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then24, label %if.end25

for.update17:                                     ; preds = %if.end40
  %20 = load i32, ptr %k, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %k, align 4
  br label %for.cond15

for.end18:                                        ; preds = %for.cond15
  %running59 = load i64, ptr %running, align 8
  %22 = icmp eq i64 %running59, 1
  %23 = zext i1 %22 to i32
  ret i32 %23

if.then24:                                        ; preds = %for.body16
  %idx26 = load i32, ptr %idx, align 4
  %len27 = load i32, ptr %len, align 4
  %24 = sub i32 %idx26, %len27
  store i32 %24, ptr %idx, align 4
  br label %if.end25

if.end25:                                         ; preds = %if.then24, %for.body16
  %buf28 = load ptr, ptr %buf, align 8, !nonnull !0, !dereferenceable !1
  %idx29 = load i32, ptr %idx, align 4
  %25 = sext i32 %idx29 to i64
  %arr.len30 = load i64, ptr %buf28, align 8
  %arr.oob31 = icmp uge i64 %25, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

idx.bad32:                                        ; preds = %if.end25
  call void @__polaron_fail(ptr @.fail.2709, ptr @.faila.2710, i64 %25, ptr @.failb.2711, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.end25
  %arr.data34 = getelementptr i8, ptr %buf28, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %25
  %elem = load i32, ptr %arr.elem35, align 4
  store i32 %elem, ptr %c36, align 4
  %c37 = load i32, ptr %c36, align 4
  %26 = icmp sge i32 %c37, 48
  %27 = zext i1 %26 to i32
  %sc.a = icmp ne i32 %27, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %idx.ok33
  %c38 = load i32, ptr %c36, align 4
  %28 = icmp sle i32 %c38, 57
  %29 = zext i1 %28 to i32
  %sc.b = icmp ne i32 %29, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %idx.ok33
  %sc = phi i1 [ false, %idx.ok33 ], [ %sc.b, %sc.rhs ]
  %30 = zext i1 %sc to i32
  br i1 %sc, label %if.then39, label %if.else

if.then39:                                        ; preds = %sc.end
  %running41 = load i64, ptr %running, align 8
  %31 = mul i64 %running41, 10
  %c42 = load i32, ptr %c36, align 4
  %32 = sub i32 %c42, 48
  %33 = sext i32 %32 to i64
  %34 = add i64 %31, %33
  %35 = icmp eq i64 %34, -9223372036854775808
  %36 = and i1 %35, false
  %37 = or i1 false, %36
  br i1 %37, label %div.bad, label %div.ok

if.else:                                          ; preds = %sc.end
  %c43 = load i32, ptr %c36, align 4
  %38 = icmp sge i32 %c43, 65
  %39 = zext i1 %38 to i32
  %sc.a44 = icmp ne i32 %39, 0
  br i1 %sc.a44, label %sc.rhs45, label %sc.end46

if.end40:                                         ; preds = %if.end52, %div.ok
  br label %for.update17

div.bad:                                          ; preds = %if.then39
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.then39
  %40 = srem i64 %34, 97
  store i64 %40, ptr %running, align 8
  br label %if.end40

sc.rhs45:                                         ; preds = %if.else
  %c47 = load i32, ptr %c36, align 4
  %41 = icmp sle i32 %c47, 90
  %42 = zext i1 %41 to i32
  %sc.b48 = icmp ne i32 %42, 0
  br label %sc.end46

sc.end46:                                         ; preds = %sc.rhs45, %if.else
  %sc49 = phi i1 [ false, %if.else ], [ %sc.b48, %sc.rhs45 ]
  %43 = zext i1 %sc49 to i32
  br i1 %sc49, label %if.then50, label %if.else51

if.then50:                                        ; preds = %sc.end46
  %running53 = load i64, ptr %running, align 8
  %44 = mul i64 %running53, 100
  %c54 = load i32, ptr %c36, align 4
  %45 = sub i32 %c54, 65
  %46 = add i32 %45, 10
  %47 = sext i32 %46 to i64
  %48 = add i64 %44, %47
  %49 = icmp eq i64 %48, -9223372036854775808
  %50 = and i1 %49, false
  %51 = or i1 false, %50
  br i1 %51, label %div.bad55, label %div.ok56

if.else51:                                        ; preds = %sc.end46
  ret i32 0

if.end52:                                         ; preds = %div.ok56
  br label %if.end40

div.bad55:                                        ; preds = %if.then50
  %exc57 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc57)
  store ptr %exc57, ptr %exc.thrown58, align 8
  call void @_CxxThrowException(ptr %exc.thrown58, ptr @_TI1PEAX)
  unreachable

div.ok56:                                         ; preds = %if.then50
  %52 = srem i64 %48, 97
  store i64 %52, ptr %running, align 8
  br label %if.end52
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5365)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5367)
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

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i64 @__polaron_str_index(ptr, i64, ptr, i64)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
