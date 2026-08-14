; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/async_chain.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/async_chain.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"Main.val$state" = type { i32, ptr, i32 }
%"class.Task$int" = type { ptr, i64 }
%"Main.pipeline$state" = type { i32, ptr, i32, i32, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
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
@.str = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1
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

define internal ptr @Main.pipeline() {
entry:
  %task = call i64 @__polaron_task_new()
  %state = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"Main.pipeline$state", ptr null, i64 1) to i64))
  %0 = getelementptr inbounds %"Main.pipeline$state", ptr %state, i32 0, i32 0
  store i32 0, ptr %0, align 4
  %1 = getelementptr inbounds %"Main.pipeline$state", ptr %state, i32 0, i32 1
  %2 = inttoptr i64 %task to ptr
  store ptr %2, ptr %1, align 8
  call void @__polaron_schedule(ptr @"Main.pipeline$resume", ptr %state)
  %task.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Task$int", ptr null, i64 1) to i64))
  call void @"Task$int.Task$int"(ptr %task.obj)
  %task.h.addr = getelementptr inbounds %"class.Task$int", ptr %task.obj, i32 0, i32 1
  store i64 %task, ptr %task.h.addr, align 8, !tbaa !0
  ret ptr %task.obj
}

define internal void @"Main.pipeline$resume"(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown20 = alloca ptr, align 8
  %exc.thrown9 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %exc.async = alloca ptr, align 8
  %st.task.addr = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 1
  %st.task = load ptr, ptr %st.task.addr, align 8
  %a = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 2
  %b = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 3
  %c = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 4
  %st.state.addr = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 0
  %st.state = load i32, ptr %st.state.addr, align 4
  switch i32 %st.state, label %body [
    i32 1, label %resume1
    i32 2, label %resume2
    i32 3, label %resume3
  ]

body:                                             ; preds = %entry
  %1 = invoke ptr @Main.val(i32 10)
          to label %invoke.cont unwind label %async.guard

suspend:                                          ; preds = %invoke.cont12, %invoke.cont1, %invoke.cont
  ret void

async.guard:                                      ; preds = %await.throw18, %await.ok8, %await.throw7, %await.ok, %await.throw, %body
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
  %task.h = load i64, ptr %task.h.addr, align 8, !tbaa !0
  %6 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 5
  store i64 %task.h, ptr %6, align 8
  %7 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 0
  store i32 1, ptr %7, align 4
  %"suspend?" = call i32 @__polaron_await(i64 %task.h, ptr @"Main.pipeline$resume", ptr %0)
  %8 = icmp ne i32 %"suspend?", 0
  br i1 %8, label %suspend, label %resume1

resume1:                                          ; preds = %entry, %invoke.cont
  %9 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 5
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
  store i32 %12, ptr %a, align 4
  %13 = invoke ptr @Main.val(i32 20)
          to label %invoke.cont1 unwind label %async.guard

throw.cont:                                       ; preds = %await.throw
  unreachable

invoke.cont1:                                     ; preds = %await.ok
  %task.h.addr2 = getelementptr inbounds %"class.Task$int", ptr %13, i32 0, i32 1
  %task.h3 = load i64, ptr %task.h.addr2, align 8, !tbaa !0
  %14 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 6
  store i64 %task.h3, ptr %14, align 8
  %15 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 0
  store i32 2, ptr %15, align 4
  %"suspend?4" = call i32 @__polaron_await(i64 %task.h3, ptr @"Main.pipeline$resume", ptr %0)
  %16 = icmp ne i32 %"suspend?4", 0
  br i1 %16, label %suspend, label %resume2

resume2:                                          ; preds = %entry, %invoke.cont1
  %17 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 6
  %aw.saved5 = load i64, ptr %17, align 8
  %aw.err6 = call i64 @__polaron_task_error(i64 %aw.saved5)
  %18 = icmp ne i64 %aw.err6, 0
  br i1 %18, label %await.throw7, label %await.ok8

await.throw7:                                     ; preds = %resume2
  %19 = inttoptr i64 %aw.err6 to ptr
  store ptr %19, ptr %exc.thrown9, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown9, ptr @_TI1PEAX)
          to label %throw.cont10 unwind label %async.guard

await.ok8:                                        ; preds = %resume2
  %aw.result11 = call i64 @__polaron_task_result(i64 %aw.saved5)
  %20 = trunc i64 %aw.result11 to i32
  store i32 %20, ptr %b, align 4
  %21 = invoke ptr @Main.val(i32 30)
          to label %invoke.cont12 unwind label %async.guard

throw.cont10:                                     ; preds = %await.throw7
  unreachable

invoke.cont12:                                    ; preds = %await.ok8
  %task.h.addr13 = getelementptr inbounds %"class.Task$int", ptr %21, i32 0, i32 1
  %task.h14 = load i64, ptr %task.h.addr13, align 8, !tbaa !0
  %22 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 7
  store i64 %task.h14, ptr %22, align 8
  %23 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 0
  store i32 3, ptr %23, align 4
  %"suspend?15" = call i32 @__polaron_await(i64 %task.h14, ptr @"Main.pipeline$resume", ptr %0)
  %24 = icmp ne i32 %"suspend?15", 0
  br i1 %24, label %suspend, label %resume3

resume3:                                          ; preds = %entry, %invoke.cont12
  %25 = getelementptr inbounds %"Main.pipeline$state", ptr %0, i32 0, i32 7
  %aw.saved16 = load i64, ptr %25, align 8
  %aw.err17 = call i64 @__polaron_task_error(i64 %aw.saved16)
  %26 = icmp ne i64 %aw.err17, 0
  br i1 %26, label %await.throw18, label %await.ok19

await.throw18:                                    ; preds = %resume3
  %27 = inttoptr i64 %aw.err17 to ptr
  store ptr %27, ptr %exc.thrown20, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown20, ptr @_TI1PEAX)
          to label %throw.cont21 unwind label %async.guard

await.ok19:                                       ; preds = %resume3
  %aw.result22 = call i64 @__polaron_task_result(i64 %aw.saved16)
  %28 = trunc i64 %aw.result22 to i32
  store i32 %28, ptr %c, align 4
  %a23 = load i32, ptr %a, align 4
  %b24 = load i32, ptr %b, align 4
  %29 = add i32 %a23, %b24
  %c25 = load i32, ptr %c, align 4
  %30 = add i32 %29, %c25
  %31 = ptrtoint ptr %st.task to i64
  %32 = sext i32 %30 to i64
  call void @__polaron_task_complete(i64 %31, i64 %32)
  ret void

throw.cont21:                                     ; preds = %await.throw18
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
  %16 = call ptr @Main.pipeline()
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
