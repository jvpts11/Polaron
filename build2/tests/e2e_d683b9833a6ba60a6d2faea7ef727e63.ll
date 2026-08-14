; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/move_region.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/move_region.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Car = type { ptr, i32 }
%class.ByteSize = type { i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Car.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.panic = private unnamed_addr constant [148 x i8] c"region out of memory: this fixed region is full -- give itself.allocate a bigger size, release it and take it again, or make it a `growable` region\00", align 1
@.panic.1 = private unnamed_addr constant [148 x i8] c"region out of memory: this fixed region is full -- give itself.allocate a bigger size, release it and take it again, or make it a `growable` region\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"id=%d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define internal void @Car.Car(ptr %0, i32 %1) {
entry:
  %id = alloca i32, align 4
  store i32 %1, ptr %id, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Car, ptr %0, i32 0, i32 0
  store ptr @Car.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %id1 = getelementptr inbounds %class.Car, ptr %0, i32 0, i32 1
  %id2 = load i32, ptr %id, align 4
  store i32 %id2, ptr %id1, align 4, !tbaa !4
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %c2 = alloca ptr, align 8
  %c1 = alloca ptr, align 8
  %exc.thrown17 = alloca ptr, align 8
  %exc.cleanup11 = alloca ptr, align 8
  %"production#cursor" = alloca i64, align 8
  %production = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %exc.cleanup = alloca ptr, align 8
  %"staging#cursor" = alloca i64, align 8
  %staging = alloca ptr, align 8
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
  %16 = call ptr @literal.kilobytes.int(i32 1)
  %bs = getelementptr inbounds %class.ByteSize, ptr %16, i32 0, i32 0
  %bytes = load i64, ptr %bs, align 8, !tbaa !6
  %17 = add i64 24, %bytes
  %region = call ptr @__polaron_region_acquire(i64 %17)
  %rgn.databegin = getelementptr i8, ptr %region, i64 24
  store i64 0, ptr %region, align 8
  %rgn.cap = getelementptr i8, ptr %region, i64 8
  store i64 %bytes, ptr %rgn.cap, align 8
  %rgn.dbase = getelementptr i8, ptr %region, i64 16
  store ptr %rgn.databegin, ptr %rgn.dbase, align 8
  store ptr %region, ptr %staging, align 8
  store i64 0, ptr %"staging#cursor", align 8
  %18 = invoke ptr @literal.kilobytes.int(i32 1)
          to label %invoke.cont unwind label %cleanup

cleanup:                                          ; preds = %argv.end
  %19 = catchswitch within none [label %cleanup.dispatch] unwind to caller

cleanup.dispatch:                                 ; preds = %cleanup
  %20 = catchpad within %19 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup]
  catchret from %20 to label %cleanup.run

cleanup.run:                                      ; preds = %cleanup.dispatch
  %cleanup.obj = load ptr, ptr %exc.cleanup, align 8
  %region1 = load ptr, ptr %staging, align 8
  call void @__polaron_region_release(ptr %region1)
  store ptr %cleanup.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

invoke.cont:                                      ; preds = %argv.end
  %bs2 = getelementptr inbounds %class.ByteSize, ptr %18, i32 0, i32 0
  %bytes3 = load i64, ptr %bs2, align 8, !tbaa !6
  %21 = add i64 24, %bytes3
  %region4 = call ptr @__polaron_region_acquire(i64 %21)
  %rgn.databegin5 = getelementptr i8, ptr %region4, i64 24
  store i64 0, ptr %region4, align 8
  %rgn.cap6 = getelementptr i8, ptr %region4, i64 8
  store i64 %bytes3, ptr %rgn.cap6, align 8
  %rgn.dbase7 = getelementptr i8, ptr %region4, i64 16
  store ptr %rgn.databegin5, ptr %rgn.dbase7, align 8
  store ptr %region4, ptr %production, align 8
  store i64 0, ptr %"production#cursor", align 8
  %region8 = load ptr, ptr %staging, align 8
  %used = load i64, ptr %"staging#cursor", align 8
  %rgn.data = getelementptr i8, ptr %region8, i64 24
  %rgn.obj = getelementptr i8, ptr %rgn.data, i64 %used
  %22 = and i64 add (i64 ptrtoint (ptr getelementptr (%class.Car, ptr null, i64 1) to i64), i64 7), -8
  %rgn.next = add i64 %used, %22
  %rgn.cap9 = getelementptr i8, ptr %region8, i64 8
  %cap = load i64, ptr %rgn.cap9, align 8, !invariant.load !8
  %rgn.over = icmp ugt i64 %rgn.next, %cap
  br i1 %rgn.over, label %rgn.full, label %rgn.ok

rgn.full:                                         ; preds = %invoke.cont
  call void @__polaron_panic(ptr @.panic)
  unreachable

rgn.ok:                                           ; preds = %invoke.cont
  store i64 %rgn.next, ptr %"staging#cursor", align 8
  invoke void @Car.Car(ptr %rgn.obj, i32 7)
          to label %invoke.cont18 unwind label %cleanup10

cleanup10:                                        ; preds = %rgn.ok
  %23 = catchswitch within none [label %cleanup.dispatch12] unwind to caller

cleanup.dispatch12:                               ; preds = %cleanup10
  %24 = catchpad within %23 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup11]
  catchret from %24 to label %cleanup.run13

