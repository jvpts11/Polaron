; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/affinity.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/affinity.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Particle = type { ptr, float, float, float, float, i32, i32 }
%class.Tagged = type { ptr, float, float, float, float, i32, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Particle.vtable = private constant [350 x ptr] [ptr @Particle.advance, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Tagged.vtable = private constant [350 x ptr] [ptr @Particle.advance, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [21 x i8] c"x=%.1f y=%.1f id=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"tx=%.1f ty=%.1f tid=%d tag=%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"ux=%.1f uid=%d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define internal void @Particle.Particle(ptr %0, i32 %1, float %2, float %3, float %4, float %5) {
entry:
  %vy = alloca float, align 4
  %vx = alloca float, align 4
  %y = alloca float, align 4
  %x = alloca float, align 4
  %id = alloca i32, align 4
  store i32 %1, ptr %id, align 4
  store float %2, ptr %x, align 4
  store float %3, ptr %y, align 4
  store float %4, ptr %vx, align 4
  store float %5, ptr %vy, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 0
  store ptr @Particle.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %id1 = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 5
  %id2 = load i32, ptr %id, align 4
  store i32 %id2, ptr %id1, align 4, !tbaa !4
  %spawnFrame = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 6
  store i32 0, ptr %spawnFrame, align 4, !tbaa !4
  %x3 = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 1
  %x4 = load float, ptr %x, align 4
  store float %x4, ptr %x3, align 4, !tbaa !6
  %y5 = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 2
  %y6 = load float, ptr %y, align 4
  store float %y6, ptr %y5, align 4, !tbaa !6
  %vx7 = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 3
  %vx8 = load float, ptr %vx, align 4
  store float %vx8, ptr %vx7, align 4, !tbaa !6
  %vy9 = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 4
  %vy10 = load float, ptr %vy, align 4
  store float %vy10, ptr %vy9, align 4, !tbaa !6
  ret void
}

define internal void @Particle.advance(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %x = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 1
  %x1 = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 1
  %x2 = load float, ptr %x1, align 4, !tbaa !6
  %vx = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 3
  %vx3 = load float, ptr %vx, align 4, !tbaa !6
  %1 = fadd float %x2, %vx3
  store float %1, ptr %x, align 4, !tbaa !6
  %y = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 2
  %y4 = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 2
  %y5 = load float, ptr %y4, align 4, !tbaa !6
  %vy = getelementptr inbounds %class.Particle, ptr %0, i32 0, i32 4
  %vy6 = load float, ptr %vy, align 4, !tbaa !6
  %2 = fadd float %y5, %vy6
  store float %2, ptr %y, align 4, !tbaa !6
  ret void
}

define internal void @Tagged.Tagged(ptr %0, i32 %1, float %2, float %3, i32 %4) {
entry:
  %tag = alloca i32, align 4
  %y = alloca float, align 4
  %x = alloca float, align 4
  %id = alloca i32, align 4
  store i32 %1, ptr %id, align 4
  store float %2, ptr %x, align 4
  store float %3, ptr %y, align 4
  store i32 %4, ptr %tag, align 4
  %id1 = load i32, ptr %id, align 4
  %x2 = load float, ptr %x, align 4
  %y3 = load float, ptr %y, align 4
  call void @Particle.Particle(ptr %0, i32 %id1, float %x2, float %y3, float 1.000000e+00, float 2.000000e+00)
  %vtbl.addr = getelementptr inbounds %class.Tagged, ptr %0, i32 0, i32 0
  store ptr @Tagged.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %tag4 = getelementptr inbounds %class.Tagged, ptr %0, i32 0, i32 7
  %tag5 = load i32, ptr %tag, align 4
  store i32 %tag5, ptr %tag4, align 4, !tbaa !4
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %up = alloca ptr, align 8
  %t = alloca ptr, align 8
  %i = alloca i32, align 4
  %p = alloca ptr, align 8
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
  %Particle.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Particle, ptr null, i64 1) to i64))
  call void @Particle.Particle(ptr %Particle.obj, i32 7, float 1.000000e+00, float 2.000000e+00, float 5.000000e-01, float 2.500000e-01)
  store ptr %Particle.obj, ptr %p, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %dv.join, %argv.end
  %i1 = load i32, ptr %i, align 4
  %16 = icmp slt i32 %i1, 4
  %17 = zext i1 %16 to i32
  br i1 %16, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %p2 = load ptr, ptr %p, align 8
  %vtbl.addr = getelementptr inbounds %class.Particle, ptr %p2, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 0
  %fn = load ptr, ptr %slot, align 8
  %dv.is = icmp eq ptr %fn, @Particle.advance
  br i1 %dv.is, label %dv.hit, label %dv.miss

