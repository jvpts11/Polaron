; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_arg_passing.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_arg_passing.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Timber = type { ptr, i32 }
%class.Crate = type { ptr, i64 }
%class.Cart = type { ptr, i64 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Timber.vtable = private constant [352 x ptr] [ptr @Timber.weight, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Crate.vtable = private constant [352 x ptr] [ptr null, ptr @Crate.weighs, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Cart.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr @Cart.carries, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Timber.Oak.__inst = private global ptr null
@Timber.Pine.__inst = private global ptr null
@.str = private unnamed_addr constant [25 x i8] c"m=%d %d %d c=%d e=%d %d\0A\00", align 1
@Cart.Light.__inst = private global ptr null
@Cart.Heavy.__inst = private global ptr null
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Timber.Timber(ptr %0, i32 %1) {
entry:
  %w = alloca i32, align 4
  store i32 %1, ptr %w, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Timber, ptr %0, i32 0, i32 0
  store ptr @Timber.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %w1 = getelementptr inbounds %class.Timber, ptr %0, i32 0, i32 1
  %w2 = load i32, ptr %w, align 4
  store i32 %w2, ptr %w1, align 4, !tbaa !4
  ret void
}

define internal i32 @Timber.weight(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %w = getelementptr inbounds %class.Timber, ptr %0, i32 0, i32 1
  %w1 = load i32, ptr %w, align 4, !tbaa !4
  ret i32 %w1
}

define internal i32 @Scale.weigh(i64 %0) {
entry:
  %cat.res = alloca i32, align 4
  %h = alloca i64, align 8
  store i64 %0, ptr %h, align 8
  %h1 = load i64, ptr %h, align 8
  %cat.ord = trunc i64 %h1 to i32
  %1 = lshr i64 %h1, 32
  %cat.id = trunc i64 %1 to i32
  store i32 0, ptr %cat.res, align 4
  switch i32 %cat.id, label %cat.default [
    i32 0, label %cat.Ingot
    i32 1, label %cat.Stone
    i32 2, label %cat.Timber
  ]

cat.cont:                                         ; preds = %cat.default, %enumc.done5, %cat.Stone, %cat.Ingot
  %cat.result = load i32, ptr %cat.res, align 4
  ret i32 %cat.result

cat.default:                                      ; preds = %entry
  br label %cat.cont

cat.Ingot:                                        ; preds = %entry
  %2 = call i32 @Ingot.weight(i32 %cat.ord)
  store i32 %2, ptr %cat.res, align 4
  br label %cat.cont

cat.Stone:                                        ; preds = %entry
  %3 = call i32 @Stone.weight(i32 %cat.ord)
  store i32 %3, ptr %cat.res, align 4
  br label %cat.cont

cat.Timber:                                       ; preds = %entry
  %enum.cur = load ptr, ptr @Timber.Oak.__inst, align 8
  %4 = icmp eq ptr %enum.cur, null
  br i1 %4, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %cat.Timber
  %Timber = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Timber, ptr null, i64 1) to i64))
  call void @Timber.Timber(ptr %Timber, i32 30)
  store ptr %Timber, ptr @Timber.Oak.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %cat.Timber
  %Timber2 = load ptr, ptr @Timber.Oak.__inst, align 8
  %5 = icmp eq i32 %cat.ord, 0
  %enum.singleton = select i1 %5, ptr %Timber2, ptr null
  %enum.cur3 = load ptr, ptr @Timber.Pine.__inst, align 8
  %6 = icmp eq ptr %enum.cur3, null
  br i1 %6, label %enumc.init4, label %enumc.done5

enumc.init4:                                      ; preds = %enumc.done
  %Timber6 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Timber, ptr null, i64 1) to i64))
  call void @Timber.Timber(ptr %Timber6, i32 20)
  store ptr %Timber6, ptr @Timber.Pine.__inst, align 8
  br label %enumc.done5

