; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/resilience.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/resilience.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.CircuitBreaker = type { ptr, i32, i32, i32, i64, i64 }
%class.TokenBucket = type { ptr, double, double, double, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@CircuitBreaker.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @CircuitBreaker.allow, ptr @CircuitBreaker.recordSuccess, ptr @CircuitBreaker.recordFailure, ptr @CircuitBreaker.getState, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@TokenBucket.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @TokenBucket.tryAcquire, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [51 x i8] c"open=%d blocked=%d half=%d halfstate=%d closed=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"acquired=%d empty=%d refilled=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %refilled = alloca i32, align 4
  %empty = alloca i32, align 4
  %i = alloca i32, align 4
  %ok = alloca i32, align 4
  %tb = alloca ptr, align 8
  %s2 = alloca i32, align 4
  %half = alloca i32, align 4
  %blocked = alloca i32, align 4
  %cb = alloca ptr, align 8
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
  %CircuitBreaker.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.CircuitBreaker, ptr null, i64 1) to i64))
  call void @CircuitBreaker.CircuitBreaker(ptr %CircuitBreaker.obj, i32 2, i64 100)
  store ptr %CircuitBreaker.obj, ptr %cb, align 8
  %cb1 = load ptr, ptr %cb, align 8
  call void @CircuitBreaker.recordFailure(ptr %cb1, i64 0)
  %cb2 = load ptr, ptr %cb, align 8
  call void @CircuitBreaker.recordFailure(ptr %cb2, i64 0)
  %cb3 = load ptr, ptr %cb, align 8
  %16 = call i32 @CircuitBreaker.allow(ptr %cb3, i64 50)
  store i32 %16, ptr %blocked, align 4
  %cb4 = load ptr, ptr %cb, align 8
  %17 = call i32 @CircuitBreaker.allow(ptr %cb4, i64 100)
  store i32 %17, ptr %half, align 4
  %cb5 = load ptr, ptr %cb, align 8
  %18 = call i32 @CircuitBreaker.getState(ptr %cb5)
  store i32 %18, ptr %s2, align 4
  %cb6 = load ptr, ptr %cb, align 8
  call void @CircuitBreaker.recordSuccess(ptr %cb6)
  %blocked7 = load i32, ptr %blocked, align 4
  %half8 = load i32, ptr %half, align 4
  %s29 = load i32, ptr %s2, align 4
  %cb10 = load ptr, ptr %cb, align 8
  %19 = call i32 @CircuitBreaker.getState(ptr %cb10)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 1, i32 %blocked7, i32 %half8, i32 %s29, i32 %19)
  %TokenBucket.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.TokenBucket, ptr null, i64 1) to i64))
  call void @TokenBucket.TokenBucket(ptr %TokenBucket.obj, double 5.000000e+00, double 1.000000e-03)
  store ptr %TokenBucket.obj, ptr %tb, align 8
  store i32 0, ptr %ok, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i11 = load i32, ptr %i, align 4
  %21 = icmp slt i32 %i11, 5
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %tb12 = load ptr, ptr %tb, align 8
  %23 = call i32 @TokenBucket.tryAcquire(ptr %tb12, i64 0, i32 1)
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %if.then, label %if.end

for.update:                                       ; preds = %if.end
  %25 = load i32, ptr %i, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %tb14 = load ptr, ptr %tb, align 8
  %27 = call i32 @TokenBucket.tryAcquire(ptr %tb14, i64 0, i32 1)
  store i32 %27, ptr %empty, align 4
  %tb15 = load ptr, ptr %tb, align 8
  %28 = call i32 @TokenBucket.tryAcquire(ptr %tb15, i64 1000, i32 1)
  store i32 %28, ptr %refilled, align 4
  %ok16 = load i32, ptr %ok, align 4
  %empty17 = load i32, ptr %empty, align 4
  %refilled18 = load i32, ptr %refilled, align 4
  %29 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %ok16, i32 %empty17, i32 %refilled18)
  ret i32 0

