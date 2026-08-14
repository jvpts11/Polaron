; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol:14:22  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol:15:22  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [20 x i8] c"len=%d %d %d %d %d\0A\00", align 1
@.fail.4 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol:16:41  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol:16:41  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol:16:41  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol:16:41  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.16 = private unnamed_addr constant [11 x i8] c"len=%d %d\0A\00", align 1
@.fail.17 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_grow.pol:19:41  in main\0A\00", align 1
@.faila.18 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.19 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5327 = private constant [1 x i8] zeroinitializer
@.strobj.5328 = private global %String { i64 0, ptr @.strdata.5327, i64 0 }
@.strdata.5329 = private constant [1 x i8] zeroinitializer
@.strobj.5330 = private global %String { i64 0, ptr @.strdata.5329, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %a = alloca ptr, align 8
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
  %arrlit = call ptr @__polaron_malloc(i64 16)
  store i64 2, ptr %arrlit, align 8
  %arr.data1 = getelementptr i8, ptr %arrlit, i64 8
  %16 = getelementptr i32, ptr %arr.data1, i64 0
  store i32 1, ptr %16, align 4
  %17 = getelementptr i32, ptr %arr.data1, i64 1
  store i32 2, ptr %17, align 4
  store ptr %arrlit, ptr %a, align 8
  %arr.old = load ptr, ptr %a, align 8
  %arr.oldlen = load i64, ptr %arr.old, align 8
  %arr.new = call ptr @__polaron_realloc(ptr %arr.old, i64 24)
  store i64 4, ptr %arr.new, align 8
  %18 = icmp sgt i64 4, %arr.oldlen
  %19 = sub i64 4, %arr.oldlen
  %20 = mul i64 %19, 4
  %21 = select i1 %18, i64 %20, i64 0
  %22 = mul i64 %arr.oldlen, 4
  %arr.data2 = getelementptr i8, ptr %arr.new, i64 8
  %23 = getelementptr i8, ptr %arr.data2, i64 %22
  %24 = call ptr @memset(ptr %23, i32 0, i64 %21)
  store ptr %arr.new, ptr %a, align 8
  %a3 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a3, align 8
  %arr.oob = icmp uge i64 2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 2, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data4 = getelementptr i8, ptr %a3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data4, i64 2
  store i32 30, ptr %arr.elem, align 4
  %a5 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len6 = load i64, ptr %a5, align 8
  %arr.oob7 = icmp uge i64 3, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !2

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 3, ptr @.failb.3, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %a5, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 3
  store i32 40, ptr %arr.elem11, align 4
  %a12 = load ptr, ptr %a, align 8
  %len = load i64, ptr %a12, align 8
  %25 = trunc i64 %len to i32
  %a13 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len14 = load i64, ptr %a13, align 8
  %arr.oob15 = icmp uge i64 0, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad16:                                        ; preds = %idx.ok9
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 0, ptr @.failb.6, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok9
  %arr.data18 = getelementptr i8, ptr %a13, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 0
  %elem = load i32, ptr %arr.elem19, align 4
  %a20 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len21 = load i64, ptr %a20, align 8
  %arr.oob22 = icmp uge i64 1, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

idx.bad23:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 1, ptr @.failb.9, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok17
  %arr.data25 = getelementptr i8, ptr %a20, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 1
  %elem27 = load i32, ptr %arr.elem26, align 4
  %a28 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len29 = load i64, ptr %a28, align 8
  %arr.oob30 = icmp uge i64 2, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !2

idx.bad31:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 2, ptr @.failb.12, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok24
  %arr.data33 = getelementptr i8, ptr %a28, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 2
  %elem35 = load i32, ptr %arr.elem34, align 4
  %a36 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len37 = load i64, ptr %a36, align 8
  %arr.oob38 = icmp uge i64 3, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad39:                                        ; preds = %idx.ok32
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 3, ptr @.failb.15, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok32
  %arr.data41 = getelementptr i8, ptr %a36, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 3
  %elem43 = load i32, ptr %arr.elem42, align 4
  %26 = call i32 (ptr, ...) @printf(ptr @.str, i32 %25, i32 %elem, i32 %elem27, i32 %elem35, i32 %elem43)
  %arr.old44 = load ptr, ptr %a, align 8
  %arr.oldlen45 = load i64, ptr %arr.old44, align 8
  %arr.new46 = call ptr @__polaron_realloc(ptr %arr.old44, i64 12)
  store i64 1, ptr %arr.new46, align 8
  %27 = icmp sgt i64 1, %arr.oldlen45
  %28 = sub i64 1, %arr.oldlen45
  %29 = mul i64 %28, 4
  %30 = select i1 %27, i64 %29, i64 0
  %31 = mul i64 %arr.oldlen45, 4
  %arr.data47 = getelementptr i8, ptr %arr.new46, i64 8
  %32 = getelementptr i8, ptr %arr.data47, i64 %31
  %33 = call ptr @memset(ptr %32, i32 0, i64 %30)
  store ptr %arr.new46, ptr %a, align 8
  %a48 = load ptr, ptr %a, align 8
  %len49 = load i64, ptr %a48, align 8
  %34 = trunc i64 %len49 to i32
  %a50 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len51 = load i64, ptr %a50, align 8
  %arr.oob52 = icmp uge i64 0, %arr.len51
  br i1 %arr.oob52, label %idx.bad53, label %idx.ok54, !prof !2

idx.bad53:                                        ; preds = %idx.ok40
  call void @__polaron_fail(ptr @.fail.17, ptr @.faila.18, i64 0, ptr @.failb.19, i64 %arr.len51, i32 70)
  unreachable

idx.ok54:                                         ; preds = %idx.ok40
  %arr.data55 = getelementptr i8, ptr %a50, i64 8
  %arr.elem56 = getelementptr inbounds i32, ptr %arr.data55, i64 0
  %elem57 = load i32, ptr %arr.elem56, align 4
  %35 = call i32 (ptr, ...) @printf(ptr @.str.16, i32 %34, i32 %elem57)
  %a58 = load ptr, ptr %a, align 8
  call void @__polaron_free(ptr %a58)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5328)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5330)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare noalias ptr @__polaron_realloc(ptr, i64)

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
