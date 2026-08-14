; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/textdist_det_stats.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/textdist_det_stats.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Matrix = type { ptr, ptr, i32, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Matrix.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Matrix.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Matrix.add, ptr null, ptr @Matrix.set, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Matrix.multiply, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Matrix.rows, ptr @Matrix.cols, ptr @Matrix.transpose, ptr @Matrix.determinant, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/textdist_det_stats.pol:20:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/textdist_det_stats.pol:21:23  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/textdist_det_stats.pol:22:23  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/textdist_det_stats.pol:23:23  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/textdist_det_stats.pol:24:23  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/textdist_det_stats.pol:25:23  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [39 x i8] c"lev=%d det=%d sum=%d range=%d mode=%d\0A\00", align 1
@.strdata = private constant [7 x i8] c"kitten\00"
@.strobj = private global %String { i64 6, ptr @.strdata, i64 0 }
@.strdata.16 = private constant [8 x i8] c"sitting\00"
@.strobj.17 = private global %String { i64 7, ptr @.strdata.16, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1326 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1327 = private global %String { i64 16, ptr @.strdata.1326, i64 0 }
@.strdata.1328 = private constant [17 x i8] c"division by zero\00"
@.strobj.1329 = private global %String { i64 16, ptr @.strdata.1328, i64 0 }
@.fail.2361 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3699:64  in TextDistance.levenshtein\0A\00", align 1
@.faila.2362 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2363 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2364 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3701:28  in TextDistance.levenshtein\0A\00", align 1
@.faila.2365 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2366 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2367 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3705:25  in TextDistance.levenshtein\0A\00", align 1
@.faila.2368 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2369 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2370 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3706:25  in TextDistance.levenshtein\0A\00", align 1
@.faila.2371 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2372 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2373 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3706:59  in TextDistance.levenshtein\0A\00", align 1
@.faila.2374 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2375 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2376 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3707:25  in TextDistance.levenshtein\0A\00", align 1
@.faila.2377 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2378 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2379 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3707:63  in TextDistance.levenshtein\0A\00", align 1
@.faila.2380 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2381 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2382 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3708:32  in TextDistance.levenshtein\0A\00", align 1
@.faila.2383 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2384 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2385 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3714:17  in TextDistance.levenshtein\0A\00", align 1
@.faila.2386 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2387 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3252 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5564:67  in Stats.sum\0A\00", align 1
@.faila.3253 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3254 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3255 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5572:17  in Stats.min\0A\00", align 1
@.faila.3256 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3257 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3258 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5573:65  in Stats.min\0A\00", align 1
@.faila.3259 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3260 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3261 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5573:84  in Stats.min\0A\00", align 1
@.faila.3262 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3263 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3264 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5577:17  in Stats.max\0A\00", align 1
@.faila.3265 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3266 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3267 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5578:65  in Stats.max\0A\00", align 1
@.faila.3268 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3269 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3270 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5578:84  in Stats.max\0A\00", align 1
@.faila.3271 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3272 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3300 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5622:17  in Stats.mode\0A\00", align 1
@.faila.3301 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3302 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3303 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5627:25  in Stats.mode\0A\00", align 1
@.faila.3304 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3305 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3306 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5627:25  in Stats.mode\0A\00", align 1
@.faila.3307 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3308 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3309 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5631:30  in Stats.mode\0A\00", align 1
@.faila.3310 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3311 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3336 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5693:48  in Matrix.set\0A\00", align 1
@.faila.3337 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3338 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3339 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5696:59  in Matrix.get\0A\00", align 1
@.faila.3340 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3341 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3342 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5727:64  in Matrix.determinant\0A\00", align 1
@.faila.3343 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3344 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3345 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5727:64  in Matrix.determinant\0A\00", align 1
@.faila.3346 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3347 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3348 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5731:21  in Matrix.determinant\0A\00", align 1
@.faila.3349 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3350 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3351 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5734:29  in Matrix.determinant\0A\00", align 1
@.faila.3352 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3353 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3354 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5738:29  in Matrix.determinant\0A\00", align 1
@.faila.3355 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3356 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3357 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5739:42  in Matrix.determinant\0A\00", align 1
@.faila.3358 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3359 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3360 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5739:42  in Matrix.determinant\0A\00", align 1
@.faila.3361 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3362 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3363 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5740:43  in Matrix.determinant\0A\00", align 1
@.faila.3364 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3365 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3366 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3367 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3368 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3369 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3370 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3371 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3372 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3373 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3374 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3375 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3376 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3377 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3378 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3379 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3380 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3381 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5749:26  in Matrix.determinant\0A\00", align 1
@.faila.3382 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3383 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3384 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5751:17  in Matrix.determinant\0A\00", align 1
@.faila.3385 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3386 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5327 = private constant [1 x i8] zeroinitializer
@.strobj.5328 = private global %String { i64 0, ptr @.strdata.5327, i64 0 }
@.strdata.5329 = private constant [1 x i8] zeroinitializer
@.strobj.5330 = private global %String { i64 0, ptr @.strdata.5329, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %xs = alloca ptr, align 8
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
  %Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  call void @Matrix.Matrix(ptr %Matrix.obj, i32 2, i32 2)
  store ptr %Matrix.obj, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  call void @Matrix.set(ptr %a1, i32 0, i32 0, i32 1)
  %a2 = load ptr, ptr %a, align 8
  call void @Matrix.set(ptr %a2, i32 0, i32 1, i32 2)
  %a3 = load ptr, ptr %a, align 8
  call void @Matrix.set(ptr %a3, i32 1, i32 0, i32 3)
  %a4 = load ptr, ptr %a, align 8
  call void @Matrix.set(ptr %a4, i32 1, i32 1, i32 4)
  %arr = call ptr @__polaron_malloc(i64 32)
  store i64 6, ptr %arr, align 8
  %arr.data5 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data5, i32 0, i64 24)
  store ptr %arr, ptr %xs, align 8
  %xs6 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %xs6, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data7 = getelementptr i8, ptr %xs6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data7, i64 0
  store i32 1, ptr %arr.elem, align 4
  %xs8 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len9 = load i64, ptr %xs8, align 8
  %arr.oob10 = icmp uge i64 1, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

idx.bad11:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %idx.ok
  %arr.data13 = getelementptr i8, ptr %xs8, i64 8
  %arr.elem14 = getelementptr inbounds i32, ptr %arr.data13, i64 1
  store i32 2, ptr %arr.elem14, align 4
  %xs15 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len16 = load i64, ptr %xs15, align 8
  %arr.oob17 = icmp uge i64 2, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

idx.bad18:                                        ; preds = %idx.ok12
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok12
  %arr.data20 = getelementptr i8, ptr %xs15, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 2
  store i32 2, ptr %arr.elem21, align 4
  %xs22 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len23 = load i64, ptr %xs22, align 8
  %arr.oob24 = icmp uge i64 3, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !2

idx.bad25:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok19
  %arr.data27 = getelementptr i8, ptr %xs22, i64 8
  %arr.elem28 = getelementptr inbounds i32, ptr %arr.data27, i64 3
  store i32 3, ptr %arr.elem28, align 4
  %xs29 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len30 = load i64, ptr %xs29, align 8
  %arr.oob31 = icmp uge i64 4, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

idx.bad32:                                        ; preds = %idx.ok26
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %idx.ok26
  %arr.data34 = getelementptr i8, ptr %xs29, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 4
  store i32 3, ptr %arr.elem35, align 4
  %xs36 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len37 = load i64, ptr %xs36, align 8
  %arr.oob38 = icmp uge i64 5, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad39:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 5, ptr @.failb.15, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok33
  %arr.data41 = getelementptr i8, ptr %xs36, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 5
  store i32 3, ptr %arr.elem42, align 4
  %17 = call i32 @TextDistance.levenshtein(ptr @.strobj, ptr @.strobj.17)
  %a43 = load ptr, ptr %a, align 8
  %18 = call i32 @Matrix.determinant(ptr %a43)
  %xs44 = load ptr, ptr %xs, align 8
  %19 = call i32 @Stats.sum(ptr %xs44)
  %xs45 = load ptr, ptr %xs, align 8
  %20 = call i32 @Stats.range(ptr %xs45)
  %xs46 = load ptr, ptr %xs, align 8
  %21 = call i32 @Stats.mode(ptr %xs46)
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1327)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1329)
  ret ptr %strcpy
}

