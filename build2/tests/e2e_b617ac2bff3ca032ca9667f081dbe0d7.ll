; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_in_aggregate.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_in_aggregate.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Coord = type { i32, i32 }
%class.Rect = type { ptr, i32 }
%class.Holder = type { ptr, ptr }
%class.Holder2 = type { ptr, ptr }
%class.Holder3 = type { ptr, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Holder2.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Holder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Holder3.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [138 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_in_aggregate.pol:63:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [138 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_in_aggregate.pol:64:23  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [138 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_in_aggregate.pol:68:17  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [67 x i8] c"field=%d,%d elem=%d,%d nested=%d,%d op=%d,%d fbf=%d,%d mret=%d,%d\0A\00", align 1
@.fail.7 = private unnamed_addr constant [138 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_in_aggregate.pol:69:41  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [138 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_in_aggregate.pol:69:41  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5320 = private constant [1 x i8] zeroinitializer
@.strobj.5321 = private global %String { i64 0, ptr @.strdata.5320, i64 0 }
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }

define internal void @Coord.Coord(ptr %0, i32 %1, i32 %2) {
entry:
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 %2, ptr %y, align 4
  %x1 = getelementptr inbounds %class.Coord, ptr %0, i32 0, i32 0
  %x2 = load i32, ptr %x, align 4
  store i32 %x2, ptr %x1, align 4, !tbaa !0
  %y3 = getelementptr inbounds %class.Coord, ptr %0, i32 0, i32 1
  %y4 = load i32, ptr %y, align 4
  store i32 %y4, ptr %y3, align 4, !tbaa !0
  ret void
}

define internal void @Coord.operator-(ptr nonnull align 4 dereferenceable(8) %0, ptr %1, ptr %2) {
entry:
  %Coord.obj = alloca %class.Coord, align 8
  %Coord.copy = alloca %class.Coord, align 8
  %o = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %Coord.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  store ptr %Coord.copy, ptr %o, align 8
  %x = getelementptr inbounds %class.Coord, ptr %0, i32 0, i32 0
  %x1 = load i32, ptr %x, align 4, !tbaa !0
  %o2 = load ptr, ptr %o, align 8
  %x3 = getelementptr inbounds %class.Coord, ptr %o2, i32 0, i32 0
  %x4 = load i32, ptr %x3, align 4, !tbaa !0
  %4 = sub i32 %x1, %x4
  %y = getelementptr inbounds %class.Coord, ptr %0, i32 0, i32 1
  %y5 = load i32, ptr %y, align 4, !tbaa !0
  %o6 = load ptr, ptr %o, align 8
  %y7 = getelementptr inbounds %class.Coord, ptr %o6, i32 0, i32 1
  %y8 = load i32, ptr %y7, align 4, !tbaa !0
  %5 = sub i32 %y5, %y8
  call void @Coord.Coord(ptr %Coord.obj, i32 %4, i32 %5)
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %2, ptr align 8 %Coord.obj, i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64), i1 false)
  ret void
}

define internal void @Rect.Rect(ptr %0, i32 %1, i32 %2, i32 %3) {
entry:
  %w = alloca i32, align 4
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 %2, ptr %y, align 4
  store i32 %3, ptr %w, align 4
  %tl = getelementptr inbounds %class.Rect, ptr %0, i32 0, i32 0
  store ptr null, ptr %tl, align 8, !tbaa !4
  %tl1 = getelementptr inbounds %class.Rect, ptr %0, i32 0, i32 0
  %Coord.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  %x2 = load i32, ptr %x, align 4
  %y3 = load i32, ptr %y, align 4
  call void @Coord.Coord(ptr %Coord.obj, i32 %x2, i32 %y3)
  store ptr %Coord.obj, ptr %tl1, align 8, !tbaa !4
  %w4 = getelementptr inbounds %class.Rect, ptr %0, i32 0, i32 1
  %w5 = load i32, ptr %w, align 4
  store i32 %w5, ptr %w4, align 4, !tbaa !0
  ret void
}

define internal void @Holder.Holder(ptr %0, i32 %1, i32 %2) {
entry:
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 %2, ptr %y, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Holder, ptr %0, i32 0, i32 0
  store ptr @Holder.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  %cap = getelementptr inbounds %class.Holder, ptr %0, i32 0, i32 1
  store ptr null, ptr %cap, align 8, !tbaa !4
  %cap1 = getelementptr inbounds %class.Holder, ptr %0, i32 0, i32 1
  %Coord.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  %x2 = load i32, ptr %x, align 4
  %y3 = load i32, ptr %y, align 4
  call void @Coord.Coord(ptr %Coord.obj, i32 %x2, i32 %y3)
  store ptr %Coord.obj, ptr %cap1, align 8, !tbaa !4
  ret void
}

define internal void @Holder2.Holder2(ptr %0, i32 %1, i32 %2) {
entry:
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 %2, ptr %y, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Holder2, ptr %0, i32 0, i32 0
  store ptr @Holder2.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  %cap.dflt = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  %3 = call ptr @memset(ptr %cap.dflt, i32 0, i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  %cap = getelementptr inbounds %class.Holder2, ptr %0, i32 0, i32 1
  store ptr %cap.dflt, ptr %cap, align 8, !tbaa !4
  %cap1 = getelementptr inbounds %class.Holder2, ptr %0, i32 0, i32 1
  %cap2 = load ptr, ptr %cap1, align 8, !tbaa !4
  %x3 = getelementptr inbounds %class.Coord, ptr %cap2, i32 0, i32 0
  %x4 = load i32, ptr %x, align 4
  store i32 %x4, ptr %x3, align 4, !tbaa !0
  %cap5 = getelementptr inbounds %class.Holder2, ptr %0, i32 0, i32 1
  %cap6 = load ptr, ptr %cap5, align 8, !tbaa !4
  %y7 = getelementptr inbounds %class.Coord, ptr %cap6, i32 0, i32 1
  %y8 = load i32, ptr %y, align 4
  store i32 %y8, ptr %y7, align 4, !tbaa !0
  ret void
}

define internal void @Holder3.Holder3(ptr %0, i32 %1, i32 %2) {
entry:
  %sret = alloca %class.Coord, align 8
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 %2, ptr %y, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Holder3, ptr %0, i32 0, i32 0
  store ptr @Holder3.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  %cap = getelementptr inbounds %class.Holder3, ptr %0, i32 0, i32 1
  store ptr null, ptr %cap, align 8, !tbaa !4
  %cap1 = getelementptr inbounds %class.Holder3, ptr %0, i32 0, i32 1
  %x2 = load i32, ptr %x, align 4
  %y3 = load i32, ptr %y, align 4
  call void @Main.origin(i32 %x2, i32 %y3, ptr %sret)
  %Coord.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  %3 = call ptr @memcpy(ptr %Coord.copy, ptr %sret, i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  store ptr %Coord.copy, ptr %cap1, align 8, !tbaa !4
  ret void
}

define internal void @Main.origin(i32 %0, i32 %1, ptr %2) {
entry:
  %Coord.obj = alloca %class.Coord, align 8
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  store i32 %1, ptr %y, align 4
  %x1 = load i32, ptr %x, align 4
  %y2 = load i32, ptr %y, align 4
  call void @Coord.Coord(ptr %Coord.obj, i32 %x1, i32 %y2)
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %2, ptr align 8 %Coord.obj, i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64), i1 false)
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %d = alloca ptr, align 8
  %sret = alloca %class.Coord, align 8
  %h3 = alloca ptr, align 8
  %h2 = alloca ptr, align 8
  %r = alloca ptr, align 8
  %Rect.obj = alloca %class.Rect, align 8
  %cs = alloca ptr, align 8
  %h = alloca ptr, align 8
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
  %Holder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Holder, ptr null, i64 1) to i64))
  call void @Holder.Holder(ptr %Holder.obj, i32 10, i32 20)
  store ptr %Holder.obj, ptr %h, align 8
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 16)
  store ptr %arr, ptr %cs, align 8
  %cs2 = load ptr, ptr %cs, align 8, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %cs2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %cs2, i64 8
  %arr.elem = getelementptr inbounds %class.Coord, ptr %arr.data3, i64 0
  %Coord.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  call void @Coord.Coord(ptr %Coord.obj, i32 3, i32 4)
  %17 = call ptr @memcpy(ptr %arr.elem, ptr %Coord.obj, i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  %cs4 = load ptr, ptr %cs, align 8, !nonnull !6, !dereferenceable !7
  %arr.len5 = load i64, ptr %cs4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !8

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %cs4, i64 8
  %arr.elem10 = getelementptr inbounds %class.Coord, ptr %arr.data9, i64 1
  %Coord.obj11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  call void @Coord.Coord(ptr %Coord.obj11, i32 30, i32 40)
  %18 = call ptr @memcpy(ptr %arr.elem10, ptr %Coord.obj11, i64 ptrtoint (ptr getelementptr (%class.Coord, ptr null, i64 1) to i64))
  call void @Rect.Rect(ptr %Rect.obj, i32 5, i32 6, i32 7)
  store ptr %Rect.obj, ptr %r, align 8
  %Holder2.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Holder2, ptr null, i64 1) to i64))
  call void @Holder2.Holder2(ptr %Holder2.obj, i32 99, i32 88)
  store ptr %Holder2.obj, ptr %h2, align 8
  %Holder3.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Holder3, ptr null, i64 1) to i64))
  call void @Holder3.Holder3(ptr %Holder3.obj, i32 77, i32 66)
  store ptr %Holder3.obj, ptr %h3, align 8
  %h12 = load ptr, ptr %h, align 8
  %cap = getelementptr inbounds %class.Holder, ptr %h12, i32 0, i32 1
  %cap13 = load ptr, ptr %cap, align 8, !tbaa !4
  %cs14 = load ptr, ptr %cs, align 8, !nonnull !6, !dereferenceable !7
  %arr.len15 = load i64, ptr %cs14, align 8
  %arr.oob16 = icmp uge i64 0, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !8

