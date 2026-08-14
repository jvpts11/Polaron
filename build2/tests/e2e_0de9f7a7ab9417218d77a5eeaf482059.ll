; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/match_expr.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/match_expr.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Circle = type { ptr, i32 }
%class.Square = type { ptr, i32 }
%class.Shape = type { ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Square.vtable = private constant [350 x ptr] [ptr @Square.area, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Circle.vtable = private constant [350 x ptr] [ptr @Circle.area, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [11 x i8] c"area = %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"area = %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"d = %d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

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

define internal i32 @Circle.area(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %r = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 1
  %r1 = load i32, ptr %r, align 4, !tbaa !4
  %r2 = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 1
  %r3 = load i32, ptr %r2, align 4, !tbaa !4
  %1 = mul i32 %r1, %r3
  %2 = mul i32 %1, 3
  ret i32 %2
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

define internal i32 @Square.area(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %side = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 1
  %side1 = load i32, ptr %side, align 4, !tbaa !4
  %side2 = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 1
  %side3 = load i32, ptr %side2, align 4, !tbaa !4
  %1 = mul i32 %side1, %side3
  ret i32 %1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %d = alloca i32, align 4
  %r51 = alloca i32, align 4
  %u = alloca ptr, align 8
  %b = alloca i32, align 4
  %side30 = alloca i32, align 4
  %r23 = alloca i32, align 4
  %t = alloca ptr, align 8
  %a = alloca i32, align 4
  %side8 = alloca i32, align 4
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

matchx.end:                                       ; preds = %matchx.case5, %matchx.case
  %matchx = phi i32 [ %20, %matchx.case ], [ %22, %matchx.case5 ]
  store i32 %matchx, ptr %a, align 4
  %a11 = load i32, ptr %a, align 4
  %16 = call i32 (ptr, ...) @printf(ptr @.str, i32 %a11)
  %s12 = load ptr, ptr %s, align 8
  call void @__polaron_check_live(ptr %s12)
  %vtbl.addr13 = getelementptr inbounds %class.Shape, ptr %s12, i32 0, i32 0
  %vtbl14 = load ptr, ptr %vtbl.addr13, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl14, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %17 = icmp ne ptr %dtor.fn, null
  br i1 %17, label %dtor.call, label %dtor.free

matchx.case:                                      ; preds = %argv.end
  %18 = getelementptr inbounds %class.Circle, ptr %s1, i32 0, i32 1
  %r = load i32, ptr %18, align 4, !tbaa !4
  store i32 %r, ptr %r2, align 4
  %r3 = load i32, ptr %r2, align 4
  %r4 = load i32, ptr %r2, align 4
  %19 = mul i32 %r3, %r4
  %20 = mul i32 %19, 3
  br label %matchx.end

matchx.next:                                      ; preds = %argv.end
  %is7 = icmp eq ptr %vtbl, @Square.vtable
  br i1 %is7, label %matchx.case5, label %matchx.next6

matchx.case5:                                     ; preds = %matchx.next
  %21 = getelementptr inbounds %class.Square, ptr %s1, i32 0, i32 1
  %side = load i32, ptr %21, align 4, !tbaa !4
  store i32 %side, ptr %side8, align 4
  %side9 = load i32, ptr %side8, align 4
  %side10 = load i32, ptr %side8, align 4
  %22 = mul i32 %side9, %side10
  br label %matchx.end

matchx.next6:                                     ; preds = %matchx.next
  unreachable

dtor.call:                                        ; preds = %matchx.end
  call void %dtor.fn(ptr %s12)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %matchx.end
  call void @__polaron_free(ptr %s12)
  %Square.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Square, ptr null, i64 1) to i64))
  call void @Square.Square(ptr %Square.obj, i32 5)
  store ptr %Square.obj, ptr %t, align 8
  %t15 = load ptr, ptr %t, align 8
  %vtbl.addr16 = getelementptr inbounds %class.Shape, ptr %t15, i32 0, i32 0
  %vtbl17 = load ptr, ptr %vtbl.addr16, align 8, !tbaa !0
  %is21 = icmp eq ptr %vtbl17, @Circle.vtable
  br i1 %is21, label %matchx.case19, label %matchx.next20

matchx.end18:                                     ; preds = %matchx.case26, %matchx.case19
  %matchx33 = phi i32 [ %27, %matchx.case19 ], [ %29, %matchx.case26 ]
  store i32 %matchx33, ptr %b, align 4
  %b34 = load i32, ptr %b, align 4
  %23 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %b34)
  %t35 = load ptr, ptr %t, align 8
  call void @__polaron_check_live(ptr %t35)
  %vtbl.addr36 = getelementptr inbounds %class.Shape, ptr %t35, i32 0, i32 0
  %vtbl37 = load ptr, ptr %vtbl.addr36, align 8, !tbaa !0
  %dtor.slot38 = getelementptr [350 x ptr], ptr %vtbl37, i64 0, i64 349
  %dtor.fn39 = load ptr, ptr %dtor.slot38, align 8
  %24 = icmp ne ptr %dtor.fn39, null
  br i1 %24, label %dtor.call40, label %dtor.free41

matchx.case19:                                    ; preds = %dtor.free
  %25 = getelementptr inbounds %class.Circle, ptr %t15, i32 0, i32 1
  %r22 = load i32, ptr %25, align 4, !tbaa !4
  store i32 %r22, ptr %r23, align 4
  %r24 = load i32, ptr %r23, align 4
  %r25 = load i32, ptr %r23, align 4
  %26 = mul i32 %r24, %r25
  %27 = mul i32 %26, 3
  br label %matchx.end18

matchx.next20:                                    ; preds = %dtor.free
  %is28 = icmp eq ptr %vtbl17, @Square.vtable
  br i1 %is28, label %matchx.case26, label %matchx.next27

matchx.case26:                                    ; preds = %matchx.next20
  %28 = getelementptr inbounds %class.Square, ptr %t15, i32 0, i32 1
  %side29 = load i32, ptr %28, align 4, !tbaa !4
  store i32 %side29, ptr %side30, align 4
  %side31 = load i32, ptr %side30, align 4
  %side32 = load i32, ptr %side30, align 4
  %29 = mul i32 %side31, %side32
  br label %matchx.end18

matchx.next27:                                    ; preds = %matchx.next20
  unreachable

dtor.call40:                                      ; preds = %matchx.end18
  call void %dtor.fn39(ptr %t35)
  br label %dtor.free41

dtor.free41:                                      ; preds = %dtor.call40, %matchx.end18
  call void @__polaron_free(ptr %t35)
  %Square.obj42 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Square, ptr null, i64 1) to i64))
  call void @Square.Square(ptr %Square.obj42, i32 2)
  store ptr %Square.obj42, ptr %u, align 8
  %u43 = load ptr, ptr %u, align 8
  %vtbl.addr44 = getelementptr inbounds %class.Shape, ptr %u43, i32 0, i32 0
  %vtbl45 = load ptr, ptr %vtbl.addr44, align 8, !tbaa !0
  %is49 = icmp eq ptr %vtbl45, @Circle.vtable
  br i1 %is49, label %matchx.case47, label %matchx.next48

