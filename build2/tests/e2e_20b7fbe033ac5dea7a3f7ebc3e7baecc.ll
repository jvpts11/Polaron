; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/uuid_semver.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/uuid_semver.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Semver = type { ptr, i32, i32, i32 }
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
@Semver.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Semver.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Semver.getMajor, ptr @Semver.getMinor, ptr @Semver.getPatch, ptr @Semver.compareTo, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [23 x i8] c"uuid=%s valid=%d v=%c\0A\00", align 1
@.strdata = private constant [6 x i8] c"1.2.3\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [8 x i8] c"v1.10.0\00"
@.strobj.2 = private global %String { i64 7, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [11 x i8] c"1.2.3-beta\00"
@.strobj.4 = private global %String { i64 10, ptr @.strdata.3, i64 0 }
@.str.5 = private unnamed_addr constant [26 x i8] c"a=%s cmp_ab=%d cmp_ac=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1311 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1312 = private global %String { i64 16, ptr @.strdata.1311, i64 0 }
@.strdata.1313 = private constant [17 x i8] c"division by zero\00"
@.strobj.1314 = private global %String { i64 16, ptr @.strdata.1313, i64 0 }
@.strdata.2508 = private constant [17 x i8] c"0123456789abcdef\00"
@.strobj.2509 = private global %String { i64 16, ptr @.strdata.2508, i64 0 }
@.fail.2510 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3923:21  in Uuid.format\0A\00", align 1
@.faila.2511 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2512 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2513 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3931:61  in Uuid.v4\0A\00", align 1
@.faila.2514 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2515 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2516 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3931:61  in Uuid.v4\0A\00", align 1
@.faila.2517 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2518 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2519 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3932:22  in Uuid.v4\0A\00", align 1
@.faila.2520 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2521 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2522 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3932:22  in Uuid.v4\0A\00", align 1
@.faila.2523 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2524 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2525 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3933:22  in Uuid.v4\0A\00", align 1
@.faila.2526 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2527 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2528 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3933:22  in Uuid.v4\0A\00", align 1
@.faila.2529 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2530 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2531 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3944:26  in Uuid.v4Seeded\0A\00", align 1
@.faila.2532 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2533 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2534 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3980:51  in Semver.Semver\0A\00", align 1
@.faila.2535 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2536 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2537 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3985:41  in Semver.Semver\0A\00", align 1
@.faila.2538 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2539 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2540 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3986:28  in Semver.Semver\0A\00", align 1
@.faila.2541 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2542 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2543 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3987:28  in Semver.Semver\0A\00", align 1
@.faila.2544 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2545 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2546 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3988:28  in Semver.Semver\0A\00", align 1
@.faila.2547 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2548 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2549 = private constant [2 x i8] c".\00"
@.strobj.2550 = private global %String { i64 1, ptr @.strdata.2549, i64 0 }
@.strdata.2551 = private constant [2 x i8] c".\00"
@.strobj.2552 = private global %String { i64 1, ptr @.strdata.2551, i64 0 }
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca ptr, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %u = alloca ptr, align 8
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
  %16 = call ptr @Uuid.v4Seeded(i32 123456789)
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  store ptr %strcpy, ptr %u, align 8
  call void @__polaron_str_free(ptr %16)
  %u1 = load ptr, ptr %u, align 8
  %str.data = getelementptr inbounds %String, ptr %u1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %u2 = load ptr, ptr %u, align 8
  %17 = call i32 @Uuid.isValid(ptr %u2)
  %u3 = load ptr, ptr %u, align 8
  %str.data4 = getelementptr inbounds %String, ptr %u3, i32 0, i32 1
  %data5 = load ptr, ptr %str.data4, align 8
  %ch.addr = getelementptr i8, ptr %data5, i64 14
  %ch = load i8, ptr %ch.addr, align 1
  %18 = zext i8 %ch to i32
  %19 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, i32 %17, i32 %18)
  %Semver.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Semver, ptr null, i64 1) to i64))
  call void @Semver.Semver(ptr %Semver.obj, ptr @.strobj)
  store ptr %Semver.obj, ptr %a, align 8
  %Semver.obj6 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Semver, ptr null, i64 1) to i64))
  call void @Semver.Semver(ptr %Semver.obj6, ptr @.strobj.2)
  store ptr %Semver.obj6, ptr %b, align 8
  %Semver.obj7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Semver, ptr null, i64 1) to i64))
  call void @Semver.Semver(ptr %Semver.obj7, ptr @.strobj.4)
  store ptr %Semver.obj7, ptr %c, align 8
  %a8 = load ptr, ptr %a, align 8
  %20 = call ptr @Semver.toString(ptr %a8)
  %str.data9 = getelementptr inbounds %String, ptr %20, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %a11 = load ptr, ptr %a, align 8
  %b12 = load ptr, ptr %b, align 8
  %21 = call i32 @Semver.compareTo(ptr %a11, ptr %b12)
  %a13 = load ptr, ptr %a, align 8
  %c14 = load ptr, ptr %c, align 8
  %22 = call i32 @Semver.compareTo(ptr %a13, ptr %c14)
  %23 = call i32 (ptr, ...) @printf(ptr @.str.5, ptr %data10, i32 %21, i32 %22)
  call void @__polaron_str_free(ptr %20)
  %24 = load ptr, ptr %u, align 8
  call void @__polaron_str_free(ptr %24)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1312)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1314)
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

