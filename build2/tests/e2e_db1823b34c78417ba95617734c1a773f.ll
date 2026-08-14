; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/showcase.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/showcase.pol"
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
@.contract = private unnamed_addr constant [193 x i8] c"contract violated: requires\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/showcase.pol:15:57  in Circle.Circle\0A   |  public constructor Circle(int r) requires r > 0 { this.r = r; }\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1 = private unnamed_addr constant [205 x i8] c"contract violated: requires\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/showcase.pol:20:63  in Square.Square\0A   |  public constructor Square(int side) requires side > 0 { this.side = side; }\0A\00", align 1
@.cl.2 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.3 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.str = private unnamed_addr constant [23 x i8] c"areas: %d %d total %d\0A\00", align 1
@.str.4 = private unnamed_addr constant [14 x i8] c"odd sum = %d\0A\00", align 1
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }

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
  %r1 = load i32, ptr %r, align 4
  %2 = icmp sgt i32 %r1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %r2 = load i32, ptr %r, align 4
  %contract.l = sext i32 %r2 to i64
  call void @__polaron_fail(ptr @.contract, ptr @.cl, i64 %contract.l, ptr @.cr, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %r3 = getelementptr inbounds %class.Circle, ptr %0, i32 0, i32 1
  %r4 = load i32, ptr %r, align 4
  store i32 %r4, ptr %r3, align 4, !tbaa !4
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
  %side1 = load i32, ptr %side, align 4
  %2 = icmp sgt i32 %side1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %side2 = load i32, ptr %side, align 4
  %contract.l = sext i32 %side2 to i64
  call void @__polaron_fail(ptr @.contract.1, ptr @.cl.2, i64 %contract.l, ptr @.cr.3, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %side3 = getelementptr inbounds %class.Square, ptr %0, i32 0, i32 1
  %side4 = load i32, ptr %side, align 4
  store i32 %side4, ptr %side3, align 4, !tbaa !4
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
  %i = alloca i32, align 4
  %acc = alloca i32, align 4
  %total = alloca i32, align 4
  %a2 = alloca i32, align 4
  %side26 = alloca i32, align 4
  %r19 = alloca i32, align 4
  %a1 = alloca i32, align 4
  %side8 = alloca i32, align 4
  %r2 = alloca i32, align 4
  %s2 = alloca ptr, align 8
  %s1 = alloca ptr, align 8
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
  call void @Circle.Circle(ptr %Circle.obj, i32 2)
  store ptr %Circle.obj, ptr %s1, align 8
  %Square.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Square, ptr null, i64 1) to i64))
  call void @Square.Square(ptr %Square.obj, i32 3)
  store ptr %Square.obj, ptr %s2, align 8
  %s11 = load ptr, ptr %s1, align 8
  %vtbl.addr = getelementptr inbounds %class.Shape, ptr %s11, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %is = icmp eq ptr %vtbl, @Circle.vtable
  br i1 %is, label %matchx.case, label %matchx.next

matchx.end:                                       ; preds = %matchx.case5, %matchx.case
  %matchx = phi i32 [ %18, %matchx.case ], [ %20, %matchx.case5 ]
  store i32 %matchx, ptr %a1, align 4
  %s211 = load ptr, ptr %s2, align 8
  %vtbl.addr12 = getelementptr inbounds %class.Shape, ptr %s211, i32 0, i32 0
  %vtbl13 = load ptr, ptr %vtbl.addr12, align 8, !tbaa !0
  %is17 = icmp eq ptr %vtbl13, @Circle.vtable
  br i1 %is17, label %matchx.case15, label %matchx.next16

matchx.case:                                      ; preds = %argv.end
  %16 = getelementptr inbounds %class.Circle, ptr %s11, i32 0, i32 1
  %r = load i32, ptr %16, align 4, !tbaa !4
  store i32 %r, ptr %r2, align 4
  %r3 = load i32, ptr %r2, align 4
  %r4 = load i32, ptr %r2, align 4
  %17 = mul i32 %r3, %r4
  %18 = mul i32 %17, 3
  br label %matchx.end

matchx.next:                                      ; preds = %argv.end
  %is7 = icmp eq ptr %vtbl, @Square.vtable
  br i1 %is7, label %matchx.case5, label %matchx.next6

matchx.case5:                                     ; preds = %matchx.next
  %19 = getelementptr inbounds %class.Square, ptr %s11, i32 0, i32 1
  %side = load i32, ptr %19, align 4, !tbaa !4
  store i32 %side, ptr %side8, align 4
  %side9 = load i32, ptr %side8, align 4
  %side10 = load i32, ptr %side8, align 4
  %20 = mul i32 %side9, %side10
  br label %matchx.end

