; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_starts_at_zero.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_starts_at_zero.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Bare = type { i32, i64, i32 }
%class.Counted = type { i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [29 x i8] c"fresh: n=%d bits=%d flag=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"set: bit3=%d bit4=%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"own: n=%d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define internal void @Bare.take(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %k = alloca i32, align 4
  store i32 %1, ptr %k, align 4
  %bits = getelementptr inbounds %class.Bare, ptr %0, i32 0, i32 1
  %bits1 = getelementptr inbounds %class.Bare, ptr %0, i32 0, i32 1
  %bits2 = load i64, ptr %bits1, align 8, !tbaa !0
  %k3 = load i32, ptr %k, align 4
  %2 = sext i32 %k3 to i64
  %3 = icmp ult i64 %2, 64
  %4 = select i1 %3, i64 %2, i64 0
  %5 = shl i64 1, %4
  %6 = select i1 %3, i64 %5, i64 0
  %7 = or i64 %bits2, %6
  store i64 %7, ptr %bits, align 8, !tbaa !0
  ret void
}

define internal i32 @Bare.has(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %k = alloca i32, align 4
  store i32 %1, ptr %k, align 4
  %bits = getelementptr inbounds %class.Bare, ptr %0, i32 0, i32 1
  %bits1 = load i64, ptr %bits, align 8, !tbaa !0
  %k2 = load i32, ptr %k, align 4
  %2 = sext i32 %k2 to i64
  %3 = ashr i64 %bits1, 63
  %4 = icmp ult i64 %2, 64
  %5 = select i1 %4, i64 %2, i64 0
  %6 = ashr i64 %bits1, %5
  %7 = select i1 %4, i64 %6, i64 %3
  %8 = and i64 %7, 1
  %9 = icmp ne i64 %8, 0
  %10 = zext i1 %9 to i32
  ret i32 %10
}

define internal void @Bare.Bare(ptr %0) {
entry:
  ret void
}

define internal void @Counted.Counted(ptr %0) {
entry:
  %n = getelementptr inbounds %class.Counted, ptr %0, i32 0, i32 0
  store i32 7, ptr %n, align 4, !tbaa !4
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %own = alloca ptr, align 8
  %Counted.obj = alloca %class.Counted, align 8
  %fresh = alloca ptr, align 8
  %Bare.obj = alloca %class.Bare, align 8
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
  %16 = call ptr @memset(ptr %Bare.obj, i32 0, i64 ptrtoint (ptr getelementptr (%class.Bare, ptr null, i64 1) to i64))
  call void @Bare.Bare(ptr %Bare.obj)
  store ptr %Bare.obj, ptr %fresh, align 8
  %fresh1 = load ptr, ptr %fresh, align 8
  %n = getelementptr inbounds %class.Bare, ptr %fresh1, i32 0, i32 0
  %n2 = load i32, ptr %n, align 4, !tbaa !4
  %fresh3 = load ptr, ptr %fresh, align 8
  %bits = getelementptr inbounds %class.Bare, ptr %fresh3, i32 0, i32 1
  %bits4 = load i64, ptr %bits, align 8, !tbaa !0
  %17 = trunc i64 %bits4 to i32
  %fresh5 = load ptr, ptr %fresh, align 8
  %flag = getelementptr inbounds %class.Bare, ptr %fresh5, i32 0, i32 2
  %flag6 = load i32, ptr %flag, align 4, !tbaa !4
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 %n2, i32 %17, i32 %flag6)
  %fresh7 = load ptr, ptr %fresh, align 8
  call void @Bare.take(ptr %fresh7, i32 3)
  %fresh8 = load ptr, ptr %fresh, align 8
  %19 = call i32 @Bare.has(ptr %fresh8, i32 3)
  %fresh9 = load ptr, ptr %fresh, align 8
  %20 = call i32 @Bare.has(ptr %fresh9, i32 4)
  %21 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %19, i32 %20)
  call void @Counted.Counted(ptr %Counted.obj)
  store ptr %Counted.obj, ptr %own, align 8
  %own10 = load ptr, ptr %own, align 8
  %n11 = getelementptr inbounds %class.Counted, ptr %own10, i32 0, i32 0
  %n12 = load i32, ptr %n11, align 4, !tbaa !4
  %22 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %n12)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"i64", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
