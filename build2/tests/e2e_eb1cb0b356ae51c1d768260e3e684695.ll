; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol"
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
@.fail = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:15:22  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:15:31  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:15:40  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:15:49  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:15:58  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:15:67  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:15:76  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:15:85  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [23 x i8] c"area2=%d in=%d out=%d\0A\00", align 1
@.fail.22 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:22  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:31  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:40  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:49  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:58  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:67  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:76  in main\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:85  in main\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:94  in main\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.49 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:103  in main\0A\00", align 1
@.faila.50 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.51 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.52 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:112  in main\0A\00", align 1
@.faila.53 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.54 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.55 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/geometry.pol:21:121  in main\0A\00", align 1
@.faila.56 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.57 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.58 = private unnamed_addr constant [9 x i8] c"hull=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1365 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1366 = private global %String { i64 16, ptr @.strdata.1365, i64 0 }
@.strdata.1367 = private constant [17 x i8] c"division by zero\00"
@.strobj.1368 = private global %String { i64 16, ptr @.strdata.1367, i64 0 }
@.fail.3558 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6060:23  in Polygon.area2\0A\00", align 1
@.faila.3559 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3560 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3561 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6060:23  in Polygon.area2\0A\00", align 1
@.faila.3562 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3563 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3564 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6060:23  in Polygon.area2\0A\00", align 1
@.faila.3565 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3566 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3567 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6060:23  in Polygon.area2\0A\00", align 1
@.faila.3568 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3569 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3570 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6069:21  in Polygon.contains\0A\00", align 1
@.faila.3571 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3572 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3573 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6069:21  in Polygon.contains\0A\00", align 1
@.faila.3574 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3575 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3576 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6071:25  in Polygon.contains\0A\00", align 1
@.faila.3577 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3578 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3579 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6071:25  in Polygon.contains\0A\00", align 1
@.faila.3580 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3581 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3582 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6072:25  in Polygon.contains\0A\00", align 1
@.faila.3583 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3584 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3585 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6072:25  in Polygon.contains\0A\00", align 1
@.faila.3586 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3587 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3588 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6073:25  in Polygon.contains\0A\00", align 1
@.faila.3589 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3590 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3591 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6074:25  in Polygon.contains\0A\00", align 1
@.faila.3592 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3593 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3594 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6090:17  in ConvexHull.cross\0A\00", align 1
@.faila.3595 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3596 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3597 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6090:17  in ConvexHull.cross\0A\00", align 1
@.faila.3598 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3599 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3600 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6090:17  in ConvexHull.cross\0A\00", align 1
@.faila.3601 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3602 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3603 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6090:17  in ConvexHull.cross\0A\00", align 1
@.faila.3604 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3605 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3606 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6090:17  in ConvexHull.cross\0A\00", align 1
@.faila.3607 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3608 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3609 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6090:17  in ConvexHull.cross\0A\00", align 1
@.faila.3610 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3611 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3612 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6090:17  in ConvexHull.cross\0A\00", align 1
@.faila.3613 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3614 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3615 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6090:17  in ConvexHull.cross\0A\00", align 1
@.faila.3616 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3617 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3618 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6095:62  in ConvexHull.size\0A\00", align 1
@.faila.3619 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3620 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3621 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6097:21  in ConvexHull.size\0A\00", align 1
@.faila.3622 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3623 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3624 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3625 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3626 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3627 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3628 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3629 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3630 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3631 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3632 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3633 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3634 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3635 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3636 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3637 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3638 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3639 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3640 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3641 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3642 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3643 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3644 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3645 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3646 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3647 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3648 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6099:21  in ConvexHull.size\0A\00", align 1
@.faila.3649 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3650 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3651 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6100:36  in ConvexHull.size\0A\00", align 1
@.faila.3652 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3653 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3654 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6100:36  in ConvexHull.size\0A\00", align 1
@.faila.3655 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3656 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3657 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6103:32  in ConvexHull.size\0A\00", align 1
@.faila.3658 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3659 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3660 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6108:21  in ConvexHull.size\0A\00", align 1
@.faila.3661 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3662 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3663 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6109:21  in ConvexHull.size\0A\00", align 1
@.faila.3664 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3665 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3666 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6109:21  in ConvexHull.size\0A\00", align 1
@.faila.3667 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3668 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3669 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6110:29  in ConvexHull.size\0A\00", align 1
@.faila.3670 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3671 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3672 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6114:21  in ConvexHull.size\0A\00", align 1
@.faila.3673 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3674 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3675 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6115:21  in ConvexHull.size\0A\00", align 1
@.faila.3676 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3677 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3678 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6115:21  in ConvexHull.size\0A\00", align 1
@.faila.3679 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3680 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3681 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6116:29  in ConvexHull.size\0A\00", align 1
@.faila.3682 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3683 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5366 = private constant [1 x i8] zeroinitializer
@.strobj.5367 = private global %String { i64 0, ptr @.strdata.5366, i64 0 }
@.strdata.5368 = private constant [1 x i8] zeroinitializer
@.strobj.5369 = private global %String { i64 0, ptr @.strdata.5368, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %hy = alloca ptr, align 8
  %hx = alloca ptr, align 8
  %sy = alloca ptr, align 8
  %sx = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 16)
  store ptr %arr, ptr %sx, align 8
  %arr2 = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr2, align 8
  %arr.data3 = getelementptr i8, ptr %arr2, i64 8
  %17 = call ptr @memset(ptr %arr.data3, i32 0, i64 16)
  store ptr %arr2, ptr %sy, align 8
  %sx4 = load ptr, ptr %sx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %sx4, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data5 = getelementptr i8, ptr %sx4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data5, i64 0
  store i32 0, ptr %arr.elem, align 4
  %sy6 = load ptr, ptr %sy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len7 = load i64, ptr %sy6, align 8
  %arr.oob8 = icmp uge i64 0, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 0, ptr @.failb.3, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %sy6, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 0
  store i32 0, ptr %arr.elem12, align 4
  %sx13 = load ptr, ptr %sx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len14 = load i64, ptr %sx13, align 8
  %arr.oob15 = icmp uge i64 1, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad16:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 1, ptr @.failb.6, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok10
  %arr.data18 = getelementptr i8, ptr %sx13, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 1
  store i32 4, ptr %arr.elem19, align 4
  %sy20 = load ptr, ptr %sy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len21 = load i64, ptr %sy20, align 8
  %arr.oob22 = icmp uge i64 1, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

idx.bad23:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 1, ptr @.failb.9, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok17
  %arr.data25 = getelementptr i8, ptr %sy20, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 1
  store i32 0, ptr %arr.elem26, align 4
  %sx27 = load ptr, ptr %sx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len28 = load i64, ptr %sx27, align 8
  %arr.oob29 = icmp uge i64 2, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 2, ptr @.failb.12, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok24
  %arr.data32 = getelementptr i8, ptr %sx27, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 2
  store i32 4, ptr %arr.elem33, align 4
  %sy34 = load ptr, ptr %sy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len35 = load i64, ptr %sy34, align 8
  %arr.oob36 = icmp uge i64 2, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !2

idx.bad37:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 2, ptr @.failb.15, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %idx.ok31
  %arr.data39 = getelementptr i8, ptr %sy34, i64 8
  %arr.elem40 = getelementptr inbounds i32, ptr %arr.data39, i64 2
  store i32 4, ptr %arr.elem40, align 4
  %sx41 = load ptr, ptr %sx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len42 = load i64, ptr %sx41, align 8
  %arr.oob43 = icmp uge i64 3, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !2