matchx.next6:                                     ; preds = %matchx.next
  unreachable

matchx.end14:                                     ; preds = %matchx.case22, %matchx.case15
  %matchx29 = phi i32 [ %25, %matchx.case15 ], [ %27, %matchx.case22 ]
  store i32 %matchx29, ptr %a2, align 4
  %a130 = load i32, ptr %a1, align 4
  %a231 = load i32, ptr %a2, align 4
  %21 = add i32 %a130, %a231
  store i32 %21, ptr %total, align 4
  %a132 = load i32, ptr %a1, align 4
  %a233 = load i32, ptr %a2, align 4
  %total34 = load i32, ptr %total, align 4
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %a132, i32 %a233, i32 %total34)
  store i32 0, ptr %acc, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

matchx.case15:                                    ; preds = %matchx.end
  %23 = getelementptr inbounds %class.Circle, ptr %s211, i32 0, i32 1
  %r18 = load i32, ptr %23, align 4, !tbaa !4
  store i32 %r18, ptr %r19, align 4
  %r20 = load i32, ptr %r19, align 4
  %r21 = load i32, ptr %r19, align 4
  %24 = mul i32 %r20, %r21
  %25 = mul i32 %24, 3
  br label %matchx.end14

matchx.next16:                                    ; preds = %matchx.end
  %is24 = icmp eq ptr %vtbl13, @Square.vtable
  br i1 %is24, label %matchx.case22, label %matchx.next23

matchx.case22:                                    ; preds = %matchx.next16
  %26 = getelementptr inbounds %class.Square, ptr %s211, i32 0, i32 1
  %side25 = load i32, ptr %26, align 4, !tbaa !4
  store i32 %side25, ptr %side26, align 4
  %side27 = load i32, ptr %side26, align 4
  %side28 = load i32, ptr %side26, align 4
  %27 = mul i32 %side27, %side28
  br label %matchx.end14

matchx.next23:                                    ; preds = %matchx.next16
  unreachable

for.cond:                                         ; preds = %for.update, %matchx.end14
  %i35 = load i32, ptr %i, align 4
  %28 = icmp sle i32 %i35, 4
  %29 = zext i1 %28 to i32
  br i1 %28, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %acc36 = load i32, ptr %acc, align 4
  %i37 = load i32, ptr %i, align 4
  %30 = and i32 %i37, 1
  %31 = icmp eq i32 %30, 1
  %32 = zext i1 %31 to i32
  %tern.c = icmp ne i32 %32, 0
  br i1 %tern.c, label %tern.then, label %tern.else

for.update:                                       ; preds = %tern.end
  %33 = load i32, ptr %i, align 4
  %34 = add i32 %33, 1
  store i32 %34, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %acc39 = load i32, ptr %acc, align 4
  %35 = call i32 (ptr, ...) @printf(ptr @.str.4, i32 %acc39)
  %s140 = load ptr, ptr %s1, align 8
  call void @__polaron_check_live(ptr %s140)
  %vtbl.addr41 = getelementptr inbounds %class.Shape, ptr %s140, i32 0, i32 0
  %vtbl42 = load ptr, ptr %vtbl.addr41, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl42, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %36 = icmp ne ptr %dtor.fn, null
  br i1 %36, label %dtor.call, label %dtor.free

tern.then:                                        ; preds = %for.body
  %i38 = load i32, ptr %i, align 4
  br label %tern.end

tern.else:                                        ; preds = %for.body
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ %i38, %tern.then ], [ 0, %tern.else ]
  %37 = add i32 %acc36, %tern
  store i32 %37, ptr %acc, align 4
  br label %for.update

dtor.call:                                        ; preds = %for.end
  call void %dtor.fn(ptr %s140)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %for.end
  call void @__polaron_free(ptr %s140)
  %s243 = load ptr, ptr %s2, align 8
  call void @__polaron_check_live(ptr %s243)
  %vtbl.addr44 = getelementptr inbounds %class.Shape, ptr %s243, i32 0, i32 0
  %vtbl45 = load ptr, ptr %vtbl.addr44, align 8, !tbaa !0
  %dtor.slot46 = getelementptr [350 x ptr], ptr %vtbl45, i64 0, i64 349
  %dtor.fn47 = load ptr, ptr %dtor.slot46, align 8
  %38 = icmp ne ptr %dtor.fn47, null
  br i1 %38, label %dtor.call48, label %dtor.free49

dtor.call48:                                      ; preds = %dtor.free
  call void %dtor.fn47(ptr %s243)
  br label %dtor.free49

dtor.free49:                                      ; preds = %dtor.call48, %dtor.free
  call void @__polaron_free(ptr %s243)
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

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

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
