; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/async_try.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/async_try.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.MyError = type { ptr, i32 }
%"Main.val$state" = type { i32, ptr, i32 }
%"class.Task$int" = type { ptr, i64 }
%"Main.work$state" = type { i32, ptr, i32, i32, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@MyError.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Task$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str = private unnamed_addr constant [7 x i8] c"ok=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"bad=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define internal void @MyError.MyError(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.MyError, ptr %0, i32 0, i32 0
  store ptr @MyError.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %code = getelementptr inbounds %class.MyError, ptr %0, i32 0, i32 1
  store i32 1, ptr %code, align 4, !tbaa !4
  ret void
}

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
  store i64 %task, ptr %task.h.addr, align 8, !tbaa !6
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

define internal ptr @Main.work(i32 %0) {
entry:
  %task = call i64 @__polaron_task_new()
  %state = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"Main.work$state", ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %"Main.work$state", ptr %state, i32 0, i32 0
  store i32 0, ptr %1, align 4
  %2 = getelementptr inbounds %"Main.work$state", ptr %state, i32 0, i32 1
  %3 = inttoptr i64 %task to ptr
  store ptr %3, ptr %2, align 8
  %4 = getelementptr inbounds %"Main.work$state", ptr %state, i32 0, i32 2
  store i32 %0, ptr %4, align 4
  call void @__polaron_schedule(ptr @"Main.work$resume", ptr %state)
  %task.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Task$int", ptr null, i64 1) to i64))
  call void @"Task$int.Task$int"(ptr %task.obj)
  %task.h.addr = getelementptr inbounds %"class.Task$int", ptr %task.obj, i32 0, i32 1
  store i64 %task, ptr %task.h.addr, align 8, !tbaa !6
  ret ptr %task.obj
}

define internal void @"Main.work$resume"(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown31 = alloca ptr, align 8
  %exc.thrown27 = alloca ptr, align 8
  %e = alloca ptr, align 8
  %exc.caught = alloca ptr, align 8
  %exc.thrown14 = alloca ptr, align 8
  %a = alloca i32, align 4
  %exc.thrown9 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %exc.async = alloca ptr, align 8
  %st.task.addr = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 1
  %st.task = load ptr, ptr %st.task.addr, align 8
  %fail = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 2
  %base = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 3
  %out = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 4
  %st.state.addr = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 0
  %st.state = load i32, ptr %st.state.addr, align 4
  switch i32 %st.state, label %body [
    i32 1, label %resume1
    i32 2, label %resume2
    i32 3, label %resume3
  ]

body:                                             ; preds = %entry
  %1 = invoke ptr @Main.val(i32 10)
          to label %invoke.cont unwind label %async.guard

suspend:                                          ; preds = %invoke.cont19, %invoke.cont1, %invoke.cont
  ret void

async.guard:                                      ; preds = %rethrow, %await.throw25, %catch.body, %ehpad, %await.throw, %body
  %2 = catchswitch within none [label %async.dispatch] unwind to caller

async.dispatch:                                   ; preds = %async.guard
  %3 = catchpad within %2 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.async]
  catchret from %3 to label %async.fail

async.fail:                                       ; preds = %async.dispatch
  %async.err = load ptr, ptr %exc.async, align 8
  %4 = ptrtoint ptr %st.task to i64
  %5 = ptrtoint ptr %async.err to i64
  call void @__polaron_task_complete_error(i64 %4, i64 %5)
  ret void

invoke.cont:                                      ; preds = %body
  %task.h.addr = getelementptr inbounds %"class.Task$int", ptr %1, i32 0, i32 1
  %task.h = load i64, ptr %task.h.addr, align 8, !tbaa !6
  %6 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 5
  store i64 %task.h, ptr %6, align 8
  %7 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 0
  store i32 1, ptr %7, align 4
  %"suspend?" = call i32 @__polaron_await(i64 %task.h, ptr @"Main.work$resume", ptr %0)
  %8 = icmp ne i32 %"suspend?", 0
  br i1 %8, label %suspend, label %resume1

resume1:                                          ; preds = %entry, %invoke.cont
  %9 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 5
  %aw.saved = load i64, ptr %9, align 8
  %aw.err = call i64 @__polaron_task_error(i64 %aw.saved)
  %10 = icmp ne i64 %aw.err, 0
  br i1 %10, label %await.throw, label %await.ok

await.throw:                                      ; preds = %resume1
  %11 = inttoptr i64 %aw.err to ptr
  store ptr %11, ptr %exc.thrown, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
          to label %throw.cont unwind label %async.guard

await.ok:                                         ; preds = %resume1
  %aw.result = call i64 @__polaron_task_result(i64 %aw.saved)
  %12 = trunc i64 %aw.result to i32
  store i32 %12, ptr %base, align 4
  store i32 0, ptr %out, align 4
  %13 = invoke ptr @Main.val(i32 20)
          to label %invoke.cont1 unwind label %ehpad

throw.cont:                                       ; preds = %await.throw
  unreachable

ehpad:                                            ; preds = %invoke.cont13, %if.then, %await.throw7, %await.ok
  %14 = catchswitch within none [label %catch.dispatch] unwind label %async.guard

try.cont:                                         ; preds = %await.ok26, %if.end
  %out33 = load i32, ptr %out, align 4
  %15 = add i32 %out33, 100
  store i32 %15, ptr %out, align 4
  %out34 = load i32, ptr %out, align 4
  %16 = ptrtoint ptr %st.task to i64
  %17 = sext i32 %out34 to i64
  call void @__polaron_task_complete(i64 %16, i64 %17)
  ret void

invoke.cont1:                                     ; preds = %await.ok
  %task.h.addr2 = getelementptr inbounds %"class.Task$int", ptr %13, i32 0, i32 1
  %task.h3 = load i64, ptr %task.h.addr2, align 8, !tbaa !6
  %18 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 6
  store i64 %task.h3, ptr %18, align 8
  %19 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 0
  store i32 2, ptr %19, align 4
  %"suspend?4" = call i32 @__polaron_await(i64 %task.h3, ptr @"Main.work$resume", ptr %0)
  %20 = icmp ne i32 %"suspend?4", 0
  br i1 %20, label %suspend, label %resume2

resume2:                                          ; preds = %entry, %invoke.cont1
  %21 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 6
  %aw.saved5 = load i64, ptr %21, align 8
  %aw.err6 = call i64 @__polaron_task_error(i64 %aw.saved5)
  %22 = icmp ne i64 %aw.err6, 0
  br i1 %22, label %await.throw7, label %await.ok8

await.throw7:                                     ; preds = %resume2
  %23 = inttoptr i64 %aw.err6 to ptr
  store ptr %23, ptr %exc.thrown9, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown9, ptr @_TI1PEAX)
          to label %throw.cont10 unwind label %ehpad

