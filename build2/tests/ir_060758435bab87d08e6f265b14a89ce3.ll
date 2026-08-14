; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/narrow_address.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/narrow_address.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.RealModePointer = type { i16, i16 }
%String = type { i64, ptr, i64 }

define internal void @RealModePointer.RealModePointer(ptr %0, i16 %1, i16 %2) {
entry:
  %offset = alloca i16, align 2
  %segment = alloca i16, align 2
  store i16 %1, ptr %segment, align 2
  store i16 %2, ptr %offset, align 2
  %segment1 = getelementptr inbounds %class.RealModePointer, ptr %0, i32 0, i32 0
  %segment2 = load i16, ptr %segment, align 2
  store i16 %segment2, ptr %segment1, align 2, !tbaa !0
  %offset3 = getelementptr inbounds %class.RealModePointer, ptr %0, i32 0, i32 1
  %offset4 = load i16, ptr %offset, align 2
  store i16 %offset4, ptr %offset3, align 2, !tbaa !0
  ret void
}

define internal i64 @RealModePointer.linear(ptr nonnull align 2 dereferenceable(4) %0) {
entry:
  %off = alloca i64, align 8
  %seg = alloca i64, align 8
  %segment = getelementptr inbounds %class.RealModePointer, ptr %0, i32 0, i32 0
  %segment1 = load i16, ptr %segment, align 2, !tbaa !0
  %1 = zext i16 %segment1 to i64
  store i64 %1, ptr %seg, align 8
  %offset = getelementptr inbounds %class.RealModePointer, ptr %0, i32 0, i32 1
  %offset2 = load i16, ptr %offset, align 2, !tbaa !0
  %2 = zext i16 %offset2 to i64
  store i64 %2, ptr %off, align 8
  %seg3 = load i64, ptr %seg, align 8
  %3 = mul i64 %seg3, 16
  %off4 = load i64, ptr %off, align 8
  %4 = add i64 %3, %off4
  ret i64 %4
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %linear = alloca i64, align 8
  %p = alloca ptr, align 8
  %narrowed = alloca i32, align 4
  %wide = alloca i64, align 8
  %half = alloca i32, align 4
  %z = alloca i8, align 1
  %s = alloca i16, align 2
  %h = alloca i32, align 4
  %a = alloca i64, align 8
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
  store i64 4096, ptr %a, align 8
  %a1 = load i64, ptr %a, align 8
  %16 = trunc i64 %a1 to i32
  store i32 %16, ptr %h, align 4
  store i16 -18432, ptr %s, align 2
  store i8 -2, ptr %z, align 1
  store i32 3, ptr %half, align 4
  %s2 = load i16, ptr %s, align 2
  %17 = zext i16 %s2 to i64
  store i64 %17, ptr %wide, align 8
  %a3 = load i64, ptr %a, align 8
  %18 = trunc i64 %a3 to i32
  store i32 %18, ptr %narrowed, align 4
  %RealModePointer.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.RealModePointer, ptr null, i64 1) to i64))
  %s4 = load i16, ptr %s, align 2
  call void @RealModePointer.RealModePointer(ptr %RealModePointer.obj, i16 %s4, i16 16)
  store ptr %RealModePointer.obj, ptr %p, align 8
  %p5 = load ptr, ptr %p, align 8
  %19 = call i64 @RealModePointer.linear(ptr %p5)
  store i64 %19, ptr %linear, align 8
  %p6 = load ptr, ptr %p, align 8
  call void @__polaron_check_live(ptr %p6)
  call void @__polaron_free(ptr %p6)
  ret i32 0
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"i16", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
