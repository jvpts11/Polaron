; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Cell = type { i32, float, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:40:17  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:40:17  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:43:28  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:44:28  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:45:31  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:46:31  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:47:17  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:47:17  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:50:28  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:51:17  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:51:17  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:54:17  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:54:17  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:57:28  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:57:28  in main\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:58:17  in main\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:62:27  in main\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.49 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:62:27  in main\0A\00", align 1
@.faila.50 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.51 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.52 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:63:17  in main\0A\00", align 1
@.faila.53 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.54 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.55 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:63:17  in main\0A\00", align 1
@.faila.56 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.57 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.58 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:66:29  in main\0A\00", align 1
@.faila.59 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.60 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.61 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:67:17  in main\0A\00", align 1
@.faila.62 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.63 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.64 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_array.pol:67:17  in main\0A\00", align 1
@.faila.65 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.66 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"inline = %d\0A\00", align 1
@.strdata.5374 = private constant [1 x i8] zeroinitializer
@.strobj.5375 = private global %String { i64 0, ptr @.strdata.5374, i64 0 }
@.strdata.5376 = private constant [1 x i8] zeroinitializer
@.strobj.5377 = private global %String { i64 0, ptr @.strdata.5376, i64 0 }

define internal i32 @Cell.isKind(ptr nonnull align 4 dereferenceable(16) %0, i32 %1) {
entry:
  %k = alloca i32, align 4
  store i32 %1, ptr %k, align 4
  %kind = getelementptr inbounds %class.Cell, ptr %0, i32 0, i32 3
  %kind1 = load i32, ptr %kind, align 4, !tbaa !0
  %k2 = load i32, ptr %k, align 4
  %2 = icmp eq i32 %kind1, %k2
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %mirror = alloca ptr, align 8
  %score = alloca i32, align 4
  %cells = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 4, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 64)
  store ptr %arr, ptr %cells, align 8
  store i32 0, ptr %score, align 4
  %cells2 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len = load i64, ptr %cells2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %cells2, i64 8
  %arr.elem = getelementptr inbounds %class.Cell, ptr %arr.data3, i64 0
  %a = getelementptr inbounds %class.Cell, ptr %arr.elem, i32 0, i32 0
  %a4 = load i32, ptr %a, align 4, !tbaa !0
  %17 = icmp eq i32 %a4, 0
  %18 = zext i1 %17 to i32
  %sc.a = icmp ne i32 %18, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %idx.ok
  %cells5 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len6 = load i64, ptr %cells5, align 8
  %arr.oob7 = icmp uge i64 0, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !6

sc.end:                                           ; preds = %idx.ok9, %idx.ok
  %sc = phi i1 [ false, %idx.ok ], [ %sc.b, %idx.ok9 ]
  %19 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad8:                                         ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 0, ptr @.failb.3, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %sc.rhs
  %arr.data10 = getelementptr i8, ptr %cells5, i64 8
  %arr.elem11 = getelementptr inbounds %class.Cell, ptr %arr.data10, i64 0
  %flag = getelementptr inbounds %class.Cell, ptr %arr.elem11, i32 0, i32 2
  %flag12 = load i32, ptr %flag, align 4, !tbaa !0
  %20 = icmp eq i32 %flag12, 0
  %21 = zext i1 %20 to i32
  %sc.b = icmp ne i32 %21, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %score13 = load i32, ptr %score, align 4
  %22 = add i32 %score13, 1
  store i32 %22, ptr %score, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  %cells14 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len15 = load i64, ptr %cells14, align 8
  %arr.oob16 = icmp uge i64 0, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !6

idx.bad17:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 0, ptr @.failb.6, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %if.end
  %arr.data19 = getelementptr i8, ptr %cells14, i64 8
  %arr.elem20 = getelementptr inbounds %class.Cell, ptr %arr.data19, i64 0
  %a21 = getelementptr inbounds %class.Cell, ptr %arr.elem20, i32 0, i32 0
  store i32 7, ptr %a21, align 4, !tbaa !0
  %cells22 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len23 = load i64, ptr %cells22, align 8
  %arr.oob24 = icmp uge i64 0, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !6

idx.bad25:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 0, ptr @.failb.9, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok18
  %arr.data27 = getelementptr i8, ptr %cells22, i64 8
  %arr.elem28 = getelementptr inbounds %class.Cell, ptr %arr.data27, i64 0
  %b = getelementptr inbounds %class.Cell, ptr %arr.elem28, i32 0, i32 1
  store float 1.500000e+00, ptr %b, align 4, !tbaa !7
  %cells29 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len30 = load i64, ptr %cells29, align 8
  %arr.oob31 = icmp uge i64 0, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !6

idx.bad32:                                        ; preds = %idx.ok26
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 0, ptr @.failb.12, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %idx.ok26
  %arr.data34 = getelementptr i8, ptr %cells29, i64 8
  %arr.elem35 = getelementptr inbounds %class.Cell, ptr %arr.data34, i64 0
  %flag36 = getelementptr inbounds %class.Cell, ptr %arr.elem35, i32 0, i32 2
  store i32 1, ptr %flag36, align 4, !tbaa !0
  %cells37 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len38 = load i64, ptr %cells37, align 8
  %arr.oob39 = icmp uge i64 0, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !6

idx.bad40:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 0, ptr @.failb.15, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %idx.ok33
  %arr.data42 = getelementptr i8, ptr %cells37, i64 8
  %arr.elem43 = getelementptr inbounds %class.Cell, ptr %arr.data42, i64 0
  %kind = getelementptr inbounds %class.Cell, ptr %arr.elem43, i32 0, i32 3
  store i32 1, ptr %kind, align 4, !tbaa !0
  %cells44 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len45 = load i64, ptr %cells44, align 8
  %arr.oob46 = icmp uge i64 0, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !6

idx.bad47:                                        ; preds = %idx.ok41
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 0, ptr @.failb.18, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok41
  %arr.data49 = getelementptr i8, ptr %cells44, i64 8
  %arr.elem50 = getelementptr inbounds %class.Cell, ptr %arr.data49, i64 0
  %a51 = getelementptr inbounds %class.Cell, ptr %arr.elem50, i32 0, i32 0
  %a52 = load i32, ptr %a51, align 4, !tbaa !0
  %23 = icmp eq i32 %a52, 7
  %24 = zext i1 %23 to i32
  %sc.a53 = icmp ne i32 %24, 0
  br i1 %sc.a53, label %sc.rhs54, label %sc.end55

sc.rhs54:                                         ; preds = %idx.ok48
  %cells56 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len57 = load i64, ptr %cells56, align 8
  %arr.oob58 = icmp uge i64 0, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !6

sc.end55:                                         ; preds = %idx.ok60, %idx.ok48
  %sc66 = phi i1 [ false, %idx.ok48 ], [ %sc.b65, %idx.ok60 ]
  %25 = zext i1 %sc66 to i32
  br i1 %sc66, label %if.then67, label %if.end68

idx.bad59:                                        ; preds = %sc.rhs54
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 0, ptr @.failb.21, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %sc.rhs54
  %arr.data61 = getelementptr i8, ptr %cells56, i64 8
  %arr.elem62 = getelementptr inbounds %class.Cell, ptr %arr.data61, i64 0
  %flag63 = getelementptr inbounds %class.Cell, ptr %arr.elem62, i32 0, i32 2
  %flag64 = load i32, ptr %flag63, align 4, !tbaa !0
  %sc.b65 = icmp ne i32 %flag64, 0
  br label %sc.end55

if.then67:                                        ; preds = %sc.end55
  %score69 = load i32, ptr %score, align 4
  %26 = add i32 %score69, 1
  store i32 %26, ptr %score, align 4
  br label %if.end68

if.end68:                                         ; preds = %if.then67, %sc.end55
  %cells70 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len71 = load i64, ptr %cells70, align 8
  %arr.oob72 = icmp uge i64 3, %arr.len71
  br i1 %arr.oob72, label %idx.bad73, label %idx.ok74, !prof !6

idx.bad73:                                        ; preds = %if.end68
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 3, ptr @.failb.24, i64 %arr.len71, i32 70)
  unreachable

