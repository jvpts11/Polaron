; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bundle_inherit_app.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bundle_inherit_app.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Button = type { ptr, i32 }
%class.Widget = type { ptr, i32 }
%class.Object = type { ptr }
%class.IntCounter = type { ptr, ptr, i32, i32, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Button.vtable = private constant [351 x ptr] [ptr @Button.weight, ptr @Widget.label, ptr @Widget.total, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [37 x i8] c"weight = %d, label = %d, total = %d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Button.Button(ptr %0, i32 %1) {
entry:
  %tag = alloca i32, align 4
  store i32 %1, ptr %tag, align 4
  %tag1 = load i32, ptr %tag, align 4
  call void @Widget.Widget(ptr %0, i32 %tag1)
  %vtbl.addr = getelementptr inbounds %class.Button, ptr %0, i32 0, i32 0
  store ptr @Button.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal i32 @Button.weight(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret i32 5
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %w = alloca ptr, align 8
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
  %Button.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Button, ptr null, i64 1) to i64))
  call void @Button.Button(ptr %Button.obj, i32 7)
  store ptr %Button.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %vtbl.addr = getelementptr inbounds %class.Widget, ptr %w1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 0
  %fn = load ptr, ptr %slot, align 8
  %dv.is = icmp eq ptr %fn, @Button.weight
  br i1 %dv.is, label %dv.hit, label %dv.miss

dv.join:                                          ; preds = %dv.miss, %dv.hit
  %dv.r = phi i32 [ %16, %dv.hit ], [ %17, %dv.miss ]
  %w2 = load ptr, ptr %w, align 8
  %vtbl.addr3 = getelementptr inbounds %class.Widget, ptr %w2, i32 0, i32 0
  %vtbl4 = load ptr, ptr %vtbl.addr3, align 8, !tbaa !0
  %slot5 = getelementptr [350 x ptr], ptr %vtbl4, i64 0, i64 1
  %fn6 = load ptr, ptr %slot5, align 8
  %dv.is10 = icmp eq ptr %fn6, @Widget.label
  br i1 %dv.is10, label %dv.hit8, label %dv.miss9

dv.hit:                                           ; preds = %argv.end
  %16 = call i32 @Button.weight(ptr %w1)
  br label %dv.join

dv.miss:                                          ; preds = %argv.end
  %17 = call i32 %fn(ptr %w1)
  br label %dv.join

dv.join7:                                         ; preds = %dv.miss9, %dv.hit8
  %dv.r11 = phi i32 [ %18, %dv.hit8 ], [ %19, %dv.miss9 ]
  %w12 = load ptr, ptr %w, align 8
  %vtbl.addr13 = getelementptr inbounds %class.Widget, ptr %w12, i32 0, i32 0
  %vtbl14 = load ptr, ptr %vtbl.addr13, align 8, !tbaa !0
  %slot15 = getelementptr [350 x ptr], ptr %vtbl14, i64 0, i64 2
  %fn16 = load ptr, ptr %slot15, align 8
  %dv.is20 = icmp eq ptr %fn16, @Widget.total
  br i1 %dv.is20, label %dv.hit18, label %dv.miss19

dv.hit8:                                          ; preds = %dv.join
  %18 = call i32 @Widget.label(ptr %w2)
  br label %dv.join7

dv.miss9:                                         ; preds = %dv.join
  %19 = call i32 %fn6(ptr %w2)
  br label %dv.join7

dv.join17:                                        ; preds = %dv.miss22, %dv.hit21, %dv.hit18
  %dv.r24 = phi i32 [ %21, %dv.hit18 ], [ %22, %dv.hit21 ], [ %23, %dv.miss22 ]
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %dv.r, i32 %dv.r11, i32 %dv.r24)
  %w25 = load ptr, ptr %w, align 8
  call void @Widget.__delete(ptr %w25)
  ret i32 0

dv.hit18:                                         ; preds = %dv.join7
  %21 = call i32 @Widget.total(ptr %w12)
  br label %dv.join17

dv.miss19:                                        ; preds = %dv.join7
  %dv.is23 = icmp eq ptr %fn16, @IntCounter.total
  br i1 %dv.is23, label %dv.hit21, label %dv.miss22

dv.hit21:                                         ; preds = %dv.miss19
  %22 = call i32 @IntCounter.total(ptr %w12)
  br label %dv.join17

dv.miss22:                                        ; preds = %dv.miss19
  %23 = call i32 %fn16(ptr %w12)
  br label %dv.join17
}

declare void @Widget.Widget(ptr, i32)

declare i32 @Widget.label(ptr nonnull align 8 dereferenceable(16))

declare i32 @Widget.total(ptr nonnull align 8 dereferenceable(16))

declare void @Widget.__delete(ptr)

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

define internal i32 @IntCounter.total(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %total = getelementptr inbounds %class.IntCounter, ptr %0, i32 0, i32 2
  %total1 = load i32, ptr %total, align 4, !tbaa !4
  ret i32 %total1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
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
