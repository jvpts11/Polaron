; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ciphers.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ciphers.pol"
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
@.strdata = private constant [14 x i8] c"Hello, World!\00"
@.strobj = private global %String { i64 13, ptr @.strdata, i64 0 }
@.str = private unnamed_addr constant [26 x i8] c"caesar=%s back=%s rot=%s\0A\00", align 1
@.strdata.1 = private constant [6 x i8] c"Hello\00"
@.strobj.2 = private global %String { i64 5, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [13 x i8] c"ATTACKATDAWN\00"
@.strobj.4 = private global %String { i64 12, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [6 x i8] c"LEMON\00"
@.strobj.6 = private global %String { i64 5, ptr @.strdata.5, i64 0 }
@.str.7 = private unnamed_addr constant [16 x i8] c"vig=%s back=%s\0A\00", align 1
@.strdata.8 = private constant [6 x i8] c"LEMON\00"
@.strobj.9 = private global %String { i64 5, ptr @.strdata.8, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1315 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1316 = private global %String { i64 16, ptr @.strdata.1315, i64 0 }
@.strdata.1317 = private constant [17 x i8] c"division by zero\00"
@.strobj.1318 = private global %String { i64 16, ptr @.strdata.1317, i64 0 }
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }
@.strdata.5318 = private constant [1 x i8] zeroinitializer
@.strobj.5319 = private global %String { i64 0, ptr @.strdata.5318, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %ve = alloca ptr, align 8
  %ce = alloca ptr, align 8
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
  %16 = call ptr @Caesar.encrypt(ptr @.strobj, i32 3)
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  store ptr %strcpy, ptr %ce, align 8
  call void @__polaron_str_free(ptr %16)
  %ce1 = load ptr, ptr %ce, align 8
  %str.data = getelementptr inbounds %String, ptr %ce1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ce2 = load ptr, ptr %ce, align 8
  %17 = call ptr @Caesar.decrypt(ptr %ce2, i32 3)
  %str.data3 = getelementptr inbounds %String, ptr %17, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %18 = call ptr @Caesar.rot13(ptr @.strobj.2)
  %19 = call ptr @Caesar.rot13(ptr %18)
  %str.data5 = getelementptr inbounds %String, ptr %19, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %20 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, ptr %data4, ptr %data6)
  call void @__polaron_str_free(ptr %17)
  call void @__polaron_str_free(ptr %18)
  call void @__polaron_str_free(ptr %19)
  %21 = call ptr @Vigenere.encrypt(ptr @.strobj.4, ptr @.strobj.6)
  %strcpy7 = call ptr @__polaron_str_copy(ptr %21)
  store ptr %strcpy7, ptr %ve, align 8
  call void @__polaron_str_free(ptr %21)
  %ve8 = load ptr, ptr %ve, align 8
  %str.data9 = getelementptr inbounds %String, ptr %ve8, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %ve11 = load ptr, ptr %ve, align 8
  %22 = call ptr @Vigenere.decrypt(ptr %ve11, ptr @.strobj.9)
  %str.data12 = getelementptr inbounds %String, ptr %22, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %23 = call i32 (ptr, ...) @printf(ptr @.str.7, ptr %data10, ptr %data13)
  call void @__polaron_str_free(ptr %22)
  %24 = load ptr, ptr %ve, align 8
  call void @__polaron_str_free(ptr %24)
  %25 = load ptr, ptr %ce, align 8
  call void @__polaron_str_free(ptr %25)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1316)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1318)
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