enumc.done5:                                      ; preds = %enumc.init4, %enumc.done
  %Timber7 = load ptr, ptr @Timber.Pine.__inst, align 8
  %7 = icmp eq i32 %cat.ord, 1
  %enum.singleton8 = select i1 %7, ptr %Timber7, ptr %enum.singleton
  %8 = call i32 @Timber.weight(ptr %enum.singleton8)
  store i32 %8, ptr %cat.res, align 4
  br label %cat.cont
}

define internal void @Crate.Crate(ptr %0, i64 %1) {
entry:
  %load = alloca i64, align 8
  store i64 %1, ptr %load, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Crate, ptr %0, i32 0, i32 0
  store ptr @Crate.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %load1 = getelementptr inbounds %class.Crate, ptr %0, i32 0, i32 1
  %load2 = load i64, ptr %load, align 8
  store i64 %load2, ptr %load1, align 8, !tbaa !6
  ret void
}

define internal i32 @Crate.weighs(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %cat.res = alloca i32, align 4
  %load = getelementptr inbounds %class.Crate, ptr %0, i32 0, i32 1
  %load1 = load i64, ptr %load, align 8, !tbaa !6
  %cat.ord = trunc i64 %load1 to i32
  %1 = lshr i64 %load1, 32
  %cat.id = trunc i64 %1 to i32
  store i32 0, ptr %cat.res, align 4
  switch i32 %cat.id, label %cat.default [
    i32 0, label %cat.Ingot
    i32 1, label %cat.Stone
    i32 2, label %cat.Timber
  ]

cat.cont:                                         ; preds = %cat.default, %enumc.done5, %cat.Stone, %cat.Ingot
  %cat.result = load i32, ptr %cat.res, align 4
  ret i32 %cat.result

cat.default:                                      ; preds = %entry
  br label %cat.cont

cat.Ingot:                                        ; preds = %entry
  %2 = call i32 @Ingot.weight(i32 %cat.ord)
  store i32 %2, ptr %cat.res, align 4
  br label %cat.cont

cat.Stone:                                        ; preds = %entry
  %3 = call i32 @Stone.weight(i32 %cat.ord)
  store i32 %3, ptr %cat.res, align 4
  br label %cat.cont

cat.Timber:                                       ; preds = %entry
  %enum.cur = load ptr, ptr @Timber.Oak.__inst, align 8
  %4 = icmp eq ptr %enum.cur, null
  br i1 %4, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %cat.Timber
  %Timber = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Timber, ptr null, i64 1) to i64))
  call void @Timber.Timber(ptr %Timber, i32 30)
  store ptr %Timber, ptr @Timber.Oak.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %cat.Timber
  %Timber2 = load ptr, ptr @Timber.Oak.__inst, align 8
  %5 = icmp eq i32 %cat.ord, 0
  %enum.singleton = select i1 %5, ptr %Timber2, ptr null
  %enum.cur3 = load ptr, ptr @Timber.Pine.__inst, align 8
  %6 = icmp eq ptr %enum.cur3, null
  br i1 %6, label %enumc.init4, label %enumc.done5

enumc.init4:                                      ; preds = %enumc.done
  %Timber6 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Timber, ptr null, i64 1) to i64))
  call void @Timber.Timber(ptr %Timber6, i32 20)
  store ptr %Timber6, ptr @Timber.Pine.__inst, align 8
  br label %enumc.done5

enumc.done5:                                      ; preds = %enumc.init4, %enumc.done
  %Timber7 = load ptr, ptr @Timber.Pine.__inst, align 8
  %7 = icmp eq i32 %cat.ord, 1
  %enum.singleton8 = select i1 %7, ptr %Timber7, ptr %enum.singleton
  %8 = call i32 @Timber.weight(ptr %enum.singleton8)
  store i32 %8, ptr %cat.res, align 4
  br label %cat.cont
}

define internal void @Cart.Cart(ptr %0, i64 %1) {
entry:
  %load = alloca i64, align 8
  store i64 %1, ptr %load, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Cart, ptr %0, i32 0, i32 0
  store ptr @Cart.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %load1 = getelementptr inbounds %class.Cart, ptr %0, i32 0, i32 1
  %load2 = load i64, ptr %load, align 8
  store i64 %load2, ptr %load1, align 8, !tbaa !6
  ret void
}