idx.bad17:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 0, ptr @.failb.6, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok8
  %arr.data19 = getelementptr i8, ptr %cs14, i64 8
  %arr.elem20 = getelementptr inbounds %class.Coord, ptr %arr.data19, i64 0
  call void @Coord.operator-(ptr %cap13, ptr %arr.elem20, ptr %sret)
  store ptr %sret, ptr %d, align 8
  %h21 = load ptr, ptr %h, align 8
  %cap22 = getelementptr inbounds %class.Holder, ptr %h21, i32 0, i32 1
  %cap23 = load ptr, ptr %cap22, align 8, !tbaa !4
  %x = getelementptr inbounds %class.Coord, ptr %cap23, i32 0, i32 0
  %x24 = load i32, ptr %x, align 4, !tbaa !0
  %h25 = load ptr, ptr %h, align 8
  %cap26 = getelementptr inbounds %class.Holder, ptr %h25, i32 0, i32 1
  %cap27 = load ptr, ptr %cap26, align 8, !tbaa !4
  %y = getelementptr inbounds %class.Coord, ptr %cap27, i32 0, i32 1
  %y28 = load i32, ptr %y, align 4, !tbaa !0
  %cs29 = load ptr, ptr %cs, align 8, !nonnull !6, !dereferenceable !7
  %arr.len30 = load i64, ptr %cs29, align 8
  %arr.oob31 = icmp uge i64 1, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

