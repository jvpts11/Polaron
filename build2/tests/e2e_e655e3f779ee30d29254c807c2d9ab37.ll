; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_index.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_index.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_index.pol:12:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_index.pol:13:23  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_index.pol:14:23  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_index.pol:15:23  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/foreach_index.pol:17:17  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [8 x i8] c"dot=%d\0A\00", align 1
@.str.13 = private unnamed_addr constant [9 x i8] c"last=%d\0A\00", align 1
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %k = alloca i32, align 4
  %n = alloca i32, align 4
  %last = alloca i32, align 4
  %v = alloca i32, align 4
  %fe.i = alloca i32, align 4
  %dot = alloca i32, align 4
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
  %xs2 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %xs2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %xs2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 10, ptr %arr.elem, align 4
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %xs4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %xs4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 20, ptr %arr.elem10, align 4
  %xs11 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %xs11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %xs11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 30, ptr %arr.elem17, align 4
  %xs18 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %xs18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %xs18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 3
  store i32 40, ptr %arr.elem24, align 4
  store i32 0, ptr %dot, align 4
  %xs25 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %fe.len = load i64, ptr %xs25, align 8
  %fe.len32 = trunc i64 %fe.len to i32
  store i32 0, ptr %fe.i, align 4
  br label %fe.cond

fe.cond:                                          ; preds = %fe.update, %idx.ok22
  %fe.iv = load i32, ptr %fe.i, align 4
  %17 = icmp slt i32 %fe.iv, %fe.len32
  br i1 %17, label %fe.body, label %fe.end

fe.body:                                          ; preds = %fe.cond
  %18 = sext i32 %fe.iv to i64
  %arr.len26 = load i64, ptr %xs25, align 8
  %arr.oob27 = icmp uge i64 %18, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

fe.update:                                        ; preds = %idx.ok29
  %19 = load i32, ptr %fe.i, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %fe.i, align 4
  br label %fe.cond

fe.end:                                           ; preds = %fe.cond
  %dot34 = load i32, ptr %dot, align 4
  %21 = call i32 (ptr, ...) @printf(ptr @.str, i32 %dot34)
  store i32 0, ptr %last, align 4
  store i32 5, ptr %n, align 4
  store i32 0, ptr %k, align 4
  br label %fr.cond

idx.bad28:                                        ; preds = %fe.body
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 %18, ptr @.failb.12, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %fe.body
  %arr.data30 = getelementptr i8, ptr %xs25, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %18
  %fe.el = load i32, ptr %arr.elem31, align 4
  store i32 %fe.el, ptr %v, align 4
  %dot32 = load i32, ptr %dot, align 4
  %i = load i32, ptr %fe.i, align 4
  %v33 = load i32, ptr %v, align 4
  %22 = mul i32 %i, %v33
  %23 = add i32 %dot32, %22
  store i32 %23, ptr %dot, align 4
  br label %fe.update

fr.cond:                                          ; preds = %fr.update, %fe.end
  %fr.iv = load i32, ptr %n, align 4
  %24 = icmp sle i32 %fr.iv, 8
  br i1 %24, label %fr.body, label %fr.end

fr.body:                                          ; preds = %fr.cond
  %k35 = load i32, ptr %k, align 4
  store i32 %k35, ptr %last, align 4
  br label %fr.update

fr.update:                                        ; preds = %fr.body
  %25 = load i32, ptr %n, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %n, align 4
  %27 = load i32, ptr %k, align 4
  %28 = add i32 %27, 1
  store i32 %28, ptr %k, align 4
  br label %fr.cond

fr.end:                                           ; preds = %fr.cond
  %last36 = load i32, ptr %last, align 4
  %29 = call i32 (ptr, ...) @printf(ptr @.str.13, i32 %last36)
  %xs37 = load ptr, ptr %xs, align 8
  call void @__polaron_free(ptr %xs37)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5322)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5324)
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
