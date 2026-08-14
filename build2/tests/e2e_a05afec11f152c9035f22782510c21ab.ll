; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_kit.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_kit.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Rational = type { ptr, i32, i32 }
%class.Complex = type { ptr, double, double }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Rational.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Rational.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Rational.numerator, ptr @Rational.denominator, ptr @Rational.sub, ptr @Rational.mul, ptr @Rational.toDouble, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Complex.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Complex.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Complex.sub, ptr @Complex.mul, ptr null, ptr @Complex.real, ptr @Complex.imag, ptr @Complex.conjugate, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [52 x i8] c"gcd=%d lcm=%d fact=%d p7=%d p8=%d isqrt=%d ipow=%d\0A\00", align 1
@.fail = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_kit.pol:22:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_kit.pol:23:23  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_kit.pol:24:23  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_kit.pol:25:23  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_kit.pol:26:23  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.13 = private unnamed_addr constant [50 x i8] c"rat=%d/%d cx=%d+%di sum=%d mean=%d min=%d max=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1320 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1321 = private global %String { i64 16, ptr @.strdata.1320, i64 0 }
@.strdata.1322 = private constant [17 x i8] c"division by zero\00"
@.strobj.1323 = private global %String { i64 16, ptr @.strdata.1322, i64 0 }
@.fail.3246 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5564:67  in Stats.sum\0A\00", align 1
@.faila.3247 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3248 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3249 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5572:17  in Stats.min\0A\00", align 1
@.faila.3250 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3251 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3252 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5573:65  in Stats.min\0A\00", align 1
@.faila.3253 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3254 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3255 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5573:84  in Stats.min\0A\00", align 1
@.faila.3256 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3257 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3258 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5577:17  in Stats.max\0A\00", align 1
@.faila.3259 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3260 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3261 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5578:65  in Stats.max\0A\00", align 1
@.faila.3262 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3263 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3264 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5578:84  in Stats.max\0A\00", align 1
@.faila.3265 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3266 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %xs = alloca ptr, align 8
  %q = alloca ptr, align 8
  %p = alloca ptr, align 8
  %s = alloca ptr, align 8
  %r = alloca ptr, align 8
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
  %16 = call i32 @IntMath.gcd(i32 12, i32 18)
  %17 = call i32 @IntMath.lcm(i32 4, i32 6)
  %18 = call i32 @IntMath.factorial(i32 5)
  %19 = call i32 @IntMath.isPrime(i32 7)
  %20 = call i32 @IntMath.isPrime(i32 8)
  %21 = call i32 @IntMath.isqrt(i32 50)
  %22 = call i32 @IntMath.ipow(i32 2, i32 10)
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22)
  %Rational.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Rational, ptr null, i64 1) to i64))
  call void @Rational.Rational(ptr %Rational.obj, i32 1, i32 2)
  store ptr %Rational.obj, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %Rational.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Rational, ptr null, i64 1) to i64))
  call void @Rational.Rational(ptr %Rational.obj2, i32 1, i32 3)
  %24 = call ptr @Rational.add(ptr %r1, ptr %Rational.obj2)
  call void @__polaron_check_live(ptr %Rational.obj2)
  %vtbl.addr = getelementptr inbounds %class.Rational, ptr %Rational.obj2, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %25 = icmp ne ptr %dtor.fn, null
  br i1 %25, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %argv.end
  call void %dtor.fn(ptr %Rational.obj2)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %argv.end
  call void @__polaron_free(ptr %Rational.obj2)
  store ptr %24, ptr %s, align 8
  %Complex.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  call void @Complex.Complex(ptr %Complex.obj, double 1.000000e+00, double 2.000000e+00)
  store ptr %Complex.obj, ptr %p, align 8
  %p3 = load ptr, ptr %p, align 8
  %Complex.obj4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  call void @Complex.Complex(ptr %Complex.obj4, double 3.000000e+00, double 4.000000e+00)
  %26 = call ptr @Complex.mul(ptr %p3, ptr %Complex.obj4)
  call void @__polaron_check_live(ptr %Complex.obj4)
  %vtbl.addr5 = getelementptr inbounds %class.Complex, ptr %Complex.obj4, i32 0, i32 0
  %vtbl6 = load ptr, ptr %vtbl.addr5, align 8, !tbaa !0
  %dtor.slot7 = getelementptr [349 x ptr], ptr %vtbl6, i64 0, i64 348
  %dtor.fn8 = load ptr, ptr %dtor.slot7, align 8
  %27 = icmp ne ptr %dtor.fn8, null
  br i1 %27, label %dtor.call9, label %dtor.free10

