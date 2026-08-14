; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/encoding_hex_base64.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/encoding_hex_base64.pol"
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
@.strdata = private constant [4 x i8] c"ABC\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c"Man\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.str = private unnamed_addr constant [47 x i8] c"hex=%s back=%s b64=%s dec=%s decMa=%s decM=%s\0A\00", align 1
@.strdata.3 = private constant [5 x i8] c"TWE=\00"
@.strobj.4 = private global %String { i64 4, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [5 x i8] c"TQ==\00"
@.strobj.6 = private global %String { i64 4, ptr @.strdata.5, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1312 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1313 = private global %String { i64 16, ptr @.strdata.1312, i64 0 }
@.strdata.1314 = private constant [17 x i8] c"division by zero\00"
@.strobj.1315 = private global %String { i64 16, ptr @.strdata.1314, i64 0 }
@.strdata.2893 = private constant [17 x i8] c"0123456789abcdef\00"
@.strobj.2894 = private global %String { i64 16, ptr @.strdata.2893, i64 0 }
@.strdata.2897 = private constant [65 x i8] c"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\00"
@.strobj.2898 = private global %String { i64 64, ptr @.strdata.2897, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %e = alloca ptr, align 8
  %h = alloca ptr, align 8
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
  %16 = call ptr @Hex.encode(ptr @.strobj)
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  store ptr %strcpy, ptr %h, align 8
  call void @__polaron_str_free(ptr %16)
  %17 = call ptr @Base64.encode(ptr @.strobj.2)
  %strcpy1 = call ptr @__polaron_str_copy(ptr %17)
  store ptr %strcpy1, ptr %e, align 8
  call void @__polaron_str_free(ptr %17)
  %h2 = load ptr, ptr %h, align 8
  %str.data = getelementptr inbounds %String, ptr %h2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %h3 = load ptr, ptr %h, align 8
  %18 = call ptr @Hex.decode(ptr %h3)
  %str.data4 = getelementptr inbounds %String, ptr %18, i32 0, i32 1
  %data5 = load ptr, ptr %str.data4, align 8
  %e6 = load ptr, ptr %e, align 8
  %str.data7 = getelementptr inbounds %String, ptr %e6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %e9 = load ptr, ptr %e, align 8
  %19 = call ptr @Base64.decode(ptr %e9)
  %str.data10 = getelementptr inbounds %String, ptr %19, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %20 = call ptr @Base64.decode(ptr @.strobj.4)
  %str.data12 = getelementptr inbounds %String, ptr %20, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %21 = call ptr @Base64.decode(ptr @.strobj.6)
  %str.data14 = getelementptr inbounds %String, ptr %21, i32 0, i32 1
  %data15 = load ptr, ptr %str.data14, align 8
  %22 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, ptr %data5, ptr %data8, ptr %data11, ptr %data13, ptr %data15)
  call void @__polaron_str_free(ptr %18)
  call void @__polaron_str_free(ptr %19)
  call void @__polaron_str_free(ptr %20)
  call void @__polaron_str_free(ptr %21)
  %23 = load ptr, ptr %e, align 8
  call void @__polaron_str_free(ptr %23)
  %24 = load ptr, ptr %h, align 8
  call void @__polaron_str_free(ptr %24)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1313)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1315)
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

