; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ptr_array.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ptr_array.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [349 x ptr] [ptr @Node.get, ptr @Node.set, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Node.~Node"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [5 x i8] c"~%d\0A\00", align 1
@.fail = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ptr_array.pol:29:24  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ptr_array.pol:30:24  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ptr_array.pol:31:27  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.7 = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1
@.fail.8 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ptr_array.pol:32:41  in main\0A\00", align 1
@.faila.9 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.10 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.11 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ptr_array.pol:32:41  in main\0A\00", align 1
@.faila.12 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.13 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.14 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"ok\0A\00", align 1
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }
@.strdata.5325 = private constant [1 x i8] zeroinitializer
@.strobj.5326 = private global %String { i64 0, ptr @.strdata.5325, i64 0 }

define internal void @Node.Node(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %id = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %i1 = load i32, ptr %i, align 4
  store i32 %i1, ptr %id, align 4, !tbaa !4
  ret void
}

define internal i32 @Node.get(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %id = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id1 = load i32, ptr %id, align 4, !tbaa !4
  ret i32 %id1
}

define internal void @Node.set(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %id = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %x1 = load i32, ptr %x, align 4
  store i32 %x1, ptr %id, align 4, !tbaa !4
  ret void
}

define internal void @"Node.~Node"(ptr %0) {
entry:
  %id = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id1 = load i32, ptr %id, align 4, !tbaa !4
  %1 = call i32 (ptr, ...) @printf(ptr @.str, i32 %id1)
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %arr3 = alloca ptr, align 8
  %b = alloca ptr, align 8
  store ptr null, ptr %b, align 8
  %Node.obj1 = alloca %class.Node, align 8
  %a = alloca ptr, align 8
  store ptr null, ptr %a, align 8
  %Node.obj = alloca %class.Node, align 8
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
  call void @Node.Node(ptr %Node.obj, i32 1)
  store ptr %Node.obj, ptr %a, align 8
  invoke void @Node.Node(ptr %Node.obj1, i32 2)
          to label %invoke.cont unwind label %cleanup.Node

cleanup.Node:                                     ; preds = %argv.end
  %16 = cleanuppad within none []
  %17 = load ptr, ptr %a, align 8
  call void @"Node.~Node"(ptr %17) [ "funclet"(token %16) ]
  cleanupret from %16 unwind to caller

invoke.cont:                                      ; preds = %argv.end
  store ptr %Node.obj1, ptr %b, align 8
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr, align 8
  %arr.data2 = getelementptr i8, ptr %arr, i64 8
  %18 = call ptr @memset(ptr %arr.data2, i32 0, i64 16)
  store ptr %arr, ptr %arr3, align 8
  %arr4 = load ptr, ptr %arr3, align 8, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %arr4, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %invoke.cont
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %invoke.cont
  %arr.data5 = getelementptr i8, ptr %arr4, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data5, i64 0
  %a6 = load ptr, ptr %a, align 8
  store ptr %a6, ptr %arr.elem, align 8
  %arr7 = load ptr, ptr %arr3, align 8, !nonnull !6, !dereferenceable !7
  %arr.len8 = load i64, ptr %arr7, align 8
  %arr.oob9 = icmp uge i64 1, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !8

idx.bad10:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %idx.ok
  %arr.data12 = getelementptr i8, ptr %arr7, i64 8
  %arr.elem13 = getelementptr inbounds ptr, ptr %arr.data12, i64 1
  %b14 = load ptr, ptr %b, align 8
  store ptr %b14, ptr %arr.elem13, align 8
  %arr15 = load ptr, ptr %arr3, align 8, !nonnull !6, !dereferenceable !7
  %arr.len16 = load i64, ptr %arr15, align 8
  %arr.oob17 = icmp uge i64 0, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

idx.bad18:                                        ; preds = %idx.ok11
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 0, ptr @.failb.6, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok11
  %arr.data20 = getelementptr i8, ptr %arr15, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 0
  %elem = load ptr, ptr %arr.elem21, align 8
  invoke void @Node.set(ptr %elem, i32 9)
          to label %invoke.cont24 unwind label %cleanup.Node23

cleanup.Node22:                                   ; preds = %cleanup.Node23
  %19 = cleanuppad within none []
  %20 = load ptr, ptr %a, align 8
  call void @"Node.~Node"(ptr %20) [ "funclet"(token %19) ]
  cleanupret from %19 unwind to caller

cleanup.Node23:                                   ; preds = %idx.ok19
  %21 = cleanuppad within none []
  %22 = load ptr, ptr %b, align 8
  call void @"Node.~Node"(ptr %22) [ "funclet"(token %21) ]
  cleanupret from %21 unwind label %cleanup.Node22

invoke.cont24:                                    ; preds = %idx.ok19
  %arr25 = load ptr, ptr %arr3, align 8, !nonnull !6, !dereferenceable !7
  %arr.len26 = load i64, ptr %arr25, align 8
  %arr.oob27 = icmp uge i64 0, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !8

idx.bad28:                                        ; preds = %invoke.cont24
  call void @__polaron_fail(ptr @.fail.8, ptr @.faila.9, i64 0, ptr @.failb.10, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %invoke.cont24
  %arr.data30 = getelementptr i8, ptr %arr25, i64 8
  %arr.elem31 = getelementptr inbounds ptr, ptr %arr.data30, i64 0
  %elem32 = load ptr, ptr %arr.elem31, align 8
  %23 = invoke i32 @Node.get(ptr %elem32)
          to label %invoke.cont35 unwind label %cleanup.Node34

cleanup.Node33:                                   ; preds = %cleanup.Node34
  %24 = cleanuppad within none []
  %25 = load ptr, ptr %a, align 8
  call void @"Node.~Node"(ptr %25) [ "funclet"(token %24) ]
  cleanupret from %24 unwind to caller

cleanup.Node34:                                   ; preds = %idx.ok29
  %26 = cleanuppad within none []
  %27 = load ptr, ptr %b, align 8
  call void @"Node.~Node"(ptr %27) [ "funclet"(token %26) ]
  cleanupret from %26 unwind label %cleanup.Node33

invoke.cont35:                                    ; preds = %idx.ok29
  %arr36 = load ptr, ptr %arr3, align 8, !nonnull !6, !dereferenceable !7
  %arr.len37 = load i64, ptr %arr36, align 8
  %arr.oob38 = icmp uge i64 1, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !8

idx.bad39:                                        ; preds = %invoke.cont35
  call void @__polaron_fail(ptr @.fail.11, ptr @.faila.12, i64 1, ptr @.failb.13, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %invoke.cont35
  %arr.data41 = getelementptr i8, ptr %arr36, i64 8
  %arr.elem42 = getelementptr inbounds ptr, ptr %arr.data41, i64 1
  %elem43 = load ptr, ptr %arr.elem42, align 8
  %28 = invoke i32 @Node.get(ptr %elem43)
          to label %invoke.cont46 unwind label %cleanup.Node45

cleanup.Node44:                                   ; preds = %cleanup.Node45
  %29 = cleanuppad within none []
  %30 = load ptr, ptr %a, align 8
  call void @"Node.~Node"(ptr %30) [ "funclet"(token %29) ]
  cleanupret from %29 unwind to caller

cleanup.Node45:                                   ; preds = %idx.ok40
  %31 = cleanuppad within none []
  %32 = load ptr, ptr %b, align 8
  call void @"Node.~Node"(ptr %32) [ "funclet"(token %31) ]
  cleanupret from %31 unwind label %cleanup.Node44

invoke.cont46:                                    ; preds = %idx.ok40
  %33 = add i32 %23, %28
  %34 = call i32 (ptr, ...) @printf(ptr @.str.7, i32 %33)
  %arr47 = load ptr, ptr %arr3, align 8
  call void @__polaron_free(ptr %arr47)
  %35 = call i32 (ptr, ...) @printf(ptr @.str.14, ptr @.str.15)
  %36 = load ptr, ptr %b, align 8
  %37 = icmp ne ptr %36, null
  br i1 %37, label %dtor.live, label %dtor.done

dtor.live:                                        ; preds = %invoke.cont46
  call void @"Node.~Node"(ptr %36)
  br label %dtor.done

dtor.done:                                        ; preds = %dtor.live, %invoke.cont46
  %38 = load ptr, ptr %a, align 8
  %39 = icmp ne ptr %38, null
  br i1 %39, label %dtor.live48, label %dtor.done49

dtor.live48:                                      ; preds = %dtor.done
  call void @"Node.~Node"(ptr %38)
  br label %dtor.done49

dtor.done49:                                      ; preds = %dtor.live48, %dtor.done
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5324)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5326)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @__CxxFrameHandler3(...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

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
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
