; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Car = type { ptr, i32, ptr }
%persistblock.Car = type { i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Car.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array.pol:18:25  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@pkey = private unnamed_addr constant [10 x i8] c"main.cars\00", align 1
@.fail.1 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array.pol:19:25  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@pkey.4 = private unnamed_addr constant [10 x i8] c"main.cars\00", align 1
@.fail.5 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array.pol:20:32  in main\0A\00", align 1
@.faila.6 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.7 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.8 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array.pol:21:32  in main\0A\00", align 1
@.faila.9 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.10 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"c0=%d c1=%d\0A\00", align 1
@.fail.11 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array.pol:22:41  in main\0A\00", align 1
@.faila.12 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.13 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.14 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/persist_array.pol:22:41  in main\0A\00", align 1
@.faila.15 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.16 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }
@.strdata.5326 = private constant [1 x i8] zeroinitializer
@.strobj.5327 = private global %String { i64 0, ptr @.strdata.5326, i64 0 }

define internal void @Car.Car(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Car, ptr %0, i32 0, i32 0
  store ptr @Car.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %chassi = getelementptr inbounds %class.Car, ptr %0, i32 0, i32 1
  store i32 0, ptr %chassi, align 4, !tbaa !4
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %arr = call ptr @__polaron_malloc(i64 32)
  store i64 3, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 24)
  store ptr %arr, ptr %cars, align 8
  %cars2 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %cars2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %cars2, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data3, i64 0
  %Car.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Car, ptr null, i64 1) to i64))
  %__persist.slot = call ptr @__polaron_persist_slot(ptr @pkey, i64 0, i64 ptrtoint (ptr getelementptr (%persistblock.Car, ptr null, i64 1) to i64))
  %__persist = getelementptr inbounds %class.Car, ptr %Car.obj, i32 0, i32 2
  store ptr %__persist.slot, ptr %__persist, align 8, !tbaa !0
  call void @Car.Car(ptr %Car.obj)
  store ptr %Car.obj, ptr %arr.elem, align 8
  %cars4 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %arr.len5 = load i64, ptr %cars4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !8

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %cars4, i64 8
  %arr.elem10 = getelementptr inbounds ptr, ptr %arr.data9, i64 1
  %Car.obj11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Car, ptr null, i64 1) to i64))
  %__persist.slot12 = call ptr @__polaron_persist_slot(ptr @pkey.4, i64 1, i64 ptrtoint (ptr getelementptr (%persistblock.Car, ptr null, i64 1) to i64))
  %__persist13 = getelementptr inbounds %class.Car, ptr %Car.obj11, i32 0, i32 2
  store ptr %__persist.slot12, ptr %__persist13, align 8, !tbaa !0
  call void @Car.Car(ptr %Car.obj11)
  store ptr %Car.obj11, ptr %arr.elem10, align 8
  %cars14 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %arr.len15 = load i64, ptr %cars14, align 8
  %arr.oob16 = icmp uge i64 0, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !8

idx.bad17:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.5, ptr @.faila.6, i64 0, ptr @.failb.7, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok8
  %arr.data19 = getelementptr i8, ptr %cars14, i64 8
  %arr.elem20 = getelementptr inbounds ptr, ptr %arr.data19, i64 0
  %elem = load ptr, ptr %arr.elem20, align 8
  %__persist21 = getelementptr inbounds %class.Car, ptr %elem, i32 0, i32 2
  %pblock = load ptr, ptr %__persist21, align 8, !tbaa !0
  %chassi = getelementptr inbounds %persistblock.Car, ptr %pblock, i32 0, i32 0
  store i32 11, ptr %chassi, align 4
  %cars22 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %arr.len23 = load i64, ptr %cars22, align 8
  %arr.oob24 = icmp uge i64 1, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !8

idx.bad25:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.8, ptr @.faila.9, i64 1, ptr @.failb.10, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok18
  %arr.data27 = getelementptr i8, ptr %cars22, i64 8
  %arr.elem28 = getelementptr inbounds ptr, ptr %arr.data27, i64 1
  %elem29 = load ptr, ptr %arr.elem28, align 8
  %__persist30 = getelementptr inbounds %class.Car, ptr %elem29, i32 0, i32 2
  %pblock31 = load ptr, ptr %__persist30, align 8, !tbaa !0
  %chassi32 = getelementptr inbounds %persistblock.Car, ptr %pblock31, i32 0, i32 0
  store i32 22, ptr %chassi32, align 4
  %cars33 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %arr.len34 = load i64, ptr %cars33, align 8
  %arr.oob35 = icmp uge i64 0, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

idx.bad36:                                        ; preds = %idx.ok26
  call void @__polaron_fail(ptr @.fail.11, ptr @.faila.12, i64 0, ptr @.failb.13, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %idx.ok26
  %arr.data38 = getelementptr i8, ptr %cars33, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 0
  %elem40 = load ptr, ptr %arr.elem39, align 8
  %__persist41 = getelementptr inbounds %class.Car, ptr %elem40, i32 0, i32 2
  %pblock42 = load ptr, ptr %__persist41, align 8, !tbaa !0
  %chassi43 = getelementptr inbounds %persistblock.Car, ptr %pblock42, i32 0, i32 0
  %chassi44 = load i32, ptr %chassi43, align 4
  %cars45 = load ptr, ptr %cars, align 8, !nonnull !6, !dereferenceable !7
  %arr.len46 = load i64, ptr %cars45, align 8
  %arr.oob47 = icmp uge i64 1, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !8

idx.bad48:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.14, ptr @.faila.15, i64 1, ptr @.failb.16, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %idx.ok37
  %arr.data50 = getelementptr i8, ptr %cars45, i64 8
  %arr.elem51 = getelementptr inbounds ptr, ptr %arr.data50, i64 1
  %elem52 = load ptr, ptr %arr.elem51, align 8
  %__persist53 = getelementptr inbounds %class.Car, ptr %elem52, i32 0, i32 2
  %pblock54 = load ptr, ptr %__persist53, align 8, !tbaa !0
  %chassi55 = getelementptr inbounds %persistblock.Car, ptr %pblock54, i32 0, i32 0
  %chassi56 = load i32, ptr %chassi55, align 4
  %17 = call i32 (ptr, ...) @printf(ptr @.str, i32 %chassi44, i32 %chassi56)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5325)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5327)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @__polaron_persist_slot(ptr, i64, i64)

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
