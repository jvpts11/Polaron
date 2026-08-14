; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/duration_stdlib.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/duration_stdlib.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.Duration = type { ptr, i64 }
%class.Instant = type { ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Instant.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Instant.plus, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Instant.toEpochMillis, ptr @Instant.isBefore, ptr @Instant.isAfter, ptr @Instant.since, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Duration.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Duration.compareTo, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Duration.toMillis, ptr @Duration.toSeconds, ptr @Duration.plus, ptr @Duration.minus, ptr @"Duration.TComparer$lessThan", ptr @Duration.lessThan, ptr @"Duration.TComparer$atMost", ptr @Duration.atMost, ptr @"Duration.TComparer$greaterThan", ptr @Duration.greaterThan, ptr @"Duration.TComparer$atLeast", ptr @Duration.atLeast, ptr @"Duration.TComparer$sameOrder", ptr @Duration.sameOrder, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [25 x i8] c"aMs=%d aSec=%d sumMs=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [42 x i8] c"before=%d after=%d elapsedMs=%d nowOk=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1305 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1306 = private global %String { i64 16, ptr @.strdata.1305, i64 0 }
@.strdata.1307 = private constant [17 x i8] c"division by zero\00"
@.strobj.1308 = private global %String { i64 16, ptr @.strdata.1307, i64 0 }
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %el = alloca ptr, align 8
  %t1 = alloca ptr, align 8
  %t0 = alloca ptr, align 8
  %sum = alloca ptr, align 8
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
  %16 = call ptr @Duration.ofSeconds(i64 2)
  store ptr %16, ptr %a, align 8
  %17 = call ptr @Duration.ofMillis(i64 500)
  store ptr %17, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %b2 = load ptr, ptr %b, align 8
  %18 = call ptr @Duration.plus(ptr %a1, ptr %b2)
  store ptr %18, ptr %sum, align 8
  %a3 = load ptr, ptr %a, align 8
  %19 = call i64 @Duration.toMillis(ptr %a3)
  %20 = trunc i64 %19 to i32
  %a4 = load ptr, ptr %a, align 8
  %21 = call i64 @Duration.toSeconds(ptr %a4)
  %22 = trunc i64 %21 to i32
  %sum5 = load ptr, ptr %sum, align 8
  %23 = call i64 @Duration.toMillis(ptr %sum5)
  %24 = trunc i64 %23 to i32
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %20, i32 %22, i32 %24)
  %26 = call ptr @Instant.ofEpochMillis(i64 1000)
  store ptr %26, ptr %t0, align 8
  %27 = call ptr @Instant.ofEpochMillis(i64 3500)
  store ptr %27, ptr %t1, align 8
  %t16 = load ptr, ptr %t1, align 8
  %t07 = load ptr, ptr %t0, align 8
  %28 = call ptr @Instant.since(ptr %t16, ptr %t07)
  store ptr %28, ptr %el, align 8
  %t08 = load ptr, ptr %t0, align 8
  %t19 = load ptr, ptr %t1, align 8
  %29 = call i32 @Instant.isBefore(ptr %t08, ptr %t19)
  %t110 = load ptr, ptr %t1, align 8
  %t011 = load ptr, ptr %t0, align 8
  %30 = call i32 @Instant.isAfter(ptr %t110, ptr %t011)
  %el12 = load ptr, ptr %el, align 8
  %31 = call i64 @Duration.toMillis(ptr %el12)
  %32 = trunc i64 %31 to i32
  %33 = call ptr @Instant.now()
  %34 = call i64 @Instant.toEpochMillis(ptr %33)
  %35 = icmp sgt i64 %34, 1000000000000
  %36 = zext i1 %35 to i32
  %37 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %29, i32 %30, i32 %32, i32 %36)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1306)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1308)
  ret ptr %strcpy
}

define internal void @Duration.Duration(ptr %0, i64 %1) {
entry:
  %millis = alloca i64, align 8
  store i64 %1, ptr %millis, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 0
  store ptr @Duration.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %millis1 = load i64, ptr %millis, align 8
  store i64 %millis1, ptr %ms, align 8, !tbaa !4
  ret void
}

define internal i32 @Duration.compareTo(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %theirs = alloca i64, align 8
  %mine = alloca i64, align 8
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !4
  store i64 %ms1, ptr %mine, align 8
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Duration.toMillis(ptr %other2)
  store i64 %3, ptr %theirs, align 8
  %mine3 = load i64, ptr %mine, align 8
  %theirs4 = load i64, ptr %theirs, align 8
  %4 = icmp slt i64 %mine3, %theirs4
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 -1

if.end:                                           ; preds = %entry
  %mine5 = load i64, ptr %mine, align 8
  %theirs6 = load i64, ptr %theirs, align 8
  %6 = icmp sgt i64 %mine5, %theirs6
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end
  ret i32 1

if.end8:                                          ; preds = %if.end
  ret i32 0
}

