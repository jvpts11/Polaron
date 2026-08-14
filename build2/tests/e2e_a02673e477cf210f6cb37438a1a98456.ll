; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol"
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
@.fail = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:14:22  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:14:33  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:14:44  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:14:55  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:14:66  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:14:77  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:14:88  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:14:99  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [23 x i8] c"dc_re=%.4f dc_im=%.4f\0A\00", align 1
@.fail.22 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:16:41  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:16:41  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.28 = private unnamed_addr constant [34 x i8] c"back0=%.4f back1=%.4f back4=%.4f\0A\00", align 1
@.fail.29 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:18:41  in main\0A\00", align 1
@.faila.30 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.31 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.32 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:18:41  in main\0A\00", align 1
@.faila.33 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.34 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.35 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fft.pol:18:41  in main\0A\00", align 1
@.faila.36 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.37 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1344 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1345 = private global %String { i64 16, ptr @.strdata.1344, i64 0 }
@.strdata.1346 = private constant [17 x i8] c"division by zero\00"
@.strobj.1347 = private global %String { i64 16, ptr @.strdata.1346, i64 0 }
@.fail.3690 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6453:25  in Fft.transform\0A\00", align 1
@.faila.3691 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3692 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3693 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6453:50  in Fft.transform\0A\00", align 1
@.faila.3694 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3695 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3696 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6453:50  in Fft.transform\0A\00", align 1
@.faila.3697 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3698 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3699 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6453:65  in Fft.transform\0A\00", align 1
@.faila.3700 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3701 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3702 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6454:25  in Fft.transform\0A\00", align 1
@.faila.3703 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3704 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3705 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6454:50  in Fft.transform\0A\00", align 1
@.faila.3706 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3707 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3708 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6454:50  in Fft.transform\0A\00", align 1
@.faila.3709 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3710 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3711 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6454:65  in Fft.transform\0A\00", align 1
@.faila.3712 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3713 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3714 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6471:29  in Fft.transform\0A\00", align 1
@.faila.3715 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3716 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3717 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6472:29  in Fft.transform\0A\00", align 1
@.faila.3718 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3719 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3720 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6473:29  in Fft.transform\0A\00", align 1
@.faila.3721 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3722 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3723 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6473:29  in Fft.transform\0A\00", align 1
@.faila.3724 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3725 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3726 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6474:29  in Fft.transform\0A\00", align 1
@.faila.3727 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3728 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3729 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6474:29  in Fft.transform\0A\00", align 1
@.faila.3730 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3731 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3732 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6475:35  in Fft.transform\0A\00", align 1
@.faila.3733 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3734 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3735 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6475:54  in Fft.transform\0A\00", align 1
@.faila.3736 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3737 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3738 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6476:35  in Fft.transform\0A\00", align 1
@.faila.3739 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3740 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3741 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6476:54  in Fft.transform\0A\00", align 1
@.faila.3742 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3743 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3744 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6494:27  in Fft.inverse\0A\00", align 1
@.faila.3745 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3746 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3747 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6494:27  in Fft.inverse\0A\00", align 1
@.faila.3748 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3749 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3750 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6495:27  in Fft.inverse\0A\00", align 1
@.faila.3751 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3752 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3753 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6495:27  in Fft.inverse\0A\00", align 1
@.faila.3754 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3755 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5345 = private constant [1 x i8] zeroinitializer
@.strobj.5346 = private global %String { i64 0, ptr @.strdata.5345, i64 0 }
@.strdata.5347 = private constant [1 x i8] zeroinitializer
@.strobj.5348 = private global %String { i64 0, ptr @.strdata.5347, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %im = alloca ptr, align 8
  %re = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 64)
  store ptr %arr, ptr %re, align 8
  %arr2 = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr2, align 8
  %arr.data3 = getelementptr i8, ptr %arr2, i64 8
  %17 = call ptr @memset(ptr %arr.data3, i32 0, i64 64)
  store ptr %arr2, ptr %im, align 8
  %re4 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %re4, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data5 = getelementptr i8, ptr %re4, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data5, i64 0
  store double 1.000000e+00, ptr %arr.elem, align 8
  %re6 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len7 = load i64, ptr %re6, align 8
  %arr.oob8 = icmp uge i64 1, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %re6, i64 8
  %arr.elem12 = getelementptr inbounds double, ptr %arr.data11, i64 1
  store double 1.000000e+00, ptr %arr.elem12, align 8
  %re13 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len14 = load i64, ptr %re13, align 8
  %arr.oob15 = icmp uge i64 2, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad16:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok10
  %arr.data18 = getelementptr i8, ptr %re13, i64 8
  %arr.elem19 = getelementptr inbounds double, ptr %arr.data18, i64 2
  store double 1.000000e+00, ptr %arr.elem19, align 8
  %re20 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len21 = load i64, ptr %re20, align 8
  %arr.oob22 = icmp uge i64 3, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

