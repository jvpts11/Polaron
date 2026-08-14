; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/dispatch_table.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/dispatch_table.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Dog = type { ptr, i32 }
%class.Poodle = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Dog.vtable = private global [351 x ptr] [ptr @Dog.bark, ptr @Dog.loudness, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Poodle.vtable = private global [351 x ptr] [ptr @Dog.bark, ptr @Poodle.loudness, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [351 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [11 x i8] c"woof (%d)\0A\00", align 1
@Dog.bark.patch0.fn = private global ptr null
@.str.1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"woof remix\00", align 1
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_0, ptr null]
@Dog.loudness.patch1.fn = private global ptr null
@__polaron_closure.3 = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_1, ptr null]
@.str.4 = private unnamed_addr constant [13 x i8] c"loudness=%d\0A\00", align 1
@Dog.loudness.patch2.fn = private global ptr null
@.str.5 = private unnamed_addr constant [13 x i8] c"captured=%d\0A\00", align 1
@.str.6 = private unnamed_addr constant [11 x i8] c"poodle=%d\0A\00", align 1
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }

define internal void @Dog.Dog(ptr %0, i32 %1) {
entry:
  %volume = alloca i32, align 4
  store i32 %1, ptr %volume, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 0
  store ptr @Dog.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %volume1 = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %volume2 = load i32, ptr %volume, align 4
  store i32 %volume2, ptr %volume1, align 4, !tbaa !4
  ret void
}

define internal void @Dog.bark(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %volume = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %volume1 = load i32, ptr %volume, align 4, !tbaa !4
  %1 = call i32 (ptr, ...) @printf(ptr @.str, i32 %volume1)
  ret void
}

define internal i32 @Dog.loudness(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %times = alloca i32, align 4
  store i32 %1, ptr %times, align 4
  %volume = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %volume1 = load i32, ptr %volume, align 4, !tbaa !4
  %times2 = load i32, ptr %times, align 4
  %2 = mul i32 %volume1, %times2
  ret i32 %2
}

define internal void @Poodle.Poodle(ptr %0) {
entry:
  call void @Dog.Dog(ptr %0, i32 1)
  %vtbl.addr = getelementptr inbounds %class.Poodle, ptr %0, i32 0, i32 0
  store ptr @Poodle.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal i32 @Poodle.loudness(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %times = alloca i32, align 4
  store i32 %1, ptr %times, align 4
  %times1 = load i32, ptr %times, align 4
  ret i32 %times1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %p = alloca ptr, align 8
  %base = alloca i32, align 4
  %fido = alloca ptr, align 8
  %rex = alloca ptr, align 8
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
  %Dog.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64))
  call void @Dog.Dog(ptr %Dog.obj, i32 3)
  store ptr %Dog.obj, ptr %rex, align 8
  %rex1 = load ptr, ptr %rex, align 8
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %rex1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 0
  %fn = load ptr, ptr %slot, align 8
  %dv.is = icmp eq ptr %fn, @Dog.bark
  br i1 %dv.is, label %dv.hit, label %dv.miss

dv.join:                                          ; preds = %dv.miss, %dv.hit
  store ptr @__polaron_closure, ptr @Dog.bark.patch0.fn, align 8
  store ptr @Dog.bark.patch0.thunk, ptr @Dog.vtable, align 8
  store ptr @Dog.bark.patch0.thunk, ptr @Poodle.vtable, align 8
  %Dog.obj2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64))
  call void @Dog.Dog(ptr %Dog.obj2, i32 9)
  store ptr %Dog.obj2, ptr %fido, align 8
  %rex3 = load ptr, ptr %rex, align 8
  %vtbl.addr4 = getelementptr inbounds %class.Dog, ptr %rex3, i32 0, i32 0
  %vtbl5 = load ptr, ptr %vtbl.addr4, align 8, !tbaa !0
  %slot6 = getelementptr [350 x ptr], ptr %vtbl5, i64 0, i64 0
  %fn7 = load ptr, ptr %slot6, align 8
  %dv.is11 = icmp eq ptr %fn7, @Dog.bark
  br i1 %dv.is11, label %dv.hit9, label %dv.miss10

dv.hit:                                           ; preds = %argv.end
  call void @Dog.bark(ptr %rex1)
  br label %dv.join

dv.miss:                                          ; preds = %argv.end
  call void %fn(ptr %rex1)
  br label %dv.join

