; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/jaro_winkler.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/jaro_winkler.pol"
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
@.str = private unnamed_addr constant [34 x i8] c"martha=%.3f dixon=%.3f same=%.3f\0A\00", align 1
@.strdata = private constant [7 x i8] c"MARTHA\00"
@.strobj = private global %String { i64 6, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"MARHTA\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [6 x i8] c"DIXON\00"
@.strobj.4 = private global %String { i64 5, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [9 x i8] c"DICKSONX\00"
@.strobj.6 = private global %String { i64 8, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [6 x i8] c"hello\00"
@.strobj.8 = private global %String { i64 5, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [6 x i8] c"hello\00"
@.strobj.10 = private global %String { i64 5, ptr @.strdata.9, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1316 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1317 = private global %String { i64 16, ptr @.strdata.1316, i64 0 }
@.strdata.1318 = private constant [17 x i8] c"division by zero\00"
@.strobj.1319 = private global %String { i64 16, ptr @.strdata.1318, i64 0 }
@.fail.2607 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4208:25  in JaroWinkler.jaro\0A\00", align 1
@.faila.2608 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2609 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2610 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4209:35  in JaroWinkler.jaro\0A\00", align 1
@.faila.2611 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2612 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2613 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4209:49  in JaroWinkler.jaro\0A\00", align 1
@.faila.2614 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2615 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2616 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4218:21  in JaroWinkler.jaro\0A\00", align 1
@.faila.2617 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2618 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2619 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4219:25  in JaroWinkler.jaro\0A\00", align 1
@.faila.2620 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2621 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }

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
  %16 = call double @JaroWinkler.similarity(ptr @.strobj, ptr @.strobj.2)
  %17 = call double @JaroWinkler.similarity(ptr @.strobj.4, ptr @.strobj.6)
  %18 = call double @JaroWinkler.similarity(ptr @.strobj.8, ptr @.strobj.10)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, double %16, double %17, double %18)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1317)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1319)
  ret ptr %strcpy
}