define internal i32 @Hex.hexVal(i32 %0) {
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
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %c3 = load i32, ptr %c, align 4
  %6 = sub i32 %c3, 48
  ret i32 %6

if.end:                                           ; preds = %sc.end
  %c4 = load i32, ptr %c, align 4
  %7 = icmp sge i32 %c4, 97
  %8 = zext i1 %7 to i32
  %sc.a5 = icmp ne i32 %8, 0
  br i1 %sc.a5, label %sc.rhs6, label %sc.end7

sc.rhs6:                                          ; preds = %if.end
  %c8 = load i32, ptr %c, align 4
  %9 = icmp sle i32 %c8, 102
  %10 = zext i1 %9 to i32
  %sc.b9 = icmp ne i32 %10, 0
  br label %sc.end7

sc.end7:                                          ; preds = %sc.rhs6, %if.end
  %sc10 = phi i1 [ false, %if.end ], [ %sc.b9, %sc.rhs6 ]
  %11 = zext i1 %sc10 to i32
  br i1 %sc10, label %if.then11, label %if.end12

if.then11:                                        ; preds = %sc.end7
  %c13 = load i32, ptr %c, align 4
  %12 = sub i32 %c13, 97
  %13 = add i32 %12, 10
  ret i32 %13

if.end12:                                         ; preds = %sc.end7
  %c14 = load i32, ptr %c, align 4
  %14 = icmp sge i32 %c14, 65
  %15 = zext i1 %14 to i32
  %sc.a15 = icmp ne i32 %15, 0
  br i1 %sc.a15, label %sc.rhs16, label %sc.end17

sc.rhs16:                                         ; preds = %if.end12
  %c18 = load i32, ptr %c, align 4
  %16 = icmp sle i32 %c18, 70
  %17 = zext i1 %16 to i32
  %sc.b19 = icmp ne i32 %17, 0
  br label %sc.end17

sc.end17:                                         ; preds = %sc.rhs16, %if.end12
  %sc20 = phi i1 [ false, %if.end12 ], [ %sc.b19, %sc.rhs16 ]
  %18 = zext i1 %sc20 to i32
  br i1 %sc20, label %if.then21, label %if.end22

if.then21:                                        ; preds = %sc.end17
  %c23 = load i32, ptr %c, align 4
  %19 = sub i32 %c23, 65
  %20 = add i32 %19, 10
  ret i32 %20

if.end22:                                         ; preds = %sc.end17
  ret i32 0
}

define internal ptr @Hex.encode(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown19 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %b = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %digits = alloca ptr, align 8
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2894)
  store ptr %strcpy, ptr %digits, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
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
  %data3 = load ptr, ptr %data, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %data3, i32 0, i32 1
  %data5 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data5, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %b, align 4
  %sb6 = load ptr, ptr %sb, align 8
  %digits7 = load ptr, ptr %digits, align 8
  %b8 = load i32, ptr %b, align 4
  %6 = icmp eq i32 %b8, -2147483648
  %7 = and i1 %6, false
  %8 = or i1 false, %7
  br i1 %8, label %div.bad, label %div.ok

for.update:                                       ; preds = %div.ok17
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb24 = load ptr, ptr %sb, align 8
  %11 = call ptr @StringBuilder.toString(ptr %sb24)
  %strcpy25 = call ptr @__polaron_str_copy(ptr %11)
  call void @__polaron_str_free(ptr %11)
  %12 = load ptr, ptr %digits, align 8
  call void @__polaron_str_free(ptr %12)
  ret ptr %strcpy25

div.bad:                                          ; preds = %for.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.body
  %13 = sdiv i32 %b8, 16
  %14 = sext i32 %13 to i64
  %str.data9 = getelementptr inbounds %String, ptr %digits7, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %ch.addr11 = getelementptr i8, ptr %data10, i64 %14
  %ch12 = load i8, ptr %ch.addr11, align 1
  %15 = zext i8 %ch12 to i32
  %16 = call ptr @StringBuilder.appendChar(ptr %sb6, i32 %15)
  %sb13 = load ptr, ptr %sb, align 8
  %digits14 = load ptr, ptr %digits, align 8
  %b15 = load i32, ptr %b, align 4
  %17 = icmp eq i32 %b15, -2147483648
  %18 = and i1 %17, false
  %19 = or i1 false, %18
  br i1 %19, label %div.bad16, label %div.ok17

div.bad16:                                        ; preds = %div.ok
  %exc18 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc18)
  store ptr %exc18, ptr %exc.thrown19, align 8
  call void @_CxxThrowException(ptr %exc.thrown19, ptr @_TI1PEAX)
  unreachable

