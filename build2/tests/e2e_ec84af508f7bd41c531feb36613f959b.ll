; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tcp_server.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tcp_server.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.ServerSocket = type { ptr, i64 }
%class.Thread = type { ptr, ptr, i64 }
%class.Object = type { ptr }
%class.Socket = type { ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Thread.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr @Thread.start, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Thread.join, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Socket.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Socket.close, ptr null, ptr @Socket.isOpen, ptr @Socket.send, ptr @Socket.receive, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ServerSocket.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @ServerSocket.close, ptr null, ptr @ServerSocket.isOpen, ptr null, ptr null, ptr @ServerSocket.accept, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [5 x i8] c"pong\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [10 x i8] c"127.0.0.1\00"
@.strobj.2 = private global %String { i64 9, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [5 x i8] c"ping\00"
@.strobj.4 = private global %String { i64 4, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [10 x i8] c"reply=%s\0A\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %reply = alloca ptr, align 8
  %client = alloca ptr, align 8
  %t = alloca ptr, align 8
  %serverFn = alloca ptr, align 8
  %server = alloca ptr, align 8
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
  %ServerSocket.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ServerSocket, ptr null, i64 1) to i64))
  call void @ServerSocket.ServerSocket(ptr %ServerSocket.obj, i32 54545)
  store ptr %ServerSocket.obj, ptr %server, align 8
  %env = call ptr @__polaron_malloc(i64 8)
  %16 = getelementptr ptr, ptr %env, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %17 = load ptr, ptr %server, align 8
  store ptr %17, ptr %cap, align 8
  store ptr %cap, ptr %16, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_0, ptr %closure, align 8
  %18 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env, ptr %18, align 8
  store ptr %closure, ptr %serverFn, align 8
  %Thread.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Thread, ptr null, i64 1) to i64))
  %serverFn1 = load ptr, ptr %serverFn, align 8
  call void @Thread.Thread(ptr %Thread.obj, ptr %serverFn1)
  store ptr %Thread.obj, ptr %t, align 8
  %t2 = load ptr, ptr %t, align 8
  call void @Thread.start(ptr %t2)
  call void @__polaron_sleep(i64 50)
  %19 = call ptr @Socket.connect(ptr @.strobj.2, i32 54545)
  store ptr %19, ptr %client, align 8
  %client3 = load ptr, ptr %client, align 8
  %20 = call i64 @Socket.send(ptr %client3, ptr @.strobj.4)
  %client4 = load ptr, ptr %client, align 8
  %21 = call ptr @Socket.receive(ptr %client4, i32 64)
  %strcpy = call ptr @__polaron_str_copy(ptr %21)
  store ptr %strcpy, ptr %reply, align 8
  call void @__polaron_str_free(ptr %21)
  %client5 = load ptr, ptr %client, align 8
  call void @Socket.close(ptr %client5)
  %t6 = load ptr, ptr %t, align 8
  call void @Thread.join(ptr %t6)
  %server7 = load ptr, ptr %server, align 8
  call void @ServerSocket.close(ptr %server7)
  %reply8 = load ptr, ptr %reply, align 8
  %str.data = getelementptr inbounds %String, ptr %reply8, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %22 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  %23 = load ptr, ptr %reply, align 8
  call void @__polaron_str_free(ptr %23)
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

define internal void @Socket.Socket(ptr %0, i64 %1) {
entry:
  %handle = alloca i64, align 8
  store i64 %1, ptr %handle, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Socket, ptr %0, i32 0, i32 0
  store ptr @Socket.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %handle1 = getelementptr inbounds %class.Socket, ptr %0, i32 0, i32 1
  %handle2 = load i64, ptr %handle, align 8
  store i64 %handle2, ptr %handle1, align 8, !tbaa !4
  ret void
}

define internal ptr @Socket.connect(ptr %0, i32 %1) {
entry:
  %port = alloca i32, align 4
  %host = alloca ptr, align 8
  store ptr %0, ptr %host, align 8
  store i32 %1, ptr %port, align 4
  %Socket.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Socket, ptr null, i64 1) to i64))
  %host1 = load ptr, ptr %host, align 8
  %port2 = load i32, ptr %port, align 4
  %str.data = getelementptr inbounds %String, ptr %host1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %2 = call i64 @__polaron_tcp_connect(ptr %data, i32 %port2)
  call void @Socket.Socket(ptr %Socket.obj, i64 %2)
  ret ptr %Socket.obj
}