idx.bad32:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 1, ptr @.failb.9, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %idx.ok18
  %arr.data34 = getelementptr i8, ptr %cs29, i64 8
  %arr.elem35 = getelementptr inbounds %class.Coord, ptr %arr.data34, i64 1
  %x36 = getelementptr inbounds %class.Coord, ptr %arr.elem35, i32 0, i32 0
  %x37 = load i32, ptr %x36, align 4, !tbaa !0
  %cs38 = load ptr, ptr %cs, align 8, !nonnull !6, !dereferenceable !7
  %arr.len39 = load i64, ptr %cs38, align 8
  %arr.oob40 = icmp uge i64 1, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !8

idx.bad41:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 1, ptr @.failb.12, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %idx.ok33
  %arr.data43 = getelementptr i8, ptr %cs38, i64 8
  %arr.elem44 = getelementptr inbounds %class.Coord, ptr %arr.data43, i64 1
  %y45 = getelementptr inbounds %class.Coord, ptr %arr.elem44, i32 0, i32 1
  %y46 = load i32, ptr %y45, align 4, !tbaa !0
  %r47 = load ptr, ptr %r, align 8
  %tl = getelementptr inbounds %class.Rect, ptr %r47, i32 0, i32 0
  %tl48 = load ptr, ptr %tl, align 8, !tbaa !4
  %x49 = getelementptr inbounds %class.Coord, ptr %tl48, i32 0, i32 0
  %x50 = load i32, ptr %x49, align 4, !tbaa !0
  %r51 = load ptr, ptr %r, align 8
  %w = getelementptr inbounds %class.Rect, ptr %r51, i32 0, i32 1
  %w52 = load i32, ptr %w, align 4, !tbaa !0
  %d53 = load ptr, ptr %d, align 8
  %x54 = getelementptr inbounds %class.Coord, ptr %d53, i32 0, i32 0
  %x55 = load i32, ptr %x54, align 4, !tbaa !0
  %d56 = load ptr, ptr %d, align 8
  %y57 = getelementptr inbounds %class.Coord, ptr %d56, i32 0, i32 1
  %y58 = load i32, ptr %y57, align 4, !tbaa !0
  %h259 = load ptr, ptr %h2, align 8
  %cap60 = getelementptr inbounds %class.Holder2, ptr %h259, i32 0, i32 1
  %cap61 = load ptr, ptr %cap60, align 8, !tbaa !4
  %x62 = getelementptr inbounds %class.Coord, ptr %cap61, i32 0, i32 0
  %x63 = load i32, ptr %x62, align 4, !tbaa !0
  %h264 = load ptr, ptr %h2, align 8
  %cap65 = getelementptr inbounds %class.Holder2, ptr %h264, i32 0, i32 1
  %cap66 = load ptr, ptr %cap65, align 8, !tbaa !4
  %y67 = getelementptr inbounds %class.Coord, ptr %cap66, i32 0, i32 1
  %y68 = load i32, ptr %y67, align 4, !tbaa !0
  %h369 = load ptr, ptr %h3, align 8
  %cap70 = getelementptr inbounds %class.Holder3, ptr %h369, i32 0, i32 1
  %cap71 = load ptr, ptr %cap70, align 8, !tbaa !4
  %x72 = getelementptr inbounds %class.Coord, ptr %cap71, i32 0, i32 0
  %x73 = load i32, ptr %x72, align 4, !tbaa !0
  %h374 = load ptr, ptr %h3, align 8
  %cap75 = getelementptr inbounds %class.Holder3, ptr %h374, i32 0, i32 1
  %cap76 = load ptr, ptr %cap75, align 8, !tbaa !4
  %y77 = getelementptr inbounds %class.Coord, ptr %cap76, i32 0, i32 1
  %y78 = load i32, ptr %y77, align 4, !tbaa !0
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %x24, i32 %y28, i32 %x37, i32 %y46, i32 %x50, i32 %w52, i32 %x55, i32 %y58, i32 %x63, i32 %y68, i32 %x73, i32 %y78)
  %h79 = load ptr, ptr %h, align 8
  call void @__polaron_check_live(ptr %h79)
  %vtbl.addr = getelementptr inbounds %class.Holder, ptr %h79, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !4
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %20 = icmp ne ptr %dtor.fn, null
  br i1 %20, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %idx.ok42
  call void %dtor.fn(ptr %h79)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %idx.ok42
  call void @__polaron_free(ptr %h79)
  %h280 = load ptr, ptr %h2, align 8
  call void @__polaron_check_live(ptr %h280)
  %vtbl.addr81 = getelementptr inbounds %class.Holder2, ptr %h280, i32 0, i32 0
  %vtbl82 = load ptr, ptr %vtbl.addr81, align 8, !tbaa !4
  %dtor.slot83 = getelementptr [349 x ptr], ptr %vtbl82, i64 0, i64 348
  %dtor.fn84 = load ptr, ptr %dtor.slot83, align 8
  %21 = icmp ne ptr %dtor.fn84, null
  br i1 %21, label %dtor.call85, label %dtor.free86