div.ok17:                                         ; preds = %div.ok
  %20 = srem i32 %b15, 16
  %21 = sext i32 %20 to i64
  %str.data20 = getelementptr inbounds %String, ptr %digits14, i32 0, i32 1
  %data21 = load ptr, ptr %str.data20, align 8
  %ch.addr22 = getelementptr i8, ptr %data21, i64 %21
  %ch23 = load i8, ptr %ch.addr22, align 1
  %22 = zext i8 %ch23 to i32
  %23 = call ptr @StringBuilder.appendChar(ptr %sb13, i32 %22)
  br label %for.update
}

define internal ptr @Hex.decode(ptr %0) {
entry:
  %lo = alloca i32, align 4
  %hi = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %hex = alloca ptr, align 8
  store ptr %0, ptr %hex, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %1 = add i32 %i1, 1
  %hex2 = load ptr, ptr %hex, align 8
  %str.len = getelementptr inbounds %String, ptr %hex2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp slt i32 %1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %hex3 = load ptr, ptr %hex, align 8
  %i4 = load i32, ptr %i, align 4
  %5 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %hex3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = call i32 @Hex.hexVal(i32 %6)
  store i32 %7, ptr %hi, align 4
  %hex5 = load ptr, ptr %hex, align 8
  %i6 = load i32, ptr %i, align 4
  %8 = add i32 %i6, 1
  %9 = sext i32 %8 to i64
  %str.data7 = getelementptr inbounds %String, ptr %hex5, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %ch.addr9 = getelementptr i8, ptr %data8, i64 %9
  %ch10 = load i8, ptr %ch.addr9, align 1
  %10 = zext i8 %ch10 to i32
  %11 = call i32 @Hex.hexVal(i32 %10)
  store i32 %11, ptr %lo, align 4
  %sb11 = load ptr, ptr %sb, align 8
  %hi12 = load i32, ptr %hi, align 4
  %12 = mul i32 %hi12, 16
  %lo13 = load i32, ptr %lo, align 4
  %13 = add i32 %12, %lo13
  %14 = call ptr @StringBuilder.appendChar(ptr %sb11, i32 %13)
  br label %for.update

for.update:                                       ; preds = %for.body
  %i14 = load i32, ptr %i, align 4
  %15 = add i32 %i14, 2
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb15 = load ptr, ptr %sb, align 8
  %16 = call ptr @StringBuilder.toString(ptr %sb15)
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  call void @__polaron_str_free(ptr %16)
  ret ptr %strcpy
}

define internal i32 @Base64.val(i32 %0) {
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
  %6 = sub i32 %c3, 65
  ret i32 %6

if.end:                                           ; preds = %sc.end
  %c4 = load i32, ptr %c, align 4
  %7 = icmp sge i32 %c4, 97
  %8 = zext i1 %7 to i32
  %sc.a5 = icmp ne i32 %8, 0
  br i1 %sc.a5, label %sc.rhs6, label %sc.end7

sc.rhs6:                                          ; preds = %if.end
  %c8 = load i32, ptr %c, align 4
  %9 = icmp sle i32 %c8, 122
  %10 = zext i1 %9 to i32
  %sc.b9 = icmp ne i32 %10, 0
  br label %sc.end7

sc.end7:                                          ; preds = %sc.rhs6, %if.end
  %sc10 = phi i1 [ false, %if.end ], [ %sc.b9, %sc.rhs6 ]
  %11 = zext i1 %sc10 to i32
  br i1 %sc10, label %if.then11, label %if.end12

if.then11:                                        ; preds = %sc.end7
  %c13 = load i32, ptr %c, align 4
  %12 = sub i32 %c13, 97
  %13 = add i32 %12, 26
  ret i32 %13

if.end12:                                         ; preds = %sc.end7
  %c14 = load i32, ptr %c, align 4
  %14 = icmp sge i32 %c14, 48
  %15 = zext i1 %14 to i32
  %sc.a15 = icmp ne i32 %15, 0
  br i1 %sc.a15, label %sc.rhs16, label %sc.end17

sc.rhs16:                                         ; preds = %if.end12
  %c18 = load i32, ptr %c, align 4
  %16 = icmp sle i32 %c18, 57
  %17 = zext i1 %16 to i32
  %sc.b19 = icmp ne i32 %17, 0
  br label %sc.end17

sc.end17:                                         ; preds = %sc.rhs16, %if.end12
  %sc20 = phi i1 [ false, %if.end12 ], [ %sc.b19, %sc.rhs16 ]
  %18 = zext i1 %sc20 to i32
  br i1 %sc20, label %if.then21, label %if.end22

if.then21:                                        ; preds = %sc.end17
  %c23 = load i32, ptr %c, align 4
  %19 = sub i32 %c23, 48
  %20 = add i32 %19, 52
  ret i32 %20

if.end22:                                         ; preds = %sc.end17
  %c24 = load i32, ptr %c, align 4
  %21 = icmp eq i32 %c24, 43
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then25, label %if.end26

if.then25:                                        ; preds = %if.end22
  ret i32 62

if.end26:                                         ; preds = %if.end22
  %c27 = load i32, ptr %c, align 4
  %23 = icmp eq i32 %c27, 47
  %24 = zext i1 %23 to i32
  br i1 %23, label %if.then28, label %if.end29

if.then28:                                        ; preds = %if.end26
  ret i32 63

if.end29:                                         ; preds = %if.end26
  ret i32 0
}

