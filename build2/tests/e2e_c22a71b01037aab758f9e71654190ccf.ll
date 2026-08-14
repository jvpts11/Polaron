; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/pointer_arith.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/pointer_arith.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Dog = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Dog.vtable = private constant [350 x ptr] [ptr @Dog.age, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/pointer_arith.pol:33:27  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/pointer_arith.pol:38:17  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"p1=%d\0A\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"p3=%d\0A\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"p2=%d\0A\00", align 1
@.fail.6 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/pointer_arith.pol:47:17  in main\0A\00", align 1
@.faila.7 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.8 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.9 = private unnamed_addr constant [8 x i8] c"gap=%d\0A\00", align 1
@.fail.10 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/pointer_arith.pol:52:17  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"q=%d\0A\00", align 1
@.str.14 = private unnamed_addr constant [8 x i8] c"age=%d\0A\00", align 1
@.str.15 = private unnamed_addr constant [9 x i8] c"back=%d\0A\00", align 1
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }
@.strdata.5325 = private constant [1 x i8] zeroinitializer
@.strobj.5326 = private global %String { i64 0, ptr @.strdata.5325, i64 0 }

define internal void @Dog.Dog(ptr %0, i32 %1) {
entry:
  %age = alloca i32, align 4
  store i32 %1, ptr %age, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 0
  store ptr @Dog.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %age1 = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %age2 = load i32, ptr %age, align 4
  store i32 %age2, ptr %age1, align 4, !tbaa !4
  ret void
}

define internal i32 @Dog.age(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %age = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %age1 = load i32, ptr %age, align 4, !tbaa !4
  ret i32 %age1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %dp = alloca ptr, align 8
  %rex = alloca ptr, align 8
  %q = alloca ptr, align 8
  %gap = alloca i64, align 8
  %first = alloca ptr, align 8
  %p = alloca ptr, align 8
  %i = alloca i32, align 4
  %xs = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 28)
  store i64 5, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 20)
  store ptr %arr, ptr %xs, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok, %argv.end
  %i2 = load i32, ptr %i, align 4
  %17 = icmp slt i32 %i2, 5
  %18 = zext i1 %17 to i32
  br i1 %17, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %xs3 = load ptr, ptr %xs, align 8, !nonnull !6, !dereferenceable !7
  %i4 = load i32, ptr %i, align 4
  %19 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %xs3, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.end:                                        ; preds = %while.cond
  %xs8 = load ptr, ptr %xs, align 8, !nonnull !6, !dereferenceable !7
  %arr.len9 = load i64, ptr %xs8, align 8
  %arr.oob10 = icmp uge i64 0, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !8

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %19, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data5 = getelementptr i8, ptr %xs3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data5, i64 %19
  %i6 = load i32, ptr %i, align 4
  %20 = mul i32 %i6, 10
  store i32 %20, ptr %arr.elem, align 4
  %i7 = load i32, ptr %i, align 4
  %21 = add i32 %i7, 1
  store i32 %21, ptr %i, align 4
  br label %while.cond