dtor.call85:                                      ; preds = %dtor.free
  call void %dtor.fn84(ptr %h280)
  br label %dtor.free86

dtor.free86:                                      ; preds = %dtor.call85, %dtor.free
  call void @__polaron_free(ptr %h280)
  %h387 = load ptr, ptr %h3, align 8
  call void @__polaron_check_live(ptr %h387)
  %vtbl.addr88 = getelementptr inbounds %class.Holder3, ptr %h387, i32 0, i32 0
  %vtbl89 = load ptr, ptr %vtbl.addr88, align 8, !tbaa !4
  %dtor.slot90 = getelementptr [349 x ptr], ptr %vtbl89, i64 0, i64 348
  %dtor.fn91 = load ptr, ptr %dtor.slot90, align 8
  %22 = icmp ne ptr %dtor.fn91, null
  br i1 %22, label %dtor.call92, label %dtor.free93

dtor.call92:                                      ; preds = %dtor.free86
  call void %dtor.fn91(ptr %h387)
  br label %dtor.free93

dtor.free93:                                      ; preds = %dtor.call92, %dtor.free86
  call void @__polaron_free(ptr %h387)
  %cs94 = load ptr, ptr %cs, align 8
  call void @__polaron_free(ptr %cs94)
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5321)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5323)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @memcpy(ptr, ptr, i64)

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #0

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memset(ptr, i32, i64)

declare i64 @strlen(ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #1

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #1 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"ptr", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
