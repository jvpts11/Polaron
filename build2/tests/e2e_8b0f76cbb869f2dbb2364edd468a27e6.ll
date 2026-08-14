; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/arrays.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/arrays.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [125 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/arrays.pol:14:29  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [125 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/arrays.pol:18:25  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [15 x i8] c"sum=%d len=%d\0A\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %j = alloca i32, align 4
  %sum = alloca i32, align 4
  %i = alloca i32, align 4
  %nums = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 48)
  store i64 10, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 40)
  store ptr %arr, ptr %nums, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i2 = load i32, ptr %i, align 4
  %nums3 = load ptr, ptr %nums, align 8
  %len = load i64, ptr %nums3, align 8
  %17 = trunc i64 %len to i32
  %18 = icmp slt i32 %i2, %17
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %nums4 = load ptr, ptr %nums, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %20 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %nums4, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %sum, align 4
  store i32 0, ptr %j, align 4
  br label %for.cond8

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %20, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data6 = getelementptr i8, ptr %nums4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data6, i64 %20
  %i7 = load i32, ptr %i, align 4
  store i32 %i7, ptr %arr.elem, align 4
  br label %for.update

for.cond8:                                        ; preds = %for.update10, %for.end
  %j12 = load i32, ptr %j, align 4
  %23 = icmp slt i32 %j12, 10
  %24 = zext i1 %23 to i32
  br i1 %23, label %for.body9, label %for.end11

for.body9:                                        ; preds = %for.cond8
  %sum13 = load i32, ptr %sum, align 4
  %nums14 = load ptr, ptr %nums, align 8, !nonnull !0, !dereferenceable !1
  %j15 = load i32, ptr %j, align 4
  %25 = sext i32 %j15 to i64
  %arr.len16 = load i64, ptr %nums14, align 8
  %arr.oob17 = icmp uge i64 %25, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

for.update10:                                     ; preds = %idx.ok19
  %26 = load i32, ptr %j, align 4
  %27 = add i32 %26, 1
  store i32 %27, ptr %j, align 4
  br label %for.cond8

for.end11:                                        ; preds = %for.cond8
  %sum22 = load i32, ptr %sum, align 4
  %nums23 = load ptr, ptr %nums, align 8
  %len24 = load i64, ptr %nums23, align 8
  %28 = trunc i64 %len24 to i32
  %29 = call i32 (ptr, ...) @printf(ptr @.str, i32 %sum22, i32 %28)
  %nums25 = load ptr, ptr %nums, align 8
  call void @__polaron_free(ptr %nums25)
  ret i32 0

idx.bad18:                                        ; preds = %for.body9
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %25, ptr @.failb.3, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %for.body9
  %arr.data20 = getelementptr i8, ptr %nums14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %25
  %elem = load i32, ptr %arr.elem21, align 4
  %30 = add i32 %sum13, %elem
  store i32 %30, ptr %sum, align 4
  br label %for.update10
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

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
