; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/udp_socket.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/udp_socket.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.UdpSocket = type { ptr, i64 }
%class.Datagram = type { ptr, ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Datagram.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@UdpSocket.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @UdpSocket.close, ptr null, ptr @UdpSocket.isOpen, ptr @UdpSocket.send, ptr @UdpSocket.receive, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [10 x i8] c"127.0.0.1\00"
@.strobj = private global %String { i64 9, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [5 x i8] c"ping\00"
@.strobj.2 = private global %String { i64 4, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [5 x i8] c"ping\00"
@.strobj.4 = private global %String { i64 4, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [10 x i8] c"127.0.0.1\00"
@.strobj.6 = private global %String { i64 9, ptr @.strdata.5, i64 0 }
@.str = private unnamed_addr constant [15 x i8] c"ok=%d from=%d\0A\00", align 1
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %from = alloca i32, align 4
  %ok = alloca i32, align 4
  %d = alloca ptr, align 8
  %sent = alloca i64, align 8
  %client = alloca ptr, align 8
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
  %UdpSocket.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UdpSocket, ptr null, i64 1) to i64))
  call void @UdpSocket.UdpSocket(ptr %UdpSocket.obj, i32 38714)
  store ptr %UdpSocket.obj, ptr %server, align 8
  %UdpSocket.obj1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UdpSocket, ptr null, i64 1) to i64))
  call void @UdpSocket.UdpSocket(ptr %UdpSocket.obj1, i32 0)
  store ptr %UdpSocket.obj1, ptr %client, align 8
  %client2 = load ptr, ptr %client, align 8
  %16 = call i64 @UdpSocket.send(ptr %client2, ptr @.strobj, i32 38714, ptr @.strobj.2)
  store i64 %16, ptr %sent, align 8
  %server3 = load ptr, ptr %server, align 8
  %17 = call ptr @UdpSocket.receive(ptr %server3, i32 64)
  store ptr %17, ptr %d, align 8
  %d4 = load ptr, ptr %d, align 8
  %data = getelementptr inbounds %class.Datagram, ptr %d4, i32 0, i32 1
  %data5 = load ptr, ptr %data, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %data5, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %data7 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %18 = call i32 @strcmp(ptr %data6, ptr %data7)
  %19 = icmp eq i32 %18, 0
  %20 = zext i1 %19 to i32
  store i32 %20, ptr %ok, align 4
  %d8 = load ptr, ptr %d, align 8
  %host = getelementptr inbounds %class.Datagram, ptr %d8, i32 0, i32 2
  %host9 = load ptr, ptr %host, align 8, !tbaa !0
  %str.data10 = getelementptr inbounds %String, ptr %host9, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %data12 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %21 = call i32 @strcmp(ptr %data11, ptr %data12)
  %22 = icmp eq i32 %21, 0
  %23 = zext i1 %22 to i32
  store i32 %23, ptr %from, align 4
  %ok13 = load i32, ptr %ok, align 4
  %from14 = load i32, ptr %from, align 4
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %ok13, i32 %from14)
  %server15 = load ptr, ptr %server, align 8
  call void @UdpSocket.close(ptr %server15)
  %client16 = load ptr, ptr %client, align 8
  call void @UdpSocket.close(ptr %client16)
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

define internal void @Datagram.Datagram(ptr %0, ptr %1, ptr %2, i32 %3) {
entry:
  %port = alloca i32, align 4
  %host = alloca ptr, align 8
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  store ptr %2, ptr %host, align 8
  store i32 %3, ptr %port, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Datagram, ptr %0, i32 0, i32 0
  store ptr @Datagram.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %data1 = getelementptr inbounds %class.Datagram, ptr %0, i32 0, i32 1
  store ptr null, ptr %data1, align 8, !tbaa !0
  %host2 = getelementptr inbounds %class.Datagram, ptr %0, i32 0, i32 2
  store ptr null, ptr %host2, align 8, !tbaa !0
  %data3 = getelementptr inbounds %class.Datagram, ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %data4)
  %4 = load ptr, ptr %data3, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %4)
  store ptr %strcpy, ptr %data3, align 8, !tbaa !0
  %host5 = getelementptr inbounds %class.Datagram, ptr %0, i32 0, i32 2
  %host6 = load ptr, ptr %host, align 8
  %strcpy7 = call ptr @__polaron_str_copy(ptr %host6)
  %5 = load ptr, ptr %host5, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %5)
  store ptr %strcpy7, ptr %host5, align 8, !tbaa !0
  %port8 = getelementptr inbounds %class.Datagram, ptr %0, i32 0, i32 3
  %port9 = load i32, ptr %port, align 4
  store i32 %port9, ptr %port8, align 4, !tbaa !4
  ret void
}

