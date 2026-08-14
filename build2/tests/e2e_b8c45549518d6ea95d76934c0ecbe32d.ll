; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bigint_arith.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bigint_arith.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.BigInteger = type { ptr, ptr, i32, i32 }
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
@BigInteger.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BigInteger.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BigInteger.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BigInteger.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BigInteger.compareTo, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BigInteger.isZero, ptr @BigInteger.cmpMag, ptr @BigInteger.copyMag, ptr @BigInteger.subInPlace, ptr @BigInteger.mulTenAddInPlace, ptr @BigInteger.addSigned, ptr @BigInteger.subtract, ptr @BigInteger.multiply, ptr @BigInteger.divide, ptr @BigInteger.remainder, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.7 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.9 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.10 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.12 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.13 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.15 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.16 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.17 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.18 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1322 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1323 = private global %String { i64 16, ptr @.strdata.1322, i64 0 }
@.strdata.1324 = private constant [17 x i8] c"division by zero\00"
@.strobj.1325 = private global %String { i64 16, ptr @.strdata.1324, i64 0 }
@.fail.3134 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5232:29  in BigInteger.BigInteger\0A\00", align 1
@.faila.3135 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3136 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3137 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5236:44  in BigInteger.BigInteger\0A\00", align 1
@.faila.3138 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3139 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3140 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5247:68  in BigInteger.ensure\0A\00", align 1
@.faila.3141 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3142 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3143 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5247:68  in BigInteger.ensure\0A\00", align 1
@.faila.3144 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3145 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3146 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5251:54  in BigInteger.isZero\0A\00", align 1
@.faila.3147 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3148 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3149 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5255:21  in BigInteger.cmpMag\0A\00", align 1
@.faila.3150 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3151 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3152 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5255:21  in BigInteger.cmpMag\0A\00", align 1
@.faila.3153 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3154 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3155 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5255:52  in BigInteger.cmpMag\0A\00", align 1
@.faila.3156 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3157 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3158 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5255:52  in BigInteger.cmpMag\0A\00", align 1
@.faila.3159 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3160 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3161 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5263:71  in BigInteger.copyMag\0A\00", align 1
@.faila.3162 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3163 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3164 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5263:71  in BigInteger.copyMag\0A\00", align 1
@.faila.3165 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3166 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3167 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5271:21  in BigInteger.subInPlace\0A\00", align 1
@.faila.3168 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3169 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3170 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5272:40  in BigInteger.subInPlace\0A\00", align 1
@.faila.3171 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3172 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3173 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5274:33  in BigInteger.subInPlace\0A\00", align 1
@.faila.3174 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3175 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3176 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5277:17  in BigInteger.subInPlace\0A\00", align 1
@.faila.3177 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3178 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3179 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5280:17  in BigInteger.mulTenAddInPlace\0A\00", align 1
@.faila.3180 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3181 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3182 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5280:70  in BigInteger.mulTenAddInPlace\0A\00", align 1
@.faila.3183 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3184 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3185 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5282:74  in BigInteger.mulTenAddInPlace\0A\00", align 1
@.faila.3186 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3187 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3188 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5282:74  in BigInteger.mulTenAddInPlace\0A\00", align 1
@.faila.3189 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3190 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3191 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5283:29  in BigInteger.mulTenAddInPlace\0A\00", align 1
@.faila.3192 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3193 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3194 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5287:17  in BigInteger.normSign\0A\00", align 1
@.faila.3195 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3196 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3197 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5298:40  in BigInteger.addMag\0A\00", align 1
@.faila.3198 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3199 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3200 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5299:40  in BigInteger.addMag\0A\00", align 1
@.faila.3201 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3202 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3203 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5300:30  in BigInteger.addMag\0A\00", align 1
@.faila.3204 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3205 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3206 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5339:64  in BigInteger.multiply\0A\00", align 1
@.faila.3207 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3208 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3209 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5342:38  in BigInteger.multiply\0A\00", align 1
@.faila.3210 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3211 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3212 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5342:38  in BigInteger.multiply\0A\00", align 1
@.faila.3213 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3214 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3215 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5342:38  in BigInteger.multiply\0A\00", align 1
@.faila.3216 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3217 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3218 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5342:38  in BigInteger.multiply\0A\00", align 1
@.faila.3219 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3220 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3221 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5347:21  in BigInteger.multiply\0A\00", align 1
@.faila.3222 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3223 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3224 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5348:30  in BigInteger.multiply\0A\00", align 1
@.faila.3225 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3226 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3227 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5351:17  in BigInteger.multiply\0A\00", align 1
@.faila.3228 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3229 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3230 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5368:68  in BigInteger.divide\0A\00", align 1
@.faila.3231 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3232 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3233 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5371:41  in BigInteger.divide\0A\00", align 1
@.faila.3234 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3235 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3236 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5374:30  in BigInteger.divide\0A\00", align 1
@.faila.3237 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3238 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3239 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5376:17  in BigInteger.divide\0A\00", align 1
@.faila.3240 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3241 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3242 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5385:41  in BigInteger.remainder\0A\00", align 1
@.faila.3243 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3244 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3245 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5396:34  in BigInteger.toString\0A\00", align 1
@.faila.3246 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3247 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }
@.strdata.5325 = private constant [1 x i8] zeroinitializer
@.strobj.5326 = private global %String { i64 0, ptr @.strdata.5325, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %big = alloca ptr, align 8
  %k = alloca ptr, align 8
  %h = alloca ptr, align 8
  %q = alloca ptr, align 8
  %p = alloca ptr, align 8
  %na = alloca ptr, align 8
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
  %BigInteger.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj, i64 1000000)
  store ptr %BigInteger.obj, ptr %a, align 8
  %BigInteger.obj1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj1, i64 7)
  store ptr %BigInteger.obj1, ptr %b, align 8
  %a2 = load ptr, ptr %a, align 8
  %b3 = load ptr, ptr %b, align 8
  %16 = call ptr @BigInteger.divide(ptr %a2, ptr %b3)
  %17 = call ptr @BigInteger.toString(ptr %16)
  %str.data = getelementptr inbounds %String, ptr %17, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %18 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %17)
  %19 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr @.str.2)
  %a4 = load ptr, ptr %a, align 8
  %b5 = load ptr, ptr %b, align 8
  %20 = call ptr @BigInteger.remainder(ptr %a4, ptr %b5)
  %21 = call ptr @BigInteger.toString(ptr %20)
  %str.data6 = getelementptr inbounds %String, ptr %21, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %22 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr %data7)
  call void @__polaron_str_free(ptr %21)
  %23 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr @.str.5)
  %BigInteger.obj8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj8, i64 -1000000)
  store ptr %BigInteger.obj8, ptr %na, align 8
  %na9 = load ptr, ptr %na, align 8
  %b10 = load ptr, ptr %b, align 8
  %24 = call ptr @BigInteger.divide(ptr %na9, ptr %b10)
  %25 = call ptr @BigInteger.toString(ptr %24)
  %str.data11 = getelementptr inbounds %String, ptr %25, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %26 = call i32 (ptr, ...) @printf(ptr @.str.6, ptr %data12)
  call void @__polaron_str_free(ptr %25)
  %27 = call i32 (ptr, ...) @printf(ptr @.str.7, ptr @.str.8)
  %na13 = load ptr, ptr %na, align 8
  %b14 = load ptr, ptr %b, align 8
  %28 = call ptr @BigInteger.remainder(ptr %na13, ptr %b14)
  %29 = call ptr @BigInteger.toString(ptr %28)
  %str.data15 = getelementptr inbounds %String, ptr %29, i32 0, i32 1
  %data16 = load ptr, ptr %str.data15, align 8
  %30 = call i32 (ptr, ...) @printf(ptr @.str.9, ptr %data16)
  call void @__polaron_str_free(ptr %29)
  %31 = call i32 (ptr, ...) @printf(ptr @.str.10, ptr @.str.11)
  %BigInteger.obj17 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj17, i64 -100)
  store ptr %BigInteger.obj17, ptr %p, align 8
  %BigInteger.obj18 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj18, i64 30)
  store ptr %BigInteger.obj18, ptr %q, align 8
  %p19 = load ptr, ptr %p, align 8
  %q20 = load ptr, ptr %q, align 8
  %32 = call ptr @BigInteger.add(ptr %p19, ptr %q20)
  %33 = call ptr @BigInteger.toString(ptr %32)
  %str.data21 = getelementptr inbounds %String, ptr %33, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %34 = call i32 (ptr, ...) @printf(ptr @.str.12, ptr %data22)
  call void @__polaron_str_free(ptr %33)
  %35 = call i32 (ptr, ...) @printf(ptr @.str.13, ptr @.str.14)
  %BigInteger.obj23 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj23, i64 100)
  store ptr %BigInteger.obj23, ptr %h, align 8
  %BigInteger.obj24 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj24, i64 250)
  store ptr %BigInteger.obj24, ptr %k, align 8
  %h25 = load ptr, ptr %h, align 8
  %k26 = load ptr, ptr %k, align 8
  %36 = call ptr @BigInteger.subtract(ptr %h25, ptr %k26)
  %37 = call ptr @BigInteger.toString(ptr %36)
  %str.data27 = getelementptr inbounds %String, ptr %37, i32 0, i32 1
  %data28 = load ptr, ptr %str.data27, align 8
  %38 = call i32 (ptr, ...) @printf(ptr @.str.15, ptr %data28)
  call void @__polaron_str_free(ptr %37)
  %39 = call i32 (ptr, ...) @printf(ptr @.str.16, ptr @.str.17)
  %BigInteger.obj29 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj29, i64 999999)
  store ptr %BigInteger.obj29, ptr %big, align 8
  %big30 = load ptr, ptr %big, align 8
  %big31 = load ptr, ptr %big, align 8
  %40 = call ptr @BigInteger.multiply(ptr %big30, ptr %big31)
  %41 = call ptr @BigInteger.toString(ptr %40)
  %str.data32 = getelementptr inbounds %String, ptr %41, i32 0, i32 1
  %data33 = load ptr, ptr %str.data32, align 8
  %42 = call i32 (ptr, ...) @printf(ptr @.str.18, ptr %data33)
  call void @__polaron_str_free(ptr %41)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1323)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1325)
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

