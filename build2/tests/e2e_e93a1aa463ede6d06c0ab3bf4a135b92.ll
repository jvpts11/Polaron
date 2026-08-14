; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/option.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/option.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.Just$int" = type { ptr, i32 }
%"class.Nothing$int" = type { ptr }
%"class.Maybe$int" = type { ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"Nothing$int.vtable" = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Maybe$int.isSome", ptr @"Maybe$int.orElse", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Maybe$int.vtable" = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Maybe$int.isSome", ptr @"Maybe$int.orElse", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Just$int.vtable" = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Just$int.isSome", ptr @"Just$int.orElse", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [19 x i8] c"a: some=%d val=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [19 x i8] c"b: some=%d val=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
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
  %"Just$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Just$int", ptr null, i64 1) to i64))
  call void @"Just$int.Just$int"(ptr %"Just$int.obj", i32 42)
  store ptr %"Just$int.obj", ptr %a, align 8
  %"Nothing$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Nothing$int", ptr null, i64 1) to i64))
  call void @"Nothing$int.Nothing$int"(ptr %"Nothing$int.obj")
  store ptr %"Nothing$int.obj", ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %vtbl.addr = getelementptr inbounds %"class.Maybe$int", ptr %a1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 6
  %fn = load ptr, ptr %slot, align 8
  %16 = call i32 %fn(ptr %a1)
  %a2 = load ptr, ptr %a, align 8
  %vtbl.addr3 = getelementptr inbounds %"class.Maybe$int", ptr %a2, i32 0, i32 0
  %vtbl4 = load ptr, ptr %vtbl.addr3, align 8, !tbaa !0
  %slot5 = getelementptr [349 x ptr], ptr %vtbl4, i64 0, i64 7
  %fn6 = load ptr, ptr %slot5, align 8
  %dv.is = icmp eq ptr %fn6, @"Maybe$int.orElse"
  br i1 %dv.is, label %dv.hit, label %dv.miss

dv.join:                                          ; preds = %dv.miss8, %dv.hit7, %dv.hit
  %dv.r = phi i32 [ %19, %dv.hit ], [ %20, %dv.hit7 ], [ %21, %dv.miss8 ]
  %17 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %dv.r)
  %b10 = load ptr, ptr %b, align 8
  %vtbl.addr11 = getelementptr inbounds %"class.Maybe$int", ptr %b10, i32 0, i32 0
  %vtbl12 = load ptr, ptr %vtbl.addr11, align 8, !tbaa !0
  %slot13 = getelementptr [349 x ptr], ptr %vtbl12, i64 0, i64 6
  %fn14 = load ptr, ptr %slot13, align 8
  %18 = call i32 %fn14(ptr %b10)
  %b15 = load ptr, ptr %b, align 8
  %vtbl.addr16 = getelementptr inbounds %"class.Maybe$int", ptr %b15, i32 0, i32 0
  %vtbl17 = load ptr, ptr %vtbl.addr16, align 8, !tbaa !0
  %slot18 = getelementptr [349 x ptr], ptr %vtbl17, i64 0, i64 7
  %fn19 = load ptr, ptr %slot18, align 8
  %dv.is23 = icmp eq ptr %fn19, @"Maybe$int.orElse"
  br i1 %dv.is23, label %dv.hit21, label %dv.miss22

dv.hit:                                           ; preds = %argv.end
  %19 = call i32 @"Maybe$int.orElse"(ptr %a2, i32 0)
  br label %dv.join

dv.miss:                                          ; preds = %argv.end
  %dv.is9 = icmp eq ptr %fn6, @"Just$int.orElse"
  br i1 %dv.is9, label %dv.hit7, label %dv.miss8

dv.hit7:                                          ; preds = %dv.miss
  %20 = call i32 @"Just$int.orElse"(ptr %a2, i32 0)
  br label %dv.join

dv.miss8:                                         ; preds = %dv.miss
  %21 = call i32 %fn6(ptr %a2, i32 0)
  br label %dv.join

