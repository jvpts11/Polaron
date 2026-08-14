; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol:11:17  in Main.trace\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol:11:17  in Main.trace\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol:11:17  in Main.trace\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [139 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol:11:17  in Main.trace\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [10 x i8] c"%d %d %d\0A\00", align 1
@.fail.10 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol:15:41  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol:15:41  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol:15:41  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [133 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/array_multidim.pol:15:41  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5329 = private constant [1 x i8] zeroinitializer
@.strobj.5330 = private global %String { i64 0, ptr @.strdata.5329, i64 0 }
@.strdata.5331 = private constant [1 x i8] zeroinitializer
@.strobj.5332 = private global %String { i64 0, ptr @.strdata.5331, i64 0 }

define internal i32 @Main.trace(ptr %0) {
entry:
  %m = alloca ptr, align 8
  store ptr %0, ptr %m, align 8
  %m1 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %m1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %m1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8, !nonnull !0, !dereferenceable !1
  %arr.len2 = load i64, ptr %elem, align 8
  %arr.oob3 = icmp uge i64 0, %arr.len2
  br i1 %arr.oob3, label %idx.bad4, label %idx.ok5, !prof !2

idx.bad4:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 0, ptr @.failb.3, i64 %arr.len2, i32 70)
  unreachable

idx.ok5:                                          ; preds = %idx.ok
  %arr.data6 = getelementptr i8, ptr %elem, i64 8
  %arr.elem7 = getelementptr inbounds i32, ptr %arr.data6, i64 0
  %elem8 = load i32, ptr %arr.elem7, align 4
  %m9 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %arr.len10 = load i64, ptr %m9, align 8
  %arr.oob11 = icmp uge i64 1, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !2

idx.bad12:                                        ; preds = %idx.ok5
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 1, ptr @.failb.6, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok5
  %arr.data14 = getelementptr i8, ptr %m9, i64 8
  %arr.elem15 = getelementptr inbounds ptr, ptr %arr.data14, i64 1
  %elem16 = load ptr, ptr %arr.elem15, align 8, !nonnull !0, !dereferenceable !1
  %arr.len17 = load i64, ptr %elem16, align 8
  %arr.oob18 = icmp uge i64 1, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

idx.bad19:                                        ; preds = %idx.ok13
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 1, ptr @.failb.9, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok13
  %arr.data21 = getelementptr i8, ptr %elem16, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 1
  %elem23 = load i32, ptr %arr.elem22, align 4
  %1 = add i32 %elem8, %elem23
  ret i32 %1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %m = alloca ptr, align 8
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
  %arrlit = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arrlit, align 8
  %arr.data1 = getelementptr i8, ptr %arrlit, i64 8
  %arrlit2 = call ptr @__polaron_malloc(i64 16)
  store i64 2, ptr %arrlit2, align 8
  %arr.data3 = getelementptr i8, ptr %arrlit2, i64 8
  %16 = getelementptr i32, ptr %arr.data3, i64 0
  store i32 1, ptr %16, align 4
  %17 = getelementptr i32, ptr %arr.data3, i64 1
  store i32 2, ptr %17, align 4
  %18 = getelementptr ptr, ptr %arr.data1, i64 0
  store ptr %arrlit2, ptr %18, align 8
  %arrlit4 = call ptr @__polaron_malloc(i64 16)
  store i64 2, ptr %arrlit4, align 8
  %arr.data5 = getelementptr i8, ptr %arrlit4, i64 8
  %19 = getelementptr i32, ptr %arr.data5, i64 0
  store i32 3, ptr %19, align 4
  %20 = getelementptr i32, ptr %arr.data5, i64 1
  store i32 4, ptr %20, align 4
  %21 = getelementptr ptr, ptr %arr.data1, i64 1
  store ptr %arrlit4, ptr %21, align 8
  store ptr %arrlit, ptr %m, align 8
  %m6 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %m6, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 0, ptr @.failb.12, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data7 = getelementptr i8, ptr %m6, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data7, i64 0
  %elem = load ptr, ptr %arr.elem, align 8, !nonnull !0, !dereferenceable !1
  %arr.len8 = load i64, ptr %elem, align 8
  %arr.oob9 = icmp uge i64 1, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !2

idx.bad10:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 1, ptr @.failb.15, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %idx.ok
  %arr.data12 = getelementptr i8, ptr %elem, i64 8
  %arr.elem13 = getelementptr inbounds i32, ptr %arr.data12, i64 1
  %elem14 = load i32, ptr %arr.elem13, align 4
  %m15 = load ptr, ptr %m, align 8, !nonnull !0, !dereferenceable !1
  %arr.len16 = load i64, ptr %m15, align 8
  %arr.oob17 = icmp uge i64 1, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

idx.bad18:                                        ; preds = %idx.ok11
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 1, ptr @.failb.18, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok11
  %arr.data20 = getelementptr i8, ptr %m15, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 1
  %elem22 = load ptr, ptr %arr.elem21, align 8, !nonnull !0, !dereferenceable !1
  %arr.len23 = load i64, ptr %elem22, align 8
  %arr.oob24 = icmp uge i64 0, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !2

idx.bad25:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 0, ptr @.failb.21, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok19
  %arr.data27 = getelementptr i8, ptr %elem22, i64 8
  %arr.elem28 = getelementptr inbounds i32, ptr %arr.data27, i64 0
  %elem29 = load i32, ptr %arr.elem28, align 4
  %m30 = load ptr, ptr %m, align 8
  %22 = call i32 @Main.trace(ptr %m30)
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %elem14, i32 %elem29, i32 %22)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5330)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5332)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