dtor.call9:                                       ; preds = %dtor.free
  call void %dtor.fn8(ptr %Complex.obj4)
  br label %dtor.free10

dtor.free10:                                      ; preds = %dtor.call9, %dtor.free
  call void @__polaron_free(ptr %Complex.obj4)
  store ptr %26, ptr %q, align 8
  %arr = call ptr @__polaron_malloc(i64 28)
  store i64 5, ptr %arr, align 8
  %arr.data11 = getelementptr i8, ptr %arr, i64 8
  %28 = call ptr @memset(ptr %arr.data11, i32 0, i64 20)
  store ptr %arr, ptr %xs, align 8
  %xs12 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %arr.len = load i64, ptr %xs12, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %dtor.free10
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %dtor.free10
  %arr.data13 = getelementptr i8, ptr %xs12, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data13, i64 0
  store i32 4, ptr %arr.elem, align 4
  %xs14 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %arr.len15 = load i64, ptr %xs14, align 8
  %arr.oob16 = icmp uge i64 1, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !6

idx.bad17:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok
  %arr.data19 = getelementptr i8, ptr %xs14, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 1
  store i32 8, ptr %arr.elem20, align 4
  %xs21 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %arr.len22 = load i64, ptr %xs21, align 8
  %arr.oob23 = icmp uge i64 2, %arr.len22
  br i1 %arr.oob23, label %idx.bad24, label %idx.ok25, !prof !6

idx.bad24:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len22, i32 70)
  unreachable

idx.ok25:                                         ; preds = %idx.ok18
  %arr.data26 = getelementptr i8, ptr %xs21, i64 8
  %arr.elem27 = getelementptr inbounds i32, ptr %arr.data26, i64 2
  store i32 15, ptr %arr.elem27, align 4
  %xs28 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %arr.len29 = load i64, ptr %xs28, align 8
  %arr.oob30 = icmp uge i64 3, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !6

idx.bad31:                                        ; preds = %idx.ok25
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok25
  %arr.data33 = getelementptr i8, ptr %xs28, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 3
  store i32 16, ptr %arr.elem34, align 4
  %xs35 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %arr.len36 = load i64, ptr %xs35, align 8
  %arr.oob37 = icmp uge i64 4, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !6

idx.bad38:                                        ; preds = %idx.ok32
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok32
  %arr.data40 = getelementptr i8, ptr %xs35, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 4
  store i32 23, ptr %arr.elem41, align 4
  %s42 = load ptr, ptr %s, align 8
  %29 = call i32 @Rational.numerator(ptr %s42)
  %s43 = load ptr, ptr %s, align 8
  %30 = call i32 @Rational.denominator(ptr %s43)
  %q44 = load ptr, ptr %q, align 8
  %31 = call double @Complex.real(ptr %q44)
  %32 = call i32 @llvm.fptosi.sat.i32.f64(double %31)
  %q45 = load ptr, ptr %q, align 8
  %33 = call double @Complex.imag(ptr %q45)
  %34 = call i32 @llvm.fptosi.sat.i32.f64(double %33)
  %xs46 = load ptr, ptr %xs, align 8
  %35 = call i32 @Stats.sum(ptr %xs46)
  %xs47 = load ptr, ptr %xs, align 8
  %36 = call i32 @Stats.mean(ptr %xs47)
  %xs48 = load ptr, ptr %xs, align 8
  %37 = call i32 @Stats.min(ptr %xs48)
  %xs49 = load ptr, ptr %xs, align 8
  %38 = call i32 @Stats.max(ptr %xs49)
  %39 = call i32 (ptr, ...) @printf(ptr @.str.13, i32 %29, i32 %30, i32 %32, i32 %34, i32 %35, i32 %36, i32 %37, i32 %38)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1321)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1323)
  ret ptr %strcpy
}

