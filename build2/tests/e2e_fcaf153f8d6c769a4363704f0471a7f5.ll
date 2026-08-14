; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/finally_exits.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/finally_exits.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.1 = private unnamed_addr constant [16 x i8] c"finally-return\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str.2 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.3 = private unnamed_addr constant [16 x i8] c"finally-return\0A\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5 = private unnamed_addr constant [16 x i8] c"finally-return\0A\00", align 1
@.str.6 = private unnamed_addr constant [17 x i8] c"finally-iter %d\0A\00", align 1
@.str.7 = private unnamed_addr constant [9 x i8] c"iter %d\0A\00", align 1
@.str.8 = private unnamed_addr constant [17 x i8] c"finally-iter %d\0A\00", align 1
@.str.9 = private unnamed_addr constant [17 x i8] c"finally-iter %d\0A\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"r=%d\0A\00", align 1
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }

define internal i32 @Main.withReturn() personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %exc.caught = alloca ptr, align 8
  %0 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.1)
  ret i32 1

ehpad:                                            ; No predecessors!
  %1 = catchswitch within none [label %catch.dispatch] unwind to caller

try.cont:                                         ; No predecessors!
  %2 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr @.str.5)
  ret i32 0

catch.dispatch:                                   ; preds = %ehpad
  %3 = catchpad within %1 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.caught]
  %caught = load ptr, ptr %exc.caught, align 8
  %exc.vtbl = load ptr, ptr %caught, align 8
  catchret from %3 to label %rethrow

rethrow:                                          ; preds = %catch.dispatch
  %rethrow.obj = load ptr, ptr %exc.caught, align 8
  %4 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr @.str.3)
  store ptr %rethrow.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable
}

define internal void @Main.withBreak() personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %exc.caught = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %0 = icmp slt i32 %i1, 3
  %1 = zext i1 %0 to i32
  br i1 %0, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i2 = load i32, ptr %i, align 4
  %2 = icmp eq i32 %i2, 1
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

for.update:                                       ; preds = %try.cont
  %4 = load i32, ptr %i, align 4
  %5 = add i32 %4, 1
  store i32 %5, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %if.then, %for.cond
  ret void

ehpad:                                            ; No predecessors!
  %6 = catchswitch within none [label %catch.dispatch] unwind to caller

try.cont:                                         ; preds = %if.end
  %i6 = load i32, ptr %i, align 4
  %7 = call i32 (ptr, ...) @printf(ptr @.str.9, i32 %i6)
  br label %for.update

if.then:                                          ; preds = %for.body
  %i3 = load i32, ptr %i, align 4
  %8 = call i32 (ptr, ...) @printf(ptr @.str.6, i32 %i3)
  br label %for.end

if.end:                                           ; preds = %for.body
  %i4 = load i32, ptr %i, align 4
  %9 = call i32 (ptr, ...) @printf(ptr @.str.7, i32 %i4)
  br label %try.cont

catch.dispatch:                                   ; preds = %ehpad
  %10 = catchpad within %6 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.caught]
  %caught = load ptr, ptr %exc.caught, align 8
  %exc.vtbl = load ptr, ptr %caught, align 8
  catchret from %10 to label %rethrow

rethrow:                                          ; preds = %catch.dispatch
  %rethrow.obj = load ptr, ptr %exc.caught, align 8
  %i5 = load i32, ptr %i, align 4
  %11 = call i32 (ptr, ...) @printf(ptr @.str.8, i32 %i5)
  store ptr %rethrow.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %r = alloca i32, align 4
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
  %16 = call i32 @Main.withReturn()
  store i32 %16, ptr %r, align 4
  %r1 = load i32, ptr %r, align 4
  %17 = call i32 (ptr, ...) @printf(ptr @.str.10, i32 %r1)
  call void @Main.withBreak()
  ret i32 0
}

define internal void @Test.__onClassLoad() {
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

declare i32 @__CxxFrameHandler3(...)

declare i32 @printf(ptr, ...)

declare void @_CxxThrowException(ptr, ptr)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
