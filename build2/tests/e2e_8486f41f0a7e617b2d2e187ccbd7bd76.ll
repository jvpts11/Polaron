; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_at_address.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/region_at_address.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Cell = type { i32 }
%class.ByteSize = type { i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.panic = private unnamed_addr constant [148 x i8] c"region out of memory: this fixed region is full -- give itself.allocate a bigger size, release it and take it again, or make it a `growable` region\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str = private unnamed_addr constant [13 x i8] c"v=%d raw=%d\0A\00", align 1
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

define internal void @Cell.Cell(ptr %0) {
entry:
  %v = getelementptr inbounds %class.Cell, ptr %0, i32 0, i32 0
  store i32 0, ptr %v, align 4, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %c = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %exc.cleanup = alloca ptr, align 8
  %hw = alloca ptr, align 8
  %mem = alloca i64, align 8
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
  %mem.alloc = call ptr @__polaron_malloc(i64 256)
  %16 = ptrtoint ptr %mem.alloc to i64
  store i64 %16, ptr %mem, align 8
  %17 = call ptr @literal.bytes.int(i32 256)
  %bs = getelementptr inbounds %class.ByteSize, ptr %17, i32 0, i32 0
  %bytes = load i64, ptr %bs, align 8, !tbaa !4
  %mem1 = load i64, ptr %mem, align 8
  %region = call ptr @__polaron_malloc(i64 24)
  %18 = inttoptr i64 %mem1 to ptr
  store i64 0, ptr %region, align 8
  %rgn.cap = getelementptr i8, ptr %region, i64 8
  store i64 %bytes, ptr %rgn.cap, align 8
  %rgn.dbase = getelementptr i8, ptr %region, i64 16
  store ptr %18, ptr %rgn.dbase, align 8
  store ptr %region, ptr %hw, align 8
  %region2 = load ptr, ptr %hw, align 8
  %used = load i64, ptr %region2, align 8
  %rgn.dbase3 = getelementptr i8, ptr %region2, i64 16
  %rgn.data = load ptr, ptr %rgn.dbase3, align 8, !invariant.load !6
  %rgn.obj = getelementptr i8, ptr %rgn.data, i64 %used
  %19 = and i64 add (i64 ptrtoint (ptr getelementptr (%class.Cell, ptr null, i64 1) to i64), i64 7), -8
  %rgn.next = add i64 %used, %19
  %rgn.cap4 = getelementptr i8, ptr %region2, i64 8
  %cap = load i64, ptr %rgn.cap4, align 8, !invariant.load !6
  %rgn.over = icmp ugt i64 %rgn.next, %cap
  br i1 %rgn.over, label %rgn.full, label %rgn.ok

rgn.full:                                         ; preds = %argv.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

rgn.ok:                                           ; preds = %argv.end
  store i64 %rgn.next, ptr %region2, align 8
  invoke void @Cell.Cell(ptr %rgn.obj)
          to label %invoke.cont unwind label %cleanup

cleanup:                                          ; preds = %rgn.ok
  %20 = catchswitch within none [label %cleanup.dispatch] unwind to caller

cleanup.dispatch:                                 ; preds = %cleanup
  %21 = catchpad within %20 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup]
  catchret from %21 to label %cleanup.run

cleanup.run:                                      ; preds = %cleanup.dispatch
  %cleanup.obj = load ptr, ptr %exc.cleanup, align 8
  %region5 = load ptr, ptr %hw, align 8
  call void @__polaron_region_release(ptr %region5)
  store ptr %cleanup.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

invoke.cont:                                      ; preds = %rgn.ok
  store ptr %rgn.obj, ptr %c, align 8
  %c6 = load ptr, ptr %c, align 8
  %v = getelementptr inbounds %class.Cell, ptr %c6, i32 0, i32 0
  store i32 77, ptr %v, align 4, !tbaa !0
  %c7 = load ptr, ptr %c, align 8
  %v8 = getelementptr inbounds %class.Cell, ptr %c7, i32 0, i32 0
  %v9 = load i32, ptr %v8, align 4, !tbaa !0
  %mem10 = load i64, ptr %mem, align 8
  %22 = inttoptr i64 %mem10 to ptr
  %mem.read = load i32, ptr %22, align 4
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %v9, i32 %mem.read)
  %24 = load ptr, ptr %hw, align 8
  call void @__polaron_region_release(ptr %24)
  store ptr null, ptr %hw, align 8
  %mem11 = load i64, ptr %mem, align 8
  %25 = inttoptr i64 %mem11 to ptr
  call void @__polaron_free(ptr %25)
  %region12 = load ptr, ptr %hw, align 8
  call void @__polaron_region_release(ptr %region12)
  ret i32 0
}

define internal void @ByteSize.ByteSize(ptr %0, i64 %1) {
entry:
  %bytes = alloca i64, align 8
  store i64 %1, ptr %bytes, align 8
  %bytes1 = getelementptr inbounds %class.ByteSize, ptr %0, i32 0, i32 0
  %bytes2 = load i64, ptr %bytes, align 8
  store i64 %bytes2, ptr %bytes1, align 8, !tbaa !4
  ret void
}

define internal ptr @literal.bytes.int(i32 %0) {
entry:
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %ByteSize.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ByteSize, ptr null, i64 1) to i64))
  %x1 = load i32, ptr %x, align 4
  %1 = sext i32 %x1 to i64
  call void @ByteSize.ByteSize(ptr %ByteSize.obj, i64 %1)
  ret ptr %ByteSize.obj
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

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare i32 @__CxxFrameHandler3(...)

declare void @__polaron_region_release(ptr)

declare void @_CxxThrowException(ptr, ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i64", !2, i64 0}
!6 = !{}