idx.bad23:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok17
  %arr.data25 = getelementptr i8, ptr %re20, i64 8
  %arr.elem26 = getelementptr inbounds double, ptr %arr.data25, i64 3
  store double 1.000000e+00, ptr %arr.elem26, align 8
  %re27 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len28 = load i64, ptr %re27, align 8
  %arr.oob29 = icmp uge i64 4, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok24
  %arr.data32 = getelementptr i8, ptr %re27, i64 8
  %arr.elem33 = getelementptr inbounds double, ptr %arr.data32, i64 4
  store double 0.000000e+00, ptr %arr.elem33, align 8
  %re34 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len35 = load i64, ptr %re34, align 8
  %arr.oob36 = icmp uge i64 5, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !2

idx.bad37:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 5, ptr @.failb.15, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %idx.ok31
  %arr.data39 = getelementptr i8, ptr %re34, i64 8
  %arr.elem40 = getelementptr inbounds double, ptr %arr.data39, i64 5
  store double 0.000000e+00, ptr %arr.elem40, align 8
  %re41 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len42 = load i64, ptr %re41, align 8
  %arr.oob43 = icmp uge i64 6, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !2

idx.bad44:                                        ; preds = %idx.ok38
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 6, ptr @.failb.18, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok38
  %arr.data46 = getelementptr i8, ptr %re41, i64 8
  %arr.elem47 = getelementptr inbounds double, ptr %arr.data46, i64 6
  store double 0.000000e+00, ptr %arr.elem47, align 8
  %re48 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len49 = load i64, ptr %re48, align 8
  %arr.oob50 = icmp uge i64 7, %arr.len49
  br i1 %arr.oob50, label %idx.bad51, label %idx.ok52, !prof !2

idx.bad51:                                        ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 7, ptr @.failb.21, i64 %arr.len49, i32 70)
  unreachable

idx.ok52:                                         ; preds = %idx.ok45
  %arr.data53 = getelementptr i8, ptr %re48, i64 8
  %arr.elem54 = getelementptr inbounds double, ptr %arr.data53, i64 7
  store double 0.000000e+00, ptr %arr.elem54, align 8
  %re55 = load ptr, ptr %re, align 8
  %im56 = load ptr, ptr %im, align 8
  call void @Fft.forward(ptr %re55, ptr %im56, i32 8)
  %re57 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len58 = load i64, ptr %re57, align 8
  %arr.oob59 = icmp uge i64 0, %arr.len58
  br i1 %arr.oob59, label %idx.bad60, label %idx.ok61, !prof !2

idx.bad60:                                        ; preds = %idx.ok52
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 0, ptr @.failb.24, i64 %arr.len58, i32 70)
  unreachable

idx.ok61:                                         ; preds = %idx.ok52
  %arr.data62 = getelementptr i8, ptr %re57, i64 8
  %arr.elem63 = getelementptr inbounds double, ptr %arr.data62, i64 0
  %elem = load double, ptr %arr.elem63, align 8
  %im64 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %arr.len65 = load i64, ptr %im64, align 8
  %arr.oob66 = icmp uge i64 0, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !2

idx.bad67:                                        ; preds = %idx.ok61
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 0, ptr @.failb.27, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %idx.ok61
  %arr.data69 = getelementptr i8, ptr %im64, i64 8
  %arr.elem70 = getelementptr inbounds double, ptr %arr.data69, i64 0
  %elem71 = load double, ptr %arr.elem70, align 8
  %18 = call i32 (ptr, ...) @printf(ptr @.str, double %elem, double %elem71)
  %re72 = load ptr, ptr %re, align 8
  %im73 = load ptr, ptr %im, align 8
  call void @Fft.inverse(ptr %re72, ptr %im73, i32 8)
  %re74 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len75 = load i64, ptr %re74, align 8
  %arr.oob76 = icmp uge i64 0, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !2

idx.bad77:                                        ; preds = %idx.ok68
  call void @__polaron_fail(ptr @.fail.29, ptr @.faila.30, i64 0, ptr @.failb.31, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %idx.ok68
  %arr.data79 = getelementptr i8, ptr %re74, i64 8
  %arr.elem80 = getelementptr inbounds double, ptr %arr.data79, i64 0
  %elem81 = load double, ptr %arr.elem80, align 8
  %re82 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len83 = load i64, ptr %re82, align 8
  %arr.oob84 = icmp uge i64 1, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !2

idx.bad85:                                        ; preds = %idx.ok78
  call void @__polaron_fail(ptr @.fail.32, ptr @.faila.33, i64 1, ptr @.failb.34, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok78
  %arr.data87 = getelementptr i8, ptr %re82, i64 8
  %arr.elem88 = getelementptr inbounds double, ptr %arr.data87, i64 1
  %elem89 = load double, ptr %arr.elem88, align 8
  %re90 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %arr.len91 = load i64, ptr %re90, align 8
  %arr.oob92 = icmp uge i64 4, %arr.len91
  br i1 %arr.oob92, label %idx.bad93, label %idx.ok94, !prof !2

idx.bad93:                                        ; preds = %idx.ok86
  call void @__polaron_fail(ptr @.fail.35, ptr @.faila.36, i64 4, ptr @.failb.37, i64 %arr.len91, i32 70)
  unreachable

idx.ok94:                                         ; preds = %idx.ok86
  %arr.data95 = getelementptr i8, ptr %re90, i64 8
  %arr.elem96 = getelementptr inbounds double, ptr %arr.data95, i64 4
  %elem97 = load double, ptr %arr.elem96, align 8
  %19 = call i32 (ptr, ...) @printf(ptr @.str.28, double %elem81, double %elem89, double %elem97)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1345)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1347)
  ret ptr %strcpy
}

