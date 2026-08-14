; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_parse.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_parse.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Planet = type { ptr, i32, i32 }
%class.DivideByZeroException = type { ptr }
%__polaron_variant = type { i32, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Planet.vtable = private constant [350 x ptr] [ptr @Planet.density, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata = private constant [6 x i8] c"GREEN\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c"RED\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [6 x i8] c"GREEN\00"
@.strobj.4 = private global %String { i64 5, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [5 x i8] c"BLUE\00"
@.strobj.6 = private global %String { i64 4, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [7 x i8] c"PURPLE\00"
@.strobj.8 = private global %String { i64 6, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [4 x i8] c"RED\00"
@.strobj.10 = private global %String { i64 3, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [6 x i8] c"GREEN\00"
@.strobj.12 = private global %String { i64 5, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [5 x i8] c"BLUE\00"
@.strobj.14 = private global %String { i64 4, ptr @.strdata.13, i64 0 }
@.strdata.15 = private constant [5 x i8] c"MARS\00"
@.strobj.16 = private global %String { i64 4, ptr @.strdata.15, i64 0 }
@.strdata.17 = private constant [6 x i8] c"EARTH\00"
@.strobj.18 = private global %String { i64 5, ptr @.strdata.17, i64 0 }
@Planet.EARTH.__inst = private global ptr null
@.strdata.19 = private constant [5 x i8] c"MARS\00"
@.strobj.20 = private global %String { i64 4, ptr @.strdata.19, i64 0 }
@Planet.MARS.__inst = private global ptr null
@.strdata.21 = private constant [6 x i8] c"PLUTO\00"
@.strobj.22 = private global %String { i64 5, ptr @.strdata.21, i64 0 }
@.strdata.23 = private constant [6 x i8] c"EARTH\00"
@.strobj.24 = private global %String { i64 5, ptr @.strdata.23, i64 0 }
@.strdata.25 = private constant [5 x i8] c"MARS\00"
@.strobj.26 = private global %String { i64 4, ptr @.strdata.25, i64 0 }
@.str = private unnamed_addr constant [30 x i8] c"r1=%d r2=%d mars=%d pluto=%d\0A\00", align 1
@.strdata.1332 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1333 = private global %String { i64 16, ptr @.strdata.1332, i64 0 }
@.strdata.1334 = private constant [17 x i8] c"division by zero\00"
@.strobj.1335 = private global %String { i64 16, ptr @.strdata.1334, i64 0 }
@.strdata.5333 = private constant [1 x i8] zeroinitializer
@.strobj.5334 = private global %String { i64 0, ptr @.strdata.5333, i64 0 }
@.strdata.5335 = private constant [1 x i8] zeroinitializer
@.strobj.5336 = private global %String { i64 0, ptr @.strdata.5335, i64 0 }

define internal void @Planet.Planet(ptr %0, i32 %1, i32 %2) {
entry:
  %radius = alloca i32, align 4
  %mass = alloca i32, align 4
  store i32 %1, ptr %mass, align 4
  store i32 %2, ptr %radius, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Planet, ptr %0, i32 0, i32 0
  store ptr @Planet.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %mass1 = getelementptr inbounds %class.Planet, ptr %0, i32 0, i32 1
  %mass2 = load i32, ptr %mass, align 4
  store i32 %mass2, ptr %mass1, align 4, !tbaa !4
  %radius3 = getelementptr inbounds %class.Planet, ptr %0, i32 0, i32 2
  %radius4 = load i32, ptr %radius, align 4
  store i32 %radius4, ptr %radius3, align 4, !tbaa !4
  ret void
}

define internal i32 @Planet.density(ptr nonnull align 8 dereferenceable(16) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %mass = getelementptr inbounds %class.Planet, ptr %0, i32 0, i32 1
  %mass1 = load i32, ptr %mass, align 4, !tbaa !4
  %radius = getelementptr inbounds %class.Planet, ptr %0, i32 0, i32 2
  %radius2 = load i32, ptr %radius, align 4, !tbaa !4
  %1 = icmp eq i32 %radius2, 0
  %2 = icmp eq i32 %mass1, -2147483648
  %3 = icmp eq i32 %radius2, -1
  %4 = and i1 %2, %3
  %5 = or i1 %1, %4
  br i1 %5, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %6 = sdiv i32 %mass1, %radius2
  ret i32 %6
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %pluto = alloca i32, align 4
  %p108 = alloca ptr, align 8
  %parse.opt77 = alloca %__polaron_variant, align 8
  %mars = alloca i32, align 4
  %p = alloca ptr, align 8
  %parse.opt46 = alloca %__polaron_variant, align 8
  %r2 = alloca i32, align 4
  %c38 = alloca i32, align 4
  %b = alloca %__polaron_variant, align 8
  %parse.opt16 = alloca %__polaron_variant, align 8
  %r1 = alloca i32, align 4
  %c = alloca i32, align 4
  %a = alloca %__polaron_variant, align 8
  %parse.opt = alloca %__polaron_variant, align 8
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
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %data1 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %parse.cmp = call i32 @strcmp(ptr %data, ptr %data1)
  %16 = icmp eq i32 %parse.cmp, 0
  br i1 %16, label %parse.some, label %parse.next

parse.done:                                       ; preds = %parse.next9, %parse.some8, %parse.some4, %parse.some
  %parse.result = load %__polaron_variant, ptr %parse.opt, align 8
  store %__polaron_variant %parse.result, ptr %a, align 8
  %a10 = load %__polaron_variant, ptr %a, align 8
  %var.tag = extractvalue %__polaron_variant %a10, 0
  %var.pl = extractvalue %__polaron_variant %a10, 1
  %is = icmp eq i32 %var.tag, 0
  br i1 %is, label %matchx.case, label %matchx.next

parse.some:                                       ; preds = %argv.end
  store %__polaron_variant zeroinitializer, ptr %parse.opt, align 8
  br label %parse.done

parse.next:                                       ; preds = %argv.end
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %parse.cmp3 = call i32 @strcmp(ptr %data, ptr %data2)
  %17 = icmp eq i32 %parse.cmp3, 0
  br i1 %17, label %parse.some4, label %parse.next5

parse.some4:                                      ; preds = %parse.next
  store %__polaron_variant { i32 0, i64 1 }, ptr %parse.opt, align 8
  br label %parse.done

parse.next5:                                      ; preds = %parse.next
  %data6 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %parse.cmp7 = call i32 @strcmp(ptr %data, ptr %data6)
  %18 = icmp eq i32 %parse.cmp7, 0
  br i1 %18, label %parse.some8, label %parse.next9

parse.some8:                                      ; preds = %parse.next5
  store %__polaron_variant { i32 0, i64 2 }, ptr %parse.opt, align 8
  br label %parse.done

parse.next9:                                      ; preds = %parse.next5
  store %__polaron_variant { i32 1, i64 0 }, ptr %parse.opt, align 8
  br label %parse.done

matchx.end:                                       ; preds = %matchx.case12, %matchx.case
  %matchx = phi i32 [ %c11, %matchx.case ], [ -1, %matchx.case12 ]
  store i32 %matchx, ptr %r1, align 4
  %data15 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.8, i32 0, i32 1), align 8
  %data18 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.10, i32 0, i32 1), align 8
  %parse.cmp19 = call i32 @strcmp(ptr %data15, ptr %data18)
  %19 = icmp eq i32 %parse.cmp19, 0
  br i1 %19, label %parse.some20, label %parse.next21

matchx.case:                                      ; preds = %parse.done
  %var.dec.i = trunc i64 %var.pl to i32
  store i32 %var.dec.i, ptr %c, align 4
  %c11 = load i32, ptr %c, align 4
  br label %matchx.end

matchx.next:                                      ; preds = %parse.done
  %is14 = icmp eq i32 %var.tag, 1
  br i1 %is14, label %matchx.case12, label %matchx.next13

matchx.case12:                                    ; preds = %matchx.next
  br label %matchx.end

matchx.next13:                                    ; preds = %matchx.next
  unreachable

parse.done17:                                     ; preds = %parse.next29, %parse.some28, %parse.some24, %parse.some20
  %parse.result30 = load %__polaron_variant, ptr %parse.opt16, align 8
  store %__polaron_variant %parse.result30, ptr %b, align 8
  %b31 = load %__polaron_variant, ptr %b, align 8
  %var.tag32 = extractvalue %__polaron_variant %b31, 0
  %var.pl33 = extractvalue %__polaron_variant %b31, 1
  %is37 = icmp eq i32 %var.tag32, 0
  br i1 %is37, label %matchx.case35, label %matchx.next36

parse.some20:                                     ; preds = %matchx.end
  store %__polaron_variant zeroinitializer, ptr %parse.opt16, align 8
  br label %parse.done17

parse.next21:                                     ; preds = %matchx.end
  %data22 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.12, i32 0, i32 1), align 8
  %parse.cmp23 = call i32 @strcmp(ptr %data15, ptr %data22)
  %20 = icmp eq i32 %parse.cmp23, 0
  br i1 %20, label %parse.some24, label %parse.next25

parse.some24:                                     ; preds = %parse.next21
  store %__polaron_variant { i32 0, i64 1 }, ptr %parse.opt16, align 8
  br label %parse.done17

parse.next25:                                     ; preds = %parse.next21
  %data26 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.14, i32 0, i32 1), align 8
  %parse.cmp27 = call i32 @strcmp(ptr %data15, ptr %data26)
  %21 = icmp eq i32 %parse.cmp27, 0
  br i1 %21, label %parse.some28, label %parse.next29

parse.some28:                                     ; preds = %parse.next25
  store %__polaron_variant { i32 0, i64 2 }, ptr %parse.opt16, align 8
  br label %parse.done17

parse.next29:                                     ; preds = %parse.next25
  store %__polaron_variant { i32 1, i64 0 }, ptr %parse.opt16, align 8
  br label %parse.done17

matchx.end34:                                     ; preds = %matchx.case41, %matchx.case35
  %matchx44 = phi i32 [ %c40, %matchx.case35 ], [ -1, %matchx.case41 ]
  store i32 %matchx44, ptr %r2, align 4
  %data45 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.16, i32 0, i32 1), align 8
  %data48 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.18, i32 0, i32 1), align 8
  %parse.cmp49 = call i32 @strcmp(ptr %data45, ptr %data48)
  %22 = icmp eq i32 %parse.cmp49, 0
  br i1 %22, label %parse.some50, label %parse.next51

matchx.case35:                                    ; preds = %parse.done17
  %var.dec.i39 = trunc i64 %var.pl33 to i32
  store i32 %var.dec.i39, ptr %c38, align 4
  %c40 = load i32, ptr %c38, align 4
  br label %matchx.end34

matchx.next36:                                    ; preds = %parse.done17
  %is43 = icmp eq i32 %var.tag32, 1
  br i1 %is43, label %matchx.case41, label %matchx.next42

matchx.case41:                                    ; preds = %matchx.next36
  br label %matchx.end34

matchx.next42:                                    ; preds = %matchx.next36
  unreachable

parse.done47:                                     ; preds = %parse.next56, %enumc.done59, %enumc.done
  %parse.result64 = load %__polaron_variant, ptr %parse.opt46, align 8
  %var.tag65 = extractvalue %__polaron_variant %parse.result64, 0
  %var.pl66 = extractvalue %__polaron_variant %parse.result64, 1
  %is70 = icmp eq i32 %var.tag65, 0
  br i1 %is70, label %matchx.case68, label %matchx.next69

parse.some50:                                     ; preds = %matchx.end34
  %enum.cur = load ptr, ptr @Planet.EARTH.__inst, align 8
  %23 = icmp eq ptr %enum.cur, null
  br i1 %23, label %enumc.init, label %enumc.done

parse.next51:                                     ; preds = %matchx.end34
  %data53 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.20, i32 0, i32 1), align 8
  %parse.cmp54 = call i32 @strcmp(ptr %data45, ptr %data53)
  %24 = icmp eq i32 %parse.cmp54, 0
  br i1 %24, label %parse.some55, label %parse.next56

enumc.init:                                       ; preds = %parse.some50
  %Planet = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Planet, ptr null, i64 1) to i64))
  call void @Planet.Planet(ptr %Planet, i32 10, i32 2)
  store ptr %Planet, ptr @Planet.EARTH.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %parse.some50
  %Planet52 = load ptr, ptr @Planet.EARTH.__inst, align 8
  %var.enc.p = ptrtoint ptr %Planet52 to i64
  %some.singleton = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  store %__polaron_variant %some.singleton, ptr %parse.opt46, align 8
  br label %parse.done47

