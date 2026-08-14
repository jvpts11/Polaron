; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/match_expr_block.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/match_expr_block.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Circle = type { ptr, i32 }
%class.Square = type { ptr, i32 }
%class.Shape = type { ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Square.vtable = private constant [350 x ptr] [ptr @Square.tag, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Circle.vtable = private constant [350 x ptr] [ptr @Circle.tag, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [6 x i8] c"a=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"b=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define internal void @Shape.Shape(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  ret void
}

define internal void @Circle.Circle(ptr %0, i32 %1) {
entry:
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  call void @Shape.Shape(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 0
  store ptr @Circle.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %r1 = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 1
  %r2 = load i32, ptr %r, align 4
  store i32 %r2, ptr %r1, align 4, !tbaa !4
  ret void
}

define internal i32 @Circle.tag(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret i32 1
}

define internal void @Square.Square(ptr %0, i32 %1) {
entry:
  %side = alloca i32, align 4
  store i32 %1, ptr %side, align 4
  call void @Shape.Shape(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 0
  store ptr @Square.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %side1 = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 1
  %side2 = load i32, ptr %side, align 4
  store i32 %side2, ptr %side1, align 4, !tbaa !4
  ret void
}

define internal i32 @Square.tag(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret i32 2
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca i32, align 4
  %q = alloca i32, align 4
  %matchx.arm31 = alloca i32, align 4
  %side30 = alloca i32, align 4
  %r24 = alloca i32, align 4
  %t = alloca ptr, align 8
  %a = alloca i32, align 4
  %side9 = alloca i32, align 4
  %p = alloca i32, align 4
  %matchx.arm = alloca i32, align 4
  %r2 = alloca i32, align 4
  %s = alloca ptr, align 8
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
  %Circle.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Circle, ptr null, i64 1) to i64))
  call void @Circle.Circle(ptr %Circle.obj, i32 3)
  store ptr %Circle.obj, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %vtbl.addr = getelementptr inbounds %class.Shape, ptr %s1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %is = icmp eq ptr %vtbl, @Circle.vtable
  br i1 %is, label %matchx.case, label %matchx.next

matchx.end:                                       ; preds = %matchx.case6, %matchx.arm.end
  %matchx = phi i32 [ %matchx.arm.val, %matchx.arm.end ], [ %22, %matchx.case6 ]
  store i32 %matchx, ptr %a, align 4
  %a12 = load i32, ptr %a, align 4
  %16 = call i32 (ptr, ...) @printf(ptr @.str, i32 %a12)
  %s13 = load ptr, ptr %s, align 8
  call void @__polaron_check_live(ptr %s13)
  %vtbl.addr14 = getelementptr inbounds %class.Shape, ptr %s13, i32 0, i32 0
  %vtbl15 = load ptr, ptr %vtbl.addr14, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl15, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %17 = icmp ne ptr %dtor.fn, null
  br i1 %17, label %dtor.call, label %dtor.free

matchx.case:                                      ; preds = %argv.end
  %18 = getelementptr inbounds %class.Circle, ptr %s1, i32 0, i32 1
  %r = load i32, ptr %18, align 4, !tbaa !4
  store i32 %r, ptr %r2, align 4
  store i32 0, ptr %matchx.arm, align 4
  %r3 = load i32, ptr %r2, align 4
  %r4 = load i32, ptr %r2, align 4
  %19 = mul i32 %r3, %r4
  store i32 %19, ptr %p, align 4
  %p5 = load i32, ptr %p, align 4
  %20 = mul i32 %p5, 3
  store i32 %20, ptr %matchx.arm, align 4
  br label %matchx.arm.end

matchx.next:                                      ; preds = %argv.end
  %is8 = icmp eq ptr %vtbl, @Square.vtable
  br i1 %is8, label %matchx.case6, label %matchx.next7

matchx.arm.end:                                   ; preds = %matchx.case
  %matchx.arm.val = load i32, ptr %matchx.arm, align 4
  br label %matchx.end

matchx.case6:                                     ; preds = %matchx.next
  %21 = getelementptr inbounds %class.Square, ptr %s1, i32 0, i32 1
  %side = load i32, ptr %21, align 4, !tbaa !4
  store i32 %side, ptr %side9, align 4
  %side10 = load i32, ptr %side9, align 4
  %side11 = load i32, ptr %side9, align 4
  %22 = mul i32 %side10, %side11
  br label %matchx.end

matchx.next7:                                     ; preds = %matchx.next
  unreachable

dtor.call:                                        ; preds = %matchx.end
  call void %dtor.fn(ptr %s13)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %matchx.end
  call void @__polaron_free(ptr %s13)
  %Square.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Square, ptr null, i64 1) to i64))
  call void @Square.Square(ptr %Square.obj, i32 5)
  store ptr %Square.obj, ptr %t, align 8
  %t16 = load ptr, ptr %t, align 8
  %vtbl.addr17 = getelementptr inbounds %class.Shape, ptr %t16, i32 0, i32 0
  %vtbl18 = load ptr, ptr %vtbl.addr17, align 8, !tbaa !0
  %is22 = icmp eq ptr %vtbl18, @Circle.vtable
  br i1 %is22, label %matchx.case20, label %matchx.next21

