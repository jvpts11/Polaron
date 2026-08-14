; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:12:21  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:12:29  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:12:37  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:12:45  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:12:53  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:12:61  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:12:69  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:12:77  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:15:21  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:15:29  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:15:37  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:15:45  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:15:53  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:15:61  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:15:69  in main\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:15:77  in main\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:18:21  in main\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.49 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:18:29  in main\0A\00", align 1
@.faila.50 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.51 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.52 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:18:37  in main\0A\00", align 1
@.faila.53 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.54 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.55 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:18:45  in main\0A\00", align 1
@.faila.56 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.57 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.58 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:18:53  in main\0A\00", align 1
@.faila.59 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.60 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.61 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:18:61  in main\0A\00", align 1
@.faila.62 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.63 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.64 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:18:69  in main\0A\00", align 1
@.faila.65 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.66 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.67 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/quickselect.pol:18:77  in main\0A\00", align 1
@.faila.68 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.69 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [21 x i8] c"min=%d k3=%d max=%d\0A\00", align 1
@.fail.2093 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2676:17  in QuickSelect.partition\0A\00", align 1
@.faila.2094 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2095 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2096 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2679:21  in QuickSelect.partition\0A\00", align 1
@.faila.2097 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2098 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2099 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2680:25  in QuickSelect.partition\0A\00", align 1
@.faila.2100 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2101 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2102 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2680:44  in QuickSelect.partition\0A\00", align 1
@.faila.2103 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2104 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2105 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2680:44  in QuickSelect.partition\0A\00", align 1
@.faila.2106 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2107 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2108 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2680:57  in QuickSelect.partition\0A\00", align 1
@.faila.2109 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2110 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2111 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2684:17  in QuickSelect.partition\0A\00", align 1
@.faila.2112 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2113 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2114 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2684:37  in QuickSelect.partition\0A\00", align 1
@.faila.2115 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2116 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2117 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2684:37  in QuickSelect.partition\0A\00", align 1
@.faila.2118 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2119 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2120 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2684:52  in QuickSelect.partition\0A\00", align 1
@.faila.2121 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2122 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2123 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2692:35  in QuickSelect.select\0A\00", align 1
@.faila.2124 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2125 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2126 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2695:17  in QuickSelect.select\0A\00", align 1
@.faila.2127 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2128 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5377 = private constant [1 x i8] zeroinitializer
@.strobj.5378 = private global %String { i64 0, ptr @.strdata.5377, i64 0 }
@.strdata.5379 = private constant [1 x i8] zeroinitializer
@.strobj.5380 = private global %String { i64 0, ptr @.strdata.5379, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %mx = alloca i32, align 4
  %c = alloca ptr, align 8
  %med = alloca i32, align 4
  %b = alloca ptr, align 8
  %mn = alloca i32, align 4
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
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 32)
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
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 3, ptr %arr.elem, align 4
  %a4 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %a4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %a4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 1, ptr %arr.elem10, align 4
  %a11 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %a11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %a11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 4, ptr %arr.elem17, align 4
  %a18 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %a18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
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
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %a25, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 4
  store i32 5, ptr %arr.elem31, align 4
  %a32 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len33 = load i64, ptr %a32, align 8
  %arr.oob34 = icmp uge i64 5, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 5, ptr @.failb.15, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok29
  %arr.data37 = getelementptr i8, ptr %a32, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 5
  store i32 9, ptr %arr.elem38, align 4
  %a39 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len40 = load i64, ptr %a39, align 8
  %arr.oob41 = icmp uge i64 6, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !2

idx.bad42:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 6, ptr @.failb.18, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok36
  %arr.data44 = getelementptr i8, ptr %a39, i64 8
  %arr.elem45 = getelementptr inbounds i32, ptr %arr.data44, i64 6
  store i32 2, ptr %arr.elem45, align 4
  %a46 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len47 = load i64, ptr %a46, align 8
  %arr.oob48 = icmp uge i64 7, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

