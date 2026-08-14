; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/qualify_keeps_members.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/qualify_keeps_members.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.Alpha__Widget = type { ptr }
%class.Beta__Widget = type { ptr }
%String = type { i64, ptr, i64 }
%class.ByteSize = type { i64 }
%class.Object = type { ptr }

@Alpha__Widget.vtable = private constant [350 x ptr] [ptr @Alpha__Widget.who, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Beta__Widget.vtable = private constant [350 x ptr] [ptr @Beta__Widget.who, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.1296 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define internal i32 @Alpha__Widget.who(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 1
}

define internal void @Alpha__Widget.Alpha__Widget(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Alpha__Widget, ptr %0, i32 0, i32 0
  store ptr @Alpha__Widget.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal i32 @Beta__Widget.who(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 2
}

define internal void @Beta__Widget.Beta__Widget(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Beta__Widget, ptr %0, i32 0, i32 0
  store ptr @Beta__Widget.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown26 = alloca ptr, align 8
  %exc.cleanup21 = alloca ptr, align 8
  %exc.thrown17 = alloca ptr, align 8
  %exc.cleanup12 = alloca ptr, align 8
  %two = alloca ptr, align 8
  %exc.thrown8 = alloca ptr, align 8
  %exc.cleanup3 = alloca ptr, align 8
  %Beta__Widget.obj = alloca %class.Beta__Widget, align 8
  %one = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %exc.cleanup = alloca ptr, align 8
  %Alpha__Widget.obj = alloca %class.Alpha__Widget, align 8
  %"pen#cursor" = alloca i64, align 8
  %pen = alloca ptr, align 8
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
  %16 = call ptr @literal.kilobytes.int(i32 1)
  %bs = getelementptr inbounds %class.ByteSize, ptr %16, i32 0, i32 0
  %bytes = load i64, ptr %bs, align 8, !tbaa !4
  %17 = add i64 24, %bytes
  %region = call ptr @__polaron_region_acquire(i64 %17)
  %rgn.databegin = getelementptr i8, ptr %region, i64 24
  store i64 0, ptr %region, align 8
  %rgn.cap = getelementptr i8, ptr %region, i64 8
  store i64 %bytes, ptr %rgn.cap, align 8
  %rgn.dbase = getelementptr i8, ptr %region, i64 16
  store ptr %rgn.databegin, ptr %rgn.dbase, align 8
  store ptr %region, ptr %pen, align 8
  store i64 0, ptr %"pen#cursor", align 8
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 42)
  %19 = load ptr, ptr %pen, align 8
  call void @__polaron_region_release(ptr %19)
  store ptr null, ptr %pen, align 8
  invoke void @Alpha__Widget.Alpha__Widget(ptr %Alpha__Widget.obj)
          to label %invoke.cont unwind label %cleanup

cleanup:                                          ; preds = %argv.end
  %20 = catchswitch within none [label %cleanup.dispatch] unwind to caller

cleanup.dispatch:                                 ; preds = %cleanup
  %21 = catchpad within %20 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup]
  catchret from %21 to label %cleanup.run

cleanup.run:                                      ; preds = %cleanup.dispatch
  %cleanup.obj = load ptr, ptr %exc.cleanup, align 8
  %region1 = load ptr, ptr %pen, align 8
  call void @__polaron_region_release(ptr %region1)
  store ptr %cleanup.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

invoke.cont:                                      ; preds = %argv.end
  store ptr %Alpha__Widget.obj, ptr %one, align 8
  invoke void @Beta__Widget.Beta__Widget(ptr %Beta__Widget.obj)
          to label %invoke.cont9 unwind label %cleanup2

cleanup2:                                         ; preds = %invoke.cont
  %22 = catchswitch within none [label %cleanup.dispatch4] unwind to caller

cleanup.dispatch4:                                ; preds = %cleanup2
  %23 = catchpad within %22 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup3]
  catchret from %23 to label %cleanup.run5

cleanup.run5:                                     ; preds = %cleanup.dispatch4
  %cleanup.obj6 = load ptr, ptr %exc.cleanup3, align 8
  %region7 = load ptr, ptr %pen, align 8
  call void @__polaron_region_release(ptr %region7)
  store ptr %cleanup.obj6, ptr %exc.thrown8, align 8
  call void @_CxxThrowException(ptr %exc.thrown8, ptr @_TI1PEAX)
  unreachable

invoke.cont9:                                     ; preds = %invoke.cont
  store ptr %Beta__Widget.obj, ptr %two, align 8
  %one10 = load ptr, ptr %one, align 8
  %24 = invoke i32 @Alpha__Widget.who(ptr %one10)
          to label %invoke.cont18 unwind label %cleanup11

cleanup11:                                        ; preds = %invoke.cont9
  %25 = catchswitch within none [label %cleanup.dispatch13] unwind to caller

cleanup.dispatch13:                               ; preds = %cleanup11
  %26 = catchpad within %25 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup12]
  catchret from %26 to label %cleanup.run14

