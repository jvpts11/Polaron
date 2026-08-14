; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_invoke_return.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_invoke_return.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%ReflectType = type { ptr, i64, ptr, ptr, i64, ptr, i64, ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr }
%class.Calc = type { ptr }
%ReflectMethod = type { ptr, ptr, i64, ptr, i64 }
%__box = type { ptr, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Calc.vtable = private constant [350 x ptr] [ptr @Calc.square, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [5 x i8] c"Calc\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"square\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@methods.Calc = private constant [1 x ptr] [ptr @.strobj.2]
@fields.Calc = private constant [0 x ptr] zeroinitializer
@annotations.Calc = private constant [0 x ptr] zeroinitializer
@methodfns.Calc = private constant [1 x ptr] [ptr @Calc.square]
@fieldget.Calc = private constant [0 x ptr] zeroinitializer
@fieldset.Calc = private constant [0 x ptr] zeroinitializer
@methodann.Calc.0 = private constant [0 x ptr] zeroinitializer
@methodanncounts.Calc = private constant [1 x i64] zeroinitializer
@methodannptrs.Calc = private constant [1 x ptr] [ptr @methodann.Calc.0]
@methodrettags.Calc = private constant [1 x i64] [i64 1]
@type.Calc = private constant %ReflectType { ptr @.strobj, i64 1, ptr @methods.Calc, ptr @methodfns.Calc, i64 0, ptr @fields.Calc, i64 ptrtoint (ptr getelementptr (%class.Calc, ptr null, i64 1) to i64), ptr @Calc.Calc, i64 0, ptr @annotations.Calc, ptr @fieldget.Calc, ptr @fieldset.Calc, ptr @methodanncounts.Calc, ptr @methodannptrs.Calc, ptr @methodrettags.Calc }
@.strdata.3 = private constant [7 x i8] c"square\00"
@.strobj.4 = private global %String { i64 6, ptr @.strdata.3, i64 0 }
@.panic = private unnamed_addr constant [61 x i8] c"reflection: Type.method(name) found no method with that name\00", align 1
@.str = private unnamed_addr constant [6 x i8] c"v=%d\0A\00", align 1
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }

define internal void @Calc.Calc(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Calc, ptr %0, i32 0, i32 0
  store ptr @Calc.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal i32 @Calc.square(ptr nonnull align 8 dereferenceable(8) %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %x2 = load i32, ptr %x, align 4
  %2 = mul i32 %x1, %x2
  ret i32 %2
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %v = alloca i32, align 4
  %r = alloca ptr, align 8
  %m = alloca ptr, align 8
  %mi = alloca i64, align 8
  %t = alloca ptr, align 8
  %c = alloca ptr, align 8
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
  %Calc.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Calc, ptr null, i64 1) to i64))
  call void @Calc.Calc(ptr %Calc.obj)
  store ptr %Calc.obj, ptr %c, align 8
  store ptr @type.Calc, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %16 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 1
  %17 = load i64, ptr %16, align 8
  %18 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 2
  %19 = load ptr, ptr %18, align 8
  %20 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 3
  %21 = load ptr, ptr %20, align 8
  %22 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 14
  %23 = load ptr, ptr %22, align 8
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %method = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%ReflectMethod, ptr null, i64 1) to i64))
  %24 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 0
  store ptr null, ptr %24, align 8
  %25 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  store ptr null, ptr %25, align 8
  %26 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  store i64 0, ptr %26, align 8
  store i64 0, ptr %mi, align 8
  br label %m.hdr

m.hdr:                                            ; preds = %m.next, %argv.end
  %i = load i64, ptr %mi, align 8
  %27 = icmp slt i64 %i, %17
  br i1 %27, label %m.body, label %m.miss

m.body:                                           ; preds = %m.hdr
  %28 = getelementptr ptr, ptr %19, i64 %i
  %mn = load ptr, ptr %28, align 8
  %str.data = getelementptr inbounds %String, ptr %mn, i32 0, i32 1
  %data2 = load ptr, ptr %str.data, align 8
  %29 = call i32 @strcmp(ptr %data2, ptr %data)
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %m.hit, label %m.next

m.hit:                                            ; preds = %m.body
  %31 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 0
  store ptr %mn, ptr %31, align 8
  %32 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  %33 = getelementptr ptr, ptr %21, i64 %i
  %34 = load ptr, ptr %33, align 8
  store ptr %34, ptr %32, align 8
  %35 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  %36 = getelementptr i64, ptr %23, i64 %i
  %37 = load i64, ptr %36, align 8
  store i64 %37, ptr %35, align 8
  br label %m.end

m.next:                                           ; preds = %m.body
  %38 = add i64 %i, 1
  store i64 %38, ptr %mi, align 8
  br label %m.hdr