idx.ok74:                                         ; preds = %if.end68
  %arr.data75 = getelementptr i8, ptr %cells70, i64 8
  %arr.elem76 = getelementptr inbounds %class.Cell, ptr %arr.data75, i64 3
  %a77 = getelementptr inbounds %class.Cell, ptr %arr.elem76, i32 0, i32 0
  store i32 99, ptr %a77, align 4, !tbaa !0
  %cells78 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len79 = load i64, ptr %cells78, align 8
  %arr.oob80 = icmp uge i64 3, %arr.len79
  br i1 %arr.oob80, label %idx.bad81, label %idx.ok82, !prof !6

idx.bad81:                                        ; preds = %idx.ok74
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 3, ptr @.failb.27, i64 %arr.len79, i32 70)
  unreachable

idx.ok82:                                         ; preds = %idx.ok74
  %arr.data83 = getelementptr i8, ptr %cells78, i64 8
  %arr.elem84 = getelementptr inbounds %class.Cell, ptr %arr.data83, i64 3
  %a85 = getelementptr inbounds %class.Cell, ptr %arr.elem84, i32 0, i32 0
  %a86 = load i32, ptr %a85, align 4, !tbaa !0
  %27 = icmp eq i32 %a86, 99
  %28 = zext i1 %27 to i32
  %sc.a87 = icmp ne i32 %28, 0
  br i1 %sc.a87, label %sc.rhs88, label %sc.end89

