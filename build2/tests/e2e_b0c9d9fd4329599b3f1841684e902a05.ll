; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_iterable.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_iterable.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Fib = type { ptr, i32, i32 }
%class.Countdown = type { ptr, i32 }
%class.CountdownIter = type { ptr, i32 }
%"class.Iterator$int" = type { ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@CountdownIter.vtable = private constant [349 x ptr] [ptr @CountdownIter.hasNext, ptr @CountdownIter.next, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Fib.vtable = private constant [349 x ptr] [ptr @Fib.hasNext, ptr @Fib.next, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Countdown.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr @Countdown.iterator, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [5 x i8] c"sum=\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c" prod=\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }

define internal void @Fib.Fib(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 0
  store ptr @Fib.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %a = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 1
  store i32 0, ptr %a, align 4, !tbaa !4
  %b = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 2
  store i32 1, ptr %b, align 4, !tbaa !4
  ret void
}

define internal i32 @Fib.hasNext(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret i32 1
}

define internal i32 @Fib.next(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %nb = alloca i32, align 4
  %cur = alloca i32, align 4
  %a = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 1
  %a1 = load i32, ptr %a, align 4, !tbaa !4
  store i32 %a1, ptr %cur, align 4
  %a2 = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 1
  %a3 = load i32, ptr %a2, align 4, !tbaa !4
  %b = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 2
  %b4 = load i32, ptr %b, align 4, !tbaa !4
  %1 = add i32 %a3, %b4
  store i32 %1, ptr %nb, align 4
  %a5 = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 1
  %b6 = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 2
  %b7 = load i32, ptr %b6, align 4, !tbaa !4
  store i32 %b7, ptr %a5, align 4, !tbaa !4
  %b8 = getelementptr inbounds %class.Fib, ptr %0, i32 0, i32 2
  %nb9 = load i32, ptr %nb, align 4
  store i32 %nb9, ptr %b8, align 4, !tbaa !4
  %cur10 = load i32, ptr %cur, align 4
  ret i32 %cur10
}

define internal void @Countdown.Countdown(ptr %0, i32 %1) {
entry:
  %from = alloca i32, align 4
  store i32 %1, ptr %from, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Countdown, ptr %0, i32 0, i32 0
  store ptr @Countdown.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %from1 = getelementptr inbounds %class.Countdown, ptr %0, i32 0, i32 1
  %from2 = load i32, ptr %from, align 4
  store i32 %from2, ptr %from1, align 4, !tbaa !4
  ret void
}

define internal ptr @Countdown.iterator(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %CountdownIter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.CountdownIter, ptr null, i64 1) to i64))
  %from = getelementptr inbounds %class.Countdown, ptr %0, i32 0, i32 1
  %from1 = load i32, ptr %from, align 4, !tbaa !4
  call void @CountdownIter.CountdownIter(ptr %CountdownIter.obj, i32 %from1)
  ret ptr %CountdownIter.obj
}

define internal void @CountdownIter.CountdownIter(ptr %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.CountdownIter, ptr %0, i32 0, i32 0
  store ptr @CountdownIter.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %n1 = getelementptr inbounds %class.CountdownIter, ptr %0, i32 0, i32 1
  %n2 = load i32, ptr %n, align 4
  store i32 %n2, ptr %n1, align 4, !tbaa !4
  ret void
}

define internal i32 @CountdownIter.hasNext(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %n = getelementptr inbounds %class.CountdownIter, ptr %0, i32 0, i32 1
  %n1 = load i32, ptr %n, align 4, !tbaa !4
  %1 = icmp sgt i32 %n1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal i32 @CountdownIter.next(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %cur = alloca i32, align 4
  %n = getelementptr inbounds %class.CountdownIter, ptr %0, i32 0, i32 1
  %n1 = load i32, ptr %n, align 4, !tbaa !4
  store i32 %n1, ptr %cur, align 4
  %n2 = getelementptr inbounds %class.CountdownIter, ptr %0, i32 0, i32 1
  %n3 = getelementptr inbounds %class.CountdownIter, ptr %0, i32 0, i32 1
  %n4 = load i32, ptr %n3, align 4, !tbaa !4
  %1 = sub i32 %n4, 1
  store i32 %1, ptr %n2, align 4, !tbaa !4
  %cur5 = load i32, ptr %cur, align 4
  ret i32 %cur5
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %fe.i16 = alloca i32, align 4
  %v15 = alloca i32, align 4
  %fe.it14 = alloca ptr, align 8
  %prod = alloca i32, align 4
  %c = alloca ptr, align 8
  %fe.i = alloca i32, align 4
  %v = alloca i32, align 4
  %fe.it = alloca ptr, align 8
  %sum = alloca i32, align 4
  %f = alloca ptr, align 8
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
  %Fib.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Fib, ptr null, i64 1) to i64))
  call void @Fib.Fib(ptr %Fib.obj)
  store ptr %Fib.obj, ptr %f, align 8
  store i32 0, ptr %sum, align 4
  %f1 = load ptr, ptr %f, align 8
  store ptr %f1, ptr %fe.it, align 8
  store i32 0, ptr %fe.i, align 4
  br label %fei.cond