parse.some55:                                     ; preds = %parse.next51
  %enum.cur57 = load ptr, ptr @Planet.MARS.__inst, align 8
  %25 = icmp eq ptr %enum.cur57, null
  br i1 %25, label %enumc.init58, label %enumc.done59

parse.next56:                                     ; preds = %parse.next51
  store %__polaron_variant { i32 1, i64 0 }, ptr %parse.opt46, align 8
  br label %parse.done47

enumc.init58:                                     ; preds = %parse.some55
  %Planet60 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Planet, ptr null, i64 1) to i64))
  call void @Planet.Planet(ptr %Planet60, i32 30, i32 3)
  store ptr %Planet60, ptr @Planet.MARS.__inst, align 8
  br label %enumc.done59

enumc.done59:                                     ; preds = %enumc.init58, %parse.some55
  %Planet61 = load ptr, ptr @Planet.MARS.__inst, align 8
  %var.enc.p62 = ptrtoint ptr %Planet61 to i64
  %some.singleton63 = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p62, 1
  store %__polaron_variant %some.singleton63, ptr %parse.opt46, align 8
  br label %parse.done47

matchx.end67:                                     ; preds = %matchx.case72, %matchx.case68
  %matchx75 = phi i32 [ %27, %matchx.case68 ], [ -1, %matchx.case72 ]
  store i32 %matchx75, ptr %mars, align 4
  %data76 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.22, i32 0, i32 1), align 8
  %data79 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.24, i32 0, i32 1), align 8
  %parse.cmp80 = call i32 @strcmp(ptr %data76, ptr %data79)
  %26 = icmp eq i32 %parse.cmp80, 0
  br i1 %26, label %parse.some81, label %parse.next82

