; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/linkedlist_stdlib.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/linkedlist_stdlib.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.LinkedList$int" = type { ptr, ptr, ptr, ptr, i32 }
%"class.LinkedNode$int" = type { ptr, i32, %WeakSlot, ptr }
%WeakSlot = type { ptr, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"LinkedList$int.vtable" = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr @"LinkedList$int.toArray", ptr @"LinkedList$int.size", ptr @"LinkedList$int.isEmpty", ptr @"LinkedList$int.add", ptr @"LinkedList$int.get", ptr @"LinkedList$int.removeFirst", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"LinkedList$int.~LinkedList$int"]
@"LinkedNode$int.vtable" = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [21 x i8] c"size=%d g0=%d g2=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [27 x i8] c"rm=%d size=%d g0=%d g2=%d\0A\00", align 1
@.panic = private unnamed_addr constant [89 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:838:39  in LinkedList$int.add\0A\00", align 1
@.panic.41 = private unnamed_addr constant [89 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:843:59  in LinkedList$int.get\0A\00", align 1
@.panic.42 = private unnamed_addr constant [89 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:844:17  in LinkedList$int.get\0A\00", align 1
@.panic.43 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:848:17  in LinkedList$int.removeFirst\0A\00", align 1
@.panic.44 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:849:27  in LinkedList$int.removeFirst\0A\00", align 1
@.panic.45 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:851:17  in LinkedList$int.removeFirst\0A\00", align 1
@.fail.46 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:858:71  in LinkedList$int.toArray\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.49 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:858:71  in LinkedList$int.toArray\0A\00", align 1
@.panic.50 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:858:88  in LinkedList$int.toArray\0A\00", align 1
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %r = alloca i32, align 4
  %list = alloca ptr, align 8
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
  %"LinkedList$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.LinkedList$int", ptr null, i64 1) to i64))
  call void @"LinkedList$int.LinkedList$int"(ptr %"LinkedList$int.obj")
  store ptr %"LinkedList$int.obj", ptr %list, align 8
  %list1 = load ptr, ptr %list, align 8
  call void @"LinkedList$int.add"(ptr %list1, i32 10)
  %list2 = load ptr, ptr %list, align 8
  call void @"LinkedList$int.add"(ptr %list2, i32 20)
  %list3 = load ptr, ptr %list, align 8
  call void @"LinkedList$int.add"(ptr %list3, i32 30)
  %list4 = load ptr, ptr %list, align 8
  %16 = call i32 @"LinkedList$int.size"(ptr %list4)
  %list5 = load ptr, ptr %list, align 8
  %17 = call i32 @"LinkedList$int.get"(ptr %list5, i32 0)
  %list6 = load ptr, ptr %list, align 8
  %18 = call i32 @"LinkedList$int.get"(ptr %list6, i32 2)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18)
  %list7 = load ptr, ptr %list, align 8
  %20 = call i32 @"LinkedList$int.removeFirst"(ptr %list7)
  store i32 %20, ptr %r, align 4
  %list8 = load ptr, ptr %list, align 8
  call void @"LinkedList$int.add"(ptr %list8, i32 40)
  %r9 = load i32, ptr %r, align 4
  %list10 = load ptr, ptr %list, align 8
  %21 = call i32 @"LinkedList$int.size"(ptr %list10)
  %list11 = load ptr, ptr %list, align 8
  %22 = call i32 @"LinkedList$int.get"(ptr %list11, i32 0)
  %list12 = load ptr, ptr %list, align 8
  %23 = call i32 @"LinkedList$int.get"(ptr %list12, i32 2)
  %24 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %r9, i32 %21, i32 %22, i32 %23)
  ret i32 0
}

define internal void @"LinkedList$int.LinkedList$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 0
  store ptr @"LinkedList$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %nodes = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 1
  %region = call ptr @__polaron_region_acquire(i64 4544)
  call void @__polaron_region_init(ptr %region, i64 1, i64 4096, i64 0)
  store ptr %region, ptr %nodes, align 8, !tbaa !0
  %head = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %head, align 8, !tbaa !0
  %tail = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %tail, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"LinkedList$int.~LinkedList$int"(ptr %0) {
entry:
  %head = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %head, align 8, !tbaa !0
  %tail = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %tail, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  %rgn.field = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 1
  %1 = load ptr, ptr %rgn.field, align 8, !tbaa !0
  call void @__polaron_region_teardown(ptr %1)
  call void @__polaron_region_release(ptr %1)
  store ptr null, ptr %rgn.field, align 8, !tbaa !0
  ret void
}

