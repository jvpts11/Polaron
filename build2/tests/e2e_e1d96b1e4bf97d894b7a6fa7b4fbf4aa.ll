; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/random_gaussian.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/random_gaussian.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Random = type { ptr, i64 }
%class.DivideByZeroException = type { ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Random.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Random.nextInt, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Random.nextIntMax, ptr @Random.nextRange, ptr @Random.nextDouble, ptr @Random.nextBool, ptr @Random.sqrtD, ptr @Random.lnD, ptr @Random.nextGaussian, ptr @Random.nextGaussianScaled, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str = private unnamed_addr constant [17 x i8] c"pct1=%d pct2=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.2 = private unnamed_addr constant [13 x i8] c"seededNow ok\00", align 1
@.strdata.1306 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1307 = private global %String { i64 16, ptr @.strdata.1306, i64 0 }
@.strdata.1308 = private constant [17 x i8] c"division by zero\00"
@.strobj.1309 = private global %String { i64 16, ptr @.strdata.1308, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %x = alloca double, align 8
  %s = alloca ptr, align 8
  %pct2 = alloca i32, align 4
  %exc.thrown21 = alloca ptr, align 8
  %pct1 = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %g = alloca double, align 8
  %i = alloca i32, align 4
  %within2 = alloca i32, align 4
  %within1 = alloca i32, align 4
  %n = alloca i32, align 4
  %r = alloca ptr, align 8
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
  %Random.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Random, ptr null, i64 1) to i64))
  call void @Random.Random(ptr %Random.obj, i64 12345)
  store ptr %Random.obj, ptr %r, align 8
  store i32 100000, ptr %n, align 4
  store i32 0, ptr %within1, align 4
  store i32 0, ptr %within2, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %16 = icmp slt i32 %i1, %n2
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r3 = load ptr, ptr %r, align 8
  %18 = call double @Random.nextGaussian(ptr %r3)
  store double %18, ptr %g, align 8
  %g4 = load double, ptr %g, align 8
  %19 = fcmp ogt double %g4, -1.000000e+00
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

for.update:                                       ; preds = %if.end11
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %within116 = load i32, ptr %within1, align 4
  %23 = icmp eq i32 %within116, -2147483648
  %24 = and i1 %23, false
  %25 = or i1 false, %24
  br i1 %25, label %div.bad, label %div.ok

if.then:                                          ; preds = %for.body
  %g5 = load double, ptr %g, align 8
  %26 = fcmp olt double %g5, 1.000000e+00
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then6, label %if.end7

if.end:                                           ; preds = %if.end7, %for.body
  %g9 = load double, ptr %g, align 8
  %28 = fcmp ogt double %g9, -2.000000e+00
  %29 = zext i1 %28 to i32
  br i1 %28, label %if.then10, label %if.end11

if.then6:                                         ; preds = %if.then
  %within18 = load i32, ptr %within1, align 4
  %30 = add i32 %within18, 1
  store i32 %30, ptr %within1, align 4
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.then
  br label %if.end

if.then10:                                        ; preds = %if.end
  %g12 = load double, ptr %g, align 8
  %31 = fcmp olt double %g12, 2.000000e+00
  %32 = zext i1 %31 to i32
  br i1 %31, label %if.then13, label %if.end14

if.end11:                                         ; preds = %if.end14, %if.end
  br label %for.update

if.then13:                                        ; preds = %if.then10
  %within215 = load i32, ptr %within2, align 4
  %33 = add i32 %within215, 1
  store i32 %33, ptr %within2, align 4
  br label %if.end14

if.end14:                                         ; preds = %if.then13, %if.then10
  br label %if.end11

div.bad:                                          ; preds = %for.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.end
  %34 = sdiv i32 %within116, 1000
  store i32 %34, ptr %pct1, align 4
  %within217 = load i32, ptr %within2, align 4
  %35 = icmp eq i32 %within217, -2147483648
  %36 = and i1 %35, false
  %37 = or i1 false, %36
  br i1 %37, label %div.bad18, label %div.ok19

div.bad18:                                        ; preds = %div.ok
  %exc20 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc20)
  store ptr %exc20, ptr %exc.thrown21, align 8
  call void @_CxxThrowException(ptr %exc.thrown21, ptr @_TI1PEAX)
  unreachable