sc.rhs88:                                         ; preds = %idx.ok82
  %cells90 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len91 = load i64, ptr %cells90, align 8
  %arr.oob92 = icmp uge i64 1, %arr.len91
  br i1 %arr.oob92, label %idx.bad93, label %idx.ok94, !prof !6

sc.end89:                                         ; preds = %idx.ok94, %idx.ok82
  %sc100 = phi i1 [ false, %idx.ok82 ], [ %sc.b99, %idx.ok94 ]
  %29 = zext i1 %sc100 to i32
  br i1 %sc100, label %if.then101, label %if.end102

idx.bad93:                                        ; preds = %sc.rhs88
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 1, ptr @.failb.30, i64 %arr.len91, i32 70)
  unreachable

idx.ok94:                                         ; preds = %sc.rhs88
  %arr.data95 = getelementptr i8, ptr %cells90, i64 8
  %arr.elem96 = getelementptr inbounds %class.Cell, ptr %arr.data95, i64 1
  %a97 = getelementptr inbounds %class.Cell, ptr %arr.elem96, i32 0, i32 0
  %a98 = load i32, ptr %a97, align 4, !tbaa !0
  %30 = icmp eq i32 %a98, 0
  %31 = zext i1 %30 to i32
  %sc.b99 = icmp ne i32 %31, 0
  br label %sc.end89

if.then101:                                       ; preds = %sc.end89
  %score103 = load i32, ptr %score, align 4
  %32 = add i32 %score103, 1
  store i32 %32, ptr %score, align 4
  br label %if.end102

if.end102:                                        ; preds = %if.then101, %sc.end89
  %cells104 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len105 = load i64, ptr %cells104, align 8
  %arr.oob106 = icmp uge i64 0, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !6

idx.bad107:                                       ; preds = %if.end102
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 0, ptr @.failb.33, i64 %arr.len105, i32 70)
  unreachable

idx.ok108:                                        ; preds = %if.end102
  %arr.data109 = getelementptr i8, ptr %cells104, i64 8
  %arr.elem110 = getelementptr inbounds %class.Cell, ptr %arr.data109, i64 0
  %33 = call i32 @Cell.isKind(ptr %arr.elem110, i32 1)
  %sc.a111 = icmp ne i32 %33, 0
  br i1 %sc.a111, label %sc.rhs112, label %sc.end113

sc.rhs112:                                        ; preds = %idx.ok108
  %cells114 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len115 = load i64, ptr %cells114, align 8
  %arr.oob116 = icmp uge i64 1, %arr.len115
  br i1 %arr.oob116, label %idx.bad117, label %idx.ok118, !prof !6

sc.end113:                                        ; preds = %idx.ok118, %idx.ok108
  %sc122 = phi i1 [ false, %idx.ok108 ], [ %sc.b121, %idx.ok118 ]
  %34 = zext i1 %sc122 to i32
  br i1 %sc122, label %if.then123, label %if.end124

idx.bad117:                                       ; preds = %sc.rhs112
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 1, ptr @.failb.36, i64 %arr.len115, i32 70)
  unreachable

