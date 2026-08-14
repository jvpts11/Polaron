; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/digest_date.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/digest_date.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Date = type { ptr, i32, i32, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Date.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Date.year, ptr @Date.month, ptr @Date.day, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Date.toEpochDay, ptr @Date.dayOfWeek, ptr @Date.addDays, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [59 x i8] c"crc=%d fnv=%d leap=%d feb=%d epoch=%d dow=%d add=%d-%d-%d\0A\00", align 1
@.strdata = private constant [4 x i8] c"abc\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c"abc\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1308 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1309 = private global %String { i64 16, ptr @.strdata.1308, i64 0 }
@.strdata.1310 = private constant [17 x i8] c"division by zero\00"
@.strobj.1311 = private global %String { i64 16, ptr @.strdata.1310, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %Date.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Date, ptr null, i64 1) to i64))
  call void @Date.Date(ptr %Date.obj, i32 2000, i32 1, i32 1)
  store ptr %Date.obj, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %16 = call ptr @Date.addDays(ptr %a1, i32 31)
  store ptr %16, ptr %b, align 8
  %17 = call i32 @Digest.crc32(ptr @.strobj)
  %18 = call i32 @Digest.fnv1a(ptr @.strobj.2)
  %19 = call i32 @Date.isLeap(i32 2024)
  %20 = call i32 @Date.daysInMonth(i32 2024, i32 2)
  %a2 = load ptr, ptr %a, align 8
  %21 = call i32 @Date.toEpochDay(ptr %a2)
  %a3 = load ptr, ptr %a, align 8
  %22 = call i32 @Date.dayOfWeek(ptr %a3)
  %b4 = load ptr, ptr %b, align 8
  %23 = call i32 @Date.year(ptr %b4)
  %b5 = load ptr, ptr %b, align 8
  %24 = call i32 @Date.month(ptr %b5)
  %b6 = load ptr, ptr %b, align 8
  %25 = call i32 @Date.day(ptr %b6)
  %26 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22, i32 %23, i32 %24, i32 %25)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1309)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1311)
  ret ptr %strcpy
}

define internal void @Date.Date(ptr %0, i32 %1, i32 %2, i32 %3) {
entry:
  %day = alloca i32, align 4
  %month = alloca i32, align 4
  %year = alloca i32, align 4
  store i32 %1, ptr %year, align 4
  store i32 %2, ptr %month, align 4
  store i32 %3, ptr %day, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 0
  store ptr @Date.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %y = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 1
  %year1 = load i32, ptr %year, align 4
  store i32 %year1, ptr %y, align 4, !tbaa !4
  %mo = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 2
  %month2 = load i32, ptr %month, align 4
  store i32 %month2, ptr %mo, align 4, !tbaa !4
  %d = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 3
  %day3 = load i32, ptr %day, align 4
  store i32 %day3, ptr %d, align 4, !tbaa !4
  ret void
}

define internal i32 @Date.year(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %y = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 1
  %y1 = load i32, ptr %y, align 4, !tbaa !4
  ret i32 %y1
}

define internal i32 @Date.month(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %mo = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 2
  %mo1 = load i32, ptr %mo, align 4, !tbaa !4
  ret i32 %mo1
}

define internal i32 @Date.day(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %d = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 3
  %d1 = load i32, ptr %d, align 4, !tbaa !4
  ret i32 %d1
}

define internal i32 @Date.isLeap(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown14 = alloca ptr, align 8
  %exc.thrown6 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %year = alloca i32, align 4
  store i32 %0, ptr %year, align 4
  %year1 = load i32, ptr %year, align 4
  %1 = icmp eq i32 %year1, -2147483648
  %2 = and i1 %1, false
  %3 = or i1 false, %2
  br i1 %3, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %4 = srem i32 %year1, 4
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  %sc.a = icmp ne i32 %6, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %div.ok
  %year2 = load i32, ptr %year, align 4
  %7 = icmp eq i32 %year2, -2147483648
  %8 = and i1 %7, false
  %9 = or i1 false, %8
  br i1 %9, label %div.bad3, label %div.ok4

sc.end:                                           ; preds = %div.ok4, %div.ok
  %sc = phi i1 [ false, %div.ok ], [ %sc.b, %div.ok4 ]
  %10 = zext i1 %sc to i32
  %sc.a7 = icmp ne i32 %10, 0
  br i1 %sc.a7, label %sc.end9, label %sc.rhs8

div.bad3:                                         ; preds = %sc.rhs
  %exc5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc5)
  store ptr %exc5, ptr %exc.thrown6, align 8
  call void @_CxxThrowException(ptr %exc.thrown6, ptr @_TI1PEAX)
  unreachable