if.then:                                          ; preds = %for.body
  %ok13 = load i32, ptr %ok, align 4
  %30 = add i32 %ok13, 1
  store i32 %30, ptr %ok, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  br label %for.update
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

define internal void @CircuitBreaker.CircuitBreaker(ptr %0, i32 %1, i64 %2) {
entry:
  %cooldownMs = alloca i64, align 8
  %threshold = alloca i32, align 4
  store i32 %1, ptr %threshold, align 4
  store i64 %2, ptr %cooldownMs, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 0
  store ptr @CircuitBreaker.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %st = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 1
  store i32 0, ptr %st, align 4, !tbaa !4
  %failures = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 2
  store i32 0, ptr %failures, align 4, !tbaa !4
  %threshold1 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 3
  %threshold2 = load i32, ptr %threshold, align 4
  store i32 %threshold2, ptr %threshold1, align 4, !tbaa !4
  %openUntil = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 4
  store i64 0, ptr %openUntil, align 8, !tbaa !6
  %cooldownMs3 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 5
  %cooldownMs4 = load i64, ptr %cooldownMs, align 8
  store i64 %cooldownMs4, ptr %cooldownMs3, align 8, !tbaa !6
  ret void
}

define internal i32 @CircuitBreaker.allow(ptr nonnull align 8 dereferenceable(40) %0, i64 %1) {
entry:
  %now = alloca i64, align 8
  store i64 %1, ptr %now, align 8
  %st = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 1
  %st1 = load i32, ptr %st, align 4, !tbaa !4
  %2 = icmp eq i32 %st1, 1
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %now2 = load i64, ptr %now, align 8
  %openUntil = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 4
  %openUntil3 = load i64, ptr %openUntil, align 8, !tbaa !6
  %4 = icmp sge i64 %now2, %openUntil3
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then4, label %if.end5

if.end:                                           ; preds = %entry
  ret i32 1

if.then4:                                         ; preds = %if.then
  %st6 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 1
  store i32 2, ptr %st6, align 4, !tbaa !4
  ret i32 1

if.end5:                                          ; preds = %if.then
  ret i32 0
}

define internal void @CircuitBreaker.recordSuccess(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %st = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 1
  store i32 0, ptr %st, align 4, !tbaa !4
  %failures = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 2
  store i32 0, ptr %failures, align 4, !tbaa !4
  ret void
}

define internal void @CircuitBreaker.recordFailure(ptr nonnull align 8 dereferenceable(40) %0, i64 %1) {
entry:
  %now = alloca i64, align 8
  store i64 %1, ptr %now, align 8
  %failures = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 2
  %failures1 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 2
  %failures2 = load i32, ptr %failures1, align 4, !tbaa !4
  %2 = add i32 %failures2, 1
  store i32 %2, ptr %failures, align 4, !tbaa !4
  %st = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 1
  %st3 = load i32, ptr %st, align 4, !tbaa !4
  %3 = icmp eq i32 %st3, 2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %st4 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 1
  store i32 1, ptr %st4, align 4, !tbaa !4
  %openUntil = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 4
  %now5 = load i64, ptr %now, align 8
  %cooldownMs = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 5
  %cooldownMs6 = load i64, ptr %cooldownMs, align 8, !tbaa !6
  %5 = add i64 %now5, %cooldownMs6
  store i64 %5, ptr %openUntil, align 8, !tbaa !6
  ret void

if.end:                                           ; preds = %entry
  %failures7 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 2
  %failures8 = load i32, ptr %failures7, align 4, !tbaa !4
  %threshold = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 3
  %threshold9 = load i32, ptr %threshold, align 4, !tbaa !4
  %6 = icmp sge i32 %failures8, %threshold9
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then10, label %if.end11

if.then10:                                        ; preds = %if.end
  %st12 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 1
  store i32 1, ptr %st12, align 4, !tbaa !4
  %openUntil13 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 4
  %now14 = load i64, ptr %now, align 8
  %cooldownMs15 = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 5
  %cooldownMs16 = load i64, ptr %cooldownMs15, align 8, !tbaa !6
  %8 = add i64 %now14, %cooldownMs16
  store i64 %8, ptr %openUntil13, align 8, !tbaa !6
  br label %if.end11

if.end11:                                         ; preds = %if.then10, %if.end
  ret void
}

