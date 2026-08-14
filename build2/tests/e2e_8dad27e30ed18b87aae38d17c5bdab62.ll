; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.Node = type { ptr, i64 }
%class.app__Graph = type { ptr, ptr }
%String = type { i64, ptr, i64 }
%class.Object = type { ptr }

@Node.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@app__Graph.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:17:28  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:17:63  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:18:28  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:18:63  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:20:30  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [25 x i8] c"a0=%d a1=%d b0=%d b1=%d\0A\00", align 1
@.fail.13 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:21:41  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:21:41  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:21:41  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/deep_copy_array.pol:21:41  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1

define internal void @Node.Node(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @app__Graph.app__Graph(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.app__Graph, ptr %0, i32 0, i32 0
  store ptr @app__Graph.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %nodes = getelementptr inbounds %class.app__Graph, ptr %0, i32 0, i32 1
  store ptr null, ptr %nodes, align 8, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %app__Graph.copy = alloca %class.app__Graph, align 8
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
  %app__Graph.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.app__Graph, ptr null, i64 1) to i64))
  call void @app__Graph.app__Graph(ptr %app__Graph.obj)
  store ptr %app__Graph.obj, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %nodes = getelementptr inbounds %class.app__Graph, ptr %a1, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr, align 8
  %arr.data2 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data2, i32 0, i64 16)
  store ptr %arr, ptr %nodes, align 8, !tbaa !0
  %a3 = load ptr, ptr %a, align 8
  %nodes4 = getelementptr inbounds %class.app__Graph, ptr %a3, i32 0, i32 1
  %nodes5 = load ptr, ptr %nodes4, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len = load i64, ptr %nodes5, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data6 = getelementptr i8, ptr %nodes5, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data6, i64 0
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj)
  store ptr %Node.obj, ptr %arr.elem, align 8
  %a7 = load ptr, ptr %a, align 8
  %nodes8 = getelementptr inbounds %class.app__Graph, ptr %a7, i32 0, i32 1
  %nodes9 = load ptr, ptr %nodes8, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len10 = load i64, ptr %nodes9, align 8
  %arr.oob11 = icmp uge i64 0, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !6

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 0, ptr @.failb.3, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %nodes9, i64 8
  %arr.elem15 = getelementptr inbounds ptr, ptr %arr.data14, i64 0
  %elem = load ptr, ptr %arr.elem15, align 8
  %v = getelementptr inbounds %class.Node, ptr %elem, i32 0, i32 1
  store i64 10, ptr %v, align 8, !tbaa !7
  %a16 = load ptr, ptr %a, align 8
  %nodes17 = getelementptr inbounds %class.app__Graph, ptr %a16, i32 0, i32 1
  %nodes18 = load ptr, ptr %nodes17, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len19 = load i64, ptr %nodes18, align 8
  %arr.oob20 = icmp uge i64 1, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !6

idx.bad21:                                        ; preds = %idx.ok13
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 1, ptr @.failb.6, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok13
  %arr.data23 = getelementptr i8, ptr %nodes18, i64 8
  %arr.elem24 = getelementptr inbounds ptr, ptr %arr.data23, i64 1
  %Node.obj25 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj25)
  store ptr %Node.obj25, ptr %arr.elem24, align 8
  %a26 = load ptr, ptr %a, align 8
  %nodes27 = getelementptr inbounds %class.app__Graph, ptr %a26, i32 0, i32 1
  %nodes28 = load ptr, ptr %nodes27, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len29 = load i64, ptr %nodes28, align 8
  %arr.oob30 = icmp uge i64 1, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !6