dv.join8:                                         ; preds = %dv.miss10, %dv.hit9
  %fido12 = load ptr, ptr %fido, align 8
  %vtbl.addr13 = getelementptr inbounds %class.Dog, ptr %fido12, i32 0, i32 0
  %vtbl14 = load ptr, ptr %vtbl.addr13, align 8, !tbaa !0
  %slot15 = getelementptr [350 x ptr], ptr %vtbl14, i64 0, i64 0
  %fn16 = load ptr, ptr %slot15, align 8
  %dv.is20 = icmp eq ptr %fn16, @Dog.bark
  br i1 %dv.is20, label %dv.hit18, label %dv.miss19

dv.hit9:                                          ; preds = %dv.join
  call void @Dog.bark(ptr %rex3)
  br label %dv.join8

dv.miss10:                                        ; preds = %dv.join
  call void %fn7(ptr %rex3)
  br label %dv.join8

dv.join17:                                        ; preds = %dv.miss19, %dv.hit18
  store ptr @__polaron_closure.3, ptr @Dog.loudness.patch1.fn, align 8
  store ptr @Dog.loudness.patch1.thunk, ptr getelementptr inbounds ([351 x ptr], ptr @Dog.vtable, i64 0, i64 1), align 8
  %rex21 = load ptr, ptr %rex, align 8
  %vtbl.addr22 = getelementptr inbounds %class.Dog, ptr %rex21, i32 0, i32 0
  %vtbl23 = load ptr, ptr %vtbl.addr22, align 8, !tbaa !0
  %slot24 = getelementptr [350 x ptr], ptr %vtbl23, i64 0, i64 1
  %fn25 = load ptr, ptr %slot24, align 8
  %dv.is29 = icmp eq ptr %fn25, @Dog.loudness
  br i1 %dv.is29, label %dv.hit27, label %dv.miss28

dv.hit18:                                         ; preds = %dv.join8
  call void @Dog.bark(ptr %fido12)
  br label %dv.join17

dv.miss19:                                        ; preds = %dv.join8
  call void %fn16(ptr %fido12)
  br label %dv.join17

dv.join26:                                        ; preds = %dv.miss31, %dv.hit30, %dv.hit27
  %dv.r = phi i32 [ %20, %dv.hit27 ], [ %21, %dv.hit30 ], [ %22, %dv.miss31 ]
  %16 = call i32 (ptr, ...) @printf(ptr @.str.4, i32 %dv.r)
  store i32 1000, ptr %base, align 4
  %env = call ptr @__polaron_malloc(i64 8)
  %17 = getelementptr ptr, ptr %env, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %18 = load i32, ptr %base, align 4
  store i32 %18, ptr %cap, align 4
  store ptr %cap, ptr %17, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_2, ptr %closure, align 8
  %19 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env, ptr %19, align 8
  store ptr %closure, ptr @Dog.loudness.patch2.fn, align 8
  store ptr @Dog.loudness.patch2.thunk, ptr getelementptr inbounds ([351 x ptr], ptr @Dog.vtable, i64 0, i64 1), align 8
  %fido33 = load ptr, ptr %fido, align 8
  %vtbl.addr34 = getelementptr inbounds %class.Dog, ptr %fido33, i32 0, i32 0
  %vtbl35 = load ptr, ptr %vtbl.addr34, align 8, !tbaa !0
  %slot36 = getelementptr [350 x ptr], ptr %vtbl35, i64 0, i64 1
  %fn37 = load ptr, ptr %slot36, align 8
  %dv.is41 = icmp eq ptr %fn37, @Dog.loudness
  br i1 %dv.is41, label %dv.hit39, label %dv.miss40

dv.hit27:                                         ; preds = %dv.join17
  %20 = call i32 @Dog.loudness(ptr %rex21, i32 7)
  br label %dv.join26

dv.miss28:                                        ; preds = %dv.join17
  %dv.is32 = icmp eq ptr %fn25, @Poodle.loudness
  br i1 %dv.is32, label %dv.hit30, label %dv.miss31

dv.hit30:                                         ; preds = %dv.miss28
  %21 = call i32 @Poodle.loudness(ptr %rex21, i32 7)
  br label %dv.join26

dv.miss31:                                        ; preds = %dv.miss28
  %22 = call i32 %fn25(ptr %rex21, i32 7)
  br label %dv.join26

