; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/slug_inflect.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/slug_inflect.pol"
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
@.str = private unnamed_addr constant [13 x i8] c"s1=%s s2=%s\0A\00", align 1
@.strdata = private constant [14 x i8] c"Hello, World!\00"
@.strobj = private global %String { i64 13, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [27 x i8] c"  Polaron -- Rocks 2026!  \00"
@.strobj.2 = private global %String { i64 26, ptr @.strdata.1, i64 0 }
@.str.3 = private unnamed_addr constant [18 x i8] c"p=%s,%s,%s,%s,%s\0A\00", align 1
@.strdata.4 = private constant [4 x i8] c"cat\00"
@.strobj.5 = private global %String { i64 3, ptr @.strdata.4, i64 0 }
@.strdata.6 = private constant [4 x i8] c"bus\00"
@.strobj.7 = private global %String { i64 3, ptr @.strdata.6, i64 0 }
@.strdata.8 = private constant [6 x i8] c"party\00"
@.strobj.9 = private global %String { i64 5, ptr @.strdata.8, i64 0 }
@.strdata.10 = private constant [4 x i8] c"box\00"
@.strobj.11 = private global %String { i64 3, ptr @.strdata.10, i64 0 }
@.strdata.12 = private constant [4 x i8] c"day\00"
@.strobj.13 = private global %String { i64 3, ptr @.strdata.12, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1319 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1320 = private global %String { i64 16, ptr @.strdata.1319, i64 0 }
@.strdata.1321 = private constant [17 x i8] c"division by zero\00"
@.strobj.1322 = private global %String { i64 16, ptr @.strdata.1321, i64 0 }
@.strdata.2567 = private constant [2 x i8] c"s\00"
@.strobj.2568 = private global %String { i64 1, ptr @.strdata.2567, i64 0 }
@.strdata.2569 = private constant [2 x i8] c"x\00"
@.strobj.2570 = private global %String { i64 1, ptr @.strdata.2569, i64 0 }
@.strdata.2571 = private constant [2 x i8] c"z\00"
@.strobj.2572 = private global %String { i64 1, ptr @.strdata.2571, i64 0 }
@.strdata.2573 = private constant [3 x i8] c"ch\00"
@.strobj.2574 = private global %String { i64 2, ptr @.strdata.2573, i64 0 }
@.strdata.2575 = private constant [3 x i8] c"sh\00"
@.strobj.2576 = private global %String { i64 2, ptr @.strdata.2575, i64 0 }
@.strdata.2577 = private constant [3 x i8] c"es\00"
@.strobj.2578 = private global %String { i64 2, ptr @.strdata.2577, i64 0 }
@.strdata.2579 = private constant [4 x i8] c"ies\00"
@.strobj.2580 = private global %String { i64 3, ptr @.strdata.2579, i64 0 }
@.strdata.2581 = private constant [2 x i8] c"s\00"
@.strobj.2582 = private global %String { i64 1, ptr @.strdata.2581, i64 0 }
@.strdata.5320 = private constant [1 x i8] zeroinitializer
@.strobj.5321 = private global %String { i64 0, ptr @.strdata.5320, i64 0 }
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }

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
  %16 = call ptr @Slugify.make(ptr @.strobj)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %17 = call ptr @Slugify.make(ptr @.strobj.2)
  %str.data1 = getelementptr inbounds %String, ptr %17, i32 0, i32 1
  %data2 = load ptr, ptr %str.data1, align 8
  %18 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, ptr %data2)
  call void @__polaron_str_free(ptr %16)
  call void @__polaron_str_free(ptr %17)
  %19 = call ptr @Inflector.pluralize(ptr @.strobj.5)
  %str.data3 = getelementptr inbounds %String, ptr %19, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %20 = call ptr @Inflector.pluralize(ptr @.strobj.7)
  %str.data5 = getelementptr inbounds %String, ptr %20, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %21 = call ptr @Inflector.pluralize(ptr @.strobj.9)
  %str.data7 = getelementptr inbounds %String, ptr %21, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %22 = call ptr @Inflector.pluralize(ptr @.strobj.11)
  %str.data9 = getelementptr inbounds %String, ptr %22, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %23 = call ptr @Inflector.pluralize(ptr @.strobj.13)
  %str.data11 = getelementptr inbounds %String, ptr %23, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %24 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr %data4, ptr %data6, ptr %data8, ptr %data10, ptr %data12)
  call void @__polaron_str_free(ptr %19)
  call void @__polaron_str_free(ptr %20)
  call void @__polaron_str_free(ptr %21)
  call void @__polaron_str_free(ptr %22)
  call void @__polaron_str_free(ptr %23)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1320)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1322)
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