div.ok4:                                          ; preds = %sc.rhs
  %11 = srem i32 %year2, 100
  %12 = icmp ne i32 %11, 0
  %13 = zext i1 %12 to i32
  %sc.b = icmp ne i32 %13, 0
  br label %sc.end

sc.rhs8:                                          ; preds = %sc.end
  %year10 = load i32, ptr %year, align 4
  %14 = icmp eq i32 %year10, -2147483648
  %15 = and i1 %14, false
  %16 = or i1 false, %15
  br i1 %16, label %div.bad11, label %div.ok12

sc.end9:                                          ; preds = %div.ok12, %sc.end
  %sc16 = phi i1 [ true, %sc.end ], [ %sc.b15, %div.ok12 ]
  %17 = zext i1 %sc16 to i32
  ret i32 %17

div.bad11:                                        ; preds = %sc.rhs8
  %exc13 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc13)
  store ptr %exc13, ptr %exc.thrown14, align 8
  call void @_CxxThrowException(ptr %exc.thrown14, ptr @_TI1PEAX)
  unreachable

div.ok12:                                         ; preds = %sc.rhs8
  %18 = srem i32 %year10, 400
  %19 = icmp eq i32 %18, 0
  %20 = zext i1 %19 to i32
  %sc.b15 = icmp ne i32 %20, 0
  br label %sc.end9
}

define internal i32 @Date.daysInMonth(i32 %0, i32 %1) {
entry:
  %month = alloca i32, align 4
  %year = alloca i32, align 4
  store i32 %0, ptr %year, align 4
  store i32 %1, ptr %month, align 4
  %month1 = load i32, ptr %month, align 4
  %2 = icmp eq i32 %month1, 2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %year2 = load i32, ptr %year, align 4
  %4 = call i32 @Date.isLeap(i32 %year2)
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %if.then3, label %if.end4

if.end:                                           ; preds = %entry
  %month5 = load i32, ptr %month, align 4
  %6 = icmp eq i32 %month5, 4
  %7 = zext i1 %6 to i32
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

if.then3:                                         ; preds = %if.then
  ret i32 29

if.end4:                                          ; preds = %if.then
  ret i32 28

sc.rhs:                                           ; preds = %if.end
  %month6 = load i32, ptr %month, align 4
  %8 = icmp eq i32 %month6, 6
  %9 = zext i1 %8 to i32
  %sc.b = icmp ne i32 %9, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %if.end
  %sc = phi i1 [ true, %if.end ], [ %sc.b, %sc.rhs ]
  %10 = zext i1 %sc to i32
  %sc.a7 = icmp ne i32 %10, 0
  br i1 %sc.a7, label %sc.end9, label %sc.rhs8

sc.rhs8:                                          ; preds = %sc.end
  %month10 = load i32, ptr %month, align 4
  %11 = icmp eq i32 %month10, 9
  %12 = zext i1 %11 to i32
  %sc.b11 = icmp ne i32 %12, 0
  br label %sc.end9

sc.end9:                                          ; preds = %sc.rhs8, %sc.end
  %sc12 = phi i1 [ true, %sc.end ], [ %sc.b11, %sc.rhs8 ]
  %13 = zext i1 %sc12 to i32
  %sc.a13 = icmp ne i32 %13, 0
  br i1 %sc.a13, label %sc.end15, label %sc.rhs14

sc.rhs14:                                         ; preds = %sc.end9
  %month16 = load i32, ptr %month, align 4
  %14 = icmp eq i32 %month16, 11
  %15 = zext i1 %14 to i32
  %sc.b17 = icmp ne i32 %15, 0
  br label %sc.end15

sc.end15:                                         ; preds = %sc.rhs14, %sc.end9
  %sc18 = phi i1 [ true, %sc.end9 ], [ %sc.b17, %sc.rhs14 ]
  %16 = zext i1 %sc18 to i32
  br i1 %sc18, label %if.then19, label %if.end20

if.then19:                                        ; preds = %sc.end15
  ret i32 30

if.end20:                                         ; preds = %sc.end15
  ret i32 31
}