dv.join38:                                        ; preds = %dv.miss43, %dv.hit42, %dv.hit39
  %dv.r45 = phi i32 [ %24, %dv.hit39 ], [ %25, %dv.hit42 ], [ %26, %dv.miss43 ]
  %23 = call i32 (ptr, ...) @printf(ptr @.str.5, i32 %dv.r45)
  %Poodle.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Poodle, ptr null, i64 1) to i64))
  call void @Poodle.Poodle(ptr %Poodle.obj)
  store ptr %Poodle.obj, ptr %p, align 8
  %p46 = load ptr, ptr %p, align 8
  %vtbl.addr47 = getelementptr inbounds %class.Poodle, ptr %p46, i32 0, i32 0
  %vtbl48 = load ptr, ptr %vtbl.addr47, align 8, !tbaa !0
  %slot49 = getelementptr [350 x ptr], ptr %vtbl48, i64 0, i64 0
  %fn50 = load ptr, ptr %slot49, align 8
  %dv.is54 = icmp eq ptr %fn50, @Dog.bark
  br i1 %dv.is54, label %dv.hit52, label %dv.miss53

dv.hit39:                                         ; preds = %dv.join26
  %24 = call i32 @Dog.loudness(ptr %fido33, i32 5)
  br label %dv.join38

dv.miss40:                                        ; preds = %dv.join26
  %dv.is44 = icmp eq ptr %fn37, @Poodle.loudness
  br i1 %dv.is44, label %dv.hit42, label %dv.miss43

dv.hit42:                                         ; preds = %dv.miss40
  %25 = call i32 @Poodle.loudness(ptr %fido33, i32 5)
  br label %dv.join38

dv.miss43:                                        ; preds = %dv.miss40
  %26 = call i32 %fn37(ptr %fido33, i32 5)
  br label %dv.join38

dv.join51:                                        ; preds = %dv.miss53, %dv.hit52
  %p55 = load ptr, ptr %p, align 8
  %vtbl.addr56 = getelementptr inbounds %class.Poodle, ptr %p55, i32 0, i32 0
  %vtbl57 = load ptr, ptr %vtbl.addr56, align 8, !tbaa !0
  %slot58 = getelementptr [350 x ptr], ptr %vtbl57, i64 0, i64 1
  %fn59 = load ptr, ptr %slot58, align 8
  %dv.is63 = icmp eq ptr %fn59, @Dog.loudness
  br i1 %dv.is63, label %dv.hit61, label %dv.miss62

dv.hit52:                                         ; preds = %dv.join38
  call void @Dog.bark(ptr %p46)
  br label %dv.join51

dv.miss53:                                        ; preds = %dv.join38
  call void %fn50(ptr %p46)
  br label %dv.join51

dv.join60:                                        ; preds = %dv.miss65, %dv.hit64, %dv.hit61
  %dv.r67 = phi i32 [ %29, %dv.hit61 ], [ %30, %dv.hit64 ], [ %31, %dv.miss65 ]
  %27 = call i32 (ptr, ...) @printf(ptr @.str.6, i32 %dv.r67)
  %p68 = load ptr, ptr %p, align 8
  call void @__polaron_check_live(ptr %p68)
  %vtbl.addr69 = getelementptr inbounds %class.Poodle, ptr %p68, i32 0, i32 0
  %vtbl70 = load ptr, ptr %vtbl.addr69, align 8, !tbaa !0
  %dtor.slot = getelementptr [351 x ptr], ptr %vtbl70, i64 0, i64 350
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %28 = icmp ne ptr %dtor.fn, null
  br i1 %28, label %dtor.call, label %dtor.free

dv.hit61:                                         ; preds = %dv.join51
  %29 = call i32 @Dog.loudness(ptr %p55, i32 5)
  br label %dv.join60

dv.miss62:                                        ; preds = %dv.join51
  %dv.is66 = icmp eq ptr %fn59, @Poodle.loudness
  br i1 %dv.is66, label %dv.hit64, label %dv.miss65

dv.hit64:                                         ; preds = %dv.miss62
  %30 = call i32 @Poodle.loudness(ptr %p55, i32 5)
  br label %dv.join60

dv.miss65:                                        ; preds = %dv.miss62
  %31 = call i32 %fn59(ptr %p55, i32 5)
  br label %dv.join60

dtor.call:                                        ; preds = %dv.join60
  call void %dtor.fn(ptr %p68)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %dv.join60
  call void @__polaron_free(ptr %p68)
  %fido71 = load ptr, ptr %fido, align 8
  call void @__polaron_check_live(ptr %fido71)
  %vtbl.addr72 = getelementptr inbounds %class.Dog, ptr %fido71, i32 0, i32 0
  %vtbl73 = load ptr, ptr %vtbl.addr72, align 8, !tbaa !0
  %dtor.slot74 = getelementptr [351 x ptr], ptr %vtbl73, i64 0, i64 350
  %dtor.fn75 = load ptr, ptr %dtor.slot74, align 8
  %32 = icmp ne ptr %dtor.fn75, null
  br i1 %32, label %dtor.call76, label %dtor.free77

