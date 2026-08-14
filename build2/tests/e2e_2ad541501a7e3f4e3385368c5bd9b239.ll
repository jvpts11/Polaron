; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/defer_within.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/defer_within.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Resource = type { ptr, i32, i32 }
%class.Duration = type { ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Resource.vtable = private constant [349 x ptr] [ptr @Resource.close, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Duration.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Duration.compareTo, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Duration.toMillis, ptr @Duration.toSeconds, ptr @Duration.plus, ptr @Duration.minus, ptr @"Duration.TComparer$lessThan", ptr @Duration.lessThan, ptr @"Duration.TComparer$atMost", ptr @Duration.atMost, ptr @"Duration.TComparer$greaterThan", ptr @Duration.greaterThan, ptr @"Duration.TComparer$atLeast", ptr @Duration.atLeast, ptr @"Duration.TComparer$sameOrder", ptr @Duration.sameOrder, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [11 x i8] c"closed %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"quick body\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"slow body\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.6 = private unnamed_addr constant [5 x i8] c"done\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1310 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1311 = private global %String { i64 16, ptr @.strdata.1310, i64 0 }
@.strdata.1312 = private constant [17 x i8] c"division by zero\00"
@.strobj.1313 = private global %String { i64 16, ptr @.strdata.1312, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }

define internal void @Resource.Resource(ptr %0, i32 %1, i32 %2) {
entry:
  %busyMs = alloca i32, align 4
  %id = alloca i32, align 4
  store i32 %1, ptr %id, align 4
  store i32 %2, ptr %busyMs, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Resource, ptr %0, i32 0, i32 0
  store ptr @Resource.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %id1 = getelementptr inbounds %class.Resource, ptr %0, i32 0, i32 1
  %id2 = load i32, ptr %id, align 4
  store i32 %id2, ptr %id1, align 4, !tbaa !4
  %busyMs3 = getelementptr inbounds %class.Resource, ptr %0, i32 0, i32 2
  %busyMs4 = load i32, ptr %busyMs, align 4
  store i32 %busyMs4, ptr %busyMs3, align 4, !tbaa !4
  ret void
}

define internal void @Resource.close(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %busyMs = getelementptr inbounds %class.Resource, ptr %0, i32 0, i32 2
  %busyMs1 = load i32, ptr %busyMs, align 4, !tbaa !4
  %1 = icmp sgt i32 %busyMs1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %busyMs2 = getelementptr inbounds %class.Resource, ptr %0, i32 0, i32 2
  %busyMs3 = load i32, ptr %busyMs2, align 4, !tbaa !4
  %3 = sext i32 %busyMs3 to i64
  call void @__polaron_sleep(i64 %3)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %id = getelementptr inbounds %class.Resource, ptr %0, i32 0, i32 1
  %id4 = load i32, ptr %id, align 4, !tbaa !4
  %4 = call i32 (ptr, ...) @printf(ptr @.str, i32 %id4)
  ret void
}

define internal void @Main.quick() {
entry:
  %r = alloca ptr, align 8
  %Resource.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Resource, ptr null, i64 1) to i64))
  call void @Resource.Resource(ptr %Resource.obj, i32 1, i32 0)
  store ptr %Resource.obj, ptr %r, align 8
  %0 = call ptr @Duration.ofMillis(i64 500)
  %it.vtbl.addr = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 0
  %it.vtbl = load ptr, ptr %it.vtbl.addr, align 8, !tbaa !0
  %it.slot = getelementptr [348 x ptr], ptr %it.vtbl, i64 0, i64 199
  %it.fn = load ptr, ptr %it.slot, align 8
  %1 = call i64 %it.fn(ptr %0)
  %2 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr @.str.2)
  %defer.t0 = call i64 @__polaron_now_ns()
  %r1 = load ptr, ptr %r, align 8
  call void @Resource.close(ptr %r1)
  %r2 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r2)
  %vtbl.addr = getelementptr inbounds %class.Resource, ptr %r2, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %3 = icmp ne ptr %dtor.fn, null
  br i1 %3, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %r2)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %r2)
  %defer.t1 = call i64 @__polaron_now_ns()
  %defer.ns = sub i64 %defer.t1, %defer.t0
  %defer.ms = sdiv i64 %defer.ns, 1000000
  %4 = icmp sgt i64 %defer.ms, %1
  br i1 %4, label %defer.over, label %defer.ok

defer.over:                                       ; preds = %dtor.free
  call void @__polaron_defer_overrun(i64 %1, i64 %defer.ms)
  br label %defer.ok

defer.ok:                                         ; preds = %defer.over, %dtor.free
  ret void
}

define internal void @Main.slow() {
entry:
  %r = alloca ptr, align 8
  %Resource.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Resource, ptr null, i64 1) to i64))
  call void @Resource.Resource(ptr %Resource.obj, i32 2, i32 40)
  store ptr %Resource.obj, ptr %r, align 8
  %0 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr @.str.4)
  %defer.t0 = call i64 @__polaron_now_ns()
  %r1 = load ptr, ptr %r, align 8
  call void @Resource.close(ptr %r1)
  %r2 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r2)
  %vtbl.addr = getelementptr inbounds %class.Resource, ptr %r2, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %1 = icmp ne ptr %dtor.fn, null
  br i1 %1, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %r2)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %r2)
  %defer.t1 = call i64 @__polaron_now_ns()
  %defer.ns = sub i64 %defer.t1, %defer.t0
  %defer.ms = sdiv i64 %defer.ns, 1000000
  %2 = icmp sgt i64 %defer.ms, 5
  br i1 %2, label %defer.over, label %defer.ok

defer.over:                                       ; preds = %dtor.free
  call void @__polaron_defer_overrun(i64 5, i64 %defer.ms)
  br label %defer.ok

defer.ok:                                         ; preds = %defer.over, %dtor.free
  ret void
}

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
  call void @Main.quick()
  call void @Main.slow()
  %16 = call i32 (ptr, ...) @printf(ptr @.str.5, ptr @.str.6)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1311)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1313)
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
  store i64 %millis1, ptr %ms, align 8, !tbaa !6
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
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
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

define internal i64 @Duration.toMillis(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
  ret i64 %ms1
}

define internal i64 @Duration.toSeconds(ptr nonnull align 8 dereferenceable(16) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
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
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
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
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
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

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare void @__polaron_sleep(i64)

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @__polaron_now_ns()

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare void @__polaron_defer_overrun(i64, i64)

declare i64 @strlen(ptr)

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
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