idx.ok118:                                        ; preds = %sc.rhs112
  %arr.data119 = getelementptr i8, ptr %cells114, i64 8
  %arr.elem120 = getelementptr inbounds %class.Cell, ptr %arr.data119, i64 1
  %35 = call i32 @Cell.isKind(ptr %arr.elem120, i32 1)
  %36 = icmp eq i32 %35, 0
  %37 = zext i1 %36 to i32
  %sc.b121 = icmp ne i32 %37, 0
  br label %sc.end113

if.then123:                                       ; preds = %sc.end113
  %score125 = load i32, ptr %score, align 4
  %38 = add i32 %score125, 1
  store i32 %38, ptr %score, align 4
  br label %if.end124

if.end124:                                        ; preds = %if.then123, %sc.end113
  %cells126 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len127 = load i64, ptr %cells126, align 8
  %arr.oob128 = icmp uge i64 0, %arr.len127
  br i1 %arr.oob128, label %idx.bad129, label %idx.ok130, !prof !6

idx.bad129:                                       ; preds = %if.end124
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 0, ptr @.failb.39, i64 %arr.len127, i32 70)
  unreachable

idx.ok130:                                        ; preds = %if.end124
  %arr.data131 = getelementptr i8, ptr %cells126, i64 8
  %arr.elem132 = getelementptr inbounds %class.Cell, ptr %arr.data131, i64 0
  %a133 = getelementptr inbounds %class.Cell, ptr %arr.elem132, i32 0, i32 0
  %cells134 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len135 = load i64, ptr %cells134, align 8
  %arr.oob136 = icmp uge i64 0, %arr.len135
  br i1 %arr.oob136, label %idx.bad137, label %idx.ok138, !prof !6

idx.bad137:                                       ; preds = %idx.ok130
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 0, ptr @.failb.42, i64 %arr.len135, i32 70)
  unreachable

idx.ok138:                                        ; preds = %idx.ok130
  %arr.data139 = getelementptr i8, ptr %cells134, i64 8
  %arr.elem140 = getelementptr inbounds %class.Cell, ptr %arr.data139, i64 0
  %a141 = getelementptr inbounds %class.Cell, ptr %arr.elem140, i32 0, i32 0
  %a142 = load i32, ptr %a141, align 4, !tbaa !0
  %39 = add i32 %a142, 1
  store i32 %39, ptr %a133, align 4, !tbaa !0
  %cells143 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len144 = load i64, ptr %cells143, align 8
  %arr.oob145 = icmp uge i64 0, %arr.len144
  br i1 %arr.oob145, label %idx.bad146, label %idx.ok147, !prof !6

idx.bad146:                                       ; preds = %idx.ok138
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 0, ptr @.failb.45, i64 %arr.len144, i32 70)
  unreachable

idx.ok147:                                        ; preds = %idx.ok138
  %arr.data148 = getelementptr i8, ptr %cells143, i64 8
  %arr.elem149 = getelementptr inbounds %class.Cell, ptr %arr.data148, i64 0
  %a150 = getelementptr inbounds %class.Cell, ptr %arr.elem149, i32 0, i32 0
  %a151 = load i32, ptr %a150, align 4, !tbaa !0
  %40 = icmp eq i32 %a151, 8
  %41 = zext i1 %40 to i32
  br i1 %40, label %if.then152, label %if.end153

if.then152:                                       ; preds = %idx.ok147
  %score154 = load i32, ptr %score, align 4
  %42 = add i32 %score154, 1
  store i32 %42, ptr %score, align 4
  br label %if.end153

if.end153:                                        ; preds = %if.then152, %idx.ok147
  %arr155 = call ptr @__polaron_malloc(i64 72)
  store i64 4, ptr %arr155, align 8
  %arr.data156 = getelementptr i8, ptr %arr155, i64 8
  %43 = call ptr @memset(ptr %arr.data156, i32 0, i64 64)
  store ptr %arr155, ptr %mirror, align 8
  %mirror157 = load ptr, ptr %mirror, align 8, !nonnull !4, !dereferenceable !5
  %arr.len158 = load i64, ptr %mirror157, align 8
  %arr.oob159 = icmp uge i64 2, %arr.len158
  br i1 %arr.oob159, label %idx.bad160, label %idx.ok161, !prof !6

idx.bad160:                                       ; preds = %if.end153
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 2, ptr @.failb.48, i64 %arr.len158, i32 70)
  unreachable

