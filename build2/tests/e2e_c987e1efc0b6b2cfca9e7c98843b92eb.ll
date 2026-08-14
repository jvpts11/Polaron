; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_queries.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_queries.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Fenwick = type { ptr, ptr, i32 }
%class.SegmentTree = type { ptr, ptr, i32 }
%class.SparseTable = type { ptr, ptr, i32, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Fenwick.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Fenwick.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Fenwick.prefixSum, ptr @Fenwick.rangeSum, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@SegmentTree.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @SegmentTree.update, ptr @SegmentTree.query, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@SparseTable.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @SparseTable.queryMin, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [24 x i8] c"fw_pre7=%d fw_r2to5=%d\0A\00", align 1
@.fail = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_queries.pol:21:24  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_queries.pol:21:35  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_queries.pol:21:46  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_queries.pol:21:57  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_queries.pol:21:68  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_queries.pol:21:79  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.16 = private unnamed_addr constant [21 x i8] c"seg_q1=%d seg_q2=%d\0A\00", align 1
@.str.17 = private unnamed_addr constant [37 x i8] c"min_0to5=%d min_2to4=%d min_4to5=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1324 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1325 = private global %String { i64 16, ptr @.strdata.1324, i64 0 }
@.strdata.1326 = private constant [17 x i8] c"division by zero\00"
@.strobj.1327 = private global %String { i64 16, ptr @.strdata.1326, i64 0 }
@.fail.1933 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2560:52  in Fenwick.add\0A\00", align 1
@.faila.1934 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1935 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1936 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2560:52  in Fenwick.add\0A\00", align 1
@.faila.1937 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1938 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1939 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2566:35  in Fenwick.prefixSum\0A\00", align 1
@.faila.1940 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1941 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1942 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2582:79  in SegmentTree.SegmentTree\0A\00", align 1
@.faila.1943 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1944 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1945 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2582:79  in SegmentTree.SegmentTree\0A\00", align 1
@.faila.1946 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1947 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1948 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2583:81  in SegmentTree.SegmentTree\0A\00", align 1
@.faila.1949 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1950 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1951 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2583:81  in SegmentTree.SegmentTree\0A\00", align 1
@.faila.1952 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1953 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1954 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2583:81  in SegmentTree.SegmentTree\0A\00", align 1
@.faila.1955 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1956 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1957 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2587:27  in SegmentTree.update\0A\00", align 1
@.faila.1958 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1959 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1960 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2589:44  in SegmentTree.update\0A\00", align 1
@.faila.1961 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1962 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1963 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2589:44  in SegmentTree.update\0A\00", align 1
@.faila.1964 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1965 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1966 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2589:44  in SegmentTree.update\0A\00", align 1
@.faila.1967 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1968 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1969 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2597:45  in SegmentTree.query\0A\00", align 1
@.faila.1970 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1971 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1972 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2598:56  in SegmentTree.query\0A\00", align 1
@.faila.1973 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1974 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1975 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2616:74  in SparseTable.SparseTable\0A\00", align 1
@.faila.1976 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1977 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1978 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2616:74  in SparseTable.SparseTable\0A\00", align 1
@.faila.1979 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1980 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1981 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2620:25  in SparseTable.SparseTable\0A\00", align 1
@.faila.1982 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1983 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1984 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2621:25  in SparseTable.SparseTable\0A\00", align 1
@.faila.1985 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1986 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1987 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2622:63  in SparseTable.SparseTable\0A\00", align 1
@.faila.1988 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1989 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1990 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2622:102  in SparseTable.SparseTable\0A\00", align 1
@.faila.1991 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1992 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1993 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2631:17  in SparseTable.queryMin\0A\00", align 1
@.faila.1994 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1995 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1996 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2632:17  in SparseTable.queryMin\0A\00", align 1
@.faila.1997 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1998 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5325 = private constant [1 x i8] zeroinitializer
@.strobj.5326 = private global %String { i64 0, ptr @.strdata.5325, i64 0 }
@.strdata.5327 = private constant [1 x i8] zeroinitializer
@.strobj.5328 = private global %String { i64 0, ptr @.strdata.5327, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %sp = alloca ptr, align 8
  %q2 = alloca i32, align 4
  %q1 = alloca i32, align 4
  %st = alloca ptr, align 8
  %data = alloca ptr, align 8
  %i = alloca i32, align 4
  %fw = alloca ptr, align 8
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
  %Fenwick.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Fenwick, ptr null, i64 1) to i64))
  call void @Fenwick.Fenwick(ptr %Fenwick.obj, i32 8)
  store ptr %Fenwick.obj, ptr %fw, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i1 = load i32, ptr %i, align 4
  %16 = icmp slt i32 %i1, 8
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %fw2 = load ptr, ptr %fw, align 8
  %i3 = load i32, ptr %i, align 4
  %i4 = load i32, ptr %i, align 4
  %18 = add i32 %i4, 1
  call void @Fenwick.add(ptr %fw2, i32 %i3, i32 %18)
  br label %for.update

