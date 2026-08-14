; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fenwick2d_fletcher.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/fenwick2d_fletcher.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Fenwick2D = type { ptr, ptr, i32, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Fenwick2D.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Fenwick2D.rangeSum, ptr @Fenwick2D.update, ptr null, ptr null, ptr @Fenwick2D.prefix, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [25 x i8] c"total=%d mid=%d row0=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"fl=%d\0A\00", align 1
@.strdata = private constant [6 x i8] c"abcde\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1307 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1308 = private global %String { i64 16, ptr @.strdata.1307, i64 0 }
@.strdata.1309 = private constant [17 x i8] c"division by zero\00"
@.strobj.1310 = private global %String { i64 16, ptr @.strdata.1309, i64 0 }
@.fail.2207 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2796:60  in Fenwick2D.update\0A\00", align 1
@.faila.2208 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2209 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2210 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2796:60  in Fenwick2D.update\0A\00", align 1
@.faila.2211 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2212 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2213 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2809:27  in Fenwick2D.prefix\0A\00", align 1
@.faila.2214 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2215 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
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
  %Fenwick2D.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Fenwick2D, ptr null, i64 1) to i64))
  call void @Fenwick2D.Fenwick2D(ptr %Fenwick2D.obj, i32 3, i32 3)
  store ptr %Fenwick2D.obj, ptr %f, align 8
  %f1 = load ptr, ptr %f, align 8
  call void @Fenwick2D.update(ptr %f1, i32 0, i32 0, i32 1)
  %f2 = load ptr, ptr %f, align 8
  call void @Fenwick2D.update(ptr %f2, i32 1, i32 1, i32 5)
  %f3 = load ptr, ptr %f, align 8
  call void @Fenwick2D.update(ptr %f3, i32 2, i32 2, i32 3)
  %f4 = load ptr, ptr %f, align 8
  call void @Fenwick2D.update(ptr %f4, i32 0, i32 2, i32 2)
  %f5 = load ptr, ptr %f, align 8
  %16 = call i32 @Fenwick2D.rangeSum(ptr %f5, i32 0, i32 0, i32 2, i32 2)
  %f6 = load ptr, ptr %f, align 8
  %17 = call i32 @Fenwick2D.rangeSum(ptr %f6, i32 1, i32 1, i32 2, i32 2)
  %f7 = load ptr, ptr %f, align 8
  %18 = call i32 @Fenwick2D.rangeSum(ptr %f7, i32 0, i32 0, i32 0, i32 2)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18)
  %20 = call i32 @Fletcher.fletcher16(ptr @.strobj)
  %21 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %20)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1308)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1310)
  ret ptr %strcpy
}

define internal void @Fenwick2D.Fenwick2D(ptr %0, i32 %1, i32 %2) {
entry:
  %cols = alloca i32, align 4
  %rows = alloca i32, align 4
  store i32 %1, ptr %rows, align 4
  store i32 %2, ptr %cols, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 0
  store ptr @Fenwick2D.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %tree = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 1
  store ptr null, ptr %tree, align 8, !tbaa !0
  %rows1 = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 2
  %rows2 = load i32, ptr %rows, align 4
  store i32 %rows2, ptr %rows1, align 4, !tbaa !4
  %cols3 = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 3
  %cols4 = load i32, ptr %cols, align 4
  store i32 %cols4, ptr %cols3, align 4, !tbaa !4
  %tree5 = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 1
  %rows6 = load i32, ptr %rows, align 4
  %3 = add i32 %rows6, 1
  %cols7 = load i32, ptr %cols, align 4
  %4 = add i32 %cols7, 1
  %5 = mul i32 %3, %4
  %6 = sext i32 %5 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %9 = call ptr @memset(ptr %arr.data, i32 0, i64 %7)
  store ptr %arr, ptr %tree5, align 8, !tbaa !0
  ret void
}

define internal void @Fenwick2D.update(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2, i32 %3) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %delta = alloca i32, align 4
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  store i32 %3, ptr %delta, align 4
  %r1 = load i32, ptr %r, align 4
  %4 = add i32 %r1, 1
  store i32 %4, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.end7, %entry
  %i2 = load i32, ptr %i, align 4
  %rows = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 2
  %rows3 = load i32, ptr %rows, align 4, !tbaa !4
  %5 = icmp sle i32 %i2, %rows3
  %6 = zext i1 %5 to i32
  br i1 %5, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %c4 = load i32, ptr %c, align 4
  %7 = add i32 %c4, 1
  store i32 %7, ptr %j, align 4
  br label %while.cond5

while.end:                                        ; preds = %while.cond
  ret void

while.cond5:                                      ; preds = %idx.ok24, %while.body
  %j8 = load i32, ptr %j, align 4
  %cols = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 3
  %cols9 = load i32, ptr %cols, align 4, !tbaa !4
  %8 = icmp sle i32 %j8, %cols9
  %9 = zext i1 %8 to i32
  br i1 %8, label %while.body6, label %while.end7

