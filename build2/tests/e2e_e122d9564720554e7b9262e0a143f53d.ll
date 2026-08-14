; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:13:22  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:14:22  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:15:22  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:15:22  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:15:22  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:18:22  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:19:22  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:20:22  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:20:22  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:20:22  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:24:17  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [31 x i8] c"a2=%lld d2=%d sum=%lld len=%d\0A\00", align 1
@.fail.31 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:28:41  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wide_arrays.pol:28:41  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5344 = private constant [1 x i8] zeroinitializer
@.strobj.5345 = private global %String { i64 0, ptr @.strdata.5344, i64 0 }
@.strdata.5346 = private constant [1 x i8] zeroinitializer
@.strobj.5347 = private global %String { i64 0, ptr @.strdata.5346, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %x = alloca i64, align 8
  %fe.i = alloca i32, align 4
  %sum = alloca i64, align 8
  %d = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 32)
  store i64 3, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 24)
  store ptr %arr, ptr %a, align 8
  %a2 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %a2, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data3, i64 0
  store i64 5000000000, ptr %arr.elem, align 8
  %a4 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %a4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %a4, i64 8
  %arr.elem10 = getelementptr inbounds i64, ptr %arr.data9, i64 1
  store i64 12, ptr %arr.elem10, align 8
  %a11 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %a11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %a11, i64 8
  %arr.elem17 = getelementptr inbounds i64, ptr %arr.data16, i64 2
  %a18 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %a18, align 8
  %arr.oob20 = icmp uge i64 0, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 0, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %a18, i64 8
  %arr.elem24 = getelementptr inbounds i64, ptr %arr.data23, i64 0
  %elem = load i64, ptr %arr.elem24, align 8
  %a25 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len26 = load i64, ptr %a25, align 8
  %arr.oob27 = icmp uge i64 1, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 1, ptr @.failb.12, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %a25, i64 8
  %arr.elem31 = getelementptr inbounds i64, ptr %arr.data30, i64 1
  %elem32 = load i64, ptr %arr.elem31, align 8
  %17 = add i64 %elem, %elem32
  store i64 %17, ptr %arr.elem17, align 8
  %arr33 = call ptr @__polaron_malloc(i64 32)
  store i64 3, ptr %arr33, align 8
  %arr.data34 = getelementptr i8, ptr %arr33, i64 8
  %18 = call ptr @memset(ptr %arr.data34, i32 0, i64 24)
  store ptr %arr33, ptr %d, align 8
  %d35 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len36 = load i64, ptr %d35, align 8
  %arr.oob37 = icmp uge i64 0, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad38:                                        ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 0, ptr @.failb.15, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok29
  %arr.data40 = getelementptr i8, ptr %d35, i64 8
  %arr.elem41 = getelementptr inbounds double, ptr %arr.data40, i64 0
  store double 1.500000e+00, ptr %arr.elem41, align 8
  %d42 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len43 = load i64, ptr %d42, align 8
  %arr.oob44 = icmp uge i64 1, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !2

idx.bad45:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 1, ptr @.failb.18, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok39
  %arr.data47 = getelementptr i8, ptr %d42, i64 8
  %arr.elem48 = getelementptr inbounds double, ptr %arr.data47, i64 1
  store double 2.250000e+00, ptr %arr.elem48, align 8
  %d49 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len50 = load i64, ptr %d49, align 8
  %arr.oob51 = icmp uge i64 2, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !2

idx.bad52:                                        ; preds = %idx.ok46
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 2, ptr @.failb.21, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok46
  %arr.data54 = getelementptr i8, ptr %d49, i64 8
  %arr.elem55 = getelementptr inbounds double, ptr %arr.data54, i64 2
  %d56 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len57 = load i64, ptr %d56, align 8
  %arr.oob58 = icmp uge i64 0, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

idx.bad59:                                        ; preds = %idx.ok53
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 0, ptr @.failb.24, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok53
  %arr.data61 = getelementptr i8, ptr %d56, i64 8
  %arr.elem62 = getelementptr inbounds double, ptr %arr.data61, i64 0
  %elem63 = load double, ptr %arr.elem62, align 8
  %d64 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len65 = load i64, ptr %d64, align 8
  %arr.oob66 = icmp uge i64 1, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !2

