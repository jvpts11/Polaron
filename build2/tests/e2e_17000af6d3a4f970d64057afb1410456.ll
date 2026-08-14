; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/static_alloc_init.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/static_alloc_init.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Table.rows = private global ptr null
@Table.tag = private global ptr null
@Table.count = private global i32 7
@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [151 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/static_alloc_init.pol:21:31  in Table.__onClassLoad\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata = private constant [6 x i8] c"hello\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.str = private unnamed_addr constant [10 x i8] c"%d %d %d\0A\00", align 1
@.fail.1 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/static_alloc_init.pol:28:41  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }

define internal void @Table.__onClassLoad() {
entry:
  %arr = call ptr @__polaron_malloc(i64 80)
  store i64 9, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %0 = call ptr @memset(ptr %arr.data, i32 0, i64 72)
  store ptr %arr, ptr @Table.rows, align 8
  %rows = load ptr, ptr @Table.rows, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %rows, align 8
  %arr.oob = icmp uge i64 8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 8, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data1 = getelementptr i8, ptr %rows, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data1, i64 8
  store i64 42, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  %1 = load ptr, ptr @Table.tag, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy, ptr @Table.tag, align 8
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
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
  call void @Table.__onClassLoad()
  call void @Test.__onClassLoad()
  %rows = load ptr, ptr @Table.rows, align 8
  %len = load i64, ptr %rows, align 8
  %16 = trunc i64 %len to i32
  %rows1 = load ptr, ptr @Table.rows, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %rows1, align 8
  %arr.oob = icmp uge i64 8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 8, ptr @.failb.3, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data2 = getelementptr i8, ptr %rows1, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data2, i64 8
  %elem = load i64, ptr %arr.elem, align 8
  %17 = trunc i64 %elem to i32
  %count = load i32, ptr @Table.count, align 4
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %count)
  %tag = load ptr, ptr @Table.tag, align 8
  %str.data = getelementptr inbounds %String, ptr %tag, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %19 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr %data)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5315)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5317)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
