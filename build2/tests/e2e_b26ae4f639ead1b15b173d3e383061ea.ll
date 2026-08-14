; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/unimport.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/unimport.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%ReflectType = type { ptr, i64, ptr, ptr, i64, ptr, i64, ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr }
%class.Dog = type { ptr }
%class.UnimportedTypeException = type { ptr }
%ReflectMethod = type { ptr, ptr, i64, ptr, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@__polaron_code_base = private global ptr @__polaron_code
@__polaron_code_count = private global i64 13
@Dog.vtable = private global [350 x ptr] [ptr @Dog.bark, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Dog.~Dog"]
@UnimportedTypeException.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @UnimportedTypeException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@instances.Dog = private global i32 0
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"Woof!\00", align 1
@alive.Dog = private global i32 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata = private constant [4 x i8] c"Dog\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.2 = private constant [5 x i8] c"bark\00"
@.strobj.3 = private global %String { i64 4, ptr @.strdata.2, i64 0 }
@methods.Dog = private constant [1 x ptr] [ptr @.strobj.3]
@fields.Dog = private constant [0 x ptr] zeroinitializer
@annotations.Dog = private constant [0 x ptr] zeroinitializer
@methodfns.Dog = private constant [1 x ptr] [ptr @Dog.bark]
@fieldget.Dog = private constant [0 x ptr] zeroinitializer
@fieldset.Dog = private constant [0 x ptr] zeroinitializer
@methodann.Dog.0 = private constant [0 x ptr] zeroinitializer
@methodanncounts.Dog = private constant [1 x i64] zeroinitializer
@methodannptrs.Dog = private constant [1 x ptr] [ptr @methodann.Dog.0]
@methodrettags.Dog = private constant [1 x i64] zeroinitializer
@type.Dog = private constant %ReflectType { ptr @.strobj, i64 1, ptr @methods.Dog, ptr @methodfns.Dog, i64 0, ptr @fields.Dog, i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64), ptr @Dog.Dog, i64 0, ptr @annotations.Dog, ptr @fieldget.Dog, ptr @fieldset.Dog, ptr @methodanncounts.Dog, ptr @methodannptrs.Dog, ptr @methodrettags.Dog }
@.strdata.4 = private constant [5 x i8] c"bark\00"
@.strobj.5 = private global %String { i64 4, ptr @.strdata.4, i64 0 }
@.panic = private unnamed_addr constant [61 x i8] c"reflection: Type.method(name) found no method with that name\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.7 = private unnamed_addr constant [17 x i8] c"should not reach\00", align 1
@.str.8 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.9 = private unnamed_addr constant [13 x i8] c"live refused\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"byte=%d\0A\00", align 1
@.str.11 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.12 = private unnamed_addr constant [17 x i8] c"should not reach\00", align 1
@.str.13 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.14 = private unnamed_addr constant [11 x i8] c"new caught\00", align 1
@.strdata.1310 = private constant [20 x i8] c"type was unimported\00"
@.strobj.1311 = private global %String { i64 19, ptr @.strdata.1310, i64 0 }
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }
@__polaron_code = private constant [13 x ptr] [ptr @Dog.Dog, ptr @Dog.bark, ptr @"Dog.~Dog", ptr @main, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @Object.Object, ptr @Exception.Exception, ptr @UnimportedTypeException.UnimportedTypeException, ptr @UnimportedTypeException.message, ptr @Test.__onClassLoad, ptr @Dog.__unimportedCall]

define internal void @Dog.Dog(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %0, i32 0, i32 0
  store ptr @Dog.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %inst.n = load i32, ptr @instances.Dog, align 4
  %1 = add i32 %inst.n, 1
  store i32 %1, ptr @instances.Dog, align 4
  ret void
}

define internal void @Dog.bark(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %1 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.1)
  ret void
}

