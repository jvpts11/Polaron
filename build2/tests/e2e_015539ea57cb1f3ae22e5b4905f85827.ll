; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/rle_calc.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/rle_calc.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Calculator = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Calculator.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr @Calculator.peek, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Calculator.skip, ptr @Calculator.factor, ptr @Calculator.term, ptr @Calculator.expr, ptr @Calculator.evaluate, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@.strdata = private constant [9 x i8] c"aaabbbbc\00"
@.strobj = private global %String { i64 8, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [10 x i8] c"2 + 3 * 4\00"
@.strobj.2 = private global %String { i64 9, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [12 x i8] c"(2 + 3) * 4\00"
@.strobj.4 = private global %String { i64 11, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [16 x i8] c"100 - 6 * 7 + 2\00"
@.strobj.6 = private global %String { i64 15, ptr @.strdata.5, i64 0 }
@.str = private unnamed_addr constant [29 x i8] c"enc=%s rt=%d a=%d b=%d c=%d\0A\00", align 1
@.strdata.7 = private constant [9 x i8] c"aaabbbbc\00"
@.strobj.8 = private global %String { i64 8, ptr @.strdata.7, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1314 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1315 = private global %String { i64 16, ptr @.strdata.1314, i64 0 }
@.strdata.1316 = private constant [17 x i8] c"division by zero\00"
@.strobj.1317 = private global %String { i64 16, ptr @.strdata.1316, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca ptr, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %enc = alloca ptr, align 8
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
  %16 = call ptr @Rle.encode(ptr @.strobj)
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  store ptr %strcpy, ptr %enc, align 8
  call void @__polaron_str_free(ptr %16)
  %Calculator.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Calculator, ptr null, i64 1) to i64))
  call void @Calculator.Calculator(ptr %Calculator.obj, ptr @.strobj.2)
  store ptr %Calculator.obj, ptr %a, align 8
  %Calculator.obj1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Calculator, ptr null, i64 1) to i64))
  call void @Calculator.Calculator(ptr %Calculator.obj1, ptr @.strobj.4)
  store ptr %Calculator.obj1, ptr %b, align 8
  %Calculator.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Calculator, ptr null, i64 1) to i64))
  call void @Calculator.Calculator(ptr %Calculator.obj2, ptr @.strobj.6)
  store ptr %Calculator.obj2, ptr %c, align 8
  %enc3 = load ptr, ptr %enc, align 8
  %str.data = getelementptr inbounds %String, ptr %enc3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %enc4 = load ptr, ptr %enc, align 8
  %17 = call ptr @Rle.decode(ptr %enc4)
  %str.data5 = getelementptr inbounds %String, ptr %17, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %data7 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.8, i32 0, i32 1), align 8
  %18 = call i32 @strcmp(ptr %data6, ptr %data7)
  %19 = icmp eq i32 %18, 0
  %20 = zext i1 %19 to i32
  %a8 = load ptr, ptr %a, align 8
  %21 = call i32 @Calculator.evaluate(ptr %a8)
  %b9 = load ptr, ptr %b, align 8
  %22 = call i32 @Calculator.evaluate(ptr %b9)
  %c10 = load ptr, ptr %c, align 8
  %23 = call i32 @Calculator.evaluate(ptr %c10)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, i32 %20, i32 %21, i32 %22, i32 %23)
  call void @__polaron_str_free(ptr %17)
  %25 = load ptr, ptr %enc, align 8
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1315)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1317)
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

define internal void @Calculator.Calculator(ptr %0, ptr %1) {
entry:
  %expr = alloca ptr, align 8
  store ptr %1, ptr %expr, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 0
  store ptr @Calculator.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %s = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 1
  store ptr null, ptr %s, align 8, !tbaa !0
  %s1 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 1
  %expr2 = load ptr, ptr %expr, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %expr2)
  %2 = load ptr, ptr %s1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %s1, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @Calculator.peek(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %s = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 1
  %s2 = load ptr, ptr %s, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %s3 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 1
  %s4 = load ptr, ptr %s3, align 8, !tbaa !0
  %pos5 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos6 = load i32, ptr %pos5, align 4, !tbaa !4
  %4 = sext i32 %pos6 to i64
  %str.data = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  ret i32 %5

if.end:                                           ; preds = %entry
  ret i32 0
}