define internal i32 @Uuid.hx(i32 %0) {
entry:
  %d = alloca ptr, align 8
  %v = alloca i32, align 4
  store i32 %0, ptr %v, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2509)
  store ptr %strcpy, ptr %d, align 8
  %d1 = load ptr, ptr %d, align 8
  %v2 = load i32, ptr %v, align 4
  %1 = and i32 %v2, 15
  %2 = sext i32 %1 to i64
  %str.data = getelementptr inbounds %String, ptr %d1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %2
  %ch = load i8, ptr %ch.addr, align 1
  %3 = zext i8 %ch to i32
  %4 = load ptr, ptr %d, align 8
  call void @__polaron_str_free(ptr %4)
  ret i32 %3
}

define internal ptr @Uuid.format(ptr %0) {
entry:
  %b = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %bytes = alloca ptr, align 8
  store ptr %0, ptr %bytes, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %1 = icmp slt i32 %i1, 16
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i2 = load i32, ptr %i, align 4
  %3 = icmp eq i32 %i2, 4
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

for.update:                                       ; preds = %idx.ok
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb23 = load ptr, ptr %sb, align 8
  %7 = call ptr @StringBuilder.toString(ptr %sb23)
  %strcpy = call ptr @__polaron_str_copy(ptr %7)
  call void @__polaron_str_free(ptr %7)
  ret ptr %strcpy

sc.rhs:                                           ; preds = %for.body
  %i3 = load i32, ptr %i, align 4
  %8 = icmp eq i32 %i3, 6
  %9 = zext i1 %8 to i32
  %sc.b = icmp ne i32 %9, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %for.body
  %sc = phi i1 [ true, %for.body ], [ %sc.b, %sc.rhs ]
  %10 = zext i1 %sc to i32
  %sc.a4 = icmp ne i32 %10, 0
  br i1 %sc.a4, label %sc.end6, label %sc.rhs5

sc.rhs5:                                          ; preds = %sc.end
  %i7 = load i32, ptr %i, align 4
  %11 = icmp eq i32 %i7, 8
  %12 = zext i1 %11 to i32
  %sc.b8 = icmp ne i32 %12, 0
  br label %sc.end6

sc.end6:                                          ; preds = %sc.rhs5, %sc.end
  %sc9 = phi i1 [ true, %sc.end ], [ %sc.b8, %sc.rhs5 ]
  %13 = zext i1 %sc9 to i32
  %sc.a10 = icmp ne i32 %13, 0
  br i1 %sc.a10, label %sc.end12, label %sc.rhs11

sc.rhs11:                                         ; preds = %sc.end6
  %i13 = load i32, ptr %i, align 4
  %14 = icmp eq i32 %i13, 10
  %15 = zext i1 %14 to i32
  %sc.b14 = icmp ne i32 %15, 0
  br label %sc.end12

sc.end12:                                         ; preds = %sc.rhs11, %sc.end6
  %sc15 = phi i1 [ true, %sc.end6 ], [ %sc.b14, %sc.rhs11 ]
  %16 = zext i1 %sc15 to i32
  br i1 %sc15, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end12
  %sb16 = load ptr, ptr %sb, align 8
  %17 = call ptr @StringBuilder.appendChar(ptr %sb16, i32 45)
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end12
  %bytes17 = load ptr, ptr %bytes, align 8, !nonnull !8, !dereferenceable !9
  %i18 = load i32, ptr %i, align 4
  %18 = sext i32 %i18 to i64
  %arr.len = load i64, ptr %bytes17, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.2510, ptr @.faila.2511, i64 %18, ptr @.failb.2512, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %bytes17, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %18
  %elem = load i32, ptr %arr.elem, align 4
  %19 = and i32 %elem, 255
  store i32 %19, ptr %b, align 4
  %sb19 = load ptr, ptr %sb, align 8
  %b20 = load i32, ptr %b, align 4
  %20 = ashr i32 %b20, 31
  %21 = ashr i32 %b20, 4
  %22 = call i32 @Uuid.hx(i32 %21)
  %23 = call ptr @StringBuilder.appendChar(ptr %sb19, i32 %22)
  %sb21 = load ptr, ptr %sb, align 8
  %b22 = load i32, ptr %b, align 4
  %24 = call i32 @Uuid.hx(i32 %b22)
  %25 = call ptr @StringBuilder.appendChar(ptr %sb21, i32 %24)
  br label %for.update
}