while.body6:                                      ; preds = %while.cond5
  %tree = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 1
  %tree10 = load ptr, ptr %tree, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i11 = load i32, ptr %i, align 4
  %cols12 = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 3
  %cols13 = load i32, ptr %cols12, align 4, !tbaa !4
  %10 = add i32 %cols13, 1
  %11 = mul i32 %i11, %10
  %j14 = load i32, ptr %j, align 4
  %12 = add i32 %11, %j14
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %tree10, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.end7:                                       ; preds = %while.cond5
  %i31 = load i32, ptr %i, align 4
  %i32 = load i32, ptr %i, align 4
  %i33 = load i32, ptr %i, align 4
  %14 = sub i32 0, %i33
  %15 = and i32 %i32, %14
  %16 = add i32 %i31, %15
  store i32 %16, ptr %i, align 4
  br label %while.cond

idx.bad:                                          ; preds = %while.body6
  call void @__polaron_fail(ptr @.fail.2207, ptr @.faila.2208, i64 %13, ptr @.failb.2209, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body6
  %arr.data = getelementptr i8, ptr %tree10, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %13
  %tree15 = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 1
  %tree16 = load ptr, ptr %tree15, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %cols18 = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 3
  %cols19 = load i32, ptr %cols18, align 4, !tbaa !4
  %17 = add i32 %cols19, 1
  %18 = mul i32 %i17, %17
  %j20 = load i32, ptr %j, align 4
  %19 = add i32 %18, %j20
  %20 = sext i32 %19 to i64
  %arr.len21 = load i64, ptr %tree16, align 8
  %arr.oob22 = icmp uge i64 %20, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

idx.bad23:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2210, ptr @.faila.2211, i64 %20, ptr @.failb.2212, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok
  %arr.data25 = getelementptr i8, ptr %tree16, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 %20
  %elem = load i32, ptr %arr.elem26, align 4
  %delta27 = load i32, ptr %delta, align 4
  %21 = add i32 %elem, %delta27
  store i32 %21, ptr %arr.elem, align 4
  %j28 = load i32, ptr %j, align 4
  %j29 = load i32, ptr %j, align 4
  %j30 = load i32, ptr %j, align 4
  %22 = sub i32 0, %j30
  %23 = and i32 %j29, %22
  %24 = add i32 %j28, %23
  store i32 %24, ptr %j, align 4
  br label %while.cond5
}