define internal i32 @Cart.carries(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %cat.res = alloca i32, align 4
  %load = getelementptr inbounds %class.Cart, ptr %0, i32 0, i32 1
  %load1 = load i64, ptr %load, align 8, !tbaa !6
  %cat.ord = trunc i64 %load1 to i32
  %1 = lshr i64 %load1, 32
  %cat.id = trunc i64 %1 to i32
  store i32 0, ptr %cat.res, align 4
  switch i32 %cat.id, label %cat.default [
    i32 0, label %cat.Ingot
    i32 1, label %cat.Stone
    i32 2, label %cat.Timber
  ]

cat.cont:                                         ; preds = %cat.default, %enumc.done5, %cat.Stone, %cat.Ingot
  %cat.result = load i32, ptr %cat.res, align 4
  ret i32 %cat.result

cat.default:                                      ; preds = %entry
  br label %cat.cont

cat.Ingot:                                        ; preds = %entry
  %2 = call i32 @Ingot.weight(i32 %cat.ord)
  store i32 %2, ptr %cat.res, align 4
  br label %cat.cont

cat.Stone:                                        ; preds = %entry
  %3 = call i32 @Stone.weight(i32 %cat.ord)
  store i32 %3, ptr %cat.res, align 4
  br label %cat.cont

cat.Timber:                                       ; preds = %entry
  %enum.cur = load ptr, ptr @Timber.Oak.__inst, align 8
  %4 = icmp eq ptr %enum.cur, null
  br i1 %4, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %cat.Timber
  %Timber = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Timber, ptr null, i64 1) to i64))
  call void @Timber.Timber(ptr %Timber, i32 30)
  store ptr %Timber, ptr @Timber.Oak.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %cat.Timber
  %Timber2 = load ptr, ptr @Timber.Oak.__inst, align 8
  %5 = icmp eq i32 %cat.ord, 0
  %enum.singleton = select i1 %5, ptr %Timber2, ptr null
  %enum.cur3 = load ptr, ptr @Timber.Pine.__inst, align 8
  %6 = icmp eq ptr %enum.cur3, null
  br i1 %6, label %enumc.init4, label %enumc.done5

enumc.init4:                                      ; preds = %enumc.done
  %Timber6 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Timber, ptr null, i64 1) to i64))
  call void @Timber.Timber(ptr %Timber6, i32 20)
  store ptr %Timber6, ptr @Timber.Pine.__inst, align 8
  br label %enumc.done5

enumc.done5:                                      ; preds = %enumc.init4, %enumc.done
  %Timber7 = load ptr, ptr @Timber.Pine.__inst, align 8
  %7 = icmp eq i32 %cat.ord, 1
  %enum.singleton8 = select i1 %7, ptr %Timber7, ptr %enum.singleton
  %8 = call i32 @Timber.weight(ptr %enum.singleton8)
  store i32 %8, ptr %cat.res, align 4
  br label %cat.cont
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca ptr, align 8
  %Crate.obj = alloca %class.Crate, align 8
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
  %enum.cur = load ptr, ptr @Timber.Oak.__inst, align 8
  %16 = icmp eq ptr %enum.cur, null
  br i1 %16, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %argv.end
  %Timber = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Timber, ptr null, i64 1) to i64))
  call void @Timber.Timber(ptr %Timber, i32 30)
  store ptr %Timber, ptr @Timber.Oak.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %argv.end
  %Timber1 = load ptr, ptr @Timber.Oak.__inst, align 8
  %enum.ord.cur = load ptr, ptr @Timber.Oak.__inst, align 8
  %17 = icmp eq ptr %Timber1, %enum.ord.cur
  %enum.ord = select i1 %17, i32 0, i32 -1
  %enum.ord.cur2 = load ptr, ptr @Timber.Pine.__inst, align 8
  %18 = icmp eq ptr %Timber1, %enum.ord.cur2
  %enum.ord3 = select i1 %18, i32 1, i32 %enum.ord
  %19 = zext i32 %enum.ord3 to i64
  %20 = or i64 %19, 8589934592
  call void @Crate.Crate(ptr %Crate.obj, i64 %20)
  store ptr %Crate.obj, ptr %c, align 8
  %21 = call i32 @Scale.weigh(i64 1)
  %22 = call i32 @Scale.weigh(i64 4294967297)
  %enum.cur4 = load ptr, ptr @Timber.Pine.__inst, align 8
  %23 = icmp eq ptr %enum.cur4, null
  br i1 %23, label %enumc.init5, label %enumc.done6

