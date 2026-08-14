; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_java_mixed_dispatch.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/catalog_java_mixed_dispatch.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.AppLevel = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@AppLevel.vtable = private constant [350 x ptr] [ptr @AppLevel.weight, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@AppLevel.a.__inst = private global ptr null
@AppLevel.low.__inst = private global ptr null
@.str = private unnamed_addr constant [19 x i8] c"w1=%d w2=%d w3=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @AppLevel.AppLevel(ptr %0, i32 %1) {
entry:
  %heft = alloca i32, align 4
  store i32 %1, ptr %heft, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.AppLevel, ptr %0, i32 0, i32 0
  store ptr @AppLevel.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %heft1 = getelementptr inbounds %class.AppLevel, ptr %0, i32 0, i32 1
  %heft2 = load i32, ptr %heft, align 4
  store i32 %heft2, ptr %heft1, align 4, !tbaa !4
  ret void
}

define internal i32 @AppLevel.weight(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %heft = getelementptr inbounds %class.AppLevel, ptr %0, i32 0, i32 1
  %heft1 = load i32, ptr %heft, align 4, !tbaa !4
  ret i32 %heft1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %cat.res49 = alloca i32, align 4
  %cat.res28 = alloca i32, align 4
  %cat.res = alloca i32, align 4
  %t3 = alloca i64, align 8
  %t2 = alloca i64, align 8
  %t1 = alloca i64, align 8
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
  %enum.cur = load ptr, ptr @AppLevel.a.__inst, align 8
  %16 = icmp eq ptr %enum.cur, null
  br i1 %16, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %argv.end
  %AppLevel = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.AppLevel, ptr null, i64 1) to i64))
  call void @AppLevel.AppLevel(ptr %AppLevel, i32 7)
  store ptr %AppLevel, ptr @AppLevel.a.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %argv.end
  %AppLevel1 = load ptr, ptr @AppLevel.a.__inst, align 8
  %enum.ord.cur = load ptr, ptr @AppLevel.a.__inst, align 8
  %17 = icmp eq ptr %AppLevel1, %enum.ord.cur
  %enum.ord = select i1 %17, i32 0, i32 -1
  %enum.ord.cur2 = load ptr, ptr @AppLevel.low.__inst, align 8
  %18 = icmp eq ptr %AppLevel1, %enum.ord.cur2
  %enum.ord3 = select i1 %18, i32 1, i32 %enum.ord
  %19 = zext i32 %enum.ord3 to i64
  %20 = or i64 %19, 4294967296
  store i64 %20, ptr %t1, align 8
  store i64 0, ptr %t2, align 8
  %enum.cur4 = load ptr, ptr @AppLevel.low.__inst, align 8
  %21 = icmp eq ptr %enum.cur4, null
  br i1 %21, label %enumc.init5, label %enumc.done6

enumc.init5:                                      ; preds = %enumc.done
  %AppLevel7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.AppLevel, ptr null, i64 1) to i64))
  call void @AppLevel.AppLevel(ptr %AppLevel7, i32 9)
  store ptr %AppLevel7, ptr @AppLevel.low.__inst, align 8
  br label %enumc.done6

enumc.done6:                                      ; preds = %enumc.init5, %enumc.done
  %AppLevel8 = load ptr, ptr @AppLevel.low.__inst, align 8
  %enum.ord.cur9 = load ptr, ptr @AppLevel.a.__inst, align 8
  %22 = icmp eq ptr %AppLevel8, %enum.ord.cur9
  %enum.ord10 = select i1 %22, i32 0, i32 -1
  %enum.ord.cur11 = load ptr, ptr @AppLevel.low.__inst, align 8
  %23 = icmp eq ptr %AppLevel8, %enum.ord.cur11
  %enum.ord12 = select i1 %23, i32 1, i32 %enum.ord10
  %24 = zext i32 %enum.ord12 to i64
  %25 = or i64 %24, 4294967296
  store i64 %25, ptr %t3, align 8
  %t113 = load i64, ptr %t1, align 8
  %cat.ord = trunc i64 %t113 to i32
  %26 = lshr i64 %t113, 32
  %cat.id = trunc i64 %26 to i32
  store i32 0, ptr %cat.res, align 4
  switch i32 %cat.id, label %cat.default [
    i32 0, label %cat.SysLevel
    i32 1, label %cat.AppLevel
  ]

