; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/calendar.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/calendar.pol"
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
@.str = private unnamed_addr constant [67 x i8] c"y2000sat=%d y2024mon=%d leap2000=%d leap1900=%d feb2024=%d doy=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1304 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1305 = private global %String { i64 16, ptr @.strdata.1304, i64 0 }
@.strdata.1306 = private constant [17 x i8] c"division by zero\00"
@.strobj.1307 = private global %String { i64 16, ptr @.strdata.1306, i64 0 }
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %16 = call i32 @Calendar.dayOfWeek(i32 2000, i32 1, i32 1)
  %17 = call i32 @Calendar.dayOfWeek(i32 2024, i32 1, i32 1)
  %18 = call i32 @Calendar.isLeapYear(i32 2000)
  %19 = call i32 @Calendar.isLeapYear(i32 1900)
  %20 = call i32 @Calendar.daysInMonth(i32 2024, i32 2)
  %21 = call i32 @Calendar.dayOfYear(i32 2024, i32 3, i32 1)
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1305)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1307)
  ret ptr %strcpy
}

define internal i32 @Calendar.isLeapYear(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown13 = alloca ptr, align 8
  %exc.thrown6 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %y = alloca i32, align 4
  store i32 %0, ptr %y, align 4
  %y1 = load i32, ptr %y, align 4
  %1 = icmp eq i32 %y1, -2147483648
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
  %4 = srem i32 %y1, 400
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %div.ok
  ret i32 1

if.end:                                           ; preds = %div.ok
  %y2 = load i32, ptr %y, align 4
  %7 = icmp eq i32 %y2, -2147483648
  %8 = and i1 %7, false
  %9 = or i1 false, %8
  br i1 %9, label %div.bad3, label %div.ok4

div.bad3:                                         ; preds = %if.end
  %exc5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc5)
  store ptr %exc5, ptr %exc.thrown6, align 8
  call void @_CxxThrowException(ptr %exc.thrown6, ptr @_TI1PEAX)
  unreachable

div.ok4:                                          ; preds = %if.end
  %10 = srem i32 %y2, 100
  %11 = icmp eq i32 %10, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then7, label %if.end8

if.then7:                                         ; preds = %div.ok4
  ret i32 0

if.end8:                                          ; preds = %div.ok4
  %y9 = load i32, ptr %y, align 4
  %13 = icmp eq i32 %y9, -2147483648
  %14 = and i1 %13, false
  %15 = or i1 false, %14
  br i1 %15, label %div.bad10, label %div.ok11

div.bad10:                                        ; preds = %if.end8
  %exc12 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc12)
  store ptr %exc12, ptr %exc.thrown13, align 8
  call void @_CxxThrowException(ptr %exc.thrown13, ptr @_TI1PEAX)
  unreachable

div.ok11:                                         ; preds = %if.end8
  %16 = srem i32 %y9, 4
  %17 = icmp eq i32 %16, 0
  %18 = zext i1 %17 to i32
  ret i32 %18
}