define internal i32 @Date.toEpochDay(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %doe = alloca i32, align 4
  %exc.thrown30 = alloca ptr, align 8
  %exc.thrown25 = alloca ptr, align 8
  %doy = alloca i32, align 4
  %exc.thrown18 = alloca ptr, align 8
  %mp = alloca i32, align 4
  %yoe = alloca i32, align 4
  %era = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %yy = alloca i32, align 4
  %y = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 1
  %y1 = load i32, ptr %y, align 4, !tbaa !4
  store i32 %y1, ptr %yy, align 4
  %mo = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 2
  %mo2 = load i32, ptr %mo, align 4, !tbaa !4
  %1 = icmp sle i32 %mo2, 2
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %yy3 = load i32, ptr %yy, align 4
  %3 = sub i32 %yy3, 1
  store i32 %3, ptr %yy, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %yy4 = load i32, ptr %yy, align 4
  %4 = icmp eq i32 %yy4, -2147483648
  %5 = and i1 %4, false
  %6 = or i1 false, %5
  br i1 %6, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end
  %7 = sdiv i32 %yy4, 400
  store i32 %7, ptr %era, align 4
  %yy5 = load i32, ptr %yy, align 4
  %era6 = load i32, ptr %era, align 4
  %8 = mul i32 %era6, 400
  %9 = sub i32 %yy5, %8
  store i32 %9, ptr %yoe, align 4
  %mo7 = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 2
  %mo8 = load i32, ptr %mo7, align 4, !tbaa !4
  store i32 %mo8, ptr %mp, align 4
  %mp9 = load i32, ptr %mp, align 4
  %10 = icmp sgt i32 %mp9, 2
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then10, label %if.else

if.then10:                                        ; preds = %div.ok
  %mp12 = load i32, ptr %mp, align 4
  %12 = sub i32 %mp12, 3
  store i32 %12, ptr %mp, align 4
  br label %if.end11

if.else:                                          ; preds = %div.ok
  %mp13 = load i32, ptr %mp, align 4
  %13 = add i32 %mp13, 9
  store i32 %13, ptr %mp, align 4
  br label %if.end11

if.end11:                                         ; preds = %if.else, %if.then10
  %mp14 = load i32, ptr %mp, align 4
  %14 = mul i32 153, %mp14
  %15 = add i32 %14, 2
  %16 = icmp eq i32 %15, -2147483648
  %17 = and i1 %16, false
  %18 = or i1 false, %17
  br i1 %18, label %div.bad15, label %div.ok16

div.bad15:                                        ; preds = %if.end11
  %exc17 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc17)
  store ptr %exc17, ptr %exc.thrown18, align 8
  call void @_CxxThrowException(ptr %exc.thrown18, ptr @_TI1PEAX)
  unreachable

div.ok16:                                         ; preds = %if.end11
  %19 = sdiv i32 %15, 5
  %d = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 3
  %d19 = load i32, ptr %d, align 4, !tbaa !4
  %20 = add i32 %19, %d19
  %21 = sub i32 %20, 1
  store i32 %21, ptr %doy, align 4
  %yoe20 = load i32, ptr %yoe, align 4
  %22 = mul i32 %yoe20, 365
  %yoe21 = load i32, ptr %yoe, align 4
  %23 = icmp eq i32 %yoe21, -2147483648
  %24 = and i1 %23, false
  %25 = or i1 false, %24
  br i1 %25, label %div.bad22, label %div.ok23

div.bad22:                                        ; preds = %div.ok16
  %exc24 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc24)
  store ptr %exc24, ptr %exc.thrown25, align 8
  call void @_CxxThrowException(ptr %exc.thrown25, ptr @_TI1PEAX)
  unreachable

div.ok23:                                         ; preds = %div.ok16
  %26 = sdiv i32 %yoe21, 4
  %27 = add i32 %22, %26
  %yoe26 = load i32, ptr %yoe, align 4
  %28 = icmp eq i32 %yoe26, -2147483648
  %29 = and i1 %28, false
  %30 = or i1 false, %29
  br i1 %30, label %div.bad27, label %div.ok28

div.bad27:                                        ; preds = %div.ok23
  %exc29 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc29)
  store ptr %exc29, ptr %exc.thrown30, align 8
  call void @_CxxThrowException(ptr %exc.thrown30, ptr @_TI1PEAX)
  unreachable

