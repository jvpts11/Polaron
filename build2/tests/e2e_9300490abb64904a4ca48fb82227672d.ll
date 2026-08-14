; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/chars_roman_pct.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/chars_roman_pct.pol"
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
@.fail = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/chars_roman_pct.pol:15:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/chars_roman_pct.pol:16:23  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/chars_roman_pct.pol:17:23  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/chars_roman_pct.pol:18:23  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/chars_roman_pct.pol:19:23  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [49 x i8] c"up=%c lo=%c dig=%d rom=%s back=%d p50=%d p25=%d\0A\00", align 1
@.strdata = private constant [7 x i8] c"MMXXIV\00"
@.strobj = private global %String { i64 6, ptr @.strdata, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1321 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1322 = private global %String { i64 16, ptr @.strdata.1321, i64 0 }
@.strdata.1323 = private constant [17 x i8] c"division by zero\00"
@.strobj.1324 = private global %String { i64 16, ptr @.strdata.1323, i64 0 }
@.fail.2383 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3784:25  in Roman.toRoman\0A\00", align 1
@.faila.2384 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2385 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2386 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3784:41  in Roman.toRoman\0A\00", align 1
@.faila.2387 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2388 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2389 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3784:56  in Roman.toRoman\0A\00", align 1
@.faila.2390 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2391 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2392 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3784:71  in Roman.toRoman\0A\00", align 1
@.faila.2393 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2394 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2395 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3784:86  in Roman.toRoman\0A\00", align 1
@.faila.2396 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2397 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2398 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3784:101  in Roman.toRoman\0A\00", align 1
@.faila.2399 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2400 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2401 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3785:25  in Roman.toRoman\0A\00", align 1
@.faila.2402 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2403 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2404 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3785:39  in Roman.toRoman\0A\00", align 1
@.faila.2405 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2406 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2407 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3785:53  in Roman.toRoman\0A\00", align 1
@.faila.2408 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2409 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2410 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3785:67  in Roman.toRoman\0A\00", align 1
@.faila.2411 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2412 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2413 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3785:81  in Roman.toRoman\0A\00", align 1
@.faila.2414 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2415 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2416 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3785:95  in Roman.toRoman\0A\00", align 1
@.faila.2417 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2418 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2419 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3785:109  in Roman.toRoman\0A\00", align 1
@.faila.2420 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2421 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2422 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3787:25  in Roman.toRoman\0A\00", align 1
@.faila.2423 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2424 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2425 = private constant [2 x i8] c"M\00"
@.strobj.2426 = private global %String { i64 1, ptr @.strdata.2425, i64 0 }
@.fail.2427 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3787:40  in Roman.toRoman\0A\00", align 1
@.faila.2428 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2429 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2430 = private constant [3 x i8] c"CM\00"
@.strobj.2431 = private global %String { i64 2, ptr @.strdata.2430, i64 0 }
@.fail.2432 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3787:56  in Roman.toRoman\0A\00", align 1
@.faila.2433 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2434 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2435 = private constant [2 x i8] c"D\00"
@.strobj.2436 = private global %String { i64 1, ptr @.strdata.2435, i64 0 }
@.fail.2437 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3787:71  in Roman.toRoman\0A\00", align 1
@.faila.2438 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2439 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2440 = private constant [3 x i8] c"CD\00"
@.strobj.2441 = private global %String { i64 2, ptr @.strdata.2440, i64 0 }
@.fail.2442 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3787:87  in Roman.toRoman\0A\00", align 1
@.faila.2443 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2444 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2445 = private constant [2 x i8] c"C\00"
@.strobj.2446 = private global %String { i64 1, ptr @.strdata.2445, i64 0 }
@.fail.2447 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3787:102  in Roman.toRoman\0A\00", align 1
@.faila.2448 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2449 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2450 = private constant [3 x i8] c"XC\00"
@.strobj.2451 = private global %String { i64 2, ptr @.strdata.2450, i64 0 }
@.fail.2452 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3788:25  in Roman.toRoman\0A\00", align 1
@.faila.2453 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2454 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2455 = private constant [2 x i8] c"L\00"
@.strobj.2456 = private global %String { i64 1, ptr @.strdata.2455, i64 0 }
@.fail.2457 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3788:40  in Roman.toRoman\0A\00", align 1
@.faila.2458 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2459 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2460 = private constant [3 x i8] c"XL\00"
@.strobj.2461 = private global %String { i64 2, ptr @.strdata.2460, i64 0 }
@.fail.2462 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3788:56  in Roman.toRoman\0A\00", align 1
@.faila.2463 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2464 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2465 = private constant [2 x i8] c"X\00"
@.strobj.2466 = private global %String { i64 1, ptr @.strdata.2465, i64 0 }
@.fail.2467 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3788:71  in Roman.toRoman\0A\00", align 1
@.faila.2468 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2469 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2470 = private constant [3 x i8] c"IX\00"
@.strobj.2471 = private global %String { i64 2, ptr @.strdata.2470, i64 0 }
@.fail.2472 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3788:88  in Roman.toRoman\0A\00", align 1
@.faila.2473 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2474 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2475 = private constant [2 x i8] c"V\00"
@.strobj.2476 = private global %String { i64 1, ptr @.strdata.2475, i64 0 }
@.fail.2477 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3788:104  in Roman.toRoman\0A\00", align 1
@.faila.2478 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2479 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2480 = private constant [3 x i8] c"IV\00"
@.strobj.2481 = private global %String { i64 2, ptr @.strdata.2480, i64 0 }
@.fail.2482 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3788:121  in Roman.toRoman\0A\00", align 1
@.faila.2483 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2484 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2485 = private constant [2 x i8] c"I\00"
@.strobj.2486 = private global %String { i64 1, ptr @.strdata.2485, i64 0 }
@.fail.2487 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3792:21  in Roman.toRoman\0A\00", align 1
@.faila.2488 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2489 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2490 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3793:34  in Roman.toRoman\0A\00", align 1
@.faila.2491 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2492 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2493 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3794:27  in Roman.toRoman\0A\00", align 1
@.faila.2494 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2495 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3307 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5642:60  in Stats.percentile\0A\00", align 1
@.faila.3308 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3309 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3310 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5642:60  in Stats.percentile\0A\00", align 1
@.faila.3311 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3312 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3313 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5644:21  in Stats.percentile\0A\00", align 1
@.faila.3314 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3315 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3316 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5646:21  in Stats.percentile\0A\00", align 1
@.faila.3317 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3318 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3319 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5647:34  in Stats.percentile\0A\00", align 1
@.faila.3320 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3321 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3322 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5647:34  in Stats.percentile\0A\00", align 1
@.faila.3323 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3324 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3325 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5650:30  in Stats.percentile\0A\00", align 1
@.faila.3326 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3327 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3328 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5652:17  in Stats.percentile\0A\00", align 1
@.faila.3329 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3330 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %xs = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 28)
  store i64 5, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 20)
  store ptr %arr, ptr %xs, align 8
  %xs2 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %xs2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %xs2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 5, ptr %arr.elem, align 4
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %xs4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %xs4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 1, ptr %arr.elem10, align 4
  %xs11 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %xs11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %xs11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 3, ptr %arr.elem17, align 4
  %xs18 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %xs18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %xs18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 3
  store i32 2, ptr %arr.elem24, align 4
  %xs25 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len26 = load i64, ptr %xs25, align 8
  %arr.oob27 = icmp uge i64 4, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %xs25, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 4
  store i32 4, ptr %arr.elem31, align 4
  %17 = call i32 @Chars.toUpper(i32 97)
  %18 = call i32 @Chars.toLower(i32 90)
  %19 = call i32 @Chars.isDigit(i32 55)
  %20 = call ptr @Roman.toRoman(i32 2024)
  %str.data = getelementptr inbounds %String, ptr %20, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %21 = call i32 @Roman.fromRoman(ptr @.strobj)
  %xs32 = load ptr, ptr %xs, align 8
  %22 = call i32 @Stats.percentile(ptr %xs32, i32 50)
  %xs33 = load ptr, ptr %xs, align 8
  %23 = call i32 @Stats.percentile(ptr %xs33, i32 25)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %18, i32 %19, ptr %data, i32 %21, i32 %22, i32 %23)
  call void @__polaron_str_free(ptr %20)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1322)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1324)
  ret ptr %strcpy
}