define internal i32 @IntMath.gcd(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %t = alloca i32, align 4
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  store i32 %1, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  store i32 %a1, ptr %x, align 4
  %x2 = load i32, ptr %x, align 4
  %2 = icmp slt i32 %x2, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %x3 = load i32, ptr %x, align 4
  %4 = sub i32 0, %x3
  store i32 %4, ptr %x, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %b4 = load i32, ptr %b, align 4
  store i32 %b4, ptr %y, align 4
  %y5 = load i32, ptr %y, align 4
  %5 = icmp slt i32 %y5, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end
  %y8 = load i32, ptr %y, align 4
  %7 = sub i32 0, %y8
  store i32 %7, ptr %y, align 4
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.end
  br label %while.cond

while.cond:                                       ; preds = %div.ok, %if.end7
  %y9 = load i32, ptr %y, align 4
  %8 = icmp ne i32 %y9, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %y10 = load i32, ptr %y, align 4
  store i32 %y10, ptr %t, align 4
  %x11 = load i32, ptr %x, align 4
  %y12 = load i32, ptr %y, align 4
  %10 = icmp eq i32 %y12, 0
  %11 = icmp eq i32 %x11, -2147483648
  %12 = icmp eq i32 %y12, -1
  %13 = and i1 %11, %12
  %14 = or i1 %10, %13
  br i1 %14, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  %x14 = load i32, ptr %x, align 4
  ret i32 %x14

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %15 = srem i32 %x11, %y12
  store i32 %15, ptr %y, align 4
  %t13 = load i32, ptr %t, align 4
  store i32 %t13, ptr %x, align 4
  br label %while.cond
}

define internal i32 @IntMath.lcm(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %r = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %g = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4
  store i32 %1, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %2 = icmp eq i32 %a1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %b2 = load i32, ptr %b, align 4
  %4 = icmp eq i32 %b2, 0
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i32 0

if.end:                                           ; preds = %sc.end
  %a3 = load i32, ptr %a, align 4
  %b4 = load i32, ptr %b, align 4
  %7 = call i32 @IntMath.gcd(i32 %a3, i32 %b4)
  store i32 %7, ptr %g, align 4
  %a5 = load i32, ptr %a, align 4
  %g6 = load i32, ptr %g, align 4
  %8 = icmp eq i32 %g6, 0
  %9 = icmp eq i32 %a5, -2147483648
  %10 = icmp eq i32 %g6, -1
  %11 = and i1 %9, %10
  %12 = or i1 %8, %11
  br i1 %12, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end
  %13 = sdiv i32 %a5, %g6
  %b7 = load i32, ptr %b, align 4
  %14 = mul i32 %13, %b7
  store i32 %14, ptr %r, align 4
  %r8 = load i32, ptr %r, align 4
  %15 = icmp slt i32 %r8, 0
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then9, label %if.end10

if.then9:                                         ; preds = %div.ok
  %r11 = load i32, ptr %r, align 4
  %17 = sub i32 0, %r11
  ret i32 %17

if.end10:                                         ; preds = %div.ok
  %r12 = load i32, ptr %r, align 4
  ret i32 %r12
}

define internal i32 @IntMath.factorial(i32 %0) {
entry:
  %i = alloca i32, align 4
  %r = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  store i32 1, ptr %r, align 4
  store i32 2, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %1 = icmp sle i32 %i1, %n2
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r3 = load i32, ptr %r, align 4
  %i4 = load i32, ptr %i, align 4
  %3 = mul i32 %r3, %i4
  store i32 %3, ptr %r, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %4 = load i32, ptr %i, align 4
  %5 = add i32 %4, 1
  store i32 %5, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r5 = load i32, ptr %r, align 4
  ret i32 %r5
}