matchx.case68:                                    ; preds = %parse.done47
  %var.dec.p = inttoptr i64 %var.pl66 to ptr
  store ptr %var.dec.p, ptr %p, align 8
  %p71 = load ptr, ptr %p, align 8
  %27 = call i32 @Planet.density(ptr %p71)
  br label %matchx.end67

matchx.next69:                                    ; preds = %parse.done47
  %is74 = icmp eq i32 %var.tag65, 1
  br i1 %is74, label %matchx.case72, label %matchx.next73

matchx.case72:                                    ; preds = %matchx.next69
  br label %matchx.end67

matchx.next73:                                    ; preds = %matchx.next69
  unreachable

parse.done78:                                     ; preds = %parse.next93, %enumc.done96, %enumc.done85
  %parse.result101 = load %__polaron_variant, ptr %parse.opt77, align 8
  %var.tag102 = extractvalue %__polaron_variant %parse.result101, 0
  %var.pl103 = extractvalue %__polaron_variant %parse.result101, 1
  %is107 = icmp eq i32 %var.tag102, 0
  br i1 %is107, label %matchx.case105, label %matchx.next106

parse.some81:                                     ; preds = %matchx.end67
  %enum.cur83 = load ptr, ptr @Planet.EARTH.__inst, align 8
  %28 = icmp eq ptr %enum.cur83, null
  br i1 %28, label %enumc.init84, label %enumc.done85