define internal ptr @Base64.encode(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown85 = alloca ptr, align 8
  %exc.thrown69 = alloca ptr, align 8
  %exc.thrown65 = alloca ptr, align 8
  %exc.thrown51 = alloca ptr, align 8
  %exc.thrown47 = alloca ptr, align 8
  %exc.thrown36 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %triple = alloca i32, align 4
  %has2 = alloca i32, align 4
  %b2 = alloca i32, align 4
  %has1 = alloca i32, align 4
  %b1 = alloca i32, align 4
  %b0 = alloca i32, align 4
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %alpha = alloca ptr, align 8
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2898)
  store ptr %strcpy, ptr %alpha, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  %data1 = load ptr, ptr %data, align 8
  %str.len = getelementptr inbounds %String, ptr %data1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end78, %entry
  %i2 = load i32, ptr %i, align 4
  %n3 = load i32, ptr %n, align 4
  %2 = icmp slt i32 %i2, %n3
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %data4 = load ptr, ptr %data, align 8
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %data4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data6, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %b0, align 4
  store i32 0, ptr %b1, align 4
  %i7 = load i32, ptr %i, align 4
  %6 = add i32 %i7, 1
  %n8 = load i32, ptr %n, align 4
  %7 = icmp slt i32 %6, %n8
  %8 = zext i1 %7 to i32
  store i32 %8, ptr %has1, align 4
  %has19 = load i32, ptr %has1, align 4
  %9 = icmp ne i32 %has19, 0
  br i1 %9, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  %sb92 = load ptr, ptr %sb, align 8
  %10 = call ptr @StringBuilder.toString(ptr %sb92)
  %strcpy93 = call ptr @__polaron_str_copy(ptr %10)
  call void @__polaron_str_free(ptr %10)
  %11 = load ptr, ptr %alpha, align 8
  call void @__polaron_str_free(ptr %11)
  ret ptr %strcpy93

if.then:                                          ; preds = %while.body
  %data10 = load ptr, ptr %data, align 8
  %i11 = load i32, ptr %i, align 4
  %12 = add i32 %i11, 1
  %13 = sext i32 %12 to i64
  %str.data12 = getelementptr inbounds %String, ptr %data10, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %ch.addr14 = getelementptr i8, ptr %data13, i64 %13
  %ch15 = load i8, ptr %ch.addr14, align 1
  %14 = zext i8 %ch15 to i32
  store i32 %14, ptr %b1, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %while.body
  store i32 0, ptr %b2, align 4
  %i16 = load i32, ptr %i, align 4
  %15 = add i32 %i16, 2
  %n17 = load i32, ptr %n, align 4
  %16 = icmp slt i32 %15, %n17
  %17 = zext i1 %16 to i32
  store i32 %17, ptr %has2, align 4
  %has218 = load i32, ptr %has2, align 4
  %18 = icmp ne i32 %has218, 0
  br i1 %18, label %if.then19, label %if.end20