for.update:                                       ; preds = %for.body
  %19 = load i32, ptr %i, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %fw5 = load ptr, ptr %fw, align 8
  call void @Fenwick.add(ptr %fw5, i32 3, i32 10)
  %fw6 = load ptr, ptr %fw, align 8
  %21 = call i32 @Fenwick.prefixSum(ptr %fw6, i32 7)
  %fw7 = load ptr, ptr %fw, align 8
  %22 = call i32 @Fenwick.rangeSum(ptr %fw7, i32 2, i32 5)
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %21, i32 %22)
  %arr = call ptr @__polaron_malloc(i64 32)
  store i64 6, ptr %arr, align 8
  %arr.data8 = getelementptr i8, ptr %arr, i64 8
  %24 = call ptr @memset(ptr %arr.data8, i32 0, i64 24)
  store ptr %arr, ptr %data, align 8
  %data9 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %for.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.end
  %arr.data10 = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data10, i64 0
  store i32 5, ptr %arr.elem, align 4
  %data11 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %data11, align 8
  %arr.oob13 = icmp uge i64 1, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %data11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 1
  store i32 2, ptr %arr.elem17, align 4
  %data18 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %data18, align 8
  %arr.oob20 = icmp uge i64 2, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %data18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 2
  store i32 7, ptr %arr.elem24, align 4
  %data25 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len26 = load i64, ptr %data25, align 8
  %arr.oob27 = icmp uge i64 3, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %data25, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 3
  store i32 1, ptr %arr.elem31, align 4
  %data32 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len33 = load i64, ptr %data32, align 8
  %arr.oob34 = icmp uge i64 4, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok29
  %arr.data37 = getelementptr i8, ptr %data32, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 4
  store i32 9, ptr %arr.elem38, align 4
  %data39 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %arr.len40 = load i64, ptr %data39, align 8
  %arr.oob41 = icmp uge i64 5, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !2

idx.bad42:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 5, ptr @.failb.15, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok36
  %arr.data44 = getelementptr i8, ptr %data39, i64 8
  %arr.elem45 = getelementptr inbounds i32, ptr %arr.data44, i64 5
  store i32 3, ptr %arr.elem45, align 4
  %SegmentTree.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.SegmentTree, ptr null, i64 1) to i64))
  %data46 = load ptr, ptr %data, align 8
  call void @SegmentTree.SegmentTree(ptr %SegmentTree.obj, ptr %data46)
  store ptr %SegmentTree.obj, ptr %st, align 8
  %st47 = load ptr, ptr %st, align 8
  %25 = call i32 @SegmentTree.query(ptr %st47, i32 1, i32 4)
  store i32 %25, ptr %q1, align 4
  %st48 = load ptr, ptr %st, align 8
  call void @SegmentTree.update(ptr %st48, i32 3, i32 20)
  %st49 = load ptr, ptr %st, align 8
  %26 = call i32 @SegmentTree.query(ptr %st49, i32 1, i32 4)
  store i32 %26, ptr %q2, align 4
  %q150 = load i32, ptr %q1, align 4
  %q251 = load i32, ptr %q2, align 4
  %27 = call i32 (ptr, ...) @printf(ptr @.str.16, i32 %q150, i32 %q251)
  %SparseTable.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.SparseTable, ptr null, i64 1) to i64))
  %data52 = load ptr, ptr %data, align 8
  call void @SparseTable.SparseTable(ptr %SparseTable.obj, ptr %data52)
  store ptr %SparseTable.obj, ptr %sp, align 8
  %sp53 = load ptr, ptr %sp, align 8
  %28 = call i32 @SparseTable.queryMin(ptr %sp53, i32 0, i32 5)
  %sp54 = load ptr, ptr %sp, align 8
  %29 = call i32 @SparseTable.queryMin(ptr %sp54, i32 2, i32 4)
  %sp55 = load ptr, ptr %sp, align 8
  %30 = call i32 @SparseTable.queryMin(ptr %sp55, i32 4, i32 5)
  %31 = call i32 (ptr, ...) @printf(ptr @.str.17, i32 %28, i32 %29, i32 %30)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1325)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1327)
  ret ptr %strcpy
}

define internal void @Fenwick.Fenwick(ptr %0, i32 %1) {
entry:
  %size = alloca i32, align 4
  store i32 %1, ptr %size, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Fenwick, ptr %0, i32 0, i32 0
  store ptr @Fenwick.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %tree = getelementptr inbounds %class.Fenwick, ptr %0, i32 0, i32 1
  store ptr null, ptr %tree, align 8, !tbaa !3
  %n = getelementptr inbounds %class.Fenwick, ptr %0, i32 0, i32 2
  %size1 = load i32, ptr %size, align 4
  store i32 %size1, ptr %n, align 4, !tbaa !7
  %tree2 = getelementptr inbounds %class.Fenwick, ptr %0, i32 0, i32 1
  %size3 = load i32, ptr %size, align 4
  %2 = add i32 %size3, 1
  %3 = sext i32 %2 to i64
  %4 = mul i64 %3, 4
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %tree2, align 8, !tbaa !3
  ret void
}