matchx.end19:                                     ; preds = %matchx.arm.end32, %matchx.case20
  %matchx37 = phi i32 [ %r25, %matchx.case20 ], [ %matchx.arm.val36, %matchx.arm.end32 ]
  store i32 %matchx37, ptr %b, align 4
  %b38 = load i32, ptr %b, align 4
  %23 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %b38)
  %t39 = load ptr, ptr %t, align 8
  call void @__polaron_check_live(ptr %t39)
  %vtbl.addr40 = getelementptr inbounds %class.Shape, ptr %t39, i32 0, i32 0
  %vtbl41 = load ptr, ptr %vtbl.addr40, align 8, !tbaa !0
  %dtor.slot42 = getelementptr [350 x ptr], ptr %vtbl41, i64 0, i64 349
  %dtor.fn43 = load ptr, ptr %dtor.slot42, align 8
  %24 = icmp ne ptr %dtor.fn43, null
  br i1 %24, label %dtor.call44, label %dtor.free45

matchx.case20:                                    ; preds = %dtor.free
  %25 = getelementptr inbounds %class.Circle, ptr %t16, i32 0, i32 1
  %r23 = load i32, ptr %25, align 4, !tbaa !4
  store i32 %r23, ptr %r24, align 4
  %r25 = load i32, ptr %r24, align 4
  br label %matchx.end19

matchx.next21:                                    ; preds = %dtor.free
  %is28 = icmp eq ptr %vtbl18, @Square.vtable
  br i1 %is28, label %matchx.case26, label %matchx.next27

matchx.case26:                                    ; preds = %matchx.next21
  %26 = getelementptr inbounds %class.Square, ptr %t16, i32 0, i32 1
  %side29 = load i32, ptr %26, align 4, !tbaa !4
  store i32 %side29, ptr %side30, align 4
  store i32 0, ptr %matchx.arm31, align 4
  %side33 = load i32, ptr %side30, align 4
  %27 = add i32 %side33, 1
  store i32 %27, ptr %q, align 4
  %q34 = load i32, ptr %q, align 4
  %q35 = load i32, ptr %q, align 4
  %28 = mul i32 %q34, %q35
  store i32 %28, ptr %matchx.arm31, align 4
  br label %matchx.arm.end32

matchx.next27:                                    ; preds = %matchx.next21
  unreachable

matchx.arm.end32:                                 ; preds = %matchx.case26
  %matchx.arm.val36 = load i32, ptr %matchx.arm31, align 4
  br label %matchx.end19

dtor.call44:                                      ; preds = %matchx.end19
  call void %dtor.fn43(ptr %t39)
  br label %dtor.free45

dtor.free45:                                      ; preds = %dtor.call44, %matchx.end19
  call void @__polaron_free(ptr %t39)
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