define internal i32 @Caesar.shiftChar(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown19 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %n = alloca i32, align 4
  %c = alloca i32, align 4
  store i32 %0, ptr %c, align 4
  store i32 %1, ptr %n, align 4
  %c1 = load i32, ptr %c, align 4
  %2 = icmp sge i32 %c1, 65
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %c2 = load i32, ptr %c, align 4
  %4 = icmp sle i32 %c2, 90
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %c3 = load i32, ptr %c, align 4
  %7 = sub i32 %c3, 65
  %n4 = load i32, ptr %n, align 4
  %8 = add i32 %7, %n4
  %9 = add i32 %8, 2600
  %10 = icmp eq i32 %9, -2147483648
  %11 = and i1 %10, false
  %12 = or i1 false, %11
  br i1 %12, label %div.bad, label %div.ok

if.end:                                           ; preds = %sc.end
  %c5 = load i32, ptr %c, align 4
  %13 = icmp sge i32 %c5, 97
  %14 = zext i1 %13 to i32
  %sc.a6 = icmp ne i32 %14, 0
  br i1 %sc.a6, label %sc.rhs7, label %sc.end8

div.bad:                                          ; preds = %if.then
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.then
  %15 = srem i32 %9, 26
  %16 = add i32 %15, 65
  ret i32 %16

sc.rhs7:                                          ; preds = %if.end
  %c9 = load i32, ptr %c, align 4
  %17 = icmp sle i32 %c9, 122
  %18 = zext i1 %17 to i32
  %sc.b10 = icmp ne i32 %18, 0
  br label %sc.end8

sc.end8:                                          ; preds = %sc.rhs7, %if.end
  %sc11 = phi i1 [ false, %if.end ], [ %sc.b10, %sc.rhs7 ]
  %19 = zext i1 %sc11 to i32
  br i1 %sc11, label %if.then12, label %if.end13

if.then12:                                        ; preds = %sc.end8
  %c14 = load i32, ptr %c, align 4
  %20 = sub i32 %c14, 97
  %n15 = load i32, ptr %n, align 4
  %21 = add i32 %20, %n15
  %22 = add i32 %21, 2600
  %23 = icmp eq i32 %22, -2147483648
  %24 = and i1 %23, false
  %25 = or i1 false, %24
  br i1 %25, label %div.bad16, label %div.ok17

if.end13:                                         ; preds = %sc.end8
  %c20 = load i32, ptr %c, align 4
  ret i32 %c20

div.bad16:                                        ; preds = %if.then12
  %exc18 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc18)
  store ptr %exc18, ptr %exc.thrown19, align 8
  call void @_CxxThrowException(ptr %exc.thrown19, ptr @_TI1PEAX)
  unreachable

div.ok17:                                         ; preds = %if.then12
  %26 = srem i32 %22, 26
  %27 = add i32 %26, 97
  ret i32 %27
}

define internal ptr @Caesar.encrypt(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %n = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store i32 %1, ptr %n, align 4
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %s2 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp slt i32 %i1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sb3 = load ptr, ptr %sb, align 8
  %s4 = load ptr, ptr %s, align 8
  %i5 = load i32, ptr %i, align 4
  %5 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %n6 = load i32, ptr %n, align 4
  %7 = call i32 @Caesar.shiftChar(i32 %6, i32 %n6)
  %8 = call ptr @StringBuilder.appendChar(ptr %sb3, i32 %7)
  br label %for.update

for.update:                                       ; preds = %for.body
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb7 = load ptr, ptr %sb, align 8
  %11 = call ptr @StringBuilder.toString(ptr %sb7)
  %strcpy = call ptr @__polaron_str_copy(ptr %11)
  call void @__polaron_str_free(ptr %11)
  ret ptr %strcpy
}

define internal ptr @Caesar.decrypt(ptr %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %n = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store i32 %1, ptr %n, align 4
  %s1 = load ptr, ptr %s, align 8
  %n2 = load i32, ptr %n, align 4
  %2 = icmp eq i32 %n2, -2147483648
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
  %5 = srem i32 %n2, 26
  %6 = sub i32 26, %5
  %7 = call ptr @Caesar.encrypt(ptr %s1, i32 %6)
  %strcpy = call ptr @__polaron_str_copy(ptr %7)
  call void @__polaron_str_free(ptr %7)
  ret ptr %strcpy
}

define internal ptr @Caesar.rot13(ptr %0) {
entry:
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %1 = call ptr @Caesar.encrypt(ptr %s1, i32 13)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  call void @__polaron_str_free(ptr %1)
  ret ptr %strcpy
}