if.then19:                                        ; preds = %if.end
  %data21 = load ptr, ptr %data, align 8
  %i22 = load i32, ptr %i, align 4
  %19 = add i32 %i22, 2
  %20 = sext i32 %19 to i64
  %str.data23 = getelementptr inbounds %String, ptr %data21, i32 0, i32 1
  %data24 = load ptr, ptr %str.data23, align 8
  %ch.addr25 = getelementptr i8, ptr %data24, i64 %20
  %ch26 = load i8, ptr %ch.addr25, align 1
  %21 = zext i8 %ch26 to i32
  store i32 %21, ptr %b2, align 4
  br label %if.end20

if.end20:                                         ; preds = %if.then19, %if.end
  %b027 = load i32, ptr %b0, align 4
  %22 = mul i32 %b027, 65536
  %b128 = load i32, ptr %b1, align 4
  %23 = mul i32 %b128, 256
  %24 = add i32 %22, %23
  %b229 = load i32, ptr %b2, align 4
  %25 = add i32 %24, %b229
  store i32 %25, ptr %triple, align 4
  %sb30 = load ptr, ptr %sb, align 8
  %alpha31 = load ptr, ptr %alpha, align 8
  %triple32 = load i32, ptr %triple, align 4
  %26 = icmp eq i32 %triple32, -2147483648
  %27 = and i1 %26, false
  %28 = or i1 false, %27
  br i1 %28, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end20
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end20
  %29 = sdiv i32 %triple32, 262144
  %30 = icmp eq i32 %29, -2147483648
  %31 = and i1 %30, false
  %32 = or i1 false, %31
  br i1 %32, label %div.bad33, label %div.ok34

div.bad33:                                        ; preds = %div.ok
  %exc35 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc35)
  store ptr %exc35, ptr %exc.thrown36, align 8
  call void @_CxxThrowException(ptr %exc.thrown36, ptr @_TI1PEAX)
  unreachable

div.ok34:                                         ; preds = %div.ok
  %33 = srem i32 %29, 64
  %34 = sext i32 %33 to i64
  %str.data37 = getelementptr inbounds %String, ptr %alpha31, i32 0, i32 1
  %data38 = load ptr, ptr %str.data37, align 8
  %ch.addr39 = getelementptr i8, ptr %data38, i64 %34
  %ch40 = load i8, ptr %ch.addr39, align 1
  %35 = zext i8 %ch40 to i32
  %36 = call ptr @StringBuilder.appendChar(ptr %sb30, i32 %35)
  %sb41 = load ptr, ptr %sb, align 8
  %alpha42 = load ptr, ptr %alpha, align 8
  %triple43 = load i32, ptr %triple, align 4
  %37 = icmp eq i32 %triple43, -2147483648
  %38 = and i1 %37, false
  %39 = or i1 false, %38
  br i1 %39, label %div.bad44, label %div.ok45

div.bad44:                                        ; preds = %div.ok34
  %exc46 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc46)
  store ptr %exc46, ptr %exc.thrown47, align 8
  call void @_CxxThrowException(ptr %exc.thrown47, ptr @_TI1PEAX)
  unreachable

div.ok45:                                         ; preds = %div.ok34
  %40 = sdiv i32 %triple43, 4096
  %41 = icmp eq i32 %40, -2147483648
  %42 = and i1 %41, false
  %43 = or i1 false, %42
  br i1 %43, label %div.bad48, label %div.ok49

div.bad48:                                        ; preds = %div.ok45
  %exc50 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc50)
  store ptr %exc50, ptr %exc.thrown51, align 8
  call void @_CxxThrowException(ptr %exc.thrown51, ptr @_TI1PEAX)
  unreachable