idx.bad67:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 1, ptr @.failb.27, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %idx.ok60
  %arr.data69 = getelementptr i8, ptr %d64, i64 8
  %arr.elem70 = getelementptr inbounds double, ptr %arr.data69, i64 1
  %elem71 = load double, ptr %arr.elem70, align 8
  %19 = fadd double %elem63, %elem71
  store double %19, ptr %arr.elem55, align 8
  store i64 0, ptr %sum, align 8
  %a72 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %fe.len = load i64, ptr %a72, align 8
  %fe.len32 = trunc i64 %fe.len to i32
  store i32 0, ptr %fe.i, align 4
  br label %fe.cond

fe.cond:                                          ; preds = %fe.update, %idx.ok68
  %fe.iv = load i32, ptr %fe.i, align 4
  %20 = icmp slt i32 %fe.iv, %fe.len32
  br i1 %20, label %fe.body, label %fe.end

fe.body:                                          ; preds = %fe.cond
  %21 = sext i32 %fe.iv to i64
  %arr.len73 = load i64, ptr %a72, align 8
  %arr.oob74 = icmp uge i64 %21, %arr.len73
  br i1 %arr.oob74, label %idx.bad75, label %idx.ok76, !prof !2

fe.update:                                        ; preds = %idx.ok76
  %22 = load i32, ptr %fe.i, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %fe.i, align 4
  br label %fe.cond

fe.end:                                           ; preds = %fe.cond
  %a81 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len82 = load i64, ptr %a81, align 8
  %arr.oob83 = icmp uge i64 2, %arr.len82
  br i1 %arr.oob83, label %idx.bad84, label %idx.ok85, !prof !2

idx.bad75:                                        ; preds = %fe.body
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 %21, ptr @.failb.30, i64 %arr.len73, i32 70)
  unreachable

idx.ok76:                                         ; preds = %fe.body
  %arr.data77 = getelementptr i8, ptr %a72, i64 8
  %arr.elem78 = getelementptr inbounds i64, ptr %arr.data77, i64 %21
  %fe.el = load i64, ptr %arr.elem78, align 8
  store i64 %fe.el, ptr %x, align 8
  %sum79 = load i64, ptr %sum, align 8
  %x80 = load i64, ptr %x, align 8
  %24 = add i64 %sum79, %x80
  store i64 %24, ptr %sum, align 8
  br label %fe.update

idx.bad84:                                        ; preds = %fe.end
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 2, ptr @.failb.33, i64 %arr.len82, i32 70)
  unreachable

idx.ok85:                                         ; preds = %fe.end
  %arr.data86 = getelementptr i8, ptr %a81, i64 8
  %arr.elem87 = getelementptr inbounds i64, ptr %arr.data86, i64 2
  %elem88 = load i64, ptr %arr.elem87, align 8
  %d89 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len90 = load i64, ptr %d89, align 8
  %arr.oob91 = icmp uge i64 2, %arr.len90
  br i1 %arr.oob91, label %idx.bad92, label %idx.ok93, !prof !2

idx.bad92:                                        ; preds = %idx.ok85
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 2, ptr @.failb.36, i64 %arr.len90, i32 70)
  unreachable

idx.ok93:                                         ; preds = %idx.ok85
  %arr.data94 = getelementptr i8, ptr %d89, i64 8
  %arr.elem95 = getelementptr inbounds double, ptr %arr.data94, i64 2
  %elem96 = load double, ptr %arr.elem95, align 8
  %25 = call i32 @llvm.fptosi.sat.i32.f64(double %elem96)
  %sum97 = load i64, ptr %sum, align 8
  %a98 = load ptr, ptr %a, align 8
  %len = load i64, ptr %a98, align 8
  %26 = trunc i64 %len to i32
  %27 = call i32 (ptr, ...) @printf(ptr @.str, i64 %elem88, i32 %25, i64 %sum97, i32 %26)
  %a99 = load ptr, ptr %a, align 8
  call void @__polaron_free(ptr %a99)
  %d100 = load ptr, ptr %d, align 8
  call void @__polaron_free(ptr %d100)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5345)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5347)
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

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #1

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
