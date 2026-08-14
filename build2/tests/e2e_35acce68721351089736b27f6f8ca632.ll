; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_args.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_args.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%ReflectType = type { ptr, i64, ptr, ptr, i64, ptr, i64, ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr }
%class.Dog = type { ptr, i32 }
%class.ClassCastException = type { ptr }
%ReflectMethod = type { ptr, ptr, i64, ptr, i64 }
%__box = type { ptr, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Dog.vtable = private constant [350 x ptr] [ptr @Dog.setAge, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ClassCastException.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ClassCastException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [4 x i8] c"Dog\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"setAge\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@methods.Dog = private constant [1 x ptr] [ptr @.strobj.2]
@.strdata.3 = private constant [4 x i8] c"age\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@fields.Dog = private constant [1 x ptr] [ptr @.strobj.4]
@annotations.Dog = private constant [0 x ptr] zeroinitializer
@methodfns.Dog = private constant [1 x ptr] [ptr @Dog.setAge]
@fieldget.Dog = private constant [1 x ptr] [ptr @__fget.Dog.age]
@fieldset.Dog = private constant [1 x ptr] [ptr @__fset.Dog.age]
@methodann.Dog.0 = private constant [0 x ptr] zeroinitializer
@methodanncounts.Dog = private constant [1 x i64] zeroinitializer
@methodannptrs.Dog = private constant [1 x ptr] [ptr @methodann.Dog.0]
@methodrettags.Dog = private constant [1 x i64] zeroinitializer
@type.Dog = private constant %ReflectType { ptr @.strobj, i64 1, ptr @methods.Dog, ptr @methodfns.Dog, i64 1, ptr @fields.Dog, i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64), ptr @Dog.Dog, i64 0, ptr @annotations.Dog, ptr @fieldget.Dog, ptr @fieldset.Dog, ptr @methodanncounts.Dog, ptr @methodannptrs.Dog, ptr @methodrettags.Dog }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str = private unnamed_addr constant [8 x i8] c"age=%d\0A\00", align 1
@.strdata.5 = private constant [7 x i8] c"setAge\00"
@.strobj.6 = private global %String { i64 6, ptr @.strdata.5, i64 0 }
@.panic = private unnamed_addr constant [61 x i8] c"reflection: Type.method(name) found no method with that name\00", align 1
@.str.7 = private unnamed_addr constant [8 x i8] c"age=%d\0A\00", align 1
@.strdata.1309 = private constant [13 x i8] c"invalid cast\00"
@.strobj.1310 = private global %String { i64 12, ptr @.strdata.1309, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }

define internal void @Dog.Dog(ptr %0, i32 %1) {
entry:
  %a = alloca i32, align 4
  store i32 %1, ptr %a, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 0
  store ptr @Dog.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %age = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %a1 = load i32, ptr %a, align 4
  store i32 %a1, ptr %age, align 4, !tbaa !4
  ret void
}

define internal void @Dog.setAge(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %a = alloca i32, align 4
  store i32 %1, ptr %a, align 4
  %age = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 1
  %a1 = load i32, ptr %a, align 4
  store i32 %a1, ptr %age, align 4, !tbaa !4
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %mi = alloca i64, align 8
  %d = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
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
  %16 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 6
  %size = load i64, ptr %16, align 8
  %17 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 7
  %ctor = load ptr, ptr %17, align 8
  %inst = call ptr @__polaron_malloc(i64 %size)
  call void %ctor(ptr %inst, i32 7)
  %cast.nn = icmp ne ptr %inst, null
  %isa.null = icmp eq ptr %inst, null
  br i1 %isa.null, label %isa.cont, label %isa.chk

isa.chk:                                          ; preds = %argv.end
  %isa.vtbl = load ptr, ptr %inst, align 8
  %18 = icmp eq ptr %isa.vtbl, @Dog.vtable
  %19 = or i1 false, %18
  br label %isa.cont

isa.cont:                                         ; preds = %isa.chk, %argv.end
  %isa = phi i1 [ false, %argv.end ], [ %19, %isa.chk ]
  %20 = xor i1 %isa, true
  %21 = and i1 %cast.nn, %20
  br i1 %21, label %cast.bad, label %cast.ok

cast.bad:                                         ; preds = %isa.cont
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ClassCastException, ptr null, i64 1) to i64))
  call void @ClassCastException.ClassCastException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

cast.ok:                                          ; preds = %isa.cont
  store ptr %inst, ptr %d, align 8
  %d2 = load ptr, ptr %d, align 8
  %age = getelementptr inbounds %class.Dog, ptr %d2, i32 0, i32 1
  %age3 = load i32, ptr %age, align 4, !tbaa !4
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %age3)
  %t4 = load ptr, ptr %t, align 8
  %23 = getelementptr inbounds %ReflectType, ptr %t4, i32 0, i32 1
  %24 = load i64, ptr %23, align 8
  %25 = getelementptr inbounds %ReflectType, ptr %t4, i32 0, i32 2
  %26 = load ptr, ptr %25, align 8
  %27 = getelementptr inbounds %ReflectType, ptr %t4, i32 0, i32 3
  %28 = load ptr, ptr %27, align 8
  %29 = getelementptr inbounds %ReflectType, ptr %t4, i32 0, i32 14
  %30 = load ptr, ptr %29, align 8
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %method = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%ReflectMethod, ptr null, i64 1) to i64))
  %31 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 0
  store ptr null, ptr %31, align 8
  %32 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  store ptr null, ptr %32, align 8
  %33 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  store i64 0, ptr %33, align 8
  store i64 0, ptr %mi, align 8
  br label %m.hdr

