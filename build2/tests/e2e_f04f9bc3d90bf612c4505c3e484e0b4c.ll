; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/escape_ok.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/escape_ok.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32, ptr }
%class.Chain = type { ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Chain.vtable = private constant [350 x ptr] [ptr @Chain.push, ptr @Chain.sum, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Chain.~Chain"]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.panic = private unnamed_addr constant [134 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/escape_ok.pol:53:27  in Chain.sum\0A\00", align 1
@.panic.1 = private unnamed_addr constant [134 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/escape_ok.pol:54:26  in Chain.sum\0A\00", align 1
@.panic.2 = private unnamed_addr constant [137 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/escape_ok.pol:62:21  in Chain.~Chain\0A\00", align 1
@.panic.3 = private unnamed_addr constant [137 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/escape_ok.pol:63:21  in Chain.~Chain\0A\00", align 1
@.str = private unnamed_addr constant [17 x i8] c"sum=%d loose=%d\0A\00", align 1
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }

define internal void @Node.Node(ptr %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %val = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %v1 = load i32, ptr %v, align 4
  store i32 %v1, ptr %val, align 4, !tbaa !4
  %next = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  store ptr null, ptr %next, align 8, !tbaa !0
  ret void
}

define internal void @Chain.Chain(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 0
  store ptr @Chain.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %head = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 1
  store ptr null, ptr %head, align 8, !tbaa !0
  %count = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @Chain.push(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %n = alloca ptr, align 8
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %v1 = load i32, ptr %v, align 4
  call void @Node.Node(ptr %Node.obj, i32 %v1)
  store ptr %Node.obj, ptr %n, align 8
  %n2 = load ptr, ptr %n, align 8
  %next = getelementptr inbounds %class.Node, ptr %n2, i32 0, i32 2
  %head = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 1
  %head3 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head3, ptr %next, align 8, !tbaa !0
  %head4 = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 1
  %n5 = load ptr, ptr %n, align 8
  store ptr %n5, ptr %head4, align 8, !tbaa !0
  %count = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 2
  %count6 = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %2 = add i32 %count7, 1
  store i32 %2, ptr %count, align 4, !tbaa !4
  ret void
}

define internal ptr @Chain.spawn(i32 %0) {
entry:
  %n = alloca ptr, align 8
  %v = alloca i32, align 4
  store i32 %0, ptr %v, align 4
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %v1 = load i32, ptr %v, align 4
  call void @Node.Node(ptr %Node.obj, i32 %v1)
  store ptr %Node.obj, ptr %n, align 8
  %n2 = load ptr, ptr %n, align 8
  ret ptr %n2
}

define internal i32 @Chain.sum(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %walk = alloca ptr, align 8
  %total = alloca i32, align 4
  store i32 0, ptr %total, align 4
  %head = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 1
  %head1 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head1, ptr %walk, align 8
  br label %while.cond

while.cond:                                       ; preds = %nullrecv.ok8, %entry
  %walk2 = load ptr, ptr %walk, align 8
  %1 = icmp ne ptr %walk2, null
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %total3 = load i32, ptr %total, align 4
  %walk4 = load ptr, ptr %walk, align 8
  %3 = icmp eq ptr %walk4, null
  br i1 %3, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %total10 = load i32, ptr %total, align 4
  ret i32 %total10

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %val = getelementptr inbounds %class.Node, ptr %walk4, i32 0, i32 1
  %val5 = load i32, ptr %val, align 4, !tbaa !4
  %4 = add i32 %total3, %val5
  store i32 %4, ptr %total, align 4
  %walk6 = load ptr, ptr %walk, align 8
  %5 = icmp eq ptr %walk6, null
  br i1 %5, label %nullrecv7, label %nullrecv.ok8

nullrecv7:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.1)
  unreachable

nullrecv.ok8:                                     ; preds = %nullrecv.ok
  %next = getelementptr inbounds %class.Node, ptr %walk6, i32 0, i32 2
  %next9 = load ptr, ptr %next, align 8, !tbaa !0
  store ptr %next9, ptr %walk, align 8
  br label %while.cond
}

define internal void @"Chain.~Chain"(ptr %0) {
entry:
  %next5 = alloca ptr, align 8
  %walk = alloca ptr, align 8
  %head = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 1
  %head1 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head1, ptr %walk, align 8
  br label %while.cond

while.cond:                                       ; preds = %dtor.free, %entry
  %walk2 = load ptr, ptr %walk, align 8
  %1 = icmp ne ptr %walk2, null
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %walk3 = load ptr, ptr %walk, align 8
  %3 = icmp eq ptr %walk3, null
  br i1 %3, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %head10 = getelementptr inbounds %class.Chain, ptr %0, i32 0, i32 1
  store ptr null, ptr %head10, align 8, !tbaa !0
  ret void

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.2)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %next = getelementptr inbounds %class.Node, ptr %walk3, i32 0, i32 2
  %next4 = load ptr, ptr %next, align 8, !tbaa !0
  store ptr %next4, ptr %next5, align 8
  %walk6 = load ptr, ptr %walk, align 8
  %4 = icmp eq ptr %walk6, null
  br i1 %4, label %nullrecv7, label %nullrecv.ok8

nullrecv7:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.3)
  unreachable

nullrecv.ok8:                                     ; preds = %nullrecv.ok
  call void @__polaron_check_live(ptr %walk6)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %walk6, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %5 = icmp ne ptr %dtor.fn, null
  br i1 %5, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %nullrecv.ok8
  call void %dtor.fn(ptr %walk6)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %nullrecv.ok8
  call void @__polaron_free(ptr %walk6)
  %next9 = load ptr, ptr %next5, align 8
  store ptr %next9, ptr %walk, align 8
  br label %while.cond
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %loose = alloca ptr, align 8
  %c = alloca ptr, align 8
  store ptr null, ptr %c, align 8
  %Chain.obj = alloca %class.Chain, align 8
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
  call void @Chain.Chain(ptr %Chain.obj)
  store ptr %Chain.obj, ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  invoke void @Chain.push(ptr %c1, i32 1)
          to label %invoke.cont unwind label %cleanup.Chain

cleanup.Chain:                                    ; preds = %argv.end
  %16 = cleanuppad within none []
  %17 = load ptr, ptr %c, align 8
  call void @"Chain.~Chain"(ptr %17) [ "funclet"(token %16) ]
  cleanupret from %16 unwind to caller

invoke.cont:                                      ; preds = %argv.end
  %c2 = load ptr, ptr %c, align 8
  invoke void @Chain.push(ptr %c2, i32 2)
          to label %invoke.cont4 unwind label %cleanup.Chain3

cleanup.Chain3:                                   ; preds = %invoke.cont
  %18 = cleanuppad within none []
  %19 = load ptr, ptr %c, align 8
  call void @"Chain.~Chain"(ptr %19) [ "funclet"(token %18) ]
  cleanupret from %18 unwind to caller

invoke.cont4:                                     ; preds = %invoke.cont
  %c5 = load ptr, ptr %c, align 8
  invoke void @Chain.push(ptr %c5, i32 3)
          to label %invoke.cont7 unwind label %cleanup.Chain6

cleanup.Chain6:                                   ; preds = %invoke.cont4
  %20 = cleanuppad within none []
  %21 = load ptr, ptr %c, align 8
  call void @"Chain.~Chain"(ptr %21) [ "funclet"(token %20) ]
  cleanupret from %20 unwind to caller

invoke.cont7:                                     ; preds = %invoke.cont4
  %22 = invoke ptr @Chain.spawn(i32 10)
          to label %invoke.cont9 unwind label %cleanup.Chain8

cleanup.Chain8:                                   ; preds = %invoke.cont7
  %23 = cleanuppad within none []
  %24 = load ptr, ptr %c, align 8
  call void @"Chain.~Chain"(ptr %24) [ "funclet"(token %23) ]
  cleanupret from %23 unwind to caller

invoke.cont9:                                     ; preds = %invoke.cont7
  store ptr %22, ptr %loose, align 8
  %c10 = load ptr, ptr %c, align 8
  %25 = invoke i32 @Chain.sum(ptr %c10)
          to label %invoke.cont12 unwind label %cleanup.Chain11

cleanup.Chain11:                                  ; preds = %invoke.cont9
  %26 = cleanuppad within none []
  %27 = load ptr, ptr %c, align 8
  call void @"Chain.~Chain"(ptr %27) [ "funclet"(token %26) ]
  cleanupret from %26 unwind to caller

invoke.cont12:                                    ; preds = %invoke.cont9
  %loose13 = load ptr, ptr %loose, align 8
  %val = getelementptr inbounds %class.Node, ptr %loose13, i32 0, i32 1
  %val14 = load i32, ptr %val, align 4, !tbaa !4
  %28 = call i32 (ptr, ...) @printf(ptr @.str, i32 %25, i32 %val14)
  %loose15 = load ptr, ptr %loose, align 8
  call void @__polaron_check_live(ptr %loose15)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %loose15, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %29 = icmp ne ptr %dtor.fn, null
  br i1 %29, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %invoke.cont12
  call void %dtor.fn(ptr %loose15)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %invoke.cont12
  call void @__polaron_free(ptr %loose15)
  %30 = load ptr, ptr %c, align 8
  %31 = icmp ne ptr %30, null
  br i1 %31, label %dtor.live, label %dtor.done

dtor.live:                                        ; preds = %dtor.free
  call void @"Chain.~Chain"(ptr %30)
  br label %dtor.done

dtor.done:                                        ; preds = %dtor.live, %dtor.free
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare i64 @strlen(ptr)

declare i32 @__CxxFrameHandler3(...)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