define internal void @Fenwick.add(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %x = alloca i32, align 4
  %delta = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store i32 %2, ptr %delta, align 4
  %i1 = load i32, ptr %i, align 4
  %3 = add i32 %i1, 1
  store i32 %3, ptr %x, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok12, %entry
  %x2 = load i32, ptr %x, align 4
  %n = getelementptr inbounds %class.Fenwick, ptr %0, i32 0, i32 2
  %n3 = load i32, ptr %n, align 4, !tbaa !7
  %4 = icmp sle i32 %x2, %n3
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %tree = getelementptr inbounds %class.Fenwick, ptr %0, i32 0, i32 1
  %tree4 = load ptr, ptr %tree, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %x5 = load i32, ptr %x, align 4
  %6 = sext i32 %x5 to i64
  %arr.len = load i64, ptr %tree4, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1933, ptr @.faila.1934, i64 %6, ptr @.failb.1935, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %tree4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %tree6 = getelementptr inbounds %class.Fenwick, ptr %0, i32 0, i32 1
  %tree7 = load ptr, ptr %tree6, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %x8 = load i32, ptr %x, align 4
  %7 = sext i32 %x8 to i64
  %arr.len9 = load i64, ptr %tree7, align 8
  %arr.oob10 = icmp uge i64 %7, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

idx.bad11:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1936, ptr @.faila.1937, i64 %7, ptr @.failb.1938, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %idx.ok
  %arr.data13 = getelementptr i8, ptr %tree7, i64 8
  %arr.elem14 = getelementptr inbounds i32, ptr %arr.data13, i64 %7
  %elem = load i32, ptr %arr.elem14, align 4
  %delta15 = load i32, ptr %delta, align 4
  %8 = add i32 %elem, %delta15
  store i32 %8, ptr %arr.elem, align 4
  %x16 = load i32, ptr %x, align 4
  %x17 = load i32, ptr %x, align 4
  %x18 = load i32, ptr %x, align 4
  %9 = sub i32 0, %x18
  %10 = and i32 %x17, %9
  %11 = add i32 %x16, %10
  store i32 %11, ptr %x, align 4
  br label %while.cond
}

define internal i32 @Fenwick.prefixSum(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %s = alloca i32, align 4
  %x = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %i1 = load i32, ptr %i, align 4
  %2 = add i32 %i1, 1
  store i32 %2, ptr %x, align 4
  store i32 0, ptr %s, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok, %entry
  %x2 = load i32, ptr %x, align 4
  %3 = icmp sgt i32 %x2, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %s3 = load i32, ptr %s, align 4
  %tree = getelementptr inbounds %class.Fenwick, ptr %0, i32 0, i32 1
  %tree4 = load ptr, ptr %tree, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %x5 = load i32, ptr %x, align 4
  %5 = sext i32 %x5 to i64
  %arr.len = load i64, ptr %tree4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  %s9 = load i32, ptr %s, align 4
  ret i32 %s9

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1939, ptr @.faila.1940, i64 %5, ptr @.failb.1941, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %tree4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  %6 = add i32 %s3, %elem
  store i32 %6, ptr %s, align 4
  %x6 = load i32, ptr %x, align 4
  %x7 = load i32, ptr %x, align 4
  %x8 = load i32, ptr %x, align 4
  %7 = sub i32 0, %x8
  %8 = and i32 %x7, %7
  %9 = sub i32 %x6, %8
  store i32 %9, ptr %x, align 4
  br label %while.cond
}

define internal i32 @Fenwick.rangeSum(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  store i32 %1, ptr %lo, align 4
  store i32 %2, ptr %hi, align 4
  %lo1 = load i32, ptr %lo, align 4
  %3 = icmp eq i32 %lo1, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %hi2 = load i32, ptr %hi, align 4
  %5 = call i32 @Fenwick.prefixSum(ptr %0, i32 %hi2)
  ret i32 %5

if.end:                                           ; preds = %entry
  %hi3 = load i32, ptr %hi, align 4
  %6 = call i32 @Fenwick.prefixSum(ptr %0, i32 %hi3)
  %lo4 = load i32, ptr %lo, align 4
  %7 = sub i32 %lo4, 1
  %8 = call i32 @Fenwick.prefixSum(ptr %0, i32 %7)
  %9 = sub i32 %6, %8
  ret i32 %9
}