while.end:                                        ; preds = %while.cond
  %p4 = load ptr, ptr %p, align 8
  %x = getelementptr inbounds %class.Particle, ptr %p4, i32 0, i32 1
  %x5 = load float, ptr %x, align 4, !tbaa !6
  %18 = fpext float %x5 to double
  %p6 = load ptr, ptr %p, align 8
  %y = getelementptr inbounds %class.Particle, ptr %p6, i32 0, i32 2
  %y7 = load float, ptr %y, align 4, !tbaa !6
  %19 = fpext float %y7 to double
  %p8 = load ptr, ptr %p, align 8
  %id = getelementptr inbounds %class.Particle, ptr %p8, i32 0, i32 5
  %id9 = load i32, ptr %id, align 4, !tbaa !4
  %20 = call i32 (ptr, ...) @printf(ptr @.str, double %18, double %19, i32 %id9)
  %Tagged.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Tagged, ptr null, i64 1) to i64))
  call void @Tagged.Tagged(ptr %Tagged.obj, i32 9, float 1.000000e+01, float 2.000000e+01, i32 42)
  store ptr %Tagged.obj, ptr %t, align 8
  %t10 = load ptr, ptr %t, align 8
  call void @Particle.advance(ptr %t10)
  %t11 = load ptr, ptr %t, align 8
  %x12 = getelementptr inbounds %class.Tagged, ptr %t11, i32 0, i32 1
  %x13 = load float, ptr %x12, align 4, !tbaa !6
  %21 = fpext float %x13 to double
  %t14 = load ptr, ptr %t, align 8
  %y15 = getelementptr inbounds %class.Tagged, ptr %t14, i32 0, i32 2
  %y16 = load float, ptr %y15, align 4, !tbaa !6
  %22 = fpext float %y16 to double
  %t17 = load ptr, ptr %t, align 8
  %id18 = getelementptr inbounds %class.Tagged, ptr %t17, i32 0, i32 5
  %id19 = load i32, ptr %id18, align 4, !tbaa !4
  %t20 = load ptr, ptr %t, align 8
  %tag = getelementptr inbounds %class.Tagged, ptr %t20, i32 0, i32 7
  %tag21 = load i32, ptr %tag, align 4, !tbaa !4
  %23 = call i32 (ptr, ...) @printf(ptr @.str.1, double %21, double %22, i32 %id19, i32 %tag21)
  %t22 = load ptr, ptr %t, align 8
  store ptr %t22, ptr %up, align 8
  %up23 = load ptr, ptr %up, align 8
  %x24 = getelementptr inbounds %class.Particle, ptr %up23, i32 0, i32 1
  %x25 = load float, ptr %x24, align 4, !tbaa !6
  %24 = fpext float %x25 to double
  %up26 = load ptr, ptr %up, align 8
  %id27 = getelementptr inbounds %class.Particle, ptr %up26, i32 0, i32 5
  %id28 = load i32, ptr %id27, align 4, !tbaa !4
  %25 = call i32 (ptr, ...) @printf(ptr @.str.2, double %24, i32 %id28)
  %t29 = load ptr, ptr %t, align 8
  call void @__polaron_check_live(ptr %t29)
  %vtbl.addr30 = getelementptr inbounds %class.Tagged, ptr %t29, i32 0, i32 0
  %vtbl31 = load ptr, ptr %vtbl.addr30, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl31, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %26 = icmp ne ptr %dtor.fn, null
  br i1 %26, label %dtor.call, label %dtor.free

dv.join:                                          ; preds = %dv.miss, %dv.hit
  %i3 = load i32, ptr %i, align 4
  %27 = add i32 %i3, 1
  store i32 %27, ptr %i, align 4
  br label %while.cond

dv.hit:                                           ; preds = %while.body
  call void @Particle.advance(ptr %p2)
  br label %dv.join

dv.miss:                                          ; preds = %while.body
  call void %fn(ptr %p2)
  br label %dv.join

dtor.call:                                        ; preds = %while.end
  call void %dtor.fn(ptr %t29)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %while.end
  call void @__polaron_free(ptr %t29)
  %p32 = load ptr, ptr %p, align 8
  call void @__polaron_check_live(ptr %p32)
  %vtbl.addr33 = getelementptr inbounds %class.Particle, ptr %p32, i32 0, i32 0
  %vtbl34 = load ptr, ptr %vtbl.addr33, align 8, !tbaa !0
  %dtor.slot35 = getelementptr [350 x ptr], ptr %vtbl34, i64 0, i64 349
  %dtor.fn36 = load ptr, ptr %dtor.slot35, align 8
  %28 = icmp ne ptr %dtor.fn36, null
  br i1 %28, label %dtor.call37, label %dtor.free38

dtor.call37:                                      ; preds = %dtor.free
  call void %dtor.fn36(ptr %p32)
  br label %dtor.free38

dtor.free38:                                      ; preds = %dtor.call37, %dtor.free
  call void @__polaron_free(ptr %p32)
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

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"f32", !2, i64 0}