define internal void @"Dog.~Dog"(ptr %0) {
entry:
  %inst.n = load i32, ptr @instances.Dog, align 4
  %1 = sub i32 %inst.n, 1
  store i32 %1, ptr @instances.Dog, align 4
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown49 = alloca ptr, align 8
  %e45 = alloca ptr, align 8
  %exc.caught38 = alloca ptr, align 8
  %b = alloca ptr, align 8
  %exc.thrown35 = alloca ptr, align 8
  %exc.thrown21 = alloca ptr, align 8
  %exc.thrown15 = alloca ptr, align 8
  %e = alloca ptr, align 8
  %exc.caught = alloca ptr, align 8
  %exc.thrown10 = alloca ptr, align 8
  %m = alloca ptr, align 8
  %mi = alloca i64, align 8
  %t = alloca ptr, align 8
  %exc.thrown5 = alloca ptr, align 8
  %a = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
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
  %alive = load i32, ptr @alive.Dog, align 4
  %16 = icmp eq i32 %alive, 0
  br i1 %16, label %unimported, label %alive.ok

unimported:                                       ; preds = %argv.end
  %unimp.exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UnimportedTypeException, ptr null, i64 1) to i64))
  call void @UnimportedTypeException.UnimportedTypeException(ptr %unimp.exc)
  store ptr %unimp.exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

alive.ok:                                         ; preds = %argv.end
  %Dog.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64))
  call void @Dog.Dog(ptr %Dog.obj)
  store ptr %Dog.obj, ptr %a, align 8
  %alive1 = load i32, ptr @alive.Dog, align 4
  %17 = icmp eq i32 %alive1, 0
  br i1 %17, label %unimported2, label %alive.ok3

unimported2:                                      ; preds = %alive.ok
  %unimp.exc4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UnimportedTypeException, ptr null, i64 1) to i64))
  call void @UnimportedTypeException.UnimportedTypeException(ptr %unimp.exc4)
  store ptr %unimp.exc4, ptr %exc.thrown5, align 8
  call void @_CxxThrowException(ptr %exc.thrown5, ptr @_TI1PEAX)
  unreachable

alive.ok3:                                        ; preds = %alive.ok
  %a6 = load ptr, ptr %a, align 8
  call void @Dog.bark(ptr %a6)
  store ptr @type.Dog, ptr %t, align 8
  %t7 = load ptr, ptr %t, align 8
  %18 = getelementptr inbounds %ReflectType, ptr %t7, i32 0, i32 1
  %19 = load i64, ptr %18, align 8
  %20 = getelementptr inbounds %ReflectType, ptr %t7, i32 0, i32 2
  %21 = load ptr, ptr %20, align 8
  %22 = getelementptr inbounds %ReflectType, ptr %t7, i32 0, i32 3
  %23 = load ptr, ptr %22, align 8
  %24 = getelementptr inbounds %ReflectType, ptr %t7, i32 0, i32 14
  %25 = load ptr, ptr %24, align 8
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.5, i32 0, i32 1), align 8
  %method = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%ReflectMethod, ptr null, i64 1) to i64))
  %26 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 0
  store ptr null, ptr %26, align 8
  %27 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  store ptr null, ptr %27, align 8
  %28 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  store i64 0, ptr %28, align 8
  store i64 0, ptr %mi, align 8
  br label %m.hdr

m.hdr:                                            ; preds = %m.next, %alive.ok3
  %i = load i64, ptr %mi, align 8
  %29 = icmp slt i64 %i, %19
  br i1 %29, label %m.body, label %m.miss

m.body:                                           ; preds = %m.hdr
  %30 = getelementptr ptr, ptr %21, i64 %i
  %mn = load ptr, ptr %30, align 8
  %str.data = getelementptr inbounds %String, ptr %mn, i32 0, i32 1
  %data8 = load ptr, ptr %str.data, align 8
  %31 = call i32 @strcmp(ptr %data8, ptr %data)
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %m.hit, label %m.next