m.hdr:                                            ; preds = %m.next, %cast.ok
  %i = load i64, ptr %mi, align 8
  %34 = icmp slt i64 %i, %24
  br i1 %34, label %m.body, label %m.miss

m.body:                                           ; preds = %m.hdr
  %35 = getelementptr ptr, ptr %26, i64 %i
  %mn = load ptr, ptr %35, align 8
  %str.data = getelementptr inbounds %String, ptr %mn, i32 0, i32 1
  %data5 = load ptr, ptr %str.data, align 8
  %36 = call i32 @strcmp(ptr %data5, ptr %data)
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %m.hit, label %m.next

m.hit:                                            ; preds = %m.body
  %38 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 0
  store ptr %mn, ptr %38, align 8
  %39 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  %40 = getelementptr ptr, ptr %28, i64 %i
  %41 = load ptr, ptr %40, align 8
  store ptr %41, ptr %39, align 8
  %42 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  %43 = getelementptr i64, ptr %30, i64 %i
  %44 = load i64, ptr %43, align 8
  store i64 %44, ptr %42, align 8
  br label %m.end

m.next:                                           ; preds = %m.body
  %45 = add i64 %i, 1
  store i64 %45, ptr %mi, align 8
  br label %m.hdr

m.end:                                            ; preds = %m.hit
  %46 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  %m.fn = load ptr, ptr %46, align 8
  %47 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  %m.tag = load i64, ptr %47, align 8
  %d6 = load ptr, ptr %d, align 8
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
  %invoke.r = phi ptr [ null, %invoke.t0 ], [ %box, %invoke.t1 ], [ %box7, %invoke.t2 ], [ %box8, %invoke.t3 ], [ %box9, %invoke.t4 ], [ %65, %invoke.t5 ], [ %box10, %invoke.t6 ], [ %box11, %invoke.t7 ], [ null, %invoke.def ]
  %d12 = load ptr, ptr %d, align 8
  %age13 = getelementptr inbounds %class.Dog, ptr %d12, i32 0, i32 1
  %age14 = load i32, ptr %age13, align 4, !tbaa !4
  %48 = call i32 (ptr, ...) @printf(ptr @.str.7, i32 %age14)
  ret i32 0

invoke.t0:                                        ; preds = %m.end
  call void %m.fn(ptr %d6, i32 99)
  br label %invoke.cont

invoke.t1:                                        ; preds = %m.end
  %49 = call i32 %m.fn(ptr %d6, i32 99)
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %50 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %50, align 8
  %51 = sext i32 %49 to i64
  %52 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %51, ptr %52, align 8
  br label %invoke.cont

invoke.t2:                                        ; preds = %m.end
  %53 = call i64 %m.fn(ptr %d6, i32 99)
  %box7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %54 = getelementptr inbounds %__box, ptr %box7, i32 0, i32 0
  store ptr @Object.vtable, ptr %54, align 8
  %55 = getelementptr inbounds %__box, ptr %box7, i32 0, i32 1
  store i64 %53, ptr %55, align 8
  br label %invoke.cont

invoke.t3:                                        ; preds = %m.end
  %56 = call double %m.fn(ptr %d6, i32 99)
  %box8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %57 = getelementptr inbounds %__box, ptr %box8, i32 0, i32 0
  store ptr @Object.vtable, ptr %57, align 8
  %58 = bitcast double %56 to i64
  %59 = getelementptr inbounds %__box, ptr %box8, i32 0, i32 1
  store i64 %58, ptr %59, align 8
  br label %invoke.cont

invoke.t4:                                        ; preds = %m.end
  %60 = call float %m.fn(ptr %d6, i32 99)
  %box9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %61 = getelementptr inbounds %__box, ptr %box9, i32 0, i32 0
  store ptr @Object.vtable, ptr %61, align 8
  %62 = bitcast float %60 to i32
  %63 = zext i32 %62 to i64
  %64 = getelementptr inbounds %__box, ptr %box9, i32 0, i32 1
  store i64 %63, ptr %64, align 8
  br label %invoke.cont

invoke.t5:                                        ; preds = %m.end
  %65 = call ptr %m.fn(ptr %d6, i32 99)
  br label %invoke.cont

invoke.t6:                                        ; preds = %m.end
  %66 = call i8 %m.fn(ptr %d6, i32 99)
  %box10 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %67 = getelementptr inbounds %__box, ptr %box10, i32 0, i32 0
  store ptr @Object.vtable, ptr %67, align 8
  %68 = sext i8 %66 to i64
  %69 = getelementptr inbounds %__box, ptr %box10, i32 0, i32 1
  store i64 %68, ptr %69, align 8
  br label %invoke.cont

invoke.t7:                                        ; preds = %m.end
  %70 = call i16 %m.fn(ptr %d6, i32 99)
  %box11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %71 = getelementptr inbounds %__box, ptr %box11, i32 0, i32 0
  store ptr @Object.vtable, ptr %71, align 8
  %72 = sext i16 %70 to i64
  %73 = getelementptr inbounds %__box, ptr %box11, i32 0, i32 1
  store i64 %72, ptr %73, align 8
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

define internal void @Exception.Exception(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  ret void
}

define internal void @ClassCastException.ClassCastException(ptr %0) {
entry:
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ClassCastException, ptr %0, i32 0, i32 0
  store ptr @ClassCastException.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal ptr @ClassCastException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1310)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5318)
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

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare i32 @printf(ptr, ...)

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
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
