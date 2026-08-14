; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/levenshtein.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/levenshtein.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [33 x i8] c"kit=%d empty=%d same=%d flaw=%d\0A\00", align 1
@.strdata = private constant [7 x i8] c"kitten\00"
@.strobj = private global %String { i64 6, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [8 x i8] c"sitting\00"
@.strobj.2 = private global %String { i64 7, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [1 x i8] zeroinitializer
@.strobj.4 = private global %String { i64 0, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [4 x i8] c"abc\00"
@.strobj.6 = private global %String { i64 3, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [4 x i8] c"abc\00"
@.strobj.8 = private global %String { i64 3, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [4 x i8] c"abc\00"
@.strobj.10 = private global %String { i64 3, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [5 x i8] c"flaw\00"
@.strobj.12 = private global %String { i64 4, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [5 x i8] c"lawn\00"
@.strobj.14 = private global %String { i64 4, ptr @.strdata.13, i64 0 }
@.fail.2584 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4167:64  in Levenshtein.distance\0A\00", align 1
@.faila.2585 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2586 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2587 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4169:28  in Levenshtein.distance\0A\00", align 1
@.faila.2588 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2589 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2590 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4173:25  in Levenshtein.distance\0A\00", align 1
@.faila.2591 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2592 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2593 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4174:25  in Levenshtein.distance\0A\00", align 1
@.faila.2594 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2595 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2596 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4175:25  in Levenshtein.distance\0A\00", align 1
@.faila.2597 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2598 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2599 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4178:32  in Levenshtein.distance\0A\00", align 1
@.faila.2600 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2601 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2602 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4180:68  in Levenshtein.distance\0A\00", align 1
@.faila.2603 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2604 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2605 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4180:68  in Levenshtein.distance\0A\00", align 1
@.faila.2606 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2607 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2608 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4182:17  in Levenshtein.distance\0A\00", align 1
@.faila.2609 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2610 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }

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
  call void @Test.__onClassLoad()
  %16 = call i32 @Levenshtein.distance(ptr @.strobj, ptr @.strobj.2)
  %17 = call i32 @Levenshtein.distance(ptr @.strobj.4, ptr @.strobj.6)
  %18 = call i32 @Levenshtein.distance(ptr @.strobj.8, ptr @.strobj.10)
  %19 = call i32 @Levenshtein.distance(ptr @.strobj.12, ptr @.strobj.14)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19)
  ret i32 0
}

define internal i32 @Levenshtein.distance(ptr %0, ptr %1) {
entry:
  %j98 = alloca i32, align 4
  %sub = alloca i32, align 4
  %ins = alloca i32, align 4
  %mn = alloca i32, align 4
  %cost = alloca i32, align 4
  %j35 = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %cur = alloca ptr, align 8
  %prev = alloca ptr, align 8
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %str.len = getelementptr inbounds %String, ptr %a1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %b2 = load ptr, ptr %b, align 8
  %str.len3 = getelementptr inbounds %String, ptr %b2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %m, align 4
  %n5 = load i32, ptr %n, align 4
  %4 = icmp eq i32 %n5, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %m6 = load i32, ptr %m, align 4
  ret i32 %m6

if.end:                                           ; preds = %entry
  %m7 = load i32, ptr %m, align 4
  %6 = icmp eq i32 %m7, 0
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end
  %n10 = load i32, ptr %n, align 4
  ret i32 %n10

if.end9:                                          ; preds = %if.end
  %m11 = load i32, ptr %m, align 4
  %8 = add i32 %m11, 1
  %9 = sext i32 %8 to i64
  %10 = mul i64 %9, 4
  %11 = add i64 8, %10
  %arr = call ptr @__polaron_malloc(i64 %11)
  store i64 %9, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %12 = call ptr @memset(ptr %arr.data, i32 0, i64 %10)
  store ptr %arr, ptr %prev, align 8
  %m12 = load i32, ptr %m, align 4
  %13 = add i32 %m12, 1
  %14 = sext i32 %13 to i64
  %15 = mul i64 %14, 4
  %16 = add i64 8, %15
  %arr13 = call ptr @__polaron_malloc(i64 %16)
  store i64 %14, ptr %arr13, align 8
  %arr.data14 = getelementptr i8, ptr %arr13, i64 8
  %17 = call ptr @memset(ptr %arr.data14, i32 0, i64 %15)
  store ptr %arr13, ptr %cur, align 8
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end9
  %j15 = load i32, ptr %j, align 4
  %m16 = load i32, ptr %m, align 4
  %18 = icmp sle i32 %j15, %m16
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %prev17 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j18 = load i32, ptr %j, align 4
  %20 = sext i32 %j18 to i64
  %arr.len = load i64, ptr %prev17, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %21 = load i32, ptr %j, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %i, align 4
  br label %for.cond21

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2584, ptr @.faila.2585, i64 %20, ptr @.failb.2586, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data19 = getelementptr i8, ptr %prev17, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data19, i64 %20
  %j20 = load i32, ptr %j, align 4
  store i32 %j20, ptr %arr.elem, align 4
  br label %for.update

for.cond21:                                       ; preds = %for.update23, %for.end
  %i25 = load i32, ptr %i, align 4
  %n26 = load i32, ptr %n, align 4
  %23 = icmp sle i32 %i25, %n26
  %24 = zext i1 %23 to i32
  br i1 %23, label %for.body22, label %for.end24

for.body22:                                       ; preds = %for.cond21
  %cur27 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %arr.len28 = load i64, ptr %cur27, align 8
  %arr.oob29 = icmp uge i64 0, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

for.update23:                                     ; preds = %for.end102
  %25 = load i32, ptr %i, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %i, align 4
  br label %for.cond21

for.end24:                                        ; preds = %for.cond21
  %prev122 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %m123 = load i32, ptr %m, align 4
  %27 = sext i32 %m123 to i64
  %arr.len124 = load i64, ptr %prev122, align 8
  %arr.oob125 = icmp uge i64 %27, %arr.len124
  br i1 %arr.oob125, label %idx.bad126, label %idx.ok127, !prof !2

idx.bad30:                                        ; preds = %for.body22
  call void @__polaron_fail(ptr @.fail.2587, ptr @.faila.2588, i64 0, ptr @.failb.2589, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %for.body22
  %arr.data32 = getelementptr i8, ptr %cur27, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 0
  %i34 = load i32, ptr %i, align 4
  store i32 %i34, ptr %arr.elem33, align 4
  store i32 1, ptr %j35, align 4
  br label %for.cond36

for.cond36:                                       ; preds = %for.update38, %idx.ok31
  %j40 = load i32, ptr %j35, align 4
  %m41 = load i32, ptr %m, align 4
  %28 = icmp sle i32 %j40, %m41
  %29 = zext i1 %28 to i32
  br i1 %28, label %for.body37, label %for.end39

for.body37:                                       ; preds = %for.cond36
  store i32 1, ptr %cost, align 4
  %a42 = load ptr, ptr %a, align 8
  %i43 = load i32, ptr %i, align 4
  %30 = sub i32 %i43, 1
  %31 = sext i32 %30 to i64
  %str.data = getelementptr inbounds %String, ptr %a42, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %31
  %ch = load i8, ptr %ch.addr, align 1
  %32 = zext i8 %ch to i32
  %b44 = load ptr, ptr %b, align 8
  %j45 = load i32, ptr %j35, align 4
  %33 = sub i32 %j45, 1
  %34 = sext i32 %33 to i64
  %str.data46 = getelementptr inbounds %String, ptr %b44, i32 0, i32 1
  %data47 = load ptr, ptr %str.data46, align 8
  %ch.addr48 = getelementptr i8, ptr %data47, i64 %34
  %ch49 = load i8, ptr %ch.addr48, align 1
  %35 = zext i8 %ch49 to i32
  %36 = icmp eq i32 %32, %35
  %37 = zext i1 %36 to i32
  br i1 %36, label %if.then50, label %if.end51

for.update38:                                     ; preds = %idx.ok94
  %38 = load i32, ptr %j35, align 4
  %39 = add i32 %38, 1
  store i32 %39, ptr %j35, align 4
  br label %for.cond36

for.end39:                                        ; preds = %for.cond36
  store i32 0, ptr %j98, align 4
  br label %for.cond99

if.then50:                                        ; preds = %for.body37
  store i32 0, ptr %cost, align 4
  br label %if.end51

if.end51:                                         ; preds = %if.then50, %for.body37
  %prev52 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j53 = load i32, ptr %j35, align 4
  %40 = sext i32 %j53 to i64
  %arr.len54 = load i64, ptr %prev52, align 8
  %arr.oob55 = icmp uge i64 %40, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !2

idx.bad56:                                        ; preds = %if.end51
  call void @__polaron_fail(ptr @.fail.2590, ptr @.faila.2591, i64 %40, ptr @.failb.2592, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %if.end51
  %arr.data58 = getelementptr i8, ptr %prev52, i64 8
  %arr.elem59 = getelementptr inbounds i32, ptr %arr.data58, i64 %40
  %elem = load i32, ptr %arr.elem59, align 4
  %41 = add i32 %elem, 1
  store i32 %41, ptr %mn, align 4
  %cur60 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j61 = load i32, ptr %j35, align 4
  %42 = sub i32 %j61, 1
  %43 = sext i32 %42 to i64
  %arr.len62 = load i64, ptr %cur60, align 8
  %arr.oob63 = icmp uge i64 %43, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !2

idx.bad64:                                        ; preds = %idx.ok57
  call void @__polaron_fail(ptr @.fail.2593, ptr @.faila.2594, i64 %43, ptr @.failb.2595, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %idx.ok57
  %arr.data66 = getelementptr i8, ptr %cur60, i64 8
  %arr.elem67 = getelementptr inbounds i32, ptr %arr.data66, i64 %43
  %elem68 = load i32, ptr %arr.elem67, align 4
  %44 = add i32 %elem68, 1
  store i32 %44, ptr %ins, align 4
  %prev69 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j70 = load i32, ptr %j35, align 4
  %45 = sub i32 %j70, 1
  %46 = sext i32 %45 to i64
  %arr.len71 = load i64, ptr %prev69, align 8
  %arr.oob72 = icmp uge i64 %46, %arr.len71
  br i1 %arr.oob72, label %idx.bad73, label %idx.ok74, !prof !2

idx.bad73:                                        ; preds = %idx.ok65
  call void @__polaron_fail(ptr @.fail.2596, ptr @.faila.2597, i64 %46, ptr @.failb.2598, i64 %arr.len71, i32 70)
  unreachable

idx.ok74:                                         ; preds = %idx.ok65
  %arr.data75 = getelementptr i8, ptr %prev69, i64 8
  %arr.elem76 = getelementptr inbounds i32, ptr %arr.data75, i64 %46
  %elem77 = load i32, ptr %arr.elem76, align 4
  %cost78 = load i32, ptr %cost, align 4
  %47 = add i32 %elem77, %cost78
  store i32 %47, ptr %sub, align 4
  %ins79 = load i32, ptr %ins, align 4
  %mn80 = load i32, ptr %mn, align 4
  %48 = icmp slt i32 %ins79, %mn80
  %49 = zext i1 %48 to i32
  br i1 %48, label %if.then81, label %if.end82

if.then81:                                        ; preds = %idx.ok74
  %ins83 = load i32, ptr %ins, align 4
  store i32 %ins83, ptr %mn, align 4
  br label %if.end82

if.end82:                                         ; preds = %if.then81, %idx.ok74
  %sub84 = load i32, ptr %sub, align 4
  %mn85 = load i32, ptr %mn, align 4
  %50 = icmp slt i32 %sub84, %mn85
  %51 = zext i1 %50 to i32
  br i1 %50, label %if.then86, label %if.end87

if.then86:                                        ; preds = %if.end82
  %sub88 = load i32, ptr %sub, align 4
  store i32 %sub88, ptr %mn, align 4
  br label %if.end87

if.end87:                                         ; preds = %if.then86, %if.end82
  %cur89 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j90 = load i32, ptr %j35, align 4
  %52 = sext i32 %j90 to i64
  %arr.len91 = load i64, ptr %cur89, align 8
  %arr.oob92 = icmp uge i64 %52, %arr.len91
  br i1 %arr.oob92, label %idx.bad93, label %idx.ok94, !prof !2

idx.bad93:                                        ; preds = %if.end87
  call void @__polaron_fail(ptr @.fail.2599, ptr @.faila.2600, i64 %52, ptr @.failb.2601, i64 %arr.len91, i32 70)
  unreachable

idx.ok94:                                         ; preds = %if.end87
  %arr.data95 = getelementptr i8, ptr %cur89, i64 8
  %arr.elem96 = getelementptr inbounds i32, ptr %arr.data95, i64 %52
  %mn97 = load i32, ptr %mn, align 4
  store i32 %mn97, ptr %arr.elem96, align 4
  br label %for.update38

for.cond99:                                       ; preds = %for.update101, %for.end39
  %j103 = load i32, ptr %j98, align 4
  %m104 = load i32, ptr %m, align 4
  %53 = icmp sle i32 %j103, %m104
  %54 = zext i1 %53 to i32
  br i1 %53, label %for.body100, label %for.end102

for.body100:                                      ; preds = %for.cond99
  %prev105 = load ptr, ptr %prev, align 8, !nonnull !0, !dereferenceable !1
  %j106 = load i32, ptr %j98, align 4
  %55 = sext i32 %j106 to i64
  %arr.len107 = load i64, ptr %prev105, align 8
  %arr.oob108 = icmp uge i64 %55, %arr.len107
  br i1 %arr.oob108, label %idx.bad109, label %idx.ok110, !prof !2

for.update101:                                    ; preds = %idx.ok118
  %56 = load i32, ptr %j98, align 4
  %57 = add i32 %56, 1
  store i32 %57, ptr %j98, align 4
  br label %for.cond99

for.end102:                                       ; preds = %for.cond99
  br label %for.update23

idx.bad109:                                       ; preds = %for.body100
  call void @__polaron_fail(ptr @.fail.2602, ptr @.faila.2603, i64 %55, ptr @.failb.2604, i64 %arr.len107, i32 70)
  unreachable

idx.ok110:                                        ; preds = %for.body100
  %arr.data111 = getelementptr i8, ptr %prev105, i64 8
  %arr.elem112 = getelementptr inbounds i32, ptr %arr.data111, i64 %55
  %cur113 = load ptr, ptr %cur, align 8, !nonnull !0, !dereferenceable !1
  %j114 = load i32, ptr %j98, align 4
  %58 = sext i32 %j114 to i64
  %arr.len115 = load i64, ptr %cur113, align 8
  %arr.oob116 = icmp uge i64 %58, %arr.len115
  br i1 %arr.oob116, label %idx.bad117, label %idx.ok118, !prof !2

idx.bad117:                                       ; preds = %idx.ok110
  call void @__polaron_fail(ptr @.fail.2605, ptr @.faila.2606, i64 %58, ptr @.failb.2607, i64 %arr.len115, i32 70)
  unreachable

idx.ok118:                                        ; preds = %idx.ok110
  %arr.data119 = getelementptr i8, ptr %cur113, i64 8
  %arr.elem120 = getelementptr inbounds i32, ptr %arr.data119, i64 %58
  %elem121 = load i32, ptr %arr.elem120, align 4
  store i32 %elem121, ptr %arr.elem112, align 4
  br label %for.update101

idx.bad126:                                       ; preds = %for.end24
  call void @__polaron_fail(ptr @.fail.2608, ptr @.faila.2609, i64 %27, ptr @.failb.2610, i64 %arr.len124, i32 70)
  unreachable

idx.ok127:                                        ; preds = %for.end24
  %arr.data128 = getelementptr i8, ptr %prev122, i64 8
  %arr.elem129 = getelementptr inbounds i32, ptr %arr.data128, i64 %27
  %elem130 = load i32, ptr %arr.elem129, align 4
  ret i32 %elem130
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

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