define internal void @SegmentTree.SegmentTree(ptr %0, ptr %1) {
entry:
  %i24 = alloca i32, align 4
  %i = alloca i32, align 4
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 0
  store ptr @SegmentTree.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %t = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  store ptr null, ptr %t, align 8, !tbaa !3
  %n = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 2
  %data1 = load ptr, ptr %data, align 8
  %len = load i64, ptr %data1, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4, !tbaa !7
  %t2 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %n3 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 2
  %n4 = load i32, ptr %n3, align 4, !tbaa !7
  %3 = mul i32 2, %n4
  %4 = sext i32 %3 to i64
  %5 = mul i64 %4, 4
  %6 = add i64 8, %5
  %arr = call ptr @__polaron_malloc(i64 %6)
  store i64 %4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %7 = call ptr @memset(ptr %arr.data, i32 0, i64 %5)
  store ptr %arr, ptr %t2, align 8, !tbaa !3
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i5 = load i32, ptr %i, align 4
  %n6 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 2
  %n7 = load i32, ptr %n6, align 4, !tbaa !7
  %8 = icmp slt i32 %i5, %n7
  %9 = zext i1 %8 to i32
  br i1 %8, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %t8 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t9 = load ptr, ptr %t8, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %n10 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 2
  %n11 = load i32, ptr %n10, align 4, !tbaa !7
  %i12 = load i32, ptr %i, align 4
  %10 = add i32 %n11, %i12
  %11 = sext i32 %10 to i64
  %arr.len = load i64, ptr %t9, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok19
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %n22 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 2
  %n23 = load i32, ptr %n22, align 4, !tbaa !7
  %14 = sub i32 %n23, 1
  store i32 %14, ptr %i24, align 4
  br label %for.cond25

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1942, ptr @.faila.1943, i64 %11, ptr @.failb.1944, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %t9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data13, i64 %11
  %data14 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

idx.bad18:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1945, ptr @.faila.1946, i64 %15, ptr @.failb.1947, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %15
  %elem = load i32, ptr %arr.elem21, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

for.cond25:                                       ; preds = %for.update27, %for.end
  %i29 = load i32, ptr %i24, align 4
  %16 = icmp sge i32 %i29, 1
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body26, label %for.end28

for.body26:                                       ; preds = %for.cond25
  %t30 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t31 = load ptr, ptr %t30, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i32 = load i32, ptr %i24, align 4
  %18 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %t31, align 8
  %arr.oob34 = icmp uge i64 %18, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

for.update27:                                     ; preds = %idx.ok55
  %i59 = load i32, ptr %i24, align 4
  %19 = sub i32 %i59, 1
  store i32 %19, ptr %i24, align 4
  br label %for.cond25

for.end28:                                        ; preds = %for.cond25
  ret void

idx.bad35:                                        ; preds = %for.body26
  call void @__polaron_fail(ptr @.fail.1948, ptr @.faila.1949, i64 %18, ptr @.failb.1950, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %for.body26
  %arr.data37 = getelementptr i8, ptr %t31, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 %18
  %t39 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t40 = load ptr, ptr %t39, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i41 = load i32, ptr %i24, align 4
  %20 = mul i32 2, %i41
  %21 = sext i32 %20 to i64
  %arr.len42 = load i64, ptr %t40, align 8
  %arr.oob43 = icmp uge i64 %21, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !2

idx.bad44:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.1951, ptr @.faila.1952, i64 %21, ptr @.failb.1953, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok36
  %arr.data46 = getelementptr i8, ptr %t40, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 %21
  %elem48 = load i32, ptr %arr.elem47, align 4
  %t49 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t50 = load ptr, ptr %t49, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i51 = load i32, ptr %i24, align 4
  %22 = mul i32 2, %i51
  %23 = add i32 %22, 1
  %24 = sext i32 %23 to i64
  %arr.len52 = load i64, ptr %t50, align 8
  %arr.oob53 = icmp uge i64 %24, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !2

idx.bad54:                                        ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.fail.1954, ptr @.faila.1955, i64 %24, ptr @.failb.1956, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %idx.ok45
  %arr.data56 = getelementptr i8, ptr %t50, i64 8
  %arr.elem57 = getelementptr inbounds i32, ptr %arr.data56, i64 %24
  %elem58 = load i32, ptr %arr.elem57, align 4
  %25 = add i32 %elem48, %elem58
  store i32 %25, ptr %arr.elem38, align 4
  br label %for.update27
}

define internal void @SegmentTree.update(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown40 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %p = alloca i32, align 4
  %value = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store i32 %2, ptr %value, align 4
  %i1 = load i32, ptr %i, align 4
  %n = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 2
  %n2 = load i32, ptr %n, align 4, !tbaa !7
  %3 = add i32 %i1, %n2
  store i32 %3, ptr %p, align 4
  %t = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t3 = load ptr, ptr %t, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %p4 = load i32, ptr %p, align 4
  %4 = sext i32 %p4 to i64
  %arr.len = load i64, ptr %t3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1957, ptr @.faila.1958, i64 %4, ptr @.failb.1959, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %t3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %value5 = load i32, ptr %value, align 4
  store i32 %value5, ptr %arr.elem, align 4
  %p6 = load i32, ptr %p, align 4
  %5 = icmp eq i32 %p6, -2147483648
  %6 = and i1 %5, false
  %7 = or i1 false, %6
  br i1 %7, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %8 = sdiv i32 %p6, 2
  store i32 %8, ptr %p, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok38, %div.ok
  %p7 = load i32, ptr %p, align 4
  %9 = icmp sge i32 %p7, 1
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %t8 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t9 = load ptr, ptr %t8, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %p10 = load i32, ptr %p, align 4
  %11 = sext i32 %p10 to i64
  %arr.len11 = load i64, ptr %t9, align 8
  %arr.oob12 = icmp uge i64 %11, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

while.end:                                        ; preds = %while.cond
  ret void

idx.bad13:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1960, ptr @.faila.1961, i64 %11, ptr @.failb.1962, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %while.body
  %arr.data15 = getelementptr i8, ptr %t9, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %11
  %t17 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t18 = load ptr, ptr %t17, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %p19 = load i32, ptr %p, align 4
  %12 = mul i32 2, %p19
  %13 = sext i32 %12 to i64
  %arr.len20 = load i64, ptr %t18, align 8
  %arr.oob21 = icmp uge i64 %13, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

idx.bad22:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.1963, ptr @.faila.1964, i64 %13, ptr @.failb.1965, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok14
  %arr.data24 = getelementptr i8, ptr %t18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %13
  %elem = load i32, ptr %arr.elem25, align 4
  %t26 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t27 = load ptr, ptr %t26, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %p28 = load i32, ptr %p, align 4
  %14 = mul i32 2, %p28
  %15 = add i32 %14, 1
  %16 = sext i32 %15 to i64
  %arr.len29 = load i64, ptr %t27, align 8
  %arr.oob30 = icmp uge i64 %16, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !2

idx.bad31:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.1966, ptr @.faila.1967, i64 %16, ptr @.failb.1968, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok23
  %arr.data33 = getelementptr i8, ptr %t27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %16
  %elem35 = load i32, ptr %arr.elem34, align 4
  %17 = add i32 %elem, %elem35
  store i32 %17, ptr %arr.elem16, align 4
  %p36 = load i32, ptr %p, align 4
  %18 = icmp eq i32 %p36, -2147483648
  %19 = and i1 %18, false
  %20 = or i1 false, %19
  br i1 %20, label %div.bad37, label %div.ok38

div.bad37:                                        ; preds = %idx.ok32
  %exc39 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc39)
  store ptr %exc39, ptr %exc.thrown40, align 8
  call void @_CxxThrowException(ptr %exc.thrown40, ptr @_TI1PEAX)
  unreachable

div.ok38:                                         ; preds = %idx.ok32
  %21 = sdiv i32 %p36, 2
  store i32 %21, ptr %p, align 4
  br label %while.cond
}