define internal void @BigInteger.BigInteger(ptr %0, i64 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown30 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %v = alloca i64, align 8
  %value = alloca i64, align 8
  store i64 %1, ptr %value, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 0
  store ptr @BigInteger.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %dig = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  store ptr null, ptr %dig, align 8, !tbaa !0
  %neg = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %value1 = load i64, ptr %value, align 8
  %2 = icmp slt i64 %value1, 0
  %3 = zext i1 %2 to i32
  store i32 %3, ptr %neg, align 4, !tbaa !4
  %value2 = load i64, ptr %value, align 8
  store i64 %value2, ptr %v, align 8
  %neg3 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg4 = load i32, ptr %neg3, align 4, !tbaa !4
  %4 = icmp ne i32 %neg4, 0
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %v5 = load i64, ptr %v, align 8
  %5 = sub i64 0, %v5
  store i64 %5, ptr %v, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %dig6 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 104)
  store i64 24, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 96)
  store ptr %arr, ptr %dig6, align 8, !tbaa !0
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  store i32 1, ptr %len, align 4, !tbaa !4
  %dig7 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig8 = load ptr, ptr %dig7, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %dig8, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.3134, ptr @.faila.3135, i64 0, ptr @.failb.3136, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data9 = getelementptr i8, ptr %dig8, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 0
  store i32 0, ptr %arr.elem, align 4
  %v10 = load i64, ptr %v, align 8
  %7 = icmp sgt i64 %v10, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then11, label %if.end12

if.then11:                                        ; preds = %idx.ok
  %len13 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  store i32 0, ptr %len13, align 4, !tbaa !4
  br label %while.cond

if.end12:                                         ; preds = %while.end, %idx.ok
  ret void

while.cond:                                       ; preds = %div.ok28, %if.then11
  %v14 = load i64, ptr %v, align 8
  %9 = icmp sgt i64 %v14, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %dig15 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig16 = load ptr, ptr %dig15, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %len17 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len18 = load i32, ptr %len17, align 4, !tbaa !4
  %11 = sext i32 %len18 to i64
  %arr.len19 = load i64, ptr %dig16, align 8
  %arr.oob20 = icmp uge i64 %11, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !10

while.end:                                        ; preds = %while.cond
  br label %if.end12

idx.bad21:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.3137, ptr @.faila.3138, i64 %11, ptr @.failb.3139, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %while.body
  %arr.data23 = getelementptr i8, ptr %dig16, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %11
  %v25 = load i64, ptr %v, align 8
  %12 = icmp eq i64 %v25, -9223372036854775808
  %13 = and i1 %12, false
  %14 = or i1 false, %13
  br i1 %14, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok22
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok22
  %15 = srem i64 %v25, 10
  %16 = trunc i64 %15 to i32
  store i32 %16, ptr %arr.elem24, align 4
  %v26 = load i64, ptr %v, align 8
  %17 = icmp eq i64 %v26, -9223372036854775808
  %18 = and i1 %17, false
  %19 = or i1 false, %18
  br i1 %19, label %div.bad27, label %div.ok28

div.bad27:                                        ; preds = %div.ok
  %exc29 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc29)
  store ptr %exc29, ptr %exc.thrown30, align 8
  call void @_CxxThrowException(ptr %exc.thrown30, ptr @_TI1PEAX)
  unreachable

div.ok28:                                         ; preds = %div.ok
  %20 = sdiv i64 %v26, 10
  store i64 %20, ptr %v, align 8
  %len31 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len32 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len33 = load i32, ptr %len32, align 4, !tbaa !4
  %21 = add i32 %len33, 1
  store i32 %21, ptr %len31, align 4, !tbaa !4
  br label %while.cond
}

define internal void @BigInteger.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %nd = alloca ptr, align 8
  %cap = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %dig = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig2 = load ptr, ptr %dig, align 8, !tbaa !0
  %len = load i64, ptr %dig2, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp sle i32 %n1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %dig3 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig4 = load ptr, ptr %dig3, align 8, !tbaa !0
  %len5 = load i64, ptr %dig4, align 8
  %5 = trunc i64 %len5 to i32
  %6 = mul i32 %5, 2
  store i32 %6, ptr %cap, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %cap6 = load i32, ptr %cap, align 4
  %n7 = load i32, ptr %n, align 4
  %7 = icmp slt i32 %cap6, %n7
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %cap8 = load i32, ptr %cap, align 4
  %9 = mul i32 %cap8, 2
  store i32 %9, ptr %cap, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %cap9 = load i32, ptr %cap, align 4
  %10 = sext i32 %cap9 to i64
  %11 = mul i64 %10, 4
  %12 = add i64 8, %11
  %arr = call ptr @__polaron_malloc(i64 %12)
  store i64 %10, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %13 = call ptr @memset(ptr %arr.data, i32 0, i64 %11)
  store ptr %arr, ptr %nd, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %while.end
  %i10 = load i32, ptr %i, align 4
  %len11 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len12 = load i32, ptr %len11, align 4, !tbaa !4
  %14 = icmp slt i32 %i10, %len12
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %nd13 = load ptr, ptr %nd, align 8, !nonnull !8, !dereferenceable !9
  %i14 = load i32, ptr %i, align 4
  %16 = sext i32 %i14 to i64
  %arr.len = load i64, ptr %nd13, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok22
  %17 = load i32, ptr %i, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dig25 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig26 = load ptr, ptr %dig25, align 8, !tbaa !0
  call void @__polaron_free(ptr %dig26)
  %dig27 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %nd28 = load ptr, ptr %nd, align 8
  store ptr %nd28, ptr %dig27, align 8, !tbaa !0
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3140, ptr @.faila.3141, i64 %16, ptr @.failb.3142, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data15 = getelementptr i8, ptr %nd13, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data15, i64 %16
  %dig16 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig17 = load ptr, ptr %dig16, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i18 = load i32, ptr %i, align 4
  %19 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %dig17, align 8
  %arr.oob20 = icmp uge i64 %19, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !10

idx.bad21:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3143, ptr @.faila.3144, i64 %19, ptr @.failb.3145, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok
  %arr.data23 = getelementptr i8, ptr %dig17, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %19
  %elem = load i32, ptr %arr.elem24, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @BigInteger.isZero(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len1 = load i32, ptr %len, align 4, !tbaa !4
  %1 = icmp eq i32 %len1, 1
  %2 = zext i1 %1 to i32
  %sc.a = icmp ne i32 %2, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %dig = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig2 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %dig2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

sc.end:                                           ; preds = %idx.ok, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %idx.ok ]
  %3 = zext i1 %sc to i32
  ret i32 %3

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3146, ptr @.faila.3147, i64 0, ptr @.failb.3148, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %dig2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %4 = icmp eq i32 %elem, 0
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end
}

define internal i32 @BigInteger.cmpMag(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %o, align 8
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len1 = load i32, ptr %len, align 4, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %len3 = getelementptr inbounds %class.BigInteger, ptr %o2, i32 0, i32 2
  %len4 = load i32, ptr %len3, align 4, !tbaa !4
  %9 = icmp ne i32 %len1, %len4
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %len5 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len6 = load i32, ptr %len5, align 4, !tbaa !4
  %o7 = load ptr, ptr %o, align 8
  %len8 = getelementptr inbounds %class.BigInteger, ptr %o7, i32 0, i32 2
  %len9 = load i32, ptr %len8, align 4, !tbaa !4
  %11 = icmp slt i32 %len6, %len9
  %12 = zext i1 %11 to i32
  %tern.c = icmp ne i32 %12, 0
  br i1 %tern.c, label %tern.then, label %tern.else

if.end:                                           ; preds = %entry
  %len10 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len11 = load i32, ptr %len10, align 4, !tbaa !4
  %13 = sub i32 %len11, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

tern.then:                                        ; preds = %if.then
  br label %tern.end

tern.else:                                        ; preds = %if.then
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ -1, %tern.then ], [ 1, %tern.else ]
  ret i32 %tern

for.cond:                                         ; preds = %for.update, %if.end
  %i12 = load i32, ptr %i, align 4
  %14 = icmp sge i32 %i12, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %dig = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig13 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i14 = load i32, ptr %i, align 4
  %16 = sext i32 %i14 to i64
  %arr.len15 = load i64, ptr %dig13, align 8
  %arr.oob = icmp uge i64 %16, %arr.len15
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end28
  %17 = load i32, ptr %i, align 4
  %18 = sub i32 %17, 1
  store i32 %18, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3149, ptr @.faila.3150, i64 %16, ptr @.failb.3151, i64 %arr.len15, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %dig13, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %16
  %elem = load i32, ptr %arr.elem, align 4
  %o16 = load ptr, ptr %o, align 8
  %dig17 = getelementptr inbounds %class.BigInteger, ptr %o16, i32 0, i32 1
  %dig18 = load ptr, ptr %dig17, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i19 = load i32, ptr %i, align 4
  %19 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %dig18, align 8
  %arr.oob21 = icmp uge i64 %19, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3152, ptr @.faila.3153, i64 %19, ptr @.failb.3154, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %dig18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %19
  %elem26 = load i32, ptr %arr.elem25, align 4
  %20 = icmp ne i32 %elem, %elem26
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then27, label %if.end28

