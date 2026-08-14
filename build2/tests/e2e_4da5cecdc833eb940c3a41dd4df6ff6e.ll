; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_invoke.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_invoke.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%ReflectType = type { ptr, i64, ptr, ptr, i64, ptr, i64, ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr }
%class.Dog = type { ptr }
%ReflectMethod = type { ptr, ptr, i64, ptr, i64 }
%__box = type { ptr, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Dog.vtable = private constant [351 x ptr] [ptr @Dog.bark, ptr @Dog.sit, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [351 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"Woof!\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"(sits)\00", align 1
@.strdata = private constant [4 x i8] c"Dog\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.4 = private constant [5 x i8] c"bark\00"
@.strobj.5 = private global %String { i64 4, ptr @.strdata.4, i64 0 }
@.strdata.6 = private constant [4 x i8] c"sit\00"
@.strobj.7 = private global %String { i64 3, ptr @.strdata.6, i64 0 }
@methods.Dog = private constant [2 x ptr] [ptr @.strobj.5, ptr @.strobj.7]
@fields.Dog = private constant [0 x ptr] zeroinitializer
@annotations.Dog = private constant [0 x ptr] zeroinitializer
@methodfns.Dog = private constant [2 x ptr] [ptr @Dog.bark, ptr @Dog.sit]
@fieldget.Dog = private constant [0 x ptr] zeroinitializer
@fieldset.Dog = private constant [0 x ptr] zeroinitializer
@methodann.Dog.0 = private constant [0 x ptr] zeroinitializer
@methodann.Dog.1 = private constant [0 x ptr] zeroinitializer
@methodanncounts.Dog = private constant [2 x i64] zeroinitializer
@methodannptrs.Dog = private constant [2 x ptr] [ptr @methodann.Dog.0, ptr @methodann.Dog.1]
@methodrettags.Dog = private constant [2 x i64] zeroinitializer
@type.Dog = private constant %ReflectType { ptr @.strobj, i64 2, ptr @methods.Dog, ptr @methodfns.Dog, i64 0, ptr @fields.Dog, i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64), ptr @Dog.Dog, i64 0, ptr @annotations.Dog, ptr @fieldget.Dog, ptr @fieldset.Dog, ptr @methodanncounts.Dog, ptr @methodannptrs.Dog, ptr @methodrettags.Dog }
@.strdata.8 = private constant [5 x i8] c"bark\00"
@.strobj.9 = private global %String { i64 4, ptr @.strdata.8, i64 0 }
@.panic = private unnamed_addr constant [61 x i8] c"reflection: Type.method(name) found no method with that name\00", align 1
@.str.10 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.11 = private constant [4 x i8] c"sit\00"
@.strobj.12 = private global %String { i64 3, ptr @.strdata.11, i64 0 }
@.panic.13 = private unnamed_addr constant [61 x i8] c"reflection: Type.method(name) found no method with that name\00", align 1
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }

define internal void @Dog.Dog(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 0
  store ptr @Dog.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @Dog.bark(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %1 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.1)
  ret void
}

define internal void @Dog.sit(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %1 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr @.str.3)
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %mi16 = alloca i64, align 8
  %m = alloca ptr, align 8
  %mi = alloca i64, align 8
  %t = alloca ptr, align 8
  %d = alloca ptr, align 8
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
  call void @Dog.Dog(ptr %Dog.obj)
  store ptr %Dog.obj, ptr %d, align 8
  store ptr @type.Dog, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %16 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 1
  %17 = load i64, ptr %16, align 8
  %18 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 2
  %19 = load ptr, ptr %18, align 8
  %20 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 3
  %21 = load ptr, ptr %20, align 8
  %22 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 14
  %23 = load ptr, ptr %22, align 8
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.9, i32 0, i32 1), align 8
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
  %39 = getelementptr inbounds %ReflectMethod, ptr %m3, i32 0, i32 0
  %m.name = load ptr, ptr %39, align 8
  %str.data4 = getelementptr inbounds %String, ptr %m.name, i32 0, i32 1
  %data5 = load ptr, ptr %str.data4, align 8
  %40 = call i32 (ptr, ...) @printf(ptr @.str.10, ptr %data5)
  %m6 = load ptr, ptr %m, align 8
  %41 = getelementptr inbounds %ReflectMethod, ptr %m6, i32 0, i32 1
  %m.fn = load ptr, ptr %41, align 8
  %42 = getelementptr inbounds %ReflectMethod, ptr %m6, i32 0, i32 4
  %m.tag = load i64, ptr %42, align 8
  %d7 = load ptr, ptr %d, align 8
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
  %invoke.r = phi ptr [ null, %invoke.t0 ], [ %box, %invoke.t1 ], [ %box8, %invoke.t2 ], [ %box9, %invoke.t3 ], [ %box10, %invoke.t4 ], [ %70, %invoke.t5 ], [ %box11, %invoke.t6 ], [ %box12, %invoke.t7 ], [ null, %invoke.def ]
  %t13 = load ptr, ptr %t, align 8
  %43 = getelementptr inbounds %ReflectType, ptr %t13, i32 0, i32 1
  %44 = load i64, ptr %43, align 8
  %45 = getelementptr inbounds %ReflectType, ptr %t13, i32 0, i32 2
  %46 = load ptr, ptr %45, align 8
  %47 = getelementptr inbounds %ReflectType, ptr %t13, i32 0, i32 3
  %48 = load ptr, ptr %47, align 8
  %49 = getelementptr inbounds %ReflectType, ptr %t13, i32 0, i32 14
  %50 = load ptr, ptr %49, align 8
  %data14 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.12, i32 0, i32 1), align 8
  %method15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%ReflectMethod, ptr null, i64 1) to i64))
  %51 = getelementptr inbounds %ReflectMethod, ptr %method15, i32 0, i32 0
  store ptr null, ptr %51, align 8
  %52 = getelementptr inbounds %ReflectMethod, ptr %method15, i32 0, i32 1
  store ptr null, ptr %52, align 8
  %53 = getelementptr inbounds %ReflectMethod, ptr %method15, i32 0, i32 4
  store i64 0, ptr %53, align 8
  store i64 0, ptr %mi16, align 8
  br label %m.hdr17