parse.next82:                                     ; preds = %matchx.end67
  %data90 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.26, i32 0, i32 1), align 8
  %parse.cmp91 = call i32 @strcmp(ptr %data76, ptr %data90)
  %29 = icmp eq i32 %parse.cmp91, 0
  br i1 %29, label %parse.some92, label %parse.next93

enumc.init84:                                     ; preds = %parse.some81
  %Planet86 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Planet, ptr null, i64 1) to i64))
  call void @Planet.Planet(ptr %Planet86, i32 10, i32 2)
  store ptr %Planet86, ptr @Planet.EARTH.__inst, align 8
  br label %enumc.done85

enumc.done85:                                     ; preds = %enumc.init84, %parse.some81
  %Planet87 = load ptr, ptr @Planet.EARTH.__inst, align 8
  %var.enc.p88 = ptrtoint ptr %Planet87 to i64
  %some.singleton89 = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p88, 1
  store %__polaron_variant %some.singleton89, ptr %parse.opt77, align 8
  br label %parse.done78

parse.some92:                                     ; preds = %parse.next82
  %enum.cur94 = load ptr, ptr @Planet.MARS.__inst, align 8
  %30 = icmp eq ptr %enum.cur94, null
  br i1 %30, label %enumc.init95, label %enumc.done96