define internal ptr @Slugify.make(ptr %0) {
entry:
  %lc = alloca i32, align 4
  %alnum = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %pendingDash = alloca i32, align 4
  %sb = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %pendingDash, align 4
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
  %s3 = load ptr, ptr %s, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %c, align 4
  %c5 = load i32, ptr %c, align 4
  %6 = icmp sge i32 %c5, 48
  %7 = zext i1 %6 to i32
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

for.update:                                       ; preds = %if.end30
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb43 = load ptr, ptr %sb, align 8
  %10 = call ptr @StringBuilder.toString(ptr %sb43)
  %strcpy = call ptr @__polaron_str_copy(ptr %10)
  call void @__polaron_str_free(ptr %10)
  ret ptr %strcpy

sc.rhs:                                           ; preds = %for.body
  %c6 = load i32, ptr %c, align 4
  %11 = icmp sle i32 %c6, 57
  %12 = zext i1 %11 to i32
  %sc.b = icmp ne i32 %12, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %for.body
  %sc = phi i1 [ false, %for.body ], [ %sc.b, %sc.rhs ]
  %13 = zext i1 %sc to i32
  %sc.a7 = icmp ne i32 %13, 0
  br i1 %sc.a7, label %sc.end9, label %sc.rhs8

sc.rhs8:                                          ; preds = %sc.end
  %c10 = load i32, ptr %c, align 4
  %14 = icmp sge i32 %c10, 97
  %15 = zext i1 %14 to i32
  %sc.a11 = icmp ne i32 %15, 0
  br i1 %sc.a11, label %sc.rhs12, label %sc.end13

sc.end9:                                          ; preds = %sc.end13, %sc.end
  %sc18 = phi i1 [ true, %sc.end ], [ %sc.b17, %sc.end13 ]
  %16 = zext i1 %sc18 to i32
  store i32 %16, ptr %alnum, align 4
  %c19 = load i32, ptr %c, align 4
  store i32 %c19, ptr %lc, align 4
  %c20 = load i32, ptr %c, align 4
  %17 = icmp sge i32 %c20, 65
  %18 = zext i1 %17 to i32
  %sc.a21 = icmp ne i32 %18, 0
  br i1 %sc.a21, label %sc.rhs22, label %sc.end23

sc.rhs12:                                         ; preds = %sc.rhs8
  %c14 = load i32, ptr %c, align 4
  %19 = icmp sle i32 %c14, 122
  %20 = zext i1 %19 to i32
  %sc.b15 = icmp ne i32 %20, 0
  br label %sc.end13

sc.end13:                                         ; preds = %sc.rhs12, %sc.rhs8
  %sc16 = phi i1 [ false, %sc.rhs8 ], [ %sc.b15, %sc.rhs12 ]
  %21 = zext i1 %sc16 to i32
  %sc.b17 = icmp ne i32 %21, 0
  br label %sc.end9

sc.rhs22:                                         ; preds = %sc.end9
  %c24 = load i32, ptr %c, align 4
  %22 = icmp sle i32 %c24, 90
  %23 = zext i1 %22 to i32
  %sc.b25 = icmp ne i32 %23, 0
  br label %sc.end23

sc.end23:                                         ; preds = %sc.rhs22, %sc.end9
  %sc26 = phi i1 [ false, %sc.end9 ], [ %sc.b25, %sc.rhs22 ]
  %24 = zext i1 %sc26 to i32
  br i1 %sc26, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end23
  %c27 = load i32, ptr %c, align 4
  %25 = add i32 %c27, 32
  store i32 %25, ptr %lc, align 4
  store i32 1, ptr %alnum, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end23
  %alnum28 = load i32, ptr %alnum, align 4
  %26 = icmp ne i32 %alnum28, 0
  br i1 %26, label %if.then29, label %if.else

if.then29:                                        ; preds = %if.end
  %pendingDash31 = load i32, ptr %pendingDash, align 4
  %sc.a32 = icmp ne i32 %pendingDash31, 0
  br i1 %sc.a32, label %sc.rhs33, label %sc.end34

if.else:                                          ; preds = %if.end
  store i32 1, ptr %pendingDash, align 4
  br label %if.end30

if.end30:                                         ; preds = %if.else, %if.end39
  br label %for.update

sc.rhs33:                                         ; preds = %if.then29
  %sb35 = load ptr, ptr %sb, align 8
  %27 = call i32 @StringBuilder.length(ptr %sb35)
  %28 = icmp sgt i32 %27, 0
  %29 = zext i1 %28 to i32
  %sc.b36 = icmp ne i32 %29, 0
  br label %sc.end34

sc.end34:                                         ; preds = %sc.rhs33, %if.then29
  %sc37 = phi i1 [ false, %if.then29 ], [ %sc.b36, %sc.rhs33 ]
  %30 = zext i1 %sc37 to i32
  br i1 %sc37, label %if.then38, label %if.end39

if.then38:                                        ; preds = %sc.end34
  %sb40 = load ptr, ptr %sb, align 8
  %31 = call ptr @StringBuilder.appendChar(ptr %sb40, i32 45)
  br label %if.end39

if.end39:                                         ; preds = %if.then38, %sc.end34
  store i32 0, ptr %pendingDash, align 4
  %sb41 = load ptr, ptr %sb, align 8
  %lc42 = load i32, ptr %lc, align 4
  %32 = call ptr @StringBuilder.appendChar(ptr %sb41, i32 %lc42)
  br label %if.end30
}

