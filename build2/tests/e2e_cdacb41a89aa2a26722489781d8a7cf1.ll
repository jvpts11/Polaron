; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/async_loop.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/async_loop.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"Main.val$state" = type { i32, ptr, i32 }
%"class.Task$int" = type { ptr, i64 }
%"Main.sumLoop$state" = type { i32, ptr, i32, i32, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"Task$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str = private unnamed_addr constant [12 x i8] c"loopsum=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal ptr @Main.val(i32 %0) {
entry:
  %task = call i64 @__polaron_task_new()
  %state = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"Main.val$state", ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %"Main.val$state", ptr %state, i32 0, i32 0
  store i32 0, ptr %1, align 4
  %2 = getelementptr inbounds %"Main.val$state", ptr %state, i32 0, i32 1
  %3 = inttoptr i64 %task to ptr
  store ptr %3, ptr %2, align 8
  %4 = getelementptr inbounds %"Main.val$state", ptr %state, i32 0, i32 2
  store i32 %0, ptr %4, align 4
  call void @__polaron_schedule(ptr @"Main.val$resume", ptr %state)
  %task.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Task$int", ptr null, i64 1) to i64))
  call void @"Task$int.Task$int"(ptr %task.obj)
  %task.h.addr = getelementptr inbounds %"class.Task$int", ptr %task.obj, i32 0, i32 1
  store i64 %task, ptr %task.h.addr, align 8, !tbaa !0
  ret ptr %task.obj
}

define internal void @"Main.val$resume"(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.async = alloca ptr, align 8
  %st.task.addr = getelementptr inbounds %"Main.val$state", ptr %0, i32 0, i32 1
  %st.task = load ptr, ptr %st.task.addr, align 8
  %n = getelementptr inbounds %"Main.val$state", ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4
  %1 = ptrtoint ptr %st.task to i64
  %2 = sext i32 %n1 to i64
  call void @__polaron_task_complete(i64 %1, i64 %2)
  ret void

async.guard:                                      ; No predecessors!
  %3 = catchswitch within none [label %async.dispatch] unwind to caller

async.dispatch:                                   ; preds = %async.guard
  %4 = catchpad within %3 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.async]
  catchret from %4 to label %async.fail

async.fail:                                       ; preds = %async.dispatch
  %async.err = load ptr, ptr %exc.async, align 8
  %5 = ptrtoint ptr %st.task to i64
  %6 = ptrtoint ptr %async.err to i64
  call void @__polaron_task_complete_error(i64 %5, i64 %6)
  ret void
}

define internal ptr @Main.sumLoop() {
entry:
  %task = call i64 @__polaron_task_new()
  %state = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"Main.sumLoop$state", ptr null, i64 1) to i64))
  %0 = getelementptr inbounds %"Main.sumLoop$state", ptr %state, i32 0, i32 0
  store i32 0, ptr %0, align 4
  %1 = getelementptr inbounds %"Main.sumLoop$state", ptr %state, i32 0, i32 1
  %2 = inttoptr i64 %task to ptr
  store ptr %2, ptr %1, align 8
  call void @__polaron_schedule(ptr @"Main.sumLoop$resume", ptr %state)
  %task.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Task$int", ptr null, i64 1) to i64))
  call void @"Task$int.Task$int"(ptr %task.obj)
  %task.h.addr = getelementptr inbounds %"class.Task$int", ptr %task.obj, i32 0, i32 1
  store i64 %task, ptr %task.h.addr, align 8, !tbaa !0
  ret ptr %task.obj
}

define internal void @"Main.sumLoop$resume"(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %exc.async = alloca ptr, align 8
  %st.task.addr = getelementptr inbounds %"Main.sumLoop$state", ptr %0, i32 0, i32 1
  %st.task = load ptr, ptr %st.task.addr, align 8
  %total = getelementptr inbounds %"Main.sumLoop$state", ptr %0, i32 0, i32 2
  %i = getelementptr inbounds %"Main.sumLoop$state", ptr %0, i32 0, i32 3
  %x = getelementptr inbounds %"Main.sumLoop$state", ptr %0, i32 0, i32 4
  %st.state.addr = getelementptr inbounds %"Main.sumLoop$state", ptr %0, i32 0, i32 0
  %st.state = load i32, ptr %st.state.addr, align 4
  switch i32 %st.state, label %body [
    i32 1, label %resume1
  ]

body:                                             ; preds = %entry
  store i32 0, ptr %total, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

suspend:                                          ; preds = %invoke.cont
  ret void

async.guard:                                      ; preds = %await.throw, %for.body
  %1 = catchswitch within none [label %async.dispatch] unwind to caller

async.dispatch:                                   ; preds = %async.guard
  %2 = catchpad within %1 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.async]
  catchret from %2 to label %async.fail