if.then27:                                        ; preds = %idx.ok23
  %dig29 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig30 = load ptr, ptr %dig29, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i31 = load i32, ptr %i, align 4
  %22 = sext i32 %i31 to i64
  %arr.len32 = load i64, ptr %dig30, align 8
  %arr.oob33 = icmp uge i64 %22, %arr.len32
  br i1 %arr.oob33, label %idx.bad34, label %idx.ok35, !prof !10

if.end28:                                         ; preds = %idx.ok23
  br label %for.update

idx.bad34:                                        ; preds = %if.then27
  call void @__polaron_fail(ptr @.fail.3155, ptr @.faila.3156, i64 %22, ptr @.failb.3157, i64 %arr.len32, i32 70)
  unreachable

idx.ok35:                                         ; preds = %if.then27
  %arr.data36 = getelementptr i8, ptr %dig30, i64 8
  %arr.elem37 = getelementptr inbounds i32, ptr %arr.data36, i64 %22
  %elem38 = load i32, ptr %arr.elem37, align 4
  %o39 = load ptr, ptr %o, align 8
  %dig40 = getelementptr inbounds %class.BigInteger, ptr %o39, i32 0, i32 1
  %dig41 = load ptr, ptr %dig40, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i42 = load i32, ptr %i, align 4
  %23 = sext i32 %i42 to i64
  %arr.len43 = load i64, ptr %dig41, align 8
  %arr.oob44 = icmp uge i64 %23, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !10

idx.bad45:                                        ; preds = %idx.ok35
  call void @__polaron_fail(ptr @.fail.3158, ptr @.faila.3159, i64 %23, ptr @.failb.3160, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok35
  %arr.data47 = getelementptr i8, ptr %dig41, i64 8
  %arr.elem48 = getelementptr inbounds i32, ptr %arr.data47, i64 %23
  %elem49 = load i32, ptr %arr.elem48, align 4
  %24 = icmp slt i32 %elem38, %elem49
  %25 = zext i1 %24 to i32
  %tern.c50 = icmp ne i32 %25, 0
  br i1 %tern.c50, label %tern.then51, label %tern.else52

tern.then51:                                      ; preds = %idx.ok46
  br label %tern.end53

tern.else52:                                      ; preds = %idx.ok46
  br label %tern.end53

tern.end53:                                       ; preds = %tern.else52, %tern.then51
  %tern54 = phi i32 [ -1, %tern.then51 ], [ 1, %tern.else52 ]
  ret i32 %tern54
}

define internal ptr @BigInteger.copyMag(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %r = alloca ptr, align 8
  %BigInteger.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj, i64 0)
  store ptr %BigInteger.obj, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len2 = load i32, ptr %len, align 4, !tbaa !4
  %1 = add i32 %len2, 1
  call void @BigInteger.ensure(ptr %r1, i32 %1)
  %r3 = load ptr, ptr %r, align 8
  %len4 = getelementptr inbounds %class.BigInteger, ptr %r3, i32 0, i32 2
  %len5 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len6 = load i32, ptr %len5, align 4, !tbaa !4
  store i32 %len6, ptr %len4, align 4, !tbaa !4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i7 = load i32, ptr %i, align 4
  %len8 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len9 = load i32, ptr %len8, align 4, !tbaa !4
  %2 = icmp slt i32 %i7, %len9
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r10 = load ptr, ptr %r, align 8
  %dig = getelementptr inbounds %class.BigInteger, ptr %r10, i32 0, i32 1
  %dig11 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i12 = load i32, ptr %i, align 4
  %4 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %dig11, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok19
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r22 = load ptr, ptr %r, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %r22, i32 0, i32 3
  store i32 0, ptr %neg, align 4, !tbaa !4
  %r23 = load ptr, ptr %r, align 8
  ret ptr %r23

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3161, ptr @.faila.3162, i64 %4, ptr @.failb.3163, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %dig11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %dig13 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig14 = load ptr, ptr %dig13, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i15 = load i32, ptr %i, align 4
  %7 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %dig14, align 8
  %arr.oob17 = icmp uge i64 %7, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !10

idx.bad18:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3164, ptr @.faila.3165, i64 %7, ptr @.failb.3166, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok
  %arr.data20 = getelementptr i8, ptr %dig14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %7
  %elem = load i32, ptr %arr.elem21, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @BigInteger.subInPlace(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %s = alloca i32, align 4
  %i = alloca i32, align 4
  %borrow = alloca i32, align 4
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %o, align 8
  store i32 0, ptr %borrow, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok33, %entry
  %i1 = load i32, ptr %i, align 4
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len2 = load i32, ptr %len, align 4, !tbaa !4
  %9 = icmp slt i32 %i1, %len2
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %dig = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig3 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i4 = load i32, ptr %i, align 4
  %11 = sext i32 %i4 to i64
  %arr.len5 = load i64, ptr %dig3, align 8
  %arr.oob = icmp uge i64 %11, %arr.len5
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

while.end:                                        ; preds = %while.cond
  br label %while.cond38

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.3167, ptr @.faila.3168, i64 %11, ptr @.failb.3169, i64 %arr.len5, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %dig3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %11
  %elem = load i32, ptr %arr.elem, align 4
  %borrow6 = load i32, ptr %borrow, align 4
  %12 = sub i32 %elem, %borrow6
  store i32 %12, ptr %s, align 4
  %i7 = load i32, ptr %i, align 4
  %o8 = load ptr, ptr %o, align 8
  %len9 = getelementptr inbounds %class.BigInteger, ptr %o8, i32 0, i32 2
  %len10 = load i32, ptr %len9, align 4, !tbaa !4
  %13 = icmp slt i32 %i7, %len10
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %s11 = load i32, ptr %s, align 4
  %o12 = load ptr, ptr %o, align 8
  %dig13 = getelementptr inbounds %class.BigInteger, ptr %o12, i32 0, i32 1
  %dig14 = load ptr, ptr %dig13, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %dig14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !10

if.end:                                           ; preds = %idx.ok19, %idx.ok
  %s23 = load i32, ptr %s, align 4
  %16 = icmp slt i32 %s23, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then24, label %if.else

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3170, ptr @.faila.3171, i64 %15, ptr @.failb.3172, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %dig14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %15
  %elem22 = load i32, ptr %arr.elem21, align 4
  %18 = sub i32 %s11, %elem22
  store i32 %18, ptr %s, align 4
  br label %if.end

if.then24:                                        ; preds = %if.end
  %s26 = load i32, ptr %s, align 4
  %19 = add i32 %s26, 10
  store i32 %19, ptr %s, align 4
  store i32 1, ptr %borrow, align 4
  br label %if.end25

if.else:                                          ; preds = %if.end
  store i32 0, ptr %borrow, align 4
  br label %if.end25

if.end25:                                         ; preds = %if.else, %if.then24
  %dig27 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig28 = load ptr, ptr %dig27, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i29 = load i32, ptr %i, align 4
  %20 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %dig28, align 8
  %arr.oob31 = icmp uge i64 %20, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !10

idx.bad32:                                        ; preds = %if.end25
  call void @__polaron_fail(ptr @.fail.3173, ptr @.faila.3174, i64 %20, ptr @.failb.3175, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.end25
  %arr.data34 = getelementptr i8, ptr %dig28, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %20
  %s36 = load i32, ptr %s, align 4
  store i32 %s36, ptr %arr.elem35, align 4
  %i37 = load i32, ptr %i, align 4
  %21 = add i32 %i37, 1
  store i32 %21, ptr %i, align 4
  br label %while.cond

while.cond38:                                     ; preds = %while.body39, %while.end
  %len41 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len42 = load i32, ptr %len41, align 4, !tbaa !4
  %22 = icmp sgt i32 %len42, 1
  %23 = zext i1 %22 to i32
  %sc.a = icmp ne i32 %23, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body39:                                     ; preds = %sc.end
  %len54 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len55 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len56 = load i32, ptr %len55, align 4, !tbaa !4
  %24 = sub i32 %len56, 1
  store i32 %24, ptr %len54, align 4, !tbaa !4
  br label %while.cond38

while.end40:                                      ; preds = %sc.end
  ret void

sc.rhs:                                           ; preds = %while.cond38
  %dig43 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig44 = load ptr, ptr %dig43, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %len45 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len46 = load i32, ptr %len45, align 4, !tbaa !4
  %25 = sub i32 %len46, 1
  %26 = sext i32 %25 to i64
  %arr.len47 = load i64, ptr %dig44, align 8
  %arr.oob48 = icmp uge i64 %26, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !10

sc.end:                                           ; preds = %idx.ok50, %while.cond38
  %sc = phi i1 [ false, %while.cond38 ], [ %sc.b, %idx.ok50 ]
  %27 = zext i1 %sc to i32
  br i1 %sc, label %while.body39, label %while.end40

idx.bad49:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3176, ptr @.faila.3177, i64 %26, ptr @.failb.3178, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %sc.rhs
  %arr.data51 = getelementptr i8, ptr %dig44, i64 8
  %arr.elem52 = getelementptr inbounds i32, ptr %arr.data51, i64 %26
  %elem53 = load i32, ptr %arr.elem52, align 4
  %28 = icmp eq i32 %elem53, 0
  %29 = zext i1 %28 to i32
  %sc.b = icmp ne i32 %29, 0
  br label %sc.end
}

define internal void @BigInteger.mulTenAddInPlace(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %d = alloca i32, align 4
  store i32 %1, ptr %d, align 4
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len1 = load i32, ptr %len, align 4, !tbaa !4
  %2 = icmp eq i32 %len1, 1
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %dig = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig2 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %dig2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

sc.end:                                           ; preds = %idx.ok, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %idx.ok ]
  %4 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3179, ptr @.faila.3180, i64 0, ptr @.failb.3181, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %dig2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %5 = icmp eq i32 %elem, 0
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %dig3 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig4 = load ptr, ptr %dig3, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %arr.len5 = load i64, ptr %dig4, align 8
  %arr.oob6 = icmp uge i64 0, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !10

if.end:                                           ; preds = %sc.end
  %len12 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len13 = load i32, ptr %len12, align 4, !tbaa !4
  %7 = add i32 %len13, 1
  call void @BigInteger.ensure(ptr %0, i32 %7)
  %len14 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len15 = load i32, ptr %len14, align 4, !tbaa !4
  store i32 %len15, ptr %i, align 4
  br label %for.cond

idx.bad7:                                         ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3182, ptr @.faila.3183, i64 0, ptr @.failb.3184, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %if.then
  %arr.data9 = getelementptr i8, ptr %dig4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 0
  %d11 = load i32, ptr %d, align 4
  store i32 %d11, ptr %arr.elem10, align 4
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %i16 = load i32, ptr %i, align 4
  %8 = icmp sgt i32 %i16, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %dig17 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig18 = load ptr, ptr %dig17, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i19 = load i32, ptr %i, align 4
  %10 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %dig18, align 8
  %arr.oob21 = icmp uge i64 %10, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

for.update:                                       ; preds = %idx.ok32
  %11 = load i32, ptr %i, align 4
  %12 = sub i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dig36 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig37 = load ptr, ptr %dig36, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %arr.len38 = load i64, ptr %dig37, align 8
  %arr.oob39 = icmp uge i64 0, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !10

idx.bad22:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3185, ptr @.faila.3186, i64 %10, ptr @.failb.3187, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %for.body
  %arr.data24 = getelementptr i8, ptr %dig18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %10
  %dig26 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig27 = load ptr, ptr %dig26, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i28 = load i32, ptr %i, align 4
  %13 = sub i32 %i28, 1
  %14 = sext i32 %13 to i64
  %arr.len29 = load i64, ptr %dig27, align 8
  %arr.oob30 = icmp uge i64 %14, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !10

idx.bad31:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.3188, ptr @.faila.3189, i64 %14, ptr @.failb.3190, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok23
  %arr.data33 = getelementptr i8, ptr %dig27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %14
  %elem35 = load i32, ptr %arr.elem34, align 4
  store i32 %elem35, ptr %arr.elem25, align 4
  br label %for.update

idx.bad40:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.3191, ptr @.faila.3192, i64 0, ptr @.failb.3193, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %for.end
  %arr.data42 = getelementptr i8, ptr %dig37, i64 8
  %arr.elem43 = getelementptr inbounds i32, ptr %arr.data42, i64 0
  %d44 = load i32, ptr %d, align 4
  store i32 %d44, ptr %arr.elem43, align 4
  %len45 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len46 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len47 = load i32, ptr %len46, align 4, !tbaa !4
  %15 = add i32 %len47, 1
  store i32 %15, ptr %len45, align 4, !tbaa !4
  ret void
}