fei.cond:                                         ; preds = %fei.update, %argv.end
  %fei.itv = load ptr, ptr %fe.it, align 8
  %it.vtbl.addr = getelementptr inbounds %class.Fib, ptr %fei.itv, i32 0, i32 0
  %it.vtbl = load ptr, ptr %it.vtbl.addr, align 8, !tbaa !0
  %it.slot = getelementptr [348 x ptr], ptr %it.vtbl, i64 0, i64 0
  %it.fn = load ptr, ptr %it.slot, align 8
  %16 = call i32 %it.fn(ptr %fei.itv)
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %fei.body, label %fei.end

fei.body:                                         ; preds = %fei.cond
  %fei.itv2 = load ptr, ptr %fe.it, align 8
  %it.vtbl.addr2 = getelementptr inbounds %class.Fib, ptr %fei.itv2, i32 0, i32 0
  %it.vtbl3 = load ptr, ptr %it.vtbl.addr2, align 8, !tbaa !0
  %it.slot4 = getelementptr [348 x ptr], ptr %it.vtbl3, i64 0, i64 1
  %it.fn5 = load ptr, ptr %it.slot4, align 8
  %18 = call i32 %it.fn5(ptr %fei.itv2)
  store i32 %18, ptr %v, align 4
  %v6 = load i32, ptr %v, align 4
  %19 = icmp sgt i32 %v6, 40
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

fei.update:                                       ; preds = %if.end
  %fei.iv = load i32, ptr %fe.i, align 4
  %21 = add i32 %fei.iv, 1
  store i32 %21, ptr %fe.i, align 4
  br label %fei.cond

fei.end:                                          ; preds = %if.then, %fei.cond
  %Countdown.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Countdown, ptr null, i64 1) to i64))
  call void @Countdown.Countdown(ptr %Countdown.obj, i32 4)
  store ptr %Countdown.obj, ptr %c, align 8
  store i32 1, ptr %prod, align 4
  %c9 = load ptr, ptr %c, align 8
  %it.vtbl.addr10 = getelementptr inbounds %class.Countdown, ptr %c9, i32 0, i32 0
  %it.vtbl11 = load ptr, ptr %it.vtbl.addr10, align 8, !tbaa !0
  %it.slot12 = getelementptr [348 x ptr], ptr %it.vtbl11, i64 0, i64 2
  %it.fn13 = load ptr, ptr %it.slot12, align 8
  %22 = call ptr %it.fn13(ptr %c9)
  store ptr %22, ptr %fe.it14, align 8
  store i32 0, ptr %fe.i16, align 4
  br label %fei.cond17

if.then:                                          ; preds = %fei.body
  br label %fei.end

if.end:                                           ; preds = %fei.body
  %sum7 = load i32, ptr %sum, align 4
  %v8 = load i32, ptr %v, align 4
  %23 = add i32 %sum7, %v8
  store i32 %23, ptr %sum, align 4
  br label %fei.update

fei.cond17:                                       ; preds = %fei.update19, %fei.end
  %fei.itv21 = load ptr, ptr %fe.it14, align 8
  %it.vtbl.addr22 = getelementptr inbounds %"class.Iterator$int", ptr %fei.itv21, i32 0, i32 0
  %it.vtbl23 = load ptr, ptr %it.vtbl.addr22, align 8, !tbaa !0
  %it.slot24 = getelementptr [348 x ptr], ptr %it.vtbl23, i64 0, i64 0
  %it.fn25 = load ptr, ptr %it.slot24, align 8
  %24 = call i32 %it.fn25(ptr %fei.itv21)
  %25 = icmp ne i32 %24, 0
  br i1 %25, label %fei.body18, label %fei.end20