div.ok49:                                         ; preds = %div.ok45
  %44 = srem i32 %40, 64
  %45 = sext i32 %44 to i64
  %str.data52 = getelementptr inbounds %String, ptr %alpha42, i32 0, i32 1
  %data53 = load ptr, ptr %str.data52, align 8
  %ch.addr54 = getelementptr i8, ptr %data53, i64 %45
  %ch55 = load i8, ptr %ch.addr54, align 1
  %46 = zext i8 %ch55 to i32
  %47 = call ptr @StringBuilder.appendChar(ptr %sb41, i32 %46)
  %has156 = load i32, ptr %has1, align 4
  %48 = icmp ne i32 %has156, 0
  br i1 %48, label %if.then57, label %if.else

if.then57:                                        ; preds = %div.ok49
  %sb59 = load ptr, ptr %sb, align 8
  %alpha60 = load ptr, ptr %alpha, align 8
  %triple61 = load i32, ptr %triple, align 4
  %49 = icmp eq i32 %triple61, -2147483648
  %50 = and i1 %49, false
  %51 = or i1 false, %50
  br i1 %51, label %div.bad62, label %div.ok63

if.else:                                          ; preds = %div.ok49
  %sb74 = load ptr, ptr %sb, align 8
  %52 = call ptr @StringBuilder.appendChar(ptr %sb74, i32 61)
  br label %if.end58

if.end58:                                         ; preds = %if.else, %div.ok67
  %has275 = load i32, ptr %has2, align 4
  %53 = icmp ne i32 %has275, 0
  br i1 %53, label %if.then76, label %if.else77

div.bad62:                                        ; preds = %if.then57
  %exc64 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc64)
  store ptr %exc64, ptr %exc.thrown65, align 8
  call void @_CxxThrowException(ptr %exc.thrown65, ptr @_TI1PEAX)
  unreachable

div.ok63:                                         ; preds = %if.then57
  %54 = sdiv i32 %triple61, 64
  %55 = icmp eq i32 %54, -2147483648
  %56 = and i1 %55, false
  %57 = or i1 false, %56
  br i1 %57, label %div.bad66, label %div.ok67

div.bad66:                                        ; preds = %div.ok63
  %exc68 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc68)
  store ptr %exc68, ptr %exc.thrown69, align 8
  call void @_CxxThrowException(ptr %exc.thrown69, ptr @_TI1PEAX)
  unreachable

div.ok67:                                         ; preds = %div.ok63
  %58 = srem i32 %54, 64
  %59 = sext i32 %58 to i64
  %str.data70 = getelementptr inbounds %String, ptr %alpha60, i32 0, i32 1
  %data71 = load ptr, ptr %str.data70, align 8
  %ch.addr72 = getelementptr i8, ptr %data71, i64 %59
  %ch73 = load i8, ptr %ch.addr72, align 1
  %60 = zext i8 %ch73 to i32
  %61 = call ptr @StringBuilder.appendChar(ptr %sb59, i32 %60)
  br label %if.end58

if.then76:                                        ; preds = %if.end58
  %sb79 = load ptr, ptr %sb, align 8
  %alpha80 = load ptr, ptr %alpha, align 8
  %triple81 = load i32, ptr %triple, align 4
  %62 = icmp eq i32 %triple81, -2147483648
  %63 = and i1 %62, false
  %64 = or i1 false, %63
  br i1 %64, label %div.bad82, label %div.ok83

if.else77:                                        ; preds = %if.end58
  %sb90 = load ptr, ptr %sb, align 8
  %65 = call ptr @StringBuilder.appendChar(ptr %sb90, i32 61)
  br label %if.end78

if.end78:                                         ; preds = %if.else77, %div.ok83
  %i91 = load i32, ptr %i, align 4
  %66 = add i32 %i91, 3
  store i32 %66, ptr %i, align 4
  br label %while.cond

div.bad82:                                        ; preds = %if.then76
  %exc84 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc84)
  store ptr %exc84, ptr %exc.thrown85, align 8
  call void @_CxxThrowException(ptr %exc.thrown85, ptr @_TI1PEAX)
  unreachable

