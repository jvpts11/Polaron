; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bit_fields.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bit_fields.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Flags = type { i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [16 x i8] c"a=%d b=%d c=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Flags.Flags(ptr %0) {
entry:
  %a = getelementptr inbounds %class.Flags, ptr %0, i32 0, i32 0
  %a.unit = load i32, ptr %a, align 4, !tbaa !0
  %a.keep = and i32 %a.unit, -16
  %a.set = or i32 %a.keep, 0
  store i32 %a.set, ptr %a, align 4, !tbaa !0
  %b = getelementptr inbounds %class.Flags, ptr %0, i32 0, i32 0
  %b.unit = load i32, ptr %b, align 4, !tbaa !0
  %b.keep = and i32 %b.unit, -241
  %b.set = or i32 %b.keep, 0
  store i32 %b.set, ptr %b, align 4, !tbaa !0
  %c = getelementptr inbounds %class.Flags, ptr %0, i32 0, i32 0
  %c.unit = load i32, ptr %c, align 4, !tbaa !0
  %c.keep = and i32 %c.unit, -1048321
  %c.set = or i32 %c.keep, 0
  store i32 %c.set, ptr %c, align 4, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %wider = alloca i32, align 4
  %wide = alloca i32, align 4
  %f = alloca ptr, align 8
  %Flags.obj = alloca %class.Flags, align 8
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
  call void @Flags.Flags(ptr %Flags.obj)
  store ptr %Flags.obj, ptr %f, align 8
  store i32 20, ptr %wide, align 4
  store i32 5000, ptr %wider, align 4
  %f1 = load ptr, ptr %f, align 8
  %a = getelementptr inbounds %class.Flags, ptr %f1, i32 0, i32 0
  %wide2 = load i32, ptr %wide, align 4
  %a.bits = and i32 %wide2, 15
  %a.unit = load i32, ptr %a, align 4, !tbaa !0
  %a.keep = and i32 %a.unit, -16
  %a.set = or i32 %a.keep, %a.bits
  store i32 %a.set, ptr %a, align 4, !tbaa !0
  %f3 = load ptr, ptr %f, align 8
  %b = getelementptr inbounds %class.Flags, ptr %f3, i32 0, i32 0
  %b.unit = load i32, ptr %b, align 4, !tbaa !0
  %b.keep = and i32 %b.unit, -241
  %b.set = or i32 %b.keep, 112
  store i32 %b.set, ptr %b, align 4, !tbaa !0
  %f4 = load ptr, ptr %f, align 8
  %c = getelementptr inbounds %class.Flags, ptr %f4, i32 0, i32 0
  %wider5 = load i32, ptr %wider, align 4
  %c.bits = and i32 %wider5, 4095
  %16 = shl i32 %c.bits, 8
  %c.unit = load i32, ptr %c, align 4, !tbaa !0
  %c.keep = and i32 %c.unit, -1048321
  %c.set = or i32 %c.keep, %16
  store i32 %c.set, ptr %c, align 4, !tbaa !0
  %f6 = load ptr, ptr %f, align 8
  %a7 = getelementptr inbounds %class.Flags, ptr %f6, i32 0, i32 0
  %a.unit8 = load i32, ptr %a7, align 4, !tbaa !0
  %a.hi = shl i32 %a.unit8, 28
  %a9 = ashr i32 %a.hi, 28
  %f10 = load ptr, ptr %f, align 8
  %b11 = getelementptr inbounds %class.Flags, ptr %f10, i32 0, i32 0
  %b.unit12 = load i32, ptr %b11, align 4, !tbaa !0
  %b.hi = shl i32 %b.unit12, 24
  %b13 = ashr i32 %b.hi, 28
  %f14 = load ptr, ptr %f, align 8
  %c15 = getelementptr inbounds %class.Flags, ptr %f14, i32 0, i32 0
  %c.unit16 = load i32, ptr %c15, align 4, !tbaa !0
  %c.hi = shl i32 %c.unit16, 12
  %c17 = ashr i32 %c.hi, 20
  %17 = call i32 (ptr, ...) @printf(ptr @.str, i32 %a9, i32 %b13, i32 %c17)
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

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