m.hit:                                            ; preds = %m.body
  %33 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 0
  store ptr %mn, ptr %33, align 8
  %34 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  %35 = getelementptr ptr, ptr %23, i64 %i
  %36 = load ptr, ptr %35, align 8
  store ptr %36, ptr %34, align 8
  %37 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  %38 = getelementptr i64, ptr %25, i64 %i
  %39 = load i64, ptr %38, align 8
  store i64 %39, ptr %37, align 8
  br label %m.end

m.next:                                           ; preds = %m.body
  %40 = add i64 %i, 1
  store i64 %40, ptr %mi, align 8
  br label %m.hdr

m.end:                                            ; preds = %m.hit
  store ptr %method, ptr %m, align 8
  %live.n = load i32, ptr @instances.Dog, align 4
  %41 = icmp ne i32 %live.n, 0
  br i1 %41, label %unimport.live, label %unimport.ok

m.miss:                                           ; preds = %m.hdr
  call void @__polaron_panic(ptr @.panic)
  unreachable

ehpad:                                            ; preds = %unimport.live
  %42 = catchswitch within none [label %catch.dispatch] unwind to caller

try.cont:                                         ; preds = %catch.body, %unimport.ok
  %a16 = load ptr, ptr %a, align 8
  call void @__polaron_check_live(ptr %a16)
  %vtbl.addr = getelementptr inbounds %class.Dog, ptr %a16, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %43 = icmp ne ptr %dtor.fn, null
  br i1 %43, label %dtor.call, label %dtor.free

unimport.live:                                    ; preds = %m.end
  %unimp.exc9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UnimportedTypeException, ptr null, i64 1) to i64))
  call void @UnimportedTypeException.UnimportedTypeException(ptr %unimp.exc9)
  store ptr %unimp.exc9, ptr %exc.thrown10, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown10, ptr @_TI1PEAX)
          to label %throw.cont unwind label %ehpad

unimport.ok:                                      ; preds = %m.end
  store i32 0, ptr @alive.Dog, align 4
  store ptr @Dog.__unimportedCall, ptr @Dog.vtable, align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 1), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 2), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 3), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 4), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 5), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 6), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 7), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 8), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 9), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 10), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 11), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 12), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 13), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 14), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 15), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 16), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 17), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 18), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 19), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 20), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 21), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 22), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 23), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 24), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 25), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 26), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 27), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 28), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 29), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 30), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 31), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 32), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 33), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 34), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 35), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 36), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 37), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 38), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 39), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 40), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 41), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 42), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 43), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 44), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 45), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 46), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 47), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 48), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 49), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 50), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 51), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 52), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 53), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 54), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 55), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 56), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 57), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 58), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 59), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 60), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 61), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 62), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 63), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 64), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 65), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 66), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 67), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 68), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 69), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 70), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 71), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 72), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 73), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 74), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 75), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 76), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 77), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 78), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 79), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 80), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 81), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 82), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 83), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 84), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 85), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 86), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 87), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 88), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 89), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 90), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 91), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 92), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 93), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 94), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 95), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 96), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 97), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 98), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 99), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 100), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 101), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 102), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 103), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 104), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 105), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 106), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 107), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 108), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 109), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 110), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 111), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 112), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 113), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 114), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 115), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 116), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 117), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 118), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 119), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 120), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 121), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 122), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 123), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 124), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 125), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 126), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 127), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 128), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 129), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 130), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 131), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 132), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 133), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 134), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 135), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 136), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 137), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 138), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 139), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 140), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 141), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 142), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 143), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 144), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 145), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 146), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 147), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 148), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 149), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 150), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 151), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 152), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 153), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 154), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 155), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 156), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 157), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 158), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 159), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 160), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 161), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 162), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 163), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 164), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 165), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 166), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 167), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 168), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 169), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 170), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 171), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 172), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 173), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 174), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 175), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 176), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 177), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 178), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 179), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 180), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 181), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 182), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 183), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 184), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 185), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 186), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 187), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 188), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 189), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 190), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 191), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 192), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 193), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 194), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 195), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 196), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 197), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 198), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 199), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 200), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 201), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 202), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 203), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 204), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 205), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 206), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 207), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 208), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 209), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 210), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 211), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 212), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 213), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 214), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 215), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 216), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 217), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 218), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 219), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 220), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 221), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 222), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 223), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 224), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 225), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 226), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 227), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 228), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 229), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 230), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 231), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 232), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 233), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 234), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 235), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 236), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 237), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 238), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 239), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 240), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 241), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 242), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 243), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 244), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 245), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 246), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 247), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 248), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 249), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 250), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 251), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 252), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 253), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 254), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 255), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 256), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 257), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 258), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 259), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 260), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 261), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 262), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 263), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 264), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 265), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 266), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 267), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 268), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 269), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 270), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 271), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 272), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 273), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 274), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 275), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 276), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 277), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 278), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 279), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 280), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 281), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 282), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 283), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 284), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 285), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 286), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 287), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 288), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 289), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 290), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 291), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 292), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 293), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 294), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 295), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 296), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 297), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 298), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 299), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 300), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 301), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 302), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 303), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 304), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 305), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 306), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 307), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 308), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 309), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 310), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 311), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 312), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 313), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 314), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 315), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 316), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 317), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 318), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 319), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 320), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 321), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 322), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 323), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 324), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 325), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 326), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 327), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 328), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 329), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 330), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 331), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 332), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 333), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 334), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 335), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 336), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 337), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 338), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 339), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 340), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 341), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 342), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 343), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 344), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 345), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 346), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 347), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 348), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 349), align 8
  %code.base = load ptr, ptr @__polaron_code_base, align 8
  %code.n = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @Dog.bark, ptr %code.base, i64 %code.n)
  %code.base11 = load ptr, ptr @__polaron_code_base, align 8
  %code.n12 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @Dog.Dog, ptr %code.base11, i64 %code.n12)
  %code.base13 = load ptr, ptr @__polaron_code_base, align 8
  %code.n14 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @"Dog.~Dog", ptr %code.base13, i64 %code.n14)
  %44 = call i32 (ptr, ...) @printf(ptr @.str.6, ptr @.str.7)
  br label %try.cont