invoke.t0:                                        ; preds = %m.end
  call void %m.fn(ptr %d7)
  br label %invoke.cont

invoke.t1:                                        ; preds = %m.end
  %54 = call i32 %m.fn(ptr %d7)
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %55 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %55, align 8
  %56 = sext i32 %54 to i64
  %57 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %56, ptr %57, align 8
  br label %invoke.cont

invoke.t2:                                        ; preds = %m.end
  %58 = call i64 %m.fn(ptr %d7)
  %box8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %59 = getelementptr inbounds %__box, ptr %box8, i32 0, i32 0
  store ptr @Object.vtable, ptr %59, align 8
  %60 = getelementptr inbounds %__box, ptr %box8, i32 0, i32 1
  store i64 %58, ptr %60, align 8
  br label %invoke.cont

invoke.t3:                                        ; preds = %m.end
  %61 = call double %m.fn(ptr %d7)
  %box9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %62 = getelementptr inbounds %__box, ptr %box9, i32 0, i32 0
  store ptr @Object.vtable, ptr %62, align 8
  %63 = bitcast double %61 to i64
  %64 = getelementptr inbounds %__box, ptr %box9, i32 0, i32 1
  store i64 %63, ptr %64, align 8
  br label %invoke.cont

invoke.t4:                                        ; preds = %m.end
  %65 = call float %m.fn(ptr %d7)
  %box10 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %66 = getelementptr inbounds %__box, ptr %box10, i32 0, i32 0
  store ptr @Object.vtable, ptr %66, align 8
  %67 = bitcast float %65 to i32
  %68 = zext i32 %67 to i64
  %69 = getelementptr inbounds %__box, ptr %box10, i32 0, i32 1
  store i64 %68, ptr %69, align 8
  br label %invoke.cont