idx.ok161:                                        ; preds = %if.end153
  %arr.data162 = getelementptr i8, ptr %mirror157, i64 8
  %arr.elem163 = getelementptr inbounds %class.Cell, ptr %arr.data162, i64 2
  %cells164 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len165 = load i64, ptr %cells164, align 8
  %arr.oob166 = icmp uge i64 0, %arr.len165
  br i1 %arr.oob166, label %idx.bad167, label %idx.ok168, !prof !6

idx.bad167:                                       ; preds = %idx.ok161
  call void @__polaron_fail(ptr @.fail.49, ptr @.faila.50, i64 0, ptr @.failb.51, i64 %arr.len165, i32 70)
  unreachable

idx.ok168:                                        ; preds = %idx.ok161
  %arr.data169 = getelementptr i8, ptr %cells164, i64 8
  %arr.elem170 = getelementptr inbounds %class.Cell, ptr %arr.data169, i64 0
  %44 = call ptr @memcpy(ptr %arr.elem163, ptr %arr.elem170, i64 ptrtoint (ptr getelementptr (%class.Cell, ptr null, i64 1) to i64))
  %mirror171 = load ptr, ptr %mirror, align 8, !nonnull !4, !dereferenceable !5
  %arr.len172 = load i64, ptr %mirror171, align 8
  %arr.oob173 = icmp uge i64 2, %arr.len172
  br i1 %arr.oob173, label %idx.bad174, label %idx.ok175, !prof !6

idx.bad174:                                       ; preds = %idx.ok168
  call void @__polaron_fail(ptr @.fail.52, ptr @.faila.53, i64 2, ptr @.failb.54, i64 %arr.len172, i32 70)
  unreachable

idx.ok175:                                        ; preds = %idx.ok168
  %arr.data176 = getelementptr i8, ptr %mirror171, i64 8
  %arr.elem177 = getelementptr inbounds %class.Cell, ptr %arr.data176, i64 2
  %a178 = getelementptr inbounds %class.Cell, ptr %arr.elem177, i32 0, i32 0
  %a179 = load i32, ptr %a178, align 4, !tbaa !0
  %45 = icmp eq i32 %a179, 8
  %46 = zext i1 %45 to i32
  %sc.a180 = icmp ne i32 %46, 0
  br i1 %sc.a180, label %sc.rhs181, label %sc.end182

sc.rhs181:                                        ; preds = %idx.ok175
  %mirror183 = load ptr, ptr %mirror, align 8, !nonnull !4, !dereferenceable !5
  %arr.len184 = load i64, ptr %mirror183, align 8
  %arr.oob185 = icmp uge i64 2, %arr.len184
  br i1 %arr.oob185, label %idx.bad186, label %idx.ok187, !prof !6

sc.end182:                                        ; preds = %idx.ok187, %idx.ok175
  %sc193 = phi i1 [ false, %idx.ok175 ], [ %sc.b192, %idx.ok187 ]
  %47 = zext i1 %sc193 to i32
  br i1 %sc193, label %if.then194, label %if.end195

idx.bad186:                                       ; preds = %sc.rhs181
  call void @__polaron_fail(ptr @.fail.55, ptr @.faila.56, i64 2, ptr @.failb.57, i64 %arr.len184, i32 70)
  unreachable

idx.ok187:                                        ; preds = %sc.rhs181
  %arr.data188 = getelementptr i8, ptr %mirror183, i64 8
  %arr.elem189 = getelementptr inbounds %class.Cell, ptr %arr.data188, i64 2
  %flag190 = getelementptr inbounds %class.Cell, ptr %arr.elem189, i32 0, i32 2
  %flag191 = load i32, ptr %flag190, align 4, !tbaa !0
  %sc.b192 = icmp ne i32 %flag191, 0
  br label %sc.end182

if.then194:                                       ; preds = %sc.end182
  %score196 = load i32, ptr %score, align 4
  %48 = add i32 %score196, 1
  store i32 %48, ptr %score, align 4
  br label %if.end195

if.end195:                                        ; preds = %if.then194, %sc.end182
  %mirror197 = load ptr, ptr %mirror, align 8, !nonnull !4, !dereferenceable !5
  %arr.len198 = load i64, ptr %mirror197, align 8
  %arr.oob199 = icmp uge i64 2, %arr.len198
  br i1 %arr.oob199, label %idx.bad200, label %idx.ok201, !prof !6