define internal i32 @IntMath.isPrime(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = icmp slt i32 %n1, 2
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  store i32 2, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end8, %if.end
  %i2 = load i32, ptr %i, align 4
  %i3 = load i32, ptr %i, align 4
  %3 = mul i32 %i2, %i3
  %n4 = load i32, ptr %n, align 4
  %4 = icmp sle i32 %3, %n4
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n5 = load i32, ptr %n, align 4
  %i6 = load i32, ptr %i, align 4
  %6 = icmp eq i32 %i6, 0
  %7 = icmp eq i32 %n5, -2147483648
  %8 = icmp eq i32 %i6, -1
  %9 = and i1 %7, %8
  %10 = or i1 %6, %9
  br i1 %10, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  ret i32 1

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %11 = srem i32 %n5, %i6
  %12 = icmp eq i32 %11, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then7, label %if.end8

if.then7:                                         ; preds = %div.ok
  ret i32 0

if.end8:                                          ; preds = %div.ok
  %i9 = load i32, ptr %i, align 4
  %14 = add i32 %i9, 1
  store i32 %14, ptr %i, align 4
  br label %while.cond
}

define internal i32 @IntMath.ipow(i32 %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %r = alloca i32, align 4
  %exp = alloca i32, align 4
  %base = alloca i32, align 4
  store i32 %0, ptr %base, align 4
  store i32 %1, ptr %exp, align 4
  store i32 1, ptr %r, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %exp2 = load i32, ptr %exp, align 4
  %2 = icmp slt i32 %i1, %exp2
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r3 = load i32, ptr %r, align 4
  %base4 = load i32, ptr %base, align 4
  %4 = mul i32 %r3, %base4
  store i32 %4, ptr %r, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r5 = load i32, ptr %r, align 4
  ret i32 %r5
}

define internal i32 @IntMath.isqrt(i32 %0) {
entry:
  %r = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = icmp slt i32 %n1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  store i32 0, ptr %r, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %r2 = load i32, ptr %r, align 4
  %3 = add i32 %r2, 1
  %r3 = load i32, ptr %r, align 4
  %4 = add i32 %r3, 1
  %5 = mul i32 %3, %4
  %n4 = load i32, ptr %n, align 4
  %6 = icmp sle i32 %5, %n4
  %7 = zext i1 %6 to i32
  br i1 %6, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %r5 = load i32, ptr %r, align 4
  %8 = add i32 %r5, 1
  store i32 %8, ptr %r, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %r6 = load i32, ptr %r, align 4
  ret i32 %r6
}

define internal void @Rational.Rational(ptr %0, i32 %1, i32 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown16 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %sign = alloca i32, align 4
  %g = alloca i32, align 4
  %d = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  store i32 %2, ptr %d, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 0
  store ptr @Rational.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %n1 = load i32, ptr %n, align 4
  %d2 = load i32, ptr %d, align 4
  %3 = call i32 @IntMath.gcd(i32 %n1, i32 %d2)
  store i32 %3, ptr %g, align 4
  %g3 = load i32, ptr %g, align 4
  %4 = icmp eq i32 %g3, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, ptr %g, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  store i32 1, ptr %sign, align 4
  %d4 = load i32, ptr %d, align 4
  %6 = icmp slt i32 %d4, 0
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  store i32 -1, ptr %sign, align 4
  br label %if.end6

if.end6:                                          ; preds = %if.then5, %if.end
  %num = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 1
  %sign7 = load i32, ptr %sign, align 4
  %n8 = load i32, ptr %n, align 4
  %8 = mul i32 %sign7, %n8
  %g9 = load i32, ptr %g, align 4
  %9 = icmp eq i32 %g9, 0
  %10 = icmp eq i32 %8, -2147483648
  %11 = icmp eq i32 %g9, -1
  %12 = and i1 %10, %11
  %13 = or i1 %9, %12
  br i1 %13, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end6
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end6
  %14 = sdiv i32 %8, %g9
  store i32 %14, ptr %num, align 4, !tbaa !7
  %den = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 2
  %sign10 = load i32, ptr %sign, align 4
  %d11 = load i32, ptr %d, align 4
  %15 = mul i32 %sign10, %d11
  %g12 = load i32, ptr %g, align 4
  %16 = icmp eq i32 %g12, 0
  %17 = icmp eq i32 %15, -2147483648
  %18 = icmp eq i32 %g12, -1
  %19 = and i1 %17, %18
  %20 = or i1 %16, %19
  br i1 %20, label %div.bad13, label %div.ok14

div.bad13:                                        ; preds = %div.ok
  %exc15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc15)
  store ptr %exc15, ptr %exc.thrown16, align 8
  call void @_CxxThrowException(ptr %exc.thrown16, ptr @_TI1PEAX)
  unreachable

