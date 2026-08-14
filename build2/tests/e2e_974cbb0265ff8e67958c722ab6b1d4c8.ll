; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_value.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_value.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Range = type { ptr, i32, i32, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Range.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr @Range.toArray, ptr @Range.size, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Range.contains, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Range.inRange, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [21 x i8] c"size=%d c6=%d c5=%d\0A\00", align 1
@.fail = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/range_value.pol:16:17  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1
@.fail.1483 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1716:50  in Range.toArray\0A\00", align 1
@.faila.1484 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1485 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %x = alloca i32, align 4
  %fe.i = alloca i32, align 4
  %sum = alloca i32, align 4
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
  %range = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Range, ptr null, i64 1) to i64))
  call void @Range.Range(ptr %range, i32 0, i32 10, i32 2, i32 0)
  store ptr %range, ptr %r, align 8
  %r1 = load ptr, ptr %r, align 8
  %16 = call i32 @Range.size(ptr %r1)
  %r2 = load ptr, ptr %r, align 8
  %17 = call i32 @Range.contains(ptr %r2, i32 6)
  %r3 = load ptr, ptr %r, align 8
  %18 = call i32 @Range.contains(ptr %r3, i32 5)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18)
  store i32 0, ptr %sum, align 4
  %r4 = load ptr, ptr %r, align 8
  %fe.arr = call ptr @Range.toArray(ptr %r4)
  %fe.len = load i64, ptr %fe.arr, align 8
  %fe.len32 = trunc i64 %fe.len to i32
  store i32 0, ptr %fe.i, align 4
  br label %fe.cond

fe.cond:                                          ; preds = %fe.update, %argv.end
  %fe.iv = load i32, ptr %fe.i, align 4
  %20 = icmp slt i32 %fe.iv, %fe.len32
  br i1 %20, label %fe.body, label %fe.end

fe.body:                                          ; preds = %fe.cond
  %21 = sext i32 %fe.iv to i64
  %arr.len = load i64, ptr %fe.arr, align 8
  %arr.oob = icmp uge i64 %21, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

fe.update:                                        ; preds = %idx.ok
  %22 = load i32, ptr %fe.i, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %fe.i, align 4
  br label %fe.cond

fe.end:                                           ; preds = %fe.cond
  %sum8 = load i32, ptr %sum, align 4
  %24 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %sum8)
  ret i32 0

idx.bad:                                          ; preds = %fe.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %21, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %fe.body
  %arr.data5 = getelementptr i8, ptr %fe.arr, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data5, i64 %21
  %fe.el = load i32, ptr %arr.elem, align 4
  store i32 %fe.el, ptr %x, align 4
  %sum6 = load i32, ptr %sum, align 4
  %x7 = load i32, ptr %x, align 4
  %25 = add i32 %sum6, %x7
  store i32 %25, ptr %sum, align 4
  br label %fe.update
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !1
  ret void
}

define internal void @Range.Range(ptr %0, i32 %1, i32 %2, i32 %3, i32 %4) {
entry:
  %inclusive = alloca i32, align 4
  %stride = alloca i32, align 4
  %end = alloca i32, align 4
  %start = alloca i32, align 4
  store i32 %1, ptr %start, align 4
  store i32 %2, ptr %end, align 4
  store i32 %3, ptr %stride, align 4
  store i32 %4, ptr %inclusive, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 0
  store ptr @Range.vtable, ptr %vtbl.addr, align 8, !tbaa !1
  %start1 = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 1
  %start2 = load i32, ptr %start, align 4
  store i32 %start2, ptr %start1, align 4, !tbaa !5
  %end3 = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 2
  %end4 = load i32, ptr %end, align 4
  store i32 %end4, ptr %end3, align 4, !tbaa !5
  %stride5 = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 3
  %stride6 = load i32, ptr %stride, align 4
  store i32 %stride6, ptr %stride5, align 4, !tbaa !5
  %inclusive7 = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 4
  %inclusive8 = load i32, ptr %inclusive, align 4
  store i32 %inclusive8, ptr %inclusive7, align 4, !tbaa !5
  ret void
}