define internal ptr @Duration.ofMillis(i64 %0) {
entry:
  %m = alloca i64, align 8
  store i64 %0, ptr %m, align 8
  %Duration.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  %m1 = load i64, ptr %m, align 8
  call void @Duration.Duration(ptr %Duration.obj, i64 %m1)
  ret ptr %Duration.obj
}

define internal ptr @Duration.ofSeconds(i64 %0) {
entry:
  %s = alloca i64, align 8
  store i64 %0, ptr %s, align 8
  %Duration.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  %s1 = load i64, ptr %s, align 8
  %1 = mul i64 %s1, 1000
  call void @Duration.Duration(ptr %Duration.obj, i64 %1)
  ret ptr %Duration.obj
}

define internal i64 @Duration.toMillis(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !4
  ret i64 %ms1
}

define internal i64 @Duration.toSeconds(ptr nonnull align 8 dereferenceable(16) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !4
  %1 = icmp eq i64 %ms1, -9223372036854775808
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
  %4 = sdiv i64 %ms1, 1000
  ret i64 %4
}

define internal ptr @Duration.plus(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %Duration.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !4
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Duration.toMillis(ptr %other2)
  %4 = add i64 %ms1, %3
  call void @Duration.Duration(ptr %Duration.obj, i64 %4)
  ret ptr %Duration.obj
}

define internal ptr @Duration.minus(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %Duration.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !4
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Duration.toMillis(ptr %other2)
  %4 = sub i64 %ms1, %3
  call void @Duration.Duration(ptr %Duration.obj, i64 %4)
  ret ptr %Duration.obj
}

define internal i32 @"Duration.TComparer$lessThan"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp slt i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.lessThan(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp slt i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @"Duration.TComparer$atMost"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sle i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.atMost(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sle i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @"Duration.TComparer$greaterThan"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sgt i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.greaterThan(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sgt i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @"Duration.TComparer$atLeast"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sge i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.atLeast(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sge i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @"Duration.TComparer$sameOrder"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.sameOrder(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal void @Instant.Instant(ptr %0, i64 %1) {
entry:
  %ms = alloca i64, align 8
  store i64 %1, ptr %ms, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 0
  store ptr @Instant.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8
  store i64 %ms1, ptr %epochMs, align 8, !tbaa !4
  ret void
}

define internal ptr @Instant.now() {
entry:
  %Instant.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  %0 = call i64 @__polaron_unix_ms()
  call void @Instant.Instant(ptr %Instant.obj, i64 %0)
  ret ptr %Instant.obj
}

define internal ptr @Instant.ofEpochMillis(i64 %0) {
entry:
  %ms = alloca i64, align 8
  store i64 %0, ptr %ms, align 8
  %Instant.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  %ms1 = load i64, ptr %ms, align 8
  call void @Instant.Instant(ptr %Instant.obj, i64 %ms1)
  ret ptr %Instant.obj
}

define internal i64 @Instant.toEpochMillis(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !4
  ret i64 %epochMs1
}

define internal i32 @Instant.isBefore(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Instant.copy = alloca %class.Instant, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Instant.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy, ptr %other, align 8
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !4
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Instant.toEpochMillis(ptr %other2)
  %4 = icmp slt i64 %epochMs1, %3
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Instant.isAfter(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Instant.copy = alloca %class.Instant, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Instant.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy, ptr %other, align 8
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !4
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Instant.toEpochMillis(ptr %other2)
  %4 = icmp sgt i64 %epochMs1, %3
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal ptr @Instant.plus(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %d = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %d, align 8
  %Instant.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !4
  %d2 = load ptr, ptr %d, align 8
  %3 = call i64 @Duration.toMillis(ptr %d2)
  %4 = add i64 %epochMs1, %3
  call void @Instant.Instant(ptr %Instant.obj, i64 %4)
  ret ptr %Instant.obj
}

define internal ptr @Instant.since(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Instant.copy = alloca %class.Instant, align 8
  %earlier = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Instant.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy, ptr %earlier, align 8
  %Duration.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !4
  %earlier2 = load ptr, ptr %earlier, align 8
  %3 = call i64 @Instant.toEpochMillis(ptr %earlier2)
  %4 = sub i64 %epochMs1, %3
  call void @Duration.Duration(ptr %Duration.obj, i64 %4)
  ret ptr %Duration.obj
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5307)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5309)
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

declare i64 @__polaron_unix_ms()

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i64", !2, i64 0}