div.ok14:                                         ; preds = %div.ok
  %21 = sdiv i32 %15, %g12
  store i32 %21, ptr %den, align 4, !tbaa !7
  ret void
}

define internal i32 @Rational.numerator(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %num = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 1
  %num1 = load i32, ptr %num, align 4, !tbaa !7
  ret i32 %num1
}

define internal i32 @Rational.denominator(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %den = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 2
  %den1 = load i32, ptr %den, align 4, !tbaa !7
  ret i32 %den1
}

define internal ptr @Rational.add(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Rational.copy = alloca %class.Rational, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Rational.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Rational, ptr null, i64 1) to i64))
  store ptr %Rational.copy, ptr %o, align 8
  %Rational.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Rational, ptr null, i64 1) to i64))
  %num = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 1
  %num1 = load i32, ptr %num, align 4, !tbaa !7
  %o2 = load ptr, ptr %o, align 8
  %3 = call i32 @Rational.denominator(ptr %o2)
  %4 = mul i32 %num1, %3
  %o3 = load ptr, ptr %o, align 8
  %5 = call i32 @Rational.numerator(ptr %o3)
  %den = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 2
  %den4 = load i32, ptr %den, align 4, !tbaa !7
  %6 = mul i32 %5, %den4
  %7 = add i32 %4, %6
  %den5 = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 2
  %den6 = load i32, ptr %den5, align 4, !tbaa !7
  %o7 = load ptr, ptr %o, align 8
  %8 = call i32 @Rational.denominator(ptr %o7)
  %9 = mul i32 %den6, %8
  call void @Rational.Rational(ptr %Rational.obj, i32 %7, i32 %9)
  ret ptr %Rational.obj
}

define internal ptr @Rational.sub(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Rational.copy = alloca %class.Rational, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Rational.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Rational, ptr null, i64 1) to i64))
  store ptr %Rational.copy, ptr %o, align 8
  %Rational.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Rational, ptr null, i64 1) to i64))
  %num = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 1
  %num1 = load i32, ptr %num, align 4, !tbaa !7
  %o2 = load ptr, ptr %o, align 8
  %3 = call i32 @Rational.denominator(ptr %o2)
  %4 = mul i32 %num1, %3
  %o3 = load ptr, ptr %o, align 8
  %5 = call i32 @Rational.numerator(ptr %o3)
  %den = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 2
  %den4 = load i32, ptr %den, align 4, !tbaa !7
  %6 = mul i32 %5, %den4
  %7 = sub i32 %4, %6
  %den5 = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 2
  %den6 = load i32, ptr %den5, align 4, !tbaa !7
  %o7 = load ptr, ptr %o, align 8
  %8 = call i32 @Rational.denominator(ptr %o7)
  %9 = mul i32 %den6, %8
  call void @Rational.Rational(ptr %Rational.obj, i32 %7, i32 %9)
  ret ptr %Rational.obj
}