div.ok28:                                         ; preds = %div.ok23
  %31 = sdiv i32 %yoe26, 100
  %32 = sub i32 %27, %31
  %doy31 = load i32, ptr %doy, align 4
  %33 = add i32 %32, %doy31
  store i32 %33, ptr %doe, align 4
  %era32 = load i32, ptr %era, align 4
  %34 = mul i32 %era32, 146097
  %doe33 = load i32, ptr %doe, align 4
  %35 = add i32 %34, %doe33
  %36 = sub i32 %35, 719468
  ret i32 %36
}

define internal i32 @Date.dayOfWeek(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %e = alloca i32, align 4
  %1 = call i32 @Date.toEpochDay(ptr %0)
  store i32 %1, ptr %e, align 4
  %e1 = load i32, ptr %e, align 4
  %2 = add i32 %e1, 4
  %3 = icmp eq i32 %2, -2147483648
  %4 = and i1 %3, false
  %5 = or i1 false, %4
  br i1 %5, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %6 = srem i32 %2, 7
  ret i32 %6
}

define internal ptr @Date.fromEpochDay(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %m = alloca i32, align 4
  %d = alloca i32, align 4
  %exc.thrown49 = alloca ptr, align 8
  %mp = alloca i32, align 4
  %exc.thrown43 = alloca ptr, align 8
  %doy = alloca i32, align 4
  %exc.thrown38 = alloca ptr, align 8
  %exc.thrown33 = alloca ptr, align 8
  %y = alloca i32, align 4
  %yoe = alloca i32, align 4
  %exc.thrown24 = alloca ptr, align 8
  %exc.thrown20 = alloca ptr, align 8
  %exc.thrown15 = alloca ptr, align 8
  %exc.thrown10 = alloca ptr, align 8
  %doe = alloca i32, align 4
  %era = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %z = alloca i32, align 4
  %z0 = alloca i32, align 4
  store i32 %0, ptr %z0, align 4
  %z01 = load i32, ptr %z0, align 4
  %1 = add i32 %z01, 719468
  store i32 %1, ptr %z, align 4
  %z2 = load i32, ptr %z, align 4
  %2 = icmp eq i32 %z2, -2147483648
  %3 = and i1 %2, false
  %4 = or i1 false, %3
  br i1 %4, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %5 = sdiv i32 %z2, 146097
  store i32 %5, ptr %era, align 4
  %z3 = load i32, ptr %z, align 4
  %era4 = load i32, ptr %era, align 4
  %6 = mul i32 %era4, 146097
  %7 = sub i32 %z3, %6
  store i32 %7, ptr %doe, align 4
  %doe5 = load i32, ptr %doe, align 4
  %doe6 = load i32, ptr %doe, align 4
  %8 = icmp eq i32 %doe6, -2147483648
  %9 = and i1 %8, false
  %10 = or i1 false, %9
  br i1 %10, label %div.bad7, label %div.ok8

div.bad7:                                         ; preds = %div.ok
  %exc9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc9)
  store ptr %exc9, ptr %exc.thrown10, align 8
  call void @_CxxThrowException(ptr %exc.thrown10, ptr @_TI1PEAX)
  unreachable

div.ok8:                                          ; preds = %div.ok
  %11 = sdiv i32 %doe6, 1460
  %12 = sub i32 %doe5, %11
  %doe11 = load i32, ptr %doe, align 4
  %13 = icmp eq i32 %doe11, -2147483648
  %14 = and i1 %13, false
  %15 = or i1 false, %14
  br i1 %15, label %div.bad12, label %div.ok13

div.bad12:                                        ; preds = %div.ok8
  %exc14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc14)
  store ptr %exc14, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

div.ok13:                                         ; preds = %div.ok8
  %16 = sdiv i32 %doe11, 36524
  %17 = add i32 %12, %16
  %doe16 = load i32, ptr %doe, align 4
  %18 = icmp eq i32 %doe16, -2147483648
  %19 = and i1 %18, false
  %20 = or i1 false, %19
  br i1 %20, label %div.bad17, label %div.ok18

div.bad17:                                        ; preds = %div.ok13
  %exc19 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc19)
  store ptr %exc19, ptr %exc.thrown20, align 8
  call void @_CxxThrowException(ptr %exc.thrown20, ptr @_TI1PEAX)
  unreachable

