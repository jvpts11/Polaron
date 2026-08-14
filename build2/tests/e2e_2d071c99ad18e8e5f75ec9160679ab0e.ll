; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [23 x i8] c"%d %d len=%d %c %d %d\0A\00", align 1
@.fail = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol:14:41  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol:14:41  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol:14:41  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol:14:41  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol:14:41  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol:14:41  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_literals.pol:14:41  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5326 = private constant [1 x i8] zeroinitializer
@.strobj.5327 = private global %String { i64 0, ptr @.strdata.5326, i64 0 }
@.strdata.5328 = private constant [1 x i8] zeroinitializer
@.strobj.5329 = private global %String { i64 0, ptr @.strdata.5328, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %m = alloca ptr, align 8
  %cs = alloca ptr, align 8
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
  %arrlit = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arrlit, align 8
  %arr.data1 = getelementptr i8, ptr %arrlit, i64 8
  %16 = getelementptr i32, ptr %arr.data1, i64 0
  store i32 10, ptr %16, align 4
  %17 = getelementptr i32, ptr %arr.data1, i64 1
  store i32 20, ptr %17, align 4
  %18 = getelementptr i32, ptr %arr.data1, i64 2
  store i32 30, ptr %18, align 4
  store ptr %arrlit, ptr %a, align 8
  %arrlit2 = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arrlit2, align 8
  %arr.data3 = getelementptr i8, ptr %arrlit2, i64 8
  %19 = getelementptr i32, ptr %arr.data3, i64 0
  store i32 120, ptr %19, align 4
  %20 = getelementptr i32, ptr %arr.data3, i64 1
  store i32 121, ptr %20, align 4
  %21 = getelementptr i32, ptr %arr.data3, i64 2
  store i32 122, ptr %21, align 4
  store ptr %arrlit2, ptr %cs, align 8
  %arrlit4 = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arrlit4, align 8
  %arr.data5 = getelementptr i8, ptr %arrlit4, i64 8
  %arrlit6 = call ptr @__polaron_malloc(i64 16)
  store i64 2, ptr %arrlit6, align 8
  %arr.data7 = getelementptr i8, ptr %arrlit6, i64 8
  %22 = getelementptr i32, ptr %arr.data7, i64 0
  store i32 1, ptr %22, align 4
  %23 = getelementptr i32, ptr %arr.data7, i64 1
  store i32 2, ptr %23, align 4
  %24 = getelementptr ptr, ptr %arr.data5, i64 0
  store ptr %arrlit6, ptr %24, align 8
  %arrlit8 = call ptr @__polaron_malloc(i64 16)
  store i64 2, ptr %arrlit8, align 8
  %arr.data9 = getelementptr i8, ptr %arrlit8, i64 8
  %25 = getelementptr i32, ptr %arr.data9, i64 0
  store i32 3, ptr %25, align 4
  %26 = getelementptr i32, ptr %arr.data9, i64 1
  store i32 4, ptr %26, align 4
  %27 = getelementptr ptr, ptr %arr.data5, i64 1
  store ptr %arrlit8, ptr %27, align 8
  store ptr %arrlit4, ptr %m, align 8
  %a10 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a10, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data11 = getelementptr i8, ptr %a10, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %a12 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len13 = load i64, ptr %a12, align 8
  %arr.oob14 = icmp uge i64 2, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !2

idx.bad15:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 2, ptr @.failb.3, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok
  %arr.data17 = getelementptr i8, ptr %a12, i64 8
  %arr.elem18 = getelementptr inbounds i32, ptr %arr.data17, i64 2
  %elem19 = load i32, ptr %arr.elem18, align 4
  %a20 = load ptr, ptr %a, align 8
  %len = load i64, ptr %a20, align 8
  %28 = trunc i64 %len to i32
  %cs21 = load ptr, ptr %cs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len22 = load i64, ptr %cs21, align 8
  %arr.oob23 = icmp uge i64 1, %arr.len22
  br i1 %arr.oob23, label %idx.bad24, label %idx.ok25, !prof !2

idx.bad24:                                        ; preds = %idx.ok16
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 1, ptr @.failb.6, i64 %arr.len22, i32 70)
  unreachable

idx.ok25:                                         ; preds = %idx.ok16
  %arr.data26 = getelementptr i8, ptr %cs21, i64 8
  %arr.elem27 = getelementptr inbounds i32, ptr %arr.data26, i64 1
  %elem28 = load i32, ptr %arr.elem27, align 4
  %m29 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %arr.len30 = load i64, ptr %m29, align 8
  %arr.oob31 = icmp uge i64 0, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

idx.bad32:                                        ; preds = %idx.ok25
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 0, ptr @.failb.9, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %idx.ok25
  %arr.data34 = getelementptr i8, ptr %m29, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 0
  %elem36 = load ptr, ptr %arr.elem35, align 8, !nonnull !0, !dereferenceable !1
  %arr.len37 = load i64, ptr %elem36, align 8
  %arr.oob38 = icmp uge i64 1, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad39:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 1, ptr @.failb.12, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok33
  %arr.data41 = getelementptr i8, ptr %elem36, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 1
  %elem43 = load i32, ptr %arr.elem42, align 4
  %m44 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %arr.len45 = load i64, ptr %m44, align 8
  %arr.oob46 = icmp uge i64 1, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

idx.bad47:                                        ; preds = %idx.ok40
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 1, ptr @.failb.15, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok40
  %arr.data49 = getelementptr i8, ptr %m44, i64 8
  %arr.elem50 = getelementptr inbounds ptr, ptr %arr.data49, i64 1
  %elem51 = load ptr, ptr %arr.elem50, align 8, !nonnull !0, !dereferenceable !1
  %arr.len52 = load i64, ptr %elem51, align 8
  %arr.oob53 = icmp uge i64 1, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !2

idx.bad54:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 1, ptr @.failb.18, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %idx.ok48
  %arr.data56 = getelementptr i8, ptr %elem51, i64 8
  %arr.elem57 = getelementptr inbounds i32, ptr %arr.data56, i64 1
  %elem58 = load i32, ptr %arr.elem57, align 4
  %29 = call i32 (ptr, ...) @printf(ptr @.str, i32 %elem, i32 %elem19, i32 %28, i32 %elem28, i32 %elem43, i32 %elem58)
  %a59 = load ptr, ptr %a, align 8
  call void @__polaron_free(ptr %a59)
  %cs60 = load ptr, ptr %cs, align 8
  call void @__polaron_free(ptr %cs60)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5327)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5329)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

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
