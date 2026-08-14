; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_forest.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_forest.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32, ptr, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.panic = private unnamed_addr constant [142 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_forest.pol:27:17  in Main.sumTree\0A\00", align 1
@.panic.1 = private unnamed_addr constant [142 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_forest.pol:27:17  in Main.sumTree\0A\00", align 1
@.panic.2 = private unnamed_addr constant [142 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_forest.pol:27:17  in Main.sumTree\0A\00", align 1
@.str = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1
@.panic.3 = private unnamed_addr constant [134 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/cascade_forest.pol:33:17  in main\0A\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"freed\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }

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
  %left = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  store ptr null, ptr %left, align 8, !tbaa !0
  %right = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  store ptr null, ptr %right, align 8, !tbaa !0
  ret void
}

define internal ptr @Main.build(i32 %0, i32 %1) {
entry:
  %n = alloca ptr, align 8
  %tag = alloca i32, align 4
  %depth = alloca i32, align 4
  store i32 %0, ptr %depth, align 4
  store i32 %1, ptr %tag, align 4
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %tag1 = load i32, ptr %tag, align 4
  call void @Node.Node(ptr %Node.obj, i32 %tag1)
  store ptr %Node.obj, ptr %n, align 8
  %depth2 = load i32, ptr %depth, align 4
  %2 = icmp sgt i32 %depth2, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %n3 = load ptr, ptr %n, align 8
  %left = getelementptr inbounds %class.Node, ptr %n3, i32 0, i32 2
  %depth4 = load i32, ptr %depth, align 4
  %4 = sub i32 %depth4, 1
  %tag5 = load i32, ptr %tag, align 4
  %5 = mul i32 %tag5, 2
  %6 = call ptr @Main.build(i32 %4, i32 %5)
  store ptr %6, ptr %left, align 8, !tbaa !0
  %n6 = load ptr, ptr %n, align 8
  %right = getelementptr inbounds %class.Node, ptr %n6, i32 0, i32 3
  %depth7 = load i32, ptr %depth, align 4
  %7 = sub i32 %depth7, 1
  %tag8 = load i32, ptr %tag, align 4
  %8 = mul i32 %tag8, 2
  %9 = add i32 %8, 1
  %10 = call ptr @Main.build(i32 %7, i32 %9)
  store ptr %10, ptr %right, align 8, !tbaa !0
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %n9 = load ptr, ptr %n, align 8
  ret ptr %n9
}

define internal i32 @Main.sumTree(ptr %0) {
entry:
  %n = alloca ptr, align 8
  store ptr %0, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %1 = icmp eq ptr %n1, null
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %n2 = load ptr, ptr %n, align 8
  %3 = icmp eq ptr %n2, null
  br i1 %3, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %val = getelementptr inbounds %class.Node, ptr %n2, i32 0, i32 1
  %val3 = load i32, ptr %val, align 4, !tbaa !4
  %n4 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n4, null
  br i1 %4, label %nullrecv5, label %nullrecv.ok6

nullrecv5:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.1)
  unreachable

nullrecv.ok6:                                     ; preds = %nullrecv.ok
  %left = getelementptr inbounds %class.Node, ptr %n4, i32 0, i32 2
  %left7 = load ptr, ptr %left, align 8, !tbaa !0
  %5 = call i32 @Main.sumTree(ptr %left7)
  %6 = add i32 %val3, %5
  %n8 = load ptr, ptr %n, align 8
  %7 = icmp eq ptr %n8, null
  br i1 %7, label %nullrecv9, label %nullrecv.ok10

nullrecv9:                                        ; preds = %nullrecv.ok6
  call void @__polaron_panic(ptr @.panic.2)
  unreachable

nullrecv.ok10:                                    ; preds = %nullrecv.ok6
  %right = getelementptr inbounds %class.Node, ptr %n8, i32 0, i32 3
  %right11 = load ptr, ptr %right, align 8, !tbaa !0
  %8 = call i32 @Main.sumTree(ptr %right11)
  %9 = add i32 %6, %8
  ret i32 %9
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %before = alloca i32, align 4
  %root = alloca ptr, align 8
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
  %16 = call ptr @Main.build(i32 4, i32 1)
  store ptr %16, ptr %root, align 8
  %root1 = load ptr, ptr %root, align 8
  %17 = call i32 @Main.sumTree(ptr %root1)
  store i32 %17, ptr %before, align 4
  %before2 = load i32, ptr %before, align 4
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 %before2)
  %root3 = load ptr, ptr %root, align 8
  %19 = icmp eq ptr %root3, null
  br i1 %19, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %argv.end
  call void @__polaron_panic(ptr @.panic.3)
  unreachable

nullrecv.ok:                                      ; preds = %argv.end
  call void @__cascade.0.0.Node(ptr %root3, ptr null, i32 -1)
  %20 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr @.str.5)
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

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

define internal void @__cascade.0.0.Node(ptr %0, ptr %1, i32 %2) {
entry:
  %3 = icmp ne ptr %0, null
  br i1 %3, label %live, label %ret

live:                                             ; preds = %entry
  br label %fresh

ret:                                              ; preds = %after, %entry
  ret void

fresh:                                            ; preds = %live
  %left = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %left1 = load ptr, ptr %left, align 8, !tbaa !0
  %right = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %right2 = load ptr, ptr %right, align 8, !tbaa !0
  call void @__polaron_check_live(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %4 = icmp ne ptr %dtor.fn, null
  br i1 %4, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %fresh
  call void %dtor.fn(ptr %0)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %fresh
  call void @__polaron_free(ptr %0)
  %5 = icmp ne i32 %2, 0
  br i1 %5, label %recurse, label %after

recurse:                                          ; preds = %dtor.free
  %6 = icmp slt i32 %2, 0
  %7 = sub i32 %2, 1
  %8 = select i1 %6, i32 %2, i32 %7
  call void @__cascade.0.0.Node(ptr %left1, ptr %1, i32 %8)
  call void @__cascade.0.0.Node(ptr %right2, ptr %1, i32 %8)
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

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