define internal void @BigInteger.normSign(ptr %0) {
entry:
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %r = alloca ptr, align 8
  %1 = call ptr @memcpy(ptr %BigInteger.copy, ptr %0, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %2 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %3 = load ptr, ptr %2, align 8, !tbaa !0
  %arr.len = load i64, ptr %3, align 8
  %4 = mul i64 %arr.len, 4
  %5 = add i64 8, %4
  %arr.copy = call ptr @__polaron_malloc(i64 %5)
  %6 = call ptr @memcpy(ptr %arr.copy, ptr %3, i64 %5)
  %7 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %7, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %len = getelementptr inbounds %class.BigInteger, ptr %r1, i32 0, i32 2
  %len2 = load i32, ptr %len, align 4, !tbaa !4
  %8 = icmp eq i32 %len2, 1
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %r3 = load ptr, ptr %r, align 8
  %dig = getelementptr inbounds %class.BigInteger, ptr %r3, i32 0, i32 1
  %dig4 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %arr.len5 = load i64, ptr %dig4, align 8
  %arr.oob = icmp uge i64 0, %arr.len5
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

sc.end:                                           ; preds = %idx.ok, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %idx.ok ]
  %10 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3194, ptr @.faila.3195, i64 0, ptr @.failb.3196, i64 %arr.len5, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %dig4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %11 = icmp eq i32 %elem, 0
  %12 = zext i1 %11 to i32
  %sc.b = icmp ne i32 %12, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %r6 = load ptr, ptr %r, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %r6, i32 0, i32 3
  store i32 0, ptr %neg, align 4, !tbaa !4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  ret void
}

define internal ptr @BigInteger.addMag(ptr %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown65 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %s = alloca i32, align 4
  %i = alloca i32, align 4
  %carry = alloca i32, align 4
  %n = alloca i32, align 4
  %r = alloca ptr, align 8
  %BigInteger.copy1 = alloca %class.BigInteger, align 8
  %b = alloca ptr, align 8
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %a = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %0, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %a, align 8
  %9 = call ptr @memcpy(ptr %BigInteger.copy1, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %arr.len2 = load i64, ptr %11, align 8
  %12 = mul i64 %arr.len2, 4
  %13 = add i64 8, %12
  %arr.copy3 = call ptr @__polaron_malloc(i64 %13)
  %14 = call ptr @memcpy(ptr %arr.copy3, ptr %11, i64 %13)
  %15 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy1, i32 0, i32 1
  store ptr %arr.copy3, ptr %15, align 8, !tbaa !0
  store ptr %BigInteger.copy1, ptr %b, align 8
  %BigInteger.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj, i64 0)
  store ptr %BigInteger.obj, ptr %r, align 8
  %a4 = load ptr, ptr %a, align 8
  %len = getelementptr inbounds %class.BigInteger, ptr %a4, i32 0, i32 2
  %len5 = load i32, ptr %len, align 4, !tbaa !4
  %b6 = load ptr, ptr %b, align 8
  %len7 = getelementptr inbounds %class.BigInteger, ptr %b6, i32 0, i32 2
  %len8 = load i32, ptr %len7, align 4, !tbaa !4
  %16 = icmp sgt i32 %len5, %len8
  %17 = zext i1 %16 to i32
  %tern.c = icmp ne i32 %17, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %entry
  %a9 = load ptr, ptr %a, align 8
  %len10 = getelementptr inbounds %class.BigInteger, ptr %a9, i32 0, i32 2
  %len11 = load i32, ptr %len10, align 4, !tbaa !4
  br label %tern.end

tern.else:                                        ; preds = %entry
  %b12 = load ptr, ptr %b, align 8
  %len13 = getelementptr inbounds %class.BigInteger, ptr %b12, i32 0, i32 2
  %len14 = load i32, ptr %len13, align 4, !tbaa !4
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ %len11, %tern.then ], [ %len14, %tern.else ]
  store i32 %tern, ptr %n, align 4
  %r15 = load ptr, ptr %r, align 8
  %n16 = load i32, ptr %n, align 4
  %18 = add i32 %n16, 2
  call void @BigInteger.ensure(ptr %r15, i32 %18)
  store i32 0, ptr %carry, align 4
  store i32 0, ptr %i, align 4
  %r17 = load ptr, ptr %r, align 8
  %len18 = getelementptr inbounds %class.BigInteger, ptr %r17, i32 0, i32 2
  store i32 0, ptr %len18, align 4, !tbaa !4
  br label %while.cond

while.cond:                                       ; preds = %div.ok63, %tern.end
  %i19 = load i32, ptr %i, align 4
  %n20 = load i32, ptr %n, align 4
  %19 = icmp slt i32 %i19, %n20
  %20 = zext i1 %19 to i32
  %sc.a = icmp ne i32 %20, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

while.body:                                       ; preds = %sc.end
  %carry22 = load i32, ptr %carry, align 4
  store i32 %carry22, ptr %s, align 4
  %i23 = load i32, ptr %i, align 4
  %a24 = load ptr, ptr %a, align 8
  %len25 = getelementptr inbounds %class.BigInteger, ptr %a24, i32 0, i32 2
  %len26 = load i32, ptr %len25, align 4, !tbaa !4
  %21 = icmp slt i32 %i23, %len26
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then, label %if.end

while.end:                                        ; preds = %sc.end
  %r70 = load ptr, ptr %r, align 8
  ret ptr %r70

sc.rhs:                                           ; preds = %while.cond
  %carry21 = load i32, ptr %carry, align 4
  %23 = icmp sgt i32 %carry21, 0
  %24 = zext i1 %23 to i32
  %sc.b = icmp ne i32 %24, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ true, %while.cond ], [ %sc.b, %sc.rhs ]
  %25 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

if.then:                                          ; preds = %while.body
  %s27 = load i32, ptr %s, align 4
  %a28 = load ptr, ptr %a, align 8
  %dig = getelementptr inbounds %class.BigInteger, ptr %a28, i32 0, i32 1
  %dig29 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i30 = load i32, ptr %i, align 4
  %26 = sext i32 %i30 to i64
  %arr.len31 = load i64, ptr %dig29, align 8
  %arr.oob = icmp uge i64 %26, %arr.len31
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

if.end:                                           ; preds = %idx.ok, %while.body
  %i32 = load i32, ptr %i, align 4
  %b33 = load ptr, ptr %b, align 8
  %len34 = getelementptr inbounds %class.BigInteger, ptr %b33, i32 0, i32 2
  %len35 = load i32, ptr %len34, align 4, !tbaa !4
  %27 = icmp slt i32 %i32, %len35
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then36, label %if.end37

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.3197, ptr @.faila.3198, i64 %26, ptr @.failb.3199, i64 %arr.len31, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %dig29, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %26
  %elem = load i32, ptr %arr.elem, align 4
  %29 = add i32 %s27, %elem
  store i32 %29, ptr %s, align 4
  br label %if.end