define internal ptr @Vigenere.proc(ptr %0, ptr %1, i32 %2) personality ptr @__CxxFrameHandler3 {
entry:
  %shifted = alloca i32, align 4
  %exc.thrown62 = alloca ptr, align 8
  %off = alloca i32, align 4
  %base = alloca i32, align 4
  %kshift = alloca i32, align 4
  %kc = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %lower = alloca i32, align 4
  %upper = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %klen = alloca i32, align 4
  %ki = alloca i32, align 4
  %sb = alloca ptr, align 8
  %dir = alloca i32, align 4
  %key = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store ptr %1, ptr %key, align 8
  store i32 %2, ptr %dir, align 4
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %ki, align 4
  %key1 = load ptr, ptr %key, align 8
  %str.len = getelementptr inbounds %String, ptr %key1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %3 = trunc i64 %len to i32
  store i32 %3, ptr %klen, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %s3 = load ptr, ptr %s, align 8
  %str.len4 = getelementptr inbounds %String, ptr %s3, i32 0, i32 0
  %len5 = load i64, ptr %str.len4, align 8
  %4 = trunc i64 %len5 to i32
  %5 = icmp slt i32 %i2, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s6 = load ptr, ptr %s, align 8
  %i7 = load i32, ptr %i, align 4
  %7 = sext i32 %i7 to i64
  %str.data = getelementptr inbounds %String, ptr %s6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %7
  %ch = load i8, ptr %ch.addr, align 1
  %8 = zext i8 %ch to i32
  store i32 %8, ptr %c, align 4
  %c8 = load i32, ptr %c, align 4
  %9 = icmp sge i32 %c8, 65
  %10 = zext i1 %9 to i32
  %sc.a = icmp ne i32 %10, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb69 = load ptr, ptr %sb, align 8
  %13 = call ptr @StringBuilder.toString(ptr %sb69)
  %strcpy = call ptr @__polaron_str_copy(ptr %13)
  call void @__polaron_str_free(ptr %13)
  ret ptr %strcpy

sc.rhs:                                           ; preds = %for.body
  %c9 = load i32, ptr %c, align 4
  %14 = icmp sle i32 %c9, 90
  %15 = zext i1 %14 to i32
  %sc.b = icmp ne i32 %15, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %for.body
  %sc = phi i1 [ false, %for.body ], [ %sc.b, %sc.rhs ]
  %16 = zext i1 %sc to i32
  store i32 %16, ptr %upper, align 4
  %c10 = load i32, ptr %c, align 4
  %17 = icmp sge i32 %c10, 97
  %18 = zext i1 %17 to i32
  %sc.a11 = icmp ne i32 %18, 0
  br i1 %sc.a11, label %sc.rhs12, label %sc.end13

sc.rhs12:                                         ; preds = %sc.end
  %c14 = load i32, ptr %c, align 4
  %19 = icmp sle i32 %c14, 122
  %20 = zext i1 %19 to i32
  %sc.b15 = icmp ne i32 %20, 0
  br label %sc.end13

sc.end13:                                         ; preds = %sc.rhs12, %sc.end
  %sc16 = phi i1 [ false, %sc.end ], [ %sc.b15, %sc.rhs12 ]
  %21 = zext i1 %sc16 to i32
  store i32 %21, ptr %lower, align 4
  %upper17 = load i32, ptr %upper, align 4
  %sc.a18 = icmp ne i32 %upper17, 0
  br i1 %sc.a18, label %sc.end20, label %sc.rhs19

sc.rhs19:                                         ; preds = %sc.end13
  %lower21 = load i32, ptr %lower, align 4
  %sc.b22 = icmp ne i32 %lower21, 0
  br label %sc.end20

sc.end20:                                         ; preds = %sc.rhs19, %sc.end13
  %sc23 = phi i1 [ true, %sc.end13 ], [ %sc.b22, %sc.rhs19 ]
  %22 = zext i1 %sc23 to i32
  br i1 %sc23, label %if.then, label %if.else

if.then:                                          ; preds = %sc.end20
  %key24 = load ptr, ptr %key, align 8
  %ki25 = load i32, ptr %ki, align 4
  %klen26 = load i32, ptr %klen, align 4
  %23 = icmp eq i32 %klen26, 0
  %24 = icmp eq i32 %ki25, -2147483648
  %25 = icmp eq i32 %klen26, -1
  %26 = and i1 %24, %25
  %27 = or i1 %23, %26
  br i1 %27, label %div.bad, label %div.ok

if.else:                                          ; preds = %sc.end20
  %sb67 = load ptr, ptr %sb, align 8
  %c68 = load i32, ptr %c, align 4
  %28 = call ptr @StringBuilder.appendChar(ptr %sb67, i32 %c68)
  br label %if.end

if.end:                                           ; preds = %if.else, %div.ok60
  br label %for.update

div.bad:                                          ; preds = %if.then
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.then
  %29 = srem i32 %ki25, %klen26
  %30 = sext i32 %29 to i64
  %str.data27 = getelementptr inbounds %String, ptr %key24, i32 0, i32 1
  %data28 = load ptr, ptr %str.data27, align 8
  %ch.addr29 = getelementptr i8, ptr %data28, i64 %30
  %ch30 = load i8, ptr %ch.addr29, align 1
  %31 = zext i8 %ch30 to i32
  store i32 %31, ptr %kc, align 4
  store i32 0, ptr %kshift, align 4
  %kc31 = load i32, ptr %kc, align 4
  %32 = icmp sge i32 %kc31, 65
  %33 = zext i1 %32 to i32
  %sc.a32 = icmp ne i32 %33, 0
  br i1 %sc.a32, label %sc.rhs33, label %sc.end34

sc.rhs33:                                         ; preds = %div.ok
  %kc35 = load i32, ptr %kc, align 4
  %34 = icmp sle i32 %kc35, 90
  %35 = zext i1 %34 to i32
  %sc.b36 = icmp ne i32 %35, 0
  br label %sc.end34

sc.end34:                                         ; preds = %sc.rhs33, %div.ok
  %sc37 = phi i1 [ false, %div.ok ], [ %sc.b36, %sc.rhs33 ]
  %36 = zext i1 %sc37 to i32
  br i1 %sc37, label %if.then38, label %if.end39

if.then38:                                        ; preds = %sc.end34
  %kc40 = load i32, ptr %kc, align 4
  %37 = sub i32 %kc40, 65
  store i32 %37, ptr %kshift, align 4
  br label %if.end39

if.end39:                                         ; preds = %if.then38, %sc.end34
  %kc41 = load i32, ptr %kc, align 4
  %38 = icmp sge i32 %kc41, 97
  %39 = zext i1 %38 to i32
  %sc.a42 = icmp ne i32 %39, 0
  br i1 %sc.a42, label %sc.rhs43, label %sc.end44

sc.rhs43:                                         ; preds = %if.end39
  %kc45 = load i32, ptr %kc, align 4
  %40 = icmp sle i32 %kc45, 122
  %41 = zext i1 %40 to i32
  %sc.b46 = icmp ne i32 %41, 0
  br label %sc.end44

sc.end44:                                         ; preds = %sc.rhs43, %if.end39
  %sc47 = phi i1 [ false, %if.end39 ], [ %sc.b46, %sc.rhs43 ]
  %42 = zext i1 %sc47 to i32
  br i1 %sc47, label %if.then48, label %if.end49

if.then48:                                        ; preds = %sc.end44
  %kc50 = load i32, ptr %kc, align 4
  %43 = sub i32 %kc50, 97
  store i32 %43, ptr %kshift, align 4
  br label %if.end49

if.end49:                                         ; preds = %if.then48, %sc.end44
  store i32 65, ptr %base, align 4
  %lower51 = load i32, ptr %lower, align 4
  %44 = icmp ne i32 %lower51, 0
  br i1 %44, label %if.then52, label %if.end53

if.then52:                                        ; preds = %if.end49
  store i32 97, ptr %base, align 4
  br label %if.end53

if.end53:                                         ; preds = %if.then52, %if.end49
  %c54 = load i32, ptr %c, align 4
  %base55 = load i32, ptr %base, align 4
  %45 = sub i32 %c54, %base55
  store i32 %45, ptr %off, align 4
  %off56 = load i32, ptr %off, align 4
  %dir57 = load i32, ptr %dir, align 4
  %kshift58 = load i32, ptr %kshift, align 4
  %46 = mul i32 %dir57, %kshift58
  %47 = add i32 %off56, %46
  %48 = add i32 %47, 2600
  %49 = icmp eq i32 %48, -2147483648
  %50 = and i1 %49, false
  %51 = or i1 false, %50
  br i1 %51, label %div.bad59, label %div.ok60

div.bad59:                                        ; preds = %if.end53
  %exc61 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc61)
  store ptr %exc61, ptr %exc.thrown62, align 8
  call void @_CxxThrowException(ptr %exc.thrown62, ptr @_TI1PEAX)
  unreachable

