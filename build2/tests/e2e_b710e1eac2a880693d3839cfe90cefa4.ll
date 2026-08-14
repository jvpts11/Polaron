; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/clone_keeps_field_kind.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/clone_keeps_field_kind.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.Pipe = type { ptr }
%class.Sink = type { ptr, ptr }
%class.Target = type { ptr, i32, ptr }
%class.Watcher = type { ptr, %WeakSlot }
%WeakSlot = type { ptr, ptr }
%String = type { i64, ptr, i64 }
%class.Drain = type { ptr }
%class.Object = type { ptr }

@Pipe.vtable = private constant [351 x ptr] [ptr @Pipe.take, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Sink.vtable = private constant [351 x ptr] [ptr @Sink.take, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Target.vtable = private constant [351 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Watcher.vtable = private constant [351 x ptr] [ptr null, ptr @Watcher.stillThere, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [351 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [22 x i8] c"weak=%d delegated=%d\0A\00", align 1

define internal i32 @Pipe.take(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 7
}

define internal void @Pipe.Pipe(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Pipe, ptr %0, i32 0, i32 0
  store ptr @Pipe.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @Sink.Sink(ptr %0, ptr %1) {
entry:
  %Pipe.copy = alloca %class.Pipe, align 8
  %p = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Pipe.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Pipe, ptr null, i64 1) to i64))
  store ptr %Pipe.copy, ptr %p, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Sink, ptr %0, i32 0, i32 0
  store ptr @Sink.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %out = getelementptr inbounds %class.Sink, ptr %0, i32 0, i32 1
  store ptr null, ptr %out, align 8, !tbaa !0
  %out1 = getelementptr inbounds %class.Sink, ptr %0, i32 0, i32 1
  %p2 = load ptr, ptr %p, align 8
  %Pipe.copy3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pipe, ptr null, i64 1) to i64))
  %3 = call ptr @memcpy(ptr %Pipe.copy3, ptr %p2, i64 ptrtoint (ptr getelementptr (%class.Pipe, ptr null, i64 1) to i64))
  store ptr %Pipe.copy3, ptr %out1, align 8, !tbaa !0
  ret void
}

define internal i32 @Sink.take(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %out = getelementptr inbounds %class.Sink, ptr %0, i32 0, i32 1
  %out1 = load ptr, ptr %out, align 8, !tbaa !0
  %1 = call i32 @Pipe.take(ptr %out1)
  ret i32 %1
}

define internal void @Target.Target(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Target, ptr %0, i32 0, i32 0
  store ptr @Target.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %value = getelementptr inbounds %class.Target, ptr %0, i32 0, i32 1
  store i32 42, ptr %value, align 4, !tbaa !4
  ret void
}

define internal void @Watcher.Watcher(ptr %0, ptr %1) {
entry:
  %t = alloca ptr, align 8
  store ptr %1, ptr %t, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Watcher, ptr %0, i32 0, i32 0
  store ptr @Watcher.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %seen = getelementptr inbounds %class.Watcher, ptr %0, i32 0, i32 1
  %t1 = load ptr, ptr %t, align 8
  call void @__polaron_weak_unlink(ptr %seen, i64 16)
  %2 = icmp ne ptr %t1, null
  br i1 %2, label %weak.link, label %weak.done

weak.link:                                        ; preds = %entry
  call void @__polaron_weak_link(ptr %seen, ptr %t1, i64 16)
  br label %weak.done

weak.done:                                        ; preds = %weak.link, %entry
  ret void
}