define internal double @JaroWinkler.jaro(ptr %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca double, align 8
  %mt = alloca double, align 8
  %i92 = alloca i32, align 4
  %trans = alloca i32, align 4
  %k = alloca i32, align 4
  %done = alloca i32, align 4
  %j = alloca i32, align 4
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %i = alloca i32, align 4
  %matches = alloca i32, align 4
  %m2 = alloca ptr, align 8
  %m1 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %window = alloca i32, align 4
  %n2 = alloca i32, align 4
  %n1 = alloca i32, align 4
  %s2 = alloca ptr, align 8
  %s1 = alloca ptr, align 8
  store ptr %0, ptr %s1, align 8
  store ptr %1, ptr %s2, align 8
  %s11 = load ptr, ptr %s1, align 8
  %str.len = getelementptr inbounds %String, ptr %s11, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n1, align 4
  %s22 = load ptr, ptr %s2, align 8
  %str.len3 = getelementptr inbounds %String, ptr %s22, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %n2, align 4
  %n15 = load i32, ptr %n1, align 4
  %4 = icmp eq i32 %n15, 0
  %5 = zext i1 %4 to i32
  %sc.a = icmp ne i32 %5, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %n26 = load i32, ptr %n2, align 4
  %6 = icmp eq i32 %n26, 0
  %7 = zext i1 %6 to i32
  %sc.b = icmp ne i32 %7, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %8 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret double 1.000000e+00

if.end:                                           ; preds = %sc.end
  %n17 = load i32, ptr %n1, align 4
  %9 = icmp eq i32 %n17, 0
  %10 = zext i1 %9 to i32
  %sc.a8 = icmp ne i32 %10, 0
  br i1 %sc.a8, label %sc.end10, label %sc.rhs9

sc.rhs9:                                          ; preds = %if.end
  %n211 = load i32, ptr %n2, align 4
  %11 = icmp eq i32 %n211, 0
  %12 = zext i1 %11 to i32
  %sc.b12 = icmp ne i32 %12, 0
  br label %sc.end10

sc.end10:                                         ; preds = %sc.rhs9, %if.end
  %sc13 = phi i1 [ true, %if.end ], [ %sc.b12, %sc.rhs9 ]
  %13 = zext i1 %sc13 to i32
  br i1 %sc13, label %if.then14, label %if.end15

if.then14:                                        ; preds = %sc.end10
  ret double 0.000000e+00

if.end15:                                         ; preds = %sc.end10
  %n116 = load i32, ptr %n1, align 4
  store i32 %n116, ptr %window, align 4
  %n217 = load i32, ptr %n2, align 4
  %window18 = load i32, ptr %window, align 4
  %14 = icmp sgt i32 %n217, %window18
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then19, label %if.end20

if.then19:                                        ; preds = %if.end15
  %n221 = load i32, ptr %n2, align 4
  store i32 %n221, ptr %window, align 4
  br label %if.end20

if.end20:                                         ; preds = %if.then19, %if.end15
  %window22 = load i32, ptr %window, align 4
  %16 = icmp eq i32 %window22, -2147483648
  %17 = and i1 %16, false
  %18 = or i1 false, %17
  br i1 %18, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end20
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end20
  %19 = sdiv i32 %window22, 2
  %20 = sub i32 %19, 1
  store i32 %20, ptr %window, align 4
  %window23 = load i32, ptr %window, align 4
  %21 = icmp slt i32 %window23, 0
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then24, label %if.end25

if.then24:                                        ; preds = %div.ok
  store i32 0, ptr %window, align 4
  br label %if.end25

if.end25:                                         ; preds = %if.then24, %div.ok
  %n126 = load i32, ptr %n1, align 4
  %23 = sext i32 %n126 to i64
  %24 = mul i64 %23, 1
  %25 = add i64 8, %24
  %arr = call ptr @__polaron_malloc(i64 %25)
  store i64 %23, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %26 = call ptr @memset(ptr %arr.data, i32 0, i64 %24)
  store ptr %arr, ptr %m1, align 8
  %n227 = load i32, ptr %n2, align 4
  %27 = sext i32 %n227 to i64
  %28 = mul i64 %27, 1
  %29 = add i64 8, %28
  %arr28 = call ptr @__polaron_malloc(i64 %29)
  store i64 %27, ptr %arr28, align 8
  %arr.data29 = getelementptr i8, ptr %arr28, i64 8
  %30 = call ptr @memset(ptr %arr.data29, i32 0, i64 %28)
  store ptr %arr28, ptr %m2, align 8
  store i32 0, ptr %matches, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end25
  %i30 = load i32, ptr %i, align 4
  %n131 = load i32, ptr %n1, align 4
  %31 = icmp slt i32 %i30, %n131
  %32 = zext i1 %31 to i32
  br i1 %31, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i32 = load i32, ptr %i, align 4
  %window33 = load i32, ptr %window, align 4
  %33 = sub i32 %i32, %window33
  store i32 %33, ptr %lo, align 4
  %lo34 = load i32, ptr %lo, align 4
  %34 = icmp slt i32 %lo34, 0
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then35, label %if.end36

for.update:                                       ; preds = %while.end
  %36 = load i32, ptr %i, align 4
  %37 = add i32 %36, 1
  store i32 %37, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %matches89 = load i32, ptr %matches, align 4
  %38 = icmp eq i32 %matches89, 0
  %39 = zext i1 %38 to i32
  br i1 %38, label %if.then90, label %if.end91

if.then35:                                        ; preds = %for.body
  store i32 0, ptr %lo, align 4
  br label %if.end36

if.end36:                                         ; preds = %if.then35, %for.body
  %i37 = load i32, ptr %i, align 4
  %window38 = load i32, ptr %window, align 4
  %40 = add i32 %i37, %window38
  store i32 %40, ptr %hi, align 4
  %hi39 = load i32, ptr %hi, align 4
  %n240 = load i32, ptr %n2, align 4
  %41 = sub i32 %n240, 1
  %42 = icmp sgt i32 %hi39, %41
  %43 = zext i1 %42 to i32
  br i1 %42, label %if.then41, label %if.end42

if.then41:                                        ; preds = %if.end36
  %n243 = load i32, ptr %n2, align 4
  %44 = sub i32 %n243, 1
  store i32 %44, ptr %hi, align 4
  br label %if.end42

if.end42:                                         ; preds = %if.then41, %if.end36
  %lo44 = load i32, ptr %lo, align 4
  store i32 %lo44, ptr %j, align 4
  store i32 0, ptr %done, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end70, %if.end42
  %j45 = load i32, ptr %j, align 4
  %hi46 = load i32, ptr %hi, align 4
  %45 = icmp sle i32 %j45, %hi46
  %46 = zext i1 %45 to i32
  %sc.a47 = icmp ne i32 %46, 0
  br i1 %sc.a47, label %sc.rhs48, label %sc.end49

while.body:                                       ; preds = %sc.end49
  %m253 = load ptr, ptr %m2, align 8, !nonnull !4, !dereferenceable !5
  %j54 = load i32, ptr %j, align 4
  %47 = sext i32 %j54 to i64
  %arr.len = load i64, ptr %m253, align 8
  %arr.oob = icmp uge i64 %47, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

while.end:                                        ; preds = %sc.end49
  br label %for.update

sc.rhs48:                                         ; preds = %while.cond
  %done50 = load i32, ptr %done, align 4
  %48 = icmp eq i32 %done50, 0
  %49 = zext i1 %48 to i32
  %sc.b51 = icmp ne i32 %49, 0
  br label %sc.end49

sc.end49:                                         ; preds = %sc.rhs48, %while.cond
  %sc52 = phi i1 [ false, %while.cond ], [ %sc.b51, %sc.rhs48 ]
  %50 = zext i1 %sc52 to i32
  br i1 %sc52, label %while.body, label %while.end

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.2607, ptr @.faila.2608, i64 %47, ptr @.failb.2609, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data55 = getelementptr i8, ptr %m253, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data55, i64 %47
  %elem = load i8, ptr %arr.elem, align 1
  %51 = zext i8 %elem to i32
  %52 = icmp eq i32 %51, 0
  %53 = zext i1 %52 to i32
  %sc.a56 = icmp ne i32 %53, 0
  br i1 %sc.a56, label %sc.rhs57, label %sc.end58

sc.rhs57:                                         ; preds = %idx.ok
  %s159 = load ptr, ptr %s1, align 8
  %i60 = load i32, ptr %i, align 4
  %54 = sext i32 %i60 to i64
  %str.data = getelementptr inbounds %String, ptr %s159, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %54
  %ch = load i8, ptr %ch.addr, align 1
  %55 = zext i8 %ch to i32
  %s261 = load ptr, ptr %s2, align 8
  %j62 = load i32, ptr %j, align 4
  %56 = sext i32 %j62 to i64
  %str.data63 = getelementptr inbounds %String, ptr %s261, i32 0, i32 1
  %data64 = load ptr, ptr %str.data63, align 8
  %ch.addr65 = getelementptr i8, ptr %data64, i64 %56
  %ch66 = load i8, ptr %ch.addr65, align 1
  %57 = zext i8 %ch66 to i32
  %58 = icmp eq i32 %55, %57
  %59 = zext i1 %58 to i32
  %sc.b67 = icmp ne i32 %59, 0
  br label %sc.end58

sc.end58:                                         ; preds = %sc.rhs57, %idx.ok
  %sc68 = phi i1 [ false, %idx.ok ], [ %sc.b67, %sc.rhs57 ]
  %60 = zext i1 %sc68 to i32
  br i1 %sc68, label %if.then69, label %if.end70

if.then69:                                        ; preds = %sc.end58
  %m171 = load ptr, ptr %m1, align 8, !nonnull !4, !dereferenceable !5
  %i72 = load i32, ptr %i, align 4
  %61 = sext i32 %i72 to i64
  %arr.len73 = load i64, ptr %m171, align 8
  %arr.oob74 = icmp uge i64 %61, %arr.len73
  br i1 %arr.oob74, label %idx.bad75, label %idx.ok76, !prof !6

if.end70:                                         ; preds = %idx.ok84, %sc.end58
  %j88 = load i32, ptr %j, align 4
  %62 = add i32 %j88, 1
  store i32 %62, ptr %j, align 4
  br label %while.cond

idx.bad75:                                        ; preds = %if.then69
  call void @__polaron_fail(ptr @.fail.2610, ptr @.faila.2611, i64 %61, ptr @.failb.2612, i64 %arr.len73, i32 70)
  unreachable

idx.ok76:                                         ; preds = %if.then69
  %arr.data77 = getelementptr i8, ptr %m171, i64 8
  %arr.elem78 = getelementptr inbounds i8, ptr %arr.data77, i64 %61
  store i8 1, ptr %arr.elem78, align 1
  %m279 = load ptr, ptr %m2, align 8, !nonnull !4, !dereferenceable !5
  %j80 = load i32, ptr %j, align 4
  %63 = sext i32 %j80 to i64
  %arr.len81 = load i64, ptr %m279, align 8
  %arr.oob82 = icmp uge i64 %63, %arr.len81
  br i1 %arr.oob82, label %idx.bad83, label %idx.ok84, !prof !6

idx.bad83:                                        ; preds = %idx.ok76
  call void @__polaron_fail(ptr @.fail.2613, ptr @.faila.2614, i64 %63, ptr @.failb.2615, i64 %arr.len81, i32 70)
  unreachable

idx.ok84:                                         ; preds = %idx.ok76
  %arr.data85 = getelementptr i8, ptr %m279, i64 8
  %arr.elem86 = getelementptr inbounds i8, ptr %arr.data85, i64 %63
  store i8 1, ptr %arr.elem86, align 1
  %matches87 = load i32, ptr %matches, align 4
  %64 = add i32 %matches87, 1
  store i32 %64, ptr %matches, align 4
  store i32 1, ptr %done, align 4
  br label %if.end70

if.then90:                                        ; preds = %for.end
  ret double 0.000000e+00

if.end91:                                         ; preds = %for.end
  store i32 0, ptr %k, align 4
  store i32 0, ptr %trans, align 4
  store i32 0, ptr %i92, align 4
  br label %for.cond93

for.cond93:                                       ; preds = %for.update95, %if.end91
  %i97 = load i32, ptr %i92, align 4
  %n198 = load i32, ptr %n1, align 4
  %65 = icmp slt i32 %i97, %n198
  %66 = zext i1 %65 to i32
  br i1 %65, label %for.body94, label %for.end96

for.body94:                                       ; preds = %for.cond93
  %m199 = load ptr, ptr %m1, align 8, !nonnull !4, !dereferenceable !5
  %i100 = load i32, ptr %i92, align 4
  %67 = sext i32 %i100 to i64
  %arr.len101 = load i64, ptr %m199, align 8
  %arr.oob102 = icmp uge i64 %67, %arr.len101
  br i1 %arr.oob102, label %idx.bad103, label %idx.ok104, !prof !6

for.update95:                                     ; preds = %if.end109
  %68 = load i32, ptr %i92, align 4
  %69 = add i32 %68, 1
  store i32 %69, ptr %i92, align 4
  br label %for.cond93

for.end96:                                        ; preds = %for.cond93
  %matches139 = load i32, ptr %matches, align 4
  %70 = sitofp i32 %matches139 to double
  store double %70, ptr %mt, align 8
  %trans140 = load i32, ptr %trans, align 4
  %71 = sitofp i32 %trans140 to double
  %72 = fdiv double %71, 2.000000e+00
  store double %72, ptr %t, align 8
  %mt141 = load double, ptr %mt, align 8
  %n1142 = load i32, ptr %n1, align 4
  %73 = sitofp i32 %n1142 to double
  %74 = fdiv double %mt141, %73
  %mt143 = load double, ptr %mt, align 8
  %n2144 = load i32, ptr %n2, align 4
  %75 = sitofp i32 %n2144 to double
  %76 = fdiv double %mt143, %75
  %77 = fadd double %74, %76
  %mt145 = load double, ptr %mt, align 8
  %t146 = load double, ptr %t, align 8
  %78 = fsub double %mt145, %t146
  %mt147 = load double, ptr %mt, align 8
  %79 = fdiv double %78, %mt147
  %80 = fadd double %77, %79
  %81 = fdiv double %80, 3.000000e+00
  ret double %81

idx.bad103:                                       ; preds = %for.body94
  call void @__polaron_fail(ptr @.fail.2616, ptr @.faila.2617, i64 %67, ptr @.failb.2618, i64 %arr.len101, i32 70)
  unreachable

idx.ok104:                                        ; preds = %for.body94
  %arr.data105 = getelementptr i8, ptr %m199, i64 8
  %arr.elem106 = getelementptr inbounds i8, ptr %arr.data105, i64 %67
  %elem107 = load i8, ptr %arr.elem106, align 1
  %82 = zext i8 %elem107 to i32
  %83 = icmp ne i32 %82, 0
  br i1 %83, label %if.then108, label %if.end109

if.then108:                                       ; preds = %idx.ok104
  br label %while.cond110

if.end109:                                        ; preds = %if.end136, %idx.ok104
  br label %for.update95

while.cond110:                                    ; preds = %while.body111, %if.then108
  %m2113 = load ptr, ptr %m2, align 8, !nonnull !4, !dereferenceable !5
  %k114 = load i32, ptr %k, align 4
  %84 = sext i32 %k114 to i64
  %arr.len115 = load i64, ptr %m2113, align 8
  %arr.oob116 = icmp uge i64 %84, %arr.len115
  br i1 %arr.oob116, label %idx.bad117, label %idx.ok118, !prof !6

while.body111:                                    ; preds = %idx.ok118
  %k122 = load i32, ptr %k, align 4
  %85 = add i32 %k122, 1
  store i32 %85, ptr %k, align 4
  br label %while.cond110

while.end112:                                     ; preds = %idx.ok118
  %s1123 = load ptr, ptr %s1, align 8
  %i124 = load i32, ptr %i92, align 4
  %86 = sext i32 %i124 to i64
  %str.data125 = getelementptr inbounds %String, ptr %s1123, i32 0, i32 1
  %data126 = load ptr, ptr %str.data125, align 8
  %ch.addr127 = getelementptr i8, ptr %data126, i64 %86
  %ch128 = load i8, ptr %ch.addr127, align 1
  %87 = zext i8 %ch128 to i32
  %s2129 = load ptr, ptr %s2, align 8
  %k130 = load i32, ptr %k, align 4
  %88 = sext i32 %k130 to i64
  %str.data131 = getelementptr inbounds %String, ptr %s2129, i32 0, i32 1
  %data132 = load ptr, ptr %str.data131, align 8
  %ch.addr133 = getelementptr i8, ptr %data132, i64 %88
  %ch134 = load i8, ptr %ch.addr133, align 1
  %89 = zext i8 %ch134 to i32
  %90 = icmp ne i32 %87, %89
  %91 = zext i1 %90 to i32
  br i1 %90, label %if.then135, label %if.end136

idx.bad117:                                       ; preds = %while.cond110
  call void @__polaron_fail(ptr @.fail.2619, ptr @.faila.2620, i64 %84, ptr @.failb.2621, i64 %arr.len115, i32 70)
  unreachable

idx.ok118:                                        ; preds = %while.cond110
  %arr.data119 = getelementptr i8, ptr %m2113, i64 8
  %arr.elem120 = getelementptr inbounds i8, ptr %arr.data119, i64 %84
  %elem121 = load i8, ptr %arr.elem120, align 1
  %92 = zext i8 %elem121 to i32
  %93 = icmp eq i32 %92, 0
  %94 = zext i1 %93 to i32
  br i1 %93, label %while.body111, label %while.end112

if.then135:                                       ; preds = %while.end112
  %trans137 = load i32, ptr %trans, align 4
  %95 = add i32 %trans137, 1
  store i32 %95, ptr %trans, align 4
  br label %if.end136

if.end136:                                        ; preds = %if.then135, %while.end112
  %k138 = load i32, ptr %k, align 4
  %96 = add i32 %k138, 1
  store i32 %96, ptr %k, align 4
  br label %if.end109
}

