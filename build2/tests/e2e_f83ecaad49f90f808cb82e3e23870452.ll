; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_snapshot.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_snapshot.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Cell = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Cell.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str = private unnamed_addr constant [11 x i8] c"before=%d \00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"after=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define internal void @Cell.Cell(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Cell, ptr %0, i32 0, i32 0
  store ptr @Cell.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %v = getelementptr inbounds %class.Cell, ptr %0, i32 0, i32 1
  store i32 0, ptr %v, align 4, !tbaa !4
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %c = alloca ptr, align 8
  %exc.thrown33 = alloca ptr, align 8
  %exc.cleanup27 = alloca ptr, align 8
  %b = alloca ptr, align 8
  %exc.thrown15 = alloca ptr, align 8
  %exc.cleanup9 = alloca ptr, align 8
  %save = alloca i64, align 8
  %a = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %exc.cleanup = alloca ptr, align 8
  %backups = alloca ptr, align 8
  %world = alloca ptr, align 8
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
  %region = call ptr @__polaron_region_acquire(i64 4544)
  call void @__polaron_region_init(ptr %region, i64 2, i64 4096, i64 0)
  store ptr %region, ptr %world, align 8
  %region1 = call ptr @__polaron_region_acquire(i64 8640)
  call void @__polaron_region_init(ptr %region1, i64 1, i64 8192, i64 0)
  store ptr %region1, ptr %backups, align 8
  %region2 = load ptr, ptr %world, align 8
  %rgn.slot = call ptr @__polaron_region_new(ptr %region2, i64 ptrtoint (ptr getelementptr (%class.Cell, ptr null, i64 1) to i64))
  invoke void @Cell.Cell(ptr %rgn.slot)
          to label %invoke.cont unwind label %cleanup

cleanup:                                          ; preds = %argv.end
  %16 = catchswitch within none [label %cleanup.dispatch] unwind to caller

cleanup.dispatch:                                 ; preds = %cleanup
  %17 = catchpad within %16 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup]
  catchret from %17 to label %cleanup.run

cleanup.run:                                      ; preds = %cleanup.dispatch
  %cleanup.obj = load ptr, ptr %exc.cleanup, align 8
  %region3 = load ptr, ptr %backups, align 8
  call void @__polaron_region_release(ptr %region3)
  %region4 = load ptr, ptr %world, align 8
  call void @__polaron_region_teardown(ptr %region4)
  call void @__polaron_region_release(ptr %region4)
  store ptr %cleanup.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

invoke.cont:                                      ; preds = %argv.end
  store ptr %rgn.slot, ptr %a, align 8
  %a5 = load ptr, ptr %a, align 8
  %v = getelementptr inbounds %class.Cell, ptr %a5, i32 0, i32 1
  store i32 1, ptr %v, align 4, !tbaa !4
  %snap.src = load ptr, ptr %world, align 8
  %snap.home = load ptr, ptr %backups, align 8
  %snap.size = call i64 @__polaron_region_snapshot_size(ptr %snap.src)
  %snap.block = call ptr @__polaron_region_new(ptr %snap.home, i64 %snap.size)
  call void @__polaron_region_snapshot(ptr %snap.src, ptr %snap.block, i64 %snap.size)
  %snap.handle = ptrtoint ptr %snap.block to i64
  store i64 %snap.handle, ptr %save, align 8
  %region6 = load ptr, ptr %world, align 8
  %rgn.slot7 = call ptr @__polaron_region_new(ptr %region6, i64 ptrtoint (ptr getelementptr (%class.Cell, ptr null, i64 1) to i64))
  invoke void @Cell.Cell(ptr %rgn.slot7)
          to label %invoke.cont16 unwind label %cleanup8

cleanup8:                                         ; preds = %invoke.cont
  %18 = catchswitch within none [label %cleanup.dispatch10] unwind to caller

cleanup.dispatch10:                               ; preds = %cleanup8
  %19 = catchpad within %18 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup9]
  catchret from %19 to label %cleanup.run11

