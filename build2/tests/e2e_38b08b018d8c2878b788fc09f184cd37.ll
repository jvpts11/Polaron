; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/lambdas.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/lambdas.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Animal = type { ptr }
%class.Cat = type { ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Animal.vtable = private constant [350 x ptr] [ptr @Animal.speak, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Cat.vtable = private constant [350 x ptr] [ptr @Cat.speak, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_1, ptr null]
@.str = private unnamed_addr constant [37 x i8] c"a=%d b=%d counter=%d c=%d d=%d e=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define internal void @Animal.Animal(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Animal, ptr %0, i32 0, i32 0
  store ptr @Animal.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal i32 @Animal.speak(ptr nonnull align 8 dereferenceable(8) %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  ret i32 %n1
}

define internal void @Cat.Cat(ptr %0) {
entry:
  call void @Animal.Animal(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Cat, ptr %0, i32 0, i32 0
  store ptr @Cat.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal i32 @Cat.speak(ptr nonnull align 8 dereferenceable(8) %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %2 = mul i32 %n1, 100
  ret i32 %2
}

define internal i32 @Main.twice(ptr %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  %f = alloca ptr, align 8
  store ptr %0, ptr %f, align 8
  store i32 %1, ptr %v, align 4
  %f1 = load ptr, ptr %f, align 8
  %code = load ptr, ptr %f1, align 8
  %2 = getelementptr ptr, ptr %f1, i32 1
  %env = load ptr, ptr %2, align 8
  %f2 = load ptr, ptr %f, align 8
  %code3 = load ptr, ptr %f2, align 8
  %3 = getelementptr ptr, ptr %f2, i32 1
  %env4 = load ptr, ptr %3, align 8
  %v5 = load i32, ptr %v, align 4
  %4 = call i32 %code3(ptr %env4, i32 %v5)
  %5 = call i32 %code(ptr %env, i32 %4)
  ret i32 %5
}

define internal ptr @Main.adder(i32 %0) {
entry:
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %env = call ptr @__polaron_malloc(i64 8)
  %1 = getelementptr ptr, ptr %env, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %2 = load i32, ptr %n, align 4
  store i32 %2, ptr %cap, align 4
  store ptr %cap, ptr %1, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_0, ptr %closure, align 8
  %3 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env, ptr %3, align 8
  ret ptr %closure
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %e = alloca i32, align 4
  %sp = alloca ptr, align 8
  %cat = alloca ptr, align 8
  %d = alloca i32, align 4
  %add10 = alloca ptr, align 8
  %c = alloca i32, align 4
  %inc = alloca ptr, align 8
  %counter = alloca i32, align 4
  %b = alloca i32, align 4
  %addBase = alloca ptr, align 8
  %base = alloca i32, align 4
  %a = alloca i32, align 4
  %dbl = alloca ptr, align 8
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
  store ptr @__polaron_closure, ptr %dbl, align 8
  %dbl1 = load ptr, ptr %dbl, align 8
  %code = load ptr, ptr %dbl1, align 8
  %16 = getelementptr ptr, ptr %dbl1, i32 1
  %env = load ptr, ptr %16, align 8
  %17 = call i32 %code(ptr %env, i32 5)
  store i32 %17, ptr %a, align 4
  store i32 100, ptr %base, align 4
  %env2 = call ptr @__polaron_malloc(i64 8)
  %18 = getelementptr ptr, ptr %env2, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %19 = load i32, ptr %base, align 4
  store i32 %19, ptr %cap, align 4
  store ptr %cap, ptr %18, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_2, ptr %closure, align 8
  %20 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env2, ptr %20, align 8
  store ptr %closure, ptr %addBase, align 8
  %addBase3 = load ptr, ptr %addBase, align 8
  %code4 = load ptr, ptr %addBase3, align 8
  %21 = getelementptr ptr, ptr %addBase3, i32 1
  %env5 = load ptr, ptr %21, align 8
  %22 = call i32 %code4(ptr %env5, i32 7)
  store i32 %22, ptr %b, align 4
  store i32 0, ptr %counter, align 4
  %env6 = call ptr @__polaron_malloc(i64 8)
  %23 = getelementptr ptr, ptr %env6, i32 0
  store ptr %counter, ptr %23, align 8
  %closure7 = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_3, ptr %closure7, align 8
  %24 = getelementptr ptr, ptr %closure7, i32 1
  store ptr %env6, ptr %24, align 8
  store ptr %closure7, ptr %inc, align 8
  %inc8 = load ptr, ptr %inc, align 8
  %code9 = load ptr, ptr %inc8, align 8
  %25 = getelementptr ptr, ptr %inc8, i32 1
  %env10 = load ptr, ptr %25, align 8
  call void %code9(ptr %env10)
  %inc11 = load ptr, ptr %inc, align 8
  %code12 = load ptr, ptr %inc11, align 8
  %26 = getelementptr ptr, ptr %inc11, i32 1
  %env13 = load ptr, ptr %26, align 8
  call void %code12(ptr %env13)
  %inc14 = load ptr, ptr %inc, align 8
  %code15 = load ptr, ptr %inc14, align 8
  %27 = getelementptr ptr, ptr %inc14, i32 1
  %env16 = load ptr, ptr %27, align 8
  call void %code15(ptr %env16)
  %dbl17 = load ptr, ptr %dbl, align 8
  %28 = call i32 @Main.twice(ptr %dbl17, i32 3)
  store i32 %28, ptr %c, align 4
  %29 = call ptr @Main.adder(i32 10)
  store ptr %29, ptr %add10, align 8
  %add1018 = load ptr, ptr %add10, align 8
  %code19 = load ptr, ptr %add1018, align 8
  %30 = getelementptr ptr, ptr %add1018, i32 1
  %env20 = load ptr, ptr %30, align 8
  %31 = call i32 %code19(ptr %env20, i32 5)
  store i32 %31, ptr %d, align 4
  %Cat.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Cat, ptr null, i64 1) to i64))
  call void @Cat.Cat(ptr %Cat.obj)
  store ptr %Cat.obj, ptr %cat, align 8
  %cat21 = load ptr, ptr %cat, align 8
  %mr.env = call ptr @__polaron_malloc(i64 8)
  store ptr %cat21, ptr %mr.env, align 8
  %mr.closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_methodref_4, ptr %mr.closure, align 8
  %32 = getelementptr ptr, ptr %mr.closure, i32 1
  store ptr %mr.env, ptr %32, align 8
  store ptr %mr.closure, ptr %sp, align 8
  %sp22 = load ptr, ptr %sp, align 8
  %code23 = load ptr, ptr %sp22, align 8
  %33 = getelementptr ptr, ptr %sp22, i32 1
  %env24 = load ptr, ptr %33, align 8
  %34 = call i32 %code23(ptr %env24, i32 4)
  store i32 %34, ptr %e, align 4
  %a25 = load i32, ptr %a, align 4
  %b26 = load i32, ptr %b, align 4
  %counter27 = load i32, ptr %counter, align 4
  %c28 = load i32, ptr %c, align 4
  %d29 = load i32, ptr %d, align 4
  %e30 = load i32, ptr %e, align 4
  %35 = call i32 (ptr, ...) @printf(ptr @.str, i32 %a25, i32 %b26, i32 %counter27, i32 %c28, i32 %d29, i32 %e30)
  %cat31 = load ptr, ptr %cat, align 8
  call void @__polaron_check_live(ptr %cat31)
  %vtbl.addr = getelementptr inbounds %class.Animal, ptr %cat31, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %36 = icmp ne ptr %dtor.fn, null
  br i1 %36, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %argv.end
  call void %dtor.fn(ptr %cat31)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %argv.end
  call void @__polaron_free(ptr %cat31)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5307)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

define internal i32 @__polaron_lambda_0(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %2 = getelementptr ptr, ptr %0, i32 0
  %n = load ptr, ptr %2, align 8
  %x1 = load i32, ptr %x, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = add i32 %x1, %n2
  ret i32 %3
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal i32 @__polaron_lambda_1(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %2 = mul i32 %x1, 2
  ret i32 %2
}

define internal i32 @__polaron_lambda_2(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %2 = getelementptr ptr, ptr %0, i32 0
  %base = load ptr, ptr %2, align 8
  %x1 = load i32, ptr %x, align 4
  %base2 = load i32, ptr %base, align 4
  %3 = add i32 %x1, %base2
  ret i32 %3
}

define internal void @__polaron_lambda_3(ptr %0) {
entry:
  %1 = getelementptr ptr, ptr %0, i32 0
  %counter = load ptr, ptr %1, align 8
  %counter1 = load i32, ptr %counter, align 4
  %2 = add i32 %counter1, 1
  store i32 %2, ptr %counter, align 4
  ret void
}

define internal i32 @__polaron_methodref_4(ptr %0, i32 %1) {
entry:
  %recv = load ptr, ptr %0, align 8
  %vtbl.addr = getelementptr inbounds %class.Animal, ptr %recv, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 0
  %fn = load ptr, ptr %slot, align 8
  %2 = call i32 %fn(ptr %recv, i32 %1)
  ret i32 %2
}

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