define internal i32 @Inflector.endsWith(ptr %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  %suf = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  store ptr %1, ptr %suf, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %suf2 = load ptr, ptr %suf, align 8
  %str.len3 = getelementptr inbounds %String, ptr %suf2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %m, align 4
  %m5 = load i32, ptr %m, align 4
  %n6 = load i32, ptr %n, align 4
  %4 = icmp sgt i32 %m5, %n6
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i7 = load i32, ptr %i, align 4
  %m8 = load i32, ptr %m, align 4
  %6 = icmp slt i32 %i7, %m8
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s9 = load ptr, ptr %s, align 8
  %n10 = load i32, ptr %n, align 4
  %m11 = load i32, ptr %m, align 4
  %8 = sub i32 %n10, %m11
  %i12 = load i32, ptr %i, align 4
  %9 = add i32 %8, %i12
  %10 = sext i32 %9 to i64
  %str.data = getelementptr inbounds %String, ptr %s9, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %10
  %ch = load i8, ptr %ch.addr, align 1
  %11 = zext i8 %ch to i32
  %suf13 = load ptr, ptr %suf, align 8
  %i14 = load i32, ptr %i, align 4
  %12 = sext i32 %i14 to i64
  %str.data15 = getelementptr inbounds %String, ptr %suf13, i32 0, i32 1
  %data16 = load ptr, ptr %str.data15, align 8
  %ch.addr17 = getelementptr i8, ptr %data16, i64 %12
  %ch18 = load i8, ptr %ch.addr17, align 1
  %13 = zext i8 %ch18 to i32
  %14 = icmp ne i32 %11, %13
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then19, label %if.end20

for.update:                                       ; preds = %if.end20
  %16 = load i32, ptr %i, align 4
  %17 = add i32 %16, 1
  store i32 %17, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 1

if.then19:                                        ; preds = %for.body
  ret i32 0

if.end20:                                         ; preds = %for.body
  br label %for.update
}