idx.bad49:                                        ; preds = %idx.ok43
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 7, ptr @.failb.21, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %idx.ok43
  %arr.data51 = getelementptr i8, ptr %a46, i64 8
  %arr.elem52 = getelementptr inbounds i32, ptr %arr.data51, i64 7
  store i32 6, ptr %arr.elem52, align 4
  %a53 = load ptr, ptr %a, align 8
  %17 = call i32 @QuickSelect.select(ptr %a53, i32 8, i32 0)
  store i32 %17, ptr %mn, align 4
  %arr54 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr54, align 8
  %arr.data55 = getelementptr i8, ptr %arr54, i64 8
  %18 = call ptr @memset(ptr %arr.data55, i32 0, i64 32)
  store ptr %arr54, ptr %b, align 8
  %b56 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len57 = load i64, ptr %b56, align 8
  %arr.oob58 = icmp uge i64 0, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

idx.bad59:                                        ; preds = %idx.ok50
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 0, ptr @.failb.24, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok50
  %arr.data61 = getelementptr i8, ptr %b56, i64 8
  %arr.elem62 = getelementptr inbounds i32, ptr %arr.data61, i64 0
  store i32 3, ptr %arr.elem62, align 4
  %b63 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len64 = load i64, ptr %b63, align 8
  %arr.oob65 = icmp uge i64 1, %arr.len64
  br i1 %arr.oob65, label %idx.bad66, label %idx.ok67, !prof !2

idx.bad66:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 1, ptr @.failb.27, i64 %arr.len64, i32 70)
  unreachable

idx.ok67:                                         ; preds = %idx.ok60
  %arr.data68 = getelementptr i8, ptr %b63, i64 8
  %arr.elem69 = getelementptr inbounds i32, ptr %arr.data68, i64 1
  store i32 1, ptr %arr.elem69, align 4
  %b70 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len71 = load i64, ptr %b70, align 8
  %arr.oob72 = icmp uge i64 2, %arr.len71
  br i1 %arr.oob72, label %idx.bad73, label %idx.ok74, !prof !2

idx.bad73:                                        ; preds = %idx.ok67
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 2, ptr @.failb.30, i64 %arr.len71, i32 70)
  unreachable

idx.ok74:                                         ; preds = %idx.ok67
  %arr.data75 = getelementptr i8, ptr %b70, i64 8
  %arr.elem76 = getelementptr inbounds i32, ptr %arr.data75, i64 2
  store i32 4, ptr %arr.elem76, align 4
  %b77 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len78 = load i64, ptr %b77, align 8
  %arr.oob79 = icmp uge i64 3, %arr.len78
  br i1 %arr.oob79, label %idx.bad80, label %idx.ok81, !prof !2

idx.bad80:                                        ; preds = %idx.ok74
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 3, ptr @.failb.33, i64 %arr.len78, i32 70)
  unreachable

idx.ok81:                                         ; preds = %idx.ok74
  %arr.data82 = getelementptr i8, ptr %b77, i64 8
  %arr.elem83 = getelementptr inbounds i32, ptr %arr.data82, i64 3
  store i32 1, ptr %arr.elem83, align 4
  %b84 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len85 = load i64, ptr %b84, align 8
  %arr.oob86 = icmp uge i64 4, %arr.len85
  br i1 %arr.oob86, label %idx.bad87, label %idx.ok88, !prof !2

idx.bad87:                                        ; preds = %idx.ok81
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 4, ptr @.failb.36, i64 %arr.len85, i32 70)
  unreachable

idx.ok88:                                         ; preds = %idx.ok81
  %arr.data89 = getelementptr i8, ptr %b84, i64 8
  %arr.elem90 = getelementptr inbounds i32, ptr %arr.data89, i64 4
  store i32 5, ptr %arr.elem90, align 4
  %b91 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len92 = load i64, ptr %b91, align 8
  %arr.oob93 = icmp uge i64 5, %arr.len92
  br i1 %arr.oob93, label %idx.bad94, label %idx.ok95, !prof !2

idx.bad94:                                        ; preds = %idx.ok88
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 5, ptr @.failb.39, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %idx.ok88
  %arr.data96 = getelementptr i8, ptr %b91, i64 8
  %arr.elem97 = getelementptr inbounds i32, ptr %arr.data96, i64 5
  store i32 9, ptr %arr.elem97, align 4
  %b98 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len99 = load i64, ptr %b98, align 8
  %arr.oob100 = icmp uge i64 6, %arr.len99
  br i1 %arr.oob100, label %idx.bad101, label %idx.ok102, !prof !2

idx.bad101:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 6, ptr @.failb.42, i64 %arr.len99, i32 70)
  unreachable

