; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/weak_ref.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/weak_ref.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32, ptr }
%class.Watcher = type { ptr, %WeakSlot }
%WeakSlot = type { ptr, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Watcher.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [20 x i8] c"before=%d after=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Node.Node(ptr %0, i32 %1) {
entry:
  %id = alloca i32, align 4
  store i32 %1, ptr %id, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %id1 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %id2 = load i32, ptr %id, align 4
  store i32 %id2, ptr %id1, align 4, !tbaa !4
  ret void
}

define internal void @Watcher.Watcher(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Watcher, ptr %0, i32 0, i32 0
  store ptr @Watcher.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %after = alloca i32, align 4
  %before = alloca i32, align 4
  %n = alloca ptr, align 8
  %w = alloca ptr, align 8
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
  %Watcher.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Watcher, ptr null, i64 1) to i64))
  %target.winit = getelementptr inbounds %class.Watcher, ptr %Watcher.obj, i32 0, i32 1
  %16 = getelementptr inbounds %WeakSlot, ptr %target.winit, i32 0, i32 0
  store ptr null, ptr %16, align 8
  %17 = getelementptr inbounds %WeakSlot, ptr %target.winit, i32 0, i32 1
  store ptr null, ptr %17, align 8
  call void @Watcher.Watcher(ptr %Watcher.obj)
  store ptr %Watcher.obj, ptr %w, align 8
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %whead.winit = getelementptr inbounds %class.Node, ptr %Node.obj, i32 0, i32 2
  store ptr null, ptr %whead.winit, align 8, !tbaa !0
  call void @Node.Node(ptr %Node.obj, i32 42)
  store ptr %Node.obj, ptr %n, align 8
  %w1 = load ptr, ptr %w, align 8
  %target = getelementptr inbounds %class.Watcher, ptr %w1, i32 0, i32 1
  %n2 = load ptr, ptr %n, align 8
  call void @__polaron_weak_unlink(ptr %target, i64 16)
  %18 = icmp ne ptr %n2, null
  br i1 %18, label %weak.link, label %weak.done

weak.link:                                        ; preds = %argv.end
  call void @__polaron_weak_link(ptr %target, ptr %n2, i64 16)
  br label %weak.done

weak.done:                                        ; preds = %weak.link, %argv.end
  store i32 0, ptr %before, align 4
  %w3 = load ptr, ptr %w, align 8
  %target4 = getelementptr inbounds %class.Watcher, ptr %w3, i32 0, i32 1
  %target5 = load ptr, ptr %target4, align 8, !tbaa !0
  %19 = icmp eq ptr %target5, null
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.else

if.then:                                          ; preds = %weak.done
  store i32 -1, ptr %before, align 4
  br label %if.end

if.else:                                          ; preds = %weak.done
  %w6 = load ptr, ptr %w, align 8
  %target7 = getelementptr inbounds %class.Watcher, ptr %w6, i32 0, i32 1
  %target8 = load ptr, ptr %target7, align 8, !tbaa !0
  %id = getelementptr inbounds %class.Node, ptr %target8, i32 0, i32 1
  %id9 = load i32, ptr %id, align 4, !tbaa !4
  store i32 %id9, ptr %before, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %n10 = load ptr, ptr %n, align 8
  call void @__polaron_check_live(ptr %n10)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %n10, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %21 = icmp ne ptr %dtor.fn, null
  br i1 %21, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %if.end
  call void %dtor.fn(ptr %n10)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %if.end
  %whead = getelementptr inbounds %class.Node, ptr %n10, i32 0, i32 2
  call void @__polaron_weak_nullify(ptr %whead)
  call void @__polaron_free(ptr %n10)
  store i32 0, ptr %after, align 4
  %w11 = load ptr, ptr %w, align 8
  %target12 = getelementptr inbounds %class.Watcher, ptr %w11, i32 0, i32 1
  %target13 = load ptr, ptr %target12, align 8, !tbaa !0
  %22 = icmp eq ptr %target13, null
  %23 = zext i1 %22 to i32
  br i1 %22, label %if.then14, label %if.else15

if.then14:                                        ; preds = %dtor.free
  store i32 -1, ptr %after, align 4
  br label %if.end16