define internal void @Calculator.skip(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %pos = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %s = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 1
  %s2 = load ptr, ptr %s, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %pos7 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos8 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos9 = load i32, ptr %pos8, align 4, !tbaa !4
  %4 = add i32 %pos9, 1
  store i32 %4, ptr %pos7, align 4, !tbaa !4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  ret void

sc.rhs:                                           ; preds = %while.cond
  %s3 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 1
  %s4 = load ptr, ptr %s3, align 8, !tbaa !0
  %pos5 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos6 = load i32, ptr %pos5, align 4, !tbaa !4
  %5 = sext i32 %pos6 to i64
  %str.data = getelementptr inbounds %String, ptr %s4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = icmp eq i32 %6, 32
  %8 = zext i1 %7 to i32
  %sc.b = icmp ne i32 %8, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %9 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end
}

define internal i32 @Calculator.factor(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %n = alloca i32, align 4
  %v = alloca i32, align 4
  call void @Calculator.skip(ptr %0)
  %1 = call i32 @Calculator.peek(ptr %0)
  %2 = icmp eq i32 %1, 40
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %pos = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos1 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos1, align 4, !tbaa !4
  %4 = add i32 %pos2, 1
  store i32 %4, ptr %pos, align 4, !tbaa !4
  %5 = call i32 @Calculator.expr(ptr %0)
  store i32 %5, ptr %v, align 4
  call void @Calculator.skip(ptr %0)
  %pos3 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %6 = add i32 %pos5, 1
  store i32 %6, ptr %pos3, align 4, !tbaa !4
  %v6 = load i32, ptr %v, align 4
  ret i32 %v6

if.end:                                           ; preds = %entry
  store i32 0, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %7 = call i32 @Calculator.peek(ptr %0)
  %8 = icmp sge i32 %7, 48
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %n7 = load i32, ptr %n, align 4
  %10 = mul i32 %n7, 10
  %11 = call i32 @Calculator.peek(ptr %0)
  %12 = sub i32 %11, 48
  %13 = add i32 %10, %12
  store i32 %13, ptr %n, align 4
  %pos8 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos9 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos10 = load i32, ptr %pos9, align 4, !tbaa !4
  %14 = add i32 %pos10, 1
  store i32 %14, ptr %pos8, align 4, !tbaa !4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %n11 = load i32, ptr %n, align 4
  ret i32 %n11

sc.rhs:                                           ; preds = %while.cond
  %15 = call i32 @Calculator.peek(ptr %0)
  %16 = icmp sle i32 %15, 57
  %17 = zext i1 %16 to i32
  %sc.b = icmp ne i32 %17, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %18 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end
}

define internal i32 @Calculator.term(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %r = alloca i32, align 4
  %op = alloca i32, align 4
  %v = alloca i32, align 4
  %1 = call i32 @Calculator.factor(ptr %0)
  store i32 %1, ptr %v, align 4
  call void @Calculator.skip(ptr %0)
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %2 = call i32 @Calculator.peek(ptr %0)
  %3 = icmp eq i32 %2, 42
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

while.body:                                       ; preds = %sc.end
  %5 = call i32 @Calculator.peek(ptr %0)
  store i32 %5, ptr %op, align 4
  %pos = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos1 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos1, align 4, !tbaa !4
  %6 = add i32 %pos2, 1
  store i32 %6, ptr %pos, align 4, !tbaa !4
  %7 = call i32 @Calculator.factor(ptr %0)
  store i32 %7, ptr %r, align 4
  call void @Calculator.skip(ptr %0)
  %op3 = load i32, ptr %op, align 4
  %8 = icmp eq i32 %op3, 42
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.else

while.end:                                        ; preds = %sc.end
  %v8 = load i32, ptr %v, align 4
  ret i32 %v8

sc.rhs:                                           ; preds = %while.cond
  %10 = call i32 @Calculator.peek(ptr %0)
  %11 = icmp eq i32 %10, 47
  %12 = zext i1 %11 to i32
  %sc.b = icmp ne i32 %12, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ true, %while.cond ], [ %sc.b, %sc.rhs ]
  %13 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