define internal i32 @Watcher.stillThere(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %seen = getelementptr inbounds %class.Watcher, ptr %0, i32 0, i32 1
  %seen1 = load ptr, ptr %seen, align 8, !tbaa !0
  %1 = icmp ne ptr %seen1, null
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %d = alloca ptr, align 8
  %s = alloca ptr, align 8
  %Sink.obj = alloca %class.Sink, align 8
  %p = alloca ptr, align 8
  %alive = alloca i32, align 4
  %w = alloca ptr, align 8
  store ptr null, ptr %w, align 8
  %Watcher.obj = alloca %class.Watcher, align 8
  %t = alloca ptr, align 8
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
  %Target.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Target, ptr null, i64 1) to i64))
  %whead.winit = getelementptr inbounds %class.Target, ptr %Target.obj, i32 0, i32 2
  store ptr null, ptr %whead.winit, align 8, !tbaa !0
  call void @Target.Target(ptr %Target.obj)
  store ptr %Target.obj, ptr %t, align 8
  %seen.winit = getelementptr inbounds %class.Watcher, ptr %Watcher.obj, i32 0, i32 1
  %16 = getelementptr inbounds %WeakSlot, ptr %seen.winit, i32 0, i32 0
  store ptr null, ptr %16, align 8
  %17 = getelementptr inbounds %WeakSlot, ptr %seen.winit, i32 0, i32 1
  store ptr null, ptr %17, align 8
  %t1 = load ptr, ptr %t, align 8
  call void @Watcher.Watcher(ptr %Watcher.obj, ptr %t1)
  store ptr %Watcher.obj, ptr %w, align 8
  %t2 = load ptr, ptr %t, align 8
  call void @__polaron_check_live(ptr %t2)
  %vtbl.addr = getelementptr inbounds %class.Target, ptr %t2, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [351 x ptr], ptr %vtbl, i64 0, i64 350
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %18 = icmp ne ptr %dtor.fn, null
  br i1 %18, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %argv.end
  call void %dtor.fn(ptr %t2)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %argv.end
  %whead = getelementptr inbounds %class.Target, ptr %t2, i32 0, i32 2
  call void @__polaron_weak_nullify(ptr %whead)
  call void @__polaron_free(ptr %t2)
  store i32 1, ptr %alive, align 4
  %w3 = load ptr, ptr %w, align 8
  %19 = call i32 @Watcher.stillThere(ptr %w3)
  %20 = icmp eq i32 %19, 0
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %dtor.free
  store i32 0, ptr %alive, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %dtor.free
  %Pipe.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pipe, ptr null, i64 1) to i64))
  call void @Pipe.Pipe(ptr %Pipe.obj)
  store ptr %Pipe.obj, ptr %p, align 8
  %p4 = load ptr, ptr %p, align 8
  call void @Sink.Sink(ptr %Sink.obj, ptr %p4)
  store ptr %Sink.obj, ptr %s, align 8
  %s5 = load ptr, ptr %s, align 8
  store ptr %s5, ptr %d, align 8
  %alive6 = load i32, ptr %alive, align 4
  %d7 = load ptr, ptr %d, align 8
  %vtbl.addr8 = getelementptr inbounds %class.Drain, ptr %d7, i32 0, i32 0
  %vtbl9 = load ptr, ptr %vtbl.addr8, align 8, !tbaa !0
  %slot = getelementptr [350 x ptr], ptr %vtbl9, i64 0, i64 0
  %fn = load ptr, ptr %slot, align 8
  %dv.is = icmp eq ptr %fn, @Pipe.take
  br i1 %dv.is, label %dv.hit, label %dv.miss

dv.join:                                          ; preds = %dv.miss11, %dv.hit10, %dv.hit
  %dv.r = phi i32 [ %24, %dv.hit ], [ %25, %dv.hit10 ], [ %26, %dv.miss11 ]
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %alive6, i32 %dv.r)
  %p13 = load ptr, ptr %p, align 8
  call void @__polaron_check_live(ptr %p13)
  %vtbl.addr14 = getelementptr inbounds %class.Pipe, ptr %p13, i32 0, i32 0
  %vtbl15 = load ptr, ptr %vtbl.addr14, align 8, !tbaa !0
  %dtor.slot16 = getelementptr [351 x ptr], ptr %vtbl15, i64 0, i64 350
  %dtor.fn17 = load ptr, ptr %dtor.slot16, align 8
  %23 = icmp ne ptr %dtor.fn17, null
  br i1 %23, label %dtor.call18, label %dtor.free19

dv.hit:                                           ; preds = %if.end
  %24 = call i32 @Pipe.take(ptr %d7)
  br label %dv.join

dv.miss:                                          ; preds = %if.end
  %dv.is12 = icmp eq ptr %fn, @Sink.take
  br i1 %dv.is12, label %dv.hit10, label %dv.miss11

dv.hit10:                                         ; preds = %dv.miss
  %25 = call i32 @Sink.take(ptr %d7)
  br label %dv.join

dv.miss11:                                        ; preds = %dv.miss
  %26 = call i32 %fn(ptr %d7)
  br label %dv.join

dtor.call18:                                      ; preds = %dv.join
  call void %dtor.fn17(ptr %p13)
  br label %dtor.free19

dtor.free19:                                      ; preds = %dtor.call18, %dv.join
  call void @__polaron_free(ptr %p13)
  %27 = load ptr, ptr %w, align 8
  %28 = icmp ne ptr %27, null
  br i1 %28, label %dtor.live, label %dtor.done

dtor.live:                                        ; preds = %dtor.free19
  %seen.wunlink = getelementptr inbounds %class.Watcher, ptr %27, i32 0, i32 1
  call void @__polaron_weak_unlink(ptr %seen.wunlink, i64 16)
  br label %dtor.done

dtor.done:                                        ; preds = %dtor.live, %dtor.free19
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

declare ptr @memcpy(ptr, ptr, i64)

declare noalias ptr @__polaron_malloc(i64)

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

declare i64 @strlen(ptr)

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

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