idx.bad44:                                        ; preds = %idx.ok38
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 3, ptr @.failb.18, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok38
  %arr.data46 = getelementptr i8, ptr %sx41, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 3
  store i32 0, ptr %arr.elem47, align 4
  %sy48 = load ptr, ptr %sy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len49 = load i64, ptr %sy48, align 8
  %arr.oob50 = icmp uge i64 3, %arr.len49
  br i1 %arr.oob50, label %idx.bad51, label %idx.ok52, !prof !2

idx.bad51:                                        ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 3, ptr @.failb.21, i64 %arr.len49, i32 70)
  unreachable

idx.ok52:                                         ; preds = %idx.ok45
  %arr.data53 = getelementptr i8, ptr %sy48, i64 8
  %arr.elem54 = getelementptr inbounds i32, ptr %arr.data53, i64 3
  store i32 4, ptr %arr.elem54, align 4
  %sx55 = load ptr, ptr %sx, align 8
  %sy56 = load ptr, ptr %sy, align 8
  %18 = call i32 @Polygon.area2(ptr %sx55, ptr %sy56, i32 4)
  %sx57 = load ptr, ptr %sx, align 8
  %sy58 = load ptr, ptr %sy, align 8
  %19 = call i32 @Polygon.contains(ptr %sx57, ptr %sy58, i32 4, i32 2, i32 2)
  %sx59 = load ptr, ptr %sx, align 8
  %sy60 = load ptr, ptr %sy, align 8
  %20 = call i32 @Polygon.contains(ptr %sx59, ptr %sy60, i32 4, i32 5, i32 5)
  %21 = call i32 (ptr, ...) @printf(ptr @.str, i32 %18, i32 %19, i32 %20)
  %arr61 = call ptr @__polaron_malloc(i64 32)
  store i64 6, ptr %arr61, align 8
  %arr.data62 = getelementptr i8, ptr %arr61, i64 8
  %22 = call ptr @memset(ptr %arr.data62, i32 0, i64 24)
  store ptr %arr61, ptr %hx, align 8
  %arr63 = call ptr @__polaron_malloc(i64 32)
  store i64 6, ptr %arr63, align 8
  %arr.data64 = getelementptr i8, ptr %arr63, i64 8
  %23 = call ptr @memset(ptr %arr.data64, i32 0, i64 24)
  store ptr %arr63, ptr %hy, align 8
  %hx65 = load ptr, ptr %hx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len66 = load i64, ptr %hx65, align 8
  %arr.oob67 = icmp uge i64 0, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !2

idx.bad68:                                        ; preds = %idx.ok52
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 0, ptr @.failb.24, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %idx.ok52
  %arr.data70 = getelementptr i8, ptr %hx65, i64 8
  %arr.elem71 = getelementptr inbounds i32, ptr %arr.data70, i64 0
  store i32 0, ptr %arr.elem71, align 4
  %hy72 = load ptr, ptr %hy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len73 = load i64, ptr %hy72, align 8
  %arr.oob74 = icmp uge i64 0, %arr.len73
  br i1 %arr.oob74, label %idx.bad75, label %idx.ok76, !prof !2

idx.bad75:                                        ; preds = %idx.ok69
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 0, ptr @.failb.27, i64 %arr.len73, i32 70)
  unreachable

idx.ok76:                                         ; preds = %idx.ok69
  %arr.data77 = getelementptr i8, ptr %hy72, i64 8
  %arr.elem78 = getelementptr inbounds i32, ptr %arr.data77, i64 0
  store i32 0, ptr %arr.elem78, align 4
  %hx79 = load ptr, ptr %hx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len80 = load i64, ptr %hx79, align 8
  %arr.oob81 = icmp uge i64 1, %arr.len80
  br i1 %arr.oob81, label %idx.bad82, label %idx.ok83, !prof !2

idx.bad82:                                        ; preds = %idx.ok76
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 1, ptr @.failb.30, i64 %arr.len80, i32 70)
  unreachable

idx.ok83:                                         ; preds = %idx.ok76
  %arr.data84 = getelementptr i8, ptr %hx79, i64 8
  %arr.elem85 = getelementptr inbounds i32, ptr %arr.data84, i64 1
  store i32 4, ptr %arr.elem85, align 4
  %hy86 = load ptr, ptr %hy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len87 = load i64, ptr %hy86, align 8
  %arr.oob88 = icmp uge i64 1, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !2

idx.bad89:                                        ; preds = %idx.ok83
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 1, ptr @.failb.33, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok83
  %arr.data91 = getelementptr i8, ptr %hy86, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 1
  store i32 0, ptr %arr.elem92, align 4
  %hx93 = load ptr, ptr %hx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len94 = load i64, ptr %hx93, align 8
  %arr.oob95 = icmp uge i64 2, %arr.len94
  br i1 %arr.oob95, label %idx.bad96, label %idx.ok97, !prof !2

idx.bad96:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 2, ptr @.failb.36, i64 %arr.len94, i32 70)
  unreachable

idx.ok97:                                         ; preds = %idx.ok90
  %arr.data98 = getelementptr i8, ptr %hx93, i64 8
  %arr.elem99 = getelementptr inbounds i32, ptr %arr.data98, i64 2
  store i32 4, ptr %arr.elem99, align 4
  %hy100 = load ptr, ptr %hy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len101 = load i64, ptr %hy100, align 8
  %arr.oob102 = icmp uge i64 2, %arr.len101
  br i1 %arr.oob102, label %idx.bad103, label %idx.ok104, !prof !2

idx.bad103:                                       ; preds = %idx.ok97
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 2, ptr @.failb.39, i64 %arr.len101, i32 70)
  unreachable

idx.ok104:                                        ; preds = %idx.ok97
  %arr.data105 = getelementptr i8, ptr %hy100, i64 8
  %arr.elem106 = getelementptr inbounds i32, ptr %arr.data105, i64 2
  store i32 4, ptr %arr.elem106, align 4
  %hx107 = load ptr, ptr %hx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len108 = load i64, ptr %hx107, align 8
  %arr.oob109 = icmp uge i64 3, %arr.len108
  br i1 %arr.oob109, label %idx.bad110, label %idx.ok111, !prof !2

idx.bad110:                                       ; preds = %idx.ok104
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 3, ptr @.failb.42, i64 %arr.len108, i32 70)
  unreachable

idx.ok111:                                        ; preds = %idx.ok104
  %arr.data112 = getelementptr i8, ptr %hx107, i64 8
  %arr.elem113 = getelementptr inbounds i32, ptr %arr.data112, i64 3
  store i32 0, ptr %arr.elem113, align 4
  %hy114 = load ptr, ptr %hy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len115 = load i64, ptr %hy114, align 8
  %arr.oob116 = icmp uge i64 3, %arr.len115
  br i1 %arr.oob116, label %idx.bad117, label %idx.ok118, !prof !2

idx.bad117:                                       ; preds = %idx.ok111
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 3, ptr @.failb.45, i64 %arr.len115, i32 70)
  unreachable

idx.ok118:                                        ; preds = %idx.ok111
  %arr.data119 = getelementptr i8, ptr %hy114, i64 8
  %arr.elem120 = getelementptr inbounds i32, ptr %arr.data119, i64 3
  store i32 4, ptr %arr.elem120, align 4
  %hx121 = load ptr, ptr %hx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len122 = load i64, ptr %hx121, align 8
  %arr.oob123 = icmp uge i64 4, %arr.len122
  br i1 %arr.oob123, label %idx.bad124, label %idx.ok125, !prof !2

idx.bad124:                                       ; preds = %idx.ok118
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 4, ptr @.failb.48, i64 %arr.len122, i32 70)
  unreachable