define internal double @JaroWinkler.similarity(ptr %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %prefix = alloca i32, align 4
  %j = alloca double, align 8
  %s2 = alloca ptr, align 8
  %s1 = alloca ptr, align 8
  store ptr %0, ptr %s1, align 8
  store ptr %1, ptr %s2, align 8
  %s11 = load ptr, ptr %s1, align 8
  %s22 = load ptr, ptr %s2, align 8
  %2 = call double @JaroWinkler.jaro(ptr %s11, ptr %s22)
  store double %2, ptr %j, align 8
  store i32 0, ptr %prefix, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i3 = load i32, ptr %i, align 4
  %s14 = load ptr, ptr %s1, align 8
  %str.len = getelementptr inbounds %String, ptr %s14, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp slt i32 %i3, %3
  %5 = zext i1 %4 to i32
  %sc.a = icmp ne i32 %5, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end17
  %prefix28 = load i32, ptr %prefix, align 4
  %6 = add i32 %prefix28, 1
  store i32 %6, ptr %prefix, align 4
  %i29 = load i32, ptr %i, align 4
  %7 = add i32 %i29, 1
  store i32 %7, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end17
  %j30 = load double, ptr %j, align 8
  %prefix31 = load i32, ptr %prefix, align 4
  %8 = sitofp i32 %prefix31 to double
  %9 = fmul double %8, 1.000000e-01
  %j32 = load double, ptr %j, align 8
  %10 = fsub double 1.000000e+00, %j32
  %11 = fmul double %9, %10
  %12 = fadd double %j30, %11
  ret double %12

sc.rhs:                                           ; preds = %while.cond
  %i5 = load i32, ptr %i, align 4
  %s26 = load ptr, ptr %s2, align 8
  %str.len7 = getelementptr inbounds %String, ptr %s26, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %13 = trunc i64 %len8 to i32
  %14 = icmp slt i32 %i5, %13
  %15 = zext i1 %14 to i32
  %sc.b = icmp ne i32 %15, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %16 = zext i1 %sc to i32
  %sc.a9 = icmp ne i32 %16, 0
  br i1 %sc.a9, label %sc.rhs10, label %sc.end11

sc.rhs10:                                         ; preds = %sc.end
  %i12 = load i32, ptr %i, align 4
  %17 = icmp slt i32 %i12, 4
  %18 = zext i1 %17 to i32
  %sc.b13 = icmp ne i32 %18, 0
  br label %sc.end11

sc.end11:                                         ; preds = %sc.rhs10, %sc.end
  %sc14 = phi i1 [ false, %sc.end ], [ %sc.b13, %sc.rhs10 ]
  %19 = zext i1 %sc14 to i32
  %sc.a15 = icmp ne i32 %19, 0
  br i1 %sc.a15, label %sc.rhs16, label %sc.end17

sc.rhs16:                                         ; preds = %sc.end11
  %s118 = load ptr, ptr %s1, align 8
  %i19 = load i32, ptr %i, align 4
  %20 = sext i32 %i19 to i64
  %str.data = getelementptr inbounds %String, ptr %s118, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %20
  %ch = load i8, ptr %ch.addr, align 1
  %21 = zext i8 %ch to i32
  %s220 = load ptr, ptr %s2, align 8
  %i21 = load i32, ptr %i, align 4
  %22 = sext i32 %i21 to i64
  %str.data22 = getelementptr inbounds %String, ptr %s220, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %ch.addr24 = getelementptr i8, ptr %data23, i64 %22
  %ch25 = load i8, ptr %ch.addr24, align 1
  %23 = zext i8 %ch25 to i32
  %24 = icmp eq i32 %21, %23
  %25 = zext i1 %24 to i32
  %sc.b26 = icmp ne i32 %25, 0
  br label %sc.end17

sc.end17:                                         ; preds = %sc.rhs16, %sc.end11
  %sc27 = phi i1 [ false, %sc.end11 ], [ %sc.b26, %sc.rhs16 ]
  %26 = zext i1 %sc27 to i32
  br i1 %sc27, label %while.body, label %while.end
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5320)
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
!4 = !{}
!5 = !{i64 8}
!6 = !{!"branch_weights", i32 1, i32 1048576}
