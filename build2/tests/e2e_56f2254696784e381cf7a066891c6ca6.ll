; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/implicit_this.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/implicit_this.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Counter = type { ptr, i32, i32 }
%class.Tally = type { ptr, i32, i32 }
%class.Object = type { ptr }

@Counter.made = private global i32 0
@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Counter.vtable = private constant [352 x ptr] [ptr @Counter.bump, ptr @Counter.twice, ptr @Counter.read, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Tally.vtable = private constant [352 x ptr] [ptr @Counter.bump, ptr @Counter.twice, ptr @Counter.read, ptr @Tally.describe, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [12 x i8] c"tally = %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"counter = %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"made = %d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define internal void @Counter.Counter(ptr %0, i32 %1) {
entry:
  %amount = alloca i32, align 4
  store i32 %1, ptr %amount, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 0
  store ptr @Counter.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %amount1 = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 2
  %amount2 = load i32, ptr %amount, align 4
  store i32 %amount2, ptr %amount1, align 4, !tbaa !4
  %value = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 1
  store i32 0, ptr %value, align 4, !tbaa !4
  %made = load i32, ptr @Counter.made, align 4
  %2 = add i32 %made, 1
  store i32 %2, ptr @Counter.made, align 4
  ret void
}

define internal void @Counter.bump(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %value = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 1
  %value1 = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 1
  %value2 = load i32, ptr %value1, align 4, !tbaa !4
  %amount = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 2
  %amount3 = load i32, ptr %amount, align 4, !tbaa !4
  %1 = add i32 %value2, %amount3
  store i32 %1, ptr %value, align 4, !tbaa !4
  ret void
}

define internal void @Counter.twice(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %vtbl.addr = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %slot = getelementptr [351 x ptr], ptr %vtbl, i64 0, i64 0
  %fn = load ptr, ptr %slot, align 8
  %dv.is = icmp eq ptr %fn, @Counter.bump
  br i1 %dv.is, label %dv.hit, label %dv.miss

dv.join:                                          ; preds = %dv.miss, %dv.hit
  %vtbl.addr1 = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 0
  %vtbl2 = load ptr, ptr %vtbl.addr1, align 8, !tbaa !0
  %slot3 = getelementptr [351 x ptr], ptr %vtbl2, i64 0, i64 0
  %fn4 = load ptr, ptr %slot3, align 8
  %dv.is8 = icmp eq ptr %fn4, @Counter.bump
  br i1 %dv.is8, label %dv.hit6, label %dv.miss7

dv.hit:                                           ; preds = %entry
  call void @Counter.bump(ptr %0)
  br label %dv.join

dv.miss:                                          ; preds = %entry
  call void %fn(ptr %0)
  br label %dv.join

dv.join5:                                         ; preds = %dv.miss7, %dv.hit6
  ret void

dv.hit6:                                          ; preds = %dv.join
  call void @Counter.bump(ptr %0)
  br label %dv.join5

dv.miss7:                                         ; preds = %dv.join
  call void %fn4(ptr %0)
  br label %dv.join5
}

define internal i32 @Counter.read(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %value = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 1
  %value1 = load i32, ptr %value, align 4, !tbaa !4
  ret i32 %value1
}

define internal i32 @Counter.total() {
entry:
  %made = load i32, ptr @Counter.made, align 4
  ret i32 %made
}

define internal void @Tally.Tally(ptr %0) {
entry:
  call void @Counter.Counter(ptr %0, i32 5)
  %vtbl.addr = getelementptr inbounds %class.Tally, ptr %0, i32 0, i32 0
  store ptr @Tally.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @Tally.describe(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %1 = call i32 @Counter.read(ptr %0)
  %2 = call i32 (ptr, ...) @printf(ptr @.str, i32 %1)
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %t = alloca ptr, align 8
  %Tally.obj = alloca %class.Tally, align 8
  %c = alloca ptr, align 8
  %Counter.obj = alloca %class.Counter, align 8
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
  call void @Counter.Counter(ptr %Counter.obj, i32 3)
  store ptr %Counter.obj, ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  %vtbl.addr = getelementptr inbounds %class.Counter, ptr %c1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %slot = getelementptr [351 x ptr], ptr %vtbl, i64 0, i64 1
  %fn = load ptr, ptr %slot, align 8
  %dv.is = icmp eq ptr %fn, @Counter.twice
  br i1 %dv.is, label %dv.hit, label %dv.miss

dv.join:                                          ; preds = %dv.miss, %dv.hit
  %c2 = load ptr, ptr %c, align 8
  %vtbl.addr3 = getelementptr inbounds %class.Counter, ptr %c2, i32 0, i32 0
  %vtbl4 = load ptr, ptr %vtbl.addr3, align 8, !tbaa !0
  %slot5 = getelementptr [351 x ptr], ptr %vtbl4, i64 0, i64 2
  %fn6 = load ptr, ptr %slot5, align 8
  %dv.is10 = icmp eq ptr %fn6, @Counter.read
  br i1 %dv.is10, label %dv.hit8, label %dv.miss9

dv.hit:                                           ; preds = %argv.end
  call void @Counter.twice(ptr %c1)
  br label %dv.join

dv.miss:                                          ; preds = %argv.end
  call void %fn(ptr %c1)
  br label %dv.join

dv.join7:                                         ; preds = %dv.miss9, %dv.hit8
  %dv.r = phi i32 [ %19, %dv.hit8 ], [ %20, %dv.miss9 ]
  %16 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %dv.r)
  call void @Tally.Tally(ptr %Tally.obj)
  store ptr %Tally.obj, ptr %t, align 8
  %t11 = load ptr, ptr %t, align 8
  call void @Counter.bump(ptr %t11)
  %t12 = load ptr, ptr %t, align 8
  call void @Tally.describe(ptr %t12)
  %17 = call i32 @Counter.total()
  %18 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %17)
  ret i32 0

dv.hit8:                                          ; preds = %dv.join
  %19 = call i32 @Counter.read(ptr %c2)
  br label %dv.join7

dv.miss9:                                         ; preds = %dv.join
  %20 = call i32 %fn6(ptr %c2)
  br label %dv.join7
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

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