define internal ptr @Inflector.pluralize(ptr %0) {
entry:
  %b = alloca i32, align 4
  %vowelBefore = alloca i32, align 4
  %last = alloca i32, align 4
  %n = alloca i32, align 4
  %w = alloca ptr, align 8
  store ptr %0, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %str.len = getelementptr inbounds %String, ptr %w1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  %2 = icmp eq i32 %n2, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %w3 = load ptr, ptr %w, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %w3)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %w4 = load ptr, ptr %w, align 8
  %n5 = load i32, ptr %n, align 4
  %4 = sub i32 %n5, 1
  %5 = sext i32 %4 to i64
  %str.data = getelementptr inbounds %String, ptr %w4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  store i32 %6, ptr %last, align 4
  %w6 = load ptr, ptr %w, align 8
  %7 = call i32 @Inflector.endsWith(ptr %w6, ptr @.strobj.2568)
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %if.end
  %w7 = load ptr, ptr %w, align 8
  %8 = call i32 @Inflector.endsWith(ptr %w7, ptr @.strobj.2570)
  %sc.b = icmp ne i32 %8, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %if.end
  %sc = phi i1 [ true, %if.end ], [ %sc.b, %sc.rhs ]
  %9 = zext i1 %sc to i32
  %sc.a8 = icmp ne i32 %9, 0
  br i1 %sc.a8, label %sc.end10, label %sc.rhs9

sc.rhs9:                                          ; preds = %sc.end
  %w11 = load ptr, ptr %w, align 8
  %10 = call i32 @Inflector.endsWith(ptr %w11, ptr @.strobj.2572)
  %sc.b12 = icmp ne i32 %10, 0
  br label %sc.end10

sc.end10:                                         ; preds = %sc.rhs9, %sc.end
  %sc13 = phi i1 [ true, %sc.end ], [ %sc.b12, %sc.rhs9 ]
  %11 = zext i1 %sc13 to i32
  %sc.a14 = icmp ne i32 %11, 0
  br i1 %sc.a14, label %sc.end16, label %sc.rhs15

sc.rhs15:                                         ; preds = %sc.end10
  %w17 = load ptr, ptr %w, align 8
  %12 = call i32 @Inflector.endsWith(ptr %w17, ptr @.strobj.2574)
  %sc.b18 = icmp ne i32 %12, 0
  br label %sc.end16

sc.end16:                                         ; preds = %sc.rhs15, %sc.end10
  %sc19 = phi i1 [ true, %sc.end10 ], [ %sc.b18, %sc.rhs15 ]
  %13 = zext i1 %sc19 to i32
  %sc.a20 = icmp ne i32 %13, 0
  br i1 %sc.a20, label %sc.end22, label %sc.rhs21

sc.rhs21:                                         ; preds = %sc.end16
  %w23 = load ptr, ptr %w, align 8
  %14 = call i32 @Inflector.endsWith(ptr %w23, ptr @.strobj.2576)
  %sc.b24 = icmp ne i32 %14, 0
  br label %sc.end22

sc.end22:                                         ; preds = %sc.rhs21, %sc.end16
  %sc25 = phi i1 [ true, %sc.end16 ], [ %sc.b24, %sc.rhs21 ]
  %15 = zext i1 %sc25 to i32
  br i1 %sc25, label %if.then26, label %if.end27

if.then26:                                        ; preds = %sc.end22
  %w28 = load ptr, ptr %w, align 8
  %str.len29 = getelementptr inbounds %String, ptr %w28, i32 0, i32 0
  %len30 = load i64, ptr %str.len29, align 8
  %len31 = load i64, ptr @.strobj.2578, align 8
  %16 = add i64 %len30, %len31
  %17 = add i64 %16, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %17)
  %str.data32 = getelementptr inbounds %String, ptr %w28, i32 0, i32 1
  %data33 = load ptr, ptr %str.data32, align 8
  %18 = call ptr @memcpy(ptr %cat.buf, ptr %data33, i64 %len30)
  %data34 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2578, i32 0, i32 1), align 8
  %19 = getelementptr i8, ptr %cat.buf, i64 %len30
  %20 = call ptr @memcpy(ptr %19, ptr %data34, i64 %len31)
  %21 = getelementptr i8, ptr %cat.buf, i64 %16
  store i8 0, ptr %21, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %22 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %16, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %23, align 8
  %24 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %24, align 8
  %strcpy35 = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy35

if.end27:                                         ; preds = %sc.end22
  %last36 = load i32, ptr %last, align 4
  %25 = icmp eq i32 %last36, 121
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then37, label %if.end38

if.then37:                                        ; preds = %if.end27
  store i32 0, ptr %vowelBefore, align 4
  %n39 = load i32, ptr %n, align 4
  %27 = icmp sge i32 %n39, 2
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then40, label %if.end41

