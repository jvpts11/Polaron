; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bundle_field_app.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bundle_field_app.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Box = type { ptr, i64, i64, i64, i32, i64, i8, %WeakSlot, i32 }
%WeakSlot = type { ptr, ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [50 x i8] c"visible = %d, get = %d, hidden = %d, packed = %d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
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
  %Box.new = call ptr @Box.__new()
  store ptr %Box.new, ptr %b, align 8
  %b1 = load ptr, ptr %b, align 8
  %visible = getelementptr inbounds %class.Box, ptr %b1, i32 0, i32 8
  store i32 7, ptr %visible, align 4, !tbaa !0
  %b2 = load ptr, ptr %b, align 8
  %visible3 = getelementptr inbounds %class.Box, ptr %b2, i32 0, i32 8
  %visible4 = load i32, ptr %visible3, align 4, !tbaa !0
  %b5 = load ptr, ptr %b, align 8
  %vtbl.addr = getelementptr inbounds %class.Box, ptr %b5, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !4
  %slot = getelementptr [350 x ptr], ptr %vtbl, i64 0, i64 0
  %fn = load ptr, ptr %slot, align 8
  %16 = call i32 %fn(ptr %b5)
  %b6 = load ptr, ptr %b, align 8
  %vtbl.addr7 = getelementptr inbounds %class.Box, ptr %b6, i32 0, i32 0
  %vtbl8 = load ptr, ptr %vtbl.addr7, align 8, !tbaa !4
  %slot9 = getelementptr [350 x ptr], ptr %vtbl8, i64 0, i64 1
  %fn10 = load ptr, ptr %slot9, align 8
  %17 = call i64 %fn10(ptr %b6)
  %18 = trunc i64 %17 to i32
  %b11 = load ptr, ptr %b, align 8
  %vtbl.addr12 = getelementptr inbounds %class.Box, ptr %b11, i32 0, i32 0
  %vtbl13 = load ptr, ptr %vtbl.addr12, align 8, !tbaa !4
  %slot14 = getelementptr [350 x ptr], ptr %vtbl13, i64 0, i64 2
  %fn15 = load ptr, ptr %slot14, align 8
  %19 = call i32 %fn15(ptr %b11)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %visible4, i32 %16, i32 %18, i32 %19)
  ret i32 0
}

declare ptr @Box.__new()

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
!4 = !{!5, !5, i64 0}
!5 = !{!"ptr", !2, i64 0}