define internal void @UdpSocket.UdpSocket(ptr %0, i32 %1) {
entry:
  %port = alloca i32, align 4
  store i32 %1, ptr %port, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.UdpSocket, ptr %0, i32 0, i32 0
  store ptr @UdpSocket.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %handle = getelementptr inbounds %class.UdpSocket, ptr %0, i32 0, i32 1
  %port1 = load i32, ptr %port, align 4
  %2 = call i64 @__polaron_udp_open(i32 %port1)
  store i64 %2, ptr %handle, align 8, !tbaa !6
  ret void
}

define internal i32 @UdpSocket.isOpen(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.UdpSocket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !6
  %1 = icmp sge i64 %handle1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal i64 @UdpSocket.send(ptr nonnull align 8 dereferenceable(16) %0, ptr %1, i32 %2, ptr %3) {
entry:
  %data = alloca ptr, align 8
  %port = alloca i32, align 4
  %host = alloca ptr, align 8
  store ptr %1, ptr %host, align 8
  store i32 %2, ptr %port, align 4
  store ptr %3, ptr %data, align 8
  %handle = getelementptr inbounds %class.UdpSocket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !6
  %host2 = load ptr, ptr %host, align 8
  %port3 = load i32, ptr %port, align 4
  %data4 = load ptr, ptr %data, align 8
  %str.data = getelementptr inbounds %String, ptr %host2, i32 0, i32 1
  %data5 = load ptr, ptr %str.data, align 8
  %str.data6 = getelementptr inbounds %String, ptr %data4, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %str.len = getelementptr inbounds %String, ptr %data4, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %4 = call i64 @__polaron_udp_sendto(i64 %handle1, ptr %data5, i32 %port3, ptr %data7, i64 %len)
  ret i64 %4
}

define internal ptr @UdpSocket.receive(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %payload = alloca ptr, align 8
  %max = alloca i32, align 4
  store i32 %1, ptr %max, align 4
  %handle = getelementptr inbounds %class.UdpSocket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !6
  %max2 = load i32, ptr %max, align 4
  %2 = sext i32 %max2 to i64
  %3 = add i64 %2, 1
  %urc.buf = call ptr @__polaron_malloc(i64 %3)
  %4 = call i64 @__polaron_udp_recvfrom(i64 %handle1, ptr %urc.buf, i64 %2)
  %5 = icmp slt i64 %4, 0
  %6 = select i1 %5, i64 0, i64 %4
  %7 = getelementptr i8, ptr %urc.buf, i64 %6
  store i8 0, ptr %7, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %6, ptr %8, align 8
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %urc.buf, ptr %9, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %10, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy, ptr %payload, align 8
  call void @__polaron_str_free(ptr %newstr)
  %Datagram.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Datagram, ptr null, i64 1) to i64))
  %payload3 = load ptr, ptr %payload, align 8
  %11 = call ptr @__polaron_udp_peer_host()
  %ph.len = call i64 @strlen(ptr %11)
  %newstr4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %12 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %ph.len, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %11, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %14, align 8
  %15 = call i32 @__polaron_udp_peer_port()
  call void @Datagram.Datagram(ptr %Datagram.obj, ptr %payload3, ptr %newstr4, i32 %15)
  %16 = load ptr, ptr %payload, align 8
  call void @__polaron_str_free(ptr %16)
  ret ptr %Datagram.obj
}

define internal void @UdpSocket.close(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.UdpSocket, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !6
  call void @__polaron_udp_close(i64 %handle1)
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @strcmp(ptr, ptr)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i64 @__polaron_udp_open(i32)

declare i64 @__polaron_udp_sendto(i64, ptr, i32, ptr, i64)

declare i64 @__polaron_udp_recvfrom(i64, ptr, i64)

declare ptr @__polaron_udp_peer_host()

declare i32 @__polaron_udp_peer_port()

declare void @__polaron_udp_close(i64)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