define internal i32 @Socket.isOpen(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Socket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %1 = icmp sge i64 %handle1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal i64 @Socket.send(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  %handle = getelementptr inbounds %class.Socket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %data2 = load ptr, ptr %data, align 8
  %str.data = getelementptr inbounds %String, ptr %data2, i32 0, i32 1
  %data3 = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %data2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = call i64 @__polaron_tcp_send(i64 %handle1, ptr %data3, i64 %len)
  ret i64 %2
}

define internal ptr @Socket.receive(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %max = alloca i32, align 4
  store i32 %1, ptr %max, align 4
  %handle = getelementptr inbounds %class.Socket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %max2 = load i32, ptr %max, align 4
  %2 = sext i32 %max2 to i64
  %3 = add i64 %2, 1
  %rc.buf = call ptr @__polaron_malloc(i64 %3)
  %4 = call i64 @__polaron_tcp_recv(i64 %handle1, ptr %rc.buf, i64 %2)
  %5 = icmp slt i64 %4, 0
  %6 = select i1 %5, i64 0, i64 %4
  %7 = getelementptr i8, ptr %rc.buf, i64 %6
  store i8 0, ptr %7, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %6, ptr %8, align 8
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %rc.buf, ptr %9, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %10, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy
}

define internal void @Socket.close(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Socket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  call void @__polaron_tcp_close(i64 %handle1)
  ret void
}

define internal void @ServerSocket.ServerSocket(ptr %0, i32 %1) {
entry:
  %port = alloca i32, align 4
  store i32 %1, ptr %port, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ServerSocket, ptr %0, i32 0, i32 0
  store ptr @ServerSocket.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %handle = getelementptr inbounds %class.ServerSocket, ptr %0, i32 0, i32 1
  %port1 = load i32, ptr %port, align 4
  %2 = call i64 @__polaron_tcp_listen(i32 %port1)
  store i64 %2, ptr %handle, align 8, !tbaa !4
  ret void
}

define internal i32 @ServerSocket.isOpen(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.ServerSocket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %1 = icmp sge i64 %handle1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal ptr @ServerSocket.accept(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %Socket.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Socket, ptr null, i64 1) to i64))
  %handle = getelementptr inbounds %class.ServerSocket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %1 = call i64 @__polaron_tcp_accept(i64 %handle1)
  call void @Socket.Socket(ptr %Socket.obj, i64 %1)
  ret ptr %Socket.obj
}

define internal void @ServerSocket.close(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.ServerSocket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  call void @__polaron_tcp_close(i64 %handle1)
  ret void
}

define internal void @Thread.Thread(ptr %0, ptr %1) {
entry:
  %w = alloca ptr, align 8
  store ptr %1, ptr %w, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 0
  store ptr @Thread.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %work = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 1
  %w1 = load ptr, ptr %w, align 8
  store ptr %w1, ptr %work, align 8, !tbaa !0
  %handle = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 2
  store i64 0, ptr %handle, align 8, !tbaa !4
  ret void
}

define internal void @Thread.start(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %handle = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 2
  %work = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 1
  %work1 = load ptr, ptr %work, align 8, !tbaa !0
  %thread.h = call i64 @__polaron_thread_spawn(ptr %work1)
  store i64 %thread.h, ptr %handle, align 8, !tbaa !4
  ret void
}

define internal void @Thread.join(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %handle = getelementptr inbounds %class.Thread, ptr %0, i32 0, i32 2
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  call void @__polaron_thread_join(i64 %handle1)
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal void @__polaron_lambda_0(ptr %0) {
entry:
  %msg = alloca ptr, align 8
  %conn = alloca ptr, align 8
  %1 = getelementptr ptr, ptr %0, i32 0
  %server = load ptr, ptr %1, align 8
  %server1 = load ptr, ptr %server, align 8
  %2 = call ptr @ServerSocket.accept(ptr %server1)
  store ptr %2, ptr %conn, align 8
  %conn2 = load ptr, ptr %conn, align 8
  %3 = call ptr @Socket.receive(ptr %conn2, i32 64)
  %strcpy = call ptr @__polaron_str_copy(ptr %3)
  store ptr %strcpy, ptr %msg, align 8
  call void @__polaron_str_free(ptr %3)
  %conn3 = load ptr, ptr %conn, align 8
  %4 = call i64 @Socket.send(ptr %conn3, ptr @.strobj)
  %conn4 = load ptr, ptr %conn, align 8
  call void @Socket.close(ptr %conn4)
  %5 = load ptr, ptr %msg, align 8
  call void @__polaron_str_free(ptr %5)
  ret void
}

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare void @__polaron_sleep(i64)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @__polaron_tcp_connect(ptr, i32)

declare i64 @__polaron_tcp_send(i64, ptr, i64)

declare i64 @__polaron_tcp_recv(i64, ptr, i64)

declare void @__polaron_tcp_close(i64)

declare i64 @__polaron_tcp_listen(i32)

declare i64 @__polaron_tcp_accept(i64)

declare i64 @__polaron_thread_spawn(ptr)

declare void @__polaron_thread_join(i64)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i64", !2, i64 0}
