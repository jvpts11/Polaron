; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crossarch_hosted.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/crossarch_hosted.pol"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-none"

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
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
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
define internal i32 @Node.bump(ptr nonnull align 8 dereferenceable(16) %0) #0 {
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
  %t = alloca ptr, align 8
  %s = alloca ptr, align 8
  %r = alloca i32, align 4
  %n = alloca ptr, align 8
  %args = alloca ptr, align 8
  store ptr %0, ptr %args, align 8
  call void @Test.__onClassLoad()
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj, i32 21)
  store ptr %Node.obj, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %1 = call i32 @Node.bump(ptr %n1)
  %n2 = load ptr, ptr %n, align 8
  %2 = call i32 @Node.bump(ptr %n2)
  store i32 %2, ptr %r, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %s, align 8
  %s3 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s3, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len4 = load i64, ptr @.strobj.5, align 8
  %3 = add i64 %len, %len4
  %4 = add i64 %3, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %4)
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %5 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data5 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.5, i32 0, i32 1), align 8
  %6 = getelementptr i8, ptr %cat.buf, i64 %len
  %7 = call ptr @memcpy(ptr %6, ptr %data5, i64 %len4)
  %8 = getelementptr i8, ptr %cat.buf, i64 %3
  store i8 0, ptr %8, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %3, ptr %9, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %11, align 8
  %strcpy6 = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy6, ptr %t, align 8
  call void @__polaron_str_free(ptr %newstr)
  %t7 = load ptr, ptr %t, align 8
  %str.data8 = getelementptr inbounds %String, ptr %t7, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %r10 = load i32, ptr %r, align 4
  %t11 = load ptr, ptr %t, align 8
  %str.len12 = getelementptr inbounds %String, ptr %t11, i32 0, i32 0
  %len13 = load i64, ptr %str.len12, align 8
  %12 = trunc i64 %len13 to i32
  %13 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data9, i32 %r10, i32 %12)
  %n14 = load ptr, ptr %n, align 8
  call void @__polaron_check_live(ptr %n14)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %n14, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 349
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %14 = icmp ne ptr %dtor.fn, null
  br i1 %14, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %n14)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %n14)
  %15 = load ptr, ptr %t, align 8
  call void @__polaron_str_free(ptr %15)
  %16 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %16)
  ret i32 0
}

; Function Attrs: noredzone
define internal i32 @Object.equals(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) #0 {
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

; Function Attrs: noredzone
define internal i32 @Object.hashCode(ptr nonnull align 8 dereferenceable(8) %0) #0 {
entry:
  ret i32 0
}

; Function Attrs: noredzone
define internal i32 @Object.equalsKey(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) #0 {
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

; Function Attrs: noredzone
define internal void @Object.Object(ptr %0) #0 {
entry:
  %vtbl.addr = getelementptr inbounds %class.Object, ptr %0, i32 0, i32 0
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

; Function Attrs: noredzone
define internal void @Test.__onClassLoad() #0 {
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

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #2

declare noalias ptr @__polaron_malloc(i64)

declare ptr @__polaron_str_copy(ptr)

declare ptr @memcpy(ptr, ptr, i64)

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