dv.join20:                                        ; preds = %dv.miss25, %dv.hit24, %dv.hit21
  %dv.r27 = phi i32 [ %24, %dv.hit21 ], [ %25, %dv.hit24 ], [ %26, %dv.miss25 ]
  %22 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %18, i32 %dv.r27)
  %a28 = load ptr, ptr %a, align 8
  call void @__polaron_check_live(ptr %a28)
  %vtbl.addr29 = getelementptr inbounds %"class.Maybe$int", ptr %a28, i32 0, i32 0
  %vtbl30 = load ptr, ptr %vtbl.addr29, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl30, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %23 = icmp ne ptr %dtor.fn, null
  br i1 %23, label %dtor.call, label %dtor.free

dv.hit21:                                         ; preds = %dv.join
  %24 = call i32 @"Maybe$int.orElse"(ptr %b15, i32 99)
  br label %dv.join20

dv.miss22:                                        ; preds = %dv.join
  %dv.is26 = icmp eq ptr %fn19, @"Just$int.orElse"
  br i1 %dv.is26, label %dv.hit24, label %dv.miss25

dv.hit24:                                         ; preds = %dv.miss22
  %25 = call i32 @"Just$int.orElse"(ptr %b15, i32 99)
  br label %dv.join20

dv.miss25:                                        ; preds = %dv.miss22
  %26 = call i32 %fn19(ptr %b15, i32 99)
  br label %dv.join20

dtor.call:                                        ; preds = %dv.join20
  call void %dtor.fn(ptr %a28)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %dv.join20
  call void @__polaron_free(ptr %a28)
  %b31 = load ptr, ptr %b, align 8
  call void @__polaron_check_live(ptr %b31)
  %vtbl.addr32 = getelementptr inbounds %"class.Maybe$int", ptr %b31, i32 0, i32 0
  %vtbl33 = load ptr, ptr %vtbl.addr32, align 8, !tbaa !0
  %dtor.slot34 = getelementptr [350 x ptr], ptr %vtbl33, i64 0, i64 349
  %dtor.fn35 = load ptr, ptr %dtor.slot34, align 8
  %27 = icmp ne ptr %dtor.fn35, null
  br i1 %27, label %dtor.call36, label %dtor.free37

dtor.call36:                                      ; preds = %dtor.free
  call void %dtor.fn35(ptr %b31)
  br label %dtor.free37

dtor.free37:                                      ; preds = %dtor.call36, %dtor.free
  call void @__polaron_free(ptr %b31)
  ret i32 0
}

define internal void @"Nothing$int.Nothing$int"(ptr %0) {
entry:
  call void @"Maybe$int.Maybe$int"(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Nothing$int", ptr %0, i32 0, i32 0
  store ptr @"Nothing$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @"Maybe$int.Maybe$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Maybe$int", ptr %0, i32 0, i32 0
  store ptr @"Maybe$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal i32 @"Maybe$int.isSome"(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 0
}

define internal i32 @"Maybe$int.orElse"(ptr nonnull align 8 dereferenceable(8) %0, i32 %1) {
entry:
  %fallback = alloca i32, align 4
  store i32 %1, ptr %fallback, align 4
  %fallback1 = load i32, ptr %fallback, align 4
  ret i32 %fallback1
}

define internal void @"Just$int.Just$int"(ptr %0, i32 %1) {
entry:
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  call void @"Maybe$int.Maybe$int"(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Just$int", ptr %0, i32 0, i32 0
  store ptr @"Just$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %value1 = getelementptr inbounds %"class.Just$int", ptr %0, i32 0, i32 1
  %value2 = load i32, ptr %value, align 4
  store i32 %value2, ptr %value1, align 4, !tbaa !4
  ret void
}

define internal i32 @"Just$int.isSome"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret i32 1
}

define internal i32 @"Just$int.orElse"(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %fallback = alloca i32, align 4
  store i32 %1, ptr %fallback, align 4
  %value = getelementptr inbounds %"class.Just$int", ptr %0, i32 0, i32 1
  %value1 = load i32, ptr %value, align 4, !tbaa !4
  ret i32 %value1
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
