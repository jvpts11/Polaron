; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_incr_owned.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_incr_owned.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Vec = type { ptr, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_incr_owned.pol:14:30  in Vec.Vec\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [15 x i8] c"n=%d first=%d\0A\00", align 1
@.fail.1 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_incr_owned.pol:27:41  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }

define internal void @Vec.Vec(ptr %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %data = getelementptr inbounds %class.Vec, ptr %0, i32 0, i32 0
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %class.Vec, ptr %0, i32 0, i32 0
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %2 = call ptr @memset(ptr %arr.data, i32 0, i64 12)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %data2 = getelementptr inbounds %class.Vec, ptr %0, i32 0, i32 0
  %data3 = load ptr, ptr %data2, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len = load i64, ptr %data3, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data4 = getelementptr i8, ptr %data3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data4, i64 0
  %n5 = load i32, ptr %n, align 4
  store i32 %n5, ptr %arr.elem, align 4
  %n6 = getelementptr inbounds %class.Vec, ptr %0, i32 0, i32 1
  %n7 = load i32, ptr %n, align 4
  store i32 %n7, ptr %n6, align 4, !tbaa !7
  ret void
}

define internal void @"Vec.operator++"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Vec.obj = alloca %class.Vec, align 8
  %n = getelementptr inbounds %class.Vec, ptr %0, i32 0, i32 1
  %n1 = load i32, ptr %n, align 4, !tbaa !7
  %2 = add i32 %n1, 1
  call void @Vec.Vec(ptr %Vec.obj, i32 %2)
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %1, ptr align 8 %Vec.obj, i64 ptrtoint (ptr getelementptr (%class.Vec, ptr null, i64 1) to i64), i1 false)
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %sret = alloca %class.Vec, align 8
  %i = alloca i32, align 4
  %v = alloca ptr, align 8
  %Vec.obj = alloca %class.Vec, align 8
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
  call void @Vec.Vec(ptr %Vec.obj, i32 0)
  store ptr %Vec.obj, ptr %v, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i1 = load i32, ptr %i, align 4
  %16 = icmp slt i32 %i1, 1000
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %v2 = load ptr, ptr %v, align 8
  call void @"Vec.operator++"(ptr %v2, ptr %sret)
  %18 = load ptr, ptr %v, align 8
  %19 = getelementptr inbounds %class.Vec, ptr %18, i32 0, i32 0
  %20 = load ptr, ptr %19, align 8, !tbaa !0
  call void @__polaron_free(ptr %20)
  %21 = getelementptr inbounds %class.Vec, ptr %18, i32 0, i32 1
  %22 = call ptr @memcpy(ptr %18, ptr %sret, i64 ptrtoint (ptr getelementptr (%class.Vec, ptr null, i64 1) to i64))
  br label %for.update

for.update:                                       ; preds = %for.body
  %23 = load i32, ptr %i, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %v3 = load ptr, ptr %v, align 8
  %n = getelementptr inbounds %class.Vec, ptr %v3, i32 0, i32 1
  %n4 = load i32, ptr %n, align 4, !tbaa !7
  %v5 = load ptr, ptr %v, align 8
  %data = getelementptr inbounds %class.Vec, ptr %v5, i32 0, i32 0
  %data6 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len = load i64, ptr %data6, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 0, ptr @.failb.3, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.end
  %arr.data7 = getelementptr i8, ptr %data6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data7, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %n4, i32 %elem)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #1

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @strlen(ptr)

declare void @__polaron_free(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{}
!5 = !{i64 8}
!6 = !{!"branch_weights", i32 1, i32 1048576}
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !2, i64 0}
