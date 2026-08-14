; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32, i32, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [351 x ptr] [ptr @Node.insert, ptr @Node.inOrder, ptr @Node.leftmost, ptr @Node.rightmost, ptr @Node.find, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [351 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Node.region = internal global ptr null
@.panic = private unnamed_addr constant [146 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol:47:44  in Node.insert\0A\00", align 1
@.panic.1 = private unnamed_addr constant [146 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol:50:45  in Node.insert\0A\00", align 1
@.panic.2 = private unnamed_addr constant [147 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol:56:59  in Node.inOrder\0A\00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.panic.3 = private unnamed_addr constant [147 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol:58:61  in Node.inOrder\0A\00", align 1
@.panic.4 = private unnamed_addr constant [148 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol:64:17  in Node.leftmost\0A\00", align 1
@.panic.5 = private unnamed_addr constant [149 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol:69:17  in Node.rightmost\0A\00", align 1
@.panic.6 = private unnamed_addr constant [144 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol:76:21  in Node.find\0A\00", align 1
@.panic.7 = private unnamed_addr constant [144 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_class_narrow.pol:79:17  in Node.find\0A\00", align 1
@.str.8 = private unnamed_addr constant [36 x i8] c"/ root=%d leftmost=%d rightmost=%d \00", align 1
@.str.9 = private unnamed_addr constant [14 x i8] c"/ missing=%d\0A\00", align 1
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }

define internal void @Node.Node(ptr %0, i32 %1, i32 %2) {
entry:
  %value = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  store i32 %2, ptr %value, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %key1 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %key2 = load i32, ptr %key, align 4
  store i32 %key2, ptr %key1, align 4, !tbaa !4
  %value3 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %value4 = load i32, ptr %value, align 4
  store i32 %value4, ptr %value3, align 4, !tbaa !4
  %left = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %rgncls.cur = load ptr, ptr @Node.region, align 8
  %rgncls.absent = icmp eq ptr %rgncls.cur, null
  br i1 %rgncls.absent, label %rgncls.init, label %rgncls.ready

rgncls.init:                                      ; preds = %entry
  %rgncls.arena = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena, ptr @Node.region, align 8
  br label %rgncls.ready

rgncls.ready:                                     ; preds = %rgncls.init, %entry
  %rgncls.arena5 = load ptr, ptr @Node.region, align 8
  %Node.base = call ptr @__polaron_arena_base(ptr %rgncls.arena5)
  %3 = ptrtoint ptr %Node.base to i64
  %narrow.delta = sub i64 0, %3
  %narrow.off = trunc i64 %narrow.delta to i32
  %narrow.store = select i1 true, i32 0, i32 %narrow.off
  store i32 %narrow.store, ptr %left, align 4, !tbaa !4
  %right = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %rgncls.cur8 = load ptr, ptr @Node.region, align 8
  %rgncls.absent9 = icmp eq ptr %rgncls.cur8, null
  br i1 %rgncls.absent9, label %rgncls.init6, label %rgncls.ready7

rgncls.init6:                                     ; preds = %rgncls.ready
  %rgncls.arena10 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena10, ptr @Node.region, align 8
  br label %rgncls.ready7

rgncls.ready7:                                    ; preds = %rgncls.init6, %rgncls.ready
  %rgncls.arena11 = load ptr, ptr @Node.region, align 8
  %Node.base12 = call ptr @__polaron_arena_base(ptr %rgncls.arena11)
  %4 = ptrtoint ptr %Node.base12 to i64
  %narrow.delta13 = sub i64 0, %4
  %narrow.off14 = trunc i64 %narrow.delta13 to i32
  %narrow.store15 = select i1 true, i32 0, i32 %narrow.off14
  store i32 %narrow.store15, ptr %right, align 4, !tbaa !4
  ret void
}

define internal void @Node.insert(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %v = alloca i32, align 4
  %k = alloca i32, align 4
  store i32 %1, ptr %k, align 4
  store i32 %2, ptr %v, align 4
  %k1 = load i32, ptr %k, align 4
  %key = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %key2 = load i32, ptr %key, align 4, !tbaa !4
  %3 = icmp slt i32 %k1, %key2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %left = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %left.off = load i32, ptr %left, align 4, !tbaa !4
  %rgncls.cur = load ptr, ptr @Node.region, align 8
  %rgncls.absent = icmp eq ptr %rgncls.cur, null
  br i1 %rgncls.absent, label %rgncls.init, label %rgncls.ready

if.else:                                          ; preds = %entry
  %right = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %right.off = load i32, ptr %right, align 4, !tbaa !4
  %rgncls.cur42 = load ptr, ptr @Node.region, align 8
  %rgncls.absent43 = icmp eq ptr %rgncls.cur42, null
  br i1 %rgncls.absent43, label %rgncls.init40, label %rgncls.ready41

if.end:                                           ; preds = %if.end51, %if.end8
  ret void

rgncls.init:                                      ; preds = %if.then
  %rgncls.arena = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena, ptr @Node.region, align 8
  br label %rgncls.ready

rgncls.ready:                                     ; preds = %rgncls.init, %if.then
  %rgncls.arena3 = load ptr, ptr @Node.region, align 8
  %Node.base = call ptr @__polaron_arena_base(ptr %rgncls.arena3)
  %5 = zext i32 %left.off to i64
  %left4 = getelementptr i8, ptr %Node.base, i64 %5
  %left.isnull = icmp eq i32 %left.off, 0
  %left5 = select i1 %left.isnull, ptr null, ptr %left4
  %6 = icmp eq ptr %left5, null
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then6, label %if.else7

if.then6:                                         ; preds = %rgncls.ready
  %left9 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %rgncls.cur12 = load ptr, ptr @Node.region, align 8
  %rgncls.absent13 = icmp eq ptr %rgncls.cur12, null
  br i1 %rgncls.absent13, label %rgncls.init10, label %rgncls.ready11

if.else7:                                         ; preds = %rgncls.ready
  %left26 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %left.off27 = load i32, ptr %left26, align 4, !tbaa !4
  %rgncls.cur30 = load ptr, ptr @Node.region, align 8
  %rgncls.absent31 = icmp eq ptr %rgncls.cur30, null
  br i1 %rgncls.absent31, label %rgncls.init28, label %rgncls.ready29

if.end8:                                          ; preds = %nullrecv.ok, %rgncls.ready20
  br label %if.end

rgncls.init10:                                    ; preds = %if.then6
  %rgncls.arena14 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena14, ptr @Node.region, align 8
  br label %rgncls.ready11

rgncls.ready11:                                   ; preds = %rgncls.init10, %if.then6
  %rgncls.arena15 = load ptr, ptr @Node.region, align 8
  %Node.off = call i64 @__polaron_arena_alloc(ptr %rgncls.arena15, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %Node.base16 = call ptr @__polaron_arena_base(ptr %rgncls.arena15)
  %Node.obj = getelementptr i8, ptr %Node.base16, i64 %Node.off
  %k17 = load i32, ptr %k, align 4
  %v18 = load i32, ptr %v, align 4
  call void @Node.Node(ptr %Node.obj, i32 %k17, i32 %v18)
  %rgncls.cur21 = load ptr, ptr @Node.region, align 8
  %rgncls.absent22 = icmp eq ptr %rgncls.cur21, null
  br i1 %rgncls.absent22, label %rgncls.init19, label %rgncls.ready20

rgncls.init19:                                    ; preds = %rgncls.ready11
  %rgncls.arena23 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena23, ptr @Node.region, align 8
  br label %rgncls.ready20

rgncls.ready20:                                   ; preds = %rgncls.init19, %rgncls.ready11
  %rgncls.arena24 = load ptr, ptr @Node.region, align 8
  %Node.base25 = call ptr @__polaron_arena_base(ptr %rgncls.arena24)
  %8 = ptrtoint ptr %Node.base25 to i64
  %9 = ptrtoint ptr %Node.obj to i64
  %narrow.delta = sub i64 %9, %8
  %narrow.off = trunc i64 %narrow.delta to i32
  %narrow.isnull = icmp eq ptr %Node.obj, null
  %narrow.store = select i1 %narrow.isnull, i32 0, i32 %narrow.off
  store i32 %narrow.store, ptr %left9, align 4, !tbaa !4
  br label %if.end8

rgncls.init28:                                    ; preds = %if.else7
  %rgncls.arena32 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena32, ptr @Node.region, align 8
  br label %rgncls.ready29

rgncls.ready29:                                   ; preds = %rgncls.init28, %if.else7
  %rgncls.arena33 = load ptr, ptr @Node.region, align 8
  %Node.base34 = call ptr @__polaron_arena_base(ptr %rgncls.arena33)
  %10 = zext i32 %left.off27 to i64
  %left35 = getelementptr i8, ptr %Node.base34, i64 %10
  %left.isnull36 = icmp eq i32 %left.off27, 0
  %left37 = select i1 %left.isnull36, ptr null, ptr %left35
  %11 = icmp eq ptr %left37, null
  br i1 %11, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %rgncls.ready29
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %rgncls.ready29
  %k38 = load i32, ptr %k, align 4
  %v39 = load i32, ptr %v, align 4
  call void @Node.insert(ptr %left37, i32 %k38, i32 %v39)
  br label %if.end8

rgncls.init40:                                    ; preds = %if.else
  %rgncls.arena44 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena44, ptr @Node.region, align 8
  br label %rgncls.ready41

rgncls.ready41:                                   ; preds = %rgncls.init40, %if.else
  %rgncls.arena45 = load ptr, ptr @Node.region, align 8
  %Node.base46 = call ptr @__polaron_arena_base(ptr %rgncls.arena45)
  %12 = zext i32 %right.off to i64
  %right47 = getelementptr i8, ptr %Node.base46, i64 %12
  %right.isnull = icmp eq i32 %right.off, 0
  %right48 = select i1 %right.isnull, ptr null, ptr %right47
  %13 = icmp eq ptr %right48, null
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then49, label %if.else50

if.then49:                                        ; preds = %rgncls.ready41
  %right52 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %rgncls.cur55 = load ptr, ptr @Node.region, align 8
  %rgncls.absent56 = icmp eq ptr %rgncls.cur55, null
  br i1 %rgncls.absent56, label %rgncls.init53, label %rgncls.ready54

if.else50:                                        ; preds = %rgncls.ready41
  %right75 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %right.off76 = load i32, ptr %right75, align 4, !tbaa !4
  %rgncls.cur79 = load ptr, ptr @Node.region, align 8
  %rgncls.absent80 = icmp eq ptr %rgncls.cur79, null
  br i1 %rgncls.absent80, label %rgncls.init77, label %rgncls.ready78

if.end51:                                         ; preds = %nullrecv.ok88, %rgncls.ready65
  br label %if.end

rgncls.init53:                                    ; preds = %if.then49
  %rgncls.arena57 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena57, ptr @Node.region, align 8
  br label %rgncls.ready54

rgncls.ready54:                                   ; preds = %rgncls.init53, %if.then49
  %rgncls.arena58 = load ptr, ptr @Node.region, align 8
  %Node.off59 = call i64 @__polaron_arena_alloc(ptr %rgncls.arena58, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %Node.base60 = call ptr @__polaron_arena_base(ptr %rgncls.arena58)
  %Node.obj61 = getelementptr i8, ptr %Node.base60, i64 %Node.off59
  %k62 = load i32, ptr %k, align 4
  %v63 = load i32, ptr %v, align 4
  call void @Node.Node(ptr %Node.obj61, i32 %k62, i32 %v63)
  %rgncls.cur66 = load ptr, ptr @Node.region, align 8
  %rgncls.absent67 = icmp eq ptr %rgncls.cur66, null
  br i1 %rgncls.absent67, label %rgncls.init64, label %rgncls.ready65

rgncls.init64:                                    ; preds = %rgncls.ready54
  %rgncls.arena68 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena68, ptr @Node.region, align 8
  br label %rgncls.ready65

rgncls.ready65:                                   ; preds = %rgncls.init64, %rgncls.ready54
  %rgncls.arena69 = load ptr, ptr @Node.region, align 8
  %Node.base70 = call ptr @__polaron_arena_base(ptr %rgncls.arena69)
  %15 = ptrtoint ptr %Node.base70 to i64
  %16 = ptrtoint ptr %Node.obj61 to i64
  %narrow.delta71 = sub i64 %16, %15
  %narrow.off72 = trunc i64 %narrow.delta71 to i32
  %narrow.isnull73 = icmp eq ptr %Node.obj61, null
  %narrow.store74 = select i1 %narrow.isnull73, i32 0, i32 %narrow.off72
  store i32 %narrow.store74, ptr %right52, align 4, !tbaa !4
  br label %if.end51

rgncls.init77:                                    ; preds = %if.else50
  %rgncls.arena81 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena81, ptr @Node.region, align 8
  br label %rgncls.ready78

rgncls.ready78:                                   ; preds = %rgncls.init77, %if.else50
  %rgncls.arena82 = load ptr, ptr @Node.region, align 8
  %Node.base83 = call ptr @__polaron_arena_base(ptr %rgncls.arena82)
  %17 = zext i32 %right.off76 to i64
  %right84 = getelementptr i8, ptr %Node.base83, i64 %17
  %right.isnull85 = icmp eq i32 %right.off76, 0
  %right86 = select i1 %right.isnull85, ptr null, ptr %right84
  %18 = icmp eq ptr %right86, null
  br i1 %18, label %nullrecv87, label %nullrecv.ok88

nullrecv87:                                       ; preds = %rgncls.ready78
  call void @__polaron_panic(ptr @.panic.1)
  unreachable

nullrecv.ok88:                                    ; preds = %rgncls.ready78
  %k89 = load i32, ptr %k, align 4
  %v90 = load i32, ptr %v, align 4
  call void @Node.insert(ptr %right86, i32 %k89, i32 %v90)
  br label %if.end51
}

define internal void @Node.inOrder(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %left = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %left.off = load i32, ptr %left, align 4, !tbaa !4
  %rgncls.cur = load ptr, ptr @Node.region, align 8
  %rgncls.absent = icmp eq ptr %rgncls.cur, null
  br i1 %rgncls.absent, label %rgncls.init, label %rgncls.ready

rgncls.init:                                      ; preds = %entry
  %rgncls.arena = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena, ptr @Node.region, align 8
  br label %rgncls.ready

rgncls.ready:                                     ; preds = %rgncls.init, %entry
  %rgncls.arena1 = load ptr, ptr @Node.region, align 8
  %Node.base = call ptr @__polaron_arena_base(ptr %rgncls.arena1)
  %1 = zext i32 %left.off to i64
  %left2 = getelementptr i8, ptr %Node.base, i64 %1
  %left.isnull = icmp eq i32 %left.off, 0
  %left3 = select i1 %left.isnull, ptr null, ptr %left2
  %2 = icmp ne ptr %left3, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %rgncls.ready
  %left4 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %left.off5 = load i32, ptr %left4, align 4, !tbaa !4
  %rgncls.cur8 = load ptr, ptr @Node.region, align 8
  %rgncls.absent9 = icmp eq ptr %rgncls.cur8, null
  br i1 %rgncls.absent9, label %rgncls.init6, label %rgncls.ready7

if.end:                                           ; preds = %nullrecv.ok, %rgncls.ready
  %value = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %value16 = load i32, ptr %value, align 4, !tbaa !4
  %4 = call i32 (ptr, ...) @printf(ptr @.str, i32 %value16)
  %right = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %right.off = load i32, ptr %right, align 4, !tbaa !4
  %rgncls.cur19 = load ptr, ptr @Node.region, align 8
  %rgncls.absent20 = icmp eq ptr %rgncls.cur19, null
  br i1 %rgncls.absent20, label %rgncls.init17, label %rgncls.ready18

rgncls.init6:                                     ; preds = %if.then
  %rgncls.arena10 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena10, ptr @Node.region, align 8
  br label %rgncls.ready7

rgncls.ready7:                                    ; preds = %rgncls.init6, %if.then
  %rgncls.arena11 = load ptr, ptr @Node.region, align 8
  %Node.base12 = call ptr @__polaron_arena_base(ptr %rgncls.arena11)
  %5 = zext i32 %left.off5 to i64
  %left13 = getelementptr i8, ptr %Node.base12, i64 %5
  %left.isnull14 = icmp eq i32 %left.off5, 0
  %left15 = select i1 %left.isnull14, ptr null, ptr %left13
  %6 = icmp eq ptr %left15, null
  br i1 %6, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %rgncls.ready7
  call void @__polaron_panic(ptr @.panic.2)
  unreachable

nullrecv.ok:                                      ; preds = %rgncls.ready7
  call void @Node.inOrder(ptr %left15)
  br label %if.end

rgncls.init17:                                    ; preds = %if.end
  %rgncls.arena21 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena21, ptr @Node.region, align 8
  br label %rgncls.ready18

rgncls.ready18:                                   ; preds = %rgncls.init17, %if.end
  %rgncls.arena22 = load ptr, ptr @Node.region, align 8
  %Node.base23 = call ptr @__polaron_arena_base(ptr %rgncls.arena22)
  %7 = zext i32 %right.off to i64
  %right24 = getelementptr i8, ptr %Node.base23, i64 %7
  %right.isnull = icmp eq i32 %right.off, 0
  %right25 = select i1 %right.isnull, ptr null, ptr %right24
  %8 = icmp ne ptr %right25, null
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then26, label %if.end27

if.then26:                                        ; preds = %rgncls.ready18
  %right28 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %right.off29 = load i32, ptr %right28, align 4, !tbaa !4
  %rgncls.cur32 = load ptr, ptr @Node.region, align 8
  %rgncls.absent33 = icmp eq ptr %rgncls.cur32, null
  br i1 %rgncls.absent33, label %rgncls.init30, label %rgncls.ready31

if.end27:                                         ; preds = %nullrecv.ok41, %rgncls.ready18
  ret void

rgncls.init30:                                    ; preds = %if.then26
  %rgncls.arena34 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena34, ptr @Node.region, align 8
  br label %rgncls.ready31

rgncls.ready31:                                   ; preds = %rgncls.init30, %if.then26
  %rgncls.arena35 = load ptr, ptr @Node.region, align 8
  %Node.base36 = call ptr @__polaron_arena_base(ptr %rgncls.arena35)
  %10 = zext i32 %right.off29 to i64
  %right37 = getelementptr i8, ptr %Node.base36, i64 %10
  %right.isnull38 = icmp eq i32 %right.off29, 0
  %right39 = select i1 %right.isnull38, ptr null, ptr %right37
  %11 = icmp eq ptr %right39, null
  br i1 %11, label %nullrecv40, label %nullrecv.ok41

nullrecv40:                                       ; preds = %rgncls.ready31
  call void @__polaron_panic(ptr @.panic.3)
  unreachable

nullrecv.ok41:                                    ; preds = %rgncls.ready31
  call void @Node.inOrder(ptr %right39)
  br label %if.end27
}

define internal i32 @Node.leftmost(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %left = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %left.off = load i32, ptr %left, align 4, !tbaa !4
  %rgncls.cur = load ptr, ptr @Node.region, align 8
  %rgncls.absent = icmp eq ptr %rgncls.cur, null
  br i1 %rgncls.absent, label %rgncls.init, label %rgncls.ready

rgncls.init:                                      ; preds = %entry
  %rgncls.arena = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena, ptr @Node.region, align 8
  br label %rgncls.ready

rgncls.ready:                                     ; preds = %rgncls.init, %entry
  %rgncls.arena1 = load ptr, ptr @Node.region, align 8
  %Node.base = call ptr @__polaron_arena_base(ptr %rgncls.arena1)
  %1 = zext i32 %left.off to i64
  %left2 = getelementptr i8, ptr %Node.base, i64 %1
  %left.isnull = icmp eq i32 %left.off, 0
  %left3 = select i1 %left.isnull, ptr null, ptr %left2
  %2 = icmp eq ptr %left3, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %rgncls.ready
  %key = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %key4 = load i32, ptr %key, align 4, !tbaa !4
  ret i32 %key4

if.end:                                           ; preds = %rgncls.ready
  %left5 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %left.off6 = load i32, ptr %left5, align 4, !tbaa !4
  %rgncls.cur9 = load ptr, ptr @Node.region, align 8
  %rgncls.absent10 = icmp eq ptr %rgncls.cur9, null
  br i1 %rgncls.absent10, label %rgncls.init7, label %rgncls.ready8

rgncls.init7:                                     ; preds = %if.end
  %rgncls.arena11 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena11, ptr @Node.region, align 8
  br label %rgncls.ready8

rgncls.ready8:                                    ; preds = %rgncls.init7, %if.end
  %rgncls.arena12 = load ptr, ptr @Node.region, align 8
  %Node.base13 = call ptr @__polaron_arena_base(ptr %rgncls.arena12)
  %4 = zext i32 %left.off6 to i64
  %left14 = getelementptr i8, ptr %Node.base13, i64 %4
  %left.isnull15 = icmp eq i32 %left.off6, 0
  %left16 = select i1 %left.isnull15, ptr null, ptr %left14
  %5 = icmp eq ptr %left16, null
  br i1 %5, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %rgncls.ready8
  call void @__polaron_panic(ptr @.panic.4)
  unreachable

nullrecv.ok:                                      ; preds = %rgncls.ready8
  %6 = call i32 @Node.leftmost(ptr %left16)
  ret i32 %6
}

define internal i32 @Node.rightmost(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %right = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %right.off = load i32, ptr %right, align 4, !tbaa !4
  %rgncls.cur = load ptr, ptr @Node.region, align 8
  %rgncls.absent = icmp eq ptr %rgncls.cur, null
  br i1 %rgncls.absent, label %rgncls.init, label %rgncls.ready

rgncls.init:                                      ; preds = %entry
  %rgncls.arena = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena, ptr @Node.region, align 8
  br label %rgncls.ready

rgncls.ready:                                     ; preds = %rgncls.init, %entry
  %rgncls.arena1 = load ptr, ptr @Node.region, align 8
  %Node.base = call ptr @__polaron_arena_base(ptr %rgncls.arena1)
  %1 = zext i32 %right.off to i64
  %right2 = getelementptr i8, ptr %Node.base, i64 %1
  %right.isnull = icmp eq i32 %right.off, 0
  %right3 = select i1 %right.isnull, ptr null, ptr %right2
  %2 = icmp eq ptr %right3, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %rgncls.ready
  %key = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %key4 = load i32, ptr %key, align 4, !tbaa !4
  ret i32 %key4

if.end:                                           ; preds = %rgncls.ready
  %right5 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %right.off6 = load i32, ptr %right5, align 4, !tbaa !4
  %rgncls.cur9 = load ptr, ptr @Node.region, align 8
  %rgncls.absent10 = icmp eq ptr %rgncls.cur9, null
  br i1 %rgncls.absent10, label %rgncls.init7, label %rgncls.ready8

rgncls.init7:                                     ; preds = %if.end
  %rgncls.arena11 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena11, ptr @Node.region, align 8
  br label %rgncls.ready8

rgncls.ready8:                                    ; preds = %rgncls.init7, %if.end
  %rgncls.arena12 = load ptr, ptr @Node.region, align 8
  %Node.base13 = call ptr @__polaron_arena_base(ptr %rgncls.arena12)
  %4 = zext i32 %right.off6 to i64
  %right14 = getelementptr i8, ptr %Node.base13, i64 %4
  %right.isnull15 = icmp eq i32 %right.off6, 0
  %right16 = select i1 %right.isnull15, ptr null, ptr %right14
  %5 = icmp eq ptr %right16, null
  br i1 %5, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %rgncls.ready8
  call void @__polaron_panic(ptr @.panic.5)
  unreachable

nullrecv.ok:                                      ; preds = %rgncls.ready8
  %6 = call i32 @Node.rightmost(ptr %right16)
  ret i32 %6
}

define internal i32 @Node.find(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %k = alloca i32, align 4
  store i32 %1, ptr %k, align 4
  %k1 = load i32, ptr %k, align 4
  %key = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %key2 = load i32, ptr %key, align 4, !tbaa !4
  %2 = icmp eq i32 %k1, %key2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %value = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %value3 = load i32, ptr %value, align 4, !tbaa !4
  ret i32 %value3

if.end:                                           ; preds = %entry
  %k4 = load i32, ptr %k, align 4
  %key5 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %key6 = load i32, ptr %key5, align 4, !tbaa !4
  %4 = icmp slt i32 %k4, %key6
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end
  %left = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %left.off = load i32, ptr %left, align 4, !tbaa !4
  %rgncls.cur = load ptr, ptr @Node.region, align 8
  %rgncls.absent = icmp eq ptr %rgncls.cur, null
  br i1 %rgncls.absent, label %rgncls.init, label %rgncls.ready

if.end8:                                          ; preds = %if.end
  %right = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %right.off = load i32, ptr %right, align 4, !tbaa !4
  %rgncls.cur29 = load ptr, ptr @Node.region, align 8
  %rgncls.absent30 = icmp eq ptr %rgncls.cur29, null
  br i1 %rgncls.absent30, label %rgncls.init27, label %rgncls.ready28

rgncls.init:                                      ; preds = %if.then7
  %rgncls.arena = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena, ptr @Node.region, align 8
  br label %rgncls.ready

rgncls.ready:                                     ; preds = %rgncls.init, %if.then7
  %rgncls.arena9 = load ptr, ptr @Node.region, align 8
  %Node.base = call ptr @__polaron_arena_base(ptr %rgncls.arena9)
  %6 = zext i32 %left.off to i64
  %left10 = getelementptr i8, ptr %Node.base, i64 %6
  %left.isnull = icmp eq i32 %left.off, 0
  %left11 = select i1 %left.isnull, ptr null, ptr %left10
  %7 = icmp eq ptr %left11, null
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then12, label %if.end13

if.then12:                                        ; preds = %rgncls.ready
  ret i32 0

if.end13:                                         ; preds = %rgncls.ready
  %left14 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 3
  %left.off15 = load i32, ptr %left14, align 4, !tbaa !4
  %rgncls.cur18 = load ptr, ptr @Node.region, align 8
  %rgncls.absent19 = icmp eq ptr %rgncls.cur18, null
  br i1 %rgncls.absent19, label %rgncls.init16, label %rgncls.ready17

rgncls.init16:                                    ; preds = %if.end13
  %rgncls.arena20 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena20, ptr @Node.region, align 8
  br label %rgncls.ready17

rgncls.ready17:                                   ; preds = %rgncls.init16, %if.end13
  %rgncls.arena21 = load ptr, ptr @Node.region, align 8
  %Node.base22 = call ptr @__polaron_arena_base(ptr %rgncls.arena21)
  %9 = zext i32 %left.off15 to i64
  %left23 = getelementptr i8, ptr %Node.base22, i64 %9
  %left.isnull24 = icmp eq i32 %left.off15, 0
  %left25 = select i1 %left.isnull24, ptr null, ptr %left23
  %10 = icmp eq ptr %left25, null
  br i1 %10, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %rgncls.ready17
  call void @__polaron_panic(ptr @.panic.6)
  unreachable

nullrecv.ok:                                      ; preds = %rgncls.ready17
  %k26 = load i32, ptr %k, align 4
  %11 = call i32 @Node.find(ptr %left25, i32 %k26)
  ret i32 %11

rgncls.init27:                                    ; preds = %if.end8
  %rgncls.arena31 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena31, ptr @Node.region, align 8
  br label %rgncls.ready28

rgncls.ready28:                                   ; preds = %rgncls.init27, %if.end8
  %rgncls.arena32 = load ptr, ptr @Node.region, align 8
  %Node.base33 = call ptr @__polaron_arena_base(ptr %rgncls.arena32)
  %12 = zext i32 %right.off to i64
  %right34 = getelementptr i8, ptr %Node.base33, i64 %12
  %right.isnull = icmp eq i32 %right.off, 0
  %right35 = select i1 %right.isnull, ptr null, ptr %right34
  %13 = icmp eq ptr %right35, null
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then36, label %if.end37

if.then36:                                        ; preds = %rgncls.ready28
  ret i32 0

if.end37:                                         ; preds = %rgncls.ready28
  %right38 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 4
  %right.off39 = load i32, ptr %right38, align 4, !tbaa !4
  %rgncls.cur42 = load ptr, ptr @Node.region, align 8
  %rgncls.absent43 = icmp eq ptr %rgncls.cur42, null
  br i1 %rgncls.absent43, label %rgncls.init40, label %rgncls.ready41

rgncls.init40:                                    ; preds = %if.end37
  %rgncls.arena44 = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena44, ptr @Node.region, align 8
  br label %rgncls.ready41

rgncls.ready41:                                   ; preds = %rgncls.init40, %if.end37
  %rgncls.arena45 = load ptr, ptr @Node.region, align 8
  %Node.base46 = call ptr @__polaron_arena_base(ptr %rgncls.arena45)
  %15 = zext i32 %right.off39 to i64
  %right47 = getelementptr i8, ptr %Node.base46, i64 %15
  %right.isnull48 = icmp eq i32 %right.off39, 0
  %right49 = select i1 %right.isnull48, ptr null, ptr %right47
  %16 = icmp eq ptr %right49, null
  br i1 %16, label %nullrecv50, label %nullrecv.ok51

nullrecv50:                                       ; preds = %rgncls.ready41
  call void @__polaron_panic(ptr @.panic.7)
  unreachable

nullrecv.ok51:                                    ; preds = %rgncls.ready41
  %k52 = load i32, ptr %k, align 4
  %17 = call i32 @Node.find(ptr %right49, i32 %k52)
  ret i32 %17
}

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %rgncls.cur = load ptr, ptr @Node.region, align 8
  %rgncls.absent = icmp eq ptr %rgncls.cur, null
  br i1 %rgncls.absent, label %rgncls.init, label %rgncls.ready

rgncls.init:                                      ; preds = %argv.end
  %rgncls.arena = call ptr @__polaron_arena_reserve()
  store ptr %rgncls.arena, ptr @Node.region, align 8
  br label %rgncls.ready

rgncls.ready:                                     ; preds = %rgncls.init, %argv.end
  %rgncls.arena1 = load ptr, ptr @Node.region, align 8
  %Node.off = call i64 @__polaron_arena_alloc(ptr %rgncls.arena1, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %Node.base = call ptr @__polaron_arena_base(ptr %rgncls.arena1)
  %Node.obj = getelementptr i8, ptr %Node.base, i64 %Node.off
  call void @Node.Node(ptr %Node.obj, i32 4, i32 4)
  store ptr %Node.obj, ptr %root, align 8
  %root2 = load ptr, ptr %root, align 8
  call void @Node.insert(ptr %root2, i32 2, i32 2)
  %root3 = load ptr, ptr %root, align 8
  call void @Node.insert(ptr %root3, i32 6, i32 6)
  %root4 = load ptr, ptr %root, align 8
  call void @Node.insert(ptr %root4, i32 1, i32 1)
  %root5 = load ptr, ptr %root, align 8
  call void @Node.insert(ptr %root5, i32 3, i32 3)
  %root6 = load ptr, ptr %root, align 8
  call void @Node.insert(ptr %root6, i32 5, i32 5)
  %root7 = load ptr, ptr %root, align 8
  call void @Node.insert(ptr %root7, i32 7, i32 7)
  %root8 = load ptr, ptr %root, align 8
  call void @Node.inOrder(ptr %root8)
  %root9 = load ptr, ptr %root, align 8
  %value = getelementptr inbounds %class.Node, ptr %root9, i32 0, i32 2
  %value10 = load i32, ptr %value, align 4, !tbaa !4
  %root11 = load ptr, ptr %root, align 8
  %16 = call i32 @Node.leftmost(ptr %root11)
  %root12 = load ptr, ptr %root, align 8
  %17 = call i32 @Node.rightmost(ptr %root12)
  %18 = call i32 (ptr, ...) @printf(ptr @.str.8, i32 %value10, i32 %16, i32 %17)
  %root13 = load ptr, ptr %root, align 8
  %19 = call i32 @Node.find(ptr %root13, i32 99)
  %20 = call i32 (ptr, ...) @printf(ptr @.str.9, i32 %19)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_arena_reserve()

; Function Attrs: nounwind memory(read)
declare noalias ptr @__polaron_arena_base(ptr) #0

declare i64 @__polaron_arena_alloc(ptr, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #1

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nounwind memory(read) }
attributes #1 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