if.then:                                          ; preds = %while.body
  %v4 = load i32, ptr %v, align 4
  %r5 = load i32, ptr %r, align 4
  %14 = mul i32 %v4, %r5
  store i32 %14, ptr %v, align 4
  br label %if.end

if.else:                                          ; preds = %while.body
  %v6 = load i32, ptr %v, align 4
  %r7 = load i32, ptr %r, align 4
  %15 = icmp eq i32 %r7, 0
  %16 = icmp eq i32 %v6, -2147483648
  %17 = icmp eq i32 %r7, -1
  %18 = and i1 %16, %17
  %19 = or i1 %15, %18
  br i1 %19, label %div.bad, label %div.ok

if.end:                                           ; preds = %div.ok, %if.then
  br label %while.cond

div.bad:                                          ; preds = %if.else
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.else
  %20 = sdiv i32 %v6, %r7
  store i32 %20, ptr %v, align 4
  br label %if.end
}

define internal i32 @Calculator.expr(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %r = alloca i32, align 4
  %op = alloca i32, align 4
  %v = alloca i32, align 4
  %1 = call i32 @Calculator.term(ptr %0)
  store i32 %1, ptr %v, align 4
  call void @Calculator.skip(ptr %0)
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %2 = call i32 @Calculator.peek(ptr %0)
  %3 = icmp eq i32 %2, 43
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

while.body:                                       ; preds = %sc.end
  %5 = call i32 @Calculator.peek(ptr %0)
  store i32 %5, ptr %op, align 4
  %pos = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos1 = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos1, align 4, !tbaa !4
  %6 = add i32 %pos2, 1
  store i32 %6, ptr %pos, align 4, !tbaa !4
  %7 = call i32 @Calculator.term(ptr %0)
  store i32 %7, ptr %r, align 4
  call void @Calculator.skip(ptr %0)
  %op3 = load i32, ptr %op, align 4
  %8 = icmp eq i32 %op3, 43
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.else

while.end:                                        ; preds = %sc.end
  %v8 = load i32, ptr %v, align 4
  ret i32 %v8

sc.rhs:                                           ; preds = %while.cond
  %10 = call i32 @Calculator.peek(ptr %0)
  %11 = icmp eq i32 %10, 45
  %12 = zext i1 %11 to i32
  %sc.b = icmp ne i32 %12, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ true, %while.cond ], [ %sc.b, %sc.rhs ]
  %13 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

if.then:                                          ; preds = %while.body
  %v4 = load i32, ptr %v, align 4
  %r5 = load i32, ptr %r, align 4
  %14 = add i32 %v4, %r5
  store i32 %14, ptr %v, align 4
  br label %if.end

if.else:                                          ; preds = %while.body
  %v6 = load i32, ptr %v, align 4
  %r7 = load i32, ptr %r, align 4
  %15 = sub i32 %v6, %r7
  store i32 %15, ptr %v, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %while.cond
}

define internal i32 @Calculator.evaluate(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %class.Calculator, ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  %1 = call i32 @Calculator.expr(ptr %0)
  ret i32 %1
}