div.ok83:                                         ; preds = %if.then76
  %67 = srem i32 %triple81, 64
  %68 = sext i32 %67 to i64
  %str.data86 = getelementptr inbounds %String, ptr %alpha80, i32 0, i32 1
  %data87 = load ptr, ptr %str.data86, align 8
  %ch.addr88 = getelementptr i8, ptr %data87, i64 %68
  %ch89 = load i8, ptr %ch.addr88, align 1
  %69 = zext i8 %ch89 to i32
  %70 = call ptr @StringBuilder.appendChar(ptr %sb79, i32 %69)
  br label %if.end78
}

define internal ptr @Base64.decode(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown60 = alloca ptr, align 8
  %exc.thrown46 = alloca ptr, align 8
  %exc.thrown42 = alloca ptr, align 8
  %exc.thrown30 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %triple = alloca i32, align 4
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  %data1 = load ptr, ptr %data, align 8
  %str.len = getelementptr inbounds %String, ptr %data1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end54, %entry
  %i2 = load i32, ptr %i, align 4
  %2 = add i32 %i2, 3
  %n3 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %2, %n3
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %data4 = load ptr, ptr %data, align 8
  %i5 = load i32, ptr %i, align 4
  %5 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %data4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data6, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = call i32 @Base64.val(i32 %6)
  %8 = mul i32 %7, 262144
  %data7 = load ptr, ptr %data, align 8
  %i8 = load i32, ptr %i, align 4
  %9 = add i32 %i8, 1
  %10 = sext i32 %9 to i64
  %str.data9 = getelementptr inbounds %String, ptr %data7, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %ch.addr11 = getelementptr i8, ptr %data10, i64 %10
  %ch12 = load i8, ptr %ch.addr11, align 1
  %11 = zext i8 %ch12 to i32
  %12 = call i32 @Base64.val(i32 %11)
  %13 = mul i32 %12, 4096
  %14 = add i32 %8, %13
  %data13 = load ptr, ptr %data, align 8
  %i14 = load i32, ptr %i, align 4
  %15 = add i32 %i14, 2
  %16 = sext i32 %15 to i64
  %str.data15 = getelementptr inbounds %String, ptr %data13, i32 0, i32 1
  %data16 = load ptr, ptr %str.data15, align 8
  %ch.addr17 = getelementptr i8, ptr %data16, i64 %16
  %ch18 = load i8, ptr %ch.addr17, align 1
  %17 = zext i8 %ch18 to i32
  %18 = call i32 @Base64.val(i32 %17)
  %19 = mul i32 %18, 64
  %20 = add i32 %14, %19
  %data19 = load ptr, ptr %data, align 8
  %i20 = load i32, ptr %i, align 4
  %21 = add i32 %i20, 3
  %22 = sext i32 %21 to i64
  %str.data21 = getelementptr inbounds %String, ptr %data19, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %ch.addr23 = getelementptr i8, ptr %data22, i64 %22
  %ch24 = load i8, ptr %ch.addr23, align 1
  %23 = zext i8 %ch24 to i32
  %24 = call i32 @Base64.val(i32 %23)
  %25 = add i32 %20, %24
  store i32 %25, ptr %triple, align 4
  %sb25 = load ptr, ptr %sb, align 8
  %triple26 = load i32, ptr %triple, align 4
  %26 = icmp eq i32 %triple26, -2147483648
  %27 = and i1 %26, false
  %28 = or i1 false, %27
  br i1 %28, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  %sb62 = load ptr, ptr %sb, align 8
  %29 = call ptr @StringBuilder.toString(ptr %sb62)
  %strcpy = call ptr @__polaron_str_copy(ptr %29)
  call void @__polaron_str_free(ptr %29)
  ret ptr %strcpy

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %30 = sdiv i32 %triple26, 65536
  %31 = icmp eq i32 %30, -2147483648
  %32 = and i1 %31, false
  %33 = or i1 false, %32
  br i1 %33, label %div.bad27, label %div.ok28

div.bad27:                                        ; preds = %div.ok
  %exc29 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc29)
  store ptr %exc29, ptr %exc.thrown30, align 8
  call void @_CxxThrowException(ptr %exc.thrown30, ptr @_TI1PEAX)
  unreachable