if.end38:                                         ; preds = %if.end77, %if.end27
  %w92 = load ptr, ptr %w, align 8
  %str.len93 = getelementptr inbounds %String, ptr %w92, i32 0, i32 0
  %len94 = load i64, ptr %str.len93, align 8
  %len95 = load i64, ptr @.strobj.2582, align 8
  %29 = add i64 %len94, %len95
  %30 = add i64 %29, 1
  %cat.buf96 = call ptr @__polaron_malloc(i64 %30)
  %str.data97 = getelementptr inbounds %String, ptr %w92, i32 0, i32 1
  %data98 = load ptr, ptr %str.data97, align 8
  %31 = call ptr @memcpy(ptr %cat.buf96, ptr %data98, i64 %len94)
  %data99 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2582, i32 0, i32 1), align 8
  %32 = getelementptr i8, ptr %cat.buf96, i64 %len94
  %33 = call ptr @memcpy(ptr %32, ptr %data99, i64 %len95)
  %34 = getelementptr i8, ptr %cat.buf96, i64 %29
  store i8 0, ptr %34, align 1
  %newstr100 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr100, i32 0, i32 0
  store i64 %29, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr100, i32 0, i32 1
  store ptr %cat.buf96, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr100, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %strcpy101 = call ptr @__polaron_str_copy(ptr %newstr100)
  call void @__polaron_str_free(ptr %newstr100)
  ret ptr %strcpy101

if.then40:                                        ; preds = %if.then37
  %w42 = load ptr, ptr %w, align 8
  %n43 = load i32, ptr %n, align 4
  %38 = sub i32 %n43, 2
  %39 = sext i32 %38 to i64
  %str.data44 = getelementptr inbounds %String, ptr %w42, i32 0, i32 1
  %data45 = load ptr, ptr %str.data44, align 8
  %ch.addr46 = getelementptr i8, ptr %data45, i64 %39
  %ch47 = load i8, ptr %ch.addr46, align 1
  %40 = zext i8 %ch47 to i32
  store i32 %40, ptr %b, align 4
  %b48 = load i32, ptr %b, align 4
  %41 = icmp eq i32 %b48, 97
  %42 = zext i1 %41 to i32
  %sc.a49 = icmp ne i32 %42, 0
  br i1 %sc.a49, label %sc.end51, label %sc.rhs50

if.end41:                                         ; preds = %if.end74, %if.then37
  %vowelBefore75 = load i32, ptr %vowelBefore, align 4
  %43 = icmp eq i32 %vowelBefore75, 0
  %44 = zext i1 %43 to i32
  br i1 %43, label %if.then76, label %if.end77

sc.rhs50:                                         ; preds = %if.then40
  %b52 = load i32, ptr %b, align 4
  %45 = icmp eq i32 %b52, 101
  %46 = zext i1 %45 to i32
  %sc.b53 = icmp ne i32 %46, 0
  br label %sc.end51

sc.end51:                                         ; preds = %sc.rhs50, %if.then40
  %sc54 = phi i1 [ true, %if.then40 ], [ %sc.b53, %sc.rhs50 ]
  %47 = zext i1 %sc54 to i32
  %sc.a55 = icmp ne i32 %47, 0
  br i1 %sc.a55, label %sc.end57, label %sc.rhs56

sc.rhs56:                                         ; preds = %sc.end51
  %b58 = load i32, ptr %b, align 4
  %48 = icmp eq i32 %b58, 105
  %49 = zext i1 %48 to i32
  %sc.b59 = icmp ne i32 %49, 0
  br label %sc.end57

sc.end57:                                         ; preds = %sc.rhs56, %sc.end51
  %sc60 = phi i1 [ true, %sc.end51 ], [ %sc.b59, %sc.rhs56 ]
  %50 = zext i1 %sc60 to i32
  %sc.a61 = icmp ne i32 %50, 0
  br i1 %sc.a61, label %sc.end63, label %sc.rhs62

sc.rhs62:                                         ; preds = %sc.end57
  %b64 = load i32, ptr %b, align 4
  %51 = icmp eq i32 %b64, 111
  %52 = zext i1 %51 to i32
  %sc.b65 = icmp ne i32 %52, 0
  br label %sc.end63