define internal ptr @Rle.encode(ptr %0) {
entry:
  %run = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.end7, %entry
  %i1 = load i32, ptr %i, align 4
  %s2 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %s3 = load ptr, ptr %s, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %c, align 4
  store i32 1, ptr %run, align 4
  br label %while.cond5

while.end:                                        ; preds = %while.cond
  %sb28 = load ptr, ptr %sb, align 8
  %6 = call ptr @StringBuilder.toString(ptr %sb28)
  %strcpy = call ptr @__polaron_str_copy(ptr %6)
  call void @__polaron_str_free(ptr %6)
  ret ptr %strcpy

while.cond5:                                      ; preds = %while.body6, %while.body
  %i8 = load i32, ptr %i, align 4
  %run9 = load i32, ptr %run, align 4
  %7 = add i32 %i8, %run9
  %s10 = load ptr, ptr %s, align 8
  %str.len11 = getelementptr inbounds %String, ptr %s10, i32 0, i32 0
  %len12 = load i64, ptr %str.len11, align 8
  %8 = trunc i64 %len12 to i32
  %9 = icmp slt i32 %7, %8
  %10 = zext i1 %9 to i32
  %sc.a = icmp ne i32 %10, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body6:                                      ; preds = %sc.end
  %run21 = load i32, ptr %run, align 4
  %11 = add i32 %run21, 1
  store i32 %11, ptr %run, align 4
  br label %while.cond5

while.end7:                                       ; preds = %sc.end
  %sb22 = load ptr, ptr %sb, align 8
  %c23 = load i32, ptr %c, align 4
  %12 = call ptr @StringBuilder.appendChar(ptr %sb22, i32 %c23)
  %sb24 = load ptr, ptr %sb, align 8
  %run25 = load i32, ptr %run, align 4
  %13 = call ptr @StringBuilder.appendInt(ptr %sb24, i32 %run25)
  %i26 = load i32, ptr %i, align 4
  %run27 = load i32, ptr %run, align 4
  %14 = add i32 %i26, %run27
  store i32 %14, ptr %i, align 4
  br label %while.cond

sc.rhs:                                           ; preds = %while.cond5
  %s13 = load ptr, ptr %s, align 8
  %i14 = load i32, ptr %i, align 4
  %run15 = load i32, ptr %run, align 4
  %15 = add i32 %i14, %run15
  %16 = sext i32 %15 to i64
  %str.data16 = getelementptr inbounds %String, ptr %s13, i32 0, i32 1
  %data17 = load ptr, ptr %str.data16, align 8
  %ch.addr18 = getelementptr i8, ptr %data17, i64 %16
  %ch19 = load i8, ptr %ch.addr18, align 1
  %17 = zext i8 %ch19 to i32
  %c20 = load i32, ptr %c, align 4
  %18 = icmp eq i32 %17, %c20
  %19 = zext i1 %18 to i32
  %sc.b = icmp ne i32 %19, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond5
  %sc = phi i1 [ false, %while.cond5 ], [ %sc.b, %sc.rhs ]
  %20 = zext i1 %sc to i32
  br i1 %sc, label %while.body6, label %while.end7
}