define internal i32 @Calendar.daysInMonth(i32 %0, i32 %1) {
entry:
  %m = alloca i32, align 4
  %y = alloca i32, align 4
  store i32 %0, ptr %y, align 4
  store i32 %1, ptr %m, align 4
  %m1 = load i32, ptr %m, align 4
  %2 = icmp eq i32 %m1, 2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %y2 = load i32, ptr %y, align 4
  %4 = call i32 @Calendar.isLeapYear(i32 %y2)
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %if.then3, label %if.end4

if.end:                                           ; preds = %entry
  %m5 = load i32, ptr %m, align 4
  %6 = icmp eq i32 %m5, 4
  %7 = zext i1 %6 to i32
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

if.then3:                                         ; preds = %if.then
  ret i32 29

if.end4:                                          ; preds = %if.then
  ret i32 28

sc.rhs:                                           ; preds = %if.end
  %m6 = load i32, ptr %m, align 4
  %8 = icmp eq i32 %m6, 6
  %9 = zext i1 %8 to i32
  %sc.b = icmp ne i32 %9, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %if.end
  %sc = phi i1 [ true, %if.end ], [ %sc.b, %sc.rhs ]
  %10 = zext i1 %sc to i32
  %sc.a7 = icmp ne i32 %10, 0
  br i1 %sc.a7, label %sc.end9, label %sc.rhs8

sc.rhs8:                                          ; preds = %sc.end
  %m10 = load i32, ptr %m, align 4
  %11 = icmp eq i32 %m10, 9
  %12 = zext i1 %11 to i32
  %sc.b11 = icmp ne i32 %12, 0
  br label %sc.end9

sc.end9:                                          ; preds = %sc.rhs8, %sc.end
  %sc12 = phi i1 [ true, %sc.end ], [ %sc.b11, %sc.rhs8 ]
  %13 = zext i1 %sc12 to i32
  %sc.a13 = icmp ne i32 %13, 0
  br i1 %sc.a13, label %sc.end15, label %sc.rhs14

sc.rhs14:                                         ; preds = %sc.end9
  %m16 = load i32, ptr %m, align 4
  %14 = icmp eq i32 %m16, 11
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

define internal i32 @Calendar.dayOfWeek(i32 %0, i32 %1, i32 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown38 = alloca ptr, align 8
  %h = alloca i32, align 4
  %exc.thrown33 = alloca ptr, align 8
  %exc.thrown28 = alloca ptr, align 8
  %exc.thrown23 = alloca ptr, align 8
  %exc.thrown17 = alloca ptr, align 8
  %j = alloca i32, align 4
  %exc.thrown11 = alloca ptr, align 8
  %k = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %y = alloca i32, align 4
  %m = alloca i32, align 4
  %day = alloca i32, align 4
  %month = alloca i32, align 4
  %year = alloca i32, align 4
  store i32 %0, ptr %year, align 4
  store i32 %1, ptr %month, align 4
  store i32 %2, ptr %day, align 4
  %month1 = load i32, ptr %month, align 4
  store i32 %month1, ptr %m, align 4
  %year2 = load i32, ptr %year, align 4
  store i32 %year2, ptr %y, align 4
  %m3 = load i32, ptr %m, align 4
  %3 = icmp slt i32 %m3, 3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %m4 = load i32, ptr %m, align 4
  %5 = add i32 %m4, 12
  store i32 %5, ptr %m, align 4
  %y5 = load i32, ptr %y, align 4
  %6 = sub i32 %y5, 1
  store i32 %6, ptr %y, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %y6 = load i32, ptr %y, align 4
  %7 = icmp eq i32 %y6, -2147483648
  %8 = and i1 %7, false
  %9 = or i1 false, %8
  br i1 %9, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end
  %10 = srem i32 %y6, 100
  store i32 %10, ptr %k, align 4
  %y7 = load i32, ptr %y, align 4
  %11 = icmp eq i32 %y7, -2147483648
  %12 = and i1 %11, false
  %13 = or i1 false, %12
  br i1 %13, label %div.bad8, label %div.ok9

div.bad8:                                         ; preds = %div.ok
  %exc10 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc10)
  store ptr %exc10, ptr %exc.thrown11, align 8
  call void @_CxxThrowException(ptr %exc.thrown11, ptr @_TI1PEAX)
  unreachable

div.ok9:                                          ; preds = %div.ok
  %14 = sdiv i32 %y7, 100
  store i32 %14, ptr %j, align 4
  %day12 = load i32, ptr %day, align 4
  %m13 = load i32, ptr %m, align 4
  %15 = add i32 %m13, 1
  %16 = mul i32 13, %15
  %17 = icmp eq i32 %16, -2147483648
  %18 = and i1 %17, false
  %19 = or i1 false, %18
  br i1 %19, label %div.bad14, label %div.ok15

div.bad14:                                        ; preds = %div.ok9
  %exc16 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc16)
  store ptr %exc16, ptr %exc.thrown17, align 8
  call void @_CxxThrowException(ptr %exc.thrown17, ptr @_TI1PEAX)
  unreachable