enumc.init5:                                      ; preds = %enumc.done
  %Timber7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Timber, ptr null, i64 1) to i64))
  call void @Timber.Timber(ptr %Timber7, i32 20)
  store ptr %Timber7, ptr @Timber.Pine.__inst, align 8
  br label %enumc.done6

enumc.done6:                                      ; preds = %enumc.init5, %enumc.done
  %Timber8 = load ptr, ptr @Timber.Pine.__inst, align 8
  %enum.ord.cur9 = load ptr, ptr @Timber.Oak.__inst, align 8
  %24 = icmp eq ptr %Timber8, %enum.ord.cur9
  %enum.ord10 = select i1 %24, i32 0, i32 -1
  %enum.ord.cur11 = load ptr, ptr @Timber.Pine.__inst, align 8
  %25 = icmp eq ptr %Timber8, %enum.ord.cur11
  %enum.ord12 = select i1 %25, i32 1, i32 %enum.ord10
  %26 = zext i32 %enum.ord12 to i64
  %27 = or i64 %26, 8589934592
  %28 = call i32 @Scale.weigh(i64 %27)
  %c13 = load ptr, ptr %c, align 8
  %29 = call i32 @Crate.weighs(ptr %c13)
  %enum.cur14 = load ptr, ptr @Cart.Light.__inst, align 8
  %30 = icmp eq ptr %enum.cur14, null
  br i1 %30, label %enumc.init15, label %enumc.done16

enumc.init15:                                     ; preds = %enumc.done6
  %Cart = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Cart, ptr null, i64 1) to i64))
  call void @Cart.Cart(ptr %Cart, i64 0)
  store ptr %Cart, ptr @Cart.Light.__inst, align 8
  br label %enumc.done16

enumc.done16:                                     ; preds = %enumc.init15, %enumc.done6
  %Cart17 = load ptr, ptr @Cart.Light.__inst, align 8
  %31 = call i32 @Cart.carries(ptr %Cart17)
  %enum.cur18 = load ptr, ptr @Cart.Heavy.__inst, align 8
  %32 = icmp eq ptr %enum.cur18, null
  br i1 %32, label %enumc.init19, label %enumc.done20

enumc.init19:                                     ; preds = %enumc.done16
  %Cart21 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Cart, ptr null, i64 1) to i64))
  call void @Cart.Cart(ptr %Cart21, i64 4294967297)
  store ptr %Cart21, ptr @Cart.Heavy.__inst, align 8
  br label %enumc.done20

enumc.done20:                                     ; preds = %enumc.init19, %enumc.done16
  %Cart22 = load ptr, ptr @Cart.Heavy.__inst, align 8
  %33 = call i32 @Cart.carries(ptr %Cart22)
  %34 = call i32 (ptr, ...) @printf(ptr @.str, i32 %21, i32 %22, i32 %28, i32 %29, i32 %31, i32 %33)
  ret i32 0
}

define internal i32 @Ingot.weight(i32 %0) {
entry:
  %1 = icmp eq i32 %0, 0
  %2 = zext i1 %1 to i32
  %tern.c = icmp ne i32 %2, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %entry
  br label %tern.end

tern.else:                                        ; preds = %entry
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ 7, %tern.then ], [ 11, %tern.else ]
  ret i32 %tern
}

define internal i32 @Stone.weight(i32 %0) {
entry:
  %1 = icmp eq i32 %0, 0
  %2 = zext i1 %1 to i32
  %tern.c = icmp ne i32 %2, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %entry
  br label %tern.end

tern.else:                                        ; preds = %entry
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ 100, %tern.then ], [ 200, %tern.else ]
  ret i32 %tern
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

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
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