cat.cont:                                         ; preds = %cat.default, %enumc.done21, %cat.SysLevel
  %cat.result = load i32, ptr %cat.res, align 4
  %t225 = load i64, ptr %t2, align 8
  %cat.ord26 = trunc i64 %t225 to i32
  %27 = lshr i64 %t225, 32
  %cat.id27 = trunc i64 %27 to i32
  store i32 0, ptr %cat.res28, align 4
  switch i32 %cat.id27, label %cat.default30 [
    i32 0, label %cat.SysLevel31
    i32 1, label %cat.AppLevel32
  ]

cat.default:                                      ; preds = %enumc.done6
  br label %cat.cont

cat.SysLevel:                                     ; preds = %enumc.done6
  %28 = call i32 @SysLevel.weight(i32 %cat.ord)
  store i32 %28, ptr %cat.res, align 4
  br label %cat.cont

cat.AppLevel:                                     ; preds = %enumc.done6
  %enum.cur14 = load ptr, ptr @AppLevel.a.__inst, align 8
  %29 = icmp eq ptr %enum.cur14, null
  br i1 %29, label %enumc.init15, label %enumc.done16

enumc.init15:                                     ; preds = %cat.AppLevel
  %AppLevel17 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.AppLevel, ptr null, i64 1) to i64))
  call void @AppLevel.AppLevel(ptr %AppLevel17, i32 7)
  store ptr %AppLevel17, ptr @AppLevel.a.__inst, align 8
  br label %enumc.done16

enumc.done16:                                     ; preds = %enumc.init15, %cat.AppLevel
  %AppLevel18 = load ptr, ptr @AppLevel.a.__inst, align 8
  %30 = icmp eq i32 %cat.ord, 0
  %enum.singleton = select i1 %30, ptr %AppLevel18, ptr null
  %enum.cur19 = load ptr, ptr @AppLevel.low.__inst, align 8
  %31 = icmp eq ptr %enum.cur19, null
  br i1 %31, label %enumc.init20, label %enumc.done21

enumc.init20:                                     ; preds = %enumc.done16
  %AppLevel22 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.AppLevel, ptr null, i64 1) to i64))
  call void @AppLevel.AppLevel(ptr %AppLevel22, i32 9)
  store ptr %AppLevel22, ptr @AppLevel.low.__inst, align 8
  br label %enumc.done21

enumc.done21:                                     ; preds = %enumc.init20, %enumc.done16
  %AppLevel23 = load ptr, ptr @AppLevel.low.__inst, align 8
  %32 = icmp eq i32 %cat.ord, 1
  %enum.singleton24 = select i1 %32, ptr %AppLevel23, ptr %enum.singleton
  %33 = call i32 @AppLevel.weight(ptr %enum.singleton24)
  store i32 %33, ptr %cat.res, align 4
  br label %cat.cont

cat.cont29:                                       ; preds = %cat.default30, %enumc.done41, %cat.SysLevel31
  %cat.result45 = load i32, ptr %cat.res28, align 4
  %t346 = load i64, ptr %t3, align 8
  %cat.ord47 = trunc i64 %t346 to i32
  %34 = lshr i64 %t346, 32
  %cat.id48 = trunc i64 %34 to i32
  store i32 0, ptr %cat.res49, align 4
  switch i32 %cat.id48, label %cat.default51 [
    i32 0, label %cat.SysLevel52
    i32 1, label %cat.AppLevel53
  ]

cat.default30:                                    ; preds = %cat.cont
  br label %cat.cont29

cat.SysLevel31:                                   ; preds = %cat.cont
  %35 = call i32 @SysLevel.weight(i32 %cat.ord26)
  store i32 %35, ptr %cat.res28, align 4
  br label %cat.cont29

cat.AppLevel32:                                   ; preds = %cat.cont
  %enum.cur33 = load ptr, ptr @AppLevel.a.__inst, align 8
  %36 = icmp eq ptr %enum.cur33, null
  br i1 %36, label %enumc.init34, label %enumc.done35

