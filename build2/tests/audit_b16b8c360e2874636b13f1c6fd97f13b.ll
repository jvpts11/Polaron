; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crossarch_hosted.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crossarch_hosted.pol"
target datalayout = "e-m:e-p:32:32-p10:8:8-p20:8:8-i64:64-i128:128-n32:64-S128-ni:1:10:20"
target triple = "wasm32-unknown-unknown"

%String = type { i64, ptr, i64 }
%class.Node = type { ptr, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Node.vtable = private constant [350 x ptr] [ptr @Node.bump, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.contract = private unnamed_addr constant [160 x i8] c"contract violated: invariant\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crossarch_hosted.pol:27:33  in Node.Node\0A   |  invariant this.seen >= 0;\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1 = private unnamed_addr constant [160 x i8] c"contract violated: invariant\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crossarch_hosted.pol:27:33  in Node.bump\0A   |  invariant this.seen >= 0;\0A\00", align 1
@.cl.2 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.3 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.strdata = private constant [5 x i8] c"pola\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.4 = private constant [4 x i8] c"ron\00"
@.strobj.5 = private global %String { i64 3, ptr @.strdata.4, i64 0 }
@.str = private unnamed_addr constant [16 x i8] c"%s: %d, len %d\0A\00", align 1
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }

; Function Attrs: noredzone
define internal void @Node.Node(ptr %0, i32 %1) #0 {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 4, !tbaa !0
  %v1 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %v2 = load i32, ptr %v, align 4
  store i32 %v2, ptr %v1, align 4, !tbaa !4
  %seen = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  store i32 0, ptr %seen, align 4, !tbaa !4
  %seen3 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %seen4 = load i32, ptr %seen3, align 4, !tbaa !4
  %2 = icmp sge i32 %seen4, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %seen5 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %seen6 = load i32, ptr %seen5, align 4, !tbaa !4
  %contract.l = sext i32 %seen6 to i64
  call void @__polaron_fail(ptr @.contract, ptr @.cl, i64 %contract.l, ptr @.cr, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  ret void
}

; Function Attrs: noredzone
define internal i32 @Node.bump(ptr nonnull align 4 dereferenceable(12) %0) #0 {
entry:
  %seen = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %seen1 = load i32, ptr %seen, align 4, !tbaa !4
  %1 = icmp sge i32 %seen1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %seen2 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %seen3 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %seen4 = load i32, ptr %seen3, align 4, !tbaa !4
  %3 = add i32 %seen4, 1
  store i32 %3, ptr %seen2, align 4, !tbaa !4
  %v = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %v5 = load i32, ptr %v, align 4, !tbaa !4
  %seen6 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %seen7 = load i32, ptr %seen6, align 4, !tbaa !4
  %4 = mul i32 %v5, %seen7
  %seen8 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %seen9 = load i32, ptr %seen8, align 4, !tbaa !4
  %5 = icmp sge i32 %seen9, 0
  %6 = zext i1 %5 to i32
  %contract.ok = icmp ne i32 %6, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %seen10 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %seen11 = load i32, ptr %seen10, align 4, !tbaa !4
  %contract.l = sext i32 %seen11 to i64
  call void @__polaron_fail(ptr @.contract.1, ptr @.cl.2, i64 %contract.l, ptr @.cr.3, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  ret i32 %4
}

; Function Attrs: noredzone
define i32 @kmain(ptr %0) #0 {
entry:
  %t = alloca ptr, align 4
  %s = alloca ptr, align 4
  %r = alloca i32, align 4
  %n = alloca ptr, align 4
  %args = alloca ptr, align 4
  store ptr %0, ptr %args, align 4
  call void @Test.__onClassLoad()
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj, i32 21)
  store ptr %Node.obj, ptr %n, align 4
  %n1 = load ptr, ptr %n, align 4
  %1 = call i32 @Node.bump(ptr %n1)
  %n2 = load ptr, ptr %n, align 4
  %2 = call i32 @Node.bump(ptr %n2)
  store i32 %2, ptr %r, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %s, align 4
  %s3 = load ptr, ptr %s, align 4
  %str.len = getelementptr inbounds %String, ptr %s3, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len4 = load i64, ptr @.strobj.5, align 8
  %3 = add i64 %len, %len4
  %4 = add i64 %3, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %4)
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 4
  %len5 = trunc i64 %len to i32
  %5 = call ptr @memcpy(ptr %cat.buf, ptr %data, i32 %len5)
  %data6 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.5, i32 0, i32 1), align 4
  %6 = getelementptr i8, ptr %cat.buf, i64 %len
  %len7 = trunc i64 %len4 to i32
  %7 = call ptr @memcpy(ptr %6, ptr %data6, i32 %len7)
  %8 = getelementptr i8, ptr %cat.buf, i64 %3
  store i8 0, ptr %8, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %3, ptr %9, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %10, align 4
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %11, align 8
  %strcpy8 = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy8, ptr %t, align 4
  call void @__polaron_str_free(ptr %newstr)
  %t9 = load ptr, ptr %t, align 4
  %str.data10 = getelementptr inbounds %String, ptr %t9, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 4
  %r12 = load i32, ptr %r, align 4
  %t13 = load ptr, ptr %t, align 4
  %str.len14 = getelementptr inbounds %String, ptr %t13, i32 0, i32 0
  %len15 = load i64, ptr %str.len14, align 8
  %12 = trunc i64 %len15 to i32
  %13 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data11, i32 %r12, i32 %12)
  %n16 = load ptr, ptr %n, align 4
  call void @__polaron_check_live(ptr %n16)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %n16, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 4, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 4
  %14 = icmp ne ptr %dtor.fn, null
  br i1 %14, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %n16)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %n16)
  %15 = load ptr, ptr %t, align 4
  call void @__polaron_str_free(ptr %15)
  %16 = load ptr, ptr %s, align 4
  call void @__polaron_str_free(ptr %16)
  ret i32 0
}

; Function Attrs: noredzone
define internal i32 @Object.equals(ptr nonnull align 4 dereferenceable(4) %0, ptr %1) #0 {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 4
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i32 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i32))
  store ptr %Object.copy, ptr %other, align 4
  %other1 = load ptr, ptr %other, align 4
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

; Function Attrs: noredzone
define internal i32 @Object.hashCode(ptr nonnull align 4 dereferenceable(4) %0) #0 {
entry:
  ret i32 0
}

; Function Attrs: noredzone
define internal i32 @Object.equalsKey(ptr nonnull align 4 dereferenceable(4) %0, ptr %1) #0 {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 4
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i32 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i32))
  store ptr %Object.copy, ptr %other, align 4
  %other1 = load ptr, ptr %other, align 4
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

; Function Attrs: noredzone
define internal void @Object.Object(ptr %0) #0 {
entry:
  %vtbl.addr = getelementptr inbounds %class.Object, ptr %0, i32 0, i32 0
  store ptr @Object.vtable, ptr %vtbl.addr, align 4, !tbaa !0
  ret void
}

; Function Attrs: noredzone
define internal void @Test.__onClassLoad() #0 {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %0 = load ptr, ptr @Test.criterion, align 4
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 4
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %1 = load ptr, ptr @Test.skipWhy, align 4
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 4
  ret void
}

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #2

declare noalias ptr @__polaron_malloc(i64)

declare ptr @__polaron_str_copy(ptr)

declare ptr @memcpy(ptr, ptr, i32)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

attributes #0 = { noredzone }
attributes #1 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