define internal i32 @Fenwick2D.prefix(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  store i32 0, ptr %s, align 4
  %r1 = load i32, ptr %r, align 4
  %3 = add i32 %r1, 1
  store i32 %3, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.end6, %entry
  %i2 = load i32, ptr %i, align 4
  %4 = icmp sgt i32 %i2, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %c3 = load i32, ptr %c, align 4
  %6 = add i32 %c3, 1
  store i32 %6, ptr %j, align 4
  br label %while.cond4

while.end:                                        ; preds = %while.cond
  %s19 = load i32, ptr %s, align 4
  ret i32 %s19

while.cond4:                                      ; preds = %idx.ok, %while.body
  %j7 = load i32, ptr %j, align 4
  %7 = icmp sgt i32 %j7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body5, label %while.end6

while.body5:                                      ; preds = %while.cond4
  %s8 = load i32, ptr %s, align 4
  %tree = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 1
  %tree9 = load ptr, ptr %tree, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i10 = load i32, ptr %i, align 4
  %cols = getelementptr inbounds %class.Fenwick2D, ptr %0, i32 0, i32 3
  %cols11 = load i32, ptr %cols, align 4, !tbaa !4
  %9 = add i32 %cols11, 1
  %10 = mul i32 %i10, %9
  %j12 = load i32, ptr %j, align 4
  %11 = add i32 %10, %j12
  %12 = sext i32 %11 to i64
  %arr.len = load i64, ptr %tree9, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.end6:                                       ; preds = %while.cond4
  %i16 = load i32, ptr %i, align 4
  %i17 = load i32, ptr %i, align 4
  %i18 = load i32, ptr %i, align 4
  %13 = sub i32 0, %i18
  %14 = and i32 %i17, %13
  %15 = sub i32 %i16, %14
  store i32 %15, ptr %i, align 4
  br label %while.cond

idx.bad:                                          ; preds = %while.body5
  call void @__polaron_fail(ptr @.fail.2213, ptr @.faila.2214, i64 %12, ptr @.failb.2215, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body5
  %arr.data = getelementptr i8, ptr %tree9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %12
  %elem = load i32, ptr %arr.elem, align 4
  %16 = add i32 %s8, %elem
  store i32 %16, ptr %s, align 4
  %j13 = load i32, ptr %j, align 4
  %j14 = load i32, ptr %j, align 4
  %j15 = load i32, ptr %j, align 4
  %17 = sub i32 0, %j15
  %18 = and i32 %j14, %17
  %19 = sub i32 %j13, %18
  store i32 %19, ptr %j, align 4
  br label %while.cond4
}

define internal i32 @Fenwick2D.rangeSum(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2, i32 %3, i32 %4) {
entry:
  %s = alloca i32, align 4
  %c2 = alloca i32, align 4
  %r2 = alloca i32, align 4
  %c1 = alloca i32, align 4
  %r1 = alloca i32, align 4
  store i32 %1, ptr %r1, align 4
  store i32 %2, ptr %c1, align 4
  store i32 %3, ptr %r2, align 4
  store i32 %4, ptr %c2, align 4
  %r21 = load i32, ptr %r2, align 4
  %c22 = load i32, ptr %c2, align 4
  %5 = call i32 @Fenwick2D.prefix(ptr %0, i32 %r21, i32 %c22)
  store i32 %5, ptr %s, align 4
  %r13 = load i32, ptr %r1, align 4
  %6 = icmp sgt i32 %r13, 0
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %s4 = load i32, ptr %s, align 4
  %r15 = load i32, ptr %r1, align 4
  %8 = sub i32 %r15, 1
  %c26 = load i32, ptr %c2, align 4
  %9 = call i32 @Fenwick2D.prefix(ptr %0, i32 %8, i32 %c26)
  %10 = sub i32 %s4, %9
  store i32 %10, ptr %s, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %c17 = load i32, ptr %c1, align 4
  %11 = icmp sgt i32 %c17, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end
  %s10 = load i32, ptr %s, align 4
  %r211 = load i32, ptr %r2, align 4
  %c112 = load i32, ptr %c1, align 4
  %13 = sub i32 %c112, 1
  %14 = call i32 @Fenwick2D.prefix(ptr %0, i32 %r211, i32 %13)
  %15 = sub i32 %s10, %14
  store i32 %15, ptr %s, align 4
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.end
  %r113 = load i32, ptr %r1, align 4
  %16 = icmp sgt i32 %r113, 0
  %17 = zext i1 %16 to i32
  %sc.a = icmp ne i32 %17, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %if.end9
  %c114 = load i32, ptr %c1, align 4
  %18 = icmp sgt i32 %c114, 0
  %19 = zext i1 %18 to i32
  %sc.b = icmp ne i32 %19, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %if.end9
  %sc = phi i1 [ false, %if.end9 ], [ %sc.b, %sc.rhs ]
  %20 = zext i1 %sc to i32
  br i1 %sc, label %if.then15, label %if.end16

if.then15:                                        ; preds = %sc.end
  %s17 = load i32, ptr %s, align 4
  %r118 = load i32, ptr %r1, align 4
  %21 = sub i32 %r118, 1
  %c119 = load i32, ptr %c1, align 4
  %22 = sub i32 %c119, 1
  %23 = call i32 @Fenwick2D.prefix(ptr %0, i32 %21, i32 %22)
  %24 = add i32 %s17, %23
  store i32 %24, ptr %s, align 4
  br label %if.end16

if.end16:                                         ; preds = %if.then15, %sc.end
  %s20 = load i32, ptr %s, align 4
  ret i32 %s20
}

define internal i32 @Fletcher.fletcher16(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown12 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %s2 = alloca i32, align 4
  %s1 = alloca i32, align 4
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  store i32 0, ptr %s1, align 4
  store i32 0, ptr %s2, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %data2 = load ptr, ptr %data, align 8
  %str.len = getelementptr inbounds %String, ptr %data2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s13 = load i32, ptr %s1, align 4
  %data4 = load ptr, ptr %data, align 8
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %data4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data6, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = and i32 %5, 255
  %7 = add i32 %s13, %6
  %8 = icmp eq i32 %7, -2147483648
  %9 = and i1 %8, false
  %10 = or i1 false, %9
  br i1 %10, label %div.bad, label %div.ok

for.update:                                       ; preds = %div.ok10
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s213 = load i32, ptr %s2, align 4
  %13 = shl i32 %s213, 8
  %s114 = load i32, ptr %s1, align 4
  %14 = or i32 %13, %s114
  ret i32 %14

div.bad:                                          ; preds = %for.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.body
  %15 = srem i32 %7, 255
  store i32 %15, ptr %s1, align 4
  %s27 = load i32, ptr %s2, align 4
  %s18 = load i32, ptr %s1, align 4
  %16 = add i32 %s27, %s18
  %17 = icmp eq i32 %16, -2147483648
  %18 = and i1 %17, false
  %19 = or i1 false, %18
  br i1 %19, label %div.bad9, label %div.ok10

div.bad9:                                         ; preds = %div.ok
  %exc11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc11)
  store ptr %exc11, ptr %exc.thrown12, align 8
  call void @_CxxThrowException(ptr %exc.thrown12, ptr @_TI1PEAX)
  unreachable

div.ok10:                                         ; preds = %div.ok
  %20 = srem i32 %16, 255
  store i32 %20, ptr %s2, align 4
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5311)
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

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