define internal ptr @Uuid.v4(ptr %0) {
entry:
  %i = alloca i32, align 4
  %b = alloca ptr, align 8
  %randomBytes = alloca ptr, align 8
  store ptr %0, ptr %randomBytes, align 8
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %b, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %i1, 16
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %b2 = load ptr, ptr %b, align 8, !nonnull !8, !dereferenceable !9
  %i3 = load i32, ptr %i, align 4
  %4 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %b2, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok10
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %b13 = load ptr, ptr %b, align 8, !nonnull !8, !dereferenceable !9
  %arr.len14 = load i64, ptr %b13, align 8
  %arr.oob15 = icmp uge i64 6, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !10

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2513, ptr @.faila.2514, i64 %4, ptr @.failb.2515, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data4 = getelementptr i8, ptr %b2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data4, i64 %4
  %randomBytes5 = load ptr, ptr %randomBytes, align 8, !nonnull !8, !dereferenceable !9
  %i6 = load i32, ptr %i, align 4
  %7 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %randomBytes5, align 8
  %arr.oob8 = icmp uge i64 %7, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !10

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2516, ptr @.faila.2517, i64 %7, ptr @.failb.2518, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %randomBytes5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %7
  %elem = load i32, ptr %arr.elem12, align 4
  %8 = and i32 %elem, 255
  store i32 %8, ptr %arr.elem, align 4
  br label %for.update

idx.bad16:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.2519, ptr @.faila.2520, i64 6, ptr @.failb.2521, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %for.end
  %arr.data18 = getelementptr i8, ptr %b13, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 6
  %b20 = load ptr, ptr %b, align 8, !nonnull !8, !dereferenceable !9
  %arr.len21 = load i64, ptr %b20, align 8
  %arr.oob22 = icmp uge i64 6, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !10

idx.bad23:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.2522, ptr @.faila.2523, i64 6, ptr @.failb.2524, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok17
  %arr.data25 = getelementptr i8, ptr %b20, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 6
  %elem27 = load i32, ptr %arr.elem26, align 4
  %9 = and i32 %elem27, 15
  %10 = or i32 %9, 64
  store i32 %10, ptr %arr.elem19, align 4
  %b28 = load ptr, ptr %b, align 8, !nonnull !8, !dereferenceable !9
  %arr.len29 = load i64, ptr %b28, align 8
  %arr.oob30 = icmp uge i64 8, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !10

idx.bad31:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.2525, ptr @.faila.2526, i64 8, ptr @.failb.2527, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok24
  %arr.data33 = getelementptr i8, ptr %b28, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 8
  %b35 = load ptr, ptr %b, align 8, !nonnull !8, !dereferenceable !9
  %arr.len36 = load i64, ptr %b35, align 8
  %arr.oob37 = icmp uge i64 8, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !10

idx.bad38:                                        ; preds = %idx.ok32
  call void @__polaron_fail(ptr @.fail.2528, ptr @.faila.2529, i64 8, ptr @.failb.2530, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok32
  %arr.data40 = getelementptr i8, ptr %b35, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 8
  %elem42 = load i32, ptr %arr.elem41, align 4
  %11 = and i32 %elem42, 63
  %12 = or i32 %11, 128
  store i32 %12, ptr %arr.elem34, align 4
  %b43 = load ptr, ptr %b, align 8
  %13 = call ptr @Uuid.format(ptr %b43)
  %strcpy = call ptr @__polaron_str_copy(ptr %13)
  call void @__polaron_str_free(ptr %13)
  ret ptr %strcpy
}

define internal ptr @Uuid.v4Seeded(i32 %0) {
entry:
  %i = alloca i32, align 4
  %b = alloca ptr, align 8
  %x = alloca i64, align 8
  %seed = alloca i32, align 4
  store i32 %0, ptr %seed, align 4
  %seed1 = load i32, ptr %seed, align 4
  %1 = sext i32 %seed1 to i64
  store i64 %1, ptr %x, align 8
  %x2 = load i64, ptr %x, align 8
  %2 = icmp eq i64 %x2, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i64 1, ptr %x, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %b, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i3 = load i32, ptr %i, align 4
  %5 = icmp slt i32 %i3, 16
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %x4 = load i64, ptr %x, align 8
  %x5 = load i64, ptr %x, align 8
  %7 = shl i64 %x5, 13
  %8 = xor i64 %x4, %7
  store i64 %8, ptr %x, align 8
  %x6 = load i64, ptr %x, align 8
  %x7 = load i64, ptr %x, align 8
  %9 = lshr i64 %x7, 7
  %10 = xor i64 %x6, %9
  store i64 %10, ptr %x, align 8
  %x8 = load i64, ptr %x, align 8
  %x9 = load i64, ptr %x, align 8
  %11 = shl i64 %x9, 17
  %12 = xor i64 %x8, %11
  store i64 %12, ptr %x, align 8
  %b10 = load ptr, ptr %b, align 8, !nonnull !8, !dereferenceable !9
  %i11 = load i32, ptr %i, align 4
  %13 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %b10, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %14 = load i32, ptr %i, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %b14 = load ptr, ptr %b, align 8
  %16 = call ptr @Uuid.v4(ptr %b14)
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  call void @__polaron_str_free(ptr %16)
  ret ptr %strcpy

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2531, ptr @.faila.2532, i64 %13, ptr @.failb.2533, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data12 = getelementptr i8, ptr %b10, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data12, i64 %13
  %x13 = load i64, ptr %x, align 8
  %17 = lshr i64 %x13, 24
  %18 = and i64 %17, 255
  %19 = trunc i64 %18 to i32
  store i32 %19, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @Uuid.isValid(ptr %0) {
entry:
  %hex = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp ne i32 %1, 36
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i2 = load i32, ptr %i, align 4
  %4 = icmp slt i32 %i2, 36
  %5 = zext i1 %4 to i32
  br i1 %4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s3 = load ptr, ptr %s, align 8
  %i4 = load i32, ptr %i, align 4
  %6 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %6
  %ch = load i8, ptr %ch.addr, align 1
  %7 = zext i8 %ch to i32
  store i32 %7, ptr %c, align 4
  %i5 = load i32, ptr %i, align 4
  %8 = icmp eq i32 %i5, 8
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

for.update:                                       ; preds = %if.end20
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 1

sc.rhs:                                           ; preds = %for.body
  %i6 = load i32, ptr %i, align 4
  %12 = icmp eq i32 %i6, 13
  %13 = zext i1 %12 to i32
  %sc.b = icmp ne i32 %13, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %for.body
  %sc = phi i1 [ true, %for.body ], [ %sc.b, %sc.rhs ]
  %14 = zext i1 %sc to i32
  %sc.a7 = icmp ne i32 %14, 0
  br i1 %sc.a7, label %sc.end9, label %sc.rhs8

sc.rhs8:                                          ; preds = %sc.end
  %i10 = load i32, ptr %i, align 4
  %15 = icmp eq i32 %i10, 18
  %16 = zext i1 %15 to i32
  %sc.b11 = icmp ne i32 %16, 0
  br label %sc.end9

sc.end9:                                          ; preds = %sc.rhs8, %sc.end
  %sc12 = phi i1 [ true, %sc.end ], [ %sc.b11, %sc.rhs8 ]
  %17 = zext i1 %sc12 to i32
  %sc.a13 = icmp ne i32 %17, 0
  br i1 %sc.a13, label %sc.end15, label %sc.rhs14

sc.rhs14:                                         ; preds = %sc.end9
  %i16 = load i32, ptr %i, align 4
  %18 = icmp eq i32 %i16, 23
  %19 = zext i1 %18 to i32
  %sc.b17 = icmp ne i32 %19, 0
  br label %sc.end15

sc.end15:                                         ; preds = %sc.rhs14, %sc.end9
  %sc18 = phi i1 [ true, %sc.end9 ], [ %sc.b17, %sc.rhs14 ]
  %20 = zext i1 %sc18 to i32
  br i1 %sc18, label %if.then19, label %if.else

if.then19:                                        ; preds = %sc.end15
  %c21 = load i32, ptr %c, align 4
  %21 = icmp ne i32 %c21, 45
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then22, label %if.end23

if.else:                                          ; preds = %sc.end15
  %c24 = load i32, ptr %c, align 4
  %23 = icmp sge i32 %c24, 48
  %24 = zext i1 %23 to i32
  %sc.a25 = icmp ne i32 %24, 0
  br i1 %sc.a25, label %sc.rhs26, label %sc.end27

if.end20:                                         ; preds = %if.end45, %if.end23
  br label %for.update

if.then22:                                        ; preds = %if.then19
  ret i32 0

if.end23:                                         ; preds = %if.then19
  br label %if.end20

sc.rhs26:                                         ; preds = %if.else
  %c28 = load i32, ptr %c, align 4
  %25 = icmp sle i32 %c28, 57
  %26 = zext i1 %25 to i32
  %sc.b29 = icmp ne i32 %26, 0
  br label %sc.end27

sc.end27:                                         ; preds = %sc.rhs26, %if.else
  %sc30 = phi i1 [ false, %if.else ], [ %sc.b29, %sc.rhs26 ]
  %27 = zext i1 %sc30 to i32
  %sc.a31 = icmp ne i32 %27, 0
  br i1 %sc.a31, label %sc.end33, label %sc.rhs32

sc.rhs32:                                         ; preds = %sc.end27
  %c34 = load i32, ptr %c, align 4
  %28 = icmp sge i32 %c34, 97
  %29 = zext i1 %28 to i32
  %sc.a35 = icmp ne i32 %29, 0
  br i1 %sc.a35, label %sc.rhs36, label %sc.end37

sc.end33:                                         ; preds = %sc.end37, %sc.end27
  %sc42 = phi i1 [ true, %sc.end27 ], [ %sc.b41, %sc.end37 ]
  %30 = zext i1 %sc42 to i32
  store i32 %30, ptr %hex, align 4
  %hex43 = load i32, ptr %hex, align 4
  %31 = icmp eq i32 %hex43, 0
  %32 = zext i1 %31 to i32
  br i1 %31, label %if.then44, label %if.end45

sc.rhs36:                                         ; preds = %sc.rhs32
  %c38 = load i32, ptr %c, align 4
  %33 = icmp sle i32 %c38, 102
  %34 = zext i1 %33 to i32
  %sc.b39 = icmp ne i32 %34, 0
  br label %sc.end37

sc.end37:                                         ; preds = %sc.rhs36, %sc.rhs32
  %sc40 = phi i1 [ false, %sc.rhs32 ], [ %sc.b39, %sc.rhs36 ]
  %35 = zext i1 %sc40 to i32
  %sc.b41 = icmp ne i32 %35, 0
  br label %sc.end33

if.then44:                                        ; preds = %sc.end33
  ret i32 0

if.end45:                                         ; preds = %sc.end33
  br label %if.end20
}

define internal void @Semver.Semver(ptr %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %n = alloca i32, align 4
  %cur = alloca i32, align 4
  %pi = alloca i32, align 4
  %parts = alloca ptr, align 8
  %i = alloca i32, align 4
  %v = alloca ptr, align 8
  store ptr %1, ptr %v, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 0
  store ptr @Semver.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  store i32 0, ptr %i, align 4
  %v1 = load ptr, ptr %v, align 8
  %str.len = getelementptr inbounds %String, ptr %v1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp sgt i32 %2, 0
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %v2 = load ptr, ptr %v, align 8
  %str.data = getelementptr inbounds %String, ptr %v2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 0
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = icmp eq i32 %5, 118
  %7 = zext i1 %6 to i32
  %sc.b = icmp ne i32 %7, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %8 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  store i32 1, ptr %i, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %9 = call ptr @memset(ptr %arr.data, i32 0, i64 12)
  store ptr %arr, ptr %parts, align 8
  store i32 0, ptr %pi, align 4
  store i32 0, ptr %cur, align 4
  %v3 = load ptr, ptr %v, align 8
  %str.len4 = getelementptr inbounds %String, ptr %v3, i32 0, i32 0
  %len5 = load i64, ptr %str.len4, align 8
  %10 = trunc i64 %len5 to i32
  store i32 %10, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end28, %if.end
  %i6 = load i32, ptr %i, align 4
  %n7 = load i32, ptr %n, align 4
  %11 = icmp slt i32 %i6, %n7
  %12 = zext i1 %11 to i32
  %sc.a8 = icmp ne i32 %12, 0
  br i1 %sc.a8, label %sc.rhs9, label %sc.end10

while.body:                                       ; preds = %sc.end10
  %v14 = load ptr, ptr %v, align 8
  %i15 = load i32, ptr %i, align 4
  %13 = sext i32 %i15 to i64
  %str.data16 = getelementptr inbounds %String, ptr %v14, i32 0, i32 1
  %data17 = load ptr, ptr %str.data16, align 8
  %ch.addr18 = getelementptr i8, ptr %data17, i64 %13
  %ch19 = load i8, ptr %ch.addr18, align 1
  %14 = zext i8 %ch19 to i32
  store i32 %14, ptr %c, align 4
  %c20 = load i32, ptr %c, align 4
  %15 = icmp sge i32 %c20, 48
  %16 = zext i1 %15 to i32
  %sc.a21 = icmp ne i32 %16, 0
  br i1 %sc.a21, label %sc.rhs22, label %sc.end23

while.end:                                        ; preds = %sc.end10
  %pi42 = load i32, ptr %pi, align 4
  %17 = icmp slt i32 %pi42, 3
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then43, label %if.end44

sc.rhs9:                                          ; preds = %while.cond
  %pi11 = load i32, ptr %pi, align 4
  %19 = icmp slt i32 %pi11, 3
  %20 = zext i1 %19 to i32
  %sc.b12 = icmp ne i32 %20, 0
  br label %sc.end10

sc.end10:                                         ; preds = %sc.rhs9, %while.cond
  %sc13 = phi i1 [ false, %while.cond ], [ %sc.b12, %sc.rhs9 ]
  %21 = zext i1 %sc13 to i32
  br i1 %sc13, label %while.body, label %while.end

sc.rhs22:                                         ; preds = %while.body
  %c24 = load i32, ptr %c, align 4
  %22 = icmp sle i32 %c24, 57
  %23 = zext i1 %22 to i32
  %sc.b25 = icmp ne i32 %23, 0
  br label %sc.end23

sc.end23:                                         ; preds = %sc.rhs22, %while.body
  %sc26 = phi i1 [ false, %while.body ], [ %sc.b25, %sc.rhs22 ]
  %24 = zext i1 %sc26 to i32
  br i1 %sc26, label %if.then27, label %if.else

if.then27:                                        ; preds = %sc.end23
  %cur29 = load i32, ptr %cur, align 4
  %25 = mul i32 %cur29, 10
  %c30 = load i32, ptr %c, align 4
  %26 = sub i32 %c30, 48
  %27 = add i32 %25, %26
  store i32 %27, ptr %cur, align 4
  br label %if.end28

if.else:                                          ; preds = %sc.end23
  %c31 = load i32, ptr %c, align 4
  %28 = icmp eq i32 %c31, 46
  %29 = zext i1 %28 to i32
  br i1 %28, label %if.then32, label %if.else33

if.end28:                                         ; preds = %if.end34, %if.then27
  %i41 = load i32, ptr %i, align 4
  %30 = add i32 %i41, 1
  store i32 %30, ptr %i, align 4
  br label %while.cond

if.then32:                                        ; preds = %if.else
  %parts35 = load ptr, ptr %parts, align 8, !nonnull !8, !dereferenceable !9
  %pi36 = load i32, ptr %pi, align 4
  %31 = sext i32 %pi36 to i64
  %arr.len = load i64, ptr %parts35, align 8
  %arr.oob = icmp uge i64 %31, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

if.else33:                                        ; preds = %if.else
  %n40 = load i32, ptr %n, align 4
  store i32 %n40, ptr %i, align 4
  br label %if.end34

if.end34:                                         ; preds = %if.else33, %idx.ok
  br label %if.end28

idx.bad:                                          ; preds = %if.then32
  call void @__polaron_fail(ptr @.fail.2534, ptr @.faila.2535, i64 %31, ptr @.failb.2536, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then32
  %arr.data37 = getelementptr i8, ptr %parts35, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data37, i64 %31
  %cur38 = load i32, ptr %cur, align 4
  store i32 %cur38, ptr %arr.elem, align 4
  %pi39 = load i32, ptr %pi, align 4
  %32 = add i32 %pi39, 1
  store i32 %32, ptr %pi, align 4
  store i32 0, ptr %cur, align 4
  br label %if.end34

if.then43:                                        ; preds = %while.end
  %parts45 = load ptr, ptr %parts, align 8, !nonnull !8, !dereferenceable !9
  %pi46 = load i32, ptr %pi, align 4
  %33 = sext i32 %pi46 to i64
  %arr.len47 = load i64, ptr %parts45, align 8
  %arr.oob48 = icmp uge i64 %33, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !10

if.end44:                                         ; preds = %idx.ok50, %while.end
  %major = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 1
  %parts54 = load ptr, ptr %parts, align 8, !nonnull !8, !dereferenceable !9
  %arr.len55 = load i64, ptr %parts54, align 8
  %arr.oob56 = icmp uge i64 0, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !10

idx.bad49:                                        ; preds = %if.then43
  call void @__polaron_fail(ptr @.fail.2537, ptr @.faila.2538, i64 %33, ptr @.failb.2539, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %if.then43
  %arr.data51 = getelementptr i8, ptr %parts45, i64 8
  %arr.elem52 = getelementptr inbounds i32, ptr %arr.data51, i64 %33
  %cur53 = load i32, ptr %cur, align 4
  store i32 %cur53, ptr %arr.elem52, align 4
  br label %if.end44

idx.bad57:                                        ; preds = %if.end44
  call void @__polaron_fail(ptr @.fail.2540, ptr @.faila.2541, i64 0, ptr @.failb.2542, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %if.end44
  %arr.data59 = getelementptr i8, ptr %parts54, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 0
  %elem = load i32, ptr %arr.elem60, align 4
  store i32 %elem, ptr %major, align 4, !tbaa !4
  %minor = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 2
  %parts61 = load ptr, ptr %parts, align 8, !nonnull !8, !dereferenceable !9
  %arr.len62 = load i64, ptr %parts61, align 8
  %arr.oob63 = icmp uge i64 1, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !10

idx.bad64:                                        ; preds = %idx.ok58
  call void @__polaron_fail(ptr @.fail.2543, ptr @.faila.2544, i64 1, ptr @.failb.2545, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %idx.ok58
  %arr.data66 = getelementptr i8, ptr %parts61, i64 8
  %arr.elem67 = getelementptr inbounds i32, ptr %arr.data66, i64 1
  %elem68 = load i32, ptr %arr.elem67, align 4
  store i32 %elem68, ptr %minor, align 4, !tbaa !4
  %patch = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 3
  %parts69 = load ptr, ptr %parts, align 8, !nonnull !8, !dereferenceable !9
  %arr.len70 = load i64, ptr %parts69, align 8
  %arr.oob71 = icmp uge i64 2, %arr.len70
  br i1 %arr.oob71, label %idx.bad72, label %idx.ok73, !prof !10

idx.bad72:                                        ; preds = %idx.ok65
  call void @__polaron_fail(ptr @.fail.2546, ptr @.faila.2547, i64 2, ptr @.failb.2548, i64 %arr.len70, i32 70)
  unreachable

idx.ok73:                                         ; preds = %idx.ok65
  %arr.data74 = getelementptr i8, ptr %parts69, i64 8
  %arr.elem75 = getelementptr inbounds i32, ptr %arr.data74, i64 2
  %elem76 = load i32, ptr %arr.elem75, align 4
  store i32 %elem76, ptr %patch, align 4, !tbaa !4
  ret void
}

define internal i32 @Semver.getMajor(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %major = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 1
  %major1 = load i32, ptr %major, align 4, !tbaa !4
  ret i32 %major1
}

define internal i32 @Semver.getMinor(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %minor = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 2
  %minor1 = load i32, ptr %minor, align 4, !tbaa !4
  ret i32 %minor1
}

define internal i32 @Semver.getPatch(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %patch = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 3
  %patch1 = load i32, ptr %patch, align 4, !tbaa !4
  ret i32 %patch1
}

define internal i32 @Semver.compareTo(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Semver.copy = alloca %class.Semver, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Semver.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Semver, ptr null, i64 1) to i64))
  store ptr %Semver.copy, ptr %o, align 8
  %major = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 1
  %major1 = load i32, ptr %major, align 4, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call i32 @Semver.getMajor(ptr %o2)
  %4 = icmp ne i32 %major1, %3
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %major3 = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 1
  %major4 = load i32, ptr %major3, align 4, !tbaa !4
  %o5 = load ptr, ptr %o, align 8
  %6 = call i32 @Semver.getMajor(ptr %o5)
  %7 = icmp slt i32 %major4, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then6, label %if.end7

if.end:                                           ; preds = %entry
  %minor = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 2
  %minor8 = load i32, ptr %minor, align 4, !tbaa !4
  %o9 = load ptr, ptr %o, align 8
  %9 = call i32 @Semver.getMinor(ptr %o9)
  %10 = icmp ne i32 %minor8, %9
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then10, label %if.end11

if.then6:                                         ; preds = %if.then
  ret i32 -1

if.end7:                                          ; preds = %if.then
  ret i32 1

if.then10:                                        ; preds = %if.end
  %minor12 = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 2
  %minor13 = load i32, ptr %minor12, align 4, !tbaa !4
  %o14 = load ptr, ptr %o, align 8
  %12 = call i32 @Semver.getMinor(ptr %o14)
  %13 = icmp slt i32 %minor13, %12
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then15, label %if.end16

if.end11:                                         ; preds = %if.end
  %patch = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 3
  %patch17 = load i32, ptr %patch, align 4, !tbaa !4
  %o18 = load ptr, ptr %o, align 8
  %15 = call i32 @Semver.getPatch(ptr %o18)
  %16 = icmp ne i32 %patch17, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then19, label %if.end20

if.then15:                                        ; preds = %if.then10
  ret i32 -1

if.end16:                                         ; preds = %if.then10
  ret i32 1

if.then19:                                        ; preds = %if.end11
  %patch21 = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 3
  %patch22 = load i32, ptr %patch21, align 4, !tbaa !4
  %o23 = load ptr, ptr %o, align 8
  %18 = call i32 @Semver.getPatch(ptr %o23)
  %19 = icmp slt i32 %patch22, %18
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then24, label %if.end25

if.end20:                                         ; preds = %if.end11
  ret i32 0

if.then24:                                        ; preds = %if.then19
  ret i32 -1

if.end25:                                         ; preds = %if.then19
  ret i32 1
}

define internal ptr @Semver.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %sb = alloca ptr, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb1 = load ptr, ptr %sb, align 8
  %major = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 1
  %major2 = load i32, ptr %major, align 4, !tbaa !4
  %1 = call ptr @StringBuilder.appendInt(ptr %sb1, i32 %major2)
  %2 = call ptr @StringBuilder.append(ptr %1, ptr @.strobj.2550)
  %minor = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 2
  %minor3 = load i32, ptr %minor, align 4, !tbaa !4
  %3 = call ptr @StringBuilder.appendInt(ptr %2, i32 %minor3)
  %4 = call ptr @StringBuilder.append(ptr %3, ptr @.strobj.2552)
  %patch = getelementptr inbounds %class.Semver, ptr %0, i32 0, i32 3
  %patch4 = load i32, ptr %patch, align 4, !tbaa !4
  %5 = call ptr @StringBuilder.appendInt(ptr %4, i32 %patch4)
  %sb5 = load ptr, ptr %sb, align 8
  %6 = call ptr @StringBuilder.toString(ptr %sb5)
  %strcpy = call ptr @__polaron_str_copy(ptr %6)
  call void @__polaron_str_free(ptr %6)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5315)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

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