cleanup.run13:                                    ; preds = %cleanup.dispatch12
  %cleanup.obj14 = load ptr, ptr %exc.cleanup11, align 8
  %region15 = load ptr, ptr %production, align 8
  call void @__polaron_region_release(ptr %region15)
  %region16 = load ptr, ptr %staging, align 8
  call void @__polaron_region_release(ptr %region16)
  store ptr %cleanup.obj14, ptr %exc.thrown17, align 8
  call void @_CxxThrowException(ptr %exc.thrown17, ptr @_TI1PEAX)
  unreachable

invoke.cont18:                                    ; preds = %rgn.ok
  store ptr %rgn.obj, ptr %c1, align 8
  %c119 = load ptr, ptr %c1, align 8
  %region20 = load ptr, ptr %production, align 8
  %used21 = load i64, ptr %"production#cursor", align 8
  %rgn.data22 = getelementptr i8, ptr %region20, i64 24
  %rgn.obj23 = getelementptr i8, ptr %rgn.data22, i64 %used21
  %25 = and i64 add (i64 ptrtoint (ptr getelementptr (%class.Car, ptr null, i64 1) to i64), i64 7), -8
  %rgn.next24 = add i64 %used21, %25
  %rgn.cap25 = getelementptr i8, ptr %region20, i64 8
  %cap26 = load i64, ptr %rgn.cap25, align 8, !invariant.load !8
  %rgn.over29 = icmp ugt i64 %rgn.next24, %cap26
  br i1 %rgn.over29, label %rgn.full27, label %rgn.ok28

rgn.full27:                                       ; preds = %invoke.cont18
  call void @__polaron_panic(ptr @.panic.1)
  unreachable

rgn.ok28:                                         ; preds = %invoke.cont18
  store i64 %rgn.next24, ptr %"production#cursor", align 8
  %26 = call ptr @memcpy(ptr %rgn.obj23, ptr %c119, i64 ptrtoint (ptr getelementptr (%class.Car, ptr null, i64 1) to i64))
  store ptr %rgn.obj23, ptr %c2, align 8
  %27 = load ptr, ptr %staging, align 8
  call void @__polaron_region_release(ptr %27)
  store ptr null, ptr %staging, align 8
  %c230 = load ptr, ptr %c2, align 8
  %id = getelementptr inbounds %class.Car, ptr %c230, i32 0, i32 1
  %id31 = load i32, ptr %id, align 4, !tbaa !4
  %28 = call i32 (ptr, ...) @printf(ptr @.str, i32 %id31)
  %29 = load ptr, ptr %production, align 8
  call void @__polaron_region_release(ptr %29)
  store ptr null, ptr %production, align 8
  %region32 = load ptr, ptr %production, align 8
  call void @__polaron_region_release(ptr %region32)
  %region33 = load ptr, ptr %staging, align 8
  call void @__polaron_region_release(ptr %region33)
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
  store i64 %bytes2, ptr %bytes1, align 8, !tbaa !6
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

declare noalias ptr @__polaron_region_acquire(i64)

declare i32 @__CxxFrameHandler3(...)

declare void @__polaron_region_release(ptr)

declare void @_CxxThrowException(ptr, ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
!8 = !{}
