; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regex_match.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/regex_match.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [69 x i8] c"star=%d full=%d nofull=%d dot=%d digits=%d lower=%d mixed=%d opt=%d\0A\00", align 1
@.strdata = private constant [4 x i8] c"a*b\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [5 x i8] c"aaab\00"
@.strobj.2 = private global %String { i64 4, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [6 x i8] c"^abc$\00"
@.strobj.4 = private global %String { i64 5, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [4 x i8] c"abc\00"
@.strobj.6 = private global %String { i64 3, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [6 x i8] c"^abc$\00"
@.strobj.8 = private global %String { i64 5, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [5 x i8] c"abcd\00"
@.strobj.10 = private global %String { i64 4, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [4 x i8] c"a.c\00"
@.strobj.12 = private global %String { i64 3, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [4 x i8] c"axc\00"
@.strobj.14 = private global %String { i64 3, ptr @.strdata.13, i64 0 }
@.strdata.15 = private constant [7 x i8] c"[0-9]+\00"
@.strobj.16 = private global %String { i64 6, ptr @.strdata.15, i64 0 }
@.strdata.17 = private constant [7 x i8] c"xx42yy\00"
@.strobj.18 = private global %String { i64 6, ptr @.strdata.17, i64 0 }
@.strdata.19 = private constant [9 x i8] c"^[a-z]+$\00"
@.strobj.20 = private global %String { i64 8, ptr @.strdata.19, i64 0 }
@.strdata.21 = private constant [6 x i8] c"hello\00"
@.strobj.22 = private global %String { i64 5, ptr @.strdata.21, i64 0 }
@.strdata.23 = private constant [9 x i8] c"^[a-z]+$\00"
@.strobj.24 = private global %String { i64 8, ptr @.strdata.23, i64 0 }
@.strdata.25 = private constant [6 x i8] c"Hello\00"
@.strobj.26 = private global %String { i64 5, ptr @.strdata.25, i64 0 }
@.strdata.27 = private constant [8 x i8] c"colou?r\00"
@.strobj.28 = private global %String { i64 7, ptr @.strdata.27, i64 0 }
@.strdata.29 = private constant [6 x i8] c"color\00"
@.strobj.30 = private global %String { i64 5, ptr @.strdata.29, i64 0 }
@.strdata.5337 = private constant [1 x i8] zeroinitializer
@.strobj.5338 = private global %String { i64 0, ptr @.strdata.5337, i64 0 }
@.strdata.5339 = private constant [1 x i8] zeroinitializer
@.strobj.5340 = private global %String { i64 0, ptr @.strdata.5339, i64 0 }

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
  %16 = call i32 @Regex.search(ptr @.strobj, ptr @.strobj.2)
  %17 = call i32 @Regex.search(ptr @.strobj.4, ptr @.strobj.6)
  %18 = call i32 @Regex.search(ptr @.strobj.8, ptr @.strobj.10)
  %19 = call i32 @Regex.search(ptr @.strobj.12, ptr @.strobj.14)
  %20 = call i32 @Regex.search(ptr @.strobj.16, ptr @.strobj.18)
  %21 = call i32 @Regex.search(ptr @.strobj.20, ptr @.strobj.22)
  %22 = call i32 @Regex.search(ptr @.strobj.24, ptr @.strobj.26)
  %23 = call i32 @Regex.search(ptr @.strobj.28, ptr @.strobj.30)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22, i32 %23)
  ret i32 0
}

define internal i32 @Regex.atomEnd(ptr %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %pi = alloca i32, align 4
  %pat = alloca ptr, align 8
  store ptr %0, ptr %pat, align 8
  store i32 %1, ptr %pi, align 4
  %pat1 = load ptr, ptr %pat, align 8
  %pi2 = load i32, ptr %pi, align 4
  %2 = sext i32 %pi2 to i64
  %str.data = getelementptr inbounds %String, ptr %pat1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %2
  %ch = load i8, ptr %ch.addr, align 1
  %3 = zext i8 %ch to i32
  %4 = icmp eq i32 %3, 91
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %pi3 = load i32, ptr %pi, align 4
  %6 = add i32 %pi3, 1
  store i32 %6, ptr %j, align 4
  %j4 = load i32, ptr %j, align 4
  %pat5 = load ptr, ptr %pat, align 8
  %str.len = getelementptr inbounds %String, ptr %pat5, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %7 = trunc i64 %len to i32
  %8 = icmp slt i32 %j4, %7
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

if.end:                                           ; preds = %entry
  %pi50 = load i32, ptr %pi, align 4
  %10 = add i32 %pi50, 1
  ret i32 %10

sc.rhs:                                           ; preds = %if.then
  %pat6 = load ptr, ptr %pat, align 8
  %j7 = load i32, ptr %j, align 4
  %11 = sext i32 %j7 to i64
  %str.data8 = getelementptr inbounds %String, ptr %pat6, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %ch.addr10 = getelementptr i8, ptr %data9, i64 %11
  %ch11 = load i8, ptr %ch.addr10, align 1
  %12 = zext i8 %ch11 to i32
  %13 = icmp eq i32 %12, 94
  %14 = zext i1 %13 to i32
  %sc.b = icmp ne i32 %14, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %if.then
  %sc = phi i1 [ false, %if.then ], [ %sc.b, %sc.rhs ]
  %15 = zext i1 %sc to i32
  br i1 %sc, label %if.then12, label %if.end13

if.then12:                                        ; preds = %sc.end
  %j14 = load i32, ptr %j, align 4
  %16 = add i32 %j14, 1
  store i32 %16, ptr %j, align 4
  br label %if.end13

if.end13:                                         ; preds = %if.then12, %sc.end
  %j15 = load i32, ptr %j, align 4
  %pat16 = load ptr, ptr %pat, align 8
  %str.len17 = getelementptr inbounds %String, ptr %pat16, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  %17 = trunc i64 %len18 to i32
  %18 = icmp slt i32 %j15, %17
  %19 = zext i1 %18 to i32
  %sc.a19 = icmp ne i32 %19, 0
  br i1 %sc.a19, label %sc.rhs20, label %sc.end21

sc.rhs20:                                         ; preds = %if.end13
  %pat22 = load ptr, ptr %pat, align 8
  %j23 = load i32, ptr %j, align 4
  %20 = sext i32 %j23 to i64
  %str.data24 = getelementptr inbounds %String, ptr %pat22, i32 0, i32 1
  %data25 = load ptr, ptr %str.data24, align 8
  %ch.addr26 = getelementptr i8, ptr %data25, i64 %20
  %ch27 = load i8, ptr %ch.addr26, align 1
  %21 = zext i8 %ch27 to i32
  %22 = icmp eq i32 %21, 93
  %23 = zext i1 %22 to i32
  %sc.b28 = icmp ne i32 %23, 0
  br label %sc.end21

sc.end21:                                         ; preds = %sc.rhs20, %if.end13
  %sc29 = phi i1 [ false, %if.end13 ], [ %sc.b28, %sc.rhs20 ]
  %24 = zext i1 %sc29 to i32
  br i1 %sc29, label %if.then30, label %if.end31

if.then30:                                        ; preds = %sc.end21
  %j32 = load i32, ptr %j, align 4
  %25 = add i32 %j32, 1
  store i32 %25, ptr %j, align 4
  br label %if.end31

if.end31:                                         ; preds = %if.then30, %sc.end21
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end31
  %j33 = load i32, ptr %j, align 4
  %pat34 = load ptr, ptr %pat, align 8
  %str.len35 = getelementptr inbounds %String, ptr %pat34, i32 0, i32 0
  %len36 = load i64, ptr %str.len35, align 8
  %26 = trunc i64 %len36 to i32
  %27 = icmp slt i32 %j33, %26
  %28 = zext i1 %27 to i32
  %sc.a37 = icmp ne i32 %28, 0
  br i1 %sc.a37, label %sc.rhs38, label %sc.end39

while.body:                                       ; preds = %sc.end39
  %j48 = load i32, ptr %j, align 4
  %29 = add i32 %j48, 1
  store i32 %29, ptr %j, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end39
  %j49 = load i32, ptr %j, align 4
  %30 = add i32 %j49, 1
  ret i32 %30

sc.rhs38:                                         ; preds = %while.cond
  %pat40 = load ptr, ptr %pat, align 8
  %j41 = load i32, ptr %j, align 4
  %31 = sext i32 %j41 to i64
  %str.data42 = getelementptr inbounds %String, ptr %pat40, i32 0, i32 1
  %data43 = load ptr, ptr %str.data42, align 8
  %ch.addr44 = getelementptr i8, ptr %data43, i64 %31
  %ch45 = load i8, ptr %ch.addr44, align 1
  %32 = zext i8 %ch45 to i32
  %33 = icmp ne i32 %32, 93
  %34 = zext i1 %33 to i32
  %sc.b46 = icmp ne i32 %34, 0
  br label %sc.end39

sc.end39:                                         ; preds = %sc.rhs38, %while.cond
  %sc47 = phi i1 [ false, %while.cond ], [ %sc.b46, %sc.rhs38 ]
  %35 = zext i1 %sc47 to i32
  br i1 %sc47, label %while.body, label %while.end
}

define internal i32 @Regex.matchClass(ptr %0, i32 %1, i32 %2, i32 %3) {
entry:
  %found = alloca i32, align 4
  %negate = alloca i32, align 4
  %i = alloca i32, align 4
  %ch = alloca i32, align 4
  %end = alloca i32, align 4
  %start = alloca i32, align 4
  %pat = alloca ptr, align 8
  store ptr %0, ptr %pat, align 8
  store i32 %1, ptr %start, align 4
  store i32 %2, ptr %end, align 4
  store i32 %3, ptr %ch, align 4
  %start1 = load i32, ptr %start, align 4
  store i32 %start1, ptr %i, align 4
  store i32 0, ptr %negate, align 4
  %i2 = load i32, ptr %i, align 4
  %end3 = load i32, ptr %end, align 4
  %4 = icmp slt i32 %i2, %end3
  %5 = zext i1 %4 to i32
  %sc.a = icmp ne i32 %5, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %pat4 = load ptr, ptr %pat, align 8
  %i5 = load i32, ptr %i, align 4
  %6 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %pat4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %6
  %ch6 = load i8, ptr %ch.addr, align 1
  %7 = zext i8 %ch6 to i32
  %8 = icmp eq i32 %7, 94
  %9 = zext i1 %8 to i32
  %sc.b = icmp ne i32 %9, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %10 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  store i32 1, ptr %negate, align 4
  %i7 = load i32, ptr %i, align 4
  %11 = add i32 %i7, 1
  store i32 %11, ptr %i, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  store i32 0, ptr %found, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end24, %if.end
  %i8 = load i32, ptr %i, align 4
  %end9 = load i32, ptr %end, align 4
  %12 = icmp slt i32 %i8, %end9
  %13 = zext i1 %12 to i32
  br i1 %12, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i10 = load i32, ptr %i, align 4
  %14 = add i32 %i10, 2
  %end11 = load i32, ptr %end, align 4
  %15 = icmp slt i32 %14, %end11
  %16 = zext i1 %15 to i32
  %sc.a12 = icmp ne i32 %16, 0
  br i1 %sc.a12, label %sc.rhs13, label %sc.end14

while.end:                                        ; preds = %while.cond
  %negate57 = load i32, ptr %negate, align 4
  %17 = icmp ne i32 %negate57, 0
  br i1 %17, label %if.then58, label %if.end59

sc.rhs13:                                         ; preds = %while.body
  %pat15 = load ptr, ptr %pat, align 8
  %i16 = load i32, ptr %i, align 4
  %18 = add i32 %i16, 1
  %19 = sext i32 %18 to i64
  %str.data17 = getelementptr inbounds %String, ptr %pat15, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %ch.addr19 = getelementptr i8, ptr %data18, i64 %19
  %ch20 = load i8, ptr %ch.addr19, align 1
  %20 = zext i8 %ch20 to i32
  %21 = icmp eq i32 %20, 45
  %22 = zext i1 %21 to i32
  %sc.b21 = icmp ne i32 %22, 0
  br label %sc.end14

sc.end14:                                         ; preds = %sc.rhs13, %while.body
  %sc22 = phi i1 [ false, %while.body ], [ %sc.b21, %sc.rhs13 ]
  %23 = zext i1 %sc22 to i32
  br i1 %sc22, label %if.then23, label %if.else

if.then23:                                        ; preds = %sc.end14
  %ch25 = load i32, ptr %ch, align 4
  %pat26 = load ptr, ptr %pat, align 8
  %i27 = load i32, ptr %i, align 4
  %24 = sext i32 %i27 to i64
  %str.data28 = getelementptr inbounds %String, ptr %pat26, i32 0, i32 1
  %data29 = load ptr, ptr %str.data28, align 8
  %ch.addr30 = getelementptr i8, ptr %data29, i64 %24
  %ch31 = load i8, ptr %ch.addr30, align 1
  %25 = zext i8 %ch31 to i32
  %26 = icmp sge i32 %ch25, %25
  %27 = zext i1 %26 to i32
  %sc.a32 = icmp ne i32 %27, 0
  br i1 %sc.a32, label %sc.rhs33, label %sc.end34

if.else:                                          ; preds = %sc.end14
  %pat47 = load ptr, ptr %pat, align 8
  %i48 = load i32, ptr %i, align 4
  %28 = sext i32 %i48 to i64
  %str.data49 = getelementptr inbounds %String, ptr %pat47, i32 0, i32 1
  %data50 = load ptr, ptr %str.data49, align 8
  %ch.addr51 = getelementptr i8, ptr %data50, i64 %28
  %ch52 = load i8, ptr %ch.addr51, align 1
  %29 = zext i8 %ch52 to i32
  %ch53 = load i32, ptr %ch, align 4
  %30 = icmp eq i32 %29, %ch53
  %31 = zext i1 %30 to i32
  br i1 %30, label %if.then54, label %if.end55

if.end24:                                         ; preds = %if.end55, %if.end45
  br label %while.cond

sc.rhs33:                                         ; preds = %if.then23
  %ch35 = load i32, ptr %ch, align 4
  %pat36 = load ptr, ptr %pat, align 8
  %i37 = load i32, ptr %i, align 4
  %32 = add i32 %i37, 2
  %33 = sext i32 %32 to i64
  %str.data38 = getelementptr inbounds %String, ptr %pat36, i32 0, i32 1
  %data39 = load ptr, ptr %str.data38, align 8
  %ch.addr40 = getelementptr i8, ptr %data39, i64 %33
  %ch41 = load i8, ptr %ch.addr40, align 1
  %34 = zext i8 %ch41 to i32
  %35 = icmp sle i32 %ch35, %34
  %36 = zext i1 %35 to i32
  %sc.b42 = icmp ne i32 %36, 0
  br label %sc.end34

sc.end34:                                         ; preds = %sc.rhs33, %if.then23
  %sc43 = phi i1 [ false, %if.then23 ], [ %sc.b42, %sc.rhs33 ]
  %37 = zext i1 %sc43 to i32
  br i1 %sc43, label %if.then44, label %if.end45

if.then44:                                        ; preds = %sc.end34
  store i32 1, ptr %found, align 4
  br label %if.end45

if.end45:                                         ; preds = %if.then44, %sc.end34
  %i46 = load i32, ptr %i, align 4
  %38 = add i32 %i46, 3
  store i32 %38, ptr %i, align 4
  br label %if.end24

if.then54:                                        ; preds = %if.else
  store i32 1, ptr %found, align 4
  br label %if.end55

if.end55:                                         ; preds = %if.then54, %if.else
  %i56 = load i32, ptr %i, align 4
  %39 = add i32 %i56, 1
  store i32 %39, ptr %i, align 4
  br label %if.end24

if.then58:                                        ; preds = %while.end
  %found60 = load i32, ptr %found, align 4
  %40 = icmp eq i32 %found60, 0
  %41 = zext i1 %40 to i32
  ret i32 %41

if.end59:                                         ; preds = %while.end
  %found61 = load i32, ptr %found, align 4
  ret i32 %found61
}

define internal i32 @Regex.matchAtom(ptr %0, i32 %1, i32 %2, i32 %3) {
entry:
  %p = alloca i32, align 4
  %ch = alloca i32, align 4
  %atomEnd = alloca i32, align 4
  %pi = alloca i32, align 4
  %pat = alloca ptr, align 8
  store ptr %0, ptr %pat, align 8
  store i32 %1, ptr %pi, align 4
  store i32 %2, ptr %atomEnd, align 4
  store i32 %3, ptr %ch, align 4
  %pat1 = load ptr, ptr %pat, align 8
  %pi2 = load i32, ptr %pi, align 4
  %4 = sext i32 %pi2 to i64
  %str.data = getelementptr inbounds %String, ptr %pat1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch3 = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch3 to i32
  store i32 %5, ptr %p, align 4
  %p4 = load i32, ptr %p, align 4
  %6 = icmp eq i32 %p4, 46
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 1

if.end:                                           ; preds = %entry
  %p5 = load i32, ptr %p, align 4
  %8 = icmp eq i32 %p5, 91
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end
  %pat8 = load ptr, ptr %pat, align 8
  %pi9 = load i32, ptr %pi, align 4
  %10 = add i32 %pi9, 1
  %atomEnd10 = load i32, ptr %atomEnd, align 4
  %11 = sub i32 %atomEnd10, 1
  %ch11 = load i32, ptr %ch, align 4
  %12 = call i32 @Regex.matchClass(ptr %pat8, i32 %10, i32 %11, i32 %ch11)
  ret i32 %12

if.end7:                                          ; preds = %if.end
  %p12 = load i32, ptr %p, align 4
  %ch13 = load i32, ptr %ch, align 4
  %13 = icmp eq i32 %p12, %ch13
  %14 = zext i1 %13 to i32
  ret i32 %14
}

define internal i32 @Regex.matchStar(i32 %0, ptr %1, i32 %2, i32 %3, ptr %4, i32 %5) {
entry:
  %k = alloca i32, align 4
  %count = alloca i32, align 4
  %ti = alloca i32, align 4
  %text = alloca ptr, align 8
  %atomEnd = alloca i32, align 4
  %pi = alloca i32, align 4
  %pat = alloca ptr, align 8
  %min = alloca i32, align 4
  store i32 %0, ptr %min, align 4
  store ptr %1, ptr %pat, align 8
  store i32 %2, ptr %pi, align 4
  store i32 %3, ptr %atomEnd, align 4
  store ptr %4, ptr %text, align 8
  store i32 %5, ptr %ti, align 4
  store i32 0, ptr %count, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %ti1 = load i32, ptr %ti, align 4
  %count2 = load i32, ptr %count, align 4
  %6 = add i32 %ti1, %count2
  %text3 = load ptr, ptr %text, align 8
  %str.len = getelementptr inbounds %String, ptr %text3, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %7 = trunc i64 %len to i32
  %8 = icmp slt i32 %6, %7
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %count10 = load i32, ptr %count, align 4
  %10 = add i32 %count10, 1
  store i32 %10, ptr %count, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %count11 = load i32, ptr %count, align 4
  store i32 %count11, ptr %k, align 4
  br label %while.cond12

sc.rhs:                                           ; preds = %while.cond
  %pat4 = load ptr, ptr %pat, align 8
  %pi5 = load i32, ptr %pi, align 4
  %atomEnd6 = load i32, ptr %atomEnd, align 4
  %text7 = load ptr, ptr %text, align 8
  %ti8 = load i32, ptr %ti, align 4
  %count9 = load i32, ptr %count, align 4
  %11 = add i32 %ti8, %count9
  %12 = sext i32 %11 to i64
  %str.data = getelementptr inbounds %String, ptr %text7, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %12
  %ch = load i8, ptr %ch.addr, align 1
  %13 = zext i8 %ch to i32
  %14 = call i32 @Regex.matchAtom(ptr %pat4, i32 %pi5, i32 %atomEnd6, i32 %13)
  %sc.b = icmp ne i32 %14, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %15 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

while.cond12:                                     ; preds = %if.end, %while.end
  %k15 = load i32, ptr %k, align 4
  %min16 = load i32, ptr %min, align 4
  %16 = icmp sge i32 %k15, %min16
  %17 = zext i1 %16 to i32
  br i1 %16, label %while.body13, label %while.end14

while.body13:                                     ; preds = %while.cond12
  %pat17 = load ptr, ptr %pat, align 8
  %atomEnd18 = load i32, ptr %atomEnd, align 4
  %18 = add i32 %atomEnd18, 1
  %text19 = load ptr, ptr %text, align 8
  %ti20 = load i32, ptr %ti, align 4
  %k21 = load i32, ptr %k, align 4
  %19 = add i32 %ti20, %k21
  %20 = call i32 @Regex.matchHere(ptr %pat17, i32 %18, ptr %text19, i32 %19)
  %21 = icmp ne i32 %20, 0
  br i1 %21, label %if.then, label %if.end

while.end14:                                      ; preds = %while.cond12
  ret i32 0

if.then:                                          ; preds = %while.body13
  ret i32 1

if.end:                                           ; preds = %while.body13
  %k22 = load i32, ptr %k, align 4
  %22 = sub i32 %k22, 1
  store i32 %22, ptr %k, align 4
  br label %while.cond12
}

define internal i32 @Regex.matchHere(ptr %0, i32 %1, ptr %2, i32 %3) {
entry:
  %q = alloca i32, align 4
  %quant = alloca i32, align 4
  %ae = alloca i32, align 4
  %ti = alloca i32, align 4
  %text = alloca ptr, align 8
  %pi = alloca i32, align 4
  %pat = alloca ptr, align 8
  store ptr %0, ptr %pat, align 8
  store i32 %1, ptr %pi, align 4
  store ptr %2, ptr %text, align 8
  store i32 %3, ptr %ti, align 4
  %pi1 = load i32, ptr %pi, align 4
  %pat2 = load ptr, ptr %pat, align 8
  %str.len = getelementptr inbounds %String, ptr %pat2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sge i32 %pi1, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 1

if.end:                                           ; preds = %entry
  %pat3 = load ptr, ptr %pat, align 8
  %pi4 = load i32, ptr %pi, align 4
  %7 = sext i32 %pi4 to i64
  %str.data = getelementptr inbounds %String, ptr %pat3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %7
  %ch = load i8, ptr %ch.addr, align 1
  %8 = zext i8 %ch to i32
  %9 = icmp eq i32 %8, 36
  %10 = zext i1 %9 to i32
  %sc.a = icmp ne i32 %10, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %if.end
  %pi5 = load i32, ptr %pi, align 4
  %11 = add i32 %pi5, 1
  %pat6 = load ptr, ptr %pat, align 8
  %str.len7 = getelementptr inbounds %String, ptr %pat6, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %12 = trunc i64 %len8 to i32
  %13 = icmp eq i32 %11, %12
  %14 = zext i1 %13 to i32
  %sc.b = icmp ne i32 %14, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %if.end
  %sc = phi i1 [ false, %if.end ], [ %sc.b, %sc.rhs ]
  %15 = zext i1 %sc to i32
  br i1 %sc, label %if.then9, label %if.end10

if.then9:                                         ; preds = %sc.end
  %ti11 = load i32, ptr %ti, align 4
  %text12 = load ptr, ptr %text, align 8
  %str.len13 = getelementptr inbounds %String, ptr %text12, i32 0, i32 0
  %len14 = load i64, ptr %str.len13, align 8
  %16 = trunc i64 %len14 to i32
  %17 = icmp eq i32 %ti11, %16
  %18 = zext i1 %17 to i32
  ret i32 %18

if.end10:                                         ; preds = %sc.end
  %pat15 = load ptr, ptr %pat, align 8
  %pi16 = load i32, ptr %pi, align 4
  %19 = call i32 @Regex.atomEnd(ptr %pat15, i32 %pi16)
  store i32 %19, ptr %ae, align 4
  store i32 32, ptr %quant, align 4
  %ae17 = load i32, ptr %ae, align 4
  %pat18 = load ptr, ptr %pat, align 8
  %str.len19 = getelementptr inbounds %String, ptr %pat18, i32 0, i32 0
  %len20 = load i64, ptr %str.len19, align 8
  %20 = trunc i64 %len20 to i32
  %21 = icmp slt i32 %ae17, %20
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then21, label %if.end22

if.then21:                                        ; preds = %if.end10
  %pat23 = load ptr, ptr %pat, align 8
  %ae24 = load i32, ptr %ae, align 4
  %23 = sext i32 %ae24 to i64
  %str.data25 = getelementptr inbounds %String, ptr %pat23, i32 0, i32 1
  %data26 = load ptr, ptr %str.data25, align 8
  %ch.addr27 = getelementptr i8, ptr %data26, i64 %23
  %ch28 = load i8, ptr %ch.addr27, align 1
  %24 = zext i8 %ch28 to i32
  store i32 %24, ptr %q, align 4
  %q29 = load i32, ptr %q, align 4
  %25 = icmp eq i32 %q29, 42
  %26 = zext i1 %25 to i32
  %sc.a30 = icmp ne i32 %26, 0
  br i1 %sc.a30, label %sc.end32, label %sc.rhs31

if.end22:                                         ; preds = %if.end43, %if.end10
  %quant45 = load i32, ptr %quant, align 4
  %27 = icmp eq i32 %quant45, 42
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then46, label %if.end47

sc.rhs31:                                         ; preds = %if.then21
  %q33 = load i32, ptr %q, align 4
  %29 = icmp eq i32 %q33, 43
  %30 = zext i1 %29 to i32
  %sc.b34 = icmp ne i32 %30, 0
  br label %sc.end32

sc.end32:                                         ; preds = %sc.rhs31, %if.then21
  %sc35 = phi i1 [ true, %if.then21 ], [ %sc.b34, %sc.rhs31 ]
  %31 = zext i1 %sc35 to i32
  %sc.a36 = icmp ne i32 %31, 0
  br i1 %sc.a36, label %sc.end38, label %sc.rhs37

sc.rhs37:                                         ; preds = %sc.end32
  %q39 = load i32, ptr %q, align 4
  %32 = icmp eq i32 %q39, 63
  %33 = zext i1 %32 to i32
  %sc.b40 = icmp ne i32 %33, 0
  br label %sc.end38

sc.end38:                                         ; preds = %sc.rhs37, %sc.end32
  %sc41 = phi i1 [ true, %sc.end32 ], [ %sc.b40, %sc.rhs37 ]
  %34 = zext i1 %sc41 to i32
  br i1 %sc41, label %if.then42, label %if.end43

if.then42:                                        ; preds = %sc.end38
  %q44 = load i32, ptr %q, align 4
  store i32 %q44, ptr %quant, align 4
  br label %if.end43

if.end43:                                         ; preds = %if.then42, %sc.end38
  br label %if.end22

if.then46:                                        ; preds = %if.end22
  %pat48 = load ptr, ptr %pat, align 8
  %pi49 = load i32, ptr %pi, align 4
  %ae50 = load i32, ptr %ae, align 4
  %text51 = load ptr, ptr %text, align 8
  %ti52 = load i32, ptr %ti, align 4
  %35 = call i32 @Regex.matchStar(i32 0, ptr %pat48, i32 %pi49, i32 %ae50, ptr %text51, i32 %ti52)
  ret i32 %35

if.end47:                                         ; preds = %if.end22
  %quant53 = load i32, ptr %quant, align 4
  %36 = icmp eq i32 %quant53, 43
  %37 = zext i1 %36 to i32
  br i1 %36, label %if.then54, label %if.end55

if.then54:                                        ; preds = %if.end47
  %pat56 = load ptr, ptr %pat, align 8
  %pi57 = load i32, ptr %pi, align 4
  %ae58 = load i32, ptr %ae, align 4
  %text59 = load ptr, ptr %text, align 8
  %ti60 = load i32, ptr %ti, align 4
  %38 = call i32 @Regex.matchStar(i32 1, ptr %pat56, i32 %pi57, i32 %ae58, ptr %text59, i32 %ti60)
  ret i32 %38

if.end55:                                         ; preds = %if.end47
  %quant61 = load i32, ptr %quant, align 4
  %39 = icmp eq i32 %quant61, 63
  %40 = zext i1 %39 to i32
  br i1 %39, label %if.then62, label %if.end63

if.then62:                                        ; preds = %if.end55
  %ti64 = load i32, ptr %ti, align 4
  %text65 = load ptr, ptr %text, align 8
  %str.len66 = getelementptr inbounds %String, ptr %text65, i32 0, i32 0
  %len67 = load i64, ptr %str.len66, align 8
  %41 = trunc i64 %len67 to i32
  %42 = icmp slt i32 %ti64, %41
  %43 = zext i1 %42 to i32
  %sc.a68 = icmp ne i32 %43, 0
  br i1 %sc.a68, label %sc.rhs69, label %sc.end70

if.end63:                                         ; preds = %if.end55
  %ti94 = load i32, ptr %ti, align 4
  %text95 = load ptr, ptr %text, align 8
  %str.len96 = getelementptr inbounds %String, ptr %text95, i32 0, i32 0
  %len97 = load i64, ptr %str.len96, align 8
  %44 = trunc i64 %len97 to i32
  %45 = icmp slt i32 %ti94, %44
  %46 = zext i1 %45 to i32
  %sc.a98 = icmp ne i32 %46, 0
  br i1 %sc.a98, label %sc.rhs99, label %sc.end100

sc.rhs69:                                         ; preds = %if.then62
  %pat71 = load ptr, ptr %pat, align 8
  %pi72 = load i32, ptr %pi, align 4
  %ae73 = load i32, ptr %ae, align 4
  %text74 = load ptr, ptr %text, align 8
  %ti75 = load i32, ptr %ti, align 4
  %47 = sext i32 %ti75 to i64
  %str.data76 = getelementptr inbounds %String, ptr %text74, i32 0, i32 1
  %data77 = load ptr, ptr %str.data76, align 8
  %ch.addr78 = getelementptr i8, ptr %data77, i64 %47
  %ch79 = load i8, ptr %ch.addr78, align 1
  %48 = zext i8 %ch79 to i32
  %49 = call i32 @Regex.matchAtom(ptr %pat71, i32 %pi72, i32 %ae73, i32 %48)
  %sc.b80 = icmp ne i32 %49, 0
  br label %sc.end70

sc.end70:                                         ; preds = %sc.rhs69, %if.then62
  %sc81 = phi i1 [ false, %if.then62 ], [ %sc.b80, %sc.rhs69 ]
  %50 = zext i1 %sc81 to i32
  br i1 %sc81, label %if.then82, label %if.end83

if.then82:                                        ; preds = %sc.end70
  %pat84 = load ptr, ptr %pat, align 8
  %ae85 = load i32, ptr %ae, align 4
  %51 = add i32 %ae85, 1
  %text86 = load ptr, ptr %text, align 8
  %ti87 = load i32, ptr %ti, align 4
  %52 = add i32 %ti87, 1
  %53 = call i32 @Regex.matchHere(ptr %pat84, i32 %51, ptr %text86, i32 %52)
  %54 = icmp ne i32 %53, 0
  br i1 %54, label %if.then88, label %if.end89

if.end83:                                         ; preds = %if.end89, %sc.end70
  %pat90 = load ptr, ptr %pat, align 8
  %ae91 = load i32, ptr %ae, align 4
  %55 = add i32 %ae91, 1
  %text92 = load ptr, ptr %text, align 8
  %ti93 = load i32, ptr %ti, align 4
  %56 = call i32 @Regex.matchHere(ptr %pat90, i32 %55, ptr %text92, i32 %ti93)
  ret i32 %56

if.then88:                                        ; preds = %if.then82
  ret i32 1

if.end89:                                         ; preds = %if.then82
  br label %if.end83

sc.rhs99:                                         ; preds = %if.end63
  %pat101 = load ptr, ptr %pat, align 8
  %pi102 = load i32, ptr %pi, align 4
  %ae103 = load i32, ptr %ae, align 4
  %text104 = load ptr, ptr %text, align 8
  %ti105 = load i32, ptr %ti, align 4
  %57 = sext i32 %ti105 to i64
  %str.data106 = getelementptr inbounds %String, ptr %text104, i32 0, i32 1
  %data107 = load ptr, ptr %str.data106, align 8
  %ch.addr108 = getelementptr i8, ptr %data107, i64 %57
  %ch109 = load i8, ptr %ch.addr108, align 1
  %58 = zext i8 %ch109 to i32
  %59 = call i32 @Regex.matchAtom(ptr %pat101, i32 %pi102, i32 %ae103, i32 %58)
  %sc.b110 = icmp ne i32 %59, 0
  br label %sc.end100

sc.end100:                                        ; preds = %sc.rhs99, %if.end63
  %sc111 = phi i1 [ false, %if.end63 ], [ %sc.b110, %sc.rhs99 ]
  %60 = zext i1 %sc111 to i32
  br i1 %sc111, label %if.then112, label %if.end113

if.then112:                                       ; preds = %sc.end100
  %pat114 = load ptr, ptr %pat, align 8
  %ae115 = load i32, ptr %ae, align 4
  %text116 = load ptr, ptr %text, align 8
  %ti117 = load i32, ptr %ti, align 4
  %61 = add i32 %ti117, 1
  %62 = call i32 @Regex.matchHere(ptr %pat114, i32 %ae115, ptr %text116, i32 %61)
  ret i32 %62

if.end113:                                        ; preds = %sc.end100
  ret i32 0
}

define internal i32 @Regex.search(ptr %0, ptr %1) {
entry:
  %start = alloca i32, align 4
  %text = alloca ptr, align 8
  %pat = alloca ptr, align 8
  store ptr %0, ptr %pat, align 8
  store ptr %1, ptr %text, align 8
  %pat1 = load ptr, ptr %pat, align 8
  %str.len = getelementptr inbounds %String, ptr %pat1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp sgt i32 %2, 0
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %pat2 = load ptr, ptr %pat, align 8
  %str.data = getelementptr inbounds %String, ptr %pat2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 0
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = icmp eq i32 %5, 94
  %7 = zext i1 %6 to i32
  %sc.b = icmp ne i32 %7, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %8 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %pat3 = load ptr, ptr %pat, align 8
  %text4 = load ptr, ptr %text, align 8
  %9 = call i32 @Regex.matchHere(ptr %pat3, i32 1, ptr %text4, i32 0)
  ret i32 %9

if.end:                                           ; preds = %sc.end
  store i32 0, ptr %start, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %start5 = load i32, ptr %start, align 4
  %text6 = load ptr, ptr %text, align 8
  %str.len7 = getelementptr inbounds %String, ptr %text6, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %10 = trunc i64 %len8 to i32
  %11 = icmp sle i32 %start5, %10
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pat9 = load ptr, ptr %pat, align 8
  %text10 = load ptr, ptr %text, align 8
  %start11 = load i32, ptr %start, align 4
  %13 = call i32 @Regex.matchHere(ptr %pat9, i32 0, ptr %text10, i32 %start11)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then12, label %if.end13

for.update:                                       ; preds = %if.end13
  %15 = load i32, ptr %start, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %start, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0

if.then12:                                        ; preds = %for.body
  ret i32 1

if.end13:                                         ; preds = %for.body
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5338)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5340)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