idx.ok102:                                        ; preds = %idx.ok95
  %arr.data103 = getelementptr i8, ptr %b98, i64 8
  %arr.elem104 = getelementptr inbounds i32, ptr %arr.data103, i64 6
  store i32 2, ptr %arr.elem104, align 4
  %b105 = load ptr, ptr %b, align 8, !nonnull !0, !dereferenceable !1
  %arr.len106 = load i64, ptr %b105, align 8
  %arr.oob107 = icmp uge i64 7, %arr.len106
  br i1 %arr.oob107, label %idx.bad108, label %idx.ok109, !prof !2

idx.bad108:                                       ; preds = %idx.ok102
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 7, ptr @.failb.45, i64 %arr.len106, i32 70)
  unreachable

idx.ok109:                                        ; preds = %idx.ok102
  %arr.data110 = getelementptr i8, ptr %b105, i64 8
  %arr.elem111 = getelementptr inbounds i32, ptr %arr.data110, i64 7
  store i32 6, ptr %arr.elem111, align 4
  %b112 = load ptr, ptr %b, align 8
  %19 = call i32 @QuickSelect.select(ptr %b112, i32 8, i32 3)
  store i32 %19, ptr %med, align 4
  %arr113 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr113, align 8
  %arr.data114 = getelementptr i8, ptr %arr113, i64 8
  %20 = call ptr @memset(ptr %arr.data114, i32 0, i64 32)
  store ptr %arr113, ptr %c, align 8
  %c115 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len116 = load i64, ptr %c115, align 8
  %arr.oob117 = icmp uge i64 0, %arr.len116
  br i1 %arr.oob117, label %idx.bad118, label %idx.ok119, !prof !2

idx.bad118:                                       ; preds = %idx.ok109
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 0, ptr @.failb.48, i64 %arr.len116, i32 70)
  unreachable

idx.ok119:                                        ; preds = %idx.ok109
  %arr.data120 = getelementptr i8, ptr %c115, i64 8
  %arr.elem121 = getelementptr inbounds i32, ptr %arr.data120, i64 0
  store i32 3, ptr %arr.elem121, align 4
  %c122 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len123 = load i64, ptr %c122, align 8
  %arr.oob124 = icmp uge i64 1, %arr.len123
  br i1 %arr.oob124, label %idx.bad125, label %idx.ok126, !prof !2

idx.bad125:                                       ; preds = %idx.ok119
  call void @__polaron_fail(ptr @.fail.49, ptr @.faila.50, i64 1, ptr @.failb.51, i64 %arr.len123, i32 70)
  unreachable

idx.ok126:                                        ; preds = %idx.ok119
  %arr.data127 = getelementptr i8, ptr %c122, i64 8
  %arr.elem128 = getelementptr inbounds i32, ptr %arr.data127, i64 1
  store i32 1, ptr %arr.elem128, align 4
  %c129 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len130 = load i64, ptr %c129, align 8
  %arr.oob131 = icmp uge i64 2, %arr.len130
  br i1 %arr.oob131, label %idx.bad132, label %idx.ok133, !prof !2

idx.bad132:                                       ; preds = %idx.ok126
  call void @__polaron_fail(ptr @.fail.52, ptr @.faila.53, i64 2, ptr @.failb.54, i64 %arr.len130, i32 70)
  unreachable

idx.ok133:                                        ; preds = %idx.ok126
  %arr.data134 = getelementptr i8, ptr %c129, i64 8
  %arr.elem135 = getelementptr inbounds i32, ptr %arr.data134, i64 2
  store i32 4, ptr %arr.elem135, align 4
  %c136 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len137 = load i64, ptr %c136, align 8
  %arr.oob138 = icmp uge i64 3, %arr.len137
  br i1 %arr.oob138, label %idx.bad139, label %idx.ok140, !prof !2

idx.bad139:                                       ; preds = %idx.ok133
  call void @__polaron_fail(ptr @.fail.55, ptr @.faila.56, i64 3, ptr @.failb.57, i64 %arr.len137, i32 70)
  unreachable