if.then36:                                        ; preds = %if.end
  %s38 = load i32, ptr %s, align 4
  %b39 = load ptr, ptr %b, align 8
  %dig40 = getelementptr inbounds %class.BigInteger, ptr %b39, i32 0, i32 1
  %dig41 = load ptr, ptr %dig40, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i42 = load i32, ptr %i, align 4
  %30 = sext i32 %i42 to i64
  %arr.len43 = load i64, ptr %dig41, align 8
  %arr.oob44 = icmp uge i64 %30, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !10

if.end37:                                         ; preds = %idx.ok46, %if.end
  %r50 = load ptr, ptr %r, align 8
  %dig51 = getelementptr inbounds %class.BigInteger, ptr %r50, i32 0, i32 1
  %dig52 = load ptr, ptr %dig51, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i53 = load i32, ptr %i, align 4
  %31 = sext i32 %i53 to i64
  %arr.len54 = load i64, ptr %dig52, align 8
  %arr.oob55 = icmp uge i64 %31, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !10

idx.bad45:                                        ; preds = %if.then36
  call void @__polaron_fail(ptr @.fail.3200, ptr @.faila.3201, i64 %30, ptr @.failb.3202, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %if.then36
  %arr.data47 = getelementptr i8, ptr %dig41, i64 8
  %arr.elem48 = getelementptr inbounds i32, ptr %arr.data47, i64 %30
  %elem49 = load i32, ptr %arr.elem48, align 4
  %32 = add i32 %s38, %elem49
  store i32 %32, ptr %s, align 4
  br label %if.end37

idx.bad56:                                        ; preds = %if.end37
  call void @__polaron_fail(ptr @.fail.3203, ptr @.faila.3204, i64 %31, ptr @.failb.3205, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %if.end37
  %arr.data58 = getelementptr i8, ptr %dig52, i64 8
  %arr.elem59 = getelementptr inbounds i32, ptr %arr.data58, i64 %31
  %s60 = load i32, ptr %s, align 4
  %33 = icmp eq i32 %s60, -2147483648
  %34 = and i1 %33, false
  %35 = or i1 false, %34
  br i1 %35, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok57
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok57
  %36 = srem i32 %s60, 10
  store i32 %36, ptr %arr.elem59, align 4
  %s61 = load i32, ptr %s, align 4
  %37 = icmp eq i32 %s61, -2147483648
  %38 = and i1 %37, false
  %39 = or i1 false, %38
  br i1 %39, label %div.bad62, label %div.ok63

div.bad62:                                        ; preds = %div.ok
  %exc64 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc64)
  store ptr %exc64, ptr %exc.thrown65, align 8
  call void @_CxxThrowException(ptr %exc.thrown65, ptr @_TI1PEAX)
  unreachable

div.ok63:                                         ; preds = %div.ok
  %40 = sdiv i32 %s61, 10
  store i32 %40, ptr %carry, align 4
  %i66 = load i32, ptr %i, align 4
  %41 = add i32 %i66, 1
  store i32 %41, ptr %i, align 4
  %r67 = load ptr, ptr %r, align 8
  %len68 = getelementptr inbounds %class.BigInteger, ptr %r67, i32 0, i32 2
  %i69 = load i32, ptr %i, align 4
  store i32 %i69, ptr %len68, align 4, !tbaa !4
  br label %while.cond
}

define internal ptr @BigInteger.addSigned(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2) {
entry:
  %r2 = alloca ptr, align 8
  %r17 = alloca ptr, align 8
  %c = alloca i32, align 4
  %r = alloca ptr, align 8
  %otherNeg = alloca i32, align 4
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %other = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %4 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %5 = load ptr, ptr %4, align 8, !tbaa !0
  %arr.len = load i64, ptr %5, align 8
  %6 = mul i64 %arr.len, 4
  %7 = add i64 8, %6
  %arr.copy = call ptr @__polaron_malloc(i64 %7)
  %8 = call ptr @memcpy(ptr %arr.copy, ptr %5, i64 %7)
  %9 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %9, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %other, align 8
  store i32 %2, ptr %otherNeg, align 4
  %neg = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg1 = load i32, ptr %neg, align 4, !tbaa !4
  %otherNeg2 = load i32, ptr %otherNeg, align 4
  %10 = icmp eq i32 %neg1, %otherNeg2
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %other3 = load ptr, ptr %other, align 8
  %12 = call ptr @BigInteger.addMag(ptr %0, ptr %other3)
  store ptr %12, ptr %r, align 8
  %r4 = load ptr, ptr %r, align 8
  %neg5 = getelementptr inbounds %class.BigInteger, ptr %r4, i32 0, i32 3
  %neg6 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg7 = load i32, ptr %neg6, align 4, !tbaa !4
  store i32 %neg7, ptr %neg5, align 4, !tbaa !4
  %r8 = load ptr, ptr %r, align 8
  call void @BigInteger.normSign(ptr %r8)
  %r9 = load ptr, ptr %r, align 8
  ret ptr %r9

if.end:                                           ; preds = %entry
  %other10 = load ptr, ptr %other, align 8
  %13 = call i32 @BigInteger.cmpMag(ptr %0, ptr %other10)
  store i32 %13, ptr %c, align 4
  %c11 = load i32, ptr %c, align 4
  %14 = icmp eq i32 %c11, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then12, label %if.end13

if.then12:                                        ; preds = %if.end
  %BigInteger.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj, i64 0)
  ret ptr %BigInteger.obj

if.end13:                                         ; preds = %if.end
  %c14 = load i32, ptr %c, align 4
  %16 = icmp sgt i32 %c14, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.end13
  %18 = call ptr @BigInteger.copyMag(ptr %0)
  store ptr %18, ptr %r17, align 8
  %r18 = load ptr, ptr %r17, align 8
  %other19 = load ptr, ptr %other, align 8
  call void @BigInteger.subInPlace(ptr %r18, ptr %other19)
  %r20 = load ptr, ptr %r17, align 8
  %neg21 = getelementptr inbounds %class.BigInteger, ptr %r20, i32 0, i32 3
  %neg22 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg23 = load i32, ptr %neg22, align 4, !tbaa !4
  store i32 %neg23, ptr %neg21, align 4, !tbaa !4
  %r24 = load ptr, ptr %r17, align 8
  call void @BigInteger.normSign(ptr %r24)
  %r25 = load ptr, ptr %r17, align 8
  ret ptr %r25

if.end16:                                         ; preds = %if.end13
  %other26 = load ptr, ptr %other, align 8
  %19 = call ptr @BigInteger.copyMag(ptr %other26)
  store ptr %19, ptr %r2, align 8
  %r227 = load ptr, ptr %r2, align 8
  call void @BigInteger.subInPlace(ptr %r227, ptr %0)
  %r228 = load ptr, ptr %r2, align 8
  %neg29 = getelementptr inbounds %class.BigInteger, ptr %r228, i32 0, i32 3
  %otherNeg30 = load i32, ptr %otherNeg, align 4
  store i32 %otherNeg30, ptr %neg29, align 4, !tbaa !4
  %r231 = load ptr, ptr %r2, align 8
  call void @BigInteger.normSign(ptr %r231)
  %r232 = load ptr, ptr %r2, align 8
  ret ptr %r232
}

define internal ptr @BigInteger.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %other2 = load ptr, ptr %other, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %other2, i32 0, i32 3
  %neg3 = load i32, ptr %neg, align 4, !tbaa !4
  %9 = call ptr @BigInteger.addSigned(ptr %0, ptr %other1, i32 %neg3)
  ret ptr %9
}

define internal ptr @BigInteger.subtract(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %flipped = alloca i32, align 4
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %9 = call i32 @BigInteger.isZero(ptr %other1)
  %tern.c = icmp ne i32 %9, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %entry
  br label %tern.end

tern.else:                                        ; preds = %entry
  %other2 = load ptr, ptr %other, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %other2, i32 0, i32 3
  %neg3 = load i32, ptr %neg, align 4, !tbaa !4
  %10 = icmp eq i32 %neg3, 0
  %11 = zext i1 %10 to i32
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ 0, %tern.then ], [ %11, %tern.else ]
  store i32 %tern, ptr %flipped, align 4
  %other4 = load ptr, ptr %other, align 8
  %flipped5 = load i32, ptr %flipped, align 4
  %12 = call ptr @BigInteger.addSigned(ptr %0, ptr %other4, i32 %flipped5)
  ret ptr %12
}

define internal ptr @BigInteger.multiply(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown108 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %s = alloca i32, align 4
  %k = alloca i32, align 4
  %carry = alloca i32, align 4
  %j = alloca i32, align 4
  %i16 = alloca i32, align 4
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %r = alloca ptr, align 8
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %other, align 8
  %BigInteger.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj, i64 0)
  store ptr %BigInteger.obj, ptr %r, align 8
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len1 = load i32, ptr %len, align 4, !tbaa !4
  %other2 = load ptr, ptr %other, align 8
  %len3 = getelementptr inbounds %class.BigInteger, ptr %other2, i32 0, i32 2
  %len4 = load i32, ptr %len3, align 4, !tbaa !4
  %9 = add i32 %len1, %len4
  store i32 %9, ptr %n, align 4
  %r5 = load ptr, ptr %r, align 8
  %n6 = load i32, ptr %n, align 4
  %10 = add i32 %n6, 1
  call void @BigInteger.ensure(ptr %r5, i32 %10)
  %r7 = load ptr, ptr %r, align 8
  %len8 = getelementptr inbounds %class.BigInteger, ptr %r7, i32 0, i32 2
  %n9 = load i32, ptr %n, align 4
  store i32 %n9, ptr %len8, align 4, !tbaa !4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i10 = load i32, ptr %i, align 4
  %n11 = load i32, ptr %n, align 4
  %11 = icmp slt i32 %i10, %n11
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r12 = load ptr, ptr %r, align 8
  %dig = getelementptr inbounds %class.BigInteger, ptr %r12, i32 0, i32 1
  %dig13 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i14 = load i32, ptr %i, align 4
  %13 = sext i32 %i14 to i64
  %arr.len15 = load i64, ptr %dig13, align 8
  %arr.oob = icmp uge i64 %13, %arr.len15
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %14 = load i32, ptr %i, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %i16, align 4
  br label %for.cond17

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3206, ptr @.faila.3207, i64 %13, ptr @.failb.3208, i64 %arr.len15, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %dig13, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %13
  store i32 0, ptr %arr.elem, align 4
  br label %for.update

