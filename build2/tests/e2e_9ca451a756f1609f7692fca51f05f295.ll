; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_incr.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_incr.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Counter = type { i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [6 x i8] c"n=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Counter.Counter(ptr %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %n1 = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 0
  %n2 = load i32, ptr %n, align 4
  store i32 %n2, ptr %n1, align 4, !tbaa !0
  ret void
}

define internal void @"Counter.operator++"(ptr nonnull align 4 dereferenceable(4) %0, ptr %1) {
entry:
  %Counter.obj = alloca %class.Counter, align 8
  %n = getelementptr inbounds %class.Counter, ptr %0, i32 0, i32 0
  %n1 = load i32, ptr %n, align 4, !tbaa !0
  %2 = add i32 %n1, 1
  call void @Counter.Counter(ptr %Counter.obj, i32 %2)
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %1, ptr align 8 %Counter.obj, i64 ptrtoint (ptr getelementptr (%class.Counter, ptr null, i64 1) to i64), i1 false)
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %sret = alloca %class.Counter, align 8
  %i = alloca i32, align 4
  %c = alloca ptr, align 8
  %Counter.obj = alloca %class.Counter, align 8
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
  call void @Counter.Counter(ptr %Counter.obj, i32 0)
  store ptr %Counter.obj, ptr %c, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i1 = load i32, ptr %i, align 4
  %16 = icmp slt i32 %i1, 1000
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %c2 = load ptr, ptr %c, align 8
  call void @"Counter.operator++"(ptr %c2, ptr %sret)
  %18 = load ptr, ptr %c, align 8
  %19 = getelementptr inbounds %class.Counter, ptr %18, i32 0, i32 0
  %20 = call ptr @memcpy(ptr %18, ptr %sret, i64 ptrtoint (ptr getelementptr (%class.Counter, ptr null, i64 1) to i64))
  br label %for.update

for.update:                                       ; preds = %for.body
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %c3 = load ptr, ptr %c, align 8
  %n = getelementptr inbounds %class.Counter, ptr %c3, i32 0, i32 0
  %n4 = load i32, ptr %n, align 4, !tbaa !0
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %n4)
  ret i32 0
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

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #0

declare ptr @memcpy(ptr, ptr, i64)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