idx.bad200:                                       ; preds = %if.end195
  call void @__polaron_fail(ptr @.fail.58, ptr @.faila.59, i64 2, ptr @.failb.60, i64 %arr.len198, i32 70)
  unreachable

idx.ok201:                                        ; preds = %if.end195
  %arr.data202 = getelementptr i8, ptr %mirror197, i64 8
  %arr.elem203 = getelementptr inbounds %class.Cell, ptr %arr.data202, i64 2
  %a204 = getelementptr inbounds %class.Cell, ptr %arr.elem203, i32 0, i32 0
  store i32 123, ptr %a204, align 4, !tbaa !0
  %mirror205 = load ptr, ptr %mirror, align 8, !nonnull !4, !dereferenceable !5
  %arr.len206 = load i64, ptr %mirror205, align 8
  %arr.oob207 = icmp uge i64 2, %arr.len206
  br i1 %arr.oob207, label %idx.bad208, label %idx.ok209, !prof !6

idx.bad208:                                       ; preds = %idx.ok201
  call void @__polaron_fail(ptr @.fail.61, ptr @.faila.62, i64 2, ptr @.failb.63, i64 %arr.len206, i32 70)
  unreachable

idx.ok209:                                        ; preds = %idx.ok201
  %arr.data210 = getelementptr i8, ptr %mirror205, i64 8
  %arr.elem211 = getelementptr inbounds %class.Cell, ptr %arr.data210, i64 2
  %a212 = getelementptr inbounds %class.Cell, ptr %arr.elem211, i32 0, i32 0
  %a213 = load i32, ptr %a212, align 4, !tbaa !0
  %49 = icmp eq i32 %a213, 123
  %50 = zext i1 %49 to i32
  %sc.a214 = icmp ne i32 %50, 0
  br i1 %sc.a214, label %sc.rhs215, label %sc.end216

sc.rhs215:                                        ; preds = %idx.ok209
  %cells217 = load ptr, ptr %cells, align 8, !nonnull !4, !dereferenceable !5
  %arr.len218 = load i64, ptr %cells217, align 8
  %arr.oob219 = icmp uge i64 0, %arr.len218
  br i1 %arr.oob219, label %idx.bad220, label %idx.ok221, !prof !6

sc.end216:                                        ; preds = %idx.ok221, %idx.ok209
  %sc227 = phi i1 [ false, %idx.ok209 ], [ %sc.b226, %idx.ok221 ]
  %51 = zext i1 %sc227 to i32
  br i1 %sc227, label %if.then228, label %if.end229

idx.bad220:                                       ; preds = %sc.rhs215
  call void @__polaron_fail(ptr @.fail.64, ptr @.faila.65, i64 0, ptr @.failb.66, i64 %arr.len218, i32 70)
  unreachable

idx.ok221:                                        ; preds = %sc.rhs215
  %arr.data222 = getelementptr i8, ptr %cells217, i64 8
  %arr.elem223 = getelementptr inbounds %class.Cell, ptr %arr.data222, i64 0
  %a224 = getelementptr inbounds %class.Cell, ptr %arr.elem223, i32 0, i32 0
  %a225 = load i32, ptr %a224, align 4, !tbaa !0
  %52 = icmp eq i32 %a225, 8
  %53 = zext i1 %52 to i32
  %sc.b226 = icmp ne i32 %53, 0
  br label %sc.end216

if.then228:                                       ; preds = %sc.end216
  %score230 = load i32, ptr %score, align 4
  %54 = add i32 %score230, 1
  store i32 %54, ptr %score, align 4
  br label %if.end229

if.end229:                                        ; preds = %if.then228, %sc.end216
  %mirror231 = load ptr, ptr %mirror, align 8
  call void @__polaron_free(ptr %mirror231)
  %cells232 = load ptr, ptr %cells, align 8
  call void @__polaron_free(ptr %cells232)
  %score233 = load i32, ptr %score, align 4
  %55 = call i32 (ptr, ...) @printf(ptr @.str, i32 %score233)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5375)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5377)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @memcpy(ptr, ptr, i64)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{}
!5 = !{i64 8}
!6 = !{!"branch_weights", i32 1, i32 1048576}
!7 = !{!8, !8, i64 0}
!8 = !{!"f32", !2, i64 0}