define internal i32 @TextDistance.levenshtein(ptr %0, ptr %1) {
entry:
  %t = alloca ptr, align 8
  %best = alloca i32, align 4
  %cost = alloca i32, align 4
  %j29 = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %cur = alloca ptr, align 8
  %prev = alloca ptr, align 8
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %str.len = getelementptr inbounds %String, ptr %a1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %b2 = load ptr, ptr %b, align 8
  %str.len3 = getelementptr inbounds %String, ptr %b2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %m, align 4
  %m5 = load i32, ptr %m, align 4
  %4 = add i32 %m5, 1
  %5 = sext i32 %4 to i64
  %6 = mul i64 %5, 4
  %7 = add i64 8, %6
  %arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %8 = call ptr @memset(ptr %arr.data, i32 0, i64 %6)
  store ptr %arr, ptr %prev, align 8
  %m6 = load i32, ptr %m, align 4
  %9 = add i32 %m6, 1
  %10 = sext i32 %9 to i64
  %11 = mul i64 %10, 4
  %12 = add i64 8, %11
  %arr7 = call ptr @__polaron_malloc(i64 %12)
  store i64 %10, ptr %arr7, align 8
  %arr.data8 = getelementptr i8, ptr %arr7, i64 8
  %13 = call ptr @memset(ptr %arr.data8, i32 0, i64 %11)
  store ptr %arr7, ptr %cur, align 8
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %j9 = load i32, ptr %j, align 4
  %m10 = load i32, ptr %m, align 4
  %14 = icmp sle i32 %j9, %m10
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %prev11 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j12 = load i32, ptr %j, align 4
  %16 = sext i32 %j12 to i64
  %arr.len = load i64, ptr %prev11, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %17 = load i32, ptr %j, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %i, align 4
  br label %for.cond15

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2361, ptr @.faila.2362, i64 %16, ptr @.failb.2363, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %prev11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data13, i64 %16
  %j14 = load i32, ptr %j, align 4
  store i32 %j14, ptr %arr.elem, align 4
  br label %for.update

for.cond15:                                       ; preds = %for.update17, %for.end
  %i19 = load i32, ptr %i, align 4
  %n20 = load i32, ptr %n, align 4
  %19 = icmp sle i32 %i19, %n20
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body16, label %for.end18

for.body16:                                       ; preds = %for.cond15
  %cur21 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %arr.len22 = load i64, ptr %cur21, align 8
  %arr.oob23 = icmp uge i64 0, %arr.len22
  br i1 %arr.oob23, label %idx.bad24, label %idx.ok25, !prof !2

for.update17:                                     ; preds = %for.end33
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond15

for.end18:                                        ; preds = %for.cond15
  %prev108 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %m109 = load i32, ptr %m, align 4
  %23 = sext i32 %m109 to i64
  %arr.len110 = load i64, ptr %prev108, align 8
  %arr.oob111 = icmp uge i64 %23, %arr.len110
  br i1 %arr.oob111, label %idx.bad112, label %idx.ok113, !prof !2

idx.bad24:                                        ; preds = %for.body16
  call void @__polaron_fail(ptr @.fail.2364, ptr @.faila.2365, i64 0, ptr @.failb.2366, i64 %arr.len22, i32 70)
  unreachable

idx.ok25:                                         ; preds = %for.body16
  %arr.data26 = getelementptr i8, ptr %cur21, i64 8
  %arr.elem27 = getelementptr inbounds i32, ptr %arr.data26, i64 0
  %i28 = load i32, ptr %i, align 4
  store i32 %i28, ptr %arr.elem27, align 4
  store i32 1, ptr %j29, align 4
  br label %for.cond30

for.cond30:                                       ; preds = %for.update32, %idx.ok25
  %j34 = load i32, ptr %j29, align 4
  %m35 = load i32, ptr %m, align 4
  %24 = icmp sle i32 %j34, %m35
  %25 = zext i1 %24 to i32
  br i1 %24, label %for.body31, label %for.end33

for.body31:                                       ; preds = %for.cond30
  store i32 1, ptr %cost, align 4
  %a36 = load ptr, ptr %a, align 8
  %i37 = load i32, ptr %i, align 4
  %26 = sub i32 %i37, 1
  %27 = sext i32 %26 to i64
  %str.data = getelementptr inbounds %String, ptr %a36, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %27
  %ch = load i8, ptr %ch.addr, align 1
  %28 = zext i8 %ch to i32
  %b38 = load ptr, ptr %b, align 8
  %j39 = load i32, ptr %j29, align 4
  %29 = sub i32 %j39, 1
  %30 = sext i32 %29 to i64
  %str.data40 = getelementptr inbounds %String, ptr %b38, i32 0, i32 1
  %data41 = load ptr, ptr %str.data40, align 8
  %ch.addr42 = getelementptr i8, ptr %data41, i64 %30
  %ch43 = load i8, ptr %ch.addr42, align 1
  %31 = zext i8 %ch43 to i32
  %32 = icmp eq i32 %28, %31
  %33 = zext i1 %32 to i32
  br i1 %32, label %if.then, label %if.end

for.update32:                                     ; preds = %idx.ok101
  %34 = load i32, ptr %j29, align 4
  %35 = add i32 %34, 1
  store i32 %35, ptr %j29, align 4
  br label %for.cond30

for.end33:                                        ; preds = %for.cond30
  %prev105 = load ptr, ptr %prev, align 8
  store ptr %prev105, ptr %t, align 8
  %cur106 = load ptr, ptr %cur, align 8
  store ptr %cur106, ptr %prev, align 8
  %t107 = load ptr, ptr %t, align 8
  store ptr %t107, ptr %cur, align 8
  br label %for.update17

if.then:                                          ; preds = %for.body31
  store i32 0, ptr %cost, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body31
  %prev44 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j45 = load i32, ptr %j29, align 4
  %36 = sext i32 %j45 to i64
  %arr.len46 = load i64, ptr %prev44, align 8
  %arr.oob47 = icmp uge i64 %36, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

idx.bad48:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.2367, ptr @.faila.2368, i64 %36, ptr @.failb.2369, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %if.end
  %arr.data50 = getelementptr i8, ptr %prev44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %36
  %elem = load i32, ptr %arr.elem51, align 4
  %37 = add i32 %elem, 1
  store i32 %37, ptr %best, align 4
  %cur52 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j53 = load i32, ptr %j29, align 4
  %38 = sub i32 %j53, 1
  %39 = sext i32 %38 to i64
  %arr.len54 = load i64, ptr %cur52, align 8
  %arr.oob55 = icmp uge i64 %39, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !2

idx.bad56:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.2370, ptr @.faila.2371, i64 %39, ptr @.failb.2372, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %idx.ok49
  %arr.data58 = getelementptr i8, ptr %cur52, i64 8
  %arr.elem59 = getelementptr inbounds i32, ptr %arr.data58, i64 %39
  %elem60 = load i32, ptr %arr.elem59, align 4
  %40 = add i32 %elem60, 1
  %best61 = load i32, ptr %best, align 4
  %41 = icmp slt i32 %40, %best61
  %42 = zext i1 %41 to i32
  br i1 %41, label %if.then62, label %if.end63

if.then62:                                        ; preds = %idx.ok57
  %cur64 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j65 = load i32, ptr %j29, align 4
  %43 = sub i32 %j65, 1
  %44 = sext i32 %43 to i64
  %arr.len66 = load i64, ptr %cur64, align 8
  %arr.oob67 = icmp uge i64 %44, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !2

if.end63:                                         ; preds = %idx.ok69, %idx.ok57
  %prev73 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j74 = load i32, ptr %j29, align 4
  %45 = sub i32 %j74, 1
  %46 = sext i32 %45 to i64
  %arr.len75 = load i64, ptr %prev73, align 8
  %arr.oob76 = icmp uge i64 %46, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !2

idx.bad68:                                        ; preds = %if.then62
  call void @__polaron_fail(ptr @.fail.2373, ptr @.faila.2374, i64 %44, ptr @.failb.2375, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %if.then62
  %arr.data70 = getelementptr i8, ptr %cur64, i64 8
  %arr.elem71 = getelementptr inbounds i32, ptr %arr.data70, i64 %44
  %elem72 = load i32, ptr %arr.elem71, align 4
  %47 = add i32 %elem72, 1
  store i32 %47, ptr %best, align 4
  br label %if.end63

idx.bad77:                                        ; preds = %if.end63
  call void @__polaron_fail(ptr @.fail.2376, ptr @.faila.2377, i64 %46, ptr @.failb.2378, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %if.end63
  %arr.data79 = getelementptr i8, ptr %prev73, i64 8
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data79, i64 %46
  %elem81 = load i32, ptr %arr.elem80, align 4
  %cost82 = load i32, ptr %cost, align 4
  %48 = add i32 %elem81, %cost82
  %best83 = load i32, ptr %best, align 4
  %49 = icmp slt i32 %48, %best83
  %50 = zext i1 %49 to i32
  br i1 %49, label %if.then84, label %if.end85

if.then84:                                        ; preds = %idx.ok78
  %prev86 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j87 = load i32, ptr %j29, align 4
  %51 = sub i32 %j87, 1
  %52 = sext i32 %51 to i64
  %arr.len88 = load i64, ptr %prev86, align 8
  %arr.oob89 = icmp uge i64 %52, %arr.len88
  br i1 %arr.oob89, label %idx.bad90, label %idx.ok91, !prof !2

if.end85:                                         ; preds = %idx.ok91, %idx.ok78
  %cur96 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j97 = load i32, ptr %j29, align 4
  %53 = sext i32 %j97 to i64
  %arr.len98 = load i64, ptr %cur96, align 8
  %arr.oob99 = icmp uge i64 %53, %arr.len98
  br i1 %arr.oob99, label %idx.bad100, label %idx.ok101, !prof !2

idx.bad90:                                        ; preds = %if.then84
  call void @__polaron_fail(ptr @.fail.2379, ptr @.faila.2380, i64 %52, ptr @.failb.2381, i64 %arr.len88, i32 70)
  unreachable

idx.ok91:                                         ; preds = %if.then84
  %arr.data92 = getelementptr i8, ptr %prev86, i64 8
  %arr.elem93 = getelementptr inbounds i32, ptr %arr.data92, i64 %52
  %elem94 = load i32, ptr %arr.elem93, align 4
  %cost95 = load i32, ptr %cost, align 4
  %54 = add i32 %elem94, %cost95
  store i32 %54, ptr %best, align 4
  br label %if.end85

idx.bad100:                                       ; preds = %if.end85
  call void @__polaron_fail(ptr @.fail.2382, ptr @.faila.2383, i64 %53, ptr @.failb.2384, i64 %arr.len98, i32 70)
  unreachable

idx.ok101:                                        ; preds = %if.end85
  %arr.data102 = getelementptr i8, ptr %cur96, i64 8
  %arr.elem103 = getelementptr inbounds i32, ptr %arr.data102, i64 %53
  %best104 = load i32, ptr %best, align 4
  store i32 %best104, ptr %arr.elem103, align 4
  br label %for.update32

idx.bad112:                                       ; preds = %for.end18
  call void @__polaron_fail(ptr @.fail.2385, ptr @.faila.2386, i64 %23, ptr @.failb.2387, i64 %arr.len110, i32 70)
  unreachable

idx.ok113:                                        ; preds = %for.end18
  %arr.data114 = getelementptr i8, ptr %prev108, i64 8
  %arr.elem115 = getelementptr inbounds i32, ptr %arr.data114, i64 %23
  %elem116 = load i32, ptr %arr.elem115, align 4
  ret i32 %elem116
}

define internal i32 @Stats.sum(ptr %0) {
entry:
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  store i32 0, ptr %s, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %xs2 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs2, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s3 = load i32, ptr %s, align 4
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %xs4, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s6 = load i32, ptr %s, align 4
  ret i32 %s6

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3252, ptr @.faila.3253, i64 %4, ptr @.failb.3254, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %xs4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %7 = add i32 %s3, %elem
  store i32 %7, ptr %s, align 4
  br label %for.update
}

define internal i32 @Stats.min(ptr %0) {
entry:
  %i = alloca i32, align 4
  %m = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %xs1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3255, ptr @.faila.3256, i64 0, ptr @.failb.3257, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %xs1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %m, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i2 = load i32, ptr %i, align 4
  %xs3 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs3, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i2, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len6 = load i64, ptr %xs4, align 8
  %arr.oob7 = icmp uge i64 %4, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !2

for.update:                                       ; preds = %if.end
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m23 = load i32, ptr %m, align 4
  ret i32 %m23

idx.bad8:                                         ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3258, ptr @.faila.3259, i64 %4, ptr @.failb.3260, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %for.body
  %arr.data10 = getelementptr i8, ptr %xs4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %4
  %elem12 = load i32, ptr %arr.elem11, align 4
  %m13 = load i32, ptr %m, align 4
  %7 = icmp slt i32 %elem12, %m13
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok9
  %xs14 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i15 = load i32, ptr %i, align 4
  %9 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %xs14, align 8
  %arr.oob17 = icmp uge i64 %9, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

if.end:                                           ; preds = %idx.ok19, %idx.ok9
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3261, ptr @.faila.3262, i64 %9, ptr @.failb.3263, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %xs14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %9
  %elem22 = load i32, ptr %arr.elem21, align 4
  store i32 %elem22, ptr %m, align 4
  br label %if.end
}

define internal i32 @Stats.max(ptr %0) {
entry:
  %i = alloca i32, align 4
  %m = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %xs1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3264, ptr @.faila.3265, i64 0, ptr @.failb.3266, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %xs1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %m, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i2 = load i32, ptr %i, align 4
  %xs3 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs3, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i2, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len6 = load i64, ptr %xs4, align 8
  %arr.oob7 = icmp uge i64 %4, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !2

for.update:                                       ; preds = %if.end
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m23 = load i32, ptr %m, align 4
  ret i32 %m23

idx.bad8:                                         ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3267, ptr @.faila.3268, i64 %4, ptr @.failb.3269, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %for.body
  %arr.data10 = getelementptr i8, ptr %xs4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %4
  %elem12 = load i32, ptr %arr.elem11, align 4
  %m13 = load i32, ptr %m, align 4
  %7 = icmp sgt i32 %elem12, %m13
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok9
  %xs14 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i15 = load i32, ptr %i, align 4
  %9 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %xs14, align 8
  %arr.oob17 = icmp uge i64 %9, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

if.end:                                           ; preds = %idx.ok19, %idx.ok9
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3270, ptr @.faila.3271, i64 %9, ptr @.failb.3272, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %xs14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %9
  %elem22 = load i32, ptr %arr.elem21, align 4
  store i32 %elem22, ptr %m, align 4
  br label %if.end
}

define internal i32 @Stats.range(ptr %0) {
entry:
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs1, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %xs2 = load ptr, ptr %xs, align 8
  %4 = call i32 @Stats.max(ptr %xs2)
  %xs3 = load ptr, ptr %xs, align 8
  %5 = call i32 @Stats.min(ptr %xs3)
  %6 = sub i32 %4, %5
  ret i32 %6
}

define internal i32 @Stats.mode(ptr %0) {
entry:
  %j = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %bestCount = alloca i32, align 4
  %best = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs1, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %xs2 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %xs2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.3300, ptr @.faila.3301, i64 0, ptr @.failb.3302, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %xs2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %best, align 4
  store i32 0, ptr %bestCount, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i3 = load i32, ptr %i, align 4
  %xs4 = load ptr, ptr %xs, align 8
  %len5 = load i64, ptr %xs4, align 8
  %4 = trunc i64 %len5 to i32
  %5 = icmp slt i32 %i3, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %c, align 4
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %if.end37
  %7 = load i32, ptr %i, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best48 = load i32, ptr %best, align 4
  ret i32 %best48

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %xs11 = load ptr, ptr %xs, align 8
  %len12 = load i64, ptr %xs11, align 8
  %9 = trunc i64 %len12 to i32
  %10 = icmp slt i32 %j10, %9
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %xs13 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %j14 = load i32, ptr %j, align 4
  %12 = sext i32 %j14 to i64
  %arr.len15 = load i64, ptr %xs13, align 8
  %arr.oob16 = icmp uge i64 %12, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

for.update8:                                      ; preds = %if.end32
  %13 = load i32, ptr %j, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  %c34 = load i32, ptr %c, align 4
  %bestCount35 = load i32, ptr %bestCount, align 4
  %15 = icmp sgt i32 %c34, %bestCount35
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then36, label %if.end37

idx.bad17:                                        ; preds = %for.body7
  call void @__polaron_fail(ptr @.fail.3303, ptr @.faila.3304, i64 %12, ptr @.failb.3305, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %for.body7
  %arr.data19 = getelementptr i8, ptr %xs13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %12
  %elem21 = load i32, ptr %arr.elem20, align 4
  %xs22 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i23 = load i32, ptr %i, align 4
  %17 = sext i32 %i23 to i64
  %arr.len24 = load i64, ptr %xs22, align 8
  %arr.oob25 = icmp uge i64 %17, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !2

idx.bad26:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.3306, ptr @.faila.3307, i64 %17, ptr @.failb.3308, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %idx.ok18
  %arr.data28 = getelementptr i8, ptr %xs22, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 %17
  %elem30 = load i32, ptr %arr.elem29, align 4
  %18 = icmp eq i32 %elem21, %elem30
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then31, label %if.end32

if.then31:                                        ; preds = %idx.ok27
  %c33 = load i32, ptr %c, align 4
  %20 = add i32 %c33, 1
  store i32 %20, ptr %c, align 4
  br label %if.end32

if.end32:                                         ; preds = %if.then31, %idx.ok27
  br label %for.update8

if.then36:                                        ; preds = %for.end9
  %c38 = load i32, ptr %c, align 4
  store i32 %c38, ptr %bestCount, align 4
  %xs39 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i40 = load i32, ptr %i, align 4
  %21 = sext i32 %i40 to i64
  %arr.len41 = load i64, ptr %xs39, align 8
  %arr.oob42 = icmp uge i64 %21, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !2

if.end37:                                         ; preds = %idx.ok44, %for.end9
  br label %for.update

idx.bad43:                                        ; preds = %if.then36
  call void @__polaron_fail(ptr @.fail.3309, ptr @.faila.3310, i64 %21, ptr @.failb.3311, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %if.then36
  %arr.data45 = getelementptr i8, ptr %xs39, i64 8
  %arr.elem46 = getelementptr inbounds i32, ptr %arr.data45, i64 %21
  %elem47 = load i32, ptr %arr.elem46, align 4
  store i32 %elem47, ptr %best, align 4
  br label %if.end37
}

define internal void @Matrix.Matrix(ptr %0, i32 %1, i32 %2) {
entry:
  %cols = alloca i32, align 4
  %rows = alloca i32, align 4
  store i32 %1, ptr %rows, align 4
  store i32 %2, ptr %cols, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 0
  store ptr @Matrix.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %cells = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  store ptr null, ptr %cells, align 8, !tbaa !3
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %rows1 = load i32, ptr %rows, align 4
  store i32 %rows1, ptr %nrows, align 4, !tbaa !7
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %cols2 = load i32, ptr %cols, align 4
  store i32 %cols2, ptr %ncols, align 4, !tbaa !7
  %cells3 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  %rows4 = load i32, ptr %rows, align 4
  %cols5 = load i32, ptr %cols, align 4
  %3 = mul i32 %rows4, %cols5
  %4 = sext i32 %3 to i64
  %5 = mul i64 %4, 4
  %6 = add i64 8, %5
  %arr = call ptr @__polaron_malloc(i64 %6)
  store i64 %4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %7 = call ptr @memset(ptr %arr.data, i32 0, i64 %5)
  store ptr %arr, ptr %cells3, align 8, !tbaa !3
  ret void
}

define internal i32 @Matrix.rows(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows1 = load i32, ptr %nrows, align 4, !tbaa !7
  ret i32 %nrows1
}

define internal i32 @Matrix.cols(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols1 = load i32, ptr %ncols, align 4, !tbaa !7
  ret i32 %ncols1
}

define internal void @Matrix.set(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2, i32 %3) {
entry:
  %value = alloca i32, align 4
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  store i32 %3, ptr %value, align 4
  %cells = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  %cells1 = load ptr, ptr %cells, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %r2 = load i32, ptr %r, align 4
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols3 = load i32, ptr %ncols, align 4, !tbaa !7
  %4 = mul i32 %r2, %ncols3
  %c4 = load i32, ptr %c, align 4
  %5 = add i32 %4, %c4
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %cells1, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3336, ptr @.faila.3337, i64 %6, ptr @.failb.3338, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %cells1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %value5 = load i32, ptr %value, align 4
  store i32 %value5, ptr %arr.elem, align 4
  ret void
}

define internal i32 @Matrix.get(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  %cells = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  %cells1 = load ptr, ptr %cells, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %r2 = load i32, ptr %r, align 4
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols3 = load i32, ptr %ncols, align 4, !tbaa !7
  %3 = mul i32 %r2, %ncols3
  %c4 = load i32, ptr %c, align 4
  %4 = add i32 %3, %c4
  %5 = sext i32 %4 to i64
  %arr.len = load i64, ptr %cells1, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3339, ptr @.faila.3340, i64 %5, ptr @.failb.3341, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %cells1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal ptr @Matrix.multiply(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %k = alloca i32, align 4
  %s = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %Matrix.copy = alloca %class.Matrix, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Matrix.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Matrix, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !3
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.Matrix, ptr %Matrix.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !3
  store ptr %Matrix.copy, ptr %o, align 8
  %Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows1 = load i32, ptr %nrows, align 4, !tbaa !7
  %o2 = load ptr, ptr %o, align 8
  %9 = call i32 @Matrix.cols(ptr %o2)
  call void @Matrix.Matrix(ptr %Matrix.obj, i32 %nrows1, i32 %9)
  store ptr %Matrix.obj, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %nrows4 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows5 = load i32, ptr %nrows4, align 4, !tbaa !7
  %10 = icmp slt i32 %i3, %nrows5
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m28 = load ptr, ptr %m, align 8
  ret ptr %m28

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %o11 = load ptr, ptr %o, align 8
  %14 = call i32 @Matrix.cols(ptr %o11)
  %15 = icmp slt i32 %j10, %14
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  store i32 0, ptr %s, align 4
  store i32 0, ptr %k, align 4
  br label %for.cond12

for.update8:                                      ; preds = %for.end15
  %17 = load i32, ptr %j, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update

for.cond12:                                       ; preds = %for.update14, %for.body7
  %k16 = load i32, ptr %k, align 4
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols17 = load i32, ptr %ncols, align 4, !tbaa !7
  %19 = icmp slt i32 %k16, %ncols17
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body13, label %for.end15

for.body13:                                       ; preds = %for.cond12
  %s18 = load i32, ptr %s, align 4
  %i19 = load i32, ptr %i, align 4
  %k20 = load i32, ptr %k, align 4
  %21 = call i32 @Matrix.get(ptr %0, i32 %i19, i32 %k20)
  %o21 = load ptr, ptr %o, align 8
  %k22 = load i32, ptr %k, align 4
  %j23 = load i32, ptr %j, align 4
  %22 = call i32 @Matrix.get(ptr %o21, i32 %k22, i32 %j23)
  %23 = mul i32 %21, %22
  %24 = add i32 %s18, %23
  store i32 %24, ptr %s, align 4
  br label %for.update14

for.update14:                                     ; preds = %for.body13
  %25 = load i32, ptr %k, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %k, align 4
  br label %for.cond12

for.end15:                                        ; preds = %for.cond12
  %m24 = load ptr, ptr %m, align 8
  %i25 = load i32, ptr %i, align 4
  %j26 = load i32, ptr %j, align 4
  %s27 = load i32, ptr %s, align 4
  call void @Matrix.set(ptr %m24, i32 %i25, i32 %j26, i32 %s27)
  br label %for.update8
}

define internal ptr @Matrix.transpose(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols1 = load i32, ptr %ncols, align 4, !tbaa !7
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows2 = load i32, ptr %nrows, align 4, !tbaa !7
  call void @Matrix.Matrix(ptr %Matrix.obj, i32 %ncols1, i32 %nrows2)
  store ptr %Matrix.obj, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %nrows4 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows5 = load i32, ptr %nrows4, align 4, !tbaa !7
  %1 = icmp slt i32 %i3, %nrows5
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %3 = load i32, ptr %i, align 4
  %4 = add i32 %3, 1
  store i32 %4, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m18 = load ptr, ptr %m, align 8
  ret ptr %m18

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %ncols11 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols12 = load i32, ptr %ncols11, align 4, !tbaa !7
  %5 = icmp slt i32 %j10, %ncols12
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %m13 = load ptr, ptr %m, align 8
  %j14 = load i32, ptr %j, align 4
  %i15 = load i32, ptr %i, align 4
  %i16 = load i32, ptr %i, align 4
  %j17 = load i32, ptr %j, align 4
  %7 = call i32 @Matrix.get(ptr %0, i32 %i16, i32 %j17)
  call void @Matrix.set(ptr %m13, i32 %j14, i32 %i15, i32 %7)
  br label %for.update8

for.update8:                                      ; preds = %for.body7
  %8 = load i32, ptr %j, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update
}

define internal ptr @Matrix.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %Matrix.copy = alloca %class.Matrix, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Matrix.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Matrix, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !3
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.Matrix, ptr %Matrix.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !3
  store ptr %Matrix.copy, ptr %o, align 8
  %Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows1 = load i32, ptr %nrows, align 4, !tbaa !7
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols2 = load i32, ptr %ncols, align 4, !tbaa !7
  call void @Matrix.Matrix(ptr %Matrix.obj, i32 %nrows1, i32 %ncols2)
  store ptr %Matrix.obj, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %nrows4 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows5 = load i32, ptr %nrows4, align 4, !tbaa !7
  %9 = icmp slt i32 %i3, %nrows5
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m21 = load ptr, ptr %m, align 8
  ret ptr %m21

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %ncols11 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols12 = load i32, ptr %ncols11, align 4, !tbaa !7
  %13 = icmp slt i32 %j10, %ncols12
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %m13 = load ptr, ptr %m, align 8
  %i14 = load i32, ptr %i, align 4
  %j15 = load i32, ptr %j, align 4
  %i16 = load i32, ptr %i, align 4
  %j17 = load i32, ptr %j, align 4
  %15 = call i32 @Matrix.get(ptr %0, i32 %i16, i32 %j17)
  %o18 = load ptr, ptr %o, align 8
  %i19 = load i32, ptr %i, align 4
  %j20 = load i32, ptr %j, align 4
  %16 = call i32 @Matrix.get(ptr %o18, i32 %i19, i32 %j20)
  %17 = add i32 %15, %16
  call void @Matrix.set(ptr %m13, i32 %i14, i32 %j15, i32 %17)
  br label %for.update8

for.update8:                                      ; preds = %for.body7
  %18 = load i32, ptr %j, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update
}

define internal i32 @Matrix.determinant(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %j = alloca i32, align 4
  %i110 = alloca i32, align 4
  %t = alloca i32, align 4
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  %sw = alloca i32, align 4
  %k = alloca i32, align 4
  %sign = alloca i32, align 4
  %prev = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %n = alloca i32, align 4
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows1 = load i32, ptr %nrows, align 4, !tbaa !7
  store i32 %nrows1, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  %n3 = load i32, ptr %n, align 4
  %1 = mul i32 %n2, %n3
  %2 = sext i32 %1 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %n6 = load i32, ptr %n, align 4
  %6 = mul i32 %n5, %n6
  %7 = icmp slt i32 %i4, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %m7 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %i8 = load i32, ptr %i, align 4
  %9 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %m7, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok15
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %prev, align 4
  store i32 1, ptr %sign, align 4
  store i32 0, ptr %k, align 4
  br label %for.cond18

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3342, ptr @.faila.3343, i64 %9, ptr @.failb.3344, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data9 = getelementptr i8, ptr %m7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 %9
  %cells = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  %cells10 = load ptr, ptr %cells, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i11 = load i32, ptr %i, align 4
  %12 = sext i32 %i11 to i64
  %arr.len12 = load i64, ptr %cells10, align 8
  %arr.oob13 = icmp uge i64 %12, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3345, ptr @.faila.3346, i64 %12, ptr @.failb.3347, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %cells10, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %12
  %elem = load i32, ptr %arr.elem17, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

for.cond18:                                       ; preds = %for.update20, %for.end
  %k22 = load i32, ptr %k, align 4
  %n23 = load i32, ptr %n, align 4
  %13 = sub i32 %n23, 1
  %14 = icmp slt i32 %k22, %13
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body19, label %for.end21

for.body19:                                       ; preds = %for.cond18
  %m24 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %k25 = load i32, ptr %k, align 4
  %n26 = load i32, ptr %n, align 4
  %16 = mul i32 %k25, %n26
  %k27 = load i32, ptr %k, align 4
  %17 = add i32 %16, %k27
  %18 = sext i32 %17 to i64
  %arr.len28 = load i64, ptr %m24, align 8
  %arr.oob29 = icmp uge i64 %18, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

for.update20:                                     ; preds = %idx.ok186
  %19 = load i32, ptr %k, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %k, align 4
  br label %for.cond18

for.end21:                                        ; preds = %for.cond18
  %sign190 = load i32, ptr %sign, align 4
  %m191 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %n192 = load i32, ptr %n, align 4
  %21 = sub i32 %n192, 1
  %n193 = load i32, ptr %n, align 4
  %22 = mul i32 %21, %n193
  %n194 = load i32, ptr %n, align 4
  %23 = sub i32 %n194, 1
  %24 = add i32 %22, %23
  %25 = sext i32 %24 to i64
  %arr.len195 = load i64, ptr %m191, align 8
  %arr.oob196 = icmp uge i64 %25, %arr.len195
  br i1 %arr.oob196, label %idx.bad197, label %idx.ok198, !prof !2

idx.bad30:                                        ; preds = %for.body19
  call void @__polaron_fail(ptr @.fail.3348, ptr @.faila.3349, i64 %18, ptr @.failb.3350, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %for.body19
  %arr.data32 = getelementptr i8, ptr %m24, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %18
  %elem34 = load i32, ptr %arr.elem33, align 4
  %26 = icmp eq i32 %elem34, 0
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok31
  store i32 -1, ptr %sw, align 4
  %k35 = load i32, ptr %k, align 4
  %28 = add i32 %k35, 1
  store i32 %28, ptr %r, align 4
  br label %for.cond36

if.end:                                           ; preds = %for.end62, %idx.ok31
  %k109 = load i32, ptr %k, align 4
  %29 = add i32 %k109, 1
  store i32 %29, ptr %i110, align 4
  br label %for.cond111

for.cond36:                                       ; preds = %for.update38, %if.then
  %r40 = load i32, ptr %r, align 4
  %n41 = load i32, ptr %n, align 4
  %30 = icmp slt i32 %r40, %n41
  %31 = zext i1 %30 to i32
  br i1 %30, label %for.body37, label %for.end39

for.body37:                                       ; preds = %for.cond36
  %m42 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %r43 = load i32, ptr %r, align 4
  %n44 = load i32, ptr %n, align 4
  %32 = mul i32 %r43, %n44
  %k45 = load i32, ptr %k, align 4
  %33 = add i32 %32, %k45
  %34 = sext i32 %33 to i64
  %arr.len46 = load i64, ptr %m42, align 8
  %arr.oob47 = icmp uge i64 %34, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

for.update38:                                     ; preds = %if.end54
  %35 = load i32, ptr %r, align 4
  %36 = add i32 %35, 1
  store i32 %36, ptr %r, align 4
  br label %for.cond36

for.end39:                                        ; preds = %for.cond36
  %sw56 = load i32, ptr %sw, align 4
  %37 = icmp slt i32 %sw56, 0
  %38 = zext i1 %37 to i32
  br i1 %37, label %if.then57, label %if.end58

idx.bad48:                                        ; preds = %for.body37
  call void @__polaron_fail(ptr @.fail.3351, ptr @.faila.3352, i64 %34, ptr @.failb.3353, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %for.body37
  %arr.data50 = getelementptr i8, ptr %m42, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %34
  %elem52 = load i32, ptr %arr.elem51, align 4
  %39 = icmp ne i32 %elem52, 0
  %40 = zext i1 %39 to i32
  br i1 %39, label %if.then53, label %if.end54

if.then53:                                        ; preds = %idx.ok49
  %r55 = load i32, ptr %r, align 4
  store i32 %r55, ptr %sw, align 4
  br label %if.end54

if.end54:                                         ; preds = %if.then53, %idx.ok49
  br label %for.update38

if.then57:                                        ; preds = %for.end39
  ret i32 0

if.end58:                                         ; preds = %for.end39
  store i32 0, ptr %c, align 4
  br label %for.cond59

for.cond59:                                       ; preds = %for.update61, %if.end58
  %c63 = load i32, ptr %c, align 4
  %n64 = load i32, ptr %n, align 4
  %41 = icmp slt i32 %c63, %n64
  %42 = zext i1 %41 to i32
  br i1 %41, label %for.body60, label %for.end62

for.body60:                                       ; preds = %for.cond59
  %m65 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %k66 = load i32, ptr %k, align 4
  %n67 = load i32, ptr %n, align 4
  %43 = mul i32 %k66, %n67
  %c68 = load i32, ptr %c, align 4
  %44 = add i32 %43, %c68
  %45 = sext i32 %44 to i64
  %arr.len69 = load i64, ptr %m65, align 8
  %arr.oob70 = icmp uge i64 %45, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !2

for.update61:                                     ; preds = %idx.ok104
  %46 = load i32, ptr %c, align 4
  %47 = add i32 %46, 1
  store i32 %47, ptr %c, align 4
  br label %for.cond59

for.end62:                                        ; preds = %for.cond59
  %sign108 = load i32, ptr %sign, align 4
  %48 = sub i32 0, %sign108
  store i32 %48, ptr %sign, align 4
  br label %if.end

idx.bad71:                                        ; preds = %for.body60
  call void @__polaron_fail(ptr @.fail.3354, ptr @.faila.3355, i64 %45, ptr @.failb.3356, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %for.body60
  %arr.data73 = getelementptr i8, ptr %m65, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %45
  %elem75 = load i32, ptr %arr.elem74, align 4
  store i32 %elem75, ptr %t, align 4
  %m76 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %k77 = load i32, ptr %k, align 4
  %n78 = load i32, ptr %n, align 4
  %49 = mul i32 %k77, %n78
  %c79 = load i32, ptr %c, align 4
  %50 = add i32 %49, %c79
  %51 = sext i32 %50 to i64
  %arr.len80 = load i64, ptr %m76, align 8
  %arr.oob81 = icmp uge i64 %51, %arr.len80
  br i1 %arr.oob81, label %idx.bad82, label %idx.ok83, !prof !2

idx.bad82:                                        ; preds = %idx.ok72
  call void @__polaron_fail(ptr @.fail.3357, ptr @.faila.3358, i64 %51, ptr @.failb.3359, i64 %arr.len80, i32 70)
  unreachable

idx.ok83:                                         ; preds = %idx.ok72
  %arr.data84 = getelementptr i8, ptr %m76, i64 8
  %arr.elem85 = getelementptr inbounds i32, ptr %arr.data84, i64 %51
  %m86 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %sw87 = load i32, ptr %sw, align 4
  %n88 = load i32, ptr %n, align 4
  %52 = mul i32 %sw87, %n88
  %c89 = load i32, ptr %c, align 4
  %53 = add i32 %52, %c89
  %54 = sext i32 %53 to i64
  %arr.len90 = load i64, ptr %m86, align 8
  %arr.oob91 = icmp uge i64 %54, %arr.len90
  br i1 %arr.oob91, label %idx.bad92, label %idx.ok93, !prof !2

idx.bad92:                                        ; preds = %idx.ok83
  call void @__polaron_fail(ptr @.fail.3360, ptr @.faila.3361, i64 %54, ptr @.failb.3362, i64 %arr.len90, i32 70)
  unreachable

idx.ok93:                                         ; preds = %idx.ok83
  %arr.data94 = getelementptr i8, ptr %m86, i64 8
  %arr.elem95 = getelementptr inbounds i32, ptr %arr.data94, i64 %54
  %elem96 = load i32, ptr %arr.elem95, align 4
  store i32 %elem96, ptr %arr.elem85, align 4
  %m97 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %sw98 = load i32, ptr %sw, align 4
  %n99 = load i32, ptr %n, align 4
  %55 = mul i32 %sw98, %n99
  %c100 = load i32, ptr %c, align 4
  %56 = add i32 %55, %c100
  %57 = sext i32 %56 to i64
  %arr.len101 = load i64, ptr %m97, align 8
  %arr.oob102 = icmp uge i64 %57, %arr.len101
  br i1 %arr.oob102, label %idx.bad103, label %idx.ok104, !prof !2

idx.bad103:                                       ; preds = %idx.ok93
  call void @__polaron_fail(ptr @.fail.3363, ptr @.faila.3364, i64 %57, ptr @.failb.3365, i64 %arr.len101, i32 70)
  unreachable

idx.ok104:                                        ; preds = %idx.ok93
  %arr.data105 = getelementptr i8, ptr %m97, i64 8
  %arr.elem106 = getelementptr inbounds i32, ptr %arr.data105, i64 %57
  %t107 = load i32, ptr %t, align 4
  store i32 %t107, ptr %arr.elem106, align 4
  br label %for.update61

for.cond111:                                      ; preds = %for.update113, %if.end
  %i115 = load i32, ptr %i110, align 4
  %n116 = load i32, ptr %n, align 4
  %58 = icmp slt i32 %i115, %n116
  %59 = zext i1 %58 to i32
  br i1 %58, label %for.body112, label %for.end114

for.body112:                                      ; preds = %for.cond111
  %k117 = load i32, ptr %k, align 4
  %60 = add i32 %k117, 1
  store i32 %60, ptr %j, align 4
  br label %for.cond118

for.update113:                                    ; preds = %for.end121
  %61 = load i32, ptr %i110, align 4
  %62 = add i32 %61, 1
  store i32 %62, ptr %i110, align 4
  br label %for.cond111

for.end114:                                       ; preds = %for.cond111
  %m179 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %k180 = load i32, ptr %k, align 4
  %n181 = load i32, ptr %n, align 4
  %63 = mul i32 %k180, %n181
  %k182 = load i32, ptr %k, align 4
  %64 = add i32 %63, %k182
  %65 = sext i32 %64 to i64
  %arr.len183 = load i64, ptr %m179, align 8
  %arr.oob184 = icmp uge i64 %65, %arr.len183
  br i1 %arr.oob184, label %idx.bad185, label %idx.ok186, !prof !2

for.cond118:                                      ; preds = %for.update120, %for.body112
  %j122 = load i32, ptr %j, align 4
  %n123 = load i32, ptr %n, align 4
  %66 = icmp slt i32 %j122, %n123
  %67 = zext i1 %66 to i32
  br i1 %66, label %for.body119, label %for.end121

for.body119:                                      ; preds = %for.cond118
  %m124 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %i125 = load i32, ptr %i110, align 4
  %n126 = load i32, ptr %n, align 4
  %68 = mul i32 %i125, %n126
  %j127 = load i32, ptr %j, align 4
  %69 = add i32 %68, %j127
  %70 = sext i32 %69 to i64
  %arr.len128 = load i64, ptr %m124, align 8
  %arr.oob129 = icmp uge i64 %70, %arr.len128
  br i1 %arr.oob129, label %idx.bad130, label %idx.ok131, !prof !2

for.update120:                                    ; preds = %div.ok
  %71 = load i32, ptr %j, align 4
  %72 = add i32 %71, 1
  store i32 %72, ptr %j, align 4
  br label %for.cond118

for.end121:                                       ; preds = %for.cond118
  br label %for.update113

idx.bad130:                                       ; preds = %for.body119
  call void @__polaron_fail(ptr @.fail.3366, ptr @.faila.3367, i64 %70, ptr @.failb.3368, i64 %arr.len128, i32 70)
  unreachable

idx.ok131:                                        ; preds = %for.body119
  %arr.data132 = getelementptr i8, ptr %m124, i64 8
  %arr.elem133 = getelementptr inbounds i32, ptr %arr.data132, i64 %70
  %m134 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %i135 = load i32, ptr %i110, align 4
  %n136 = load i32, ptr %n, align 4
  %73 = mul i32 %i135, %n136
  %j137 = load i32, ptr %j, align 4
  %74 = add i32 %73, %j137
  %75 = sext i32 %74 to i64
  %arr.len138 = load i64, ptr %m134, align 8
  %arr.oob139 = icmp uge i64 %75, %arr.len138
  br i1 %arr.oob139, label %idx.bad140, label %idx.ok141, !prof !2

idx.bad140:                                       ; preds = %idx.ok131
  call void @__polaron_fail(ptr @.fail.3369, ptr @.faila.3370, i64 %75, ptr @.failb.3371, i64 %arr.len138, i32 70)
  unreachable

idx.ok141:                                        ; preds = %idx.ok131
  %arr.data142 = getelementptr i8, ptr %m134, i64 8
  %arr.elem143 = getelementptr inbounds i32, ptr %arr.data142, i64 %75
  %elem144 = load i32, ptr %arr.elem143, align 4
  %m145 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %k146 = load i32, ptr %k, align 4
  %n147 = load i32, ptr %n, align 4
  %76 = mul i32 %k146, %n147
  %k148 = load i32, ptr %k, align 4
  %77 = add i32 %76, %k148
  %78 = sext i32 %77 to i64
  %arr.len149 = load i64, ptr %m145, align 8
  %arr.oob150 = icmp uge i64 %78, %arr.len149
  br i1 %arr.oob150, label %idx.bad151, label %idx.ok152, !prof !2

idx.bad151:                                       ; preds = %idx.ok141
  call void @__polaron_fail(ptr @.fail.3372, ptr @.faila.3373, i64 %78, ptr @.failb.3374, i64 %arr.len149, i32 70)
  unreachable

idx.ok152:                                        ; preds = %idx.ok141
  %arr.data153 = getelementptr i8, ptr %m145, i64 8
  %arr.elem154 = getelementptr inbounds i32, ptr %arr.data153, i64 %78
  %elem155 = load i32, ptr %arr.elem154, align 4
  %79 = mul i32 %elem144, %elem155
  %m156 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %i157 = load i32, ptr %i110, align 4
  %n158 = load i32, ptr %n, align 4
  %80 = mul i32 %i157, %n158
  %k159 = load i32, ptr %k, align 4
  %81 = add i32 %80, %k159
  %82 = sext i32 %81 to i64
  %arr.len160 = load i64, ptr %m156, align 8
  %arr.oob161 = icmp uge i64 %82, %arr.len160
  br i1 %arr.oob161, label %idx.bad162, label %idx.ok163, !prof !2

idx.bad162:                                       ; preds = %idx.ok152
  call void @__polaron_fail(ptr @.fail.3375, ptr @.faila.3376, i64 %82, ptr @.failb.3377, i64 %arr.len160, i32 70)
  unreachable

idx.ok163:                                        ; preds = %idx.ok152
  %arr.data164 = getelementptr i8, ptr %m156, i64 8
  %arr.elem165 = getelementptr inbounds i32, ptr %arr.data164, i64 %82
  %elem166 = load i32, ptr %arr.elem165, align 4
  %m167 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %k168 = load i32, ptr %k, align 4
  %n169 = load i32, ptr %n, align 4
  %83 = mul i32 %k168, %n169
  %j170 = load i32, ptr %j, align 4
  %84 = add i32 %83, %j170
  %85 = sext i32 %84 to i64
  %arr.len171 = load i64, ptr %m167, align 8
  %arr.oob172 = icmp uge i64 %85, %arr.len171
  br i1 %arr.oob172, label %idx.bad173, label %idx.ok174, !prof !2

idx.bad173:                                       ; preds = %idx.ok163
  call void @__polaron_fail(ptr @.fail.3378, ptr @.faila.3379, i64 %85, ptr @.failb.3380, i64 %arr.len171, i32 70)
  unreachable

idx.ok174:                                        ; preds = %idx.ok163
  %arr.data175 = getelementptr i8, ptr %m167, i64 8
  %arr.elem176 = getelementptr inbounds i32, ptr %arr.data175, i64 %85
  %elem177 = load i32, ptr %arr.elem176, align 4
  %86 = mul i32 %elem166, %elem177
  %87 = sub i32 %79, %86
  %prev178 = load i32, ptr %prev, align 4
  %88 = icmp eq i32 %prev178, 0
  %89 = icmp eq i32 %87, -2147483648
  %90 = icmp eq i32 %prev178, -1
  %91 = and i1 %89, %90
  %92 = or i1 %88, %91
  br i1 %92, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok174
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok174
  %93 = sdiv i32 %87, %prev178
  store i32 %93, ptr %arr.elem133, align 4
  br label %for.update120

idx.bad185:                                       ; preds = %for.end114
  call void @__polaron_fail(ptr @.fail.3381, ptr @.faila.3382, i64 %65, ptr @.failb.3383, i64 %arr.len183, i32 70)
  unreachable

idx.ok186:                                        ; preds = %for.end114
  %arr.data187 = getelementptr i8, ptr %m179, i64 8
  %arr.elem188 = getelementptr inbounds i32, ptr %arr.data187, i64 %65
  %elem189 = load i32, ptr %arr.elem188, align 4
  store i32 %elem189, ptr %prev, align 4
  br label %for.update20

idx.bad197:                                       ; preds = %for.end21
  call void @__polaron_fail(ptr @.fail.3384, ptr @.faila.3385, i64 %25, ptr @.failb.3386, i64 %arr.len195, i32 70)
  unreachable

idx.ok198:                                        ; preds = %for.end21
  %arr.data199 = getelementptr i8, ptr %m191, i64 8
  %arr.elem200 = getelementptr inbounds i32, ptr %arr.data199, i64 %25
  %elem201 = load i32, ptr %arr.elem200, align 4
  %94 = mul i32 %sign190, %elem201
  ret i32 %94
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5328)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5330)
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
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !5, i64 0}