throw.cont:                                       ; preds = %unimport.live
  unreachable

catch.dispatch:                                   ; preds = %ehpad
  %45 = catchpad within %42 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.caught]
  %caught = load ptr, ptr %exc.caught, align 8
  %exc.vtbl = load ptr, ptr %caught, align 8
  %is = icmp eq ptr %exc.vtbl, @UnimportedTypeException.vtable
  br i1 %is, label %catch.match, label %catch.next

catch.match:                                      ; preds = %catch.dispatch
  store ptr %caught, ptr %e, align 8
  catchret from %45 to label %catch.body

catch.next:                                       ; preds = %catch.dispatch
  catchret from %45 to label %rethrow

catch.body:                                       ; preds = %catch.match
  %46 = call i32 (ptr, ...) @printf(ptr @.str.8, ptr @.str.9)
  br label %try.cont

rethrow:                                          ; preds = %catch.next
  %rethrow.obj = load ptr, ptr %exc.caught, align 8
  store ptr %rethrow.obj, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

dtor.call:                                        ; preds = %try.cont
  call void %dtor.fn(ptr %a16)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %try.cont
  call void @__polaron_free(ptr %a16)
  %live.n17 = load i32, ptr @instances.Dog, align 4
  %47 = icmp ne i32 %live.n17, 0
  br i1 %47, label %unimport.live18, label %unimport.ok19

unimport.live18:                                  ; preds = %dtor.free
  %unimp.exc20 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UnimportedTypeException, ptr null, i64 1) to i64))
  call void @UnimportedTypeException.UnimportedTypeException(ptr %unimp.exc20)
  store ptr %unimp.exc20, ptr %exc.thrown21, align 8
  call void @_CxxThrowException(ptr %exc.thrown21, ptr @_TI1PEAX)
  unreachable

