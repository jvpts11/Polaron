; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/probabilistic.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/probabilistic.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.CountMinSketch = type { ptr, ptr, i32, i32 }
%class.HyperLogLog = type { ptr, ptr, i32, i32 }
%class.StringBuilder = type { ptr, i64, i32, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@HyperLogLog.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @HyperLogLog.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @HyperLogLog.estimate, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@CountMinSketch.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @CountMinSketch.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @CountMinSketch.hash, ptr @CountMinSketch.estimate, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [2 x i8] c"a\00"
@.strobj = private global %String { i64 1, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [2 x i8] c"b\00"
@.strobj.2 = private global %String { i64 1, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c"c\00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [37 x i8] c"cms_a=%d cms_b=%d cms_c=%d cms_z=%d\0A\00", align 1
@.strdata.5 = private constant [2 x i8] c"a\00"
@.strobj.6 = private global %String { i64 1, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [2 x i8] c"b\00"
@.strobj.8 = private global %String { i64 1, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [2 x i8] c"c\00"
@.strobj.10 = private global %String { i64 1, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [2 x i8] c"z\00"
@.strobj.12 = private global %String { i64 1, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [5 x i8] c"item\00"
@.strobj.14 = private global %String { i64 4, ptr @.strdata.13, i64 0 }
@.str.15 = private unnamed_addr constant [27 x i8] c"hll_est=%d within10pct=%d\0A\00", align 1
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
@.fail.3640 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6144:37  in CountMinSketch.add\0A\00", align 1
@.faila.3641 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3642 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3643 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6144:37  in CountMinSketch.add\0A\00", align 1
@.faila.3644 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3645 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3646 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6151:21  in CountMinSketch.estimate\0A\00", align 1
@.faila.3647 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3648 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3649 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6215:17  in HyperLogLog.add\0A\00", align 1
@.faila.3650 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3651 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3652 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6215:59  in HyperLogLog.add\0A\00", align 1
@.faila.3653 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3654 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3655 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6223:25  in HyperLogLog.estimate\0A\00", align 1
@.faila.3656 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3657 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3658 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:6224:21  in HyperLogLog.estimate\0A\00", align 1
@.faila.3659 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3660 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %err = alloca i32, align 4
  %est = alloca i32, align 4
  %sb = alloca ptr, align 8
  %i = alloca i32, align 4
  %hll = alloca ptr, align 8
  %cms = alloca ptr, align 8
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
  %CountMinSketch.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.CountMinSketch, ptr null, i64 1) to i64))
  call void @CountMinSketch.CountMinSketch(ptr %CountMinSketch.obj, i32 1000, i32 4)
  store ptr %CountMinSketch.obj, ptr %cms, align 8
  %cms1 = load ptr, ptr %cms, align 8
  call void @CountMinSketch.add(ptr %cms1, ptr @.strobj, i32 5)
  %cms2 = load ptr, ptr %cms, align 8
  call void @CountMinSketch.add(ptr %cms2, ptr @.strobj.2, i32 3)
  %cms3 = load ptr, ptr %cms, align 8
  call void @CountMinSketch.add(ptr %cms3, ptr @.strobj.4, i32 1)
  %cms4 = load ptr, ptr %cms, align 8
  %16 = call i32 @CountMinSketch.estimate(ptr %cms4, ptr @.strobj.6)
  %cms5 = load ptr, ptr %cms, align 8
  %17 = call i32 @CountMinSketch.estimate(ptr %cms5, ptr @.strobj.8)
  %cms6 = load ptr, ptr %cms, align 8
  %18 = call i32 @CountMinSketch.estimate(ptr %cms6, ptr @.strobj.10)
  %cms7 = load ptr, ptr %cms, align 8
  %19 = call i32 @CountMinSketch.estimate(ptr %cms7, ptr @.strobj.12)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19)
  %HyperLogLog.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.HyperLogLog, ptr null, i64 1) to i64))
  call void @HyperLogLog.HyperLogLog(ptr %HyperLogLog.obj, i32 10)
  store ptr %HyperLogLog.obj, ptr %hll, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i8 = load i32, ptr %i, align 4
  %21 = icmp slt i32 %i8, 1000
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb9 = load ptr, ptr %sb, align 8
  %23 = call ptr @StringBuilder.append(ptr %sb9, ptr @.strobj.14)
  %i10 = load i32, ptr %i, align 4
  %24 = call ptr @StringBuilder.appendInt(ptr %23, i32 %i10)
  %hll11 = load ptr, ptr %hll, align 8
  %sb12 = load ptr, ptr %sb, align 8
  %25 = call ptr @StringBuilder.toString(ptr %sb12)
  call void @HyperLogLog.add(ptr %hll11, ptr %25)
  call void @__polaron_str_free(ptr %25)
  br label %for.update