await.ok8:                                        ; preds = %resume2
  %aw.result11 = call i64 @__polaron_task_result(i64 %aw.saved5)
  %24 = trunc i64 %aw.result11 to i32
  store i32 %24, ptr %a, align 4
  %fail12 = load i32, ptr %fail, align 4
  %25 = icmp ne i32 %fail12, 0
  br i1 %25, label %if.then, label %if.end

throw.cont10:                                     ; preds = %await.throw7
  unreachable

if.then:                                          ; preds = %await.ok8
  %MyError.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.MyError, ptr null, i64 1) to i64))
  invoke void @MyError.MyError(ptr %MyError.obj)
          to label %invoke.cont13 unwind label %ehpad

if.end:                                           ; preds = %await.ok8
  %base16 = load i32, ptr %base, align 4
  %a17 = load i32, ptr %a, align 4
  %26 = add i32 %base16, %a17
  store i32 %26, ptr %out, align 4
  br label %try.cont

invoke.cont13:                                    ; preds = %if.then
  store ptr %MyError.obj, ptr %exc.thrown14, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown14, ptr @_TI1PEAX)
          to label %throw.cont15 unwind label %ehpad

throw.cont15:                                     ; preds = %invoke.cont13
  unreachable

catch.dispatch:                                   ; preds = %ehpad
  %27 = catchpad within %14 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.caught]
  %caught = load ptr, ptr %exc.caught, align 8
  %exc.vtbl = load ptr, ptr %caught, align 8
  %is = icmp eq ptr %exc.vtbl, @MyError.vtable
  br i1 %is, label %catch.match, label %catch.next

catch.match:                                      ; preds = %catch.dispatch
  store ptr %caught, ptr %e, align 8
  catchret from %27 to label %catch.body

catch.next:                                       ; preds = %catch.dispatch
  catchret from %27 to label %rethrow

