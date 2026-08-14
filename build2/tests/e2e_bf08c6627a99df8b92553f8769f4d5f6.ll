; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_ops.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_ops.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [350 x ptr] [ptr @Node.describe, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.contract = private unnamed_addr constant [153 x i8] c"contract violated: invariant\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_ops.pol:13:31  in Node.Node\0A   |  invariant this.id >= 0;\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.str = private unnamed_addr constant [9 x i8] c"Node %d\0A\00", align 1
@.contract.1 = private unnamed_addr constant [162 x i8] c"contract violated: invariant\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_ops.pol:13:31  in __cascade.2.0.Node\0A   |  invariant this.id >= 0;\0A\00", align 1
@.cl.2 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.3 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"done\00", align 1
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
  %id1 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id2 = load i32, ptr %id1, align 4, !tbaa !4
  %1 = icmp sge i32 %id2, 0
  %2 = zext i1 %1 to i32
  %contract.ok = icmp ne i32 %2, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %id3 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id4 = load i32, ptr %id3, align 4, !tbaa !4
  %contract.l = sext i32 %id4 to i64
  call void @__polaron_fail(ptr @.contract, ptr @.cl, i64 %contract.l, ptr @.cr, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  ret void
}

define internal void @Node.describe(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %id = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id1 = load i32, ptr %id, align 4, !tbaa !4
  %1 = icmp sge i32 %id1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %id2 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id3 = load i32, ptr %id2, align 4, !tbaa !4
  %3 = call i32 (ptr, ...) @printf(ptr @.str, i32 %id3)
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %a7 = load ptr, ptr %a, align 8
  %16 = call ptr @__polaron_ptrset_new()
  call void @__cascade.2.0.Node(ptr %a7, ptr %16, i32 -1)
  call void @__polaron_ptrset_free(ptr %16)
  %a8 = load ptr, ptr %a, align 8
  %17 = call ptr @__polaron_ptrset_new()
  call void @__cascade.1.1.Node(ptr %a8, ptr %17, i32 -1)
  call void @__polaron_ptrset_free(ptr %17)
  %a9 = load ptr, ptr %a, align 8
  %18 = call ptr @__polaron_ptrset_new()
  call void @__cascade.0.2.Node(ptr %a9, ptr %18, i32 -1)
  call void @__polaron_ptrset_free(ptr %18)
  %19 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr @.str.5)
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

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_ptrset_new()

define internal void @__cascade.2.0.Node(ptr %0, ptr %1, i32 %2) {
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
  %id = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id2 = load i32, ptr %id, align 4, !tbaa !4
  %6 = icmp sge i32 %id2, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %fresh
  %id3 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id4 = load i32, ptr %id3, align 4, !tbaa !4
  %contract.l = sext i32 %id4 to i64
  call void @__polaron_fail(ptr @.contract.1, ptr @.cl.2, i64 %contract.l, ptr @.cr.3, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %fresh
  %8 = icmp ne i32 %2, 0
  br i1 %8, label %recurse, label %after

recurse:                                          ; preds = %contract.cont
  %9 = icmp slt i32 %2, 0
  %10 = sub i32 %2, 1
  %11 = select i1 %9, i32 %2, i32 %10
  call void @__cascade.2.0.Node(ptr %next1, ptr %1, i32 %11)
  br label %after

after:                                            ; preds = %recurse, %contract.cont
  br label %ret
}

declare i32 @__polaron_ptrset_add(ptr, ptr)

declare void @__polaron_ptrset_free(ptr)

define internal void @__cascade.1.1.Node(ptr %0, ptr %1, i32 %2) {
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
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 0
  %fn = load ptr, ptr %slot, align 8
  call void %fn(ptr %0)
  %6 = icmp ne i32 %2, 0
  br i1 %6, label %recurse, label %after

recurse:                                          ; preds = %fresh
  %7 = icmp slt i32 %2, 0
  %8 = sub i32 %2, 1
  %9 = select i1 %7, i32 %2, i32 %8
  call void @__cascade.1.1.Node(ptr %next1, ptr %1, i32 %9)
  br label %after

after:                                            ; preds = %recurse, %fresh
  br label %ret
}

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
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
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

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