for.update:                                       ; preds = %for.body
  %26 = load i32, ptr %i, align 4
  %27 = add i32 %26, 1
  store i32 %27, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %hll13 = load ptr, ptr %hll, align 8
  %28 = call i32 @HyperLogLog.estimate(ptr %hll13)
  store i32 %28, ptr %est, align 4
  %est14 = load i32, ptr %est, align 4
  %29 = sub i32 %est14, 1000
  store i32 %29, ptr %err, align 4
  %err15 = load i32, ptr %err, align 4
  %30 = icmp slt i32 %err15, 0
  %31 = zext i1 %30 to i32
  br i1 %30, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  %err16 = load i32, ptr %err, align 4
  %32 = sub i32 0, %err16
  store i32 %32, ptr %err, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end
  %est17 = load i32, ptr %est, align 4
  %err18 = load i32, ptr %err, align 4
  %33 = icmp sle i32 %err18, 100
  %34 = zext i1 %33 to i32
  %35 = call i32 (ptr, ...) @printf(ptr @.str.15, i32 %est17, i32 %34)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1322)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1324)
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

define internal void @CountMinSketch.CountMinSketch(ptr %0, i32 %1, i32 %2) {
entry:
  %depth = alloca i32, align 4
  %width = alloca i32, align 4
  store i32 %1, ptr %width, align 4
  store i32 %2, ptr %depth, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 0
  store ptr @CountMinSketch.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %table = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 1
  store ptr null, ptr %table, align 8, !tbaa !0
  %w = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 3
  %width1 = load i32, ptr %width, align 4
  store i32 %width1, ptr %w, align 4, !tbaa !4
  %d = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 2
  %depth2 = load i32, ptr %depth, align 4
  store i32 %depth2, ptr %d, align 4, !tbaa !4
  %table3 = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 1
  %width4 = load i32, ptr %width, align 4
  %depth5 = load i32, ptr %depth, align 4
  %3 = mul i32 %width4, %depth5
  %4 = sext i32 %3 to i64
  %5 = mul i64 %4, 4
  %6 = add i64 8, %5
  %arr = call ptr @__polaron_malloc(i64 %6)
  store i64 %4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %7 = call ptr @memset(ptr %arr.data, i32 0, i64 %5)
  store ptr %arr, ptr %table3, align 8, !tbaa !0
  ret void
}