for.cond17:                                       ; preds = %for.update19, %for.end
  %i21 = load i32, ptr %i16, align 4
  %len22 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len23 = load i32, ptr %len22, align 4, !tbaa !4
  %16 = icmp slt i32 %i21, %len23
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body18, label %for.end20

for.body18:                                       ; preds = %for.cond17
  store i32 0, ptr %j, align 4
  br label %for.cond24

for.update19:                                     ; preds = %for.end27
  %18 = load i32, ptr %i16, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i16, align 4
  br label %for.cond17

for.end20:                                        ; preds = %for.cond17
  store i32 0, ptr %carry, align 4
  store i32 0, ptr %k, align 4
  br label %for.cond75

for.cond24:                                       ; preds = %for.update26, %for.body18
  %j28 = load i32, ptr %j, align 4
  %other29 = load ptr, ptr %other, align 8
  %len30 = getelementptr inbounds %class.BigInteger, ptr %other29, i32 0, i32 2
  %len31 = load i32, ptr %len30, align 4, !tbaa !4
  %20 = icmp slt i32 %j28, %len31
  %21 = zext i1 %20 to i32
  br i1 %20, label %for.body25, label %for.end27

for.body25:                                       ; preds = %for.cond24
  %r32 = load ptr, ptr %r, align 8
  %dig33 = getelementptr inbounds %class.BigInteger, ptr %r32, i32 0, i32 1
  %dig34 = load ptr, ptr %dig33, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i35 = load i32, ptr %i16, align 4
  %j36 = load i32, ptr %j, align 4
  %22 = add i32 %i35, %j36
  %23 = sext i32 %22 to i64
  %arr.len37 = load i64, ptr %dig34, align 8
  %arr.oob38 = icmp uge i64 %23, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !10

for.update26:                                     ; preds = %idx.ok71
  %24 = load i32, ptr %j, align 4
  %25 = add i32 %24, 1
  store i32 %25, ptr %j, align 4
  br label %for.cond24

for.end27:                                        ; preds = %for.cond24
  br label %for.update19

idx.bad39:                                        ; preds = %for.body25
  call void @__polaron_fail(ptr @.fail.3209, ptr @.faila.3210, i64 %23, ptr @.failb.3211, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %for.body25
  %arr.data41 = getelementptr i8, ptr %dig34, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %23
  %r43 = load ptr, ptr %r, align 8
  %dig44 = getelementptr inbounds %class.BigInteger, ptr %r43, i32 0, i32 1
  %dig45 = load ptr, ptr %dig44, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i46 = load i32, ptr %i16, align 4
  %j47 = load i32, ptr %j, align 4
  %26 = add i32 %i46, %j47
  %27 = sext i32 %26 to i64
  %arr.len48 = load i64, ptr %dig45, align 8
  %arr.oob49 = icmp uge i64 %27, %arr.len48
  br i1 %arr.oob49, label %idx.bad50, label %idx.ok51, !prof !10

idx.bad50:                                        ; preds = %idx.ok40
  call void @__polaron_fail(ptr @.fail.3212, ptr @.faila.3213, i64 %27, ptr @.failb.3214, i64 %arr.len48, i32 70)
  unreachable

idx.ok51:                                         ; preds = %idx.ok40
  %arr.data52 = getelementptr i8, ptr %dig45, i64 8
  %arr.elem53 = getelementptr inbounds i32, ptr %arr.data52, i64 %27
  %elem = load i32, ptr %arr.elem53, align 4
  %dig54 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig55 = load ptr, ptr %dig54, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i56 = load i32, ptr %i16, align 4
  %28 = sext i32 %i56 to i64
  %arr.len57 = load i64, ptr %dig55, align 8
  %arr.oob58 = icmp uge i64 %28, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !10

idx.bad59:                                        ; preds = %idx.ok51
  call void @__polaron_fail(ptr @.fail.3215, ptr @.faila.3216, i64 %28, ptr @.failb.3217, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok51
  %arr.data61 = getelementptr i8, ptr %dig55, i64 8
  %arr.elem62 = getelementptr inbounds i32, ptr %arr.data61, i64 %28
  %elem63 = load i32, ptr %arr.elem62, align 4
  %other64 = load ptr, ptr %other, align 8
  %dig65 = getelementptr inbounds %class.BigInteger, ptr %other64, i32 0, i32 1
  %dig66 = load ptr, ptr %dig65, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %j67 = load i32, ptr %j, align 4
  %29 = sext i32 %j67 to i64
  %arr.len68 = load i64, ptr %dig66, align 8
  %arr.oob69 = icmp uge i64 %29, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !10

idx.bad70:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.3218, ptr @.faila.3219, i64 %29, ptr @.failb.3220, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %idx.ok60
  %arr.data72 = getelementptr i8, ptr %dig66, i64 8
  %arr.elem73 = getelementptr inbounds i32, ptr %arr.data72, i64 %29
  %elem74 = load i32, ptr %arr.elem73, align 4
  %30 = mul i32 %elem63, %elem74
  %31 = add i32 %elem, %30
  store i32 %31, ptr %arr.elem42, align 4
  br label %for.update26

for.cond75:                                       ; preds = %for.update77, %for.end20
  %k79 = load i32, ptr %k, align 4
  %n80 = load i32, ptr %n, align 4
  %32 = icmp slt i32 %k79, %n80
  %33 = zext i1 %32 to i32
  br i1 %32, label %for.body76, label %for.end78

for.body76:                                       ; preds = %for.cond75
  %r81 = load ptr, ptr %r, align 8
  %dig82 = getelementptr inbounds %class.BigInteger, ptr %r81, i32 0, i32 1
  %dig83 = load ptr, ptr %dig82, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %k84 = load i32, ptr %k, align 4
  %34 = sext i32 %k84 to i64
  %arr.len85 = load i64, ptr %dig83, align 8
  %arr.oob86 = icmp uge i64 %34, %arr.len85
  br i1 %arr.oob86, label %idx.bad87, label %idx.ok88, !prof !10

for.update77:                                     ; preds = %div.ok106
  %35 = load i32, ptr %k, align 4
  %36 = add i32 %35, 1
  store i32 %36, ptr %k, align 4
  br label %for.cond75

for.end78:                                        ; preds = %for.cond75
  br label %while.cond

idx.bad87:                                        ; preds = %for.body76
  call void @__polaron_fail(ptr @.fail.3221, ptr @.faila.3222, i64 %34, ptr @.failb.3223, i64 %arr.len85, i32 70)
  unreachable

idx.ok88:                                         ; preds = %for.body76
  %arr.data89 = getelementptr i8, ptr %dig83, i64 8
  %arr.elem90 = getelementptr inbounds i32, ptr %arr.data89, i64 %34
  %elem91 = load i32, ptr %arr.elem90, align 4
  %carry92 = load i32, ptr %carry, align 4
  %37 = add i32 %elem91, %carry92
  store i32 %37, ptr %s, align 4
  %r93 = load ptr, ptr %r, align 8
  %dig94 = getelementptr inbounds %class.BigInteger, ptr %r93, i32 0, i32 1
  %dig95 = load ptr, ptr %dig94, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %k96 = load i32, ptr %k, align 4
  %38 = sext i32 %k96 to i64
  %arr.len97 = load i64, ptr %dig95, align 8
  %arr.oob98 = icmp uge i64 %38, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !10

idx.bad99:                                        ; preds = %idx.ok88
  call void @__polaron_fail(ptr @.fail.3224, ptr @.faila.3225, i64 %38, ptr @.failb.3226, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok88
  %arr.data101 = getelementptr i8, ptr %dig95, i64 8
  %arr.elem102 = getelementptr inbounds i32, ptr %arr.data101, i64 %38
  %s103 = load i32, ptr %s, align 4
  %39 = icmp eq i32 %s103, -2147483648
  %40 = and i1 %39, false
  %41 = or i1 false, %40
  br i1 %41, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok100
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok100
  %42 = srem i32 %s103, 10
  store i32 %42, ptr %arr.elem102, align 4
  %s104 = load i32, ptr %s, align 4
  %43 = icmp eq i32 %s104, -2147483648
  %44 = and i1 %43, false
  %45 = or i1 false, %44
  br i1 %45, label %div.bad105, label %div.ok106

div.bad105:                                       ; preds = %div.ok
  %exc107 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc107)
  store ptr %exc107, ptr %exc.thrown108, align 8
  call void @_CxxThrowException(ptr %exc.thrown108, ptr @_TI1PEAX)
  unreachable

div.ok106:                                        ; preds = %div.ok
  %46 = sdiv i32 %s104, 10
  store i32 %46, ptr %carry, align 4
  br label %for.update77

while.cond:                                       ; preds = %while.body, %for.end78
  %r109 = load ptr, ptr %r, align 8
  %len110 = getelementptr inbounds %class.BigInteger, ptr %r109, i32 0, i32 2
  %len111 = load i32, ptr %len110, align 4, !tbaa !4
  %47 = icmp sgt i32 %len111, 1
  %48 = zext i1 %47 to i32
  %sc.a = icmp ne i32 %48, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %r125 = load ptr, ptr %r, align 8
  %len126 = getelementptr inbounds %class.BigInteger, ptr %r125, i32 0, i32 2
  %r127 = load ptr, ptr %r, align 8
  %len128 = getelementptr inbounds %class.BigInteger, ptr %r127, i32 0, i32 2
  %len129 = load i32, ptr %len128, align 4, !tbaa !4
  %49 = sub i32 %len129, 1
  store i32 %49, ptr %len126, align 4, !tbaa !4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %r130 = load ptr, ptr %r, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %r130, i32 0, i32 3
  %neg131 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg132 = load i32, ptr %neg131, align 4, !tbaa !4
  %other133 = load ptr, ptr %other, align 8
  %neg134 = getelementptr inbounds %class.BigInteger, ptr %other133, i32 0, i32 3
  %neg135 = load i32, ptr %neg134, align 4, !tbaa !4
  %50 = icmp ne i32 %neg132, %neg135
  %51 = zext i1 %50 to i32
  store i32 %51, ptr %neg, align 4, !tbaa !4
  %r136 = load ptr, ptr %r, align 8
  ret ptr %r136

sc.rhs:                                           ; preds = %while.cond
  %r112 = load ptr, ptr %r, align 8
  %dig113 = getelementptr inbounds %class.BigInteger, ptr %r112, i32 0, i32 1
  %dig114 = load ptr, ptr %dig113, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %r115 = load ptr, ptr %r, align 8
  %len116 = getelementptr inbounds %class.BigInteger, ptr %r115, i32 0, i32 2
  %len117 = load i32, ptr %len116, align 4, !tbaa !4
  %52 = sub i32 %len117, 1
  %53 = sext i32 %52 to i64
  %arr.len118 = load i64, ptr %dig114, align 8
  %arr.oob119 = icmp uge i64 %53, %arr.len118
  br i1 %arr.oob119, label %idx.bad120, label %idx.ok121, !prof !10

sc.end:                                           ; preds = %idx.ok121, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok121 ]
  %54 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad120:                                       ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3227, ptr @.faila.3228, i64 %53, ptr @.failb.3229, i64 %arr.len118, i32 70)
  unreachable