idx.ok140:                                        ; preds = %idx.ok133
  %arr.data141 = getelementptr i8, ptr %c136, i64 8
  %arr.elem142 = getelementptr inbounds i32, ptr %arr.data141, i64 3
  store i32 1, ptr %arr.elem142, align 4
  %c143 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len144 = load i64, ptr %c143, align 8
  %arr.oob145 = icmp uge i64 4, %arr.len144
  br i1 %arr.oob145, label %idx.bad146, label %idx.ok147, !prof !2

idx.bad146:                                       ; preds = %idx.ok140
  call void @__polaron_fail(ptr @.fail.58, ptr @.faila.59, i64 4, ptr @.failb.60, i64 %arr.len144, i32 70)
  unreachable

idx.ok147:                                        ; preds = %idx.ok140
  %arr.data148 = getelementptr i8, ptr %c143, i64 8
  %arr.elem149 = getelementptr inbounds i32, ptr %arr.data148, i64 4
  store i32 5, ptr %arr.elem149, align 4
  %c150 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len151 = load i64, ptr %c150, align 8
  %arr.oob152 = icmp uge i64 5, %arr.len151
  br i1 %arr.oob152, label %idx.bad153, label %idx.ok154, !prof !2

idx.bad153:                                       ; preds = %idx.ok147
  call void @__polaron_fail(ptr @.fail.61, ptr @.faila.62, i64 5, ptr @.failb.63, i64 %arr.len151, i32 70)
  unreachable

idx.ok154:                                        ; preds = %idx.ok147
  %arr.data155 = getelementptr i8, ptr %c150, i64 8
  %arr.elem156 = getelementptr inbounds i32, ptr %arr.data155, i64 5
  store i32 9, ptr %arr.elem156, align 4
  %c157 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len158 = load i64, ptr %c157, align 8
  %arr.oob159 = icmp uge i64 6, %arr.len158
  br i1 %arr.oob159, label %idx.bad160, label %idx.ok161, !prof !2

idx.bad160:                                       ; preds = %idx.ok154
  call void @__polaron_fail(ptr @.fail.64, ptr @.faila.65, i64 6, ptr @.failb.66, i64 %arr.len158, i32 70)
  unreachable

idx.ok161:                                        ; preds = %idx.ok154
  %arr.data162 = getelementptr i8, ptr %c157, i64 8
  %arr.elem163 = getelementptr inbounds i32, ptr %arr.data162, i64 6
  store i32 2, ptr %arr.elem163, align 4
  %c164 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len165 = load i64, ptr %c164, align 8
  %arr.oob166 = icmp uge i64 7, %arr.len165
  br i1 %arr.oob166, label %idx.bad167, label %idx.ok168, !prof !2

idx.bad167:                                       ; preds = %idx.ok161
  call void @__polaron_fail(ptr @.fail.67, ptr @.faila.68, i64 7, ptr @.failb.69, i64 %arr.len165, i32 70)
  unreachable

idx.ok168:                                        ; preds = %idx.ok161
  %arr.data169 = getelementptr i8, ptr %c164, i64 8
  %arr.elem170 = getelementptr inbounds i32, ptr %arr.data169, i64 7
  store i32 6, ptr %arr.elem170, align 4
  %c171 = load ptr, ptr %c, align 8
  %21 = call i32 @QuickSelect.select(ptr %c171, i32 8, i32 7)
  store i32 %21, ptr %mx, align 4
  %mn172 = load i32, ptr %mn, align 4
  %med173 = load i32, ptr %med, align 4
  %mx174 = load i32, ptr %mx, align 4
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %mn172, i32 %med173, i32 %mx174)
  ret i32 0
}