define internal void @"LinkedList$int.add"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %node = alloca ptr, align 8
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %rgn.field = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 1
  %region = load ptr, ptr %rgn.field, align 8, !tbaa !0
  %rgn.slot = call ptr @__polaron_region_new(ptr %region, i64 ptrtoint (ptr getelementptr (%"class.LinkedNode$int", ptr null, i64 1) to i64))
  %next.winit = getelementptr inbounds %"class.LinkedNode$int", ptr %rgn.slot, i32 0, i32 2
  %2 = getelementptr inbounds %WeakSlot, ptr %next.winit, i32 0, i32 0
  store ptr null, ptr %2, align 8
  %3 = getelementptr inbounds %WeakSlot, ptr %next.winit, i32 0, i32 1
  store ptr null, ptr %3, align 8
  %whead.winit = getelementptr inbounds %"class.LinkedNode$int", ptr %rgn.slot, i32 0, i32 3
  store ptr null, ptr %whead.winit, align 8, !tbaa !0
  %item1 = load i32, ptr %item, align 4
  call void @"LinkedNode$int.LinkedNode$int"(ptr %rgn.slot, i32 %item1)
  %rgn.field2 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 1
  %region3 = load ptr, ptr %rgn.field2, align 8, !tbaa !0
  call void @__polaron_region_track(ptr %region3, ptr %rgn.slot, ptr @"LinkedNode$int.__rgndtor")
  store ptr %rgn.slot, ptr %node, align 8
  %tail = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 3
  %tail4 = load ptr, ptr %tail, align 8, !tbaa !0
  %4 = icmp eq ptr %tail4, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %head = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 2
  %node5 = load ptr, ptr %node, align 8
  store ptr %node5, ptr %head, align 8, !tbaa !0
  %tail6 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 3
  %node7 = load ptr, ptr %node, align 8
  store ptr %node7, ptr %tail6, align 8, !tbaa !0
  br label %if.end

if.else:                                          ; preds = %entry
  %tail8 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 3
  %tail9 = load ptr, ptr %tail8, align 8, !tbaa !0
  %6 = icmp eq ptr %tail9, null
  br i1 %6, label %nullrecv, label %nullrecv.ok

if.end:                                           ; preds = %weak.done, %if.then
  %count = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  %count13 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  %count14 = load i32, ptr %count13, align 4, !tbaa !4
  %7 = add i32 %count14, 1
  store i32 %7, ptr %count, align 4, !tbaa !4
  ret void

nullrecv:                                         ; preds = %if.else
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %if.else
  %next = getelementptr inbounds %"class.LinkedNode$int", ptr %tail9, i32 0, i32 2
  %node10 = load ptr, ptr %node, align 8
  call void @__polaron_weak_unlink(ptr %next, i64 32)
  %8 = icmp ne ptr %node10, null
  br i1 %8, label %weak.link, label %weak.done

weak.link:                                        ; preds = %nullrecv.ok
  call void @__polaron_weak_link(ptr %next, ptr %node10, i64 32)
  br label %weak.done

weak.done:                                        ; preds = %weak.link, %nullrecv.ok
  %tail11 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 3
  %node12 = load ptr, ptr %node, align 8
  store ptr %node12, ptr %tail11, align 8, !tbaa !0
  br label %if.end
}

define internal i32 @"LinkedList$int.get"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %cur = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %head = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 2
  %head1 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head1, ptr %cur, align 8
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %j2 = load i32, ptr %j, align 4
  %i3 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %j2, %i3
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

for.update:                                       ; preds = %nullrecv.ok
  %5 = load i32, ptr %j, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %cur6 = load ptr, ptr %cur, align 8
  %7 = icmp eq ptr %cur6, null
  br i1 %7, label %nullrecv7, label %nullrecv.ok8

nullrecv:                                         ; preds = %for.body
  call void @__polaron_panic(ptr @.panic.41)
  unreachable

nullrecv.ok:                                      ; preds = %for.body
  %next = getelementptr inbounds %"class.LinkedNode$int", ptr %cur4, i32 0, i32 2
  %next5 = load ptr, ptr %next, align 8, !tbaa !0
  store ptr %next5, ptr %cur, align 8
  br label %for.update

nullrecv7:                                        ; preds = %for.end
  call void @__polaron_panic(ptr @.panic.42)
  unreachable

nullrecv.ok8:                                     ; preds = %for.end
  %value = getelementptr inbounds %"class.LinkedNode$int", ptr %cur6, i32 0, i32 1
  %value9 = load i32, ptr %value, align 4, !tbaa !4
  ret i32 %value9
}

define internal i32 @"LinkedList$int.removeFirst"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %v = alloca i32, align 4
  %node = alloca ptr, align 8
  %head = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 2
  %head1 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head1, ptr %node, align 8
  %node2 = load ptr, ptr %node, align 8
  %1 = icmp eq ptr %node2, null
  br i1 %1, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.43)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %value = getelementptr inbounds %"class.LinkedNode$int", ptr %node2, i32 0, i32 1
  %value3 = load i32, ptr %value, align 4, !tbaa !4
  store i32 %value3, ptr %v, align 4
  %head4 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 2
  %node5 = load ptr, ptr %node, align 8
  %2 = icmp eq ptr %node5, null
  br i1 %2, label %nullrecv6, label %nullrecv.ok7

