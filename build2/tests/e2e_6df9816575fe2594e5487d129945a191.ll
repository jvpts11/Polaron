; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_release.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_release.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32 }
%class.Leaf = type { ptr, i32 }
%class.Branch = type { ptr, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Leaf.vtable = private constant [349 x ptr] [ptr @Node.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Leaf.~Leaf"]
@Branch.vtable = private constant [349 x ptr] [ptr @Node.get, ptr @Branch.total, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Branch.~Branch"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@instances.Node = private global i32 0
@instances.Leaf = private global i32 0
@instances.Branch = private global i32 0
@Node.region = internal global ptr null
@.str = private unnamed_addr constant [9 x i8] c"%d %d | \00", align 1
@.panic = private unnamed_addr constant [69 x i8] c"cannot release the region of 'Node': instances of it are still alive\00", align 1
@.str.1 = private unnamed_addr constant [19 x i8] c"after release: %d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define internal void @Node.Node(ptr %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  call void @Object.Object(ptr %0)
  %inst.n = load i32, ptr @instances.Node, align 4
  %2 = add i32 %inst.n, 1
  store i32 %2, ptr @instances.Node, align 4
  %value = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %v1 = load i32, ptr %v, align 4
  store i32 %v1, ptr %value, align 4, !tbaa !0
  ret void
}

define internal i32 @Node.get(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %value = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %value1 = load i32, ptr %value, align 4, !tbaa !0
  ret i32 %value1
}

define internal void @"Node.~Node"(ptr %0) {
entry:
  %inst.n = load i32, ptr @instances.Node, align 4
  %1 = sub i32 %inst.n, 1
  store i32 %1, ptr @instances.Node, align 4
  ret void
}

define internal void @Leaf.Leaf(ptr %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  call void @Node.Node(ptr %0, i32 %v1)
  %vtbl.addr = getelementptr inbounds %class.Leaf, ptr %0, i32 0, i32 0
  store ptr @Leaf.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  %inst.n = load i32, ptr @instances.Leaf, align 4
  %2 = add i32 %inst.n, 1
  store i32 %2, ptr @instances.Leaf, align 4
  ret void
}

define internal void @"Leaf.~Leaf"(ptr %0) {
entry:
  %inst.n = load i32, ptr @instances.Leaf, align 4
  %1 = sub i32 %inst.n, 1
  store i32 %1, ptr @instances.Leaf, align 4
  call void @"Node.~Node"(ptr %0)
  ret void
}

define internal void @Branch.Branch(ptr %0, i32 %1, i32 %2) {
entry:
  %w = alloca i32, align 4
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  store i32 %2, ptr %w, align 4
  %v1 = load i32, ptr %v, align 4
  call void @Node.Node(ptr %0, i32 %v1)
  %vtbl.addr = getelementptr inbounds %class.Branch, ptr %0, i32 0, i32 0
  store ptr @Branch.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  %inst.n = load i32, ptr @instances.Branch, align 4
  %3 = add i32 %inst.n, 1
  store i32 %3, ptr @instances.Branch, align 4
  %weight = getelementptr inbounds %class.Branch, ptr %0, i32 0, i32 2
  %w2 = load i32, ptr %w, align 4
  store i32 %w2, ptr %weight, align 4, !tbaa !0
  ret void
}

define internal i32 @Branch.total(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %value = getelementptr inbounds %class.Branch, ptr %0, i32 0, i32 1
  %value1 = load i32, ptr %value, align 4, !tbaa !0
  %weight = getelementptr inbounds %class.Branch, ptr %0, i32 0, i32 2
  %weight2 = load i32, ptr %weight, align 4, !tbaa !0
  %1 = add i32 %value1, %weight2
  ret i32 %1
}

define internal void @"Branch.~Branch"(ptr %0) {
entry:
  %inst.n = load i32, ptr @instances.Branch, align 4
  %1 = sub i32 %inst.n, 1
  store i32 %1, ptr @instances.Branch, align 4
  call void @"Node.~Node"(ptr %0)
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %c = alloca ptr, align 8
  store ptr null, ptr %c, align 8
  %b = alloca ptr, align 8
  store ptr null, ptr %b, align 8
  %a = alloca ptr, align 8
  store ptr null, ptr %a, align 8
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
  %rgncls.cur = load ptr, ptr @Node.region, align 8
  %rgncls.absent = icmp eq ptr %rgncls.cur, null
  br i1 %rgncls.absent, label %rgncls.init, label %rgncls.ready

rgncls.init:                                      ; preds = %argv.end
  %rgncls.arena = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena, ptr @Node.region, align 8
  br label %rgncls.ready

rgncls.ready:                                     ; preds = %rgncls.init, %argv.end
  %rgncls.arena1 = load ptr, ptr @Node.region, align 8
  %Leaf.off = call i64 @__polaron_arena_alloc(ptr %rgncls.arena1, i64 ptrtoint (ptr getelementptr (%class.Leaf, ptr null, i64 1) to i64))
  %Leaf.base = call ptr @__polaron_arena_base(ptr %rgncls.arena1)
  %Leaf.obj = getelementptr i8, ptr %Leaf.base, i64 %Leaf.off
  call void @Leaf.Leaf(ptr %Leaf.obj, i32 7)
  store ptr %Leaf.obj, ptr %a, align 8
  %rgncls.cur4 = load ptr, ptr @Node.region, align 8
  %rgncls.absent5 = icmp eq ptr %rgncls.cur4, null
  br i1 %rgncls.absent5, label %rgncls.init2, label %rgncls.ready3

rgncls.init2:                                     ; preds = %rgncls.ready
  %rgncls.arena6 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena6, ptr @Node.region, align 8
  br label %rgncls.ready3

rgncls.ready3:                                    ; preds = %rgncls.init2, %rgncls.ready
  %rgncls.arena7 = load ptr, ptr @Node.region, align 8
  %Branch.off = call i64 @__polaron_arena_alloc(ptr %rgncls.arena7, i64 ptrtoint (ptr getelementptr (%class.Branch, ptr null, i64 1) to i64))
  %Branch.base = call ptr @__polaron_arena_base(ptr %rgncls.arena7)
  %Branch.obj = getelementptr i8, ptr %Branch.base, i64 %Branch.off
  invoke void @Branch.Branch(ptr %Branch.obj, i32 4, i32 7)
          to label %invoke.cont unwind label %cleanup.Leaf

cleanup.Leaf:                                     ; preds = %rgncls.ready3
  %16 = cleanuppad within none []
  %17 = load ptr, ptr %a, align 8
  call void @"Leaf.~Leaf"(ptr %17) [ "funclet"(token %16) ]
  cleanupret from %16 unwind to caller

invoke.cont:                                      ; preds = %rgncls.ready3
  store ptr %Branch.obj, ptr %b, align 8
  %a8 = load ptr, ptr %a, align 8
  %18 = invoke i32 @Node.get(ptr %a8)
          to label %invoke.cont10 unwind label %cleanup.Branch

cleanup.Leaf9:                                    ; preds = %cleanup.Branch
  %19 = cleanuppad within none []
  %20 = load ptr, ptr %a, align 8
  call void @"Leaf.~Leaf"(ptr %20) [ "funclet"(token %19) ]
  cleanupret from %19 unwind to caller

cleanup.Branch:                                   ; preds = %invoke.cont
  %21 = cleanuppad within none []
  %22 = load ptr, ptr %b, align 8
  call void @"Branch.~Branch"(ptr %22) [ "funclet"(token %21) ]
  cleanupret from %21 unwind label %cleanup.Leaf9

invoke.cont10:                                    ; preds = %invoke.cont
  %b11 = load ptr, ptr %b, align 8
  %23 = invoke i32 @Branch.total(ptr %b11)
          to label %invoke.cont14 unwind label %cleanup.Branch13

cleanup.Leaf12:                                   ; preds = %cleanup.Branch13
  %24 = cleanuppad within none []
  %25 = load ptr, ptr %a, align 8
  call void @"Leaf.~Leaf"(ptr %25) [ "funclet"(token %24) ]
  cleanupret from %24 unwind to caller

cleanup.Branch13:                                 ; preds = %invoke.cont10
  %26 = cleanuppad within none []
  %27 = load ptr, ptr %b, align 8
  call void @"Branch.~Branch"(ptr %27) [ "funclet"(token %26) ]
  cleanupret from %26 unwind label %cleanup.Leaf12

invoke.cont14:                                    ; preds = %invoke.cont10
  %28 = call i32 (ptr, ...) @printf(ptr @.str, i32 %18, i32 %23)
  %a15 = load ptr, ptr %a, align 8
  call void @"Leaf.~Leaf"(ptr %a15)
  %b16 = load ptr, ptr %b, align 8
  call void @"Branch.~Branch"(ptr %b16)
  %Branch.live = load i32, ptr @instances.Branch, align 4
  %29 = icmp ne i32 %Branch.live, 0
  %rgncls.anylive = or i1 false, %29
  %Leaf.live = load i32, ptr @instances.Leaf, align 4
  %30 = icmp ne i32 %Leaf.live, 0
  %rgncls.anylive17 = or i1 %rgncls.anylive, %30
  %Node.live = load i32, ptr @instances.Node, align 4
  %31 = icmp ne i32 %Node.live, 0
  %rgncls.anylive18 = or i1 %rgncls.anylive17, %31
  br i1 %rgncls.anylive18, label %rgncls.live, label %rgncls.free

rgncls.live:                                      ; preds = %invoke.cont14
  call void @__polaron_panic(ptr @.panic)
  unreachable

rgncls.free:                                      ; preds = %invoke.cont14
  %rgncls.arena19 = load ptr, ptr @Node.region, align 8
  %32 = icmp eq ptr %rgncls.arena19, null
  br i1 %32, label %rgncls.done, label %rgncls.have

rgncls.have:                                      ; preds = %rgncls.free
  call void @__polaron_arena_free(ptr %rgncls.arena19)
  store ptr null, ptr @Node.region, align 8
  br label %rgncls.done

rgncls.done:                                      ; preds = %rgncls.have, %rgncls.free
  %rgncls.cur22 = load ptr, ptr @Node.region, align 8
  %rgncls.absent23 = icmp eq ptr %rgncls.cur22, null
  br i1 %rgncls.absent23, label %rgncls.init20, label %rgncls.ready21

rgncls.init20:                                    ; preds = %rgncls.done
  %rgncls.arena24 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena24, ptr @Node.region, align 8
  br label %rgncls.ready21

rgncls.ready21:                                   ; preds = %rgncls.init20, %rgncls.done
  %rgncls.arena25 = load ptr, ptr @Node.region, align 8
  %Leaf.off26 = call i64 @__polaron_arena_alloc(ptr %rgncls.arena25, i64 ptrtoint (ptr getelementptr (%class.Leaf, ptr null, i64 1) to i64))
  %Leaf.base27 = call ptr @__polaron_arena_base(ptr %rgncls.arena25)
  %Leaf.obj28 = getelementptr i8, ptr %Leaf.base27, i64 %Leaf.off26
  call void @Leaf.Leaf(ptr %Leaf.obj28, i32 5)
  store ptr %Leaf.obj28, ptr %c, align 8
  %c29 = load ptr, ptr %c, align 8
  %33 = invoke i32 @Node.get(ptr %c29)
          to label %invoke.cont31 unwind label %cleanup.Leaf30

cleanup.Leaf30:                                   ; preds = %rgncls.ready21
  %34 = cleanuppad within none []
  %35 = load ptr, ptr %c, align 8
  call void @"Leaf.~Leaf"(ptr %35) [ "funclet"(token %34) ]
  cleanupret from %34 unwind to caller

invoke.cont31:                                    ; preds = %rgncls.ready21
  %36 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %33)
  %c32 = load ptr, ptr %c, align 8
  call void @"Leaf.~Leaf"(ptr %c32)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare noalias ptr @__polaron_arena_reserve()

declare i64 @__polaron_arena_alloc(ptr, i64)

; Function Attrs: nounwind memory(read)
declare noalias ptr @__polaron_arena_base(ptr) #0

declare i32 @__CxxFrameHandler3(...)

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #1

declare void @__polaron_arena_free(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nounwind memory(read) }
attributes #1 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"ptr", !2, i64 0}