define internal i32 @Range.inRange(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %stride = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 3
  %stride1 = load i32, ptr %stride, align 4, !tbaa !5
  %2 = icmp sge i32 %stride1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %inclusive = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 4
  %inclusive2 = load i32, ptr %inclusive, align 4, !tbaa !5
  %4 = icmp ne i32 %inclusive2, 0
  br i1 %4, label %if.then3, label %if.end4

if.end:                                           ; preds = %entry
  %inclusive10 = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 4
  %inclusive11 = load i32, ptr %inclusive10, align 4, !tbaa !5
  %5 = icmp ne i32 %inclusive11, 0
  br i1 %5, label %if.then12, label %if.end13

if.then3:                                         ; preds = %if.then
  %i5 = load i32, ptr %i, align 4
  %end = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 2
  %end6 = load i32, ptr %end, align 4, !tbaa !5
  %6 = icmp sle i32 %i5, %end6
  %7 = zext i1 %6 to i32
  ret i32 %7

if.end4:                                          ; preds = %if.then
  %i7 = load i32, ptr %i, align 4
  %end8 = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 2
  %end9 = load i32, ptr %end8, align 4, !tbaa !5
  %8 = icmp slt i32 %i7, %end9
  %9 = zext i1 %8 to i32
  ret i32 %9

if.then12:                                        ; preds = %if.end
  %i14 = load i32, ptr %i, align 4
  %end15 = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 2
  %end16 = load i32, ptr %end15, align 4, !tbaa !5
  %10 = icmp sge i32 %i14, %end16
  %11 = zext i1 %10 to i32
  ret i32 %11

if.end13:                                         ; preds = %if.end
  %i17 = load i32, ptr %i, align 4
  %end18 = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 2
  %end19 = load i32, ptr %end18, align 4, !tbaa !5
  %12 = icmp sgt i32 %i17, %end19
  %13 = zext i1 %12 to i32
  ret i32 %13
}

define internal i32 @Range.size(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 0, ptr %n, align 4
  %start = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 1
  %start1 = load i32, ptr %start, align 4, !tbaa !5
  store i32 %start1, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i2 = load i32, ptr %i, align 4
  %1 = call i32 @Range.inRange(ptr %0, i32 %i2)
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n3 = load i32, ptr %n, align 4
  %3 = add i32 %n3, 1
  store i32 %3, ptr %n, align 4
  %i4 = load i32, ptr %i, align 4
  %stride = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 3
  %stride5 = load i32, ptr %stride, align 4, !tbaa !5
  %4 = add i32 %i4, %stride5
  store i32 %4, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n6 = load i32, ptr %n, align 4
  ret i32 %n6
}

define internal i32 @Range.contains(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %start = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 1
  %start1 = load i32, ptr %start, align 4, !tbaa !5
  store i32 %start1, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %i2 = load i32, ptr %i, align 4
  %2 = call i32 @Range.inRange(ptr %0, i32 %i2)
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i3 = load i32, ptr %i, align 4
  %v4 = load i32, ptr %v, align 4
  %4 = icmp eq i32 %i3, %v4
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  ret i32 0

if.then:                                          ; preds = %while.body
  ret i32 1

if.end:                                           ; preds = %while.body
  %i5 = load i32, ptr %i, align 4
  %stride = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 3
  %stride6 = load i32, ptr %stride, align 4, !tbaa !5
  %6 = add i32 %i5, %stride6
  store i32 %6, ptr %i, align 4
  br label %while.cond
}

define internal ptr @Range.toArray(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %idx = alloca i32, align 4
  %a = alloca ptr, align 8
  %n = alloca i32, align 4
  %1 = call i32 @Range.size(ptr %0)
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %2 = sext i32 %n1 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %a, align 8
  store i32 0, ptr %idx, align 4
  %start = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 1
  %start2 = load i32, ptr %start, align 4, !tbaa !5
  store i32 %start2, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok, %entry
  %i3 = load i32, ptr %i, align 4
  %6 = call i32 @Range.inRange(ptr %0, i32 %i3)
  %7 = icmp ne i32 %6, 0
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %a4 = load ptr, ptr %a, align 8, !nonnull !7, !dereferenceable !8
  %idx5 = load i32, ptr %idx, align 4
  %8 = sext i32 %idx5 to i64
  %arr.len = load i64, ptr %a4, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

while.end:                                        ; preds = %while.cond
  %a11 = load ptr, ptr %a, align 8
  ret ptr %a11

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1483, ptr @.faila.1484, i64 %8, ptr @.failb.1485, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data6 = getelementptr i8, ptr %a4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data6, i64 %8
  %i7 = load i32, ptr %i, align 4
  store i32 %i7, ptr %arr.elem, align 4
  %idx8 = load i32, ptr %idx, align 4
  %9 = add i32 %idx8, 1
  store i32 %9, ptr %idx, align 4
  %i9 = load i32, ptr %i, align 4
  %stride = getelementptr inbounds %class.Range, ptr %0, i32 0, i32 3
  %stride10 = load i32, ptr %stride, align 4, !tbaa !5
  %10 = add i32 %i9, %stride10
  store i32 %10, ptr %i, align 4
  br label %while.cond
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

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @memset(ptr, i32, i64)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!"branch_weights", i32 1, i32 1048576}
!1 = !{!2, !2, i64 0}
!2 = !{!"ptr", !3, i64 0}
!3 = !{!"polaron char", !4, i64 0}
!4 = !{!"polaron TBAA"}
!5 = !{!6, !6, i64 0}
!6 = !{!"i32", !3, i64 0}
!7 = !{}
!8 = !{i64 8}