div.ok19:                                         ; preds = %div.ok
  %38 = sdiv i32 %within217, 1000
  store i32 %38, ptr %pct2, align 4
  %pct122 = load i32, ptr %pct1, align 4
  %pct223 = load i32, ptr %pct2, align 4
  %39 = call i32 (ptr, ...) @printf(ptr @.str, i32 %pct122, i32 %pct223)
  %40 = call ptr @Random.seededNow()
  store ptr %40, ptr %s, align 8
  %s24 = load ptr, ptr %s, align 8
  %41 = call double @Random.nextGaussianScaled(ptr %s24, double 1.000000e+02, double 1.500000e+01)
  store double %41, ptr %x, align 8
  %x25 = load double, ptr %x, align 8
  %42 = fcmp ogt double %x25, -1.000000e+03
  %43 = zext i1 %42 to i32
  br i1 %42, label %if.then26, label %if.end27

if.then26:                                        ; preds = %div.ok19
  %44 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr @.str.2)
  br label %if.end27

if.end27:                                         ; preds = %if.then26, %div.ok19
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1307)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1309)
  ret ptr %strcpy
}

define internal void @Random.Random(ptr %0, i64 %1) {
entry:
  %seed = alloca i64, align 8
  store i64 %1, ptr %seed, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Random, ptr %0, i32 0, i32 0
  store ptr @Random.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %state = getelementptr inbounds %class.Random, ptr %0, i32 0, i32 1
  %seed1 = load i64, ptr %seed, align 8
  store i64 %seed1, ptr %state, align 8, !tbaa !4
  %state2 = getelementptr inbounds %class.Random, ptr %0, i32 0, i32 1
  %state3 = load i64, ptr %state2, align 8, !tbaa !4
  %2 = icmp eq i64 %state3, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %state4 = getelementptr inbounds %class.Random, ptr %0, i32 0, i32 1
  store i64 1, ptr %state4, align 8, !tbaa !4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal i32 @Random.nextInt(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %x = alloca i64, align 8
  %state = getelementptr inbounds %class.Random, ptr %0, i32 0, i32 1
  %state1 = load i64, ptr %state, align 8, !tbaa !4
  store i64 %state1, ptr %x, align 8
  %x2 = load i64, ptr %x, align 8
  %x3 = load i64, ptr %x, align 8
  %1 = shl i64 %x3, 13
  %2 = xor i64 %x2, %1
  store i64 %2, ptr %x, align 8
  %x4 = load i64, ptr %x, align 8
  %x5 = load i64, ptr %x, align 8
  %3 = lshr i64 %x5, 7
  %4 = xor i64 %x4, %3
  store i64 %4, ptr %x, align 8
  %x6 = load i64, ptr %x, align 8
  %x7 = load i64, ptr %x, align 8
  %5 = shl i64 %x7, 17
  %6 = xor i64 %x6, %5
  store i64 %6, ptr %x, align 8
  %state8 = getelementptr inbounds %class.Random, ptr %0, i32 0, i32 1
  %x9 = load i64, ptr %x, align 8
  store i64 %x9, ptr %state8, align 8, !tbaa !4
  %x10 = load i64, ptr %x, align 8
  %7 = lshr i64 %x10, 33
  %8 = trunc i64 %7 to i32
  ret i32 %8
}

define internal i32 @Random.nextIntMax(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %max = alloca i32, align 4
  store i32 %1, ptr %max, align 4
  %2 = call i32 @Random.nextInt(ptr %0)
  %max1 = load i32, ptr %max, align 4
  %3 = icmp eq i32 %max1, 0
  %4 = icmp eq i32 %2, -2147483648
  %5 = icmp eq i32 %max1, -1
  %6 = and i1 %4, %5
  %7 = or i1 %3, %6
  br i1 %7, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %8 = srem i32 %2, %max1
  ret i32 %8
}

define internal i32 @Random.nextRange(ptr nonnull align 8 dereferenceable(16) %0, i32 %1, i32 %2) {
entry:
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  store i32 %1, ptr %lo, align 4
  store i32 %2, ptr %hi, align 4
  %lo1 = load i32, ptr %lo, align 4
  %hi2 = load i32, ptr %hi, align 4
  %lo3 = load i32, ptr %lo, align 4
  %3 = sub i32 %hi2, %lo3
  %4 = call i32 @Random.nextIntMax(ptr %0, i32 %3)
  %5 = add i32 %lo1, %4
  ret i32 %5
}

define internal double @Random.nextDouble(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %1 = call i32 @Random.nextInt(ptr %0)
  %2 = sitofp i32 %1 to double
  %3 = fdiv double %2, 0x41E0000000000000
  ret double %3
}

define internal i32 @Random.nextBool(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %1 = call i32 @Random.nextIntMax(ptr %0, i32 2)
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal double @Random.sqrtD(ptr nonnull align 8 dereferenceable(16) %0, double %1) {
entry:
  %i = alloca i32, align 4
  %g = alloca double, align 8
  %x = alloca double, align 8
  store double %1, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %2 = fcmp ole double %x1, 0.000000e+00
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret double 0.000000e+00

if.end:                                           ; preds = %entry
  %x2 = load double, ptr %x, align 8
  store double %x2, ptr %g, align 8
  %g3 = load double, ptr %g, align 8
  %4 = fcmp ogt double %g3, 1.000000e+00
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  %x6 = load double, ptr %x, align 8
  %6 = fdiv double %x6, 2.000000e+00
  store double %6, ptr %g, align 8
  br label %if.end5

if.end5:                                          ; preds = %if.then4, %if.end
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end5
  %i7 = load i32, ptr %i, align 4
  %7 = icmp slt i32 %i7, 40
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %g8 = load double, ptr %g, align 8
  %x9 = load double, ptr %x, align 8
  %g10 = load double, ptr %g, align 8
  %9 = fdiv double %x9, %g10
  %10 = fadd double %g8, %9
  %11 = fmul double 5.000000e-01, %10
  store double %11, ptr %g, align 8
  br label %for.update

for.update:                                       ; preds = %for.body
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %g11 = load double, ptr %g, align 8
  ret double %g11
}

define internal double @Random.lnD(ptr nonnull align 8 dereferenceable(16) %0, double %1) {
entry:
  %k = alloca i32, align 4
  %sum = alloca double, align 8
  %term = alloca double, align 8
  %t2 = alloca double, align 8
  %t = alloca double, align 8
  %e = alloca i32, align 4
  %v = alloca double, align 8
  %x = alloca double, align 8
  store double %1, ptr %x, align 8
  %x1 = load double, ptr %x, align 8
  %2 = fcmp ole double %x1, 0.000000e+00
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret double 0.000000e+00

if.end:                                           ; preds = %entry
  %x2 = load double, ptr %x, align 8
  store double %x2, ptr %v, align 8
  store i32 0, ptr %e, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %v3 = load double, ptr %v, align 8
  %4 = fcmp oge double %v3, 2.000000e+00
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v4 = load double, ptr %v, align 8
  %6 = fdiv double %v4, 2.000000e+00
  store double %6, ptr %v, align 8
  %e5 = load i32, ptr %e, align 4
  %7 = add i32 %e5, 1
  store i32 %7, ptr %e, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %while.cond6

while.cond6:                                      ; preds = %while.body7, %while.end
  %v9 = load double, ptr %v, align 8
  %8 = fcmp olt double %v9, 1.000000e+00
  %9 = zext i1 %8 to i32
  br i1 %8, label %while.body7, label %while.end8

while.body7:                                      ; preds = %while.cond6
  %v10 = load double, ptr %v, align 8
  %10 = fmul double %v10, 2.000000e+00
  store double %10, ptr %v, align 8
  %e11 = load i32, ptr %e, align 4
  %11 = sub i32 %e11, 1
  store i32 %11, ptr %e, align 4
  br label %while.cond6

while.end8:                                       ; preds = %while.cond6
  %v12 = load double, ptr %v, align 8
  %12 = fsub double %v12, 1.000000e+00
  %v13 = load double, ptr %v, align 8
  %13 = fadd double %v13, 1.000000e+00
  %14 = fdiv double %12, %13
  store double %14, ptr %t, align 8
  %t14 = load double, ptr %t, align 8
  %t15 = load double, ptr %t, align 8
  %15 = fmul double %t14, %t15
  store double %15, ptr %t2, align 8
  %t16 = load double, ptr %t, align 8
  store double %t16, ptr %term, align 8
  store double 0.000000e+00, ptr %sum, align 8
  store i32 1, ptr %k, align 4
  br label %while.cond17

while.cond17:                                     ; preds = %while.body18, %while.end8
  %k20 = load i32, ptr %k, align 4
  %16 = icmp sle i32 %k20, 25
  %17 = zext i1 %16 to i32
  br i1 %16, label %while.body18, label %while.end19

while.body18:                                     ; preds = %while.cond17
  %sum21 = load double, ptr %sum, align 8
  %term22 = load double, ptr %term, align 8
  %k23 = load i32, ptr %k, align 4
  %18 = sitofp i32 %k23 to double
  %19 = fdiv double %term22, %18
  %20 = fadd double %sum21, %19
  store double %20, ptr %sum, align 8
  %term24 = load double, ptr %term, align 8
  %t225 = load double, ptr %t2, align 8
  %21 = fmul double %term24, %t225
  store double %21, ptr %term, align 8
  %k26 = load i32, ptr %k, align 4
  %22 = add i32 %k26, 2
  store i32 %22, ptr %k, align 4
  br label %while.cond17

while.end19:                                      ; preds = %while.cond17
  %sum27 = load double, ptr %sum, align 8
  %23 = fmul double 2.000000e+00, %sum27
  %e28 = load i32, ptr %e, align 4
  %24 = sitofp i32 %e28 to double
  %25 = fmul double %24, 0x3FE62E42FEFA39EF
  %26 = fadd double %23, %25
  ret double %26
}

define internal double @Random.nextGaussian(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %v = alloca double, align 8
  %ok = alloca i32, align 4
  %u = alloca double, align 8
  %s = alloca double, align 8
  store double 0.000000e+00, ptr %s, align 8
  store double 0.000000e+00, ptr %u, align 8
  store i32 0, ptr %ok, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %ok1 = load i32, ptr %ok, align 4
  %1 = icmp eq i32 %ok1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %3 = call double @Random.nextDouble(ptr %0)
  %4 = fmul double 2.000000e+00, %3
  %5 = fsub double %4, 1.000000e+00
  store double %5, ptr %u, align 8
  %6 = call double @Random.nextDouble(ptr %0)
  %7 = fmul double 2.000000e+00, %6
  %8 = fsub double %7, 1.000000e+00
  store double %8, ptr %v, align 8
  %u2 = load double, ptr %u, align 8
  %u3 = load double, ptr %u, align 8
  %9 = fmul double %u2, %u3
  %v4 = load double, ptr %v, align 8
  %v5 = load double, ptr %v, align 8
  %10 = fmul double %v4, %v5
  %11 = fadd double %9, %10
  store double %11, ptr %s, align 8
  %s6 = load double, ptr %s, align 8
  %12 = fcmp olt double %s6, 1.000000e+00
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  %u10 = load double, ptr %u, align 8
  %s11 = load double, ptr %s, align 8
  %14 = call double @Random.lnD(ptr %0, double %s11)
  %15 = fmul double -2.000000e+00, %14
  %s12 = load double, ptr %s, align 8
  %16 = fdiv double %15, %s12
  %17 = call double @Random.sqrtD(ptr %0, double %16)
  %18 = fmul double %u10, %17
  ret double %18

if.then:                                          ; preds = %while.body
  %s7 = load double, ptr %s, align 8
  %19 = fcmp ogt double %s7, 0.000000e+00
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then8, label %if.end9

if.end:                                           ; preds = %if.end9, %while.body
  br label %while.cond

if.then8:                                         ; preds = %if.then
  store i32 1, ptr %ok, align 4
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.then
  br label %if.end
}

define internal double @Random.nextGaussianScaled(ptr nonnull align 8 dereferenceable(16) %0, double %1, double %2) {
entry:
  %stddev = alloca double, align 8
  %mean = alloca double, align 8
  store double %1, ptr %mean, align 8
  store double %2, ptr %stddev, align 8
  %mean1 = load double, ptr %mean, align 8
  %stddev2 = load double, ptr %stddev, align 8
  %3 = call double @Random.nextGaussian(ptr %0)
  %4 = fmul double %stddev2, %3
  %5 = fadd double %mean1, %4
  ret double %5
}

define internal ptr @Random.seededNow() {
entry:
  %Random.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Random, ptr null, i64 1) to i64))
  %0 = call i64 @__polaron_now_ns()
  call void @Random.Random(ptr %Random.obj, i64 %0)
  ret ptr %Random.obj
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i64 @__polaron_now_ns()

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i64", !2, i64 0}