define internal ptr @Rle.decode(ptr %0) {
entry:
  %k = alloca i32, align 4
  %count = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %for.end, %entry
  %i1 = load i32, ptr %i, align 4
  %s2 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %s3 = load ptr, ptr %s, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %c, align 4
  %i5 = load i32, ptr %i, align 4
  %6 = add i32 %i5, 1
  store i32 %6, ptr %i, align 4
  store i32 0, ptr %count, align 4
  br label %while.cond6

while.end:                                        ; preds = %while.cond
  %sb42 = load ptr, ptr %sb, align 8
  %7 = call ptr @StringBuilder.toString(ptr %sb42)
  %strcpy = call ptr @__polaron_str_copy(ptr %7)
  call void @__polaron_str_free(ptr %7)
  ret ptr %strcpy

while.cond6:                                      ; preds = %while.body7, %while.body
  %i9 = load i32, ptr %i, align 4
  %s10 = load ptr, ptr %s, align 8
  %str.len11 = getelementptr inbounds %String, ptr %s10, i32 0, i32 0
  %len12 = load i64, ptr %str.len11, align 8
  %8 = trunc i64 %len12 to i32
  %9 = icmp slt i32 %i9, %8
  %10 = zext i1 %9 to i32
  %sc.a = icmp ne i32 %10, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body7:                                      ; preds = %sc.end21
  %count30 = load i32, ptr %count, align 4
  %11 = mul i32 %count30, 10
  %s31 = load ptr, ptr %s, align 8
  %i32 = load i32, ptr %i, align 4
  %12 = sext i32 %i32 to i64
  %str.data33 = getelementptr inbounds %String, ptr %s31, i32 0, i32 1
  %data34 = load ptr, ptr %str.data33, align 8
  %ch.addr35 = getelementptr i8, ptr %data34, i64 %12
  %ch36 = load i8, ptr %ch.addr35, align 1
  %13 = zext i8 %ch36 to i32
  %14 = sub i32 %13, 48
  %15 = add i32 %11, %14
  store i32 %15, ptr %count, align 4
  %i37 = load i32, ptr %i, align 4
  %16 = add i32 %i37, 1
  store i32 %16, ptr %i, align 4
  br label %while.cond6

while.end8:                                       ; preds = %sc.end21
  store i32 0, ptr %k, align 4
  br label %for.cond

sc.rhs:                                           ; preds = %while.cond6
  %s13 = load ptr, ptr %s, align 8
  %i14 = load i32, ptr %i, align 4
  %17 = sext i32 %i14 to i64
  %str.data15 = getelementptr inbounds %String, ptr %s13, i32 0, i32 1
  %data16 = load ptr, ptr %str.data15, align 8
  %ch.addr17 = getelementptr i8, ptr %data16, i64 %17
  %ch18 = load i8, ptr %ch.addr17, align 1
  %18 = zext i8 %ch18 to i32
  %19 = icmp sge i32 %18, 48
  %20 = zext i1 %19 to i32
  %sc.b = icmp ne i32 %20, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond6
  %sc = phi i1 [ false, %while.cond6 ], [ %sc.b, %sc.rhs ]
  %21 = zext i1 %sc to i32
  %sc.a19 = icmp ne i32 %21, 0
  br i1 %sc.a19, label %sc.rhs20, label %sc.end21

sc.rhs20:                                         ; preds = %sc.end
  %s22 = load ptr, ptr %s, align 8
  %i23 = load i32, ptr %i, align 4
  %22 = sext i32 %i23 to i64
  %str.data24 = getelementptr inbounds %String, ptr %s22, i32 0, i32 1
  %data25 = load ptr, ptr %str.data24, align 8
  %ch.addr26 = getelementptr i8, ptr %data25, i64 %22
  %ch27 = load i8, ptr %ch.addr26, align 1
  %23 = zext i8 %ch27 to i32
  %24 = icmp sle i32 %23, 57
  %25 = zext i1 %24 to i32
  %sc.b28 = icmp ne i32 %25, 0
  br label %sc.end21

sc.end21:                                         ; preds = %sc.rhs20, %sc.end
  %sc29 = phi i1 [ false, %sc.end ], [ %sc.b28, %sc.rhs20 ]
  %26 = zext i1 %sc29 to i32
  br i1 %sc29, label %while.body7, label %while.end8

for.cond:                                         ; preds = %for.update, %while.end8
  %k38 = load i32, ptr %k, align 4
  %count39 = load i32, ptr %count, align 4
  %27 = icmp slt i32 %k38, %count39
  %28 = zext i1 %27 to i32
  br i1 %27, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sb40 = load ptr, ptr %sb, align 8
  %c41 = load i32, ptr %c, align 4
  %29 = call ptr @StringBuilder.appendChar(ptr %sb40, i32 %c41)
  br label %for.update

for.update:                                       ; preds = %for.body
  %30 = load i32, ptr %k, align 4
  %31 = add i32 %30, 1
  store i32 %31, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %while.cond
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @strcmp(ptr, ptr)

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