enumc.init34:                                     ; preds = %cat.AppLevel32
  %AppLevel36 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.AppLevel, ptr null, i64 1) to i64))
  call void @AppLevel.AppLevel(ptr %AppLevel36, i32 7)
  store ptr %AppLevel36, ptr @AppLevel.a.__inst, align 8
  br label %enumc.done35

enumc.done35:                                     ; preds = %enumc.init34, %cat.AppLevel32
  %AppLevel37 = load ptr, ptr @AppLevel.a.__inst, align 8
  %37 = icmp eq i32 %cat.ord26, 0
  %enum.singleton38 = select i1 %37, ptr %AppLevel37, ptr null
  %enum.cur39 = load ptr, ptr @AppLevel.low.__inst, align 8
  %38 = icmp eq ptr %enum.cur39, null
  br i1 %38, label %enumc.init40, label %enumc.done41

enumc.init40:                                     ; preds = %enumc.done35
  %AppLevel42 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.AppLevel, ptr null, i64 1) to i64))
  call void @AppLevel.AppLevel(ptr %AppLevel42, i32 9)
  store ptr %AppLevel42, ptr @AppLevel.low.__inst, align 8
  br label %enumc.done41

enumc.done41:                                     ; preds = %enumc.init40, %enumc.done35
  %AppLevel43 = load ptr, ptr @AppLevel.low.__inst, align 8
  %39 = icmp eq i32 %cat.ord26, 1
  %enum.singleton44 = select i1 %39, ptr %AppLevel43, ptr %enum.singleton38
  %40 = call i32 @AppLevel.weight(ptr %enum.singleton44)
  store i32 %40, ptr %cat.res28, align 4
  br label %cat.cont29

cat.cont50:                                       ; preds = %cat.default51, %enumc.done62, %cat.SysLevel52
  %cat.result66 = load i32, ptr %cat.res49, align 4
  %41 = call i32 (ptr, ...) @printf(ptr @.str, i32 %cat.result, i32 %cat.result45, i32 %cat.result66)
  ret i32 0

cat.default51:                                    ; preds = %cat.cont29
  br label %cat.cont50

cat.SysLevel52:                                   ; preds = %cat.cont29
  %42 = call i32 @SysLevel.weight(i32 %cat.ord47)
  store i32 %42, ptr %cat.res49, align 4
  br label %cat.cont50

cat.AppLevel53:                                   ; preds = %cat.cont29
  %enum.cur54 = load ptr, ptr @AppLevel.a.__inst, align 8
  %43 = icmp eq ptr %enum.cur54, null
  br i1 %43, label %enumc.init55, label %enumc.done56

enumc.init55:                                     ; preds = %cat.AppLevel53
  %AppLevel57 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.AppLevel, ptr null, i64 1) to i64))
  call void @AppLevel.AppLevel(ptr %AppLevel57, i32 7)
  store ptr %AppLevel57, ptr @AppLevel.a.__inst, align 8
  br label %enumc.done56

enumc.done56:                                     ; preds = %enumc.init55, %cat.AppLevel53
  %AppLevel58 = load ptr, ptr @AppLevel.a.__inst, align 8
  %44 = icmp eq i32 %cat.ord47, 0
  %enum.singleton59 = select i1 %44, ptr %AppLevel58, ptr null
  %enum.cur60 = load ptr, ptr @AppLevel.low.__inst, align 8
  %45 = icmp eq ptr %enum.cur60, null
  br i1 %45, label %enumc.init61, label %enumc.done62

enumc.init61:                                     ; preds = %enumc.done56
  %AppLevel63 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.AppLevel, ptr null, i64 1) to i64))
  call void @AppLevel.AppLevel(ptr %AppLevel63, i32 9)
  store ptr %AppLevel63, ptr @AppLevel.low.__inst, align 8
  br label %enumc.done62

enumc.done62:                                     ; preds = %enumc.init61, %enumc.done56
  %AppLevel64 = load ptr, ptr @AppLevel.low.__inst, align 8
  %46 = icmp eq i32 %cat.ord47, 1
  %enum.singleton65 = select i1 %46, ptr %AppLevel64, ptr %enum.singleton59
  %47 = call i32 @AppLevel.weight(ptr %enum.singleton65)
  store i32 %47, ptr %cat.res49, align 4
  br label %cat.cont50
}

define internal i32 @SysLevel.weight(i32 %0) {
entry:
  ret i32 42
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
