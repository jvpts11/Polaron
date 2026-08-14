; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_members.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_members.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%ReflectType = type { ptr, i64, ptr, ptr, i64, ptr, i64, ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr }
%class.Dog = type { ptr, i32, i32 }
%class.Object = type { ptr }
%__box = type { ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Dog.vtable = private constant [351 x ptr] [ptr @Dog.bark, ptr @Dog.sit, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [351 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [4 x i8] c"Dog\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [5 x i8] c"bark\00"
@.strobj.2 = private global %String { i64 4, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [4 x i8] c"sit\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@methods.Dog = private constant [2 x ptr] [ptr @.strobj.2, ptr @.strobj.4]
@.strdata.5 = private constant [4 x i8] c"age\00"
@.strobj.6 = private global %String { i64 3, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [4 x i8] c"tag\00"
@.strobj.8 = private global %String { i64 3, ptr @.strdata.7, i64 0 }
@fields.Dog = private constant [2 x ptr] [ptr @.strobj.6, ptr @.strobj.8]
@annotations.Dog = private constant [0 x ptr] zeroinitializer
@methodfns.Dog = private constant [2 x ptr] [ptr @Dog.bark, ptr @Dog.sit]
@fieldget.Dog = private constant [2 x ptr] [ptr @__fget.Dog.age, ptr @__fget.Dog.tag]
@fieldset.Dog = private constant [2 x ptr] [ptr @__fset.Dog.age, ptr @__fset.Dog.tag]
@methodann.Dog.0 = private constant [0 x ptr] zeroinitializer
@methodann.Dog.1 = private constant [0 x ptr] zeroinitializer
@methodanncounts.Dog = private constant [2 x i64] zeroinitializer
@methodannptrs.Dog = private constant [2 x ptr] [ptr @methodann.Dog.0, ptr @methodann.Dog.1]
@methodrettags.Dog = private constant [2 x i64] zeroinitializer
@type.Dog = private constant %ReflectType { ptr @.strobj, i64 2, ptr @methods.Dog, ptr @methodfns.Dog, i64 2, ptr @fields.Dog, i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64), ptr @Dog.Dog, i64 0, ptr @annotations.Dog, ptr @fieldget.Dog, ptr @fieldset.Dog, ptr @methodanncounts.Dog, ptr @methodannptrs.Dog, ptr @methodrettags.Dog }
@.str = private unnamed_addr constant [22 x i8] c"methods=%d fields=%d\0A\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }

define internal void @Dog.Dog(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 0
  store ptr @Dog.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %age = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  store i32 0, ptr %age, align 4, !tbaa !4
  %tag = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 2
  store i32 120, ptr %tag, align 4, !tbaa !4
  ret void
}

define internal void @Dog.bark(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret void
}

define internal void @Dog.sit(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %i9 = alloca i32, align 4
  %i = alloca i32, align 4
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
  call void @Test.__onClassLoad()
  store ptr @type.Dog, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %16 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 1
  %cnt = load i64, ptr %16, align 8
  %17 = trunc i64 %cnt to i32
  %t2 = load ptr, ptr %t, align 8
  %18 = getelementptr inbounds %ReflectType, ptr %t2, i32 0, i32 4
  %cnt3 = load i64, ptr %18, align 8
  %19 = trunc i64 %cnt3 to i32
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %19)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i4 = load i32, ptr %i, align 4
  %t5 = load ptr, ptr %t, align 8
  %21 = getelementptr inbounds %ReflectType, ptr %t5, i32 0, i32 1
  %cnt6 = load i64, ptr %21, align 8
  %22 = trunc i64 %cnt6 to i32
  %23 = icmp slt i32 %i4, %22
  %24 = zext i1 %23 to i32
  br i1 %23, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %t7 = load ptr, ptr %t, align 8
  %25 = getelementptr inbounds %ReflectType, ptr %t7, i32 0, i32 2
  %arr = load ptr, ptr %25, align 8
  %i8 = load i32, ptr %i, align 4
  %26 = sext i32 %i8 to i64
  %slot = getelementptr ptr, ptr %arr, i64 %26
  %elem = load ptr, ptr %slot, align 8
  %str.data = getelementptr inbounds %String, ptr %elem, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %27 = call i32 (ptr, ...) @printf(ptr @.str.9, ptr %data)
  br label %for.update

for.update:                                       ; preds = %for.body
  %28 = load i32, ptr %i, align 4
  %29 = add i32 %28, 1
  store i32 %29, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %i9, align 4
  br label %for.cond10

for.cond10:                                       ; preds = %for.update12, %for.end
  %i14 = load i32, ptr %i9, align 4
  %t15 = load ptr, ptr %t, align 8
  %30 = getelementptr inbounds %ReflectType, ptr %t15, i32 0, i32 4
  %cnt16 = load i64, ptr %30, align 8
  %31 = trunc i64 %cnt16 to i32
  %32 = icmp slt i32 %i14, %31
  %33 = zext i1 %32 to i32
  br i1 %32, label %for.body11, label %for.end13

for.body11:                                       ; preds = %for.cond10
  %t17 = load ptr, ptr %t, align 8
  %34 = getelementptr inbounds %ReflectType, ptr %t17, i32 0, i32 5
  %arr18 = load ptr, ptr %34, align 8
  %i19 = load i32, ptr %i9, align 4
  %35 = sext i32 %i19 to i64
  %slot20 = getelementptr ptr, ptr %arr18, i64 %35
  %elem21 = load ptr, ptr %slot20, align 8
  %str.data22 = getelementptr inbounds %String, ptr %elem21, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %36 = call i32 (ptr, ...) @printf(ptr @.str.10, ptr %data23)
  br label %for.update12

for.update12:                                     ; preds = %for.body11
  %37 = load i32, ptr %i9, align 4
  %38 = add i32 %37, 1
  store i32 %38, ptr %i9, align 4
  br label %for.cond10

for.end13:                                        ; preds = %for.cond10
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5320)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define private ptr @__fget.Dog.age(ptr %0) {
entry:
  %f.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %f.val = load i32, ptr %f.addr, align 4, !tbaa !4
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %1, align 8
  %2 = sext i32 %f.val to i64
  %3 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %2, ptr %3, align 8
  ret ptr %box
}

define private void @__fset.Dog.age(ptr %0, ptr %1) {
entry:
  %f.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %2 = getelementptr inbounds %__box, ptr %1, i32 0, i32 1
  %unbox = load i64, ptr %2, align 8
  %3 = trunc i64 %unbox to i32
  store i32 %3, ptr %f.addr, align 4, !tbaa !4
  ret void
}

define private ptr @__fget.Dog.tag(ptr %0) {
entry:
  %f.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 2
  %f.val = load i32, ptr %f.addr, align 4, !tbaa !4
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %1, align 8
  %2 = sext i32 %f.val to i64
  %3 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %2, ptr %3, align 8
  ret ptr %box
}

define private void @__fset.Dog.tag(ptr %0, ptr %1) {
entry:
  %f.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 2
  %2 = getelementptr inbounds %__box, ptr %1, i32 0, i32 1
  %unbox = load i64, ptr %2, align 8
  %3 = trunc i64 %unbox to i32
  store i32 %3, ptr %f.addr, align 4, !tbaa !4
  ret void
}

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
