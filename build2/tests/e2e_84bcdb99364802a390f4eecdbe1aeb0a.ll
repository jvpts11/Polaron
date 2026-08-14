; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:11:25  in Sorter.sort\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:11:25  in Sorter.sort\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:12:29  in Sorter.sort\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:13:34  in Sorter.sort\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:13:34  in Sorter.sort\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:14:38  in Sorter.sort\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:24:22  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:24:32  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:24:42  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:24:52  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:24:62  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:26:42  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:26:42  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:26:42  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:26:42  in main\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bubble_sort.pol:26:42  in main\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [16 x i8] c"%d %d %d %d %d\0A\00", align 1
@.strdata.5353 = private constant [1 x i8] zeroinitializer
@.strobj.5354 = private global %String { i64 0, ptr @.strdata.5353, i64 0 }
@.strdata.5355 = private constant [1 x i8] zeroinitializer
@.strobj.5356 = private global %String { i64 0, ptr @.strdata.5355, i64 0 }

define internal void @Sorter.sort(ptr %0) {
entry:
  %tmp = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %len = load i64, ptr %a1, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %n, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %n3 = load i32, ptr %n, align 4
  %2 = sub i32 %n3, 1
  %3 = icmp slt i32 %i2, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond4

for.update:                                       ; preds = %for.end7
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

for.cond4:                                        ; preds = %for.update6, %for.body
  %j8 = load i32, ptr %j, align 4
  %n9 = load i32, ptr %n, align 4
  %7 = sub i32 %n9, 1
  %i10 = load i32, ptr %i, align 4
  %8 = sub i32 %7, %i10
  %9 = icmp slt i32 %j8, %8
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body5, label %for.end7

for.body5:                                        ; preds = %for.cond4
  %a11 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j12 = load i32, ptr %j, align 4
  %11 = sext i32 %j12 to i64
  %arr.len = load i64, ptr %a11, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update6:                                      ; preds = %if.end
  %12 = load i32, ptr %j, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %j, align 4
  br label %for.cond4

for.end7:                                         ; preds = %for.cond4
  br label %for.update

idx.bad:                                          ; preds = %for.body5
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %11, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body5
  %arr.data = getelementptr i8, ptr %a11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %11
  %elem = load i32, ptr %arr.elem, align 4
  %a13 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j14 = load i32, ptr %j, align 4
  %14 = add i32 %j14, 1
  %15 = sext i32 %14 to i64
  %arr.len15 = load i64, ptr %a13, align 8
  %arr.oob16 = icmp uge i64 %15, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %15, ptr @.failb.3, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok
  %arr.data19 = getelementptr i8, ptr %a13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %15
  %elem21 = load i32, ptr %arr.elem20, align 4
  %16 = icmp sgt i32 %elem, %elem21
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok18
  %a22 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j23 = load i32, ptr %j, align 4
  %18 = sext i32 %j23 to i64
  %arr.len24 = load i64, ptr %a22, align 8
  %arr.oob25 = icmp uge i64 %18, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !2

if.end:                                           ; preds = %idx.ok53, %idx.ok18
  br label %for.update6

idx.bad26:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 %18, ptr @.failb.6, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %if.then
  %arr.data28 = getelementptr i8, ptr %a22, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 %18
  %elem30 = load i32, ptr %arr.elem29, align 4
  store i32 %elem30, ptr %tmp, align 4
  %a31 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j32 = load i32, ptr %j, align 4
  %19 = sext i32 %j32 to i64
  %arr.len33 = load i64, ptr %a31, align 8
  %arr.oob34 = icmp uge i64 %19, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 %19, ptr @.failb.9, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok27
  %arr.data37 = getelementptr i8, ptr %a31, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 %19
  %a39 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j40 = load i32, ptr %j, align 4
  %20 = add i32 %j40, 1
  %21 = sext i32 %20 to i64
  %arr.len41 = load i64, ptr %a39, align 8
  %arr.oob42 = icmp uge i64 %21, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !2

idx.bad43:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 %21, ptr @.failb.12, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %idx.ok36
  %arr.data45 = getelementptr i8, ptr %a39, i64 8
  %arr.elem46 = getelementptr inbounds i32, ptr %arr.data45, i64 %21
  %elem47 = load i32, ptr %arr.elem46, align 4
  store i32 %elem47, ptr %arr.elem38, align 4
  %a48 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j49 = load i32, ptr %j, align 4
  %22 = add i32 %j49, 1
  %23 = sext i32 %22 to i64
  %arr.len50 = load i64, ptr %a48, align 8
  %arr.oob51 = icmp uge i64 %23, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !2

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 %23, ptr @.failb.15, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %a48, i64 8
  %arr.elem55 = getelementptr inbounds i32, ptr %arr.data54, i64 %23
  %tmp56 = load i32, ptr %tmp, align 4
  store i32 %tmp56, ptr %arr.elem55, align 4
  br label %if.end
}

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
  %arr = call ptr @__polaron_malloc(i64 28)
  store i64 5, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 20)
  store ptr %arr, ptr %a, align 8
  %a2 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 0, ptr @.failb.18, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %a2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 5, ptr %arr.elem, align 4
  %a4 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %a4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 1, ptr @.failb.21, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %a4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 2, ptr %arr.elem10, align 4
  %a11 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %a11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 2, ptr @.failb.24, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %a11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 8, ptr %arr.elem17, align 4
  %a18 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %a18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 3, ptr @.failb.27, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %a18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 3
  store i32 1, ptr %arr.elem24, align 4
  %a25 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len26 = load i64, ptr %a25, align 8
  %arr.oob27 = icmp uge i64 4, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 4, ptr @.failb.30, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %a25, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 4
  store i32 9, ptr %arr.elem31, align 4
  %a32 = load ptr, ptr %a, align 8
  call void @Sorter.sort(ptr %a32)
  %a33 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len34 = load i64, ptr %a33, align 8
  %arr.oob35 = icmp uge i64 0, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !2