catch.body:                                       ; preds = %catch.match
  %base18 = load i32, ptr %base, align 4
  %spill = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 6
  store i32 %base18, ptr %spill, align 4
  %28 = invoke ptr @Main.val(i32 5)
          to label %invoke.cont19 unwind label %async.guard

invoke.cont19:                                    ; preds = %catch.body
  %task.h.addr20 = getelementptr inbounds %"class.Task$int", ptr %28, i32 0, i32 1
  %task.h21 = load i64, ptr %task.h.addr20, align 8, !tbaa !6
  %29 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 7
  store i64 %task.h21, ptr %29, align 8
  %30 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 0
  store i32 3, ptr %30, align 4
  %"suspend?22" = call i32 @__polaron_await(i64 %task.h21, ptr @"Main.work$resume", ptr %0)
  %31 = icmp ne i32 %"suspend?22", 0
  br i1 %31, label %suspend, label %resume3

resume3:                                          ; preds = %entry, %invoke.cont19
  %32 = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 7
  %aw.saved23 = load i64, ptr %32, align 8
  %aw.err24 = call i64 @__polaron_task_error(i64 %aw.saved23)
  %33 = icmp ne i64 %aw.err24, 0
  br i1 %33, label %await.throw25, label %await.ok26

await.throw25:                                    ; preds = %resume3
  %34 = inttoptr i64 %aw.err24 to ptr
  store ptr %34, ptr %exc.thrown27, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown27, ptr @_TI1PEAX)
          to label %throw.cont28 unwind label %async.guard

await.ok26:                                       ; preds = %resume3
  %aw.result29 = call i64 @__polaron_task_result(i64 %aw.saved23)
  %35 = trunc i64 %aw.result29 to i32
  %reload = getelementptr inbounds %"Main.work$state", ptr %0, i32 0, i32 6
  %spilled = load i32, ptr %reload, align 4
  %36 = add i32 %spilled, %35
  store i32 %36, ptr %out, align 4
  br label %try.cont

throw.cont28:                                     ; preds = %await.throw25
  unreachable

rethrow:                                          ; preds = %catch.next
  %rethrow.obj = load ptr, ptr %exc.caught, align 8
  %out30 = load i32, ptr %out, align 4
  %37 = add i32 %out30, 100
  store i32 %37, ptr %out, align 4
  store ptr %rethrow.obj, ptr %exc.thrown31, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown31, ptr @_TI1PEAX)
          to label %throw.cont32 unwind label %async.guard

throw.cont32:                                     ; preds = %rethrow
  unreachable
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown9 = alloca ptr, align 8
  %bad = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %ok = alloca ptr, align 8
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
  %16 = call ptr @Main.work(i32 0)
  store ptr %16, ptr %ok, align 8
  %ok1 = load ptr, ptr %ok, align 8
  %task.h.addr = getelementptr inbounds %"class.Task$int", ptr %ok1, i32 0, i32 1
  %task.h = load i64, ptr %task.h.addr, align 8, !tbaa !6
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
  %21 = call ptr @Main.work(i32 1)
  store ptr %21, ptr %bad, align 8
  %bad2 = load ptr, ptr %bad, align 8
  %task.h.addr3 = getelementptr inbounds %"class.Task$int", ptr %bad2, i32 0, i32 1
  %task.h4 = load i64, ptr %task.h.addr3, align 8, !tbaa !6
  %await5 = call i64 @__polaron_task_wait(i64 %task.h4)
  %aw.err6 = call i64 @__polaron_task_error(i64 %task.h4)
  %22 = icmp ne i64 %aw.err6, 0
  br i1 %22, label %await.throw7, label %await.ok8

await.throw7:                                     ; preds = %await.ok
  %23 = inttoptr i64 %aw.err6 to ptr
  store ptr %23, ptr %exc.thrown9, align 8
  call void @_CxxThrowException(ptr %exc.thrown9, ptr @_TI1PEAX)
  unreachable

await.ok8:                                        ; preds = %await.ok
  %24 = trunc i64 %await5 to i32
  %25 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %24)
  ret i32 0
}

define internal void @"Task$int.Task$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Task$int", ptr %0, i32 0, i32 0
  store ptr @"Task$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %h = getelementptr inbounds %"class.Task$int", ptr %0, i32 0, i32 1
  store i64 0, ptr %h, align 8, !tbaa !6
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
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