idx.bad31:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 1, ptr @.failb.9, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok22
  %arr.data33 = getelementptr i8, ptr %nodes28, i64 8
  %arr.elem34 = getelementptr inbounds ptr, ptr %arr.data33, i64 1
  %elem35 = load ptr, ptr %arr.elem34, align 8
  %v36 = getelementptr inbounds %class.Node, ptr %elem35, i32 0, i32 1
  store i64 20, ptr %v36, align 8, !tbaa !7
  %a37 = load ptr, ptr %a, align 8
  %17 = call ptr @memcpy(ptr %app__Graph.copy, ptr %a37, i64 ptrtoint (ptr getelementptr (%class.app__Graph, ptr null, i64 1) to i64))
  %18 = getelementptr inbounds %class.app__Graph, ptr %a37, i32 0, i32 1
  %19 = load ptr, ptr %18, align 8, !tbaa !0
  %arr.len38 = load i64, ptr %19, align 8
  %20 = mul i64 %arr.len38, 8
  %21 = add i64 8, %20
  %arr.copy = call ptr @__polaron_malloc(i64 %21)
  %22 = call ptr @memcpy(ptr %arr.copy, ptr %19, i64 %21)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %idx.ok32
  %i = phi i64 [ 0, %idx.ok32 ], [ %29, %arrdup.cont ]
  %23 = icmp slt i64 %i, %arr.len38
  br i1 %23, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %24 = mul i64 %i, 8
  %25 = add i64 8, %24
  %26 = getelementptr i8, ptr %arr.copy, i64 %25
  %elem39 = load ptr, ptr %26, align 8
  %27 = icmp eq ptr %elem39, null
  br i1 %27, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %28 = call ptr @memcpy(ptr %Node.copy, ptr %elem39, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy, ptr %26, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %29 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %30 = getelementptr inbounds %class.app__Graph, ptr %app__Graph.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %30, align 8, !tbaa !0
  store ptr %app__Graph.copy, ptr %b, align 8
  %b40 = load ptr, ptr %b, align 8
  %nodes41 = getelementptr inbounds %class.app__Graph, ptr %b40, i32 0, i32 1
  %nodes42 = load ptr, ptr %nodes41, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len43 = load i64, ptr %nodes42, align 8
  %arr.oob44 = icmp uge i64 0, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !6

idx.bad45:                                        ; preds = %arrdup.done
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 0, ptr @.failb.12, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %arrdup.done
  %arr.data47 = getelementptr i8, ptr %nodes42, i64 8
  %arr.elem48 = getelementptr inbounds ptr, ptr %arr.data47, i64 0
  %elem49 = load ptr, ptr %arr.elem48, align 8
  %v50 = getelementptr inbounds %class.Node, ptr %elem49, i32 0, i32 1
  store i64 99, ptr %v50, align 8, !tbaa !7
  %a51 = load ptr, ptr %a, align 8
  %nodes52 = getelementptr inbounds %class.app__Graph, ptr %a51, i32 0, i32 1
  %nodes53 = load ptr, ptr %nodes52, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len54 = load i64, ptr %nodes53, align 8
  %arr.oob55 = icmp uge i64 0, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !6

idx.bad56:                                        ; preds = %idx.ok46
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 0, ptr @.failb.15, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %idx.ok46
  %arr.data58 = getelementptr i8, ptr %nodes53, i64 8
  %arr.elem59 = getelementptr inbounds ptr, ptr %arr.data58, i64 0
  %elem60 = load ptr, ptr %arr.elem59, align 8
  %v61 = getelementptr inbounds %class.Node, ptr %elem60, i32 0, i32 1
  %v62 = load i64, ptr %v61, align 8, !tbaa !7
  %31 = trunc i64 %v62 to i32
  %a63 = load ptr, ptr %a, align 8
  %nodes64 = getelementptr inbounds %class.app__Graph, ptr %a63, i32 0, i32 1
  %nodes65 = load ptr, ptr %nodes64, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len66 = load i64, ptr %nodes65, align 8
  %arr.oob67 = icmp uge i64 1, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !6

idx.bad68:                                        ; preds = %idx.ok57
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 1, ptr @.failb.18, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %idx.ok57
  %arr.data70 = getelementptr i8, ptr %nodes65, i64 8
  %arr.elem71 = getelementptr inbounds ptr, ptr %arr.data70, i64 1
  %elem72 = load ptr, ptr %arr.elem71, align 8
  %v73 = getelementptr inbounds %class.Node, ptr %elem72, i32 0, i32 1
  %v74 = load i64, ptr %v73, align 8, !tbaa !7
  %32 = trunc i64 %v74 to i32
  %b75 = load ptr, ptr %b, align 8
  %nodes76 = getelementptr inbounds %class.app__Graph, ptr %b75, i32 0, i32 1
  %nodes77 = load ptr, ptr %nodes76, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len78 = load i64, ptr %nodes77, align 8
  %arr.oob79 = icmp uge i64 0, %arr.len78
  br i1 %arr.oob79, label %idx.bad80, label %idx.ok81, !prof !6

idx.bad80:                                        ; preds = %idx.ok69
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 0, ptr @.failb.21, i64 %arr.len78, i32 70)
  unreachable

idx.ok81:                                         ; preds = %idx.ok69
  %arr.data82 = getelementptr i8, ptr %nodes77, i64 8
  %arr.elem83 = getelementptr inbounds ptr, ptr %arr.data82, i64 0
  %elem84 = load ptr, ptr %arr.elem83, align 8
  %v85 = getelementptr inbounds %class.Node, ptr %elem84, i32 0, i32 1
  %v86 = load i64, ptr %v85, align 8, !tbaa !7
  %33 = trunc i64 %v86 to i32
  %b87 = load ptr, ptr %b, align 8
  %nodes88 = getelementptr inbounds %class.app__Graph, ptr %b87, i32 0, i32 1
  %nodes89 = load ptr, ptr %nodes88, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len90 = load i64, ptr %nodes89, align 8
  %arr.oob91 = icmp uge i64 1, %arr.len90
  br i1 %arr.oob91, label %idx.bad92, label %idx.ok93, !prof !6

idx.bad92:                                        ; preds = %idx.ok81
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 1, ptr @.failb.24, i64 %arr.len90, i32 70)
  unreachable

idx.ok93:                                         ; preds = %idx.ok81
  %arr.data94 = getelementptr i8, ptr %nodes89, i64 8
  %arr.elem95 = getelementptr inbounds ptr, ptr %arr.data94, i64 1
  %elem96 = load ptr, ptr %arr.elem95, align 8
  %v97 = getelementptr inbounds %class.Node, ptr %elem96, i32 0, i32 1
  %v98 = load i64, ptr %v97, align 8, !tbaa !7
  %34 = trunc i64 %v98 to i32
  %35 = call i32 (ptr, ...) @printf(ptr @.str, i32 %31, i32 %32, i32 %33, i32 %34)
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

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{}
!5 = !{i64 8}
!6 = !{!"branch_weights", i32 1, i32 1048576}
!7 = !{!8, !8, i64 0}
!8 = !{!"i64", !2, i64 0}