dtor.call76:                                      ; preds = %dtor.free
  call void %dtor.fn75(ptr %fido71)
  br label %dtor.free77

dtor.free77:                                      ; preds = %dtor.call76, %dtor.free
  call void @__polaron_free(ptr %fido71)
  %rex78 = load ptr, ptr %rex, align 8
  call void @__polaron_check_live(ptr %rex78)
  %vtbl.addr79 = getelementptr inbounds %class.Dog, ptr %rex78, i32 0, i32 0
  %vtbl80 = load ptr, ptr %vtbl.addr79, align 8, !tbaa !0
  %dtor.slot81 = getelementptr [351 x ptr], ptr %vtbl80, i64 0, i64 350
  %dtor.fn82 = load ptr, ptr %dtor.slot81, align 8
  %33 = icmp ne ptr %dtor.fn82, null
  br i1 %33, label %dtor.call83, label %dtor.free84

dtor.call83:                                      ; preds = %dtor.free77
  call void %dtor.fn82(ptr %rex78)
  br label %dtor.free84

dtor.free84:                                      ; preds = %dtor.call83, %dtor.free77
  call void @__polaron_free(ptr %rex78)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5315)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal void @Dog.bark.patch0.thunk(ptr %0) {
entry:
  %patch.clos = load ptr, ptr @Dog.bark.patch0.fn, align 8
  %patch.code = load ptr, ptr %patch.clos, align 8
  %patch.env.addr = getelementptr ptr, ptr %patch.clos, i64 1
  %patch.env = load ptr, ptr %patch.env.addr, align 8
  call void %patch.code(ptr %patch.env, ptr %0)
  ret void
}

define internal void @__polaron_lambda_0(ptr %0, ptr %1) {
entry:
  %Dog.copy = alloca %class.Dog, align 8
  %d = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Dog.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64))
  store ptr %Dog.copy, ptr %d, align 8
  %3 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr @.str.2)
  ret void
}

declare ptr @memcpy(ptr, ptr, i64)

define internal i32 @Dog.loudness.patch1.thunk(ptr %0, i32 %1) {
entry:
  %patch.clos = load ptr, ptr @Dog.loudness.patch1.fn, align 8
  %patch.code = load ptr, ptr %patch.clos, align 8
  %patch.env.addr = getelementptr ptr, ptr %patch.clos, i64 1
  %patch.env = load ptr, ptr %patch.env.addr, align 8
  %2 = call i32 %patch.code(ptr %patch.env, ptr %0, i32 %1)
  ret i32 %2
}

define internal i32 @__polaron_lambda_1(ptr %0, ptr %1, i32 %2) {
entry:
  %times = alloca i32, align 4
  %Dog.copy = alloca %class.Dog, align 8
  %d = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %Dog.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64))
  store ptr %Dog.copy, ptr %d, align 8
  store i32 %2, ptr %times, align 4
  %times1 = load i32, ptr %times, align 4
  %4 = add i32 100, %times1
  ret i32 %4
}

define internal i32 @Dog.loudness.patch2.thunk(ptr %0, i32 %1) {
entry:
  %patch.clos = load ptr, ptr @Dog.loudness.patch2.fn, align 8
  %patch.code = load ptr, ptr %patch.clos, align 8
  %patch.env.addr = getelementptr ptr, ptr %patch.clos, i64 1
  %patch.env = load ptr, ptr %patch.env.addr, align 8
  %2 = call i32 %patch.code(ptr %patch.env, ptr %0, i32 %1)
  ret i32 %2
}

define internal i32 @__polaron_lambda_2(ptr %0, ptr %1, i32 %2) {
entry:
  %times = alloca i32, align 4
  %Dog.copy = alloca %class.Dog, align 8
  %d = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %Dog.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64))
  store ptr %Dog.copy, ptr %d, align 8
  store i32 %2, ptr %times, align 4
  %4 = getelementptr ptr, ptr %0, i32 0
  %base = load ptr, ptr %4, align 8
  %base1 = load i32, ptr %base, align 4
  %times2 = load i32, ptr %times, align 4
  %5 = add i32 %base1, %times2
  ret i32 %5
}

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