div.ok18:                                         ; preds = %div.ok13
  %21 = sdiv i32 %doe16, 146096
  %22 = sub i32 %17, %21
  %23 = icmp eq i32 %22, -2147483648
  %24 = and i1 %23, false
  %25 = or i1 false, %24
  br i1 %25, label %div.bad21, label %div.ok22

div.bad21:                                        ; preds = %div.ok18
  %exc23 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc23)
  store ptr %exc23, ptr %exc.thrown24, align 8
  call void @_CxxThrowException(ptr %exc.thrown24, ptr @_TI1PEAX)
  unreachable

div.ok22:                                         ; preds = %div.ok18
  %26 = sdiv i32 %22, 365
  store i32 %26, ptr %yoe, align 4
  %yoe25 = load i32, ptr %yoe, align 4
  %era26 = load i32, ptr %era, align 4
  %27 = mul i32 %era26, 400
  %28 = add i32 %yoe25, %27
  store i32 %28, ptr %y, align 4
  %doe27 = load i32, ptr %doe, align 4
  %yoe28 = load i32, ptr %yoe, align 4
  %29 = mul i32 365, %yoe28
  %yoe29 = load i32, ptr %yoe, align 4
  %30 = icmp eq i32 %yoe29, -2147483648
  %31 = and i1 %30, false
  %32 = or i1 false, %31
  br i1 %32, label %div.bad30, label %div.ok31

div.bad30:                                        ; preds = %div.ok22
  %exc32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc32)
  store ptr %exc32, ptr %exc.thrown33, align 8
  call void @_CxxThrowException(ptr %exc.thrown33, ptr @_TI1PEAX)
  unreachable

div.ok31:                                         ; preds = %div.ok22
  %33 = sdiv i32 %yoe29, 4
  %34 = add i32 %29, %33
  %yoe34 = load i32, ptr %yoe, align 4
  %35 = icmp eq i32 %yoe34, -2147483648
  %36 = and i1 %35, false
  %37 = or i1 false, %36
  br i1 %37, label %div.bad35, label %div.ok36

div.bad35:                                        ; preds = %div.ok31
  %exc37 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc37)
  store ptr %exc37, ptr %exc.thrown38, align 8
  call void @_CxxThrowException(ptr %exc.thrown38, ptr @_TI1PEAX)
  unreachable

div.ok36:                                         ; preds = %div.ok31
  %38 = sdiv i32 %yoe34, 100
  %39 = sub i32 %34, %38
  %40 = sub i32 %doe27, %39
  store i32 %40, ptr %doy, align 4
  %doy39 = load i32, ptr %doy, align 4
  %41 = mul i32 5, %doy39
  %42 = add i32 %41, 2
  %43 = icmp eq i32 %42, -2147483648
  %44 = and i1 %43, false
  %45 = or i1 false, %44
  br i1 %45, label %div.bad40, label %div.ok41

div.bad40:                                        ; preds = %div.ok36
  %exc42 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc42)
  store ptr %exc42, ptr %exc.thrown43, align 8
  call void @_CxxThrowException(ptr %exc.thrown43, ptr @_TI1PEAX)
  unreachable

div.ok41:                                         ; preds = %div.ok36
  %46 = sdiv i32 %42, 153
  store i32 %46, ptr %mp, align 4
  %doy44 = load i32, ptr %doy, align 4
  %mp45 = load i32, ptr %mp, align 4
  %47 = mul i32 153, %mp45
  %48 = add i32 %47, 2
  %49 = icmp eq i32 %48, -2147483648
  %50 = and i1 %49, false
  %51 = or i1 false, %50
  br i1 %51, label %div.bad46, label %div.ok47

div.bad46:                                        ; preds = %div.ok41
  %exc48 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc48)
  store ptr %exc48, ptr %exc.thrown49, align 8
  call void @_CxxThrowException(ptr %exc.thrown49, ptr @_TI1PEAX)
  unreachable

div.ok47:                                         ; preds = %div.ok41
  %52 = sdiv i32 %48, 5
  %53 = sub i32 %doy44, %52
  %54 = add i32 %53, 1
  store i32 %54, ptr %d, align 4
  %mp50 = load i32, ptr %mp, align 4
  store i32 %mp50, ptr %m, align 4
  %mp51 = load i32, ptr %mp, align 4
  %55 = icmp slt i32 %mp51, 10
  %56 = zext i1 %55 to i32
  br i1 %55, label %if.then, label %if.else