cleanup.run14:                                    ; preds = %cleanup.dispatch13
  %cleanup.obj15 = load ptr, ptr %exc.cleanup12, align 8
  %region16 = load ptr, ptr %pen, align 8
  call void @__polaron_region_release(ptr %region16)
  store ptr %cleanup.obj15, ptr %exc.thrown17, align 8
  call void @_CxxThrowException(ptr %exc.thrown17, ptr @_TI1PEAX)
  unreachable

invoke.cont18:                                    ; preds = %invoke.cont9
  %two19 = load ptr, ptr %two, align 8
  %27 = invoke i32 @Beta__Widget.who(ptr %two19)
          to label %invoke.cont27 unwind label %cleanup20

cleanup20:                                        ; preds = %invoke.cont18
  %28 = catchswitch within none [label %cleanup.dispatch22] unwind to caller

cleanup.dispatch22:                               ; preds = %cleanup20
  %29 = catchpad within %28 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup21]
  catchret from %29 to label %cleanup.run23

cleanup.run23:                                    ; preds = %cleanup.dispatch22
  %cleanup.obj24 = load ptr, ptr %exc.cleanup21, align 8
  %region25 = load ptr, ptr %pen, align 8
  call void @__polaron_region_release(ptr %region25)
  store ptr %cleanup.obj24, ptr %exc.thrown26, align 8
  call void @_CxxThrowException(ptr %exc.thrown26, ptr @_TI1PEAX)
  unreachable

invoke.cont27:                                    ; preds = %invoke.cont18
  %30 = add i32 %24, %27
  %31 = call i32 (ptr, ...) @printf(ptr @.str.1296, i32 %30)
  %region28 = load ptr, ptr %pen, align 8
  call void @__polaron_region_release(ptr %region28)
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

define internal void @ByteSize.ByteSize(ptr %0, i64 %1) {
entry:
  %bytes = alloca i64, align 8
  store i64 %1, ptr %bytes, align 8
  %bytes1 = getelementptr inbounds %class.ByteSize, ptr %0, i32 0, i32 0
  %bytes2 = load i64, ptr %bytes, align 8
  store i64 %bytes2, ptr %bytes1, align 8, !tbaa !4
  ret void
}

define internal ptr @literal.kilobytes.int(i32 %0) {
entry:
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %ByteSize.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ByteSize, ptr null, i64 1) to i64))
  %x1 = load i32, ptr %x, align 4
  %1 = sext i32 %x1 to i64
  %2 = mul i64 %1, 1024
  call void @ByteSize.ByteSize(ptr %ByteSize.obj, i64 %2)
  ret ptr %ByteSize.obj
}

declare noalias ptr @__polaron_malloc(i64)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @strlen(ptr)

declare noalias ptr @__polaron_region_acquire(i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_region_release(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i64", !2, i64 0}