define internal i32 @SegmentTree.query(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown33 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %r = alloca i32, align 4
  %l = alloca i32, align 4
  %res = alloca i32, align 4
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  store i32 %1, ptr %lo, align 4
  store i32 %2, ptr %hi, align 4
  store i32 0, ptr %res, align 4
  %lo1 = load i32, ptr %lo, align 4
  %n = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 2
  %n2 = load i32, ptr %n, align 4, !tbaa !7
  %3 = add i32 %lo1, %n2
  store i32 %3, ptr %l, align 4
  %hi3 = load i32, ptr %hi, align 4
  %n4 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 2
  %n5 = load i32, ptr %n4, align 4, !tbaa !7
  %4 = add i32 %hi3, %n5
  %5 = add i32 %4, 1
  store i32 %5, ptr %r, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok31, %entry
  %l6 = load i32, ptr %l, align 4
  %r7 = load i32, ptr %r, align 4
  %6 = icmp slt i32 %l6, %r7
  %7 = zext i1 %6 to i32
  br i1 %6, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %l8 = load i32, ptr %l, align 4
  %8 = and i32 %l8, 1
  %9 = icmp eq i32 %8, 1
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  %res34 = load i32, ptr %res, align 4
  ret i32 %res34

if.then:                                          ; preds = %while.body
  %res9 = load i32, ptr %res, align 4
  %t = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t10 = load ptr, ptr %t, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %l11 = load i32, ptr %l, align 4
  %11 = sext i32 %l11 to i64
  %arr.len = load i64, ptr %t10, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %idx.ok, %while.body
  %r13 = load i32, ptr %r, align 4
  %12 = and i32 %r13, 1
  %13 = icmp eq i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then14, label %if.end15

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1969, ptr @.faila.1970, i64 %11, ptr @.failb.1971, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %t10, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %11
  %elem = load i32, ptr %arr.elem, align 4
  %15 = add i32 %res9, %elem
  store i32 %15, ptr %res, align 4
  %l12 = load i32, ptr %l, align 4
  %16 = add i32 %l12, 1
  store i32 %16, ptr %l, align 4
  br label %if.end

if.then14:                                        ; preds = %if.end
  %r16 = load i32, ptr %r, align 4
  %17 = sub i32 %r16, 1
  store i32 %17, ptr %r, align 4
  %res17 = load i32, ptr %res, align 4
  %t18 = getelementptr inbounds %class.SegmentTree, ptr %0, i32 0, i32 1
  %t19 = load ptr, ptr %t18, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %r20 = load i32, ptr %r, align 4
  %18 = sext i32 %r20 to i64
  %arr.len21 = load i64, ptr %t19, align 8
  %arr.oob22 = icmp uge i64 %18, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

if.end15:                                         ; preds = %idx.ok24, %if.end
  %l28 = load i32, ptr %l, align 4
  %19 = icmp eq i32 %l28, -2147483648
  %20 = and i1 %19, false
  %21 = or i1 false, %20
  br i1 %21, label %div.bad, label %div.ok

idx.bad23:                                        ; preds = %if.then14
  call void @__polaron_fail(ptr @.fail.1972, ptr @.faila.1973, i64 %18, ptr @.failb.1974, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %if.then14
  %arr.data25 = getelementptr i8, ptr %t19, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 %18
  %elem27 = load i32, ptr %arr.elem26, align 4
  %22 = add i32 %res17, %elem27
  store i32 %22, ptr %res, align 4
  br label %if.end15

div.bad:                                          ; preds = %if.end15
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end15
  %23 = sdiv i32 %l28, 2
  store i32 %23, ptr %l, align 4
  %r29 = load i32, ptr %r, align 4
  %24 = icmp eq i32 %r29, -2147483648
  %25 = and i1 %24, false
  %26 = or i1 false, %25
  br i1 %26, label %div.bad30, label %div.ok31

div.bad30:                                        ; preds = %div.ok
  %exc32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc32)
  store ptr %exc32, ptr %exc.thrown33, align 8
  call void @_CxxThrowException(ptr %exc.thrown33, ptr @_TI1PEAX)
  unreachable

div.ok31:                                         ; preds = %div.ok
  %27 = sdiv i32 %r29, 2
  store i32 %27, ptr %r, align 4
  br label %while.cond
}