define internal ptr @Rational.mul(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Rational.copy = alloca %class.Rational, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Rational.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Rational, ptr null, i64 1) to i64))
  store ptr %Rational.copy, ptr %o, align 8
  %Rational.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Rational, ptr null, i64 1) to i64))
  %num = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 1
  %num1 = load i32, ptr %num, align 4, !tbaa !7
  %o2 = load ptr, ptr %o, align 8
  %3 = call i32 @Rational.numerator(ptr %o2)
  %4 = mul i32 %num1, %3
  %den = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 2
  %den3 = load i32, ptr %den, align 4, !tbaa !7
  %o4 = load ptr, ptr %o, align 8
  %5 = call i32 @Rational.denominator(ptr %o4)
  %6 = mul i32 %den3, %5
  call void @Rational.Rational(ptr %Rational.obj, i32 %4, i32 %6)
  ret ptr %Rational.obj
}

define internal double @Rational.toDouble(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %num = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 1
  %num1 = load i32, ptr %num, align 4, !tbaa !7
  %1 = sitofp i32 %num1 to double
  %den = getelementptr inbounds %class.Rational, ptr %0, i32 0, i32 2
  %den2 = load i32, ptr %den, align 4, !tbaa !7
  %2 = sitofp i32 %den2 to double
  %3 = fdiv double %1, %2
  ret double %3
}

define internal void @Complex.Complex(ptr %0, double %1, double %2) {
entry:
  %im = alloca double, align 8
  %re = alloca double, align 8
  store double %1, ptr %re, align 8
  store double %2, ptr %im, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 0
  store ptr @Complex.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %re1 = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 1
  %re2 = load double, ptr %re, align 8
  store double %re2, ptr %re1, align 8, !tbaa !9
  %im3 = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 2
  %im4 = load double, ptr %im, align 8
  store double %im4, ptr %im3, align 8, !tbaa !9
  ret void
}

define internal double @Complex.real(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %re = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 1
  %re1 = load double, ptr %re, align 8, !tbaa !9
  ret double %re1
}

define internal double @Complex.imag(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %im = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 2
  %im1 = load double, ptr %im, align 8, !tbaa !9
  ret double %im1
}

define internal ptr @Complex.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Complex.copy = alloca %class.Complex, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Complex.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  store ptr %Complex.copy, ptr %o, align 8
  %Complex.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  %re = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 1
  %re1 = load double, ptr %re, align 8, !tbaa !9
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Complex.real(ptr %o2)
  %4 = fadd double %re1, %3
  %im = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 2
  %im3 = load double, ptr %im, align 8, !tbaa !9
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Complex.imag(ptr %o4)
  %6 = fadd double %im3, %5
  call void @Complex.Complex(ptr %Complex.obj, double %4, double %6)
  ret ptr %Complex.obj
}

define internal ptr @Complex.sub(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Complex.copy = alloca %class.Complex, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Complex.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  store ptr %Complex.copy, ptr %o, align 8
  %Complex.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  %re = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 1
  %re1 = load double, ptr %re, align 8, !tbaa !9
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Complex.real(ptr %o2)
  %4 = fsub double %re1, %3
  %im = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 2
  %im3 = load double, ptr %im, align 8, !tbaa !9
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Complex.imag(ptr %o4)
  %6 = fsub double %im3, %5
  call void @Complex.Complex(ptr %Complex.obj, double %4, double %6)
  ret ptr %Complex.obj
}

define internal ptr @Complex.mul(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Complex.copy = alloca %class.Complex, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Complex.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  store ptr %Complex.copy, ptr %o, align 8
  %Complex.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  %re = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 1
  %re1 = load double, ptr %re, align 8, !tbaa !9
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Complex.real(ptr %o2)
  %4 = fmul double %re1, %3
  %im = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 2
  %im3 = load double, ptr %im, align 8, !tbaa !9
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Complex.imag(ptr %o4)
  %6 = fmul double %im3, %5
  %7 = fsub double %4, %6
  %re5 = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 1
  %re6 = load double, ptr %re5, align 8, !tbaa !9
  %o7 = load ptr, ptr %o, align 8
  %8 = call double @Complex.imag(ptr %o7)
  %9 = fmul double %re6, %8
  %im8 = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 2
  %im9 = load double, ptr %im8, align 8, !tbaa !9
  %o10 = load ptr, ptr %o, align 8
  %10 = call double @Complex.real(ptr %o10)
  %11 = fmul double %im9, %10
  %12 = fadd double %9, %11
  call void @Complex.Complex(ptr %Complex.obj, double %7, double %12)
  ret ptr %Complex.obj
}