invoke.t5:                                        ; preds = %m.end
  %70 = call ptr %m.fn(ptr %d7)
  br label %invoke.cont

invoke.t6:                                        ; preds = %m.end
  %71 = call i8 %m.fn(ptr %d7)
  %box11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %72 = getelementptr inbounds %__box, ptr %box11, i32 0, i32 0
  store ptr @Object.vtable, ptr %72, align 8
  %73 = sext i8 %71 to i64
  %74 = getelementptr inbounds %__box, ptr %box11, i32 0, i32 1
  store i64 %73, ptr %74, align 8
  br label %invoke.cont

invoke.t7:                                        ; preds = %m.end
  %75 = call i16 %m.fn(ptr %d7)
  %box12 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %76 = getelementptr inbounds %__box, ptr %box12, i32 0, i32 0
  store ptr @Object.vtable, ptr %76, align 8
  %77 = sext i16 %75 to i64
  %78 = getelementptr inbounds %__box, ptr %box12, i32 0, i32 1
  store i64 %77, ptr %78, align 8
  br label %invoke.cont

m.hdr17:                                          ; preds = %m.next20, %invoke.cont
  %i23 = load i64, ptr %mi16, align 8
  %79 = icmp slt i64 %i23, %44
  br i1 %79, label %m.body18, label %m.miss22

m.body18:                                         ; preds = %m.hdr17
  %80 = getelementptr ptr, ptr %46, i64 %i23
  %mn24 = load ptr, ptr %80, align 8
  %str.data25 = getelementptr inbounds %String, ptr %mn24, i32 0, i32 1
  %data26 = load ptr, ptr %str.data25, align 8
  %81 = call i32 @strcmp(ptr %data26, ptr %data14)
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %m.hit19, label %m.next20

m.hit19:                                          ; preds = %m.body18
  %83 = getelementptr inbounds %ReflectMethod, ptr %method15, i32 0, i32 0
  store ptr %mn24, ptr %83, align 8
  %84 = getelementptr inbounds %ReflectMethod, ptr %method15, i32 0, i32 1
  %85 = getelementptr ptr, ptr %48, i64 %i23
  %86 = load ptr, ptr %85, align 8
  store ptr %86, ptr %84, align 8
  %87 = getelementptr inbounds %ReflectMethod, ptr %method15, i32 0, i32 4
  %88 = getelementptr i64, ptr %50, i64 %i23
  %89 = load i64, ptr %88, align 8
  store i64 %89, ptr %87, align 8
  br label %m.end21

m.next20:                                         ; preds = %m.body18
  %90 = add i64 %i23, 1
  store i64 %90, ptr %mi16, align 8
  br label %m.hdr17

m.end21:                                          ; preds = %m.hit19
  %91 = getelementptr inbounds %ReflectMethod, ptr %method15, i32 0, i32 1
  %m.fn27 = load ptr, ptr %91, align 8
  %92 = getelementptr inbounds %ReflectMethod, ptr %method15, i32 0, i32 4
  %m.tag28 = load i64, ptr %92, align 8
  %d29 = load ptr, ptr %d, align 8
  switch i64 %m.tag28, label %invoke.def30 [
    i64 0, label %invoke.t032
    i64 1, label %invoke.t133
    i64 2, label %invoke.t235
    i64 3, label %invoke.t337
    i64 4, label %invoke.t439
    i64 5, label %invoke.t541
    i64 6, label %invoke.t642
    i64 7, label %invoke.t744
  ]

m.miss22:                                         ; preds = %m.hdr17
  call void @__polaron_panic(ptr @.panic.13)
  unreachable