define internal void @StringBuilder.StringBuilder(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 0
  store ptr @StringBuilder.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  store i32 16, ptr %cap, align 4, !tbaa !7
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %1 = ptrtoint ptr %mem.alloc to i64
  store i64 %1, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !7
  ret void
}

define internal void @StringBuilder.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %nb = alloca i64, align 8
  %n = alloca i32, align 4
  %extra = alloca i32, align 4
  store i32 %1, ptr %extra, align 4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %extra2 = load i32, ptr %extra, align 4
  %2 = add i32 %count1, %extra2
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap3 = load i32, ptr %cap, align 4, !tbaa !7
  %3 = icmp sle i32 %2, %cap3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap5 = load i32, ptr %cap4, align 4, !tbaa !7
  %5 = mul i32 %cap5, 2
  store i32 %5, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %n6 = load i32, ptr %n, align 4
  %count7 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
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
  %buf13 = load i64, ptr %buf, align 8, !tbaa !9
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !7
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !9
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !9
  %cap20 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %n21 = load i32, ptr %n, align 4
  store i32 %n21, ptr %cap20, align 4, !tbaa !7
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
  %buf3 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !7
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
  %count10 = load i32, ptr %count9, align 4, !tbaa !7
  %n11 = load i32, ptr %n, align 4
  %7 = add i32 %count10, %n11
  store i32 %7, ptr %count8, align 4, !tbaa !7
  ret ptr %0
}

define internal ptr @StringBuilder.appendChar(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  store i32 %1, ptr %c, align 4
  call void @StringBuilder.ensure(ptr %0, i32 1)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !7
  %2 = sext i32 %count2 to i64
  %3 = add i64 %buf1, %2
  %c3 = load i32, ptr %c, align 4
  %4 = trunc i32 %c3 to i8
  %5 = inttoptr i64 %3 to ptr
  store i8 %4, ptr %5, align 1
  %count4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count5 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count6 = load i32, ptr %count5, align 4, !tbaa !7
  %6 = add i32 %count6, 1
  store i32 %6, ptr %count4, align 4, !tbaa !7
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
  %count7 = load i32, ptr %count, align 4, !tbaa !7
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
  %count18 = load i32, ptr %count17, align 4, !tbaa !7
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
  %buf24 = load i64, ptr %buf, align 8, !tbaa !9
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !9
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !9
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !9
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  ret i32 %count1
}

define internal ptr @StringBuilder.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !7
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
  store i32 0, ptr %count, align 4, !tbaa !7
  ret ptr %0
}