idx.ok121:                                        ; preds = %sc.rhs
  %arr.data122 = getelementptr i8, ptr %dig114, i64 8
  %arr.elem123 = getelementptr inbounds i32, ptr %arr.data122, i64 %53
  %elem124 = load i32, ptr %arr.elem123, align 4
  %55 = icmp eq i32 %elem124, 0
  %56 = zext i1 %55 to i32
  %sc.b = icmp ne i32 %56, 0
  br label %sc.end
}

define internal i32 @BigInteger.compareTo(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %no = alloca i32, align 4
  %nt = alloca i32, align 4
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %other, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg1 = load i32, ptr %neg, align 4, !tbaa !4
  %sc.a = icmp ne i32 %neg1, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %9 = call i32 @BigInteger.isZero(ptr %0)
  %10 = icmp eq i32 %9, 0
  %11 = zext i1 %10 to i32
  %sc.b = icmp ne i32 %11, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %12 = zext i1 %sc to i32
  store i32 %12, ptr %nt, align 4
  %other2 = load ptr, ptr %other, align 8
  %neg3 = getelementptr inbounds %class.BigInteger, ptr %other2, i32 0, i32 3
  %neg4 = load i32, ptr %neg3, align 4, !tbaa !4
  %sc.a5 = icmp ne i32 %neg4, 0
  br i1 %sc.a5, label %sc.rhs6, label %sc.end7

sc.rhs6:                                          ; preds = %sc.end
  %other8 = load ptr, ptr %other, align 8
  %13 = call i32 @BigInteger.isZero(ptr %other8)
  %14 = icmp eq i32 %13, 0
  %15 = zext i1 %14 to i32
  %sc.b9 = icmp ne i32 %15, 0
  br label %sc.end7

sc.end7:                                          ; preds = %sc.rhs6, %sc.end
  %sc10 = phi i1 [ false, %sc.end ], [ %sc.b9, %sc.rhs6 ]
  %16 = zext i1 %sc10 to i32
  store i32 %16, ptr %no, align 4
  %nt11 = load i32, ptr %nt, align 4
  %sc.a12 = icmp ne i32 %nt11, 0
  br i1 %sc.a12, label %sc.rhs13, label %sc.end14

sc.rhs13:                                         ; preds = %sc.end7
  %no15 = load i32, ptr %no, align 4
  %17 = icmp eq i32 %no15, 0
  %18 = zext i1 %17 to i32
  %sc.b16 = icmp ne i32 %18, 0
  br label %sc.end14

sc.end14:                                         ; preds = %sc.rhs13, %sc.end7
  %sc17 = phi i1 [ false, %sc.end7 ], [ %sc.b16, %sc.rhs13 ]
  %19 = zext i1 %sc17 to i32
  br i1 %sc17, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end14
  ret i32 -1

if.end:                                           ; preds = %sc.end14
  %nt18 = load i32, ptr %nt, align 4
  %20 = icmp eq i32 %nt18, 0
  %21 = zext i1 %20 to i32
  %sc.a19 = icmp ne i32 %21, 0
  br i1 %sc.a19, label %sc.rhs20, label %sc.end21

sc.rhs20:                                         ; preds = %if.end
  %no22 = load i32, ptr %no, align 4
  %sc.b23 = icmp ne i32 %no22, 0
  br label %sc.end21

sc.end21:                                         ; preds = %sc.rhs20, %if.end
  %sc24 = phi i1 [ false, %if.end ], [ %sc.b23, %sc.rhs20 ]
  %22 = zext i1 %sc24 to i32
  br i1 %sc24, label %if.then25, label %if.end26

if.then25:                                        ; preds = %sc.end21
  ret i32 1

if.end26:                                         ; preds = %sc.end21
  %nt27 = load i32, ptr %nt, align 4
  %sc.a28 = icmp ne i32 %nt27, 0
  br i1 %sc.a28, label %sc.rhs29, label %sc.end30

sc.rhs29:                                         ; preds = %if.end26
  %no31 = load i32, ptr %no, align 4
  %sc.b32 = icmp ne i32 %no31, 0
  br label %sc.end30

sc.end30:                                         ; preds = %sc.rhs29, %if.end26
  %sc33 = phi i1 [ false, %if.end26 ], [ %sc.b32, %sc.rhs29 ]
  %23 = zext i1 %sc33 to i32
  br i1 %sc33, label %if.then34, label %if.end35

if.then34:                                        ; preds = %sc.end30
  %other36 = load ptr, ptr %other, align 8
  %24 = call i32 @BigInteger.cmpMag(ptr %0, ptr %other36)
  %25 = sub i32 0, %24
  ret i32 %25

if.end35:                                         ; preds = %sc.end30
  %other37 = load ptr, ptr %other, align 8
  %26 = call i32 @BigInteger.cmpMag(ptr %0, ptr %other37)
  ret i32 %26
}

define internal ptr @BigInteger.divide(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %d = alloca i32, align 4
  %i = alloca i32, align 4
  %rem = alloca ptr, align 8
  %z = alloca i32, align 4
  %q = alloca ptr, align 8
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %9 = call i32 @BigInteger.isZero(ptr %other1)
  %10 = icmp ne i32 %9, 0
  br i1 %10, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %BigInteger.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj, i64 0)
  ret ptr %BigInteger.obj

if.end:                                           ; preds = %entry
  %BigInteger.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj2, i64 0)
  store ptr %BigInteger.obj2, ptr %q, align 8
  %q3 = load ptr, ptr %q, align 8
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len4 = load i32, ptr %len, align 4, !tbaa !4
  %11 = add i32 %len4, 1
  call void @BigInteger.ensure(ptr %q3, i32 %11)
  %q5 = load ptr, ptr %q, align 8
  %len6 = getelementptr inbounds %class.BigInteger, ptr %q5, i32 0, i32 2
  %len7 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len8 = load i32, ptr %len7, align 4, !tbaa !4
  store i32 %len8, ptr %len6, align 4, !tbaa !4
  store i32 0, ptr %z, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %z9 = load i32, ptr %z, align 4
  %q10 = load ptr, ptr %q, align 8
  %len11 = getelementptr inbounds %class.BigInteger, ptr %q10, i32 0, i32 2
  %len12 = load i32, ptr %len11, align 4, !tbaa !4
  %12 = icmp slt i32 %z9, %len12
  %13 = zext i1 %12 to i32
  br i1 %12, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %q13 = load ptr, ptr %q, align 8
  %dig = getelementptr inbounds %class.BigInteger, ptr %q13, i32 0, i32 1
  %dig14 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %z15 = load i32, ptr %z, align 4
  %14 = sext i32 %z15 to i64
  %arr.len16 = load i64, ptr %dig14, align 8
  %arr.oob = icmp uge i64 %14, %arr.len16
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %15 = load i32, ptr %z, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %z, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %BigInteger.obj17 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj17, i64 0)
  store ptr %BigInteger.obj17, ptr %rem, align 8
  %len18 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len19 = load i32, ptr %len18, align 4, !tbaa !4
  %17 = sub i32 %len19, 1
  store i32 %17, ptr %i, align 4
  br label %for.cond20

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3230, ptr @.faila.3231, i64 %14, ptr @.failb.3232, i64 %arr.len16, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %dig14, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %14
  store i32 0, ptr %arr.elem, align 4
  br label %for.update

for.cond20:                                       ; preds = %for.update22, %for.end
  %i24 = load i32, ptr %i, align 4
  %18 = icmp sge i32 %i24, 0
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body21, label %for.end23