sc.end63:                                         ; preds = %sc.rhs62, %sc.end57
  %sc66 = phi i1 [ true, %sc.end57 ], [ %sc.b65, %sc.rhs62 ]
  %53 = zext i1 %sc66 to i32
  %sc.a67 = icmp ne i32 %53, 0
  br i1 %sc.a67, label %sc.end69, label %sc.rhs68

sc.rhs68:                                         ; preds = %sc.end63
  %b70 = load i32, ptr %b, align 4
  %54 = icmp eq i32 %b70, 117
  %55 = zext i1 %54 to i32
  %sc.b71 = icmp ne i32 %55, 0
  br label %sc.end69

sc.end69:                                         ; preds = %sc.rhs68, %sc.end63
  %sc72 = phi i1 [ true, %sc.end63 ], [ %sc.b71, %sc.rhs68 ]
  %56 = zext i1 %sc72 to i32
  br i1 %sc72, label %if.then73, label %if.end74

if.then73:                                        ; preds = %sc.end69
  store i32 1, ptr %vowelBefore, align 4
  br label %if.end74

if.end74:                                         ; preds = %if.then73, %sc.end69
  br label %if.end41

if.then76:                                        ; preds = %if.end41
  %w78 = load ptr, ptr %w, align 8
  %n79 = load i32, ptr %n, align 4
  %57 = sub i32 %n79, 1
  %58 = sext i32 %57 to i64
  %59 = sub i64 %58, 0
  %60 = add i64 %59, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %60)
  %str.data80 = getelementptr inbounds %String, ptr %w78, i32 0, i32 1
  %data81 = load ptr, ptr %str.data80, align 8
  %61 = getelementptr i8, ptr %data81, i64 0
  %62 = call ptr @memcpy(ptr %sub.buf, ptr %61, i64 %59)
  %63 = getelementptr i8, ptr %sub.buf, i64 %59
  store i8 0, ptr %63, align 1
  %newstr82 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %64 = getelementptr inbounds %String, ptr %newstr82, i32 0, i32 0
  store i64 %59, ptr %64, align 8
  %65 = getelementptr inbounds %String, ptr %newstr82, i32 0, i32 1
  store ptr %sub.buf, ptr %65, align 8
  %66 = getelementptr inbounds %String, ptr %newstr82, i32 0, i32 2
  store i64 0, ptr %66, align 8
  %str.len83 = getelementptr inbounds %String, ptr %newstr82, i32 0, i32 0
  %len84 = load i64, ptr %str.len83, align 8
  %len85 = load i64, ptr @.strobj.2580, align 8
  %67 = add i64 %len84, %len85
  %68 = add i64 %67, 1
  %cat.buf86 = call ptr @__polaron_malloc(i64 %68)
  %str.data87 = getelementptr inbounds %String, ptr %newstr82, i32 0, i32 1
  %data88 = load ptr, ptr %str.data87, align 8
  %69 = call ptr @memcpy(ptr %cat.buf86, ptr %data88, i64 %len84)
  %data89 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2580, i32 0, i32 1), align 8
  %70 = getelementptr i8, ptr %cat.buf86, i64 %len84
  %71 = call ptr @memcpy(ptr %70, ptr %data89, i64 %len85)
  %72 = getelementptr i8, ptr %cat.buf86, i64 %67
  store i8 0, ptr %72, align 1
  %newstr90 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %73 = getelementptr inbounds %String, ptr %newstr90, i32 0, i32 0
  store i64 %67, ptr %73, align 8
  %74 = getelementptr inbounds %String, ptr %newstr90, i32 0, i32 1
  store ptr %cat.buf86, ptr %74, align 8
  %75 = getelementptr inbounds %String, ptr %newstr90, i32 0, i32 2
  store i64 0, ptr %75, align 8
  %strcpy91 = call ptr @__polaron_str_copy(ptr %newstr90)
  call void @__polaron_str_free(ptr %newstr82)
  call void @__polaron_str_free(ptr %newstr90)
  ret ptr %strcpy91

if.end77:                                         ; preds = %if.end41
  br label %if.end38
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5321)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5323)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