idx.bad36:                                        ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 0, ptr @.failb.33, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %idx.ok29
  %arr.data38 = getelementptr i8, ptr %a33, i64 8
  %arr.elem39 = getelementptr inbounds i32, ptr %arr.data38, i64 0
  %elem = load i32, ptr %arr.elem39, align 4
  %a40 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len41 = load i64, ptr %a40, align 8
  %arr.oob42 = icmp uge i64 1, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !2

idx.bad43:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 1, ptr @.failb.36, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %idx.ok37
  %arr.data45 = getelementptr i8, ptr %a40, i64 8
  %arr.elem46 = getelementptr inbounds i32, ptr %arr.data45, i64 1
  %elem47 = load i32, ptr %arr.elem46, align 4
  %a48 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len49 = load i64, ptr %a48, align 8
  %arr.oob50 = icmp uge i64 2, %arr.len49
  br i1 %arr.oob50, label %idx.bad51, label %idx.ok52, !prof !2

idx.bad51:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 2, ptr @.failb.39, i64 %arr.len49, i32 70)
  unreachable

idx.ok52:                                         ; preds = %idx.ok44
  %arr.data53 = getelementptr i8, ptr %a48, i64 8
  %arr.elem54 = getelementptr inbounds i32, ptr %arr.data53, i64 2
  %elem55 = load i32, ptr %arr.elem54, align 4
  %a56 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len57 = load i64, ptr %a56, align 8
  %arr.oob58 = icmp uge i64 3, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

idx.bad59:                                        ; preds = %idx.ok52
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 3, ptr @.failb.42, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok52
  %arr.data61 = getelementptr i8, ptr %a56, i64 8
  %arr.elem62 = getelementptr inbounds i32, ptr %arr.data61, i64 3
  %elem63 = load i32, ptr %arr.elem62, align 4
  %a64 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len65 = load i64, ptr %a64, align 8
  %arr.oob66 = icmp uge i64 4, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !2

idx.bad67:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 4, ptr @.failb.45, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %idx.ok60
  %arr.data69 = getelementptr i8, ptr %a64, i64 8
  %arr.elem70 = getelementptr inbounds i32, ptr %arr.data69, i64 4
  %elem71 = load i32, ptr %arr.elem70, align 4
  %17 = call i32 (ptr, ...) @printf(ptr @.str, i32 %elem, i32 %elem47, i32 %elem55, i32 %elem63, i32 %elem71)
  %a72 = load ptr, ptr %a, align 8
  call void @__polaron_free(ptr %a72)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5354)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5356)
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

declare void @__polaron_free(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