define internal void @SparseTable.SparseTable(ptr %0, ptr %1) {
entry:
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %i32 = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %K = alloca i32, align 4
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 0
  store ptr @SparseTable.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %table = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  store ptr null, ptr %table, align 8, !tbaa !3
  %n = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %data1 = load ptr, ptr %data, align 8
  %len = load i64, ptr %data1, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4, !tbaa !7
  store i32 1, ptr %K, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %K2 = load i32, ptr %K, align 4
  %3 = icmp ult i32 %K2, 32
  %4 = select i1 %3, i32 %K2, i32 0
  %5 = shl i32 1, %4
  %6 = select i1 %3, i32 %5, i32 0
  %n3 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n4 = load i32, ptr %n3, align 4, !tbaa !7
  %7 = icmp sle i32 %6, %n4
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %K5 = load i32, ptr %K, align 4
  %9 = add i32 %K5, 1
  store i32 %9, ptr %K, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %k = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 3
  %K6 = load i32, ptr %K, align 4
  store i32 %K6, ptr %k, align 4, !tbaa !7
  %table7 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  %K8 = load i32, ptr %K, align 4
  %n9 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n10 = load i32, ptr %n9, align 4, !tbaa !7
  %10 = mul i32 %K8, %n10
  %11 = sext i32 %10 to i64
  %12 = mul i64 %11, 4
  %13 = add i64 8, %12
  %arr = call ptr @__polaron_malloc(i64 %13)
  store i64 %11, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %14 = call ptr @memset(ptr %arr.data, i32 0, i64 %12)
  store ptr %arr, ptr %table7, align 8, !tbaa !3
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %while.end
  %i11 = load i32, ptr %i, align 4
  %n12 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n13 = load i32, ptr %n12, align 4, !tbaa !7
  %15 = icmp slt i32 %i11, %n13
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %table14 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  %table15 = load ptr, ptr %table14, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %17 = sext i32 %i16 to i64
  %arr.len = load i64, ptr %table15, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok23
  %18 = load i32, ptr %i, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %j, align 4
  br label %for.cond26

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1975, ptr @.faila.1976, i64 %17, ptr @.failb.1977, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data17 = getelementptr i8, ptr %table15, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data17, i64 %17
  %data18 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %i19 = load i32, ptr %i, align 4
  %20 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %20, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1978, ptr @.faila.1979, i64 %20, ptr @.failb.1980, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %20
  %elem = load i32, ptr %arr.elem25, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

for.cond26:                                       ; preds = %for.update28, %for.end
  %j30 = load i32, ptr %j, align 4
  %K31 = load i32, ptr %K, align 4
  %21 = icmp slt i32 %j30, %K31
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body27, label %for.end29

for.body27:                                       ; preds = %for.cond26
  store i32 0, ptr %i32, align 4
  br label %while.cond33

for.update28:                                     ; preds = %while.end35
  %23 = load i32, ptr %j, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %j, align 4
  br label %for.cond26

for.end29:                                        ; preds = %for.cond26
  ret void

while.cond33:                                     ; preds = %if.end, %for.body27
  %i36 = load i32, ptr %i32, align 4
  %j37 = load i32, ptr %j, align 4
  %25 = icmp ult i32 %j37, 32
  %26 = select i1 %25, i32 %j37, i32 0
  %27 = shl i32 1, %26
  %28 = select i1 %25, i32 %27, i32 0
  %29 = add i32 %i36, %28
  %n38 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n39 = load i32, ptr %n38, align 4, !tbaa !7
  %30 = icmp sle i32 %29, %n39
  %31 = zext i1 %30 to i32
  br i1 %30, label %while.body34, label %while.end35

while.body34:                                     ; preds = %while.cond33
  %table40 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  %table41 = load ptr, ptr %table40, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j42 = load i32, ptr %j, align 4
  %32 = sub i32 %j42, 1
  %n43 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n44 = load i32, ptr %n43, align 4, !tbaa !7
  %33 = mul i32 %32, %n44
  %i45 = load i32, ptr %i32, align 4
  %34 = add i32 %33, %i45
  %35 = sext i32 %34 to i64
  %arr.len46 = load i64, ptr %table41, align 8
  %arr.oob47 = icmp uge i64 %35, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

while.end35:                                      ; preds = %while.cond33
  br label %for.update28

idx.bad48:                                        ; preds = %while.body34
  call void @__polaron_fail(ptr @.fail.1981, ptr @.faila.1982, i64 %35, ptr @.failb.1983, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %while.body34
  %arr.data50 = getelementptr i8, ptr %table41, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %35
  %elem52 = load i32, ptr %arr.elem51, align 4
  store i32 %elem52, ptr %a, align 4
  %table53 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  %table54 = load ptr, ptr %table53, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j55 = load i32, ptr %j, align 4
  %36 = sub i32 %j55, 1
  %n56 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n57 = load i32, ptr %n56, align 4, !tbaa !7
  %37 = mul i32 %36, %n57
  %i58 = load i32, ptr %i32, align 4
  %38 = add i32 %37, %i58
  %j59 = load i32, ptr %j, align 4
  %39 = sub i32 %j59, 1
  %40 = icmp ult i32 %39, 32
  %41 = select i1 %40, i32 %39, i32 0
  %42 = shl i32 1, %41
  %43 = select i1 %40, i32 %42, i32 0
  %44 = add i32 %38, %43
  %45 = sext i32 %44 to i64
  %arr.len60 = load i64, ptr %table54, align 8
  %arr.oob61 = icmp uge i64 %45, %arr.len60
  br i1 %arr.oob61, label %idx.bad62, label %idx.ok63, !prof !2

idx.bad62:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.1984, ptr @.faila.1985, i64 %45, ptr @.failb.1986, i64 %arr.len60, i32 70)
  unreachable

idx.ok63:                                         ; preds = %idx.ok49
  %arr.data64 = getelementptr i8, ptr %table54, i64 8
  %arr.elem65 = getelementptr inbounds i32, ptr %arr.data64, i64 %45
  %elem66 = load i32, ptr %arr.elem65, align 4
  store i32 %elem66, ptr %b, align 4
  %a67 = load i32, ptr %a, align 4
  %b68 = load i32, ptr %b, align 4
  %46 = icmp slt i32 %a67, %b68
  %47 = zext i1 %46 to i32
  br i1 %46, label %if.then, label %if.else

if.then:                                          ; preds = %idx.ok63
  %table69 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  %table70 = load ptr, ptr %table69, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j71 = load i32, ptr %j, align 4
  %n72 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n73 = load i32, ptr %n72, align 4, !tbaa !7
  %48 = mul i32 %j71, %n73
  %i74 = load i32, ptr %i32, align 4
  %49 = add i32 %48, %i74
  %50 = sext i32 %49 to i64
  %arr.len75 = load i64, ptr %table70, align 8
  %arr.oob76 = icmp uge i64 %50, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !2

if.else:                                          ; preds = %idx.ok63
  %table82 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  %table83 = load ptr, ptr %table82, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j84 = load i32, ptr %j, align 4
  %n85 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n86 = load i32, ptr %n85, align 4, !tbaa !7
  %51 = mul i32 %j84, %n86
  %i87 = load i32, ptr %i32, align 4
  %52 = add i32 %51, %i87
  %53 = sext i32 %52 to i64
  %arr.len88 = load i64, ptr %table83, align 8
  %arr.oob89 = icmp uge i64 %53, %arr.len88
  br i1 %arr.oob89, label %idx.bad90, label %idx.ok91, !prof !2

if.end:                                           ; preds = %idx.ok91, %idx.ok78
  %i95 = load i32, ptr %i32, align 4
  %54 = add i32 %i95, 1
  store i32 %54, ptr %i32, align 4
  br label %while.cond33

idx.bad77:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1987, ptr @.faila.1988, i64 %50, ptr @.failb.1989, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %if.then
  %arr.data79 = getelementptr i8, ptr %table70, i64 8
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data79, i64 %50
  %a81 = load i32, ptr %a, align 4
  store i32 %a81, ptr %arr.elem80, align 4
  br label %if.end

idx.bad90:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1990, ptr @.faila.1991, i64 %53, ptr @.failb.1992, i64 %arr.len88, i32 70)
  unreachable

