; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/value_compat.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/value_compat.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%__polaron_variant = type { i32, i64 }
%"class.Err$int$int" = type { ptr, i32 }
%"class.Ok$int$int" = type { ptr, i32 }
%"class.Result$int$int" = type { ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"Err$int$int.vtable" = private constant [350 x ptr] [ptr @"Err$int$int.isOk", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Ok$int$int.vtable" = private constant [350 x ptr] [ptr @"Ok$int$int.isOk", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [15 x i8] c"v=%d boxed=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal %__polaron_variant @Main.makeValue(i32 %0) {
entry:
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %1 = icmp slt i32 %x1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 1 }

if.end:                                           ; preds = %entry
  %x2 = load i32, ptr %x, align 4
  %var.enc.i = zext i32 %x2 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.i, 1
  ret %__polaron_variant %var.val
}

define internal ptr @Main.makeBoxed(i32 %0) {
entry:
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %1 = icmp slt i32 %x1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %"Err$int$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Err$int$int", ptr null, i64 1) to i64))
  call void @"Err$int$int.Err$int$int"(ptr %"Err$int$int.obj", i32 1)
  ret ptr %"Err$int$int.obj"

if.end:                                           ; preds = %entry
  %"Ok$int$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Ok$int$int", ptr null, i64 1) to i64))
  %x2 = load i32, ptr %x, align 4
  call void @"Ok$int$int.Ok$int$int"(ptr %"Ok$int$int.obj", i32 %x2)
  ret ptr %"Ok$int$int.obj"
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %e18 = alloca i32, align 4
  %a13 = alloca i32, align 4
  %bv = alloca i32, align 4
  %b = alloca ptr, align 8
  %e = alloca i32, align 4
  %a = alloca i32, align 4
  %vv = alloca i32, align 4
  %v = alloca %__polaron_variant, align 8
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
  %16 = call %__polaron_variant @Main.makeValue(i32 7)
  store %__polaron_variant %16, ptr %v, align 8
  store i32 0, ptr %vv, align 4
  %v1 = load %__polaron_variant, ptr %v, align 8
  %var.tag = extractvalue %__polaron_variant %v1, 0
  %var.pl = extractvalue %__polaron_variant %v1, 1
  %is = icmp eq i32 %var.tag, 0
  br i1 %is, label %match.case, label %match.next

match.end:                                        ; preds = %match.next4, %match.case3, %match.case
  %17 = call ptr @Main.makeBoxed(i32 20)
  store ptr %17, ptr %b, align 8
  store i32 0, ptr %bv, align 4
  %b8 = load ptr, ptr %b, align 8
  %vtbl.addr = getelementptr inbounds %"class.Result$int$int", ptr %b8, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %is12 = icmp eq ptr %vtbl, @"Ok$int$int.vtable"
  br i1 %is12, label %match.case10, label %match.next11

match.case:                                       ; preds = %argv.end
  %var.dec.i = trunc i64 %var.pl to i32
  store i32 %var.dec.i, ptr %a, align 4
  %a2 = load i32, ptr %a, align 4
  store i32 %a2, ptr %vv, align 4
  br label %match.end

match.next:                                       ; preds = %argv.end
  %is5 = icmp eq i32 %var.tag, 1
  br i1 %is5, label %match.case3, label %match.next4

match.case3:                                      ; preds = %match.next
  %var.dec.i6 = trunc i64 %var.pl to i32
  store i32 %var.dec.i6, ptr %e, align 4
  %e7 = load i32, ptr %e, align 4
  %18 = sub i32 0, %e7
  store i32 %18, ptr %vv, align 4
  br label %match.end

match.next4:                                      ; preds = %match.next
  br label %match.end

match.end9:                                       ; preds = %match.next16, %match.case15, %match.case10
  %b20 = load ptr, ptr %b, align 8
  call void @__polaron_check_live(ptr %b20)
  %vtbl.addr21 = getelementptr inbounds %"class.Result$int$int", ptr %b20, i32 0, i32 0
  %vtbl22 = load ptr, ptr %vtbl.addr21, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl22, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %19 = icmp ne ptr %dtor.fn, null
  br i1 %19, label %dtor.call, label %dtor.free

match.case10:                                     ; preds = %match.end
  %20 = getelementptr inbounds %"class.Ok$int$int", ptr %b8, i32 0, i32 1
  %value = load i32, ptr %20, align 4, !tbaa !4
  store i32 %value, ptr %a13, align 4
  %a14 = load i32, ptr %a13, align 4
  store i32 %a14, ptr %bv, align 4
  br label %match.end9

match.next11:                                     ; preds = %match.end
  %is17 = icmp eq ptr %vtbl, @"Err$int$int.vtable"
  br i1 %is17, label %match.case15, label %match.next16

match.case15:                                     ; preds = %match.next11
  %21 = getelementptr inbounds %"class.Err$int$int", ptr %b8, i32 0, i32 1
  %error = load i32, ptr %21, align 4, !tbaa !4
  store i32 %error, ptr %e18, align 4
  %e19 = load i32, ptr %e18, align 4
  %22 = sub i32 0, %e19
  store i32 %22, ptr %bv, align 4
  br label %match.end9

match.next16:                                     ; preds = %match.next11
  br label %match.end9

dtor.call:                                        ; preds = %match.end9
  call void %dtor.fn(ptr %b20)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %match.end9
  call void @__polaron_free(ptr %b20)
  %vv23 = load i32, ptr %vv, align 4
  %bv24 = load i32, ptr %bv, align 4
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %vv23, i32 %bv24)
  ret i32 0
}

define internal void @"Result$int$int.Result$int$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  ret void
}

define internal void @"Err$int$int.Err$int$int"(ptr %0, i32 %1) {
entry:
  %error = alloca i32, align 4
  store i32 %1, ptr %error, align 4
  call void @"Result$int$int.Result$int$int"(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Err$int$int", ptr %0, i32 0, i32 0
  store ptr @"Err$int$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %error1 = getelementptr inbounds %"class.Err$int$int", ptr %0, i32 0, i32 1
  %error2 = load i32, ptr %error, align 4
  store i32 %error2, ptr %error1, align 4, !tbaa !4
  ret void
}

define internal i32 @"Err$int$int.isOk"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret i32 0
}

define internal void @"Ok$int$int.Ok$int$int"(ptr %0, i32 %1) {
entry:
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  call void @"Result$int$int.Result$int$int"(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Ok$int$int", ptr %0, i32 0, i32 0
  store ptr @"Ok$int$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %value1 = getelementptr inbounds %"class.Ok$int$int", ptr %0, i32 0, i32 1
  %value2 = load i32, ptr %value, align 4
  store i32 %value2, ptr %value1, align 4, !tbaa !4
  ret void
}

define internal i32 @"Ok$int$int.isOk"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  ret i32 1
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

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

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