define internal void @"StringBuilder.~StringBuilder"(ptr %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !9
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !9
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal i32 @Chars.isDigit(i32 %0) {
entry:
  %c = alloca i32, align 4
  store i32 %0, ptr %c, align 4
  %c1 = load i32, ptr %c, align 4
  %1 = icmp sge i32 %c1, 48
  %2 = zext i1 %1 to i32
  %sc.a = icmp ne i32 %2, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %c2 = load i32, ptr %c, align 4
  %3 = icmp sle i32 %c2, 57
  %4 = zext i1 %3 to i32
  %sc.b = icmp ne i32 %4, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %5 = zext i1 %sc to i32
  ret i32 %5
}

define internal i32 @Chars.toUpper(i32 %0) {
entry:
  %c = alloca i32, align 4
  store i32 %0, ptr %c, align 4
  %c1 = load i32, ptr %c, align 4
  %1 = icmp sge i32 %c1, 97
  %2 = zext i1 %1 to i32
  %sc.a = icmp ne i32 %2, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %c2 = load i32, ptr %c, align 4
  %3 = icmp sle i32 %c2, 122
  %4 = zext i1 %3 to i32
  %sc.b = icmp ne i32 %4, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %5 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %c3 = load i32, ptr %c, align 4
  %6 = sub i32 %c3, 32
  ret i32 %6

if.end:                                           ; preds = %sc.end
  %c4 = load i32, ptr %c, align 4
  ret i32 %c4
}

define internal i32 @Chars.toLower(i32 %0) {
entry:
  %c = alloca i32, align 4
  store i32 %0, ptr %c, align 4
  %c1 = load i32, ptr %c, align 4
  %1 = icmp sge i32 %c1, 65
  %2 = zext i1 %1 to i32
  %sc.a = icmp ne i32 %2, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %c2 = load i32, ptr %c, align 4
  %3 = icmp sle i32 %c2, 90
  %4 = zext i1 %3 to i32
  %sc.b = icmp ne i32 %4, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %5 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %c3 = load i32, ptr %c, align 4
  %6 = add i32 %c3, 32
  ret i32 %6

if.end:                                           ; preds = %sc.end
  %c4 = load i32, ptr %c, align 4
  ret i32 %c4
}

define internal ptr @Roman.toRoman(i32 %0) {
entry:
  %i = alloca i32, align 4
  %x = alloca i32, align 4
  %sb = alloca ptr, align 8
  %syms = alloca ptr, align 8
  %vals = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %arr = call ptr @__polaron_malloc(i64 60)
  store i64 13, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 52)
  store ptr %arr, ptr %vals, align 8
  %vals1 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %vals1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.2383, ptr @.faila.2384, i64 0, ptr @.failb.2385, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %vals1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data2, i64 0
  store i32 1000, ptr %arr.elem, align 4
  %vals3 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len4 = load i64, ptr %vals3, align 8
  %arr.oob5 = icmp uge i64 1, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !2

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2386, ptr @.faila.2387, i64 1, ptr @.failb.2388, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %vals3, i64 8
  %arr.elem9 = getelementptr inbounds i32, ptr %arr.data8, i64 1
  store i32 900, ptr %arr.elem9, align 4
  %vals10 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len11 = load i64, ptr %vals10, align 8
  %arr.oob12 = icmp uge i64 2, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok7
  call void @__polaron_fail(ptr @.fail.2389, ptr @.faila.2390, i64 2, ptr @.failb.2391, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok7
  %arr.data15 = getelementptr i8, ptr %vals10, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 2
  store i32 500, ptr %arr.elem16, align 4
  %vals17 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len18 = load i64, ptr %vals17, align 8
  %arr.oob19 = icmp uge i64 3, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !2

idx.bad20:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.2392, ptr @.faila.2393, i64 3, ptr @.failb.2394, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %idx.ok14
  %arr.data22 = getelementptr i8, ptr %vals17, i64 8
  %arr.elem23 = getelementptr inbounds i32, ptr %arr.data22, i64 3
  store i32 400, ptr %arr.elem23, align 4
  %vals24 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len25 = load i64, ptr %vals24, align 8
  %arr.oob26 = icmp uge i64 4, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !2

idx.bad27:                                        ; preds = %idx.ok21
  call void @__polaron_fail(ptr @.fail.2395, ptr @.faila.2396, i64 4, ptr @.failb.2397, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok21
  %arr.data29 = getelementptr i8, ptr %vals24, i64 8
  %arr.elem30 = getelementptr inbounds i32, ptr %arr.data29, i64 4
  store i32 100, ptr %arr.elem30, align 4
  %vals31 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len32 = load i64, ptr %vals31, align 8
  %arr.oob33 = icmp uge i64 5, %arr.len32
  br i1 %arr.oob33, label %idx.bad34, label %idx.ok35, !prof !2

idx.bad34:                                        ; preds = %idx.ok28
  call void @__polaron_fail(ptr @.fail.2398, ptr @.faila.2399, i64 5, ptr @.failb.2400, i64 %arr.len32, i32 70)
  unreachable

idx.ok35:                                         ; preds = %idx.ok28
  %arr.data36 = getelementptr i8, ptr %vals31, i64 8
  %arr.elem37 = getelementptr inbounds i32, ptr %arr.data36, i64 5
  store i32 90, ptr %arr.elem37, align 4
  %vals38 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len39 = load i64, ptr %vals38, align 8
  %arr.oob40 = icmp uge i64 6, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !2

idx.bad41:                                        ; preds = %idx.ok35
  call void @__polaron_fail(ptr @.fail.2401, ptr @.faila.2402, i64 6, ptr @.failb.2403, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %idx.ok35
  %arr.data43 = getelementptr i8, ptr %vals38, i64 8
  %arr.elem44 = getelementptr inbounds i32, ptr %arr.data43, i64 6
  store i32 50, ptr %arr.elem44, align 4
  %vals45 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len46 = load i64, ptr %vals45, align 8
  %arr.oob47 = icmp uge i64 7, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

idx.bad48:                                        ; preds = %idx.ok42
  call void @__polaron_fail(ptr @.fail.2404, ptr @.faila.2405, i64 7, ptr @.failb.2406, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %idx.ok42
  %arr.data50 = getelementptr i8, ptr %vals45, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 7
  store i32 40, ptr %arr.elem51, align 4
  %vals52 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len53 = load i64, ptr %vals52, align 8
  %arr.oob54 = icmp uge i64 8, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !2

idx.bad55:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.2407, ptr @.faila.2408, i64 8, ptr @.failb.2409, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok49
  %arr.data57 = getelementptr i8, ptr %vals52, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 8
  store i32 10, ptr %arr.elem58, align 4
  %vals59 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len60 = load i64, ptr %vals59, align 8
  %arr.oob61 = icmp uge i64 9, %arr.len60
  br i1 %arr.oob61, label %idx.bad62, label %idx.ok63, !prof !2

idx.bad62:                                        ; preds = %idx.ok56
  call void @__polaron_fail(ptr @.fail.2410, ptr @.faila.2411, i64 9, ptr @.failb.2412, i64 %arr.len60, i32 70)
  unreachable

idx.ok63:                                         ; preds = %idx.ok56
  %arr.data64 = getelementptr i8, ptr %vals59, i64 8
  %arr.elem65 = getelementptr inbounds i32, ptr %arr.data64, i64 9
  store i32 9, ptr %arr.elem65, align 4
  %vals66 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len67 = load i64, ptr %vals66, align 8
  %arr.oob68 = icmp uge i64 10, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !2

idx.bad69:                                        ; preds = %idx.ok63
  call void @__polaron_fail(ptr @.fail.2413, ptr @.faila.2414, i64 10, ptr @.failb.2415, i64 %arr.len67, i32 70)
  unreachable

idx.ok70:                                         ; preds = %idx.ok63
  %arr.data71 = getelementptr i8, ptr %vals66, i64 8
  %arr.elem72 = getelementptr inbounds i32, ptr %arr.data71, i64 10
  store i32 5, ptr %arr.elem72, align 4
  %vals73 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len74 = load i64, ptr %vals73, align 8
  %arr.oob75 = icmp uge i64 11, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !2

idx.bad76:                                        ; preds = %idx.ok70
  call void @__polaron_fail(ptr @.fail.2416, ptr @.faila.2417, i64 11, ptr @.failb.2418, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %idx.ok70
  %arr.data78 = getelementptr i8, ptr %vals73, i64 8
  %arr.elem79 = getelementptr inbounds i32, ptr %arr.data78, i64 11
  store i32 4, ptr %arr.elem79, align 4
  %vals80 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %arr.len81 = load i64, ptr %vals80, align 8
  %arr.oob82 = icmp uge i64 12, %arr.len81
  br i1 %arr.oob82, label %idx.bad83, label %idx.ok84, !prof !2

idx.bad83:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.2419, ptr @.faila.2420, i64 12, ptr @.failb.2421, i64 %arr.len81, i32 70)
  unreachable

idx.ok84:                                         ; preds = %idx.ok77
  %arr.data85 = getelementptr i8, ptr %vals80, i64 8
  %arr.elem86 = getelementptr inbounds i32, ptr %arr.data85, i64 12
  store i32 1, ptr %arr.elem86, align 4
  %arr87 = call ptr @__polaron_malloc(i64 112)
  store i64 13, ptr %arr87, align 8
  %arr.data88 = getelementptr i8, ptr %arr87, i64 8
  %2 = call ptr @memset(ptr %arr.data88, i32 0, i64 104)
  store ptr %arr87, ptr %syms, align 8
  %syms89 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len90 = load i64, ptr %syms89, align 8
  %arr.oob91 = icmp uge i64 0, %arr.len90
  br i1 %arr.oob91, label %idx.bad92, label %idx.ok93, !prof !2

idx.bad92:                                        ; preds = %idx.ok84
  call void @__polaron_fail(ptr @.fail.2422, ptr @.faila.2423, i64 0, ptr @.failb.2424, i64 %arr.len90, i32 70)
  unreachable

idx.ok93:                                         ; preds = %idx.ok84
  %arr.data94 = getelementptr i8, ptr %syms89, i64 8
  %arr.elem95 = getelementptr inbounds ptr, ptr %arr.data94, i64 0
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2426)
  %3 = load ptr, ptr %arr.elem95, align 8
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy, ptr %arr.elem95, align 8
  %syms96 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len97 = load i64, ptr %syms96, align 8
  %arr.oob98 = icmp uge i64 1, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !2

idx.bad99:                                        ; preds = %idx.ok93
  call void @__polaron_fail(ptr @.fail.2427, ptr @.faila.2428, i64 1, ptr @.failb.2429, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok93
  %arr.data101 = getelementptr i8, ptr %syms96, i64 8
  %arr.elem102 = getelementptr inbounds ptr, ptr %arr.data101, i64 1
  %strcpy103 = call ptr @__polaron_str_copy(ptr @.strobj.2431)
  %4 = load ptr, ptr %arr.elem102, align 8
  call void @__polaron_str_free(ptr %4)
  store ptr %strcpy103, ptr %arr.elem102, align 8
  %syms104 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len105 = load i64, ptr %syms104, align 8
  %arr.oob106 = icmp uge i64 2, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !2

idx.bad107:                                       ; preds = %idx.ok100
  call void @__polaron_fail(ptr @.fail.2432, ptr @.faila.2433, i64 2, ptr @.failb.2434, i64 %arr.len105, i32 70)
  unreachable

idx.ok108:                                        ; preds = %idx.ok100
  %arr.data109 = getelementptr i8, ptr %syms104, i64 8
  %arr.elem110 = getelementptr inbounds ptr, ptr %arr.data109, i64 2
  %strcpy111 = call ptr @__polaron_str_copy(ptr @.strobj.2436)
  %5 = load ptr, ptr %arr.elem110, align 8
  call void @__polaron_str_free(ptr %5)
  store ptr %strcpy111, ptr %arr.elem110, align 8
  %syms112 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len113 = load i64, ptr %syms112, align 8
  %arr.oob114 = icmp uge i64 3, %arr.len113
  br i1 %arr.oob114, label %idx.bad115, label %idx.ok116, !prof !2

idx.bad115:                                       ; preds = %idx.ok108
  call void @__polaron_fail(ptr @.fail.2437, ptr @.faila.2438, i64 3, ptr @.failb.2439, i64 %arr.len113, i32 70)
  unreachable

idx.ok116:                                        ; preds = %idx.ok108
  %arr.data117 = getelementptr i8, ptr %syms112, i64 8
  %arr.elem118 = getelementptr inbounds ptr, ptr %arr.data117, i64 3
  %strcpy119 = call ptr @__polaron_str_copy(ptr @.strobj.2441)
  %6 = load ptr, ptr %arr.elem118, align 8
  call void @__polaron_str_free(ptr %6)
  store ptr %strcpy119, ptr %arr.elem118, align 8
  %syms120 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len121 = load i64, ptr %syms120, align 8
  %arr.oob122 = icmp uge i64 4, %arr.len121
  br i1 %arr.oob122, label %idx.bad123, label %idx.ok124, !prof !2

idx.bad123:                                       ; preds = %idx.ok116
  call void @__polaron_fail(ptr @.fail.2442, ptr @.faila.2443, i64 4, ptr @.failb.2444, i64 %arr.len121, i32 70)
  unreachable

idx.ok124:                                        ; preds = %idx.ok116
  %arr.data125 = getelementptr i8, ptr %syms120, i64 8
  %arr.elem126 = getelementptr inbounds ptr, ptr %arr.data125, i64 4
  %strcpy127 = call ptr @__polaron_str_copy(ptr @.strobj.2446)
  %7 = load ptr, ptr %arr.elem126, align 8
  call void @__polaron_str_free(ptr %7)
  store ptr %strcpy127, ptr %arr.elem126, align 8
  %syms128 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len129 = load i64, ptr %syms128, align 8
  %arr.oob130 = icmp uge i64 5, %arr.len129
  br i1 %arr.oob130, label %idx.bad131, label %idx.ok132, !prof !2

idx.bad131:                                       ; preds = %idx.ok124
  call void @__polaron_fail(ptr @.fail.2447, ptr @.faila.2448, i64 5, ptr @.failb.2449, i64 %arr.len129, i32 70)
  unreachable

idx.ok132:                                        ; preds = %idx.ok124
  %arr.data133 = getelementptr i8, ptr %syms128, i64 8
  %arr.elem134 = getelementptr inbounds ptr, ptr %arr.data133, i64 5
  %strcpy135 = call ptr @__polaron_str_copy(ptr @.strobj.2451)
  %8 = load ptr, ptr %arr.elem134, align 8
  call void @__polaron_str_free(ptr %8)
  store ptr %strcpy135, ptr %arr.elem134, align 8
  %syms136 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len137 = load i64, ptr %syms136, align 8
  %arr.oob138 = icmp uge i64 6, %arr.len137
  br i1 %arr.oob138, label %idx.bad139, label %idx.ok140, !prof !2

idx.bad139:                                       ; preds = %idx.ok132
  call void @__polaron_fail(ptr @.fail.2452, ptr @.faila.2453, i64 6, ptr @.failb.2454, i64 %arr.len137, i32 70)
  unreachable

idx.ok140:                                        ; preds = %idx.ok132
  %arr.data141 = getelementptr i8, ptr %syms136, i64 8
  %arr.elem142 = getelementptr inbounds ptr, ptr %arr.data141, i64 6
  %strcpy143 = call ptr @__polaron_str_copy(ptr @.strobj.2456)
  %9 = load ptr, ptr %arr.elem142, align 8
  call void @__polaron_str_free(ptr %9)
  store ptr %strcpy143, ptr %arr.elem142, align 8
  %syms144 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len145 = load i64, ptr %syms144, align 8
  %arr.oob146 = icmp uge i64 7, %arr.len145
  br i1 %arr.oob146, label %idx.bad147, label %idx.ok148, !prof !2

idx.bad147:                                       ; preds = %idx.ok140
  call void @__polaron_fail(ptr @.fail.2457, ptr @.faila.2458, i64 7, ptr @.failb.2459, i64 %arr.len145, i32 70)
  unreachable

idx.ok148:                                        ; preds = %idx.ok140
  %arr.data149 = getelementptr i8, ptr %syms144, i64 8
  %arr.elem150 = getelementptr inbounds ptr, ptr %arr.data149, i64 7
  %strcpy151 = call ptr @__polaron_str_copy(ptr @.strobj.2461)
  %10 = load ptr, ptr %arr.elem150, align 8
  call void @__polaron_str_free(ptr %10)
  store ptr %strcpy151, ptr %arr.elem150, align 8
  %syms152 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len153 = load i64, ptr %syms152, align 8
  %arr.oob154 = icmp uge i64 8, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !2

idx.bad155:                                       ; preds = %idx.ok148
  call void @__polaron_fail(ptr @.fail.2462, ptr @.faila.2463, i64 8, ptr @.failb.2464, i64 %arr.len153, i32 70)
  unreachable

idx.ok156:                                        ; preds = %idx.ok148
  %arr.data157 = getelementptr i8, ptr %syms152, i64 8
  %arr.elem158 = getelementptr inbounds ptr, ptr %arr.data157, i64 8
  %strcpy159 = call ptr @__polaron_str_copy(ptr @.strobj.2466)
  %11 = load ptr, ptr %arr.elem158, align 8
  call void @__polaron_str_free(ptr %11)
  store ptr %strcpy159, ptr %arr.elem158, align 8
  %syms160 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len161 = load i64, ptr %syms160, align 8
  %arr.oob162 = icmp uge i64 9, %arr.len161
  br i1 %arr.oob162, label %idx.bad163, label %idx.ok164, !prof !2

idx.bad163:                                       ; preds = %idx.ok156
  call void @__polaron_fail(ptr @.fail.2467, ptr @.faila.2468, i64 9, ptr @.failb.2469, i64 %arr.len161, i32 70)
  unreachable

idx.ok164:                                        ; preds = %idx.ok156
  %arr.data165 = getelementptr i8, ptr %syms160, i64 8
  %arr.elem166 = getelementptr inbounds ptr, ptr %arr.data165, i64 9
  %strcpy167 = call ptr @__polaron_str_copy(ptr @.strobj.2471)
  %12 = load ptr, ptr %arr.elem166, align 8
  call void @__polaron_str_free(ptr %12)
  store ptr %strcpy167, ptr %arr.elem166, align 8
  %syms168 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len169 = load i64, ptr %syms168, align 8
  %arr.oob170 = icmp uge i64 10, %arr.len169
  br i1 %arr.oob170, label %idx.bad171, label %idx.ok172, !prof !2

idx.bad171:                                       ; preds = %idx.ok164
  call void @__polaron_fail(ptr @.fail.2472, ptr @.faila.2473, i64 10, ptr @.failb.2474, i64 %arr.len169, i32 70)
  unreachable

idx.ok172:                                        ; preds = %idx.ok164
  %arr.data173 = getelementptr i8, ptr %syms168, i64 8
  %arr.elem174 = getelementptr inbounds ptr, ptr %arr.data173, i64 10
  %strcpy175 = call ptr @__polaron_str_copy(ptr @.strobj.2476)
  %13 = load ptr, ptr %arr.elem174, align 8
  call void @__polaron_str_free(ptr %13)
  store ptr %strcpy175, ptr %arr.elem174, align 8
  %syms176 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len177 = load i64, ptr %syms176, align 8
  %arr.oob178 = icmp uge i64 11, %arr.len177
  br i1 %arr.oob178, label %idx.bad179, label %idx.ok180, !prof !2

idx.bad179:                                       ; preds = %idx.ok172
  call void @__polaron_fail(ptr @.fail.2477, ptr @.faila.2478, i64 11, ptr @.failb.2479, i64 %arr.len177, i32 70)
  unreachable

idx.ok180:                                        ; preds = %idx.ok172
  %arr.data181 = getelementptr i8, ptr %syms176, i64 8
  %arr.elem182 = getelementptr inbounds ptr, ptr %arr.data181, i64 11
  %strcpy183 = call ptr @__polaron_str_copy(ptr @.strobj.2481)
  %14 = load ptr, ptr %arr.elem182, align 8
  call void @__polaron_str_free(ptr %14)
  store ptr %strcpy183, ptr %arr.elem182, align 8
  %syms184 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %arr.len185 = load i64, ptr %syms184, align 8
  %arr.oob186 = icmp uge i64 12, %arr.len185
  br i1 %arr.oob186, label %idx.bad187, label %idx.ok188, !prof !2

idx.bad187:                                       ; preds = %idx.ok180
  call void @__polaron_fail(ptr @.fail.2482, ptr @.faila.2483, i64 12, ptr @.failb.2484, i64 %arr.len185, i32 70)
  unreachable

idx.ok188:                                        ; preds = %idx.ok180
  %arr.data189 = getelementptr i8, ptr %syms184, i64 8
  %arr.elem190 = getelementptr inbounds ptr, ptr %arr.data189, i64 12
  %strcpy191 = call ptr @__polaron_str_copy(ptr @.strobj.2486)
  %15 = load ptr, ptr %arr.elem190, align 8
  call void @__polaron_str_free(ptr %15)
  store ptr %strcpy191, ptr %arr.elem190, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %n192 = load i32, ptr %n, align 4
  store i32 %n192, ptr %x, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok188
  %i193 = load i32, ptr %i, align 4
  %16 = icmp slt i32 %i193, 13
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  br label %while.cond

for.update:                                       ; preds = %while.end
  %18 = load i32, ptr %i, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb223 = load ptr, ptr %sb, align 8
  %20 = call ptr @StringBuilder.toString(ptr %sb223)
  %strcpy224 = call ptr @__polaron_str_copy(ptr %20)
  call void @__polaron_str_free(ptr %20)
  ret ptr %strcpy224

while.cond:                                       ; preds = %idx.ok219, %for.body
  %x194 = load i32, ptr %x, align 4
  %vals195 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %i196 = load i32, ptr %i, align 4
  %21 = sext i32 %i196 to i64
  %arr.len197 = load i64, ptr %vals195, align 8
  %arr.oob198 = icmp uge i64 %21, %arr.len197
  br i1 %arr.oob198, label %idx.bad199, label %idx.ok200, !prof !2

while.body:                                       ; preds = %idx.ok200
  %sb203 = load ptr, ptr %sb, align 8
  %syms204 = load ptr, ptr %syms, align 8, !nonnull !0, !dereferenceable !1
  %i205 = load i32, ptr %i, align 4
  %22 = sext i32 %i205 to i64
  %arr.len206 = load i64, ptr %syms204, align 8
  %arr.oob207 = icmp uge i64 %22, %arr.len206
  br i1 %arr.oob207, label %idx.bad208, label %idx.ok209, !prof !2

while.end:                                        ; preds = %idx.ok200
  br label %for.update

idx.bad199:                                       ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.2487, ptr @.faila.2488, i64 %21, ptr @.failb.2489, i64 %arr.len197, i32 70)
  unreachable

idx.ok200:                                        ; preds = %while.cond
  %arr.data201 = getelementptr i8, ptr %vals195, i64 8
  %arr.elem202 = getelementptr inbounds i32, ptr %arr.data201, i64 %21
  %elem = load i32, ptr %arr.elem202, align 4
  %23 = icmp sge i32 %x194, %elem
  %24 = zext i1 %23 to i32
  br i1 %23, label %while.body, label %while.end

idx.bad208:                                       ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.2490, ptr @.faila.2491, i64 %22, ptr @.failb.2492, i64 %arr.len206, i32 70)
  unreachable

idx.ok209:                                        ; preds = %while.body
  %arr.data210 = getelementptr i8, ptr %syms204, i64 8
  %arr.elem211 = getelementptr inbounds ptr, ptr %arr.data210, i64 %22
  %elem212 = load ptr, ptr %arr.elem211, align 8
  %25 = call ptr @StringBuilder.append(ptr %sb203, ptr %elem212)
  %x213 = load i32, ptr %x, align 4
  %vals214 = load ptr, ptr %vals, align 8, !nonnull !0, !dereferenceable !1
  %i215 = load i32, ptr %i, align 4
  %26 = sext i32 %i215 to i64
  %arr.len216 = load i64, ptr %vals214, align 8
  %arr.oob217 = icmp uge i64 %26, %arr.len216
  br i1 %arr.oob217, label %idx.bad218, label %idx.ok219, !prof !2

idx.bad218:                                       ; preds = %idx.ok209
  call void @__polaron_fail(ptr @.fail.2493, ptr @.faila.2494, i64 %26, ptr @.failb.2495, i64 %arr.len216, i32 70)
  unreachable

idx.ok219:                                        ; preds = %idx.ok209
  %arr.data220 = getelementptr i8, ptr %vals214, i64 8
  %arr.elem221 = getelementptr inbounds i32, ptr %arr.data220, i64 %26
  %elem222 = load i32, ptr %arr.elem221, align 4
  %27 = sub i32 %x213, %elem222
  store i32 %27, ptr %x, align 4
  br label %while.cond
}

define internal i32 @Roman.val(i32 %0) {
entry:
  %c = alloca i32, align 4
  store i32 %0, ptr %c, align 4
  %c1 = load i32, ptr %c, align 4
  %1 = icmp eq i32 %c1, 77
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 1000

if.end:                                           ; preds = %entry
  %c2 = load i32, ptr %c, align 4
  %3 = icmp eq i32 %c2, 68
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end
  ret i32 500

if.end4:                                          ; preds = %if.end
  %c5 = load i32, ptr %c, align 4
  %5 = icmp eq i32 %c5, 67
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end4
  ret i32 100

if.end7:                                          ; preds = %if.end4
  %c8 = load i32, ptr %c, align 4
  %7 = icmp eq i32 %c8, 76
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then9, label %if.end10

if.then9:                                         ; preds = %if.end7
  ret i32 50

if.end10:                                         ; preds = %if.end7
  %c11 = load i32, ptr %c, align 4
  %9 = icmp eq i32 %c11, 88
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then12, label %if.end13

if.then12:                                        ; preds = %if.end10
  ret i32 10

if.end13:                                         ; preds = %if.end10
  %c14 = load i32, ptr %c, align 4
  %11 = icmp eq i32 %c14, 86
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.end13
  ret i32 5

if.end16:                                         ; preds = %if.end13
  ret i32 1
}

define internal i32 @Roman.fromRoman(ptr %0) {
entry:
  %v = alloca i32, align 4
  %i = alloca i32, align 4
  %total = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store i32 0, ptr %total, align 4
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
  %6 = call i32 @Roman.val(i32 %5)
  store i32 %6, ptr %v, align 4
  %i5 = load i32, ptr %i, align 4
  %7 = add i32 %i5, 1
  %s6 = load ptr, ptr %s, align 8
  %str.len7 = getelementptr inbounds %String, ptr %s6, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %8 = trunc i64 %len8 to i32
  %9 = icmp slt i32 %7, %8
  %10 = zext i1 %9 to i32
  %sc.a = icmp ne i32 %10, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %total20 = load i32, ptr %total, align 4
  ret i32 %total20

sc.rhs:                                           ; preds = %for.body
  %v9 = load i32, ptr %v, align 4
  %s10 = load ptr, ptr %s, align 8
  %i11 = load i32, ptr %i, align 4
  %13 = add i32 %i11, 1
  %14 = sext i32 %13 to i64
  %str.data12 = getelementptr inbounds %String, ptr %s10, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %ch.addr14 = getelementptr i8, ptr %data13, i64 %14
  %ch15 = load i8, ptr %ch.addr14, align 1
  %15 = zext i8 %ch15 to i32
  %16 = call i32 @Roman.val(i32 %15)
  %17 = icmp slt i32 %v9, %16
  %18 = zext i1 %17 to i32
  %sc.b = icmp ne i32 %18, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %for.body
  %sc = phi i1 [ false, %for.body ], [ %sc.b, %sc.rhs ]
  %19 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.else

if.then:                                          ; preds = %sc.end
  %total16 = load i32, ptr %total, align 4
  %v17 = load i32, ptr %v, align 4
  %20 = sub i32 %total16, %v17
  store i32 %20, ptr %total, align 4
  br label %if.end

if.else:                                          ; preds = %sc.end
  %total18 = load i32, ptr %total, align 4
  %v19 = load i32, ptr %v, align 4
  %21 = add i32 %total18, %v19
  store i32 %21, ptr %total, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.update
}

define internal i32 @Stats.percentile(ptr %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %j = alloca i32, align 4
  %key = alloca i32, align 4
  %i17 = alloca i32, align 4
  %i = alloca i32, align 4
  %c = alloca ptr, align 8
  %n = alloca i32, align 4
  %p = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  store i32 %1, ptr %p, align 4
  %xs1 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs1, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = icmp eq i32 %n2, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %n3 = load i32, ptr %n, align 4
  %5 = sext i32 %n3 to i64
  %6 = mul i64 %5, 4
  %7 = add i64 8, %6
  %arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %8 = call ptr @memset(ptr %arr.data, i32 0, i64 %6)
  store ptr %arr, ptr %c, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %9 = icmp slt i32 %i4, %n5
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %c6 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %11 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %c6, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok14
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %i17, align 4
  br label %for.cond18

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3307, ptr @.faila.3308, i64 %11, ptr @.failb.3309, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %c6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data8, i64 %11
  %xs9 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %14 = sext i32 %i10 to i64
  %arr.len11 = load i64, ptr %xs9, align 8
  %arr.oob12 = icmp uge i64 %14, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3310, ptr @.faila.3311, i64 %14, ptr @.failb.3312, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %xs9, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %14
  %elem = load i32, ptr %arr.elem16, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

for.cond18:                                       ; preds = %for.update20, %for.end
  %i22 = load i32, ptr %i17, align 4
  %n23 = load i32, ptr %n, align 4
  %15 = icmp slt i32 %i22, %n23
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body19, label %for.end21

for.body19:                                       ; preds = %for.cond18
  %c24 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %i25 = load i32, ptr %i17, align 4
  %17 = sext i32 %i25 to i64
  %arr.len26 = load i64, ptr %c24, align 8
  %arr.oob27 = icmp uge i64 %17, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

for.update20:                                     ; preds = %idx.ok68
  %18 = load i32, ptr %i17, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i17, align 4
  br label %for.cond18

for.end21:                                        ; preds = %for.cond18
  %c72 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %p73 = load i32, ptr %p, align 4
  %n74 = load i32, ptr %n, align 4
  %20 = sub i32 %n74, 1
  %21 = mul i32 %p73, %20
  %22 = icmp eq i32 %21, -2147483648
  %23 = and i1 %22, false
  %24 = or i1 false, %23
  br i1 %24, label %div.bad, label %div.ok

idx.bad28:                                        ; preds = %for.body19
  call void @__polaron_fail(ptr @.fail.3313, ptr @.faila.3314, i64 %17, ptr @.failb.3315, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %for.body19
  %arr.data30 = getelementptr i8, ptr %c24, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %17
  %elem32 = load i32, ptr %arr.elem31, align 4
  store i32 %elem32, ptr %key, align 4
  %i33 = load i32, ptr %i17, align 4
  %25 = sub i32 %i33, 1
  store i32 %25, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok58, %idx.ok29
  %j34 = load i32, ptr %j, align 4
  %26 = icmp sge i32 %j34, 0
  %27 = zext i1 %26 to i32
  %sc.a = icmp ne i32 %27, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %c45 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %j46 = load i32, ptr %j, align 4
  %28 = add i32 %j46, 1
  %29 = sext i32 %28 to i64
  %arr.len47 = load i64, ptr %c45, align 8
  %arr.oob48 = icmp uge i64 %29, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

while.end:                                        ; preds = %sc.end
  %c63 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %j64 = load i32, ptr %j, align 4
  %30 = add i32 %j64, 1
  %31 = sext i32 %30 to i64
  %arr.len65 = load i64, ptr %c63, align 8
  %arr.oob66 = icmp uge i64 %31, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !2

sc.rhs:                                           ; preds = %while.cond
  %c35 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %j36 = load i32, ptr %j, align 4
  %32 = sext i32 %j36 to i64
  %arr.len37 = load i64, ptr %c35, align 8
  %arr.oob38 = icmp uge i64 %32, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

sc.end:                                           ; preds = %idx.ok40, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok40 ]
  %33 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad39:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3316, ptr @.faila.3317, i64 %32, ptr @.failb.3318, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %sc.rhs
  %arr.data41 = getelementptr i8, ptr %c35, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %32
  %elem43 = load i32, ptr %arr.elem42, align 4
  %key44 = load i32, ptr %key, align 4
  %34 = icmp sgt i32 %elem43, %key44
  %35 = zext i1 %34 to i32
  %sc.b = icmp ne i32 %35, 0
  br label %sc.end

idx.bad49:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.3319, ptr @.faila.3320, i64 %29, ptr @.failb.3321, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %while.body
  %arr.data51 = getelementptr i8, ptr %c45, i64 8
  %arr.elem52 = getelementptr inbounds i32, ptr %arr.data51, i64 %29
  %c53 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %j54 = load i32, ptr %j, align 4
  %36 = sext i32 %j54 to i64
  %arr.len55 = load i64, ptr %c53, align 8
  %arr.oob56 = icmp uge i64 %36, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

idx.bad57:                                        ; preds = %idx.ok50
  call void @__polaron_fail(ptr @.fail.3322, ptr @.faila.3323, i64 %36, ptr @.failb.3324, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok50
  %arr.data59 = getelementptr i8, ptr %c53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %36
  %elem61 = load i32, ptr %arr.elem60, align 4
  store i32 %elem61, ptr %arr.elem52, align 4
  %j62 = load i32, ptr %j, align 4
  %37 = sub i32 %j62, 1
  store i32 %37, ptr %j, align 4
  br label %while.cond

idx.bad67:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.3325, ptr @.faila.3326, i64 %31, ptr @.failb.3327, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %while.end
  %arr.data69 = getelementptr i8, ptr %c63, i64 8
  %arr.elem70 = getelementptr inbounds i32, ptr %arr.data69, i64 %31
  %key71 = load i32, ptr %key, align 4
  store i32 %key71, ptr %arr.elem70, align 4
  br label %for.update20

div.bad:                                          ; preds = %for.end21
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.end21
  %38 = sdiv i32 %21, 100
  %39 = sext i32 %38 to i64
  %arr.len75 = load i64, ptr %c72, align 8
  %arr.oob76 = icmp uge i64 %39, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !2

idx.bad77:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.3328, ptr @.faila.3329, i64 %39, ptr @.failb.3330, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %div.ok
  %arr.data79 = getelementptr i8, ptr %c72, i64 8
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data79, i64 %39
  %elem81 = load i32, ptr %arr.elem80, align 4
  ret i32 %elem81
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5323)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5325)
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

declare void @__polaron_str_free(ptr)

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !5, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"i64", !5, i64 0}