define internal i32 @CountMinSketch.hash(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %acc = alloca i32, align 4
  %row = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store i32 %2, ptr %row, align 4
  %row1 = load i32, ptr %row, align 4
  %3 = mul i32 %row1, 31
  %4 = add i32 17, %3
  store i32 %4, ptr %acc, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %key3 = load ptr, ptr %key, align 8
  %str.len = getelementptr inbounds %String, ptr %key3, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %5 = trunc i64 %len to i32
  %6 = icmp slt i32 %i2, %5
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %acc4 = load i32, ptr %acc, align 4
  %8 = mul i32 %acc4, 131
  %key5 = load ptr, ptr %key, align 8
  %i6 = load i32, ptr %i, align 4
  %9 = sext i32 %i6 to i64
  %str.data = getelementptr inbounds %String, ptr %key5, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %9
  %ch = load i8, ptr %ch.addr, align 1
  %10 = zext i8 %ch to i32
  %11 = and i32 %10, 255
  %12 = add i32 %8, %11
  store i32 %12, ptr %acc, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %acc7 = load i32, ptr %acc, align 4
  %15 = and i32 %acc7, 2147483647
  store i32 %15, ptr %acc, align 4
  %acc8 = load i32, ptr %acc, align 4
  %w = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 3
  %w9 = load i32, ptr %w, align 4, !tbaa !4
  %16 = icmp eq i32 %w9, 0
  %17 = icmp eq i32 %acc8, -2147483648
  %18 = icmp eq i32 %w9, -1
  %19 = and i1 %17, %18
  %20 = or i1 %16, %19
  br i1 %20, label %div.bad, label %div.ok

div.bad:                                          ; preds = %for.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.end
  %21 = srem i32 %acc8, %w9
  ret i32 %21
}