idx.ok91:                                         ; preds = %if.else
  %arr.data92 = getelementptr i8, ptr %table83, i64 8
  %arr.elem93 = getelementptr inbounds i32, ptr %arr.data92, i64 %53
  %b94 = load i32, ptr %b, align 4
  store i32 %b94, ptr %arr.elem93, align 4
  br label %if.end
}

define internal i32 @SparseTable.queryMin(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %j = alloca i32, align 4
  %len = alloca i32, align 4
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  store i32 %1, ptr %lo, align 4
  store i32 %2, ptr %hi, align 4
  %hi1 = load i32, ptr %hi, align 4
  %lo2 = load i32, ptr %lo, align 4
  %3 = sub i32 %hi1, %lo2
  %4 = add i32 %3, 1
  store i32 %4, ptr %len, align 4
  store i32 0, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %j3 = load i32, ptr %j, align 4
  %5 = add i32 %j3, 1
  %6 = icmp ult i32 %5, 32
  %7 = select i1 %6, i32 %5, i32 0
  %8 = shl i32 1, %7
  %9 = select i1 %6, i32 %8, i32 0
  %len4 = load i32, ptr %len, align 4
  %10 = icmp sle i32 %9, %len4
  %11 = zext i1 %10 to i32
  br i1 %10, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %j5 = load i32, ptr %j, align 4
  %12 = add i32 %j5, 1
  store i32 %12, ptr %j, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %table = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  %table6 = load ptr, ptr %table, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j7 = load i32, ptr %j, align 4
  %n = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n8 = load i32, ptr %n, align 4, !tbaa !7
  %13 = mul i32 %j7, %n8
  %lo9 = load i32, ptr %lo, align 4
  %14 = add i32 %13, %lo9
  %15 = sext i32 %14 to i64
  %arr.len = load i64, ptr %table6, align 8
  %arr.oob = icmp uge i64 %15, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.1993, ptr @.faila.1994, i64 %15, ptr @.failb.1995, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.end
  %arr.data = getelementptr i8, ptr %table6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %15
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %a, align 4
  %table10 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 1
  %table11 = load ptr, ptr %table10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j12 = load i32, ptr %j, align 4
  %n13 = getelementptr inbounds %class.SparseTable, ptr %0, i32 0, i32 2
  %n14 = load i32, ptr %n13, align 4, !tbaa !7
  %16 = mul i32 %j12, %n14
  %hi15 = load i32, ptr %hi, align 4
  %j16 = load i32, ptr %j, align 4
  %17 = icmp ult i32 %j16, 32
  %18 = select i1 %17, i32 %j16, i32 0
  %19 = shl i32 1, %18
  %20 = select i1 %17, i32 %19, i32 0
  %21 = sub i32 %hi15, %20
  %22 = add i32 %21, 1
  %23 = add i32 %16, %22
  %24 = sext i32 %23 to i64
  %arr.len17 = load i64, ptr %table11, align 8
  %arr.oob18 = icmp uge i64 %24, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1996, ptr @.faila.1997, i64 %24, ptr @.failb.1998, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %table11, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 %24
  %elem23 = load i32, ptr %arr.elem22, align 4
  store i32 %elem23, ptr %b, align 4
  %a24 = load i32, ptr %a, align 4
  %b25 = load i32, ptr %b, align 4
  %25 = icmp slt i32 %a24, %b25
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok20
  %a26 = load i32, ptr %a, align 4
  ret i32 %a26

if.end:                                           ; preds = %idx.ok20
  %b27 = load i32, ptr %b, align 4
  ret i32 %b27
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5326)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5328)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

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