idx.ok125:                                        ; preds = %idx.ok118
  %arr.data126 = getelementptr i8, ptr %hx121, i64 8
  %arr.elem127 = getelementptr inbounds i32, ptr %arr.data126, i64 4
  store i32 2, ptr %arr.elem127, align 4
  %hy128 = load ptr, ptr %hy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len129 = load i64, ptr %hy128, align 8
  %arr.oob130 = icmp uge i64 4, %arr.len129
  br i1 %arr.oob130, label %idx.bad131, label %idx.ok132, !prof !2

idx.bad131:                                       ; preds = %idx.ok125
  call void @__polaron_fail(ptr @.fail.49, ptr @.faila.50, i64 4, ptr @.failb.51, i64 %arr.len129, i32 70)
  unreachable

idx.ok132:                                        ; preds = %idx.ok125
  %arr.data133 = getelementptr i8, ptr %hy128, i64 8
  %arr.elem134 = getelementptr inbounds i32, ptr %arr.data133, i64 4
  store i32 2, ptr %arr.elem134, align 4
  %hx135 = load ptr, ptr %hx, align 8, !nonnull !0, !dereferenceable !1
  %arr.len136 = load i64, ptr %hx135, align 8
  %arr.oob137 = icmp uge i64 5, %arr.len136
  br i1 %arr.oob137, label %idx.bad138, label %idx.ok139, !prof !2

idx.bad138:                                       ; preds = %idx.ok132
  call void @__polaron_fail(ptr @.fail.52, ptr @.faila.53, i64 5, ptr @.failb.54, i64 %arr.len136, i32 70)
  unreachable

idx.ok139:                                        ; preds = %idx.ok132
  %arr.data140 = getelementptr i8, ptr %hx135, i64 8
  %arr.elem141 = getelementptr inbounds i32, ptr %arr.data140, i64 5
  store i32 1, ptr %arr.elem141, align 4
  %hy142 = load ptr, ptr %hy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len143 = load i64, ptr %hy142, align 8
  %arr.oob144 = icmp uge i64 5, %arr.len143
  br i1 %arr.oob144, label %idx.bad145, label %idx.ok146, !prof !2

idx.bad145:                                       ; preds = %idx.ok139
  call void @__polaron_fail(ptr @.fail.55, ptr @.faila.56, i64 5, ptr @.failb.57, i64 %arr.len143, i32 70)
  unreachable

idx.ok146:                                        ; preds = %idx.ok139
  %arr.data147 = getelementptr i8, ptr %hy142, i64 8
  %arr.elem148 = getelementptr inbounds i32, ptr %arr.data147, i64 5
  store i32 1, ptr %arr.elem148, align 4
  %hx149 = load ptr, ptr %hx, align 8
  %hy150 = load ptr, ptr %hy, align 8
  %24 = call i32 @ConvexHull.size(ptr %hx149, ptr %hy150, i32 6)
  %25 = call i32 (ptr, ...) @printf(ptr @.str.58, i32 %24)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1366)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1368)
  ret ptr %strcpy
}