define internal void @CountMinSketch.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2) {
entry:
  %idx = alloca i32, align 4
  %r = alloca i32, align 4
  %count = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store i32 %2, ptr %count, align 4
  store i32 0, ptr %r, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %r1 = load i32, ptr %r, align 4
  %d = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 2
  %d2 = load i32, ptr %d, align 4, !tbaa !4
  %3 = icmp slt i32 %r1, %d2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r3 = load i32, ptr %r, align 4
  %w = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 3
  %w4 = load i32, ptr %w, align 4, !tbaa !4
  %5 = mul i32 %r3, %w4
  %key5 = load ptr, ptr %key, align 8
  %r6 = load i32, ptr %r, align 4
  %6 = call i32 @CountMinSketch.hash(ptr %0, ptr %key5, i32 %r6)
  %7 = add i32 %5, %6
  store i32 %7, ptr %idx, align 4
  %table = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 1
  %table7 = load ptr, ptr %table, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %idx8 = load i32, ptr %idx, align 4
  %8 = sext i32 %idx8 to i64
  %arr.len = load i64, ptr %table7, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok15
  %9 = load i32, ptr %r, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %r, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3640, ptr @.faila.3641, i64 %8, ptr @.failb.3642, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %table7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %table9 = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 1
  %table10 = load ptr, ptr %table9, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %idx11 = load i32, ptr %idx, align 4
  %11 = sext i32 %idx11 to i64
  %arr.len12 = load i64, ptr %table10, align 8
  %arr.oob13 = icmp uge i64 %11, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !10

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3643, ptr @.faila.3644, i64 %11, ptr @.failb.3645, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %table10, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %11
  %elem = load i32, ptr %arr.elem17, align 4
  %count18 = load i32, ptr %count, align 4
  %12 = add i32 %elem, %count18
  store i32 %12, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @CountMinSketch.estimate(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %v = alloca i32, align 4
  %r = alloca i32, align 4
  %best = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store i32 2147483647, ptr %best, align 4
  store i32 0, ptr %r, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %r1 = load i32, ptr %r, align 4
  %d = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 2
  %d2 = load i32, ptr %d, align 4, !tbaa !4
  %2 = icmp slt i32 %r1, %d2
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %table = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 1
  %table3 = load ptr, ptr %table, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %r4 = load i32, ptr %r, align 4
  %w = getelementptr inbounds %class.CountMinSketch, ptr %0, i32 0, i32 3
  %w5 = load i32, ptr %w, align 4, !tbaa !4
  %4 = mul i32 %r4, %w5
  %key6 = load ptr, ptr %key, align 8
  %r7 = load i32, ptr %r, align 4
  %5 = call i32 @CountMinSketch.hash(ptr %0, ptr %key6, i32 %r7)
  %6 = add i32 %4, %5
  %7 = sext i32 %6 to i64
  %arr.len = load i64, ptr %table3, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end
  %8 = load i32, ptr %r, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %r, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best11 = load i32, ptr %best, align 4
  ret i32 %best11

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3646, ptr @.faila.3647, i64 %7, ptr @.failb.3648, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %table3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %7
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %v, align 4
  %v8 = load i32, ptr %v, align 4
  %best9 = load i32, ptr %best, align 4
  %10 = icmp slt i32 %v8, %best9
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %v10 = load i32, ptr %v, align 4
  store i32 %v10, ptr %best, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok
  br label %for.update
}

define internal void @HyperLogLog.HyperLogLog(ptr %0, i32 %1) {
entry:
  %precision = alloca i32, align 4
  store i32 %1, ptr %precision, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 0
  store ptr @HyperLogLog.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %reg = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 1
  store ptr null, ptr %reg, align 8, !tbaa !0
  %p = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 2
  %precision1 = load i32, ptr %precision, align 4
  store i32 %precision1, ptr %p, align 4, !tbaa !4
  %m = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %precision2 = load i32, ptr %precision, align 4
  %2 = icmp ult i32 %precision2, 32
  %3 = select i1 %2, i32 %precision2, i32 0
  %4 = shl i32 1, %3
  %5 = select i1 %2, i32 %4, i32 0
  store i32 %5, ptr %m, align 4, !tbaa !4
  %reg3 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 1
  %m4 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m5 = load i32, ptr %m4, align 4, !tbaa !4
  %6 = sext i32 %m5 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %9 = call ptr @memset(ptr %arr.data, i32 0, i64 %7)
  store ptr %arr, ptr %reg3, align 8, !tbaa !0
  ret void
}

define internal i32 @HyperLogLog.mix(ptr %0) {
entry:
  %i = alloca i32, align 4
  %h = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store i32 -2128831035, ptr %h, align 4
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
  %h3 = load i32, ptr %h, align 4
  %s4 = load ptr, ptr %s, align 8
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = and i32 %5, 255
  %7 = xor i32 %h3, %6
  %8 = mul i32 %7, 16777619
  store i32 %8, ptr %h, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %h6 = load i32, ptr %h, align 4
  %h7 = load i32, ptr %h, align 4
  %11 = lshr i32 %h7, 16
  %12 = xor i32 %h6, %11
  store i32 %12, ptr %h, align 4
  %h8 = load i32, ptr %h, align 4
  %13 = mul i32 %h8, -2048144777
  store i32 %13, ptr %h, align 4
  %h9 = load i32, ptr %h, align 4
  %h10 = load i32, ptr %h, align 4
  %14 = lshr i32 %h10, 13
  %15 = xor i32 %h9, %14
  store i32 %15, ptr %h, align 4
  %h11 = load i32, ptr %h, align 4
  %16 = mul i32 %h11, -1028477379
  store i32 %16, ptr %h, align 4
  %h12 = load i32, ptr %h, align 4
  %h13 = load i32, ptr %h, align 4
  %17 = lshr i32 %h13, 16
  %18 = xor i32 %h12, %17
  store i32 %18, ptr %h, align 4
  %h14 = load i32, ptr %h, align 4
  ret i32 %h14
}

define internal i32 @HyperLogLog.clz(i32 %0) {
entry:
  %v = alloca i32, align 4
  %n = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %1 = icmp eq i32 %x1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 32

if.end:                                           ; preds = %entry
  store i32 0, ptr %n, align 4
  %x2 = load i32, ptr %x, align 4
  store i32 %x2, ptr %v, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %v3 = load i32, ptr %v, align 4
  %3 = and i32 %v3, -2147483648
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n4 = load i32, ptr %n, align 4
  %6 = add i32 %n4, 1
  store i32 %6, ptr %n, align 4
  %v5 = load i32, ptr %v, align 4
  %7 = shl i32 %v5, 1
  store i32 %7, ptr %v, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n6 = load i32, ptr %n, align 4
  ret i32 %n6
}

define internal double @HyperLogLog.ln(double %0) {
entry:
  %k = alloca i32, align 4
  %sum = alloca double, align 8
  %term = alloca double, align 8
  %t2 = alloca double, align 8
  %t = alloca double, align 8
  %e = alloca i32, align 4
  %v = alloca double, align 8
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %1 = fcmp ole double %x1, 0.000000e+00
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret double 0.000000e+00

if.end:                                           ; preds = %entry
  %x2 = load double, ptr %x, align 8
  store double %x2, ptr %v, align 8
  store i32 0, ptr %e, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %v3 = load double, ptr %v, align 8
  %3 = fcmp oge double %v3, 2.000000e+00
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v4 = load double, ptr %v, align 8
  %5 = fdiv double %v4, 2.000000e+00
  store double %5, ptr %v, align 8
  %e5 = load i32, ptr %e, align 4
  %6 = add i32 %e5, 1
  store i32 %6, ptr %e, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %while.cond6

while.cond6:                                      ; preds = %while.body7, %while.end
  %v9 = load double, ptr %v, align 8
  %7 = fcmp olt double %v9, 1.000000e+00
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body7, label %while.end8

while.body7:                                      ; preds = %while.cond6
  %v10 = load double, ptr %v, align 8
  %9 = fmul double %v10, 2.000000e+00
  store double %9, ptr %v, align 8
  %e11 = load i32, ptr %e, align 4
  %10 = sub i32 %e11, 1
  store i32 %10, ptr %e, align 4
  br label %while.cond6

while.end8:                                       ; preds = %while.cond6
  %v12 = load double, ptr %v, align 8
  %11 = fsub double %v12, 1.000000e+00
  %v13 = load double, ptr %v, align 8
  %12 = fadd double %v13, 1.000000e+00
  %13 = fdiv double %11, %12
  store double %13, ptr %t, align 8
  %t14 = load double, ptr %t, align 8
  %t15 = load double, ptr %t, align 8
  %14 = fmul double %t14, %t15
  store double %14, ptr %t2, align 8
  %t16 = load double, ptr %t, align 8
  store double %t16, ptr %term, align 8
  store double 0.000000e+00, ptr %sum, align 8
  store i32 1, ptr %k, align 4
  br label %while.cond17

while.cond17:                                     ; preds = %while.body18, %while.end8
  %k20 = load i32, ptr %k, align 4
  %15 = icmp sle i32 %k20, 15
  %16 = zext i1 %15 to i32
  br i1 %15, label %while.body18, label %while.end19

while.body18:                                     ; preds = %while.cond17
  %sum21 = load double, ptr %sum, align 8
  %term22 = load double, ptr %term, align 8
  %k23 = load i32, ptr %k, align 4
  %17 = sitofp i32 %k23 to double
  %18 = fdiv double %term22, %17
  %19 = fadd double %sum21, %18
  store double %19, ptr %sum, align 8
  %term24 = load double, ptr %term, align 8
  %t225 = load double, ptr %t2, align 8
  %20 = fmul double %term24, %t225
  store double %20, ptr %term, align 8
  %k26 = load i32, ptr %k, align 4
  %21 = add i32 %k26, 2
  store i32 %21, ptr %k, align 4
  br label %while.cond17

while.end19:                                      ; preds = %while.cond17
  %sum27 = load double, ptr %sum, align 8
  %22 = fmul double 2.000000e+00, %sum27
  %e28 = load i32, ptr %e, align 4
  %23 = sitofp i32 %e28 to double
  %24 = fmul double %23, 0x3FE62E42FEFA39EF
  %25 = fadd double %22, %24
  ret double %25
}

define internal void @HyperLogLog.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %rank = alloca i32, align 4
  %rest = alloca i32, align 4
  %idx = alloca i32, align 4
  %h = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %key1 = load ptr, ptr %key, align 8
  %2 = call i32 @HyperLogLog.mix(ptr %key1)
  store i32 %2, ptr %h, align 4
  %h2 = load i32, ptr %h, align 4
  %m = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m3 = load i32, ptr %m, align 4, !tbaa !4
  %3 = sub i32 %m3, 1
  %4 = and i32 %h2, %3
  store i32 %4, ptr %idx, align 4
  %h4 = load i32, ptr %h, align 4
  %p = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 2
  %p5 = load i32, ptr %p, align 4, !tbaa !4
  %5 = icmp ult i32 %p5, 32
  %6 = select i1 %5, i32 %p5, i32 0
  %7 = lshr i32 %h4, %6
  %8 = select i1 %5, i32 %7, i32 0
  %p6 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 2
  %p7 = load i32, ptr %p6, align 4, !tbaa !4
  %9 = sub i32 31, %p7
  %10 = icmp ult i32 %9, 32
  %11 = select i1 %10, i32 %9, i32 0
  %12 = shl i32 1, %11
  %13 = select i1 %10, i32 %12, i32 0
  %14 = or i32 %8, %13
  store i32 %14, ptr %rest, align 4
  %rest8 = load i32, ptr %rest, align 4
  %15 = call i32 @HyperLogLog.clz(i32 %rest8)
  %16 = add i32 %15, 1
  %p9 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 2
  %p10 = load i32, ptr %p9, align 4, !tbaa !4
  %17 = sub i32 %16, %p10
  store i32 %17, ptr %rank, align 4
  %rank11 = load i32, ptr %rank, align 4
  %18 = icmp slt i32 %rank11, 1
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, ptr %rank, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %rank12 = load i32, ptr %rank, align 4
  %reg = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 1
  %reg13 = load ptr, ptr %reg, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %idx14 = load i32, ptr %idx, align 4
  %20 = sext i32 %idx14 to i64
  %arr.len = load i64, ptr %reg13, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.3649, ptr @.faila.3650, i64 %20, ptr @.failb.3651, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %reg13, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %20
  %elem = load i32, ptr %arr.elem, align 4
  %21 = icmp sgt i32 %rank12, %elem
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then15, label %if.end16

if.then15:                                        ; preds = %idx.ok
  %reg17 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 1
  %reg18 = load ptr, ptr %reg17, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %idx19 = load i32, ptr %idx, align 4
  %23 = sext i32 %idx19 to i64
  %arr.len20 = load i64, ptr %reg18, align 8
  %arr.oob21 = icmp uge i64 %23, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

if.end16:                                         ; preds = %idx.ok23, %idx.ok
  ret void

idx.bad22:                                        ; preds = %if.then15
  call void @__polaron_fail(ptr @.fail.3652, ptr @.faila.3653, i64 %23, ptr @.failb.3654, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then15
  %arr.data24 = getelementptr i8, ptr %reg18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %23
  %rank26 = load i32, ptr %rank, align 4
  store i32 %rank26, ptr %arr.elem25, align 4
  br label %if.end16
}

define internal i32 @HyperLogLog.estimate(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %est = alloca double, align 8
  %i = alloca i32, align 4
  %zeros = alloca i32, align 4
  %sum = alloca double, align 8
  %alpha = alloca double, align 8
  %m = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m1 = load i32, ptr %m, align 4, !tbaa !4
  %1 = sitofp i32 %m1 to double
  %2 = fdiv double 1.079000e+00, %1
  %3 = fadd double 1.000000e+00, %2
  %4 = fdiv double 7.213000e-01, %3
  store double %4, ptr %alpha, align 8
  store double 0.000000e+00, ptr %sum, align 8
  store i32 0, ptr %zeros, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %m3 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m4 = load i32, ptr %m3, align 4, !tbaa !4
  %5 = icmp slt i32 %i2, %m4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sum5 = load double, ptr %sum, align 8
  %reg = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 1
  %reg6 = load ptr, ptr %reg, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i7 = load i32, ptr %i, align 4
  %7 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %reg6, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %alpha19 = load double, ptr %alpha, align 8
  %m20 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m21 = load i32, ptr %m20, align 4, !tbaa !4
  %10 = sitofp i32 %m21 to double
  %11 = fmul double %alpha19, %10
  %m22 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m23 = load i32, ptr %m22, align 4, !tbaa !4
  %12 = sitofp i32 %m23 to double
  %13 = fmul double %11, %12
  %sum24 = load double, ptr %sum, align 8
  %14 = fdiv double %13, %sum24
  store double %14, ptr %est, align 8
  %est25 = load double, ptr %est, align 8
  %m26 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m27 = load i32, ptr %m26, align 4, !tbaa !4
  %15 = sitofp i32 %m27 to double
  %16 = fmul double 2.500000e+00, %15
  %17 = fcmp ole double %est25, %16
  %18 = zext i1 %17 to i32
  %sc.a = icmp ne i32 %18, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3655, ptr @.faila.3656, i64 %7, ptr @.failb.3657, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %reg6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %7
  %elem = load i32, ptr %arr.elem, align 4
  %19 = icmp ult i32 %elem, 32
  %20 = select i1 %19, i32 %elem, i32 0
  %21 = shl i32 1, %20
  %22 = select i1 %19, i32 %21, i32 0
  %23 = sitofp i32 %22 to double
  %24 = fdiv double 1.000000e+00, %23
  %25 = fadd double %sum5, %24
  store double %25, ptr %sum, align 8
  %reg8 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 1
  %reg9 = load ptr, ptr %reg8, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i10 = load i32, ptr %i, align 4
  %26 = sext i32 %i10 to i64
  %arr.len11 = load i64, ptr %reg9, align 8
  %arr.oob12 = icmp uge i64 %26, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !10

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3658, ptr @.faila.3659, i64 %26, ptr @.failb.3660, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %reg9, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %26
  %elem17 = load i32, ptr %arr.elem16, align 4
  %27 = icmp eq i32 %elem17, 0
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok14
  %zeros18 = load i32, ptr %zeros, align 4
  %29 = add i32 %zeros18, 1
  store i32 %29, ptr %zeros, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok14
  br label %for.update

sc.rhs:                                           ; preds = %for.end
  %zeros28 = load i32, ptr %zeros, align 4
  %30 = icmp sgt i32 %zeros28, 0
  %31 = zext i1 %30 to i32
  %sc.b = icmp ne i32 %31, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %for.end
  %sc = phi i1 [ false, %for.end ], [ %sc.b, %sc.rhs ]
  %32 = zext i1 %sc to i32
  br i1 %sc, label %if.then29, label %if.end30

if.then29:                                        ; preds = %sc.end
  %m31 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m32 = load i32, ptr %m31, align 4, !tbaa !4
  %33 = sitofp i32 %m32 to double
  %m33 = getelementptr inbounds %class.HyperLogLog, ptr %0, i32 0, i32 3
  %m34 = load i32, ptr %m33, align 4, !tbaa !4
  %34 = sitofp i32 %m34 to double
  %zeros35 = load i32, ptr %zeros, align 4
  %35 = sitofp i32 %zeros35 to double
  %36 = fdiv double %34, %35
  %37 = call double @HyperLogLog.ln(double %36)
  %38 = fmul double %33, %37
  store double %38, ptr %est, align 8
  br label %if.end30

if.end30:                                         ; preds = %if.then29, %sc.end
  %est36 = load double, ptr %est, align 8
  %39 = call i32 @llvm.fptosi.sat.i32.f64(double %est36)
  ret i32 %39
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

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #1

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

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