define internal double @Numerics.reduce(double %0) {
entry:
  %r = alloca double, align 8
  %tau = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  store double 0x401921FB54442D18, ptr %tau, align 8
  %x1 = load double, ptr %x, align 8
  store double %x1, ptr %r, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %r2 = load double, ptr %r, align 8
  %1 = fcmp ogt double %r2, 0x400921FB54442D18
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %r3 = load double, ptr %r, align 8
  %tau4 = load double, ptr %tau, align 8
  %3 = fsub double %r3, %tau4
  store double %3, ptr %r, align 8
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %while.cond5

while.cond5:                                      ; preds = %while.body6, %while.end
  %r8 = load double, ptr %r, align 8
  %4 = fcmp olt double %r8, 0xC00921FB54442D18
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body6, label %while.end7

while.body6:                                      ; preds = %while.cond5
  %r9 = load double, ptr %r, align 8
  %tau10 = load double, ptr %tau, align 8
  %6 = fadd double %r9, %tau10
  store double %6, ptr %r, align 8
  br label %while.cond5

while.end7:                                       ; preds = %while.cond5
  %r11 = load double, ptr %r, align 8
  ret double %r11
}

define internal double @Numerics.sin(double %0) {
entry:
  %n = alloca i32, align 4
  %sum = alloca double, align 8
  %term = alloca double, align 8
  %r24 = alloca double, align 8
  %r = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = call double @Numerics.reduce(double %x1)
  store double %1, ptr %r, align 8
  %r2 = load double, ptr %r, align 8
  %r3 = load double, ptr %r, align 8
  %2 = fmul double %r2, %r3
  store double %2, ptr %r24, align 8
  %r5 = load double, ptr %r, align 8
  store double %r5, ptr %term, align 8
  %r6 = load double, ptr %r, align 8
  store double %r6, ptr %sum, align 8
  store i32 1, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %n7 = load i32, ptr %n, align 4
  %3 = icmp sle i32 %n7, 12
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %term8 = load double, ptr %term, align 8
  %r29 = load double, ptr %r24, align 8
  %5 = fmul double %term8, %r29
  %n10 = load i32, ptr %n, align 4
  %6 = mul i32 2, %n10
  %n11 = load i32, ptr %n, align 4
  %7 = mul i32 2, %n11
  %8 = add i32 %7, 1
  %9 = mul i32 %6, %8
  %10 = sitofp i32 %9 to double
  %11 = fdiv double %5, %10
  %12 = fsub double 0.000000e+00, %11
  store double %12, ptr %term, align 8
  %sum12 = load double, ptr %sum, align 8
  %term13 = load double, ptr %term, align 8
  %13 = fadd double %sum12, %term13
  store double %13, ptr %sum, align 8
  %n14 = load i32, ptr %n, align 4
  %14 = add i32 %n14, 1
  store i32 %14, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %sum15 = load double, ptr %sum, align 8
  ret double %sum15
}

define internal double @Numerics.cos(double %0) {
entry:
  %n = alloca i32, align 4
  %sum = alloca double, align 8
  %term = alloca double, align 8
  %r24 = alloca double, align 8
  %r = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = call double @Numerics.reduce(double %x1)
  store double %1, ptr %r, align 8
  %r2 = load double, ptr %r, align 8
  %r3 = load double, ptr %r, align 8
  %2 = fmul double %r2, %r3
  store double %2, ptr %r24, align 8
  store double 1.000000e+00, ptr %term, align 8
  store double 1.000000e+00, ptr %sum, align 8
  store i32 1, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %n5 = load i32, ptr %n, align 4
  %3 = icmp sle i32 %n5, 12
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %term6 = load double, ptr %term, align 8
  %r27 = load double, ptr %r24, align 8
  %5 = fmul double %term6, %r27
  %n8 = load i32, ptr %n, align 4
  %6 = mul i32 2, %n8
  %7 = sub i32 %6, 1
  %n9 = load i32, ptr %n, align 4
  %8 = mul i32 2, %n9
  %9 = mul i32 %7, %8
  %10 = sitofp i32 %9 to double
  %11 = fdiv double %5, %10
  %12 = fsub double 0.000000e+00, %11
  store double %12, ptr %term, align 8
  %sum10 = load double, ptr %sum, align 8
  %term11 = load double, ptr %term, align 8
  %13 = fadd double %sum10, %term11
  store double %13, ptr %sum, align 8
  %n12 = load i32, ptr %n, align 4
  %14 = add i32 %n12, 1
  store i32 %14, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %sum13 = load double, ptr %sum, align 8
  ret double %sum13
}

