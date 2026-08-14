; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_csharp.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_csharp.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_csharp.pol:13:29  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_csharp.pol:17:17  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [21 x i8] c"sum of squares = %d\0A\00", align 1
@.str.4 = private unnamed_addr constant [12 x i8] c"count = %d\0A\00", align 1
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %k = alloca i32, align 4
  %count = alloca i32, align 4
  %x = alloca i32, align 4
  %fe.i = alloca i32, align 4
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
  %arr = call ptr @__polaron_malloc(i64 28)
  store i64 5, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 20)
  store ptr %arr, ptr %nums, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i2 = load i32, ptr %i, align 4
  %17 = icmp slt i32 %i2, 5
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %nums3 = load ptr, ptr %nums, align 8, !nonnull !0, !dereferenceable !1
  %i4 = load i32, ptr %i, align 4
  %19 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %nums3, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %sum, align 4
  %nums8 = load ptr, ptr %nums, align 8, !nonnull !0, !dereferenceable !1
  %fe.len = load i64, ptr %nums8, align 8
  %fe.len32 = trunc i64 %fe.len to i32
  store i32 0, ptr %fe.i, align 4
  br label %fe.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %19, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data5 = getelementptr i8, ptr %nums3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data5, i64 %19
  %i6 = load i32, ptr %i, align 4
  %i7 = load i32, ptr %i, align 4
  %22 = mul i32 %i6, %i7
  store i32 %22, ptr %arr.elem, align 4
  br label %for.update

fe.cond:                                          ; preds = %fe.update, %for.end
  %fe.iv = load i32, ptr %fe.i, align 4
  %23 = icmp slt i32 %fe.iv, %fe.len32
  br i1 %23, label %fe.body, label %fe.end

fe.body:                                          ; preds = %fe.cond
  %24 = sext i32 %fe.iv to i64
  %arr.len9 = load i64, ptr %nums8, align 8
  %arr.oob10 = icmp uge i64 %24, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

fe.update:                                        ; preds = %idx.ok12
  %25 = load i32, ptr %fe.i, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %fe.i, align 4
  br label %fe.cond

fe.end:                                           ; preds = %fe.cond
  store i32 0, ptr %count, align 4
  store i32 0, ptr %k, align 4
  br label %fr.cond

idx.bad11:                                        ; preds = %fe.body
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %24, ptr @.failb.3, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %fe.body
  %arr.data13 = getelementptr i8, ptr %nums8, i64 8
  %arr.elem14 = getelementptr inbounds i32, ptr %arr.data13, i64 %24
  %fe.el = load i32, ptr %arr.elem14, align 4
  store i32 %fe.el, ptr %x, align 4
  %sum15 = load i32, ptr %sum, align 4
  %x16 = load i32, ptr %x, align 4
  %27 = add i32 %sum15, %x16
  store i32 %27, ptr %sum, align 4
  br label %fe.update

fr.cond:                                          ; preds = %fr.update, %fe.end
  %fr.iv = load i32, ptr %k, align 4
  %28 = icmp sle i32 %fr.iv, 10
  br i1 %28, label %fr.body, label %fr.end

fr.body:                                          ; preds = %fr.cond
  %count17 = load i32, ptr %count, align 4
  %29 = add i32 %count17, 1
  store i32 %29, ptr %count, align 4
  br label %fr.update

fr.update:                                        ; preds = %fr.body
  %30 = load i32, ptr %k, align 4
  %31 = add i32 %30, 1
  store i32 %31, ptr %k, align 4
  br label %fr.cond

fr.end:                                           ; preds = %fr.cond
  %sum18 = load i32, ptr %sum, align 4
  %32 = call i32 (ptr, ...) @printf(ptr @.str, i32 %sum18)
  %count19 = load i32, ptr %count, align 4
  %33 = call i32 (ptr, ...) @printf(ptr @.str.4, i32 %count19)
  %nums20 = load ptr, ptr %nums, align 8
  call void @__polaron_free(ptr %nums20)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5315)
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