if.else15:                                        ; preds = %dtor.free
  store i32 999, ptr %after, align 4
  br label %if.end16

if.end16:                                         ; preds = %if.else15, %if.then14
  %before17 = load i32, ptr %before, align 4
  %after18 = load i32, ptr %after, align 4
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %before17, i32 %after18)
  %w19 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w19)
  %vtbl.addr20 = getelementptr inbounds %class.Watcher, ptr %w19, i32 0, i32 0
  %vtbl21 = load ptr, ptr %vtbl.addr20, align 8, !tbaa !0
  %dtor.slot22 = getelementptr [349 x ptr], ptr %vtbl21, i64 0, i64 348
  %dtor.fn23 = load ptr, ptr %dtor.slot22, align 8
  %25 = icmp ne ptr %dtor.fn23, null
  br i1 %25, label %dtor.call24, label %dtor.free25

dtor.call24:                                      ; preds = %if.end16
  call void %dtor.fn23(ptr %w19)
  br label %dtor.free25

dtor.free25:                                      ; preds = %dtor.call24, %if.end16
  %target.wunlink = getelementptr inbounds %class.Watcher, ptr %w19, i32 0, i32 1
  call void @__polaron_weak_unlink(ptr %target.wunlink, i64 16)
  call void @__polaron_free(ptr %w19)
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

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal void @__polaron_weak_unlink(ptr %0, i64 %1) {
entry:
  %2 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 1
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 0
  %5 = load ptr, ptr %4, align 8
  %6 = icmp eq ptr %5, null
  br i1 %6, label %clear, label %has

has:                                              ; preds = %entry
  %7 = getelementptr i8, ptr %5, i64 %1
  %8 = load ptr, ptr %7, align 8
  %9 = icmp eq ptr %8, %0
  br i1 %9, label %first, label %scan

first:                                            ; preds = %has
  store ptr %3, ptr %7, align 8
  br label %clear

scan:                                             ; preds = %advance, %has
  %10 = phi ptr [ %8, %has ], [ %12, %advance ]
  %11 = getelementptr inbounds %WeakSlot, ptr %10, i32 0, i32 1
  %12 = load ptr, ptr %11, align 8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %clear, label %advance

found:                                            ; preds = %advance
  %14 = getelementptr inbounds %WeakSlot, ptr %10, i32 0, i32 1
  store ptr %3, ptr %14, align 8
  br label %clear

advance:                                          ; preds = %scan
  %15 = icmp eq ptr %12, %0
  br i1 %15, label %found, label %scan

clear:                                            ; preds = %found, %scan, %first, %entry
  %16 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 0
  store ptr null, ptr %16, align 8
  %17 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 1
  store ptr null, ptr %17, align 8
  br label %done

done:                                             ; preds = %clear
  ret void
}

define internal void @__polaron_weak_link(ptr %0, ptr %1, i64 %2) {
entry:
  %3 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 0
  store ptr %1, ptr %3, align 8
  %4 = getelementptr i8, ptr %1, i64 %2
  %5 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 1
  %6 = load ptr, ptr %4, align 8
  store ptr %6, ptr %5, align 8
  store ptr %0, ptr %4, align 8
  ret void
}

declare void @__polaron_check_live(ptr)

define internal void @__polaron_weak_nullify(ptr %0) {
entry:
  %1 = load ptr, ptr %0, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %2 = phi ptr [ %1, %entry ], [ %5, %body ]
  %3 = icmp eq ptr %2, null
  br i1 %3, label %done, label %body

body:                                             ; preds = %loop
  %4 = getelementptr inbounds %WeakSlot, ptr %2, i32 0, i32 1
  %5 = load ptr, ptr %4, align 8
  %6 = getelementptr inbounds %WeakSlot, ptr %2, i32 0, i32 0
  store ptr null, ptr %6, align 8
  %7 = getelementptr inbounds %WeakSlot, ptr %2, i32 0, i32 1
  store ptr null, ptr %7, align 8
  br label %loop

done:                                             ; preds = %loop
  store ptr null, ptr %0, align 8
  ret void
}

declare void @__polaron_free(ptr)

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