define internal i32 @QuickSelect.partition(ptr %0, i32 %1, i32 %2) {
entry:
  %t2 = alloca i32, align 4
  %t = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %pivot = alloca i32, align 4
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %lo, align 4
  store i32 %2, ptr %hi, align 4
  %a1 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %hi2 = load i32, ptr %hi, align 4
  %3 = sext i32 %hi2 to i64
  %arr.len = load i64, ptr %a1, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.2093, ptr @.faila.2094, i64 %3, ptr @.failb.2095, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %a1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %3
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %pivot, align 4
  %lo3 = load i32, ptr %lo, align 4
  store i32 %lo3, ptr %i, align 4
  %lo4 = load i32, ptr %lo, align 4
  store i32 %lo4, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %j5 = load i32, ptr %j, align 4
  %hi6 = load i32, ptr %hi, align 4
  %4 = icmp slt i32 %j5, %hi6
  %5 = zext i1 %4 to i32
  br i1 %4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %a7 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j8 = load i32, ptr %j, align 4
  %6 = sext i32 %j8 to i64
  %arr.len9 = load i64, ptr %a7, align 8
  %arr.oob10 = icmp uge i64 %6, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

for.update:                                       ; preds = %if.end
  %7 = load i32, ptr %j, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %a53 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i54 = load i32, ptr %i, align 4
  %9 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %a53, align 8
  %arr.oob56 = icmp uge i64 %9, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

idx.bad11:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2096, ptr @.faila.2097, i64 %6, ptr @.failb.2098, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %a7, i64 8
  %arr.elem14 = getelementptr inbounds i32, ptr %arr.data13, i64 %6
  %elem15 = load i32, ptr %arr.elem14, align 4
  %pivot16 = load i32, ptr %pivot, align 4
  %10 = icmp slt i32 %elem15, %pivot16
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok12
  %a17 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i18 = load i32, ptr %i, align 4
  %12 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %a17, align 8
  %arr.oob20 = icmp uge i64 %12, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

if.end:                                           ; preds = %idx.ok48, %idx.ok12
  br label %for.update

idx.bad21:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2099, ptr @.faila.2100, i64 %12, ptr @.failb.2101, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %if.then
  %arr.data23 = getelementptr i8, ptr %a17, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %12
  %elem25 = load i32, ptr %arr.elem24, align 4
  store i32 %elem25, ptr %t, align 4
  %a26 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %13 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %a26, align 8
  %arr.oob29 = icmp uge i64 %13, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.2102, ptr @.faila.2103, i64 %13, ptr @.failb.2104, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok22
  %arr.data32 = getelementptr i8, ptr %a26, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %13
  %a34 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j35 = load i32, ptr %j, align 4
  %14 = sext i32 %j35 to i64
  %arr.len36 = load i64, ptr %a34, align 8
  %arr.oob37 = icmp uge i64 %14, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad38:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.2105, ptr @.faila.2106, i64 %14, ptr @.failb.2107, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok31
  %arr.data40 = getelementptr i8, ptr %a34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %14
  %elem42 = load i32, ptr %arr.elem41, align 4
  store i32 %elem42, ptr %arr.elem33, align 4
  %a43 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %j44 = load i32, ptr %j, align 4
  %15 = sext i32 %j44 to i64
  %arr.len45 = load i64, ptr %a43, align 8
  %arr.oob46 = icmp uge i64 %15, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

idx.bad47:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.2108, ptr @.faila.2109, i64 %15, ptr @.failb.2110, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok39
  %arr.data49 = getelementptr i8, ptr %a43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %15
  %t51 = load i32, ptr %t, align 4
  store i32 %t51, ptr %arr.elem50, align 4
  %i52 = load i32, ptr %i, align 4
  %16 = add i32 %i52, 1
  store i32 %16, ptr %i, align 4
  br label %if.end

idx.bad57:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.2111, ptr @.faila.2112, i64 %9, ptr @.failb.2113, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %for.end
  %arr.data59 = getelementptr i8, ptr %a53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %9
  %elem61 = load i32, ptr %arr.elem60, align 4
  store i32 %elem61, ptr %t2, align 4
  %a62 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i63 = load i32, ptr %i, align 4
  %17 = sext i32 %i63 to i64
  %arr.len64 = load i64, ptr %a62, align 8
  %arr.oob65 = icmp uge i64 %17, %arr.len64
  br i1 %arr.oob65, label %idx.bad66, label %idx.ok67, !prof !2

idx.bad66:                                        ; preds = %idx.ok58
  call void @__polaron_fail(ptr @.fail.2114, ptr @.faila.2115, i64 %17, ptr @.failb.2116, i64 %arr.len64, i32 70)
  unreachable

idx.ok67:                                         ; preds = %idx.ok58
  %arr.data68 = getelementptr i8, ptr %a62, i64 8
  %arr.elem69 = getelementptr inbounds i32, ptr %arr.data68, i64 %17
  %a70 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %hi71 = load i32, ptr %hi, align 4
  %18 = sext i32 %hi71 to i64
  %arr.len72 = load i64, ptr %a70, align 8
  %arr.oob73 = icmp uge i64 %18, %arr.len72
  br i1 %arr.oob73, label %idx.bad74, label %idx.ok75, !prof !2

idx.bad74:                                        ; preds = %idx.ok67
  call void @__polaron_fail(ptr @.fail.2117, ptr @.faila.2118, i64 %18, ptr @.failb.2119, i64 %arr.len72, i32 70)
  unreachable

idx.ok75:                                         ; preds = %idx.ok67
  %arr.data76 = getelementptr i8, ptr %a70, i64 8
  %arr.elem77 = getelementptr inbounds i32, ptr %arr.data76, i64 %18
  %elem78 = load i32, ptr %arr.elem77, align 4
  store i32 %elem78, ptr %arr.elem69, align 4
  %a79 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %hi80 = load i32, ptr %hi, align 4
  %19 = sext i32 %hi80 to i64
  %arr.len81 = load i64, ptr %a79, align 8
  %arr.oob82 = icmp uge i64 %19, %arr.len81
  br i1 %arr.oob82, label %idx.bad83, label %idx.ok84, !prof !2

idx.bad83:                                        ; preds = %idx.ok75
  call void @__polaron_fail(ptr @.fail.2120, ptr @.faila.2121, i64 %19, ptr @.failb.2122, i64 %arr.len81, i32 70)
  unreachable

idx.ok84:                                         ; preds = %idx.ok75
  %arr.data85 = getelementptr i8, ptr %a79, i64 8
  %arr.elem86 = getelementptr inbounds i32, ptr %arr.data85, i64 %19
  %t287 = load i32, ptr %t2, align 4
  store i32 %t287, ptr %arr.elem86, align 4
  %i88 = load i32, ptr %i, align 4
  ret i32 %i88
}