m.end:                                            ; preds = %m.hit
  store ptr %method, ptr %m, align 8
  %m3 = load ptr, ptr %m, align 8
  %39 = getelementptr inbounds %ReflectMethod, ptr %m3, i32 0, i32 1
  %m.fn = load ptr, ptr %39, align 8
  %40 = getelementptr inbounds %ReflectMethod, ptr %m3, i32 0, i32 4
  %m.tag = load i64, ptr %40, align 8
  %c4 = load ptr, ptr %c, align 8
  switch i64 %m.tag, label %invoke.def [
    i64 0, label %invoke.t0
    i64 1, label %invoke.t1
    i64 2, label %invoke.t2
    i64 3, label %invoke.t3
    i64 4, label %invoke.t4
    i64 5, label %invoke.t5
    i64 6, label %invoke.t6
    i64 7, label %invoke.t7
  ]

m.miss:                                           ; preds = %m.hdr
  call void @__polaron_panic(ptr @.panic)
  unreachable

invoke.def:                                       ; preds = %m.end
  br label %invoke.cont

invoke.cont:                                      ; preds = %invoke.def, %invoke.t7, %invoke.t6, %invoke.t5, %invoke.t4, %invoke.t3, %invoke.t2, %invoke.t1, %invoke.t0
  %invoke.r = phi ptr [ null, %invoke.t0 ], [ %box, %invoke.t1 ], [ %box5, %invoke.t2 ], [ %box6, %invoke.t3 ], [ %box7, %invoke.t4 ], [ %60, %invoke.t5 ], [ %box8, %invoke.t6 ], [ %box9, %invoke.t7 ], [ null, %invoke.def ]
  store ptr %invoke.r, ptr %r, align 8
  %r10 = load ptr, ptr %r, align 8
  %41 = getelementptr inbounds %__box, ptr %r10, i32 0, i32 1
  %unbox = load i64, ptr %41, align 8
  %42 = trunc i64 %unbox to i32
  store i32 %42, ptr %v, align 4
  %v11 = load i32, ptr %v, align 4
  %43 = call i32 (ptr, ...) @printf(ptr @.str, i32 %v11)
  ret i32 0

invoke.t0:                                        ; preds = %m.end
  call void %m.fn(ptr %c4, i32 7)
  br label %invoke.cont

invoke.t1:                                        ; preds = %m.end
  %44 = call i32 %m.fn(ptr %c4, i32 7)
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %45 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %45, align 8
  %46 = sext i32 %44 to i64
  %47 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %46, ptr %47, align 8
  br label %invoke.cont

invoke.t2:                                        ; preds = %m.end
  %48 = call i64 %m.fn(ptr %c4, i32 7)
  %box5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %49 = getelementptr inbounds %__box, ptr %box5, i32 0, i32 0
  store ptr @Object.vtable, ptr %49, align 8
  %50 = getelementptr inbounds %__box, ptr %box5, i32 0, i32 1
  store i64 %48, ptr %50, align 8
  br label %invoke.cont

invoke.t3:                                        ; preds = %m.end
  %51 = call double %m.fn(ptr %c4, i32 7)
  %box6 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %52 = getelementptr inbounds %__box, ptr %box6, i32 0, i32 0
  store ptr @Object.vtable, ptr %52, align 8
  %53 = bitcast double %51 to i64
  %54 = getelementptr inbounds %__box, ptr %box6, i32 0, i32 1
  store i64 %53, ptr %54, align 8
  br label %invoke.cont

invoke.t4:                                        ; preds = %m.end
  %55 = call float %m.fn(ptr %c4, i32 7)
  %box7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %56 = getelementptr inbounds %__box, ptr %box7, i32 0, i32 0
  store ptr @Object.vtable, ptr %56, align 8
  %57 = bitcast float %55 to i32
  %58 = zext i32 %57 to i64
  %59 = getelementptr inbounds %__box, ptr %box7, i32 0, i32 1
  store i64 %58, ptr %59, align 8
  br label %invoke.cont

invoke.t5:                                        ; preds = %m.end
  %60 = call ptr %m.fn(ptr %c4, i32 7)
  br label %invoke.cont

invoke.t6:                                        ; preds = %m.end
  %61 = call i8 %m.fn(ptr %c4, i32 7)
  %box8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %62 = getelementptr inbounds %__box, ptr %box8, i32 0, i32 0
  store ptr @Object.vtable, ptr %62, align 8
  %63 = sext i8 %61 to i64
  %64 = getelementptr inbounds %__box, ptr %box8, i32 0, i32 1
  store i64 %63, ptr %64, align 8
  br label %invoke.cont

invoke.t7:                                        ; preds = %m.end
  %65 = call i16 %m.fn(ptr %c4, i32 7)
  %box9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %66 = getelementptr inbounds %__box, ptr %box9, i32 0, i32 0
  store ptr @Object.vtable, ptr %66, align 8
  %67 = sext i16 %65 to i64
  %68 = getelementptr inbounds %__box, ptr %box9, i32 0, i32 1
  store i64 %67, ptr %68, align 8
  br label %invoke.cont
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

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @strcmp(ptr, ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