if.then:                                          ; preds = %div.ok47
  %mp52 = load i32, ptr %mp, align 4
  %57 = add i32 %mp52, 3
  store i32 %57, ptr %m, align 4
  br label %if.end

if.else:                                          ; preds = %div.ok47
  %mp53 = load i32, ptr %mp, align 4
  %58 = sub i32 %mp53, 9
  store i32 %58, ptr %m, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %m54 = load i32, ptr %m, align 4
  %59 = icmp sle i32 %m54, 2
  %60 = zext i1 %59 to i32
  br i1 %59, label %if.then55, label %if.end56

if.then55:                                        ; preds = %if.end
  %y57 = load i32, ptr %y, align 4
  %61 = add i32 %y57, 1
  store i32 %61, ptr %y, align 4
  br label %if.end56

if.end56:                                         ; preds = %if.then55, %if.end
  %Date.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Date, ptr null, i64 1) to i64))
  %y58 = load i32, ptr %y, align 4
  %m59 = load i32, ptr %m, align 4
  %d60 = load i32, ptr %d, align 4
  call void @Date.Date(ptr %Date.obj, i32 %y58, i32 %m59, i32 %d60)
  ret ptr %Date.obj
}

define internal ptr @Date.addDays(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %2 = call i32 @Date.toEpochDay(ptr %0)
  %n1 = load i32, ptr %n, align 4
  %3 = add i32 %2, %n1
  %4 = call ptr @Date.fromEpochDay(i32 %3)
  ret ptr %4
}

define internal i32 @Digest.crc32(ptr %0) {
entry:
  %b = alloca i32, align 4
  %i = alloca i32, align 4
  %poly = alloca i32, align 4
  %crc = alloca i32, align 4
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  store i32 -1, ptr %crc, align 4
  store i32 -306674912, ptr %poly, align 4
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
  %crc3 = load i32, ptr %crc, align 4
  %data4 = load ptr, ptr %data, align 8
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %data4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data6, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = xor i32 %crc3, %5
  store i32 %6, ptr %crc, align 4
  store i32 0, ptr %b, align 4
  br label %for.cond7

for.update:                                       ; preds = %for.end10
  %7 = load i32, ptr %i, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %crc16 = load i32, ptr %crc, align 4
  %9 = xor i32 %crc16, -1
  store i32 %9, ptr %crc, align 4
  %crc17 = load i32, ptr %crc, align 4
  ret i32 %crc17

for.cond7:                                        ; preds = %for.update9, %for.body
  %b11 = load i32, ptr %b, align 4
  %10 = icmp slt i32 %b11, 8
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body8, label %for.end10

for.body8:                                        ; preds = %for.cond7
  %crc12 = load i32, ptr %crc, align 4
  %12 = and i32 %crc12, 1
  %13 = icmp ne i32 %12, 0
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.else

for.update9:                                      ; preds = %if.end
  %15 = load i32, ptr %b, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %b, align 4
  br label %for.cond7

for.end10:                                        ; preds = %for.cond7
  br label %for.update

if.then:                                          ; preds = %for.body8
  %crc13 = load i32, ptr %crc, align 4
  %17 = lshr i32 %crc13, 1
  %poly14 = load i32, ptr %poly, align 4
  %18 = xor i32 %17, %poly14
  store i32 %18, ptr %crc, align 4
  br label %if.end

if.else:                                          ; preds = %for.body8
  %crc15 = load i32, ptr %crc, align 4
  %19 = lshr i32 %crc15, 1
  store i32 %19, ptr %crc, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.update9
}

define internal i32 @Digest.fnv1a(ptr %0) {
entry:
  %i = alloca i32, align 4
  %prime = alloca i32, align 4
  %h = alloca i32, align 4
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  store i32 -2128831035, ptr %h, align 4
  store i32 16777619, ptr %prime, align 4
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
  %h3 = load i32, ptr %h, align 4
  %data4 = load ptr, ptr %data, align 8
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %data4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data6, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = xor i32 %h3, %5
  %prime7 = load i32, ptr %prime, align 4
  %7 = mul i32 %6, %prime7
  store i32 %7, ptr %h, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %h8 = load i32, ptr %h, align 4
  ret i32 %h8
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