cleanup.run11:                                    ; preds = %cleanup.dispatch10
  %cleanup.obj12 = load ptr, ptr %exc.cleanup9, align 8
  %region13 = load ptr, ptr %backups, align 8
  call void @__polaron_region_release(ptr %region13)
  %region14 = load ptr, ptr %world, align 8
  call void @__polaron_region_teardown(ptr %region14)
  call void @__polaron_region_release(ptr %region14)
  store ptr %cleanup.obj12, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

invoke.cont16:                                    ; preds = %invoke.cont
  store ptr %rgn.slot7, ptr %b, align 8
  %b17 = load ptr, ptr %b, align 8
  %v18 = getelementptr inbounds %class.Cell, ptr %b17, i32 0, i32 1
  store i32 2, ptr %v18, align 4, !tbaa !4
  %b19 = load ptr, ptr %b, align 8
  %v20 = getelementptr inbounds %class.Cell, ptr %b19, i32 0, i32 1
  %v21 = load i32, ptr %v20, align 4, !tbaa !4
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %v21)
  %region22 = load ptr, ptr %world, align 8
  %save23 = load i64, ptr %save, align 8
  %snap.p = inttoptr i64 %save23 to ptr
  call void @__polaron_region_restore(ptr %region22, ptr %snap.p)
  %region24 = load ptr, ptr %world, align 8
  %rgn.slot25 = call ptr @__polaron_region_new(ptr %region24, i64 ptrtoint (ptr getelementptr (%class.Cell, ptr null, i64 1) to i64))
  invoke void @Cell.Cell(ptr %rgn.slot25)
          to label %invoke.cont34 unwind label %cleanup26

cleanup26:                                        ; preds = %invoke.cont16
  %21 = catchswitch within none [label %cleanup.dispatch28] unwind to caller

cleanup.dispatch28:                               ; preds = %cleanup26
  %22 = catchpad within %21 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup27]
  catchret from %22 to label %cleanup.run29

cleanup.run29:                                    ; preds = %cleanup.dispatch28
  %cleanup.obj30 = load ptr, ptr %exc.cleanup27, align 8
  %region31 = load ptr, ptr %backups, align 8
  call void @__polaron_region_release(ptr %region31)
  %region32 = load ptr, ptr %world, align 8
  call void @__polaron_region_teardown(ptr %region32)
  call void @__polaron_region_release(ptr %region32)
  store ptr %cleanup.obj30, ptr %exc.thrown33, align 8
  call void @_CxxThrowException(ptr %exc.thrown33, ptr @_TI1PEAX)
  unreachable

invoke.cont34:                                    ; preds = %invoke.cont16
  store ptr %rgn.slot25, ptr %c, align 8
  %c35 = load ptr, ptr %c, align 8
  %v36 = getelementptr inbounds %class.Cell, ptr %c35, i32 0, i32 1
  %a37 = load ptr, ptr %a, align 8
  %v38 = getelementptr inbounds %class.Cell, ptr %a37, i32 0, i32 1
  %v39 = load i32, ptr %v38, align 4, !tbaa !4
  store i32 %v39, ptr %v36, align 4, !tbaa !4
  %c40 = load ptr, ptr %c, align 8
  %v41 = getelementptr inbounds %class.Cell, ptr %c40, i32 0, i32 1
  %v42 = load i32, ptr %v41, align 4, !tbaa !4
  %23 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %v42)
  %region43 = load ptr, ptr %backups, align 8
  call void @__polaron_region_release(ptr %region43)
  %region44 = load ptr, ptr %world, align 8
  call void @__polaron_region_teardown(ptr %region44)
  call void @__polaron_region_release(ptr %region44)
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

declare noalias ptr @__polaron_region_acquire(i64)

declare void @__polaron_region_init(ptr, i64, i64, i64)

declare noalias ptr @__polaron_region_new(ptr, i64)

declare i32 @__CxxFrameHandler3(...)

declare void @__polaron_region_release(ptr)

declare void @__polaron_region_teardown(ptr)

declare void @_CxxThrowException(ptr, ptr)

declare i64 @__polaron_region_snapshot_size(ptr)

declare void @__polaron_region_snapshot(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_region_restore(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