nullrecv6:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.44)
  unreachable

nullrecv.ok7:                                     ; preds = %nullrecv.ok
  %next = getelementptr inbounds %"class.LinkedNode$int", ptr %node5, i32 0, i32 2
  %next8 = load ptr, ptr %next, align 8, !tbaa !0
  store ptr %next8, ptr %head4, align 8, !tbaa !0
  %head9 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 2
  %head10 = load ptr, ptr %head9, align 8, !tbaa !0
  %3 = icmp eq ptr %head10, null
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok7
  %tail = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %tail, align 8, !tbaa !0
  br label %if.end

if.end:                                           ; preds = %if.then, %nullrecv.ok7
  %node11 = load ptr, ptr %node, align 8
  %5 = icmp eq ptr %node11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.45)
  unreachable

nullrecv.ok13:                                    ; preds = %if.end
  call void @__polaron_check_live(ptr %node11)
  call void @"LinkedNode$int.__rgndtor"(ptr %node11)
  %rgn.field = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 1
  %region = load ptr, ptr %rgn.field, align 8, !tbaa !0
  call void @__polaron_region_free(ptr %region, ptr %node11, i64 ptrtoint (ptr getelementptr (%"class.LinkedNode$int", ptr null, i64 1) to i64))
  %count = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  %count14 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %6 = sub i32 %count15, 1
  store i32 %6, ptr %count, align 4, !tbaa !4
  %v16 = load i32, ptr %v, align 4
  ret i32 %v16
}

define internal ptr @"LinkedList$int.toArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %cur = alloca ptr, align 8
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %head = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 2
  %head2 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head2, ptr %cur, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %count4 = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %5 = icmp slt i32 %i3, %count5
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out6 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i7 = load i32, ptr %i, align 4
  %7 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %out6, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %nullrecv.ok13
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out15 = load ptr, ptr %out, align 8
  ret ptr %out15

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 %7, ptr @.failb.48, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %out6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data8, i64 %7
  %cur9 = load ptr, ptr %cur, align 8
  %10 = icmp eq ptr %cur9, null
  br i1 %10, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.49)
  unreachable

nullrecv.ok:                                      ; preds = %idx.ok
  %value = getelementptr inbounds %"class.LinkedNode$int", ptr %cur9, i32 0, i32 1
  %value10 = load i32, ptr %value, align 4, !tbaa !4
  store i32 %value10, ptr %arr.elem, align 4
  %cur11 = load ptr, ptr %cur, align 8
  %11 = icmp eq ptr %cur11, null
  br i1 %11, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.50)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok
  %next = getelementptr inbounds %"class.LinkedNode$int", ptr %cur11, i32 0, i32 2
  %next14 = load ptr, ptr %next, align 8, !tbaa !0
  store ptr %next14, ptr %cur, align 8
  br label %for.update
}

define internal i32 @"LinkedList$int.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"LinkedList$int.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.LinkedList$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"LinkedNode$int.LinkedNode$int"(ptr %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.LinkedNode$int", ptr %0, i32 0, i32 0
  store ptr @"LinkedNode$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %value = getelementptr inbounds %"class.LinkedNode$int", ptr %0, i32 0, i32 1
  %v1 = load i32, ptr %v, align 4
  store i32 %v1, ptr %value, align 4, !tbaa !4
  %next = getelementptr inbounds %"class.LinkedNode$int", ptr %0, i32 0, i32 2
  call void @__polaron_weak_unlink(ptr %next, i64 32)
  br i1 false, label %weak.link, label %weak.done

weak.link:                                        ; preds = %entry
  call void @__polaron_weak_link(ptr %next, ptr null, i64 32)
  br label %weak.done

weak.done:                                        ; preds = %weak.link, %entry
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5320)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare noalias ptr @__polaron_region_acquire(i64)

declare void @__polaron_region_init(ptr, i64, i64, i64)

declare void @__polaron_region_teardown(ptr)

declare void @__polaron_region_release(ptr)

declare noalias ptr @__polaron_region_new(ptr, i64)

define internal void @"LinkedNode$int.__rgndtor"(ptr %0) {
entry:
  %next.wunlink = getelementptr inbounds %"class.LinkedNode$int", ptr %0, i32 0, i32 2
  call void @__polaron_weak_unlink(ptr %next.wunlink, i64 32)
  %whead = getelementptr inbounds %"class.LinkedNode$int", ptr %0, i32 0, i32 3
  call void @__polaron_weak_nullify(ptr %whead)
  ret void
}

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

declare void @__polaron_region_track(ptr, ptr, ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

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

declare void @__polaron_region_free(ptr, ptr, i64)

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