for.body21:                                       ; preds = %for.cond20
  %rem25 = load ptr, ptr %rem, align 8
  %dig26 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig27 = load ptr, ptr %dig26, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i28 = load i32, ptr %i, align 4
  %20 = sext i32 %i28 to i64
  %arr.len29 = load i64, ptr %dig27, align 8
  %arr.oob30 = icmp uge i64 %20, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !10

for.update22:                                     ; preds = %idx.ok47
  %21 = load i32, ptr %i, align 4
  %22 = sub i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond20

for.end23:                                        ; preds = %for.cond20
  br label %while.cond51

idx.bad31:                                        ; preds = %for.body21
  call void @__polaron_fail(ptr @.fail.3233, ptr @.faila.3234, i64 %20, ptr @.failb.3235, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %for.body21
  %arr.data33 = getelementptr i8, ptr %dig27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %20
  %elem = load i32, ptr %arr.elem34, align 4
  call void @BigInteger.mulTenAddInPlace(ptr %rem25, i32 %elem)
  store i32 0, ptr %d, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok32
  %rem35 = load ptr, ptr %rem, align 8
  %other36 = load ptr, ptr %other, align 8
  %23 = call i32 @BigInteger.cmpMag(ptr %rem35, ptr %other36)
  %24 = icmp sge i32 %23, 0
  %25 = zext i1 %24 to i32
  br i1 %24, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %rem37 = load ptr, ptr %rem, align 8
  %other38 = load ptr, ptr %other, align 8
  call void @BigInteger.subInPlace(ptr %rem37, ptr %other38)
  %d39 = load i32, ptr %d, align 4
  %26 = add i32 %d39, 1
  store i32 %26, ptr %d, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %q40 = load ptr, ptr %q, align 8
  %dig41 = getelementptr inbounds %class.BigInteger, ptr %q40, i32 0, i32 1
  %dig42 = load ptr, ptr %dig41, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i43 = load i32, ptr %i, align 4
  %27 = sext i32 %i43 to i64
  %arr.len44 = load i64, ptr %dig42, align 8
  %arr.oob45 = icmp uge i64 %27, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !10

idx.bad46:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.3236, ptr @.faila.3237, i64 %27, ptr @.failb.3238, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %while.end
  %arr.data48 = getelementptr i8, ptr %dig42, i64 8
  %arr.elem49 = getelementptr inbounds i32, ptr %arr.data48, i64 %27
  %d50 = load i32, ptr %d, align 4
  store i32 %d50, ptr %arr.elem49, align 4
  br label %for.update22

while.cond51:                                     ; preds = %while.body52, %for.end23
  %q54 = load ptr, ptr %q, align 8
  %len55 = getelementptr inbounds %class.BigInteger, ptr %q54, i32 0, i32 2
  %len56 = load i32, ptr %len55, align 4, !tbaa !4
  %28 = icmp sgt i32 %len56, 1
  %29 = zext i1 %28 to i32
  %sc.a = icmp ne i32 %29, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body52:                                     ; preds = %sc.end
  %q70 = load ptr, ptr %q, align 8
  %len71 = getelementptr inbounds %class.BigInteger, ptr %q70, i32 0, i32 2
  %q72 = load ptr, ptr %q, align 8
  %len73 = getelementptr inbounds %class.BigInteger, ptr %q72, i32 0, i32 2
  %len74 = load i32, ptr %len73, align 4, !tbaa !4
  %30 = sub i32 %len74, 1
  store i32 %30, ptr %len71, align 4, !tbaa !4
  br label %while.cond51

while.end53:                                      ; preds = %sc.end
  %q75 = load ptr, ptr %q, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %q75, i32 0, i32 3
  %neg76 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg77 = load i32, ptr %neg76, align 4, !tbaa !4
  %other78 = load ptr, ptr %other, align 8
  %neg79 = getelementptr inbounds %class.BigInteger, ptr %other78, i32 0, i32 3
  %neg80 = load i32, ptr %neg79, align 4, !tbaa !4
  %31 = icmp ne i32 %neg77, %neg80
  %32 = zext i1 %31 to i32
  store i32 %32, ptr %neg, align 4, !tbaa !4
  %q81 = load ptr, ptr %q, align 8
  call void @BigInteger.normSign(ptr %q81)
  %q82 = load ptr, ptr %q, align 8
  ret ptr %q82

sc.rhs:                                           ; preds = %while.cond51
  %q57 = load ptr, ptr %q, align 8
  %dig58 = getelementptr inbounds %class.BigInteger, ptr %q57, i32 0, i32 1
  %dig59 = load ptr, ptr %dig58, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %q60 = load ptr, ptr %q, align 8
  %len61 = getelementptr inbounds %class.BigInteger, ptr %q60, i32 0, i32 2
  %len62 = load i32, ptr %len61, align 4, !tbaa !4
  %33 = sub i32 %len62, 1
  %34 = sext i32 %33 to i64
  %arr.len63 = load i64, ptr %dig59, align 8
  %arr.oob64 = icmp uge i64 %34, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !10

sc.end:                                           ; preds = %idx.ok66, %while.cond51
  %sc = phi i1 [ false, %while.cond51 ], [ %sc.b, %idx.ok66 ]
  %35 = zext i1 %sc to i32
  br i1 %sc, label %while.body52, label %while.end53

idx.bad65:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3239, ptr @.faila.3240, i64 %34, ptr @.failb.3241, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %sc.rhs
  %arr.data67 = getelementptr i8, ptr %dig59, i64 8
  %arr.elem68 = getelementptr inbounds i32, ptr %arr.data67, i64 %34
  %elem69 = load i32, ptr %arr.elem68, align 4
  %36 = icmp eq i32 %elem69, 0
  %37 = zext i1 %36 to i32
  %sc.b = icmp ne i32 %37, 0
  br label %sc.end
}

define internal ptr @BigInteger.remainder(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %rem = alloca ptr, align 8
  %BigInteger.copy = alloca %class.BigInteger, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BigInteger.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BigInteger, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.BigInteger, ptr %BigInteger.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %BigInteger.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %9 = call i32 @BigInteger.isZero(ptr %other1)
  %10 = icmp ne i32 %9, 0
  br i1 %10, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %BigInteger.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj, i64 0)
  ret ptr %BigInteger.obj

if.end:                                           ; preds = %entry
  %BigInteger.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BigInteger, ptr null, i64 1) to i64))
  call void @BigInteger.BigInteger(ptr %BigInteger.obj2, i64 0)
  store ptr %BigInteger.obj2, ptr %rem, align 8
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len3 = load i32, ptr %len, align 4, !tbaa !4
  %11 = sub i32 %len3, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i4 = load i32, ptr %i, align 4
  %12 = icmp sge i32 %i4, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %rem5 = load ptr, ptr %rem, align 8
  %dig = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig6 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i7 = load i32, ptr %i, align 4
  %14 = sext i32 %i7 to i64
  %arr.len8 = load i64, ptr %dig6, align 8
  %arr.oob = icmp uge i64 %14, %arr.len8
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %while.end
  %15 = load i32, ptr %i, align 4
  %16 = sub i32 %15, 1
  store i32 %16, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %rem13 = load ptr, ptr %rem, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %rem13, i32 0, i32 3
  %neg14 = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg15 = load i32, ptr %neg14, align 4, !tbaa !4
  store i32 %neg15, ptr %neg, align 4, !tbaa !4
  %rem16 = load ptr, ptr %rem, align 8
  call void @BigInteger.normSign(ptr %rem16)
  %rem17 = load ptr, ptr %rem, align 8
  ret ptr %rem17

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3242, ptr @.faila.3243, i64 %14, ptr @.failb.3244, i64 %arr.len8, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %dig6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %14
  %elem = load i32, ptr %arr.elem, align 4
  call void @BigInteger.mulTenAddInPlace(ptr %rem5, i32 %elem)
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok
  %rem9 = load ptr, ptr %rem, align 8
  %other10 = load ptr, ptr %other, align 8
  %17 = call i32 @BigInteger.cmpMag(ptr %rem9, ptr %other10)
  %18 = icmp sge i32 %17, 0
  %19 = zext i1 %18 to i32
  br i1 %18, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %rem11 = load ptr, ptr %rem, align 8
  %other12 = load ptr, ptr %other, align 8
  call void @BigInteger.subInPlace(ptr %rem11, ptr %other12)
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %for.update
}

define internal ptr @BigInteger.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %neg = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 3
  %neg1 = load i32, ptr %neg, align 4, !tbaa !4
  %sc.a = icmp ne i32 %neg1, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %1 = call i32 @BigInteger.isZero(ptr %0)
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  %sc.b = icmp ne i32 %3, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %4 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %sb2 = load ptr, ptr %sb, align 8
  %5 = call ptr @StringBuilder.appendChar(ptr %sb2, i32 45)
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  %len = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 2
  %len3 = load i32, ptr %len, align 4, !tbaa !4
  %6 = sub i32 %len3, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i4 = load i32, ptr %i, align 4
  %7 = icmp sge i32 %i4, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sb5 = load ptr, ptr %sb, align 8
  %dig = getelementptr inbounds %class.BigInteger, ptr %0, i32 0, i32 1
  %dig6 = load ptr, ptr %dig, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i7 = load i32, ptr %i, align 4
  %9 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %dig6, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %10 = load i32, ptr %i, align 4
  %11 = sub i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb8 = load ptr, ptr %sb, align 8
  %12 = call ptr @StringBuilder.toString(ptr %sb8)
  %strcpy = call ptr @__polaron_str_copy(ptr %12)
  call void @__polaron_str_free(ptr %12)
  ret ptr %strcpy

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3245, ptr @.faila.3246, i64 %9, ptr @.failb.3247, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %dig6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %9
  %elem = load i32, ptr %arr.elem, align 4
  %13 = add i32 48, %elem
  %14 = call ptr @StringBuilder.appendChar(ptr %sb5, i32 %13)
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5324)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5326)
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