define internal i32 @QuickSelect.select(ptr %0, i32 %1, i32 %2) {
entry:
  %p = alloca i32, align 4
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %k = alloca i32, align 4
  %n = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %n, align 4
  store i32 %2, ptr %k, align 4
  store i32 0, ptr %lo, align 4
  %n1 = load i32, ptr %n, align 4
  %3 = sub i32 %n1, 1
  store i32 %3, ptr %hi, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end14, %entry
  %lo2 = load i32, ptr %lo, align 4
  %hi3 = load i32, ptr %hi, align 4
  %4 = icmp slt i32 %lo2, %hi3
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %a4 = load ptr, ptr %a, align 8
  %lo5 = load i32, ptr %lo, align 4
  %hi6 = load i32, ptr %hi, align 4
  %6 = call i32 @QuickSelect.partition(ptr %a4, i32 %lo5, i32 %hi6)
  store i32 %6, ptr %p, align 4
  %p7 = load i32, ptr %p, align 4
  %k8 = load i32, ptr %k, align 4
  %7 = icmp eq i32 %p7, %k8
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  %a17 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %lo18 = load i32, ptr %lo, align 4
  %9 = sext i32 %lo18 to i64
  %arr.len19 = load i64, ptr %a17, align 8
  %arr.oob20 = icmp uge i64 %9, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

if.then:                                          ; preds = %while.body
  %a9 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %p10 = load i32, ptr %p, align 4
  %10 = sext i32 %p10 to i64
  %arr.len = load i64, ptr %a9, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %while.body
  %p11 = load i32, ptr %p, align 4
  %k12 = load i32, ptr %k, align 4
  %11 = icmp slt i32 %p11, %k12
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then13, label %if.else

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2123, ptr @.faila.2124, i64 %10, ptr @.failb.2125, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %a9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem

if.then13:                                        ; preds = %if.end
  %p15 = load i32, ptr %p, align 4
  %13 = add i32 %p15, 1
  store i32 %13, ptr %lo, align 4
  br label %if.end14

if.else:                                          ; preds = %if.end
  %p16 = load i32, ptr %p, align 4
  %14 = sub i32 %p16, 1
  store i32 %14, ptr %hi, align 4
  br label %if.end14

if.end14:                                         ; preds = %if.else, %if.then13
  br label %while.cond

idx.bad21:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.2126, ptr @.faila.2127, i64 %9, ptr @.failb.2128, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %while.end
  %arr.data23 = getelementptr i8, ptr %a17, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %9
  %elem25 = load i32, ptr %arr.elem24, align 4
  ret i32 %elem25
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5378)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5380)
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

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