idx.bad11:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 0, ptr @.failb.3, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %while.end
  %arr.data13 = getelementptr i8, ptr %xs8, i64 8
  %arr.elem14 = getelementptr inbounds i32, ptr %arr.data13, i64 0
  store ptr %arr.elem14, ptr %p, align 8
  %22 = load ptr, ptr %p, align 8
  %ptr.step = getelementptr i32, ptr %22, i64 1
  store ptr %ptr.step, ptr %p, align 8
  %p15 = load ptr, ptr %p, align 8
  %ptr.elem = getelementptr i32, ptr %p15, i64 0
  %elem = load i32, ptr %ptr.elem, align 1
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %elem)
  %p16 = load ptr, ptr %p, align 8
  %ptr.off = getelementptr i32, ptr %p16, i64 2
  store ptr %ptr.off, ptr %p, align 8
  %p17 = load ptr, ptr %p, align 8
  %ptr.elem18 = getelementptr i32, ptr %p17, i64 0
  %elem19 = load i32, ptr %ptr.elem18, align 1
  %24 = call i32 (ptr, ...) @printf(ptr @.str.4, i32 %elem19)
  %25 = load ptr, ptr %p, align 8
  %ptr.step20 = getelementptr i32, ptr %25, i64 -1
  store ptr %ptr.step20, ptr %p, align 8
  %p21 = load ptr, ptr %p, align 8
  %ptr.elem22 = getelementptr i32, ptr %p21, i64 0
  %elem23 = load i32, ptr %ptr.elem22, align 1
  %26 = call i32 (ptr, ...) @printf(ptr @.str.5, i32 %elem23)
  %xs24 = load ptr, ptr %xs, align 8, !nonnull !6, !dereferenceable !7
  %arr.len25 = load i64, ptr %xs24, align 8
  %arr.oob26 = icmp uge i64 0, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok12
  call void @__polaron_fail(ptr @.fail.6, ptr @.faila.7, i64 0, ptr @.failb.8, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok12
  %arr.data29 = getelementptr i8, ptr %xs24, i64 8
  %arr.elem30 = getelementptr inbounds i32, ptr %arr.data29, i64 0
  store ptr %arr.elem30, ptr %first, align 8
  %p31 = load ptr, ptr %p, align 8
  %first32 = load ptr, ptr %first, align 8
  %27 = ptrtoint ptr %p31 to i64
  %28 = ptrtoint ptr %first32 to i64
  %ptr.diff.bytes = sub i64 %27, %28
  %ptr.diff = sdiv i64 %ptr.diff.bytes, ptrtoint (ptr getelementptr (i32, ptr null, i64 1) to i64)
  store i64 %ptr.diff, ptr %gap, align 8
  %gap33 = load i64, ptr %gap, align 8
  %29 = trunc i64 %gap33 to i32
  %30 = call i32 (ptr, ...) @printf(ptr @.str.9, i32 %29)
  %xs34 = load ptr, ptr %xs, align 8, !nonnull !6, !dereferenceable !7
  %arr.len35 = load i64, ptr %xs34, align 8
  %arr.oob36 = icmp uge i64 4, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !8

idx.bad37:                                        ; preds = %idx.ok28
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %idx.ok28
  %arr.data39 = getelementptr i8, ptr %xs34, i64 8
  %arr.elem40 = getelementptr inbounds i32, ptr %arr.data39, i64 4
  store ptr %arr.elem40, ptr %q, align 8
  %q41 = load ptr, ptr %q, align 8
  %ptr.off42 = getelementptr i32, ptr %q41, i64 -3
  store ptr %ptr.off42, ptr %q, align 8
  %q43 = load ptr, ptr %q, align 8
  %ptr.elem44 = getelementptr i32, ptr %q43, i64 0
  %elem45 = load i32, ptr %ptr.elem44, align 1
  %31 = call i32 (ptr, ...) @printf(ptr @.str.13, i32 %elem45)
  %Dog.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64))
  call void @Dog.Dog(ptr %Dog.obj, i32 7)
  store ptr %Dog.obj, ptr %rex, align 8
  %rex46 = load ptr, ptr %rex, align 8
  store ptr %rex46, ptr %dp, align 8
  %dp47 = load ptr, ptr %dp, align 8
  %32 = call i32 @Dog.age(ptr %dp47)
  %33 = call i32 (ptr, ...) @printf(ptr @.str.14, i32 %32)
  %34 = load ptr, ptr %dp, align 8
  %ptr.step48 = getelementptr ptr, ptr %34, i64 1
  store ptr %ptr.step48, ptr %dp, align 8
  %35 = load ptr, ptr %dp, align 8
  %ptr.step49 = getelementptr ptr, ptr %35, i64 -1
  store ptr %ptr.step49, ptr %dp, align 8
  %dp50 = load ptr, ptr %dp, align 8
  %36 = call i32 @Dog.age(ptr %dp50)
  %37 = call i32 (ptr, ...) @printf(ptr @.str.15, i32 %36)
  %rex51 = load ptr, ptr %rex, align 8
  call void @__polaron_check_live(ptr %rex51)
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %rex51, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %38 = icmp ne ptr %dtor.fn, null
  br i1 %38, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %idx.ok38
  call void %dtor.fn(ptr %rex51)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %idx.ok38
  call void @__polaron_free(ptr %rex51)
  %xs52 = load ptr, ptr %xs, align 8
  call void @__polaron_free(ptr %xs52)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5324)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5326)
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

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

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
