; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/hot_path.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/hot_path.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/hot_path.pol:32:23  in Hot.sumChecked\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [127 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/hot_path.pol:44:27  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [19 x i8] c"hot=%d checked=%d\0A\00", align 1
@.str.4 = private unnamed_addr constant [28 x i8] c"wrapDiv=%d uncheckedDiv=%d\0A\00", align 1
@.panic = private unnamed_addr constant [126 x i8] c"Polaron panic: integer division by zero\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/hot_path.pol:52:41  in main\0A\00", align 1
@.panic.5 = private unnamed_addr constant [126 x i8] c"Polaron panic: integer division by zero\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/hot_path.pol:52:41  in main\0A\00", align 1
@.str.6 = private unnamed_addr constant [13 x i8] c"plainDiv=%d\0A\00", align 1
@.panic.7 = private unnamed_addr constant [126 x i8] c"Polaron panic: integer division by zero\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/hot_path.pol:54:41  in main\0A\00", align 1
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }
@.strdata.5318 = private constant [1 x i8] zeroinitializer
@.strobj.5319 = private global %String { i64 0, ptr @.strdata.5318, i64 0 }

define internal i32 @Hot.sum(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  %n = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %n, align 4
  store i32 0, ptr %s, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %2 = icmp slt i32 %i1, %n2
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %s3 = load i32, ptr %s, align 4
  %a4 = load ptr, ptr %a, align 8
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.data = getelementptr i8, ptr %a4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %5 = add i32 %s3, %elem
  store i32 %5, ptr %s, align 4
  %i6 = load i32, ptr %i, align 4
  %6 = add i32 %i6, 1
  store i32 %6, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %s7 = load i32, ptr %s, align 4
  ret i32 %s7
}

define internal i32 @Hot.sumChecked(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  %n = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %n, align 4
  store i32 0, ptr %s, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %2 = icmp slt i32 %i1, %n2
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %s3 = load i32, ptr %s, align 4
  %a4 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %a4, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  %s7 = load i32, ptr %s, align 4
  ret i32 %s7

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %4, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %a4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %5 = add i32 %s3, %elem
  store i32 %5, ptr %s, align 4
  %i6 = load i32, ptr %i, align 4
  %6 = add i32 %i6, 1
  store i32 %6, ptr %i, align 4
  br label %while.cond
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %lo = alloca i32, align 4
  %i = alloca i32, align 4
  %xs = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 16)
  store ptr %arr, ptr %xs, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok, %argv.end
  %i2 = load i32, ptr %i, align 4
  %17 = icmp slt i32 %i2, 4
  %18 = zext i1 %17 to i32
  br i1 %17, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %xs3 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i4 = load i32, ptr %i, align 4
  %19 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %xs3, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  %xs8 = load ptr, ptr %xs, align 8
  %20 = call i32 @Hot.sum(ptr %xs8, i32 4)
  %xs9 = load ptr, ptr %xs, align 8
  %21 = call i32 @Hot.sumChecked(ptr %xs9, i32 4)
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %20, i32 %21)
  store i32 -2147483648, ptr %lo, align 4
  %lo10 = load i32, ptr %lo, align 4
  br i1 false, label %div.bad, label %div.ok

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %19, ptr @.failb.3, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data5 = getelementptr i8, ptr %xs3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data5, i64 %19
  %i6 = load i32, ptr %i, align 4
  %23 = add i32 %i6, 1
  store i32 %23, ptr %arr.elem, align 4
  %i7 = load i32, ptr %i, align 4
  %24 = add i32 %i7, 1
  store i32 %24, ptr %i, align 4
  br label %while.cond

div.bad:                                          ; preds = %while.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

div.ok:                                           ; preds = %while.end
  %25 = icmp eq i32 %lo10, -2147483648
  %div.wraps = and i1 %25, true
  %div.rhs = select i1 %div.wraps, i32 1, i32 -1
  %26 = sdiv i32 %lo10, %div.rhs
  %lo11 = load i32, ptr %lo, align 4
  br i1 false, label %div.bad12, label %div.ok13

div.bad12:                                        ; preds = %div.ok
  call void @__polaron_panic(ptr @.panic.5)
  unreachable

div.ok13:                                         ; preds = %div.ok
  %27 = icmp eq i32 %lo11, -2147483648
  %div.wraps14 = and i1 %27, true
  %div.rhs15 = select i1 %div.wraps14, i32 1, i32 -1
  %28 = sdiv i32 %lo11, %div.rhs15
  %29 = call i32 (ptr, ...) @printf(ptr @.str.4, i32 %26, i32 %28)
  %lo16 = load i32, ptr %lo, align 4
  br i1 false, label %div.bad17, label %div.ok18

div.bad17:                                        ; preds = %div.ok13
  call void @__polaron_panic(ptr @.panic.7)
  unreachable

div.ok18:                                         ; preds = %div.ok13
  %30 = icmp eq i32 %lo16, -2147483648
  %div.wraps19 = and i1 %30, false
  %div.rhs20 = select i1 %div.wraps19, i32 1, i32 2
  %31 = sdiv i32 %lo16, %div.rhs20
  %32 = call i32 (ptr, ...) @printf(ptr @.str.6, i32 %31)
  %xs21 = load ptr, ptr %xs, align 8
  call void @__polaron_free(ptr %xs21)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5317)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5319)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