div.ok60:                                         ; preds = %if.end53
  %52 = srem i32 %48, 26
  store i32 %52, ptr %shifted, align 4
  %sb63 = load ptr, ptr %sb, align 8
  %base64 = load i32, ptr %base, align 4
  %shifted65 = load i32, ptr %shifted, align 4
  %53 = add i32 %base64, %shifted65
  %54 = call ptr @StringBuilder.appendChar(ptr %sb63, i32 %53)
  %ki66 = load i32, ptr %ki, align 4
  %55 = add i32 %ki66, 1
  store i32 %55, ptr %ki, align 4
  br label %if.end
}

define internal ptr @Vigenere.encrypt(ptr %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store ptr %1, ptr %key, align 8
  %s1 = load ptr, ptr %s, align 8
  %key2 = load ptr, ptr %key, align 8
  %2 = call ptr @Vigenere.proc(ptr %s1, ptr %key2, i32 1)
  %strcpy = call ptr @__polaron_str_copy(ptr %2)
  call void @__polaron_str_free(ptr %2)
  ret ptr %strcpy
}

define internal ptr @Vigenere.decrypt(ptr %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store ptr %1, ptr %key, align 8
  %s1 = load ptr, ptr %s, align 8
  %key2 = load ptr, ptr %key, align 8
  %2 = call ptr @Vigenere.proc(ptr %s1, ptr %key2, i32 -1)
  %strcpy = call ptr @__polaron_str_copy(ptr %2)
  call void @__polaron_str_free(ptr %2)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5317)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5319)
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

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