define internal void @Fft.transform(ptr %0, ptr %1, i32 %2, i32 %3) personality ptr @__CxxFrameHandler3 {
entry:
  %ncwr = alloca double, align 8
  %vim = alloca double, align 8
  %vre = alloca double, align 8
  %uim = alloca double, align 8
  %ure = alloca double, align 8
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %k = alloca i32, align 4
  %half = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %cwi = alloca double, align 8
  %cwr = alloca double, align 8
  %base = alloca i32, align 4
  %wi = alloca double, align 8
  %wr = alloca double, align 8
  %ang = alloca double, align 8
  %len = alloca i32, align 4
  %tau = alloca double, align 8
  %ti = alloca double, align 8
  %tr = alloca double, align 8
  %bit = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %sign = alloca i32, align 4
  %n = alloca i32, align 4
  %im = alloca ptr, align 8
  %re = alloca ptr, align 8
  store ptr %0, ptr %re, align 8
  store ptr %1, ptr %im, align 8
  store i32 %2, ptr %n, align 4
  store i32 %3, ptr %sign, align 4
  store i32 0, ptr %j, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %4 = icmp slt i32 %i1, %n2
  %5 = zext i1 %4 to i32
  br i1 %4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %n3 = load i32, ptr %n, align 4
  %6 = ashr i32 %n3, 31
  %7 = ashr i32 %n3, 1
  store i32 %7, ptr %bit, align 4
  br label %while.cond

for.update:                                       ; preds = %if.end
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store double 0x401921FB54442D18, ptr %tau, align 8
  store i32 2, ptr %len, align 4
  br label %while.cond76

while.cond:                                       ; preds = %while.body, %for.body
  %j4 = load i32, ptr %j, align 4
  %bit5 = load i32, ptr %bit, align 4
  %10 = and i32 %j4, %bit5
  %11 = icmp ne i32 %10, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %j6 = load i32, ptr %j, align 4
  %bit7 = load i32, ptr %bit, align 4
  %13 = xor i32 %j6, %bit7
  store i32 %13, ptr %j, align 4
  %bit8 = load i32, ptr %bit, align 4
  %14 = ashr i32 %bit8, 31
  %15 = ashr i32 %bit8, 1
  store i32 %15, ptr %bit, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %j9 = load i32, ptr %j, align 4
  %bit10 = load i32, ptr %bit, align 4
  %16 = or i32 %j9, %bit10
  store i32 %16, ptr %j, align 4
  %i11 = load i32, ptr %i, align 4
  %j12 = load i32, ptr %j, align 4
  %17 = icmp slt i32 %i11, %j12
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then, label %if.end

if.then:                                          ; preds = %while.end
  %re13 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %i14 = load i32, ptr %i, align 4
  %19 = sext i32 %i14 to i64
  %arr.len = load i64, ptr %re13, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %idx.ok72, %while.end
  br label %for.update

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3690, ptr @.faila.3691, i64 %19, ptr @.failb.3692, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %re13, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %19
  %elem = load double, ptr %arr.elem, align 8
  store double %elem, ptr %tr, align 8
  %re15 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %20 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %re15, align 8
  %arr.oob18 = icmp uge i64 %20, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3693, ptr @.faila.3694, i64 %20, ptr @.failb.3695, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %re15, i64 8
  %arr.elem22 = getelementptr inbounds double, ptr %arr.data21, i64 %20
  %re23 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %j24 = load i32, ptr %j, align 4
  %21 = sext i32 %j24 to i64
  %arr.len25 = load i64, ptr %re23, align 8
  %arr.oob26 = icmp uge i64 %21, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !2

idx.bad27:                                        ; preds = %idx.ok20
  call void @__polaron_fail(ptr @.fail.3696, ptr @.faila.3697, i64 %21, ptr @.failb.3698, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok20
  %arr.data29 = getelementptr i8, ptr %re23, i64 8
  %arr.elem30 = getelementptr inbounds double, ptr %arr.data29, i64 %21
  %elem31 = load double, ptr %arr.elem30, align 8
  store double %elem31, ptr %arr.elem22, align 8
  %re32 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %j33 = load i32, ptr %j, align 4
  %22 = sext i32 %j33 to i64
  %arr.len34 = load i64, ptr %re32, align 8
  %arr.oob35 = icmp uge i64 %22, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !2

idx.bad36:                                        ; preds = %idx.ok28
  call void @__polaron_fail(ptr @.fail.3699, ptr @.faila.3700, i64 %22, ptr @.failb.3701, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %idx.ok28
  %arr.data38 = getelementptr i8, ptr %re32, i64 8
  %arr.elem39 = getelementptr inbounds double, ptr %arr.data38, i64 %22
  %tr40 = load double, ptr %tr, align 8
  store double %tr40, ptr %arr.elem39, align 8
  %im41 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %i42 = load i32, ptr %i, align 4
  %23 = sext i32 %i42 to i64
  %arr.len43 = load i64, ptr %im41, align 8
  %arr.oob44 = icmp uge i64 %23, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !2

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.3702, ptr @.faila.3703, i64 %23, ptr @.failb.3704, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok37
  %arr.data47 = getelementptr i8, ptr %im41, i64 8
  %arr.elem48 = getelementptr inbounds double, ptr %arr.data47, i64 %23
  %elem49 = load double, ptr %arr.elem48, align 8
  store double %elem49, ptr %ti, align 8
  %im50 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %i51 = load i32, ptr %i, align 4
  %24 = sext i32 %i51 to i64
  %arr.len52 = load i64, ptr %im50, align 8
  %arr.oob53 = icmp uge i64 %24, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !2

idx.bad54:                                        ; preds = %idx.ok46
  call void @__polaron_fail(ptr @.fail.3705, ptr @.faila.3706, i64 %24, ptr @.failb.3707, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %idx.ok46
  %arr.data56 = getelementptr i8, ptr %im50, i64 8
  %arr.elem57 = getelementptr inbounds double, ptr %arr.data56, i64 %24
  %im58 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %j59 = load i32, ptr %j, align 4
  %25 = sext i32 %j59 to i64
  %arr.len60 = load i64, ptr %im58, align 8
  %arr.oob61 = icmp uge i64 %25, %arr.len60
  br i1 %arr.oob61, label %idx.bad62, label %idx.ok63, !prof !2

idx.bad62:                                        ; preds = %idx.ok55
  call void @__polaron_fail(ptr @.fail.3708, ptr @.faila.3709, i64 %25, ptr @.failb.3710, i64 %arr.len60, i32 70)
  unreachable

idx.ok63:                                         ; preds = %idx.ok55
  %arr.data64 = getelementptr i8, ptr %im58, i64 8
  %arr.elem65 = getelementptr inbounds double, ptr %arr.data64, i64 %25
  %elem66 = load double, ptr %arr.elem65, align 8
  store double %elem66, ptr %arr.elem57, align 8
  %im67 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %j68 = load i32, ptr %j, align 4
  %26 = sext i32 %j68 to i64
  %arr.len69 = load i64, ptr %im67, align 8
  %arr.oob70 = icmp uge i64 %26, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !2

idx.bad71:                                        ; preds = %idx.ok63
  call void @__polaron_fail(ptr @.fail.3711, ptr @.faila.3712, i64 %26, ptr @.failb.3713, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok63
  %arr.data73 = getelementptr i8, ptr %im67, i64 8
  %arr.elem74 = getelementptr inbounds double, ptr %arr.data73, i64 %26
  %ti75 = load double, ptr %ti, align 8
  store double %ti75, ptr %arr.elem74, align 8
  br label %if.end

while.cond76:                                     ; preds = %while.end88, %for.end
  %len79 = load i32, ptr %len, align 4
  %n80 = load i32, ptr %n, align 4
  %27 = icmp sle i32 %len79, %n80
  %28 = zext i1 %27 to i32
  br i1 %27, label %while.body77, label %while.end78

while.body77:                                     ; preds = %while.cond76
  %sign81 = load i32, ptr %sign, align 4
  %29 = sitofp i32 %sign81 to double
  %tau82 = load double, ptr %tau, align 8
  %30 = fmul double %29, %tau82
  %len83 = load i32, ptr %len, align 4
  %31 = sitofp i32 %len83 to double
  %32 = fdiv double %30, %31
  store double %32, ptr %ang, align 8
  %ang84 = load double, ptr %ang, align 8
  %33 = call double @Numerics.cos(double %ang84)
  store double %33, ptr %wr, align 8
  %ang85 = load double, ptr %ang, align 8
  %34 = call double @Numerics.sin(double %ang85)
  store double %34, ptr %wi, align 8
  store i32 0, ptr %base, align 4
  br label %while.cond86

while.end78:                                      ; preds = %while.cond76
  ret void

while.cond86:                                     ; preds = %for.end95, %while.body77
  %base89 = load i32, ptr %base, align 4
  %n90 = load i32, ptr %n, align 4
  %35 = icmp slt i32 %base89, %n90
  %36 = zext i1 %35 to i32
  br i1 %35, label %while.body87, label %while.end88

while.body87:                                     ; preds = %while.cond86
  store double 1.000000e+00, ptr %cwr, align 8
  store double 0.000000e+00, ptr %cwi, align 8
  %len91 = load i32, ptr %len, align 4
  %37 = icmp eq i32 %len91, -2147483648
  %38 = and i1 %37, false
  %39 = or i1 false, %38
  br i1 %39, label %div.bad, label %div.ok

while.end88:                                      ; preds = %while.cond86
  %len212 = load i32, ptr %len, align 4
  %40 = shl i32 %len212, 1
  store i32 %40, ptr %len, align 4
  br label %while.cond76

div.bad:                                          ; preds = %while.body87
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body87
  %41 = sdiv i32 %len91, 2
  store i32 %41, ptr %half, align 4
  store i32 0, ptr %k, align 4
  br label %for.cond92

for.cond92:                                       ; preds = %for.update94, %div.ok
  %k96 = load i32, ptr %k, align 4
  %half97 = load i32, ptr %half, align 4
  %42 = icmp slt i32 %k96, %half97
  %43 = zext i1 %42 to i32
  br i1 %42, label %for.body93, label %for.end95

for.body93:                                       ; preds = %for.cond92
  %base98 = load i32, ptr %base, align 4
  %k99 = load i32, ptr %k, align 4
  %44 = add i32 %base98, %k99
  store i32 %44, ptr %a, align 4
  %base100 = load i32, ptr %base, align 4
  %k101 = load i32, ptr %k, align 4
  %45 = add i32 %base100, %k101
  %half102 = load i32, ptr %half, align 4
  %46 = add i32 %45, %half102
  store i32 %46, ptr %b, align 4
  %re103 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %a104 = load i32, ptr %a, align 4
  %47 = sext i32 %a104 to i64
  %arr.len105 = load i64, ptr %re103, align 8
  %arr.oob106 = icmp uge i64 %47, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !2

for.update94:                                     ; preds = %idx.ok196
  %48 = load i32, ptr %k, align 4
  %49 = add i32 %48, 1
  store i32 %49, ptr %k, align 4
  br label %for.cond92

for.end95:                                        ; preds = %for.cond92
  %base210 = load i32, ptr %base, align 4
  %len211 = load i32, ptr %len, align 4
  %50 = add i32 %base210, %len211
  store i32 %50, ptr %base, align 4
  br label %while.cond86

idx.bad107:                                       ; preds = %for.body93
  call void @__polaron_fail(ptr @.fail.3714, ptr @.faila.3715, i64 %47, ptr @.failb.3716, i64 %arr.len105, i32 70)
  unreachable

idx.ok108:                                        ; preds = %for.body93
  %arr.data109 = getelementptr i8, ptr %re103, i64 8
  %arr.elem110 = getelementptr inbounds double, ptr %arr.data109, i64 %47
  %elem111 = load double, ptr %arr.elem110, align 8
  store double %elem111, ptr %ure, align 8
  %im112 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %a113 = load i32, ptr %a, align 4
  %51 = sext i32 %a113 to i64
  %arr.len114 = load i64, ptr %im112, align 8
  %arr.oob115 = icmp uge i64 %51, %arr.len114
  br i1 %arr.oob115, label %idx.bad116, label %idx.ok117, !prof !2

idx.bad116:                                       ; preds = %idx.ok108
  call void @__polaron_fail(ptr @.fail.3717, ptr @.faila.3718, i64 %51, ptr @.failb.3719, i64 %arr.len114, i32 70)
  unreachable

idx.ok117:                                        ; preds = %idx.ok108
  %arr.data118 = getelementptr i8, ptr %im112, i64 8
  %arr.elem119 = getelementptr inbounds double, ptr %arr.data118, i64 %51
  %elem120 = load double, ptr %arr.elem119, align 8
  store double %elem120, ptr %uim, align 8
  %re121 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %b122 = load i32, ptr %b, align 4
  %52 = sext i32 %b122 to i64
  %arr.len123 = load i64, ptr %re121, align 8
  %arr.oob124 = icmp uge i64 %52, %arr.len123
  br i1 %arr.oob124, label %idx.bad125, label %idx.ok126, !prof !2

idx.bad125:                                       ; preds = %idx.ok117
  call void @__polaron_fail(ptr @.fail.3720, ptr @.faila.3721, i64 %52, ptr @.failb.3722, i64 %arr.len123, i32 70)
  unreachable

idx.ok126:                                        ; preds = %idx.ok117
  %arr.data127 = getelementptr i8, ptr %re121, i64 8
  %arr.elem128 = getelementptr inbounds double, ptr %arr.data127, i64 %52
  %elem129 = load double, ptr %arr.elem128, align 8
  %cwr130 = load double, ptr %cwr, align 8
  %53 = fmul double %elem129, %cwr130
  %im131 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %b132 = load i32, ptr %b, align 4
  %54 = sext i32 %b132 to i64
  %arr.len133 = load i64, ptr %im131, align 8
  %arr.oob134 = icmp uge i64 %54, %arr.len133
  br i1 %arr.oob134, label %idx.bad135, label %idx.ok136, !prof !2

idx.bad135:                                       ; preds = %idx.ok126
  call void @__polaron_fail(ptr @.fail.3723, ptr @.faila.3724, i64 %54, ptr @.failb.3725, i64 %arr.len133, i32 70)
  unreachable

idx.ok136:                                        ; preds = %idx.ok126
  %arr.data137 = getelementptr i8, ptr %im131, i64 8
  %arr.elem138 = getelementptr inbounds double, ptr %arr.data137, i64 %54
  %elem139 = load double, ptr %arr.elem138, align 8
  %cwi140 = load double, ptr %cwi, align 8
  %55 = fmul double %elem139, %cwi140
  %56 = fsub double %53, %55
  store double %56, ptr %vre, align 8
  %re141 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %b142 = load i32, ptr %b, align 4
  %57 = sext i32 %b142 to i64
  %arr.len143 = load i64, ptr %re141, align 8
  %arr.oob144 = icmp uge i64 %57, %arr.len143
  br i1 %arr.oob144, label %idx.bad145, label %idx.ok146, !prof !2

idx.bad145:                                       ; preds = %idx.ok136
  call void @__polaron_fail(ptr @.fail.3726, ptr @.faila.3727, i64 %57, ptr @.failb.3728, i64 %arr.len143, i32 70)
  unreachable

idx.ok146:                                        ; preds = %idx.ok136
  %arr.data147 = getelementptr i8, ptr %re141, i64 8
  %arr.elem148 = getelementptr inbounds double, ptr %arr.data147, i64 %57
  %elem149 = load double, ptr %arr.elem148, align 8
  %cwi150 = load double, ptr %cwi, align 8
  %58 = fmul double %elem149, %cwi150
  %im151 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %b152 = load i32, ptr %b, align 4
  %59 = sext i32 %b152 to i64
  %arr.len153 = load i64, ptr %im151, align 8
  %arr.oob154 = icmp uge i64 %59, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !2

idx.bad155:                                       ; preds = %idx.ok146
  call void @__polaron_fail(ptr @.fail.3729, ptr @.faila.3730, i64 %59, ptr @.failb.3731, i64 %arr.len153, i32 70)
  unreachable

idx.ok156:                                        ; preds = %idx.ok146
  %arr.data157 = getelementptr i8, ptr %im151, i64 8
  %arr.elem158 = getelementptr inbounds double, ptr %arr.data157, i64 %59
  %elem159 = load double, ptr %arr.elem158, align 8
  %cwr160 = load double, ptr %cwr, align 8
  %60 = fmul double %elem159, %cwr160
  %61 = fadd double %58, %60
  store double %61, ptr %vim, align 8
  %re161 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %a162 = load i32, ptr %a, align 4
  %62 = sext i32 %a162 to i64
  %arr.len163 = load i64, ptr %re161, align 8
  %arr.oob164 = icmp uge i64 %62, %arr.len163
  br i1 %arr.oob164, label %idx.bad165, label %idx.ok166, !prof !2

idx.bad165:                                       ; preds = %idx.ok156
  call void @__polaron_fail(ptr @.fail.3732, ptr @.faila.3733, i64 %62, ptr @.failb.3734, i64 %arr.len163, i32 70)
  unreachable

idx.ok166:                                        ; preds = %idx.ok156
  %arr.data167 = getelementptr i8, ptr %re161, i64 8
  %arr.elem168 = getelementptr inbounds double, ptr %arr.data167, i64 %62
  %ure169 = load double, ptr %ure, align 8
  %vre170 = load double, ptr %vre, align 8
  %63 = fadd double %ure169, %vre170
  store double %63, ptr %arr.elem168, align 8
  %im171 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %a172 = load i32, ptr %a, align 4
  %64 = sext i32 %a172 to i64
  %arr.len173 = load i64, ptr %im171, align 8
  %arr.oob174 = icmp uge i64 %64, %arr.len173
  br i1 %arr.oob174, label %idx.bad175, label %idx.ok176, !prof !2

idx.bad175:                                       ; preds = %idx.ok166
  call void @__polaron_fail(ptr @.fail.3735, ptr @.faila.3736, i64 %64, ptr @.failb.3737, i64 %arr.len173, i32 70)
  unreachable

idx.ok176:                                        ; preds = %idx.ok166
  %arr.data177 = getelementptr i8, ptr %im171, i64 8
  %arr.elem178 = getelementptr inbounds double, ptr %arr.data177, i64 %64
  %uim179 = load double, ptr %uim, align 8
  %vim180 = load double, ptr %vim, align 8
  %65 = fadd double %uim179, %vim180
  store double %65, ptr %arr.elem178, align 8
  %re181 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %b182 = load i32, ptr %b, align 4
  %66 = sext i32 %b182 to i64
  %arr.len183 = load i64, ptr %re181, align 8
  %arr.oob184 = icmp uge i64 %66, %arr.len183
  br i1 %arr.oob184, label %idx.bad185, label %idx.ok186, !prof !2

idx.bad185:                                       ; preds = %idx.ok176
  call void @__polaron_fail(ptr @.fail.3738, ptr @.faila.3739, i64 %66, ptr @.failb.3740, i64 %arr.len183, i32 70)
  unreachable

idx.ok186:                                        ; preds = %idx.ok176
  %arr.data187 = getelementptr i8, ptr %re181, i64 8
  %arr.elem188 = getelementptr inbounds double, ptr %arr.data187, i64 %66
  %ure189 = load double, ptr %ure, align 8
  %vre190 = load double, ptr %vre, align 8
  %67 = fsub double %ure189, %vre190
  store double %67, ptr %arr.elem188, align 8
  %im191 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %b192 = load i32, ptr %b, align 4
  %68 = sext i32 %b192 to i64
  %arr.len193 = load i64, ptr %im191, align 8
  %arr.oob194 = icmp uge i64 %68, %arr.len193
  br i1 %arr.oob194, label %idx.bad195, label %idx.ok196, !prof !2

idx.bad195:                                       ; preds = %idx.ok186
  call void @__polaron_fail(ptr @.fail.3741, ptr @.faila.3742, i64 %68, ptr @.failb.3743, i64 %arr.len193, i32 70)
  unreachable

idx.ok196:                                        ; preds = %idx.ok186
  %arr.data197 = getelementptr i8, ptr %im191, i64 8
  %arr.elem198 = getelementptr inbounds double, ptr %arr.data197, i64 %68
  %uim199 = load double, ptr %uim, align 8
  %vim200 = load double, ptr %vim, align 8
  %69 = fsub double %uim199, %vim200
  store double %69, ptr %arr.elem198, align 8
  %cwr201 = load double, ptr %cwr, align 8
  %wr202 = load double, ptr %wr, align 8
  %70 = fmul double %cwr201, %wr202
  %cwi203 = load double, ptr %cwi, align 8
  %wi204 = load double, ptr %wi, align 8
  %71 = fmul double %cwi203, %wi204
  %72 = fsub double %70, %71
  store double %72, ptr %ncwr, align 8
  %cwr205 = load double, ptr %cwr, align 8
  %wi206 = load double, ptr %wi, align 8
  %73 = fmul double %cwr205, %wi206
  %cwi207 = load double, ptr %cwi, align 8
  %wr208 = load double, ptr %wr, align 8
  %74 = fmul double %cwi207, %wr208
  %75 = fadd double %73, %74
  store double %75, ptr %cwi, align 8
  %ncwr209 = load double, ptr %ncwr, align 8
  store double %ncwr209, ptr %cwr, align 8
  br label %for.update94
}

define internal void @Fft.forward(ptr %0, ptr %1, i32 %2) {
entry:
  %n = alloca i32, align 4
  %im = alloca ptr, align 8
  %re = alloca ptr, align 8
  store ptr %0, ptr %re, align 8
  store ptr %1, ptr %im, align 8
  store i32 %2, ptr %n, align 4
  %re1 = load ptr, ptr %re, align 8
  %im2 = load ptr, ptr %im, align 8
  %n3 = load i32, ptr %n, align 4
  call void @Fft.transform(ptr %re1, ptr %im2, i32 %n3, i32 -1)
  ret void
}

define internal void @Fft.inverse(ptr %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %im = alloca ptr, align 8
  %re = alloca ptr, align 8
  store ptr %0, ptr %re, align 8
  store ptr %1, ptr %im, align 8
  store i32 %2, ptr %n, align 4
  %re1 = load ptr, ptr %re, align 8
  %im2 = load ptr, ptr %im, align 8
  %n3 = load i32, ptr %n, align 4
  call void @Fft.transform(ptr %re1, ptr %im2, i32 %n3, i32 1)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %i4, %n5
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %re6 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %5 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %re6, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok30
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3744, ptr @.faila.3745, i64 %5, ptr @.failb.3746, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %re6, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %5
  %re8 = load ptr, ptr %re, align 8, !nonnull !0, !dereferenceable !1
  %i9 = load i32, ptr %i, align 4
  %8 = sext i32 %i9 to i64
  %arr.len10 = load i64, ptr %re8, align 8
  %arr.oob11 = icmp uge i64 %8, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !2

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3747, ptr @.faila.3748, i64 %8, ptr @.failb.3749, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %re8, i64 8
  %arr.elem15 = getelementptr inbounds double, ptr %arr.data14, i64 %8
  %elem = load double, ptr %arr.elem15, align 8
  %n16 = load i32, ptr %n, align 4
  %9 = sitofp i32 %n16 to double
  %10 = fdiv double %elem, %9
  store double %10, ptr %arr.elem, align 8
  %im17 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %i18 = load i32, ptr %i, align 4
  %11 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %im17, align 8
  %arr.oob20 = icmp uge i64 %11, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok13
  call void @__polaron_fail(ptr @.fail.3750, ptr @.faila.3751, i64 %11, ptr @.failb.3752, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok13
  %arr.data23 = getelementptr i8, ptr %im17, i64 8
  %arr.elem24 = getelementptr inbounds double, ptr %arr.data23, i64 %11
  %im25 = load ptr, ptr %im, align 8, !nonnull !0, !dereferenceable !1
  %i26 = load i32, ptr %i, align 4
  %12 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %im25, align 8
  %arr.oob28 = icmp uge i64 %12, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !2

idx.bad29:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.3753, ptr @.faila.3754, i64 %12, ptr @.failb.3755, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %idx.ok22
  %arr.data31 = getelementptr i8, ptr %im25, i64 8
  %arr.elem32 = getelementptr inbounds double, ptr %arr.data31, i64 %12
  %elem33 = load double, ptr %arr.elem32, align 8
  %n34 = load i32, ptr %n, align 4
  %13 = sitofp i32 %n34 to double
  %14 = fdiv double %elem33, %13
  store double %14, ptr %arr.elem24, align 8
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5346)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5348)
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