fei.body18:                                       ; preds = %fei.cond17
  %fei.itv226 = load ptr, ptr %fe.it14, align 8
  %it.vtbl.addr27 = getelementptr inbounds %"class.Iterator$int", ptr %fei.itv226, i32 0, i32 0
  %it.vtbl28 = load ptr, ptr %it.vtbl.addr27, align 8, !tbaa !0
  %it.slot29 = getelementptr [348 x ptr], ptr %it.vtbl28, i64 0, i64 1
  %it.fn30 = load ptr, ptr %it.slot29, align 8
  %26 = call i32 %it.fn30(ptr %fei.itv226)
  store i32 %26, ptr %v15, align 4
  %prod31 = load i32, ptr %prod, align 4
  %v32 = load i32, ptr %v15, align 4
  %27 = mul i32 %prod31, %v32
  store i32 %27, ptr %prod, align 4
  br label %fei.update19

fei.update19:                                     ; preds = %fei.body18
  %fei.iv33 = load i32, ptr %fe.i16, align 4
  %28 = add i32 %fei.iv33, 1
  store i32 %28, ptr %fe.i16, align 4
  br label %fei.cond17

fei.end20:                                        ; preds = %fei.cond17
  %sum34 = load i32, ptr %sum, align 4
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %29 = sext i32 %sum34 to i64
  %30 = call i64 @__polaron_itoa(i64 %29, ptr %itoa.buf)
  %newstr35 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %31 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 0
  store i64 %30, ptr %31, align 8
  %32 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 1
  store ptr %itoa.buf, ptr %32, align 8
  %33 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 2
  store i64 0, ptr %33, align 8
  %len = load i64, ptr @.strobj, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 0
  %len36 = load i64, ptr %str.len, align 8
  %34 = add i64 %len, %len36
  %35 = add i64 %34, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %35)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %36 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 1
  %data37 = load ptr, ptr %str.data, align 8
  %37 = getelementptr i8, ptr %cat.buf, i64 %len
  %38 = call ptr @memcpy(ptr %37, ptr %data37, i64 %len36)
  %39 = getelementptr i8, ptr %cat.buf, i64 %34
  store i8 0, ptr %39, align 1
  %newstr38 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %40 = getelementptr inbounds %String, ptr %newstr38, i32 0, i32 0
  store i64 %34, ptr %40, align 8
  %41 = getelementptr inbounds %String, ptr %newstr38, i32 0, i32 1
  store ptr %cat.buf, ptr %41, align 8
  %42 = getelementptr inbounds %String, ptr %newstr38, i32 0, i32 2
  store i64 0, ptr %42, align 8
  %str.len39 = getelementptr inbounds %String, ptr %newstr38, i32 0, i32 0
  %len40 = load i64, ptr %str.len39, align 8
  %len41 = load i64, ptr @.strobj.2, align 8
  %43 = add i64 %len40, %len41
  %44 = add i64 %43, 1
  %cat.buf42 = call ptr @__polaron_malloc(i64 %44)
  %str.data43 = getelementptr inbounds %String, ptr %newstr38, i32 0, i32 1
  %data44 = load ptr, ptr %str.data43, align 8
  %45 = call ptr @memcpy(ptr %cat.buf42, ptr %data44, i64 %len40)
  %data45 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %46 = getelementptr i8, ptr %cat.buf42, i64 %len40
  %47 = call ptr @memcpy(ptr %46, ptr %data45, i64 %len41)
  %48 = getelementptr i8, ptr %cat.buf42, i64 %43
  store i8 0, ptr %48, align 1
  %newstr46 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %49 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 0
  store i64 %43, ptr %49, align 8
  %50 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 1
  store ptr %cat.buf42, ptr %50, align 8
  %51 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 2
  store i64 0, ptr %51, align 8
  %prod47 = load i32, ptr %prod, align 4
  %itoa.buf48 = call ptr @__polaron_malloc(i64 24)
  %52 = sext i32 %prod47 to i64
  %53 = call i64 @__polaron_itoa(i64 %52, ptr %itoa.buf48)
  %newstr49 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %54 = getelementptr inbounds %String, ptr %newstr49, i32 0, i32 0
  store i64 %53, ptr %54, align 8
  %55 = getelementptr inbounds %String, ptr %newstr49, i32 0, i32 1
  store ptr %itoa.buf48, ptr %55, align 8
  %56 = getelementptr inbounds %String, ptr %newstr49, i32 0, i32 2
  store i64 0, ptr %56, align 8
  %str.len50 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 0
  %len51 = load i64, ptr %str.len50, align 8
  %str.len52 = getelementptr inbounds %String, ptr %newstr49, i32 0, i32 0
  %len53 = load i64, ptr %str.len52, align 8
  %57 = add i64 %len51, %len53
  %58 = add i64 %57, 1
  %cat.buf54 = call ptr @__polaron_malloc(i64 %58)
  %str.data55 = getelementptr inbounds %String, ptr %newstr46, i32 0, i32 1
  %data56 = load ptr, ptr %str.data55, align 8
  %59 = call ptr @memcpy(ptr %cat.buf54, ptr %data56, i64 %len51)
  %str.data57 = getelementptr inbounds %String, ptr %newstr49, i32 0, i32 1
  %data58 = load ptr, ptr %str.data57, align 8
  %60 = getelementptr i8, ptr %cat.buf54, i64 %len51
  %61 = call ptr @memcpy(ptr %60, ptr %data58, i64 %len53)
  %62 = getelementptr i8, ptr %cat.buf54, i64 %57
  store i8 0, ptr %62, align 1
  %newstr59 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %63 = getelementptr inbounds %String, ptr %newstr59, i32 0, i32 0
  store i64 %57, ptr %63, align 8
  %64 = getelementptr inbounds %String, ptr %newstr59, i32 0, i32 1
  store ptr %cat.buf54, ptr %64, align 8
  %65 = getelementptr inbounds %String, ptr %newstr59, i32 0, i32 2
  store i64 0, ptr %65, align 8
  %str.data60 = getelementptr inbounds %String, ptr %newstr59, i32 0, i32 1
  %data61 = load ptr, ptr %str.data60, align 8
  %66 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data61)
  call void @__polaron_str_free(ptr %newstr35)
  call void @__polaron_str_free(ptr %newstr38)
  call void @__polaron_str_free(ptr %newstr46)
  call void @__polaron_str_free(ptr %newstr49)
  call void @__polaron_str_free(ptr %newstr59)
  %f62 = load ptr, ptr %f, align 8
  call void @__polaron_check_live(ptr %f62)
  %vtbl.addr = getelementptr inbounds %class.Fib, ptr %f62, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %67 = icmp ne ptr %dtor.fn, null
  br i1 %67, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %fei.end20
  call void %dtor.fn(ptr %f62)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %fei.end20
  call void @__polaron_free(ptr %f62)
  %c63 = load ptr, ptr %c, align 8
  call void @__polaron_check_live(ptr %c63)
  %vtbl.addr64 = getelementptr inbounds %class.Countdown, ptr %c63, i32 0, i32 0
  %vtbl65 = load ptr, ptr %vtbl.addr64, align 8, !tbaa !0
  %dtor.slot66 = getelementptr [349 x ptr], ptr %vtbl65, i64 0, i64 348
  %dtor.fn67 = load ptr, ptr %dtor.slot66, align 8
  %68 = icmp ne ptr %dtor.fn67, null
  br i1 %68, label %dtor.call68, label %dtor.free69

dtor.call68:                                      ; preds = %dtor.free
  call void %dtor.fn67(ptr %c63)
  br label %dtor.free69

dtor.free69:                                      ; preds = %dtor.call68, %dtor.free
  call void @__polaron_free(ptr %c63)
  %69 = load ptr, ptr %fe.it14, align 8
  call void @__polaron_check_live(ptr %69)
  %vtbl.addr70 = getelementptr inbounds %"class.Iterator$int", ptr %69, i32 0, i32 0
  %vtbl71 = load ptr, ptr %vtbl.addr70, align 8, !tbaa !0
  %dtor.slot72 = getelementptr [349 x ptr], ptr %vtbl71, i64 0, i64 348
  %dtor.fn73 = load ptr, ptr %dtor.slot72, align 8
  %70 = icmp ne ptr %dtor.fn73, null
  br i1 %70, label %dtor.call74, label %dtor.free75

dtor.call74:                                      ; preds = %dtor.free69
  call void %dtor.fn73(ptr %69)
  br label %dtor.free75

dtor.free75:                                      ; preds = %dtor.call74, %dtor.free69
  call void @__polaron_free(ptr %69)
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

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i64 @__polaron_itoa(i64, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
