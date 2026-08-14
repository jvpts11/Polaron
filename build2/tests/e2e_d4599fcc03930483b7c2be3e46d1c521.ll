; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.panic = private unnamed_addr constant [133 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol:26:22  in main\0A\00", align 1
@.panic.1 = private unnamed_addr constant [133 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol:26:39  in main\0A\00", align 1
@.panic.2 = private unnamed_addr constant [133 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol:26:39  in main\0A\00", align 1
@.panic.3 = private unnamed_addr constant [133 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol:27:42  in main\0A\00", align 1
@.panic.4 = private unnamed_addr constant [133 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol:27:42  in main\0A\00", align 1
@.panic.5 = private unnamed_addr constant [133 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol:27:42  in main\0A\00", align 1
@.panic.6 = private unnamed_addr constant [133 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol:27:42  in main\0A\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"%d %d %d %d\0A\00", align 1
@.panic.7 = private unnamed_addr constant [133 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_clone.pol:29:17  in main\0A\00", align 1
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }

define internal void @Node.Node(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %id = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  store i32 0, ptr %id, align 4, !tbaa !4
  %next = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  store ptr null, ptr %next, align 8, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca ptr, align 8
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
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj)
  store ptr %Node.obj, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %id = getelementptr inbounds %class.Node, ptr %a1, i32 0, i32 1
  store i32 1, ptr %id, align 4, !tbaa !4
  %Node.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj2)
  store ptr %Node.obj2, ptr %b, align 8
  %b3 = load ptr, ptr %b, align 8
  %id4 = getelementptr inbounds %class.Node, ptr %b3, i32 0, i32 1
  store i32 2, ptr %id4, align 4, !tbaa !4
  %a5 = load ptr, ptr %a, align 8
  %next = getelementptr inbounds %class.Node, ptr %a5, i32 0, i32 2
  %b6 = load ptr, ptr %b, align 8
  store ptr %b6, ptr %next, align 8, !tbaa !0
  store ptr null, ptr %c, align 8
  %a7 = load ptr, ptr %a, align 8
  %16 = call ptr @__polaron_ptrmap_new()
  %17 = call ptr @__cascade.clone.0.Node(ptr %a7, ptr %16, i32 -1)
  call void @__polaron_ptrmap_free(ptr %16)
  store ptr %17, ptr %c, align 8
  %c8 = load ptr, ptr %c, align 8
  %18 = icmp eq ptr %c8, null
  br i1 %18, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %argv.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %argv.end
  %id9 = getelementptr inbounds %class.Node, ptr %c8, i32 0, i32 1
  store i32 100, ptr %id9, align 4, !tbaa !4
  %c10 = load ptr, ptr %c, align 8
  %19 = icmp eq ptr %c10, null
  br i1 %19, label %nullrecv11, label %nullrecv.ok12

nullrecv11:                                       ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.1)
  unreachable

nullrecv.ok12:                                    ; preds = %nullrecv.ok
  %next13 = getelementptr inbounds %class.Node, ptr %c10, i32 0, i32 2
  %next14 = load ptr, ptr %next13, align 8, !tbaa !0
  %20 = icmp eq ptr %next14, null
  br i1 %20, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok12
  call void @__polaron_panic(ptr @.panic.2)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok12
  %id17 = getelementptr inbounds %class.Node, ptr %next14, i32 0, i32 1
  store i32 200, ptr %id17, align 4, !tbaa !4
  %a18 = load ptr, ptr %a, align 8
  %id19 = getelementptr inbounds %class.Node, ptr %a18, i32 0, i32 1
  %id20 = load i32, ptr %id19, align 4, !tbaa !4
  %a21 = load ptr, ptr %a, align 8
  %next22 = getelementptr inbounds %class.Node, ptr %a21, i32 0, i32 2
  %next23 = load ptr, ptr %next22, align 8, !tbaa !0
  %21 = icmp eq ptr %next23, null
  br i1 %21, label %nullrecv24, label %nullrecv.ok25

nullrecv24:                                       ; preds = %nullrecv.ok16
  call void @__polaron_panic(ptr @.panic.3)
  unreachable

nullrecv.ok25:                                    ; preds = %nullrecv.ok16
  %id26 = getelementptr inbounds %class.Node, ptr %next23, i32 0, i32 1
  %id27 = load i32, ptr %id26, align 4, !tbaa !4
  %c28 = load ptr, ptr %c, align 8
  %22 = icmp eq ptr %c28, null
  br i1 %22, label %nullrecv29, label %nullrecv.ok30

nullrecv29:                                       ; preds = %nullrecv.ok25
  call void @__polaron_panic(ptr @.panic.4)
  unreachable

nullrecv.ok30:                                    ; preds = %nullrecv.ok25
  %id31 = getelementptr inbounds %class.Node, ptr %c28, i32 0, i32 1
  %id32 = load i32, ptr %id31, align 4, !tbaa !4
  %c33 = load ptr, ptr %c, align 8
  %23 = icmp eq ptr %c33, null
  br i1 %23, label %nullrecv34, label %nullrecv.ok35

nullrecv34:                                       ; preds = %nullrecv.ok30
  call void @__polaron_panic(ptr @.panic.5)
  unreachable

nullrecv.ok35:                                    ; preds = %nullrecv.ok30
  %next36 = getelementptr inbounds %class.Node, ptr %c33, i32 0, i32 2
  %next37 = load ptr, ptr %next36, align 8, !tbaa !0
  %24 = icmp eq ptr %next37, null
  br i1 %24, label %nullrecv38, label %nullrecv.ok39

nullrecv38:                                       ; preds = %nullrecv.ok35
  call void @__polaron_panic(ptr @.panic.6)
  unreachable

nullrecv.ok39:                                    ; preds = %nullrecv.ok35
  %id40 = getelementptr inbounds %class.Node, ptr %next37, i32 0, i32 1
  %id41 = load i32, ptr %id40, align 4, !tbaa !4
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %id20, i32 %id27, i32 %id32, i32 %id41)
  %a42 = load ptr, ptr %a, align 8
  %26 = call ptr @__polaron_ptrset_new()
  call void @__cascade.0.1.Node(ptr %a42, ptr %26, i32 -1)
  call void @__polaron_ptrset_free(ptr %26)
  %c43 = load ptr, ptr %c, align 8
  %27 = icmp eq ptr %c43, null
  br i1 %27, label %nullrecv44, label %nullrecv.ok45

nullrecv44:                                       ; preds = %nullrecv.ok39
  call void @__polaron_panic(ptr @.panic.7)
  unreachable

nullrecv.ok45:                                    ; preds = %nullrecv.ok39
  %28 = call ptr @__polaron_ptrset_new()
  call void @__cascade.0.2.Node(ptr %c43, ptr %28, i32 -1)
  call void @__polaron_ptrset_free(ptr %28)
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

declare ptr @__polaron_ptrmap_new()

define internal ptr @__cascade.clone.0.Node(ptr %0, ptr %1, i32 %2) {
entry:
  %3 = icmp ne ptr %0, null
  br i1 %3, label %live, label %nullret

live:                                             ; preds = %entry
  %4 = call ptr @__polaron_ptrmap_get(ptr %1, ptr %0)
  %5 = icmp ne ptr %4, null
  br i1 %5, label %existret, label %fresh

nullret:                                          ; preds = %entry
  ret ptr null

existret:                                         ; preds = %live
  ret ptr %4

fresh:                                            ; preds = %live
  %6 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %7 = call ptr @memcpy(ptr %6, ptr %0, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @__polaron_ptrmap_put(ptr %1, ptr %0, ptr %6)
  %8 = icmp ne i32 %2, 0
  br i1 %8, label %recurse, label %after

recurse:                                          ; preds = %fresh
  %9 = icmp slt i32 %2, 0
  %10 = sub i32 %2, 1
  %11 = select i1 %9, i32 %2, i32 %10
  %next = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %next1 = load ptr, ptr %next, align 8, !tbaa !0
  %12 = call ptr @__cascade.clone.0.Node(ptr %next1, ptr %1, i32 %11)
  %next2 = getelementptr inbounds %class.Node, ptr %6, i32 0, i32 2
  store ptr %12, ptr %next2, align 8, !tbaa !0
  br label %after

after:                                            ; preds = %recurse, %fresh
  ret ptr %6
}

declare ptr @__polaron_ptrmap_get(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_ptrmap_put(ptr, ptr, ptr)

declare void @__polaron_ptrmap_free(ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare i32 @printf(ptr, ...)

declare ptr @__polaron_ptrset_new()

define internal void @__cascade.0.1.Node(ptr %0, ptr %1, i32 %2) {
entry:
  %3 = icmp ne ptr %0, null
  br i1 %3, label %live, label %ret

live:                                             ; preds = %entry
  %4 = call i32 @__polaron_ptrset_add(ptr %1, ptr %0)
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %fresh, label %ret

ret:                                              ; preds = %after, %live, %entry
  ret void

fresh:                                            ; preds = %live
  %next = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %next1 = load ptr, ptr %next, align 8, !tbaa !0
  call void @__polaron_check_live(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %6 = icmp ne ptr %dtor.fn, null
  br i1 %6, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %fresh
  call void %dtor.fn(ptr %0)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %fresh
  call void @__polaron_free(ptr %0)
  %7 = icmp ne i32 %2, 0
  br i1 %7, label %recurse, label %after

recurse:                                          ; preds = %dtor.free
  %8 = icmp slt i32 %2, 0
  %9 = sub i32 %2, 1
  %10 = select i1 %8, i32 %2, i32 %9
  call void @__cascade.0.1.Node(ptr %next1, ptr %1, i32 %10)
  br label %after

after:                                            ; preds = %recurse, %dtor.free
  br label %ret
}

declare i32 @__polaron_ptrset_add(ptr, ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare void @__polaron_ptrset_free(ptr)

define internal void @__cascade.0.2.Node(ptr %0, ptr %1, i32 %2) {
entry:
  %3 = icmp ne ptr %0, null
  br i1 %3, label %live, label %ret

live:                                             ; preds = %entry
  %4 = call i32 @__polaron_ptrset_add(ptr %1, ptr %0)
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %fresh, label %ret

ret:                                              ; preds = %after, %live, %entry
  ret void

fresh:                                            ; preds = %live
  %next = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %next1 = load ptr, ptr %next, align 8, !tbaa !0
  call void @__polaron_check_live(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %6 = icmp ne ptr %dtor.fn, null
  br i1 %6, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %fresh
  call void %dtor.fn(ptr %0)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %fresh
  call void @__polaron_free(ptr %0)
  %7 = icmp ne i32 %2, 0
  br i1 %7, label %recurse, label %after

recurse:                                          ; preds = %dtor.free
  %8 = icmp slt i32 %2, 0
  %9 = sub i32 %2, 1
  %10 = select i1 %8, i32 %2, i32 %9
  call void @__cascade.0.2.Node(ptr %next1, ptr %1, i32 %10)
  br label %after

after:                                            ; preds = %recurse, %dtor.free
  br label %ret
}

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