define internal i32 @Polygon.area2(ptr %0, ptr %1, i32 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %j = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  %n = alloca i32, align 4
  %ys = alloca ptr, align 8
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  store ptr %1, ptr %ys, align 8
  store i32 %2, ptr %n, align 4
  store i32 0, ptr %s, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %i1, %n2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i3 = load i32, ptr %i, align 4
  %5 = add i32 %i3, 1
  %n4 = load i32, ptr %n, align 4
  %6 = icmp eq i32 %n4, 0
  %7 = icmp eq i32 %5, -2147483648
  %8 = icmp eq i32 %n4, -1
  %9 = and i1 %7, %8
  %10 = or i1 %6, %9
  br i1 %10, label %div.bad, label %div.ok

for.update:                                       ; preds = %idx.ok31
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s35 = load i32, ptr %s, align 4
  %13 = icmp slt i32 %s35, 0
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

div.bad:                                          ; preds = %for.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.body
  %15 = srem i32 %5, %n4
  store i32 %15, ptr %j, align 4
  %s5 = load i32, ptr %s, align 4
  %xs6 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %16 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %xs6, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.3558, ptr @.faila.3559, i64 %16, ptr @.failb.3560, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %xs6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %16
  %elem = load i32, ptr %arr.elem, align 4
  %ys8 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %j9 = load i32, ptr %j, align 4
  %17 = sext i32 %j9 to i64
  %arr.len10 = load i64, ptr %ys8, align 8
  %arr.oob11 = icmp uge i64 %17, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !2

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3561, ptr @.faila.3562, i64 %17, ptr @.failb.3563, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %ys8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %17
  %elem16 = load i32, ptr %arr.elem15, align 4
  %18 = mul i32 %elem, %elem16
  %19 = add i32 %s5, %18
  %xs17 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %j18 = load i32, ptr %j, align 4
  %20 = sext i32 %j18 to i64
  %arr.len19 = load i64, ptr %xs17, align 8
  %arr.oob20 = icmp uge i64 %20, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok13
  call void @__polaron_fail(ptr @.fail.3564, ptr @.faila.3565, i64 %20, ptr @.failb.3566, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok13
  %arr.data23 = getelementptr i8, ptr %xs17, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %20
  %elem25 = load i32, ptr %arr.elem24, align 4
  %ys26 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %21 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %ys26, align 8
  %arr.oob29 = icmp uge i64 %21, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.3567, ptr @.faila.3568, i64 %21, ptr @.failb.3569, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok22
  %arr.data32 = getelementptr i8, ptr %ys26, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %21
  %elem34 = load i32, ptr %arr.elem33, align 4
  %22 = mul i32 %elem25, %elem34
  %23 = sub i32 %19, %22
  store i32 %23, ptr %s, align 4
  br label %for.update

if.then:                                          ; preds = %for.end
  %s36 = load i32, ptr %s, align 4
  %24 = sub i32 0, %s36
  store i32 %24, ptr %s, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end
  %s37 = load i32, ptr %s, align 4
  ret i32 %s37
}

define internal i32 @Polygon.contains(ptr %0, ptr %1, i32 %2, i32 %3, i32 %4) {
entry:
  %rhs = alloca i32, align 4
  %lhs = alloca i32, align 4
  %dy = alloca i32, align 4
  %dx = alloca i32, align 4
  %straddles = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %inside = alloca i32, align 4
  %py = alloca i32, align 4
  %px = alloca i32, align 4
  %n = alloca i32, align 4
  %ys = alloca ptr, align 8
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  store ptr %1, ptr %ys, align 8
  store i32 %2, ptr %n, align 4
  store i32 %3, ptr %px, align 4
  store i32 %4, ptr %py, align 4
  store i32 0, ptr %inside, align 4
  %n1 = load i32, ptr %n, align 4
  %5 = sub i32 %n1, 1
  store i32 %5, ptr %j, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %n3 = load i32, ptr %n, align 4
  %6 = icmp slt i32 %i2, %n3
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %ys4 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %8 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %ys4, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %inside90 = load i32, ptr %inside, align 4
  ret i32 %inside90

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3570, ptr @.faila.3571, i64 %8, ptr @.failb.3572, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %ys4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %elem = load i32, ptr %arr.elem, align 4
  %py6 = load i32, ptr %py, align 4
  %11 = icmp sgt i32 %elem, %py6
  %12 = zext i1 %11 to i32
  %ys7 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %j8 = load i32, ptr %j, align 4
  %13 = sext i32 %j8 to i64
  %arr.len9 = load i64, ptr %ys7, align 8
  %arr.oob10 = icmp uge i64 %13, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

idx.bad11:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3573, ptr @.faila.3574, i64 %13, ptr @.failb.3575, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %idx.ok
  %arr.data13 = getelementptr i8, ptr %ys7, i64 8
  %arr.elem14 = getelementptr inbounds i32, ptr %arr.data13, i64 %13
  %elem15 = load i32, ptr %arr.elem14, align 4
  %py16 = load i32, ptr %py, align 4
  %14 = icmp sgt i32 %elem15, %py16
  %15 = zext i1 %14 to i32
  %16 = icmp ne i32 %12, %15
  %17 = zext i1 %16 to i32
  store i32 %17, ptr %straddles, align 4
  %straddles17 = load i32, ptr %straddles, align 4
  %18 = icmp ne i32 %straddles17, 0
  br i1 %18, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok12
  %xs18 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %j19 = load i32, ptr %j, align 4
  %19 = sext i32 %j19 to i64
  %arr.len20 = load i64, ptr %xs18, align 8
  %arr.oob21 = icmp uge i64 %19, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

if.end:                                           ; preds = %if.end78, %idx.ok12
  %i89 = load i32, ptr %i, align 4
  store i32 %i89, ptr %j, align 4
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3576, ptr @.faila.3577, i64 %19, ptr @.failb.3578, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %xs18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %19
  %elem26 = load i32, ptr %arr.elem25, align 4
  %xs27 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i28 = load i32, ptr %i, align 4
  %20 = sext i32 %i28 to i64
  %arr.len29 = load i64, ptr %xs27, align 8
  %arr.oob30 = icmp uge i64 %20, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !2

idx.bad31:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.3579, ptr @.faila.3580, i64 %20, ptr @.failb.3581, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok23
  %arr.data33 = getelementptr i8, ptr %xs27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %20
  %elem35 = load i32, ptr %arr.elem34, align 4
  %21 = sub i32 %elem26, %elem35
  store i32 %21, ptr %dx, align 4
  %ys36 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %j37 = load i32, ptr %j, align 4
  %22 = sext i32 %j37 to i64
  %arr.len38 = load i64, ptr %ys36, align 8
  %arr.oob39 = icmp uge i64 %22, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !2

idx.bad40:                                        ; preds = %idx.ok32
  call void @__polaron_fail(ptr @.fail.3582, ptr @.faila.3583, i64 %22, ptr @.failb.3584, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %idx.ok32
  %arr.data42 = getelementptr i8, ptr %ys36, i64 8
  %arr.elem43 = getelementptr inbounds i32, ptr %arr.data42, i64 %22
  %elem44 = load i32, ptr %arr.elem43, align 4
  %ys45 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %i46 = load i32, ptr %i, align 4
  %23 = sext i32 %i46 to i64
  %arr.len47 = load i64, ptr %ys45, align 8
  %arr.oob48 = icmp uge i64 %23, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

idx.bad49:                                        ; preds = %idx.ok41
  call void @__polaron_fail(ptr @.fail.3585, ptr @.faila.3586, i64 %23, ptr @.failb.3587, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %idx.ok41
  %arr.data51 = getelementptr i8, ptr %ys45, i64 8
  %arr.elem52 = getelementptr inbounds i32, ptr %arr.data51, i64 %23
  %elem53 = load i32, ptr %arr.elem52, align 4
  %24 = sub i32 %elem44, %elem53
  store i32 %24, ptr %dy, align 4
  %px54 = load i32, ptr %px, align 4
  %xs55 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i56 = load i32, ptr %i, align 4
  %25 = sext i32 %i56 to i64
  %arr.len57 = load i64, ptr %xs55, align 8
  %arr.oob58 = icmp uge i64 %25, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

idx.bad59:                                        ; preds = %idx.ok50
  call void @__polaron_fail(ptr @.fail.3588, ptr @.faila.3589, i64 %25, ptr @.failb.3590, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok50
  %arr.data61 = getelementptr i8, ptr %xs55, i64 8
  %arr.elem62 = getelementptr inbounds i32, ptr %arr.data61, i64 %25
  %elem63 = load i32, ptr %arr.elem62, align 4
  %26 = sub i32 %px54, %elem63
  %dy64 = load i32, ptr %dy, align 4
  %27 = mul i32 %26, %dy64
  store i32 %27, ptr %lhs, align 4
  %dx65 = load i32, ptr %dx, align 4
  %py66 = load i32, ptr %py, align 4
  %ys67 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %i68 = load i32, ptr %i, align 4
  %28 = sext i32 %i68 to i64
  %arr.len69 = load i64, ptr %ys67, align 8
  %arr.oob70 = icmp uge i64 %28, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !2

idx.bad71:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.3591, ptr @.faila.3592, i64 %28, ptr @.failb.3593, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok60
  %arr.data73 = getelementptr i8, ptr %ys67, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %28
  %elem75 = load i32, ptr %arr.elem74, align 4
  %29 = sub i32 %py66, %elem75
  %30 = mul i32 %dx65, %29
  store i32 %30, ptr %rhs, align 4
  %dy76 = load i32, ptr %dy, align 4
  %31 = icmp sgt i32 %dy76, 0
  %32 = zext i1 %31 to i32
  br i1 %31, label %if.then77, label %if.else

if.then77:                                        ; preds = %idx.ok72
  %lhs79 = load i32, ptr %lhs, align 4
  %rhs80 = load i32, ptr %rhs, align 4
  %33 = icmp slt i32 %lhs79, %rhs80
  %34 = zext i1 %33 to i32
  br i1 %33, label %if.then81, label %if.end82

if.else:                                          ; preds = %idx.ok72
  %lhs84 = load i32, ptr %lhs, align 4
  %rhs85 = load i32, ptr %rhs, align 4
  %35 = icmp sgt i32 %lhs84, %rhs85
  %36 = zext i1 %35 to i32
  br i1 %35, label %if.then86, label %if.end87

if.end78:                                         ; preds = %if.end87, %if.end82
  br label %if.end

if.then81:                                        ; preds = %if.then77
  %inside83 = load i32, ptr %inside, align 4
  %37 = icmp eq i32 %inside83, 0
  %38 = zext i1 %37 to i32
  store i32 %38, ptr %inside, align 4
  br label %if.end82

if.end82:                                         ; preds = %if.then81, %if.then77
  br label %if.end78

if.then86:                                        ; preds = %if.else
  %inside88 = load i32, ptr %inside, align 4
  %39 = icmp eq i32 %inside88, 0
  %40 = zext i1 %39 to i32
  store i32 %40, ptr %inside, align 4
  br label %if.end87

if.end87:                                         ; preds = %if.then86, %if.else
  br label %if.end78
}

define internal i32 @ConvexHull.cross(ptr %0, ptr %1, i32 %2, i32 %3, i32 %4) {
entry:
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %o = alloca i32, align 4
  %ys = alloca ptr, align 8
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  store ptr %1, ptr %ys, align 8
  store i32 %2, ptr %o, align 4
  store i32 %3, ptr %a, align 4
  store i32 %4, ptr %b, align 4
  %xs1 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %a2 = load i32, ptr %a, align 4
  %5 = sext i32 %a2 to i64
  %arr.len = load i64, ptr %xs1, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3594, ptr @.faila.3595, i64 %5, ptr @.failb.3596, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %xs1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  %xs3 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %o4 = load i32, ptr %o, align 4
  %6 = sext i32 %o4 to i64
  %arr.len5 = load i64, ptr %xs3, align 8
  %arr.oob6 = icmp uge i64 %6, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3597, ptr @.faila.3598, i64 %6, ptr @.failb.3599, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %xs3, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 %6
  %elem11 = load i32, ptr %arr.elem10, align 4
  %7 = sub i32 %elem, %elem11
  %ys12 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %b13 = load i32, ptr %b, align 4
  %8 = sext i32 %b13 to i64
  %arr.len14 = load i64, ptr %ys12, align 8
  %arr.oob15 = icmp uge i64 %8, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad16:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.3600, ptr @.faila.3601, i64 %8, ptr @.failb.3602, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok8
  %arr.data18 = getelementptr i8, ptr %ys12, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 %8
  %elem20 = load i32, ptr %arr.elem19, align 4
  %ys21 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %o22 = load i32, ptr %o, align 4
  %9 = sext i32 %o22 to i64
  %arr.len23 = load i64, ptr %ys21, align 8
  %arr.oob24 = icmp uge i64 %9, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !2

idx.bad25:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.3603, ptr @.faila.3604, i64 %9, ptr @.failb.3605, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok17
  %arr.data27 = getelementptr i8, ptr %ys21, i64 8
  %arr.elem28 = getelementptr inbounds i32, ptr %arr.data27, i64 %9
  %elem29 = load i32, ptr %arr.elem28, align 4
  %10 = sub i32 %elem20, %elem29
  %11 = mul i32 %7, %10
  %ys30 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %a31 = load i32, ptr %a, align 4
  %12 = sext i32 %a31 to i64
  %arr.len32 = load i64, ptr %ys30, align 8
  %arr.oob33 = icmp uge i64 %12, %arr.len32
  br i1 %arr.oob33, label %idx.bad34, label %idx.ok35, !prof !2

idx.bad34:                                        ; preds = %idx.ok26
  call void @__polaron_fail(ptr @.fail.3606, ptr @.faila.3607, i64 %12, ptr @.failb.3608, i64 %arr.len32, i32 70)
  unreachable

idx.ok35:                                         ; preds = %idx.ok26
  %arr.data36 = getelementptr i8, ptr %ys30, i64 8
  %arr.elem37 = getelementptr inbounds i32, ptr %arr.data36, i64 %12
  %elem38 = load i32, ptr %arr.elem37, align 4
  %ys39 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %o40 = load i32, ptr %o, align 4
  %13 = sext i32 %o40 to i64
  %arr.len41 = load i64, ptr %ys39, align 8
  %arr.oob42 = icmp uge i64 %13, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !2

idx.bad43:                                        ; preds = %idx.ok35
  call void @__polaron_fail(ptr @.fail.3609, ptr @.faila.3610, i64 %13, ptr @.failb.3611, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %idx.ok35
  %arr.data45 = getelementptr i8, ptr %ys39, i64 8
  %arr.elem46 = getelementptr inbounds i32, ptr %arr.data45, i64 %13
  %elem47 = load i32, ptr %arr.elem46, align 4
  %14 = sub i32 %elem38, %elem47
  %xs48 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %b49 = load i32, ptr %b, align 4
  %15 = sext i32 %b49 to i64
  %arr.len50 = load i64, ptr %xs48, align 8
  %arr.oob51 = icmp uge i64 %15, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !2

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.3612, ptr @.faila.3613, i64 %15, ptr @.failb.3614, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %xs48, i64 8
  %arr.elem55 = getelementptr inbounds i32, ptr %arr.data54, i64 %15
  %elem56 = load i32, ptr %arr.elem55, align 4
  %xs57 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %o58 = load i32, ptr %o, align 4
  %16 = sext i32 %o58 to i64
  %arr.len59 = load i64, ptr %xs57, align 8
  %arr.oob60 = icmp uge i64 %16, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !2

idx.bad61:                                        ; preds = %idx.ok53
  call void @__polaron_fail(ptr @.fail.3615, ptr @.faila.3616, i64 %16, ptr @.failb.3617, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %idx.ok53
  %arr.data63 = getelementptr i8, ptr %xs57, i64 8
  %arr.elem64 = getelementptr inbounds i32, ptr %arr.data63, i64 %16
  %elem65 = load i32, ptr %arr.elem64, align 4
  %17 = sub i32 %elem56, %elem65
  %18 = mul i32 %14, %17
  %19 = sub i32 %11, %18
  ret i32 %19
}

define internal i32 @ConvexHull.size(ptr %0, ptr %1, i32 %2) {
entry:
  %p218 = alloca i32, align 4
  %t203 = alloca i32, align 4
  %lower = alloca i32, align 4
  %p = alloca i32, align 4
  %t = alloca i32, align 4
  %k = alloca i32, align 4
  %hull = alloca ptr, align 8
  %j = alloca i32, align 4
  %key = alloca i32, align 4
  %i10 = alloca i32, align 4
  %i = alloca i32, align 4
  %idx = alloca ptr, align 8
  %n = alloca i32, align 4
  %ys = alloca ptr, align 8
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  store ptr %1, ptr %ys, align 8
  store i32 %2, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %n1, 3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %n2 = load i32, ptr %n, align 4
  ret i32 %n2

if.end:                                           ; preds = %entry
  %n3 = load i32, ptr %n, align 4
  %5 = sext i32 %n3 to i64
  %6 = mul i64 %5, 4
  %7 = add i64 8, %6
  %arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %8 = call ptr @memset(ptr %arr.data, i32 0, i64 %6)
  store ptr %arr, ptr %idx, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %9 = icmp slt i32 %i4, %n5
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idx6 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %11 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %idx6, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %i10, align 4
  br label %for.cond11

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3618, ptr @.faila.3619, i64 %11, ptr @.failb.3620, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %idx6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data8, i64 %11
  %i9 = load i32, ptr %i, align 4
  store i32 %i9, ptr %arr.elem, align 4
  br label %for.update

for.cond11:                                       ; preds = %for.update13, %for.end
  %i15 = load i32, ptr %i10, align 4
  %n16 = load i32, ptr %n, align 4
  %14 = icmp slt i32 %i15, %n16
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body12, label %for.end14

for.body12:                                       ; preds = %for.cond11
  %idx17 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %i18 = load i32, ptr %i10, align 4
  %16 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %idx17, align 8
  %arr.oob20 = icmp uge i64 %16, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

for.update13:                                     ; preds = %idx.ok138
  %17 = load i32, ptr %i10, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i10, align 4
  br label %for.cond11

for.end14:                                        ; preds = %for.cond11
  %n142 = load i32, ptr %n, align 4
  %19 = mul i32 2, %n142
  %20 = sext i32 %19 to i64
  %21 = mul i64 %20, 4
  %22 = add i64 8, %21
  %arr143 = call ptr @__polaron_malloc(i64 %22)
  store i64 %20, ptr %arr143, align 8
  %arr.data144 = getelementptr i8, ptr %arr143, i64 8
  %23 = call ptr @memset(ptr %arr.data144, i32 0, i64 %21)
  store ptr %arr143, ptr %hull, align 8
  store i32 0, ptr %k, align 4
  store i32 0, ptr %t, align 4
  br label %for.cond145

idx.bad21:                                        ; preds = %for.body12
  call void @__polaron_fail(ptr @.fail.3621, ptr @.faila.3622, i64 %16, ptr @.failb.3623, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %for.body12
  %arr.data23 = getelementptr i8, ptr %idx17, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %16
  %elem = load i32, ptr %arr.elem24, align 4
  store i32 %elem, ptr %key, align 4
  %i25 = load i32, ptr %i10, align 4
  %24 = sub i32 %i25, 1
  store i32 %24, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok128, %idx.ok22
  %j26 = load i32, ptr %j, align 4
  %25 = icmp sge i32 %j26, 0
  %26 = zext i1 %25 to i32
  %sc.a = icmp ne i32 %26, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %idx115 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %j116 = load i32, ptr %j, align 4
  %27 = add i32 %j116, 1
  %28 = sext i32 %27 to i64
  %arr.len117 = load i64, ptr %idx115, align 8
  %arr.oob118 = icmp uge i64 %28, %arr.len117
  br i1 %arr.oob118, label %idx.bad119, label %idx.ok120, !prof !2

while.end:                                        ; preds = %sc.end
  %idx133 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %j134 = load i32, ptr %j, align 4
  %29 = add i32 %j134, 1
  %30 = sext i32 %29 to i64
  %arr.len135 = load i64, ptr %idx133, align 8
  %arr.oob136 = icmp uge i64 %30, %arr.len135
  br i1 %arr.oob136, label %idx.bad137, label %idx.ok138, !prof !2

sc.rhs:                                           ; preds = %while.cond
  %xs27 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %idx28 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %j29 = load i32, ptr %j, align 4
  %31 = sext i32 %j29 to i64
  %arr.len30 = load i64, ptr %idx28, align 8
  %arr.oob31 = icmp uge i64 %31, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

sc.end:                                           ; preds = %sc.end55, %while.cond
  %sc114 = phi i1 [ false, %while.cond ], [ %sc.b113, %sc.end55 ]
  %32 = zext i1 %sc114 to i32
  br i1 %sc114, label %while.body, label %while.end

idx.bad32:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3624, ptr @.faila.3625, i64 %31, ptr @.failb.3626, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %sc.rhs
  %arr.data34 = getelementptr i8, ptr %idx28, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %31
  %elem36 = load i32, ptr %arr.elem35, align 4
  %33 = sext i32 %elem36 to i64
  %arr.len37 = load i64, ptr %xs27, align 8
  %arr.oob38 = icmp uge i64 %33, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad39:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.3627, ptr @.faila.3628, i64 %33, ptr @.failb.3629, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok33
  %arr.data41 = getelementptr i8, ptr %xs27, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %33
  %elem43 = load i32, ptr %arr.elem42, align 4
  %xs44 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %key45 = load i32, ptr %key, align 4
  %34 = sext i32 %key45 to i64
  %arr.len46 = load i64, ptr %xs44, align 8
  %arr.oob47 = icmp uge i64 %34, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

idx.bad48:                                        ; preds = %idx.ok40
  call void @__polaron_fail(ptr @.fail.3630, ptr @.faila.3631, i64 %34, ptr @.failb.3632, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %idx.ok40
  %arr.data50 = getelementptr i8, ptr %xs44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %34
  %elem52 = load i32, ptr %arr.elem51, align 4
  %35 = icmp sgt i32 %elem43, %elem52
  %36 = zext i1 %35 to i32
  %sc.a53 = icmp ne i32 %36, 0
  br i1 %sc.a53, label %sc.end55, label %sc.rhs54

sc.rhs54:                                         ; preds = %idx.ok49
  %xs56 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %idx57 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %j58 = load i32, ptr %j, align 4
  %37 = sext i32 %j58 to i64
  %arr.len59 = load i64, ptr %idx57, align 8
  %arr.oob60 = icmp uge i64 %37, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !2

sc.end55:                                         ; preds = %sc.end84, %idx.ok49
  %sc112 = phi i1 [ true, %idx.ok49 ], [ %sc.b111, %sc.end84 ]
  %38 = zext i1 %sc112 to i32
  %sc.b113 = icmp ne i32 %38, 0
  br label %sc.end

idx.bad61:                                        ; preds = %sc.rhs54
  call void @__polaron_fail(ptr @.fail.3633, ptr @.faila.3634, i64 %37, ptr @.failb.3635, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %sc.rhs54
  %arr.data63 = getelementptr i8, ptr %idx57, i64 8
  %arr.elem64 = getelementptr inbounds i32, ptr %arr.data63, i64 %37
  %elem65 = load i32, ptr %arr.elem64, align 4
  %39 = sext i32 %elem65 to i64
  %arr.len66 = load i64, ptr %xs56, align 8
  %arr.oob67 = icmp uge i64 %39, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !2

idx.bad68:                                        ; preds = %idx.ok62
  call void @__polaron_fail(ptr @.fail.3636, ptr @.faila.3637, i64 %39, ptr @.failb.3638, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %idx.ok62
  %arr.data70 = getelementptr i8, ptr %xs56, i64 8
  %arr.elem71 = getelementptr inbounds i32, ptr %arr.data70, i64 %39
  %elem72 = load i32, ptr %arr.elem71, align 4
  %xs73 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %key74 = load i32, ptr %key, align 4
  %40 = sext i32 %key74 to i64
  %arr.len75 = load i64, ptr %xs73, align 8
  %arr.oob76 = icmp uge i64 %40, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !2

idx.bad77:                                        ; preds = %idx.ok69
  call void @__polaron_fail(ptr @.fail.3639, ptr @.faila.3640, i64 %40, ptr @.failb.3641, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %idx.ok69
  %arr.data79 = getelementptr i8, ptr %xs73, i64 8
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data79, i64 %40
  %elem81 = load i32, ptr %arr.elem80, align 4
  %41 = icmp eq i32 %elem72, %elem81
  %42 = zext i1 %41 to i32
  %sc.a82 = icmp ne i32 %42, 0
  br i1 %sc.a82, label %sc.rhs83, label %sc.end84

sc.rhs83:                                         ; preds = %idx.ok78
  %ys85 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %idx86 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %j87 = load i32, ptr %j, align 4
  %43 = sext i32 %j87 to i64
  %arr.len88 = load i64, ptr %idx86, align 8
  %arr.oob89 = icmp uge i64 %43, %arr.len88
  br i1 %arr.oob89, label %idx.bad90, label %idx.ok91, !prof !2

sc.end84:                                         ; preds = %idx.ok107, %idx.ok78
  %sc = phi i1 [ false, %idx.ok78 ], [ %sc.b, %idx.ok107 ]
  %44 = zext i1 %sc to i32
  %sc.b111 = icmp ne i32 %44, 0
  br label %sc.end55

idx.bad90:                                        ; preds = %sc.rhs83
  call void @__polaron_fail(ptr @.fail.3642, ptr @.faila.3643, i64 %43, ptr @.failb.3644, i64 %arr.len88, i32 70)
  unreachable

idx.ok91:                                         ; preds = %sc.rhs83
  %arr.data92 = getelementptr i8, ptr %idx86, i64 8
  %arr.elem93 = getelementptr inbounds i32, ptr %arr.data92, i64 %43
  %elem94 = load i32, ptr %arr.elem93, align 4
  %45 = sext i32 %elem94 to i64
  %arr.len95 = load i64, ptr %ys85, align 8
  %arr.oob96 = icmp uge i64 %45, %arr.len95
  br i1 %arr.oob96, label %idx.bad97, label %idx.ok98, !prof !2

idx.bad97:                                        ; preds = %idx.ok91
  call void @__polaron_fail(ptr @.fail.3645, ptr @.faila.3646, i64 %45, ptr @.failb.3647, i64 %arr.len95, i32 70)
  unreachable

idx.ok98:                                         ; preds = %idx.ok91
  %arr.data99 = getelementptr i8, ptr %ys85, i64 8
  %arr.elem100 = getelementptr inbounds i32, ptr %arr.data99, i64 %45
  %elem101 = load i32, ptr %arr.elem100, align 4
  %ys102 = load ptr, ptr %ys, align 8, !nonnull !0, !dereferenceable !1
  %key103 = load i32, ptr %key, align 4
  %46 = sext i32 %key103 to i64
  %arr.len104 = load i64, ptr %ys102, align 8
  %arr.oob105 = icmp uge i64 %46, %arr.len104
  br i1 %arr.oob105, label %idx.bad106, label %idx.ok107, !prof !2

idx.bad106:                                       ; preds = %idx.ok98
  call void @__polaron_fail(ptr @.fail.3648, ptr @.faila.3649, i64 %46, ptr @.failb.3650, i64 %arr.len104, i32 70)
  unreachable

idx.ok107:                                        ; preds = %idx.ok98
  %arr.data108 = getelementptr i8, ptr %ys102, i64 8
  %arr.elem109 = getelementptr inbounds i32, ptr %arr.data108, i64 %46
  %elem110 = load i32, ptr %arr.elem109, align 4
  %47 = icmp sgt i32 %elem101, %elem110
  %48 = zext i1 %47 to i32
  %sc.b = icmp ne i32 %48, 0
  br label %sc.end84

idx.bad119:                                       ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.3651, ptr @.faila.3652, i64 %28, ptr @.failb.3653, i64 %arr.len117, i32 70)
  unreachable

idx.ok120:                                        ; preds = %while.body
  %arr.data121 = getelementptr i8, ptr %idx115, i64 8
  %arr.elem122 = getelementptr inbounds i32, ptr %arr.data121, i64 %28
  %idx123 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %j124 = load i32, ptr %j, align 4
  %49 = sext i32 %j124 to i64
  %arr.len125 = load i64, ptr %idx123, align 8
  %arr.oob126 = icmp uge i64 %49, %arr.len125
  br i1 %arr.oob126, label %idx.bad127, label %idx.ok128, !prof !2

idx.bad127:                                       ; preds = %idx.ok120
  call void @__polaron_fail(ptr @.fail.3654, ptr @.faila.3655, i64 %49, ptr @.failb.3656, i64 %arr.len125, i32 70)
  unreachable

idx.ok128:                                        ; preds = %idx.ok120
  %arr.data129 = getelementptr i8, ptr %idx123, i64 8
  %arr.elem130 = getelementptr inbounds i32, ptr %arr.data129, i64 %49
  %elem131 = load i32, ptr %arr.elem130, align 4
  store i32 %elem131, ptr %arr.elem122, align 4
  %j132 = load i32, ptr %j, align 4
  %50 = sub i32 %j132, 1
  store i32 %50, ptr %j, align 4
  br label %while.cond

idx.bad137:                                       ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.3657, ptr @.faila.3658, i64 %30, ptr @.failb.3659, i64 %arr.len135, i32 70)
  unreachable

idx.ok138:                                        ; preds = %while.end
  %arr.data139 = getelementptr i8, ptr %idx133, i64 8
  %arr.elem140 = getelementptr inbounds i32, ptr %arr.data139, i64 %30
  %key141 = load i32, ptr %key, align 4
  store i32 %key141, ptr %arr.elem140, align 4
  br label %for.update13

for.cond145:                                      ; preds = %for.update147, %for.end14
  %t149 = load i32, ptr %t, align 4
  %n150 = load i32, ptr %n, align 4
  %51 = icmp slt i32 %t149, %n150
  %52 = zext i1 %51 to i32
  br i1 %51, label %for.body146, label %for.end148

for.body146:                                      ; preds = %for.cond145
  %idx151 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %t152 = load i32, ptr %t, align 4
  %53 = sext i32 %t152 to i64
  %arr.len153 = load i64, ptr %idx151, align 8
  %arr.oob154 = icmp uge i64 %53, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !2

for.update147:                                    ; preds = %idx.ok196
  %54 = load i32, ptr %t, align 4
  %55 = add i32 %54, 1
  store i32 %55, ptr %t, align 4
  br label %for.cond145

for.end148:                                       ; preds = %for.cond145
  %k201 = load i32, ptr %k, align 4
  %56 = add i32 %k201, 1
  store i32 %56, ptr %lower, align 4
  %n202 = load i32, ptr %n, align 4
  %57 = sub i32 %n202, 2
  store i32 %57, ptr %t203, align 4
  br label %for.cond204

idx.bad155:                                       ; preds = %for.body146
  call void @__polaron_fail(ptr @.fail.3660, ptr @.faila.3661, i64 %53, ptr @.failb.3662, i64 %arr.len153, i32 70)
  unreachable

idx.ok156:                                        ; preds = %for.body146
  %arr.data157 = getelementptr i8, ptr %idx151, i64 8
  %arr.elem158 = getelementptr inbounds i32, ptr %arr.data157, i64 %53
  %elem159 = load i32, ptr %arr.elem158, align 4
  store i32 %elem159, ptr %p, align 4
  br label %while.cond160

while.cond160:                                    ; preds = %while.body161, %idx.ok156
  %k163 = load i32, ptr %k, align 4
  %58 = icmp sge i32 %k163, 2
  %59 = zext i1 %58 to i32
  %sc.a164 = icmp ne i32 %59, 0
  br i1 %sc.a164, label %sc.rhs165, label %sc.end166

while.body161:                                    ; preds = %sc.end166
  %k190 = load i32, ptr %k, align 4
  %60 = sub i32 %k190, 1
  store i32 %60, ptr %k, align 4
  br label %while.cond160

while.end162:                                     ; preds = %sc.end166
  %hull191 = load ptr, ptr %hull, align 8, !nonnull !0, !dereferenceable !1
  %k192 = load i32, ptr %k, align 4
  %61 = sext i32 %k192 to i64
  %arr.len193 = load i64, ptr %hull191, align 8
  %arr.oob194 = icmp uge i64 %61, %arr.len193
  br i1 %arr.oob194, label %idx.bad195, label %idx.ok196, !prof !2

sc.rhs165:                                        ; preds = %while.cond160
  %xs167 = load ptr, ptr %xs, align 8
  %ys168 = load ptr, ptr %ys, align 8
  %hull169 = load ptr, ptr %hull, align 8, !nonnull !0, !dereferenceable !1
  %k170 = load i32, ptr %k, align 4
  %62 = sub i32 %k170, 2
  %63 = sext i32 %62 to i64
  %arr.len171 = load i64, ptr %hull169, align 8
  %arr.oob172 = icmp uge i64 %63, %arr.len171
  br i1 %arr.oob172, label %idx.bad173, label %idx.ok174, !prof !2

sc.end166:                                        ; preds = %idx.ok183, %while.cond160
  %sc189 = phi i1 [ false, %while.cond160 ], [ %sc.b188, %idx.ok183 ]
  %64 = zext i1 %sc189 to i32
  br i1 %sc189, label %while.body161, label %while.end162

idx.bad173:                                       ; preds = %sc.rhs165
  call void @__polaron_fail(ptr @.fail.3663, ptr @.faila.3664, i64 %63, ptr @.failb.3665, i64 %arr.len171, i32 70)
  unreachable

idx.ok174:                                        ; preds = %sc.rhs165
  %arr.data175 = getelementptr i8, ptr %hull169, i64 8
  %arr.elem176 = getelementptr inbounds i32, ptr %arr.data175, i64 %63
  %elem177 = load i32, ptr %arr.elem176, align 4
  %hull178 = load ptr, ptr %hull, align 8, !nonnull !0, !dereferenceable !1
  %k179 = load i32, ptr %k, align 4
  %65 = sub i32 %k179, 1
  %66 = sext i32 %65 to i64
  %arr.len180 = load i64, ptr %hull178, align 8
  %arr.oob181 = icmp uge i64 %66, %arr.len180
  br i1 %arr.oob181, label %idx.bad182, label %idx.ok183, !prof !2

idx.bad182:                                       ; preds = %idx.ok174
  call void @__polaron_fail(ptr @.fail.3666, ptr @.faila.3667, i64 %66, ptr @.failb.3668, i64 %arr.len180, i32 70)
  unreachable

idx.ok183:                                        ; preds = %idx.ok174
  %arr.data184 = getelementptr i8, ptr %hull178, i64 8
  %arr.elem185 = getelementptr inbounds i32, ptr %arr.data184, i64 %66
  %elem186 = load i32, ptr %arr.elem185, align 4
  %p187 = load i32, ptr %p, align 4
  %67 = call i32 @ConvexHull.cross(ptr %xs167, ptr %ys168, i32 %elem177, i32 %elem186, i32 %p187)
  %68 = icmp sle i32 %67, 0
  %69 = zext i1 %68 to i32
  %sc.b188 = icmp ne i32 %69, 0
  br label %sc.end166

idx.bad195:                                       ; preds = %while.end162
  call void @__polaron_fail(ptr @.fail.3669, ptr @.faila.3670, i64 %61, ptr @.failb.3671, i64 %arr.len193, i32 70)
  unreachable

idx.ok196:                                        ; preds = %while.end162
  %arr.data197 = getelementptr i8, ptr %hull191, i64 8
  %arr.elem198 = getelementptr inbounds i32, ptr %arr.data197, i64 %61
  %p199 = load i32, ptr %p, align 4
  store i32 %p199, ptr %arr.elem198, align 4
  %k200 = load i32, ptr %k, align 4
  %70 = add i32 %k200, 1
  store i32 %70, ptr %k, align 4
  br label %for.update147

for.cond204:                                      ; preds = %for.update206, %for.end148
  %t208 = load i32, ptr %t203, align 4
  %71 = icmp sge i32 %t208, 0
  %72 = zext i1 %71 to i32
  br i1 %71, label %for.body205, label %for.end207

for.body205:                                      ; preds = %for.cond204
  %idx209 = load ptr, ptr %idx, align 8, !nonnull !0, !dereferenceable !1
  %t210 = load i32, ptr %t203, align 4
  %73 = sext i32 %t210 to i64
  %arr.len211 = load i64, ptr %idx209, align 8
  %arr.oob212 = icmp uge i64 %73, %arr.len211
  br i1 %arr.oob212, label %idx.bad213, label %idx.ok214, !prof !2

for.update206:                                    ; preds = %idx.ok256
  %t261 = load i32, ptr %t203, align 4
  %74 = sub i32 %t261, 1
  store i32 %74, ptr %t203, align 4
  br label %for.cond204

for.end207:                                       ; preds = %for.cond204
  %k262 = load i32, ptr %k, align 4
  %75 = sub i32 %k262, 1
  ret i32 %75

idx.bad213:                                       ; preds = %for.body205
  call void @__polaron_fail(ptr @.fail.3672, ptr @.faila.3673, i64 %73, ptr @.failb.3674, i64 %arr.len211, i32 70)
  unreachable

idx.ok214:                                        ; preds = %for.body205
  %arr.data215 = getelementptr i8, ptr %idx209, i64 8
  %arr.elem216 = getelementptr inbounds i32, ptr %arr.data215, i64 %73
  %elem217 = load i32, ptr %arr.elem216, align 4
  store i32 %elem217, ptr %p218, align 4
  br label %while.cond219

while.cond219:                                    ; preds = %while.body220, %idx.ok214
  %k222 = load i32, ptr %k, align 4
  %lower223 = load i32, ptr %lower, align 4
  %76 = icmp sge i32 %k222, %lower223
  %77 = zext i1 %76 to i32
  %sc.a224 = icmp ne i32 %77, 0
  br i1 %sc.a224, label %sc.rhs225, label %sc.end226

while.body220:                                    ; preds = %sc.end226
  %k250 = load i32, ptr %k, align 4
  %78 = sub i32 %k250, 1
  store i32 %78, ptr %k, align 4
  br label %while.cond219

while.end221:                                     ; preds = %sc.end226
  %hull251 = load ptr, ptr %hull, align 8, !nonnull !0, !dereferenceable !1
  %k252 = load i32, ptr %k, align 4
  %79 = sext i32 %k252 to i64
  %arr.len253 = load i64, ptr %hull251, align 8
  %arr.oob254 = icmp uge i64 %79, %arr.len253
  br i1 %arr.oob254, label %idx.bad255, label %idx.ok256, !prof !2

sc.rhs225:                                        ; preds = %while.cond219
  %xs227 = load ptr, ptr %xs, align 8
  %ys228 = load ptr, ptr %ys, align 8
  %hull229 = load ptr, ptr %hull, align 8, !nonnull !0, !dereferenceable !1
  %k230 = load i32, ptr %k, align 4
  %80 = sub i32 %k230, 2
  %81 = sext i32 %80 to i64
  %arr.len231 = load i64, ptr %hull229, align 8
  %arr.oob232 = icmp uge i64 %81, %arr.len231
  br i1 %arr.oob232, label %idx.bad233, label %idx.ok234, !prof !2

sc.end226:                                        ; preds = %idx.ok243, %while.cond219
  %sc249 = phi i1 [ false, %while.cond219 ], [ %sc.b248, %idx.ok243 ]
  %82 = zext i1 %sc249 to i32
  br i1 %sc249, label %while.body220, label %while.end221

idx.bad233:                                       ; preds = %sc.rhs225
  call void @__polaron_fail(ptr @.fail.3675, ptr @.faila.3676, i64 %81, ptr @.failb.3677, i64 %arr.len231, i32 70)
  unreachable

idx.ok234:                                        ; preds = %sc.rhs225
  %arr.data235 = getelementptr i8, ptr %hull229, i64 8
  %arr.elem236 = getelementptr inbounds i32, ptr %arr.data235, i64 %81
  %elem237 = load i32, ptr %arr.elem236, align 4
  %hull238 = load ptr, ptr %hull, align 8, !nonnull !0, !dereferenceable !1
  %k239 = load i32, ptr %k, align 4
  %83 = sub i32 %k239, 1
  %84 = sext i32 %83 to i64
  %arr.len240 = load i64, ptr %hull238, align 8
  %arr.oob241 = icmp uge i64 %84, %arr.len240
  br i1 %arr.oob241, label %idx.bad242, label %idx.ok243, !prof !2

idx.bad242:                                       ; preds = %idx.ok234
  call void @__polaron_fail(ptr @.fail.3678, ptr @.faila.3679, i64 %84, ptr @.failb.3680, i64 %arr.len240, i32 70)
  unreachable

idx.ok243:                                        ; preds = %idx.ok234
  %arr.data244 = getelementptr i8, ptr %hull238, i64 8
  %arr.elem245 = getelementptr inbounds i32, ptr %arr.data244, i64 %84
  %elem246 = load i32, ptr %arr.elem245, align 4
  %p247 = load i32, ptr %p218, align 4
  %85 = call i32 @ConvexHull.cross(ptr %xs227, ptr %ys228, i32 %elem237, i32 %elem246, i32 %p247)
  %86 = icmp sle i32 %85, 0
  %87 = zext i1 %86 to i32
  %sc.b248 = icmp ne i32 %87, 0
  br label %sc.end226

idx.bad255:                                       ; preds = %while.end221
  call void @__polaron_fail(ptr @.fail.3681, ptr @.faila.3682, i64 %79, ptr @.failb.3683, i64 %arr.len253, i32 70)
  unreachable

idx.ok256:                                        ; preds = %while.end221
  %arr.data257 = getelementptr i8, ptr %hull251, i64 8
  %arr.elem258 = getelementptr inbounds i32, ptr %arr.data257, i64 %79
  %p259 = load i32, ptr %p218, align 4
  store i32 %p259, ptr %arr.elem258, align 4
  %k260 = load i32, ptr %k, align 4
  %88 = add i32 %k260, 1
  store i32 %88, ptr %k, align 4
  br label %for.update206
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5367)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5369)
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