invoke.def30:                                     ; preds = %m.end21
  br label %invoke.cont31

invoke.cont31:                                    ; preds = %invoke.def30, %invoke.t744, %invoke.t642, %invoke.t541, %invoke.t439, %invoke.t337, %invoke.t235, %invoke.t133, %invoke.t032
  %invoke.r46 = phi ptr [ null, %invoke.t032 ], [ %box34, %invoke.t133 ], [ %box36, %invoke.t235 ], [ %box38, %invoke.t337 ], [ %box40, %invoke.t439 ], [ %109, %invoke.t541 ], [ %box43, %invoke.t642 ], [ %box45, %invoke.t744 ], [ null, %invoke.def30 ]
  ret i32 0

invoke.t032:                                      ; preds = %m.end21
  call void %m.fn27(ptr %d29)
  br label %invoke.cont31

invoke.t133:                                      ; preds = %m.end21
  %93 = call i32 %m.fn27(ptr %d29)
  %box34 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %94 = getelementptr inbounds %__box, ptr %box34, i32 0, i32 0
  store ptr @Object.vtable, ptr %94, align 8
  %95 = sext i32 %93 to i64
  %96 = getelementptr inbounds %__box, ptr %box34, i32 0, i32 1
  store i64 %95, ptr %96, align 8
  br label %invoke.cont31

invoke.t235:                                      ; preds = %m.end21
  %97 = call i64 %m.fn27(ptr %d29)
  %box36 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %98 = getelementptr inbounds %__box, ptr %box36, i32 0, i32 0
  store ptr @Object.vtable, ptr %98, align 8
  %99 = getelementptr inbounds %__box, ptr %box36, i32 0, i32 1
  store i64 %97, ptr %99, align 8
  br label %invoke.cont31

invoke.t337:                                      ; preds = %m.end21
  %100 = call double %m.fn27(ptr %d29)
  %box38 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %101 = getelementptr inbounds %__box, ptr %box38, i32 0, i32 0
  store ptr @Object.vtable, ptr %101, align 8
  %102 = bitcast double %100 to i64
  %103 = getelementptr inbounds %__box, ptr %box38, i32 0, i32 1
  store i64 %102, ptr %103, align 8
  br label %invoke.cont31

invoke.t439:                                      ; preds = %m.end21
  %104 = call float %m.fn27(ptr %d29)
  %box40 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %105 = getelementptr inbounds %__box, ptr %box40, i32 0, i32 0
  store ptr @Object.vtable, ptr %105, align 8
  %106 = bitcast float %104 to i32
  %107 = zext i32 %106 to i64
  %108 = getelementptr inbounds %__box, ptr %box40, i32 0, i32 1
  store i64 %107, ptr %108, align 8
  br label %invoke.cont31

invoke.t541:                                      ; preds = %m.end21
  %109 = call ptr %m.fn27(ptr %d29)
  br label %invoke.cont31

invoke.t642:                                      ; preds = %m.end21
  %110 = call i8 %m.fn27(ptr %d29)
  %box43 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %111 = getelementptr inbounds %__box, ptr %box43, i32 0, i32 0
  store ptr @Object.vtable, ptr %111, align 8
  %112 = sext i8 %110 to i64
  %113 = getelementptr inbounds %__box, ptr %box43, i32 0, i32 1
  store i64 %112, ptr %113, align 8
  br label %invoke.cont31

invoke.t744:                                      ; preds = %m.end21
  %114 = call i16 %m.fn27(ptr %d29)
  %box45 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %115 = getelementptr inbounds %__box, ptr %box45, i32 0, i32 0
  store ptr @Object.vtable, ptr %115, align 8
  %116 = sext i16 %114 to i64
  %117 = getelementptr inbounds %__box, ptr %box45, i32 0, i32 1
  store i64 %116, ptr %117, align 8
  br label %invoke.cont31
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5322)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5324)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @strcmp(ptr, ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