div.ok15:                                         ; preds = %div.ok9
  %20 = sdiv i32 %16, 5
  %21 = add i32 %day12, %20
  %k18 = load i32, ptr %k, align 4
  %22 = add i32 %21, %k18
  %k19 = load i32, ptr %k, align 4
  %23 = icmp eq i32 %k19, -2147483648
  %24 = and i1 %23, false
  %25 = or i1 false, %24
  br i1 %25, label %div.bad20, label %div.ok21

div.bad20:                                        ; preds = %div.ok15
  %exc22 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc22)
  store ptr %exc22, ptr %exc.thrown23, align 8
  call void @_CxxThrowException(ptr %exc.thrown23, ptr @_TI1PEAX)
  unreachable

div.ok21:                                         ; preds = %div.ok15
  %26 = sdiv i32 %k19, 4
  %27 = add i32 %22, %26
  %j24 = load i32, ptr %j, align 4
  %28 = icmp eq i32 %j24, -2147483648
  %29 = and i1 %28, false
  %30 = or i1 false, %29
  br i1 %30, label %div.bad25, label %div.ok26

div.bad25:                                        ; preds = %div.ok21
  %exc27 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc27)
  store ptr %exc27, ptr %exc.thrown28, align 8
  call void @_CxxThrowException(ptr %exc.thrown28, ptr @_TI1PEAX)
  unreachable

div.ok26:                                         ; preds = %div.ok21
  %31 = sdiv i32 %j24, 4
  %32 = add i32 %27, %31
  %j29 = load i32, ptr %j, align 4
  %33 = mul i32 5, %j29
  %34 = add i32 %32, %33
  %35 = icmp eq i32 %34, -2147483648
  %36 = and i1 %35, false
  %37 = or i1 false, %36
  br i1 %37, label %div.bad30, label %div.ok31

div.bad30:                                        ; preds = %div.ok26
  %exc32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc32)
  store ptr %exc32, ptr %exc.thrown33, align 8
  call void @_CxxThrowException(ptr %exc.thrown33, ptr @_TI1PEAX)
  unreachable

div.ok31:                                         ; preds = %div.ok26
  %38 = srem i32 %34, 7
  store i32 %38, ptr %h, align 4
  %h34 = load i32, ptr %h, align 4
  %39 = add i32 %h34, 6
  %40 = icmp eq i32 %39, -2147483648
  %41 = and i1 %40, false
  %42 = or i1 false, %41
  br i1 %42, label %div.bad35, label %div.ok36

div.bad35:                                        ; preds = %div.ok31
  %exc37 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc37)
  store ptr %exc37, ptr %exc.thrown38, align 8
  call void @_CxxThrowException(ptr %exc.thrown38, ptr @_TI1PEAX)
  unreachable

div.ok36:                                         ; preds = %div.ok31
  %43 = srem i32 %39, 7
  ret i32 %43
}

define internal i32 @Calendar.dayOfYear(i32 %0, i32 %1, i32 %2) {
entry:
  %mm = alloca i32, align 4
  %total = alloca i32, align 4
  %d = alloca i32, align 4
  %m = alloca i32, align 4
  %y = alloca i32, align 4
  store i32 %0, ptr %y, align 4
  store i32 %1, ptr %m, align 4
  store i32 %2, ptr %d, align 4
  %d1 = load i32, ptr %d, align 4
  store i32 %d1, ptr %total, align 4
  store i32 1, ptr %mm, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %mm2 = load i32, ptr %mm, align 4
  %m3 = load i32, ptr %m, align 4
  %3 = icmp slt i32 %mm2, %m3
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %total4 = load i32, ptr %total, align 4
  %y5 = load i32, ptr %y, align 4
  %mm6 = load i32, ptr %mm, align 4
  %5 = call i32 @Calendar.daysInMonth(i32 %y5, i32 %mm6)
  %6 = add i32 %total4, %5
  store i32 %6, ptr %total, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %7 = load i32, ptr %mm, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %mm, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %total7 = load i32, ptr %total, align 4
  ret i32 %total7
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
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