unimport.ok19:                                    ; preds = %dtor.free
  store i32 0, ptr @alive.Dog, align 4
  store ptr @Dog.__unimportedCall, ptr @Dog.vtable, align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 1), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 2), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 3), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 4), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 5), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 6), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 7), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 8), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 9), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 10), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 11), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 12), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 13), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 14), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 15), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 16), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 17), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 18), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 19), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 20), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 21), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 22), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 23), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 24), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 25), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 26), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 27), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 28), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 29), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 30), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 31), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 32), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 33), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 34), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 35), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 36), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 37), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 38), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 39), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 40), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 41), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 42), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 43), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 44), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 45), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 46), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 47), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 48), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 49), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 50), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 51), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 52), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 53), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 54), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 55), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 56), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 57), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 58), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 59), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 60), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 61), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 62), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 63), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 64), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 65), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 66), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 67), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 68), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 69), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 70), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 71), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 72), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 73), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 74), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 75), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 76), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 77), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 78), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 79), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 80), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 81), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 82), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 83), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 84), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 85), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 86), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 87), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 88), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 89), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 90), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 91), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 92), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 93), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 94), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 95), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 96), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 97), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 98), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 99), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 100), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 101), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 102), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 103), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 104), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 105), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 106), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 107), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 108), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 109), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 110), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 111), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 112), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 113), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 114), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 115), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 116), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 117), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 118), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 119), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 120), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 121), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 122), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 123), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 124), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 125), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 126), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 127), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 128), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 129), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 130), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 131), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 132), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 133), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 134), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 135), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 136), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 137), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 138), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 139), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 140), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 141), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 142), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 143), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 144), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 145), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 146), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 147), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 148), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 149), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 150), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 151), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 152), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 153), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 154), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 155), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 156), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 157), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 158), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 159), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 160), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 161), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 162), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 163), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 164), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 165), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 166), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 167), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 168), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 169), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 170), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 171), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 172), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 173), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 174), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 175), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 176), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 177), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 178), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 179), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 180), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 181), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 182), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 183), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 184), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 185), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 186), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 187), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 188), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 189), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 190), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 191), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 192), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 193), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 194), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 195), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 196), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 197), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 198), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 199), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 200), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 201), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 202), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 203), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 204), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 205), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 206), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 207), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 208), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 209), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 210), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 211), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 212), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 213), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 214), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 215), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 216), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 217), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 218), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 219), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 220), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 221), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 222), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 223), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 224), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 225), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 226), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 227), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 228), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 229), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 230), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 231), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 232), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 233), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 234), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 235), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 236), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 237), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 238), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 239), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 240), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 241), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 242), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 243), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 244), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 245), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 246), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 247), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 248), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 249), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 250), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 251), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 252), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 253), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 254), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 255), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 256), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 257), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 258), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 259), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 260), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 261), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 262), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 263), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 264), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 265), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 266), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 267), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 268), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 269), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 270), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 271), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 272), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 273), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 274), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 275), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 276), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 277), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 278), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 279), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 280), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 281), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 282), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 283), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 284), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 285), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 286), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 287), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 288), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 289), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 290), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 291), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 292), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 293), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 294), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 295), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 296), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 297), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 298), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 299), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 300), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 301), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 302), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 303), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 304), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 305), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 306), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 307), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 308), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 309), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 310), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 311), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 312), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 313), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 314), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 315), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 316), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 317), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 318), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 319), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 320), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 321), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 322), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 323), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 324), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 325), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 326), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 327), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 328), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 329), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 330), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 331), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 332), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 333), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 334), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 335), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 336), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 337), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 338), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 339), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 340), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 341), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 342), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 343), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 344), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 345), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 346), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 347), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 348), align 8
  store ptr @Dog.__unimportedCall, ptr getelementptr inbounds ([350 x ptr], ptr @Dog.vtable, i32 0, i32 349), align 8
  %code.base22 = load ptr, ptr @__polaron_code_base, align 8
  %code.n23 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @Dog.bark, ptr %code.base22, i64 %code.n23)
  %code.base24 = load ptr, ptr @__polaron_code_base, align 8
  %code.n25 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @Dog.Dog, ptr %code.base24, i64 %code.n25)
  %code.base26 = load ptr, ptr @__polaron_code_base, align 8
  %code.n27 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @"Dog.~Dog", ptr %code.base26, i64 %code.n27)
  %m28 = load ptr, ptr %m, align 8
  %48 = getelementptr inbounds %ReflectMethod, ptr %m28, i32 0, i32 1
  %m.fn = load ptr, ptr %48, align 8
  %byte = load i8, ptr %m.fn, align 1
  %49 = zext i8 %byte to i32
  %50 = call i32 (ptr, ...) @printf(ptr @.str.10, i32 %49)
  %alive31 = load i32, ptr @alive.Dog, align 4
  %51 = icmp eq i32 %alive31, 0
  br i1 %51, label %unimported32, label %alive.ok33