async.fail:                                       ; preds = %async.dispatch
  %async.err = load ptr, ptr %exc.async, align 8
  %3 = ptrtoint ptr %st.task to i64
  %4 = ptrtoint ptr %async.err to i64
  call void @__polaron_task_complete_error(i64 %3, i64 %4)
  ret void

for.cond:                                         ; preds = %for.update, %body
  %i1 = load i32, ptr %i, align 4
  %5 = icmp sle i32 %i1, 5
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i2 = load i32, ptr %i, align 4
  %7 = invoke ptr @Main.val(i32 %i2)
          to label %invoke.cont unwind label %async.guard

for.update:                                       ; preds = %await.ok
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %total5 = load i32, ptr %total, align 4
  %10 = ptrtoint ptr %st.task to i64
  %11 = sext i32 %total5 to i64
  call void @__polaron_task_complete(i64 %10, i64 %11)
  ret void

invoke.cont:                                      ; preds = %for.body
  %task.h.addr = getelementptr inbounds %"class.Task$int", ptr %7, i32 0, i32 1
  %task.h = load i64, ptr %task.h.addr, align 8, !tbaa !0
  %12 = getelementptr inbounds %"Main.sumLoop$state", ptr %0, i32 0, i32 5
  store i64 %task.h, ptr %12, align 8
  %13 = getelementptr inbounds %"Main.sumLoop$state", ptr %0, i32 0, i32 0
  store i32 1, ptr %13, align 4
  %"suspend?" = call i32 @__polaron_await(i64 %task.h, ptr @"Main.sumLoop$resume", ptr %0)
  %14 = icmp ne i32 %"suspend?", 0
  br i1 %14, label %suspend, label %resume1

resume1:                                          ; preds = %entry, %invoke.cont
  %15 = getelementptr inbounds %"Main.sumLoop$state", ptr %0, i32 0, i32 5
  %aw.saved = load i64, ptr %15, align 8
  %aw.err = call i64 @__polaron_task_error(i64 %aw.saved)
  %16 = icmp ne i64 %aw.err, 0
  br i1 %16, label %await.throw, label %await.ok

await.throw:                                      ; preds = %resume1
  %17 = inttoptr i64 %aw.err to ptr
  store ptr %17, ptr %exc.thrown, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
          to label %throw.cont unwind label %async.guard

await.ok:                                         ; preds = %resume1
  %aw.result = call i64 @__polaron_task_result(i64 %aw.saved)
  %18 = trunc i64 %aw.result to i32
  store i32 %18, ptr %x, align 4
  %total3 = load i32, ptr %total, align 4
  %x4 = load i32, ptr %x, align 4
  %19 = add i32 %total3, %x4
  store i32 %19, ptr %total, align 4
  br label %for.update

throw.cont:                                       ; preds = %await.throw
  unreachable
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %t = alloca ptr, align 8
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
  %16 = call ptr @Main.sumLoop()
  store ptr %16, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %task.h.addr = getelementptr inbounds %"class.Task$int", ptr %t1, i32 0, i32 1
  %task.h = load i64, ptr %task.h.addr, align 8, !tbaa !0
  %await = call i64 @__polaron_task_wait(i64 %task.h)
  %aw.err = call i64 @__polaron_task_error(i64 %task.h)
  %17 = icmp ne i64 %aw.err, 0
  br i1 %17, label %await.throw, label %await.ok

await.throw:                                      ; preds = %argv.end
  %18 = inttoptr i64 %aw.err to ptr
  store ptr %18, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

await.ok:                                         ; preds = %argv.end
  %19 = trunc i64 %await to i32
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %19)
  ret i32 0
}

define internal void @"Task$int.Task$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Task$int", ptr %0, i32 0, i32 0
  store ptr @"Task$int.vtable", ptr %vtbl.addr, align 8, !tbaa !4
  %h = getelementptr inbounds %"class.Task$int", ptr %0, i32 0, i32 1
  store i64 0, ptr %h, align 8, !tbaa !0
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

declare i32 @__CxxFrameHandler3(...)

declare void @__polaron_task_complete_error(i64, i64)

declare void @__polaron_task_complete(i64, i64)

declare i64 @__polaron_task_new()

declare noalias ptr @__polaron_malloc(i64)

declare void @__polaron_schedule(ptr, ptr)

declare i32 @__polaron_await(i64, ptr, ptr)

declare i64 @__polaron_task_error(i64)

declare void @_CxxThrowException(ptr, ptr)

declare i64 @__polaron_task_result(i64)

declare i64 @strlen(ptr)

declare i64 @__polaron_task_wait(i64)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"i64", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"ptr", !2, i64 0}