parse.next93:                                     ; preds = %parse.next82
  store %__polaron_variant { i32 1, i64 0 }, ptr %parse.opt77, align 8
  br label %parse.done78

enumc.init95:                                     ; preds = %parse.some92
  %Planet97 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Planet, ptr null, i64 1) to i64))
  call void @Planet.Planet(ptr %Planet97, i32 30, i32 3)
  store ptr %Planet97, ptr @Planet.MARS.__inst, align 8
  br label %enumc.done96

enumc.done96:                                     ; preds = %enumc.init95, %parse.some92
  %Planet98 = load ptr, ptr @Planet.MARS.__inst, align 8
  %var.enc.p99 = ptrtoint ptr %Planet98 to i64
  %some.singleton100 = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p99, 1
  store %__polaron_variant %some.singleton100, ptr %parse.opt77, align 8
  br label %parse.done78

matchx.end104:                                    ; preds = %matchx.case111, %matchx.case105
  %matchx114 = phi i32 [ %32, %matchx.case105 ], [ -1, %matchx.case111 ]
  store i32 %matchx114, ptr %pluto, align 4
  %r1115 = load i32, ptr %r1, align 4
  %r2116 = load i32, ptr %r2, align 4
  %mars117 = load i32, ptr %mars, align 4
  %pluto118 = load i32, ptr %pluto, align 4
  %31 = call i32 (ptr, ...) @printf(ptr @.str, i32 %r1115, i32 %r2116, i32 %mars117, i32 %pluto118)
  ret i32 0

matchx.case105:                                   ; preds = %parse.done78
  %var.dec.p109 = inttoptr i64 %var.pl103 to ptr
  store ptr %var.dec.p109, ptr %p108, align 8
  %p110 = load ptr, ptr %p108, align 8
  %32 = call i32 @Planet.density(ptr %p110)
  br label %matchx.end104

matchx.next106:                                   ; preds = %parse.done78
  %is113 = icmp eq i32 %var.tag102, 1
  br i1 %is113, label %matchx.case111, label %matchx.next112

matchx.case111:                                   ; preds = %matchx.next106
  br label %matchx.end104

matchx.next112:                                   ; preds = %matchx.next106
  unreachable
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1333)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1335)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5334)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5336)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare i64 @strlen(ptr)

declare i32 @strcmp(ptr, ptr)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