define internal i32 @CircuitBreaker.getState(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %st = getelementptr inbounds %class.CircuitBreaker, ptr %0, i32 0, i32 1
  %st1 = load i32, ptr %st, align 4, !tbaa !4
  ret i32 %st1
}

define internal void @TokenBucket.TokenBucket(ptr %0, double %1, double %2) {
entry:
  %ratePerMs = alloca double, align 8
  %capacity = alloca double, align 8
  store double %1, ptr %capacity, align 8
  store double %2, ptr %ratePerMs, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 0
  store ptr @TokenBucket.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %tokens = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 1
  %capacity1 = load double, ptr %capacity, align 8
  store double %capacity1, ptr %tokens, align 8, !tbaa !8
  %capacity2 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 2
  %capacity3 = load double, ptr %capacity, align 8
  store double %capacity3, ptr %capacity2, align 8, !tbaa !8
  %ratePerMs4 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 3
  %ratePerMs5 = load double, ptr %ratePerMs, align 8
  store double %ratePerMs5, ptr %ratePerMs4, align 8, !tbaa !8
  %last = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 4
  store i64 0, ptr %last, align 8, !tbaa !6
  ret void
}

define internal i32 @TokenBucket.tryAcquire(ptr nonnull align 8 dereferenceable(40) %0, i64 %1, i32 %2) {
entry:
  %elapsed = alloca double, align 8
  %count = alloca i32, align 4
  %now = alloca i64, align 8
  store i64 %1, ptr %now, align 8
  store i32 %2, ptr %count, align 4
  %now1 = load i64, ptr %now, align 8
  %last = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 4
  %last2 = load i64, ptr %last, align 8, !tbaa !6
  %3 = sub i64 %now1, %last2
  %4 = sitofp i64 %3 to double
  store double %4, ptr %elapsed, align 8
  %tokens = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 1
  %tokens3 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 1
  %tokens4 = load double, ptr %tokens3, align 8, !tbaa !8
  %elapsed5 = load double, ptr %elapsed, align 8
  %ratePerMs = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 3
  %ratePerMs6 = load double, ptr %ratePerMs, align 8, !tbaa !8
  %5 = fmul double %elapsed5, %ratePerMs6
  %6 = fadd double %tokens4, %5
  store double %6, ptr %tokens, align 8, !tbaa !8
  %tokens7 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 1
  %tokens8 = load double, ptr %tokens7, align 8, !tbaa !8
  %capacity = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 2
  %capacity9 = load double, ptr %capacity, align 8, !tbaa !8
  %7 = fcmp ogt double %tokens8, %capacity9
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %tokens10 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 1
  %capacity11 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 2
  %capacity12 = load double, ptr %capacity11, align 8, !tbaa !8
  store double %capacity12, ptr %tokens10, align 8, !tbaa !8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %last13 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 4
  %now14 = load i64, ptr %now, align 8
  store i64 %now14, ptr %last13, align 8, !tbaa !6
  %tokens15 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 1
  %tokens16 = load double, ptr %tokens15, align 8, !tbaa !8
  %count17 = load i32, ptr %count, align 4
  %9 = sitofp i32 %count17 to double
  %10 = fcmp oge double %tokens16, %9
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then18, label %if.end19

if.then18:                                        ; preds = %if.end
  %tokens20 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 1
  %tokens21 = getelementptr inbounds %class.TokenBucket, ptr %0, i32 0, i32 1
  %tokens22 = load double, ptr %tokens21, align 8, !tbaa !8
  %count23 = load i32, ptr %count, align 4
  %12 = sitofp i32 %count23 to double
  %13 = fsub double %tokens22, %12
  store double %13, ptr %tokens20, align 8, !tbaa !8
  ret i32 1

if.end19:                                         ; preds = %if.end
  ret i32 0
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
!8 = !{!9, !9, i64 0}
!9 = !{!"f64", !2, i64 0}