ehpad29:                                          ; preds = %alive.ok33, %unimported32
  %52 = catchswitch within none [label %catch.dispatch39] unwind to caller

try.cont30:                                       ; preds = %catch.body46, %invoke.cont
  ret i32 0

unimported32:                                     ; preds = %unimport.ok19
  %unimp.exc34 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UnimportedTypeException, ptr null, i64 1) to i64))
  call void @UnimportedTypeException.UnimportedTypeException(ptr %unimp.exc34)
  store ptr %unimp.exc34, ptr %exc.thrown35, align 8
  invoke void @_CxxThrowException(ptr %exc.thrown35, ptr @_TI1PEAX)
          to label %throw.cont36 unwind label %ehpad29

alive.ok33:                                       ; preds = %unimport.ok19
  %Dog.obj37 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dog, ptr null, i64 1) to i64))
  invoke void @Dog.Dog(ptr %Dog.obj37)
          to label %invoke.cont unwind label %ehpad29

throw.cont36:                                     ; preds = %unimported32
  unreachable

invoke.cont:                                      ; preds = %alive.ok33
  store ptr %Dog.obj37, ptr %b, align 8
  %53 = call i32 (ptr, ...) @printf(ptr @.str.11, ptr @.str.12)
  br label %try.cont30

catch.dispatch39:                                 ; preds = %ehpad29
  %54 = catchpad within %52 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.caught38]
  %caught40 = load ptr, ptr %exc.caught38, align 8
  %exc.vtbl41 = load ptr, ptr %caught40, align 8
  %is42 = icmp eq ptr %exc.vtbl41, @UnimportedTypeException.vtable
  br i1 %is42, label %catch.match43, label %catch.next44

catch.match43:                                    ; preds = %catch.dispatch39
  store ptr %caught40, ptr %e45, align 8
  catchret from %54 to label %catch.body46

catch.next44:                                     ; preds = %catch.dispatch39
  catchret from %54 to label %rethrow47

catch.body46:                                     ; preds = %catch.match43
  %55 = call i32 (ptr, ...) @printf(ptr @.str.13, ptr @.str.14)
  br label %try.cont30

rethrow47:                                        ; preds = %catch.next44
  %rethrow.obj48 = load ptr, ptr %exc.caught38, align 8
  store ptr %rethrow.obj48, ptr %exc.thrown49, align 8
  call void @_CxxThrowException(ptr %exc.thrown49, ptr @_TI1PEAX)
  unreachable
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

define internal void @UnimportedTypeException.UnimportedTypeException(ptr %0) {
entry:
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.UnimportedTypeException, ptr %0, i32 0, i32 0
  store ptr @UnimportedTypeException.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal ptr @UnimportedTypeException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1311)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5323)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5325)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare i32 @strcmp(ptr, ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

define internal void @Dog.__unimportedCall(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %unimp.exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UnimportedTypeException, ptr null, i64 1) to i64))
  call void @UnimportedTypeException.UnimportedTypeException(ptr %unimp.exc)
  store ptr %unimp.exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable
}

declare void @__polaron_unload_fn(ptr, ptr, i64)

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
