; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array_reattach.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array_reattach.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Car = type { ptr, i32, i32, ptr }
%persistblock.Car = type { i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Car.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [147 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array_reattach.pol:21:25  in Main.cycle\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@pkey = private unnamed_addr constant [16 x i8] c"Main.cycle.cars\00", align 1
@.fail.1 = private unnamed_addr constant [147 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array_reattach.pol:22:17  in Main.cycle\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [147 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array_reattach.pol:23:32  in Main.cycle\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [147 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array_reattach.pol:23:32  in Main.cycle\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [147 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array_reattach.pol:24:17  in Main.cycle\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"%d %d %d %d\0A\00", align 1
@.strdata.5320 = private constant [1 x i8] zeroinitializer
@.strobj.5321 = private global %String { i64 0, ptr @.strdata.5320, i64 0 }
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }

define internal void @Car.Car(ptr %0, i32 %1, i32 %2) {
entry:
  %motor = alloca i32, align 4
  %serial = alloca i32, align 4
  store i32 %1, ptr %serial, align 4
  store i32 %2, ptr %motor, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Car, ptr %0, i32 0, i32 0
  store ptr @Car.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %serial1 = getelementptr inbounds %class.Car, ptr %0, i32 0, i32 1
  store i32 0, ptr %serial1, align 4, !tbaa !4
  %__persist = getelementptr inbounds %class.Car, ptr %0, i32 0, i32 3
  %pblock = load ptr, ptr %__persist, align 8, !tbaa !0
  %serial2 = getelementptr inbounds %persistblock.Car, ptr %pblock, i32 0, i32 0
  %serial3 = load i32, ptr %serial, align 4
  store i32 %serial3, ptr %serial2, align 4
  %motor4 = getelementptr inbounds %class.Car, ptr %0, i32 0, i32 2
  %motor5 = load i32, ptr %motor, align 4
  store i32 %motor5, ptr %motor4, align 4, !tbaa !4
  ret void
}

define internal i32 @Main.cycle(ptr %0, i32 %1) {
entry:
  %s = alloca i32, align 4
  %i = alloca i32, align 4
  %cars = alloca ptr, align 8
  store ptr %0, ptr %cars, align 8
  store i32 %1, ptr %i, align 4
  %i1 = load i32, ptr %i, align 4
  %cars2 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %i3 = load i32, ptr %i, align 4
  %2 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %cars2, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %2, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %cars2, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %2
  %Car.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Car, ptr null, i64 1) to i64))
  %pidx = sext i32 %i1 to i64
  %__persist.slot = call ptr @__polaron_persist_slot(ptr @pkey, i64 %pidx, i64 ptrtoint (ptr getelementptr (%persistblock.Car, ptr null, i64 1) to i64))
  %__persist = getelementptr inbounds %class.Car, ptr %Car.obj, i32 0, i32 3
  store ptr %__persist.slot, ptr %__persist, align 8, !tbaa !0
  %serial = getelementptr inbounds %persistblock.Car, ptr %__persist.slot, i32 0, i32 0
  %serial4 = load i32, ptr %serial, align 4
  call void @Car.Car(ptr %Car.obj, i32 %serial4, i32 7)
  store ptr %Car.obj, ptr %arr.elem, align 8
  %cars5 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %i6 = load i32, ptr %i, align 4
  %3 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %cars5, align 8
  %arr.oob8 = icmp uge i64 %3, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !8

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %3, ptr @.failb.3, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %cars5, i64 8
  %arr.elem12 = getelementptr inbounds ptr, ptr %arr.data11, i64 %3
  %elem = load ptr, ptr %arr.elem12, align 8
  %__persist13 = getelementptr inbounds %class.Car, ptr %elem, i32 0, i32 3
  %pblock = load ptr, ptr %__persist13, align 8, !tbaa !0
  %serial14 = getelementptr inbounds %persistblock.Car, ptr %pblock, i32 0, i32 0
  %serial15 = load i32, ptr %serial14, align 4
  store i32 %serial15, ptr %s, align 4
  %cars16 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %4 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %cars16, align 8
  %arr.oob19 = icmp uge i64 %4, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad20:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 %4, ptr @.failb.6, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %idx.ok10
  %arr.data22 = getelementptr i8, ptr %cars16, i64 8
  %arr.elem23 = getelementptr inbounds ptr, ptr %arr.data22, i64 %4
  %elem24 = load ptr, ptr %arr.elem23, align 8
  %__persist25 = getelementptr inbounds %class.Car, ptr %elem24, i32 0, i32 3
  %pblock26 = load ptr, ptr %__persist25, align 8, !tbaa !0
  %serial27 = getelementptr inbounds %persistblock.Car, ptr %pblock26, i32 0, i32 0
  %cars28 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %5 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %cars28, align 8
  %arr.oob31 = icmp uge i64 %5, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

idx.bad32:                                        ; preds = %idx.ok21
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 %5, ptr @.failb.9, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %idx.ok21
  %arr.data34 = getelementptr i8, ptr %cars28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %5
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %__persist37 = getelementptr inbounds %class.Car, ptr %elem36, i32 0, i32 3
  %pblock38 = load ptr, ptr %__persist37, align 8, !tbaa !0
  %serial39 = getelementptr inbounds %persistblock.Car, ptr %pblock38, i32 0, i32 0
  %serial40 = load i32, ptr %serial39, align 4
  %6 = add i32 %serial40, 1
  store i32 %6, ptr %serial27, align 4
  %cars41 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %i42 = load i32, ptr %i, align 4
  %7 = sext i32 %i42 to i64
  %arr.len43 = load i64, ptr %cars41, align 8
  %arr.oob44 = icmp uge i64 %7, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !8

idx.bad45:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 %7, ptr @.failb.12, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok33
  %arr.data47 = getelementptr i8, ptr %cars41, i64 8
  %arr.elem48 = getelementptr inbounds ptr, ptr %arr.data47, i64 %7
  %elem49 = load ptr, ptr %arr.elem48, align 8
  call void @__polaron_check_live(ptr %elem49)
  %vtbl.addr = getelementptr inbounds %class.Car, ptr %elem49, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %8 = icmp ne ptr %dtor.fn, null
  br i1 %8, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %idx.ok46
  call void %dtor.fn(ptr %elem49)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %idx.ok46
  call void @__polaron_free(ptr %elem49)
  %s50 = load i32, ptr %s, align 4
  ret i32 %s50
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %d = alloca i32, align 4
  %c = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %cars = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 16)
  store ptr %arr, ptr %cars, align 8
  %cars2 = load ptr, ptr %cars, align 8
  %17 = call i32 @Main.cycle(ptr %cars2, i32 0)
  store i32 %17, ptr %a, align 4
  %cars3 = load ptr, ptr %cars, align 8
  %18 = call i32 @Main.cycle(ptr %cars3, i32 0)
  store i32 %18, ptr %b, align 4
  %cars4 = load ptr, ptr %cars, align 8
  %19 = call i32 @Main.cycle(ptr %cars4, i32 1)
  store i32 %19, ptr %c, align 4
  %cars5 = load ptr, ptr %cars, align 8
  %20 = call i32 @Main.cycle(ptr %cars5, i32 0)
  store i32 %20, ptr %d, align 4
  %a6 = load i32, ptr %a, align 4
  %b7 = load i32, ptr %b, align 4
  %c8 = load i32, ptr %c, align 4
  %d9 = load i32, ptr %d, align 4
  %21 = call i32 (ptr, ...) @printf(ptr @.str, i32 %a6, i32 %b7, i32 %c8, i32 %d9)
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

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare noalias ptr @__polaron_malloc(i64)

declare ptr @__polaron_persist_slot(ptr, i64, i64)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

declare i32 @printf(ptr, ...)

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
