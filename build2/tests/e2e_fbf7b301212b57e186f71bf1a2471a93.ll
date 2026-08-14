; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/channel_select.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/channel_select.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.Channel$int" = type { ptr, i64 }
%class.Thread = type { ptr, ptr, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Thread.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr @Thread.start, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Thread.join, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Channel$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [6 x i8] c"a=%d\0A\00", align 1
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_1, ptr null]
@.str.1 = private unnamed_addr constant [6 x i8] c"b=%d\0A\00", align 1
@__polaron_closure.2 = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_2, ptr null]
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %sel.tmp = alloca i64, align 8
  %t = alloca ptr, align 8
  %prod = alloca ptr, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
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
  %"Channel$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Channel$int", ptr null, i64 1) to i64))
  call void @"Channel$int.Channel$int"(ptr %"Channel$int.obj", i32 4)
  store ptr %"Channel$int.obj", ptr %a, align 8
  %"Channel$int.obj1" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Channel$int", ptr null, i64 1) to i64))
  call void @"Channel$int.Channel$int"(ptr %"Channel$int.obj1", i32 4)
  store ptr %"Channel$int.obj1", ptr %b, align 8
  %env = call ptr @__polaron_malloc(i64 8)
  %16 = getelementptr ptr, ptr %env, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %17 = load ptr, ptr %b, align 8
  store ptr %17, ptr %cap, align 8
  store ptr %cap, ptr %16, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_0, ptr %closure, align 8
  %18 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env, ptr %18, align 8
  store ptr %closure, ptr %prod, align 8
  %Thread.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Thread, ptr null, i64 1) to i64))
  %prod2 = load ptr, ptr %prod, align 8
  call void @Thread.Thread(ptr %Thread.obj, ptr %prod2)
  store ptr %Thread.obj, ptr %t, align 8
  %t3 = load ptr, ptr %t, align 8
  call void @Thread.start(ptr %t3)
  %t4 = load ptr, ptr %t, align 8
  call void @Thread.join(ptr %t4)
  %a5 = load ptr, ptr %a, align 8
  %19 = getelementptr inbounds %"class.Channel$int", ptr %a5, i32 0, i32 1
  %sel.h = load i64, ptr %19, align 8, !tbaa !0
  %b6 = load ptr, ptr %b, align 8
  %20 = getelementptr inbounds %"class.Channel$int", ptr %b6, i32 0, i32 1
  %sel.h7 = load i64, ptr %20, align 8, !tbaa !0
  br label %sel.loop

sel.loop:                                         ; preds = %sel.next11, %argv.end
  %sel.got = call i32 @__polaron_chan_try_receive(i64 %sel.h, ptr %sel.tmp)
  %21 = icmp ne i32 %sel.got, 0
  br i1 %21, label %sel.recv, label %sel.next

sel.done:                                         ; preds = %sel.recv10, %sel.recv
  ret i32 0

sel.recv:                                         ; preds = %sel.loop
  %sel.v = load i64, ptr %sel.tmp, align 8
  %22 = trunc i64 %sel.v to i32
  %code = load ptr, ptr @__polaron_closure, align 8
  %env8 = load ptr, ptr getelementptr (ptr, ptr @__polaron_closure, i32 1), align 8
  call void %code(ptr %env8, i32 %22)
  br label %sel.done

sel.next:                                         ; preds = %sel.loop
  %sel.got9 = call i32 @__polaron_chan_try_receive(i64 %sel.h7, ptr %sel.tmp)
  %23 = icmp ne i32 %sel.got9, 0
  br i1 %23, label %sel.recv10, label %sel.next11

sel.recv10:                                       ; preds = %sel.next
  %sel.v12 = load i64, ptr %sel.tmp, align 8
  %24 = trunc i64 %sel.v12 to i32
  %code13 = load ptr, ptr @__polaron_closure.2, align 8
  %env14 = load ptr, ptr getelementptr (ptr, ptr @__polaron_closure.2, i32 1), align 8
  call void %code13(ptr %env14, i32 %24)
  br label %sel.done

sel.next11:                                       ; preds = %sel.next
  call void @__polaron_yield()
  br label %sel.loop
}

define internal void @"Channel$int.Channel$int"(ptr %0, i32 %1) {
entry:
  %capacity = alloca i32, align 4
  store i32 %1, ptr %capacity, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Channel$int", ptr %0, i32 0, i32 0
  store ptr @"Channel$int.vtable", ptr %vtbl.addr, align 8, !tbaa !4
  %h = getelementptr inbounds %"class.Channel$int", ptr %0, i32 0, i32 1
  %capacity1 = load i32, ptr %capacity, align 4
  %2 = sext i32 %capacity1 to i64
  %chan.h = call i64 @__polaron_chan_new(i64 %2)
  store i64 %chan.h, ptr %h, align 8, !tbaa !0
  ret void
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  ret void
}

define internal void @Thread.Thread(ptr %0, ptr %1) {
entry:
  %w = alloca ptr, align 8
  store ptr %1, ptr %w, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 0
  store ptr @Thread.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  %work = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 1
  %w1 = load ptr, ptr %w, align 8
  store ptr %w1, ptr %work, align 8, !tbaa !4
  %handle = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 2
  store i64 0, ptr %handle, align 8, !tbaa !0
  ret void
}

define internal void @Thread.start(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %handle = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 2
  %work = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 1
  %work1 = load ptr, ptr %work, align 8, !tbaa !4
  %thread.h = call i64 @__polaron_thread_spawn(ptr %work1)
  store i64 %thread.h, ptr %handle, align 8, !tbaa !0
  ret void
}

define internal void @Thread.join(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %handle = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 2
  %handle1 = load i64, ptr %handle, align 8, !tbaa !0
  call void @__polaron_thread_join(i64 %handle1)
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5311)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal void @__polaron_lambda_0(ptr %0) {
entry:
  %1 = getelementptr ptr, ptr %0, i32 0
  %b = load ptr, ptr %1, align 8
  %b1 = load ptr, ptr %b, align 8
  %chan.h.addr = getelementptr inbounds %"class.Channel$int", ptr %b1, i32 0, i32 1
  %chan.h = load i64, ptr %chan.h.addr, align 8, !tbaa !0
  call void @__polaron_chan_send(i64 %chan.h, i64 42)
  ret void
}

declare void @__polaron_chan_send(i64, i64)

define internal void @__polaron_lambda_1(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %2 = call i32 (ptr, ...) @printf(ptr @.str, i32 %x1)
  ret void
}

declare i32 @printf(ptr, ...)

define internal void @__polaron_lambda_2(ptr %0, i32 %1) {
entry:
  %y = alloca i32, align 4
  store i32 %1, ptr %y, align 4
  %y1 = load i32, ptr %y, align 4
  %2 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %y1)
  ret void
}

declare i32 @__polaron_chan_try_receive(i64, ptr)

declare void @__polaron_yield()

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i64 @__polaron_chan_new(i64)

declare i64 @__polaron_thread_spawn(ptr)

declare void @__polaron_thread_join(i64)

!0 = !{!1, !1, i64 0}
!1 = !{!"i64", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"ptr", !2, i64 0}