div.ok28:                                         ; preds = %div.ok
  %34 = srem i32 %30, 256
  %35 = call ptr @StringBuilder.appendChar(ptr %sb25, i32 %34)
  %data31 = load ptr, ptr %data, align 8
  %i32 = load i32, ptr %i, align 4
  %36 = add i32 %i32, 2
  %37 = sext i32 %36 to i64
  %str.data33 = getelementptr inbounds %String, ptr %data31, i32 0, i32 1
  %data34 = load ptr, ptr %str.data33, align 8
  %ch.addr35 = getelementptr i8, ptr %data34, i64 %37
  %ch36 = load i8, ptr %ch.addr35, align 1
  %38 = zext i8 %ch36 to i32
  %39 = icmp ne i32 %38, 61
  %40 = zext i1 %39 to i32
  br i1 %39, label %if.then, label %if.end

if.then:                                          ; preds = %div.ok28
  %sb37 = load ptr, ptr %sb, align 8
  %triple38 = load i32, ptr %triple, align 4
  %41 = icmp eq i32 %triple38, -2147483648
  %42 = and i1 %41, false
  %43 = or i1 false, %42
  br i1 %43, label %div.bad39, label %div.ok40

if.end:                                           ; preds = %div.ok44, %div.ok28
  %data47 = load ptr, ptr %data, align 8
  %i48 = load i32, ptr %i, align 4
  %44 = add i32 %i48, 3
  %45 = sext i32 %44 to i64
  %str.data49 = getelementptr inbounds %String, ptr %data47, i32 0, i32 1
  %data50 = load ptr, ptr %str.data49, align 8
  %ch.addr51 = getelementptr i8, ptr %data50, i64 %45
  %ch52 = load i8, ptr %ch.addr51, align 1
  %46 = zext i8 %ch52 to i32
  %47 = icmp ne i32 %46, 61
  %48 = zext i1 %47 to i32
  br i1 %47, label %if.then53, label %if.end54

div.bad39:                                        ; preds = %if.then
  %exc41 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc41)
  store ptr %exc41, ptr %exc.thrown42, align 8
  call void @_CxxThrowException(ptr %exc.thrown42, ptr @_TI1PEAX)
  unreachable

div.ok40:                                         ; preds = %if.then
  %49 = sdiv i32 %triple38, 256
  %50 = icmp eq i32 %49, -2147483648
  %51 = and i1 %50, false
  %52 = or i1 false, %51
  br i1 %52, label %div.bad43, label %div.ok44

div.bad43:                                        ; preds = %div.ok40
  %exc45 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc45)
  store ptr %exc45, ptr %exc.thrown46, align 8
  call void @_CxxThrowException(ptr %exc.thrown46, ptr @_TI1PEAX)
  unreachable

div.ok44:                                         ; preds = %div.ok40
  %53 = srem i32 %49, 256
  %54 = call ptr @StringBuilder.appendChar(ptr %sb37, i32 %53)
  br label %if.end

if.then53:                                        ; preds = %if.end
  %sb55 = load ptr, ptr %sb, align 8
  %triple56 = load i32, ptr %triple, align 4
  %55 = icmp eq i32 %triple56, -2147483648
  %56 = and i1 %55, false
  %57 = or i1 false, %56
  br i1 %57, label %div.bad57, label %div.ok58

if.end54:                                         ; preds = %div.ok58, %if.end
  %i61 = load i32, ptr %i, align 4
  %58 = add i32 %i61, 4
  store i32 %58, ptr %i, align 4
  br label %while.cond

div.bad57:                                        ; preds = %if.then53
  %exc59 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc59)
  store ptr %exc59, ptr %exc.thrown60, align 8
  call void @_CxxThrowException(ptr %exc.thrown60, ptr @_TI1PEAX)
  unreachable

div.ok58:                                         ; preds = %if.then53
  %59 = srem i32 %triple56, 256
  %60 = call ptr @StringBuilder.appendChar(ptr %sb55, i32 %59)
  br label %if.end54
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5316)
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