matchx.end46:                                     ; preds = %matchx.next48, %matchx.case47
  %matchx53 = phi i32 [ %r52, %matchx.case47 ], [ 7, %matchx.next48 ]
  store i32 %matchx53, ptr %d, align 4
  %d54 = load i32, ptr %d, align 4
  %30 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %d54)
  %u55 = load ptr, ptr %u, align 8
  call void @__polaron_check_live(ptr %u55)
  %vtbl.addr56 = getelementptr inbounds %class.Shape, ptr %u55, i32 0, i32 0
  %vtbl57 = load ptr, ptr %vtbl.addr56, align 8, !tbaa !0
  %dtor.slot58 = getelementptr [350 x ptr], ptr %vtbl57, i64 0, i64 349
  %dtor.fn59 = load ptr, ptr %dtor.slot58, align 8
  %31 = icmp ne ptr %dtor.fn59, null
  br i1 %31, label %dtor.call60, label %dtor.free61

matchx.case47:                                    ; preds = %dtor.free41
  %32 = getelementptr inbounds %class.Circle, ptr %u43, i32 0, i32 1
  %r50 = load i32, ptr %32, align 4, !tbaa !4
  store i32 %r50, ptr %r51, align 4
  %r52 = load i32, ptr %r51, align 4
  br label %matchx.end46

matchx.next48:                                    ; preds = %dtor.free41
  br label %matchx.end46

dtor.call60:                                      ; preds = %matchx.end46
  call void %dtor.fn59(ptr %u55)
  br label %dtor.free61

dtor.free61:                                      ; preds = %dtor.call60, %matchx.end46
  call void @__polaron_free(ptr %u55)
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