define internal ptr @Complex.conjugate(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %Complex.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Complex, ptr null, i64 1) to i64))
  %re = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 1
  %re1 = load double, ptr %re, align 8, !tbaa !9
  %im = getelementptr inbounds %class.Complex, ptr %0, i32 0, i32 2
  %im2 = load double, ptr %im, align 8, !tbaa !9
  %1 = fsub double 0.000000e+00, %im2
  call void @Complex.Complex(ptr %Complex.obj, double %re1, double %1)
  ret ptr %Complex.obj
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
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %xs4, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

for.update:                                       ; preds = %idx.ok
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s6 = load i32, ptr %s, align 4
  ret i32 %s6

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3246, ptr @.faila.3247, i64 %4, ptr @.failb.3248, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %xs4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %7 = add i32 %s3, %elem
  store i32 %7, ptr %s, align 4
  br label %for.update
}

define internal i32 @Stats.mean(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
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
  %4 = call i32 @Stats.sum(ptr %xs2)
  %xs3 = load ptr, ptr %xs, align 8
  %len4 = load i64, ptr %xs3, align 8
  %5 = trunc i64 %len4 to i32
  %6 = icmp eq i32 %5, 0
  %7 = icmp eq i32 %4, -2147483648
  %8 = icmp eq i32 %5, -1
  %9 = and i1 %7, %8
  %10 = or i1 %6, %9
  br i1 %10, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end
  %11 = sdiv i32 %4, %5
  ret i32 %11
}

define internal i32 @Stats.min(ptr %0) {
entry:
  %i = alloca i32, align 4
  %m = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %arr.len = load i64, ptr %xs1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3249, ptr @.faila.3250, i64 0, ptr @.failb.3251, i64 %arr.len, i32 70)
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
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len6 = load i64, ptr %xs4, align 8
  %arr.oob7 = icmp uge i64 %4, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !6

for.update:                                       ; preds = %if.end
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m23 = load i32, ptr %m, align 4
  ret i32 %m23

idx.bad8:                                         ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3252, ptr @.faila.3253, i64 %4, ptr @.failb.3254, i64 %arr.len6, i32 70)
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
  %xs14 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %i15 = load i32, ptr %i, align 4
  %9 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %xs14, align 8
  %arr.oob17 = icmp uge i64 %9, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !6

if.end:                                           ; preds = %idx.ok19, %idx.ok9
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3255, ptr @.faila.3256, i64 %9, ptr @.failb.3257, i64 %arr.len16, i32 70)
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
  %xs1 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %arr.len = load i64, ptr %xs1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3258, ptr @.faila.3259, i64 0, ptr @.failb.3260, i64 %arr.len, i32 70)
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
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len6 = load i64, ptr %xs4, align 8
  %arr.oob7 = icmp uge i64 %4, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !6

for.update:                                       ; preds = %if.end
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m23 = load i32, ptr %m, align 4
  ret i32 %m23

idx.bad8:                                         ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3261, ptr @.faila.3262, i64 %4, ptr @.failb.3263, i64 %arr.len6, i32 70)
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
  %xs14 = load ptr, ptr %xs, align 8, !nonnull !4, !dereferenceable !5
  %i15 = load i32, ptr %i, align 4
  %9 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %xs14, align 8
  %arr.oob17 = icmp uge i64 %9, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !6

if.end:                                           ; preds = %idx.ok19, %idx.ok9
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3264, ptr @.faila.3265, i64 %9, ptr @.failb.3266, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %xs14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %9
  %elem22 = load i32, ptr %arr.elem21, align 4
  store i32 %elem22, ptr %m, align 4
  br label %if.end
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5322)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5324)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{}
!5 = !{i64 8}
!6 = !{!"branch_weights", i32 1, i32 1048576}
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !2, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"f64", !2, i64 0}
