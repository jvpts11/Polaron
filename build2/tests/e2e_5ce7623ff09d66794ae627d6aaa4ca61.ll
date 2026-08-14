; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_extras.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_extras.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [52 x i8] c"tsLen=%d teLen=%d blank1=%d blank2=%d eq=%d neq=%d\0A\00", align 1
@.strdata = private constant [7 x i8] c"  hi  \00"
@.strobj = private global %String { i64 6, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"  hi  \00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [4 x i8] c"   \00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [4 x i8] c" x \00"
@.strobj.6 = private global %String { i64 3, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [6 x i8] c"Hello\00"
@.strobj.8 = private global %String { i64 5, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [6 x i8] c"HELLO\00"
@.strobj.10 = private global %String { i64 5, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [2 x i8] c"a\00"
@.strobj.12 = private global %String { i64 1, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [2 x i8] c"b\00"
@.strobj.14 = private global %String { i64 1, ptr @.strdata.13, i64 0 }
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
  %16 = call ptr @Strings.trimStart(ptr @.strobj)
  %str.len = getelementptr inbounds %String, ptr %16, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %17 = trunc i64 %len to i32
  %18 = call ptr @Strings.trimEnd(ptr @.strobj.2)
  %str.len1 = getelementptr inbounds %String, ptr %18, i32 0, i32 0
  %len2 = load i64, ptr %str.len1, align 8
  %19 = trunc i64 %len2 to i32
  %20 = call i32 @Strings.isBlank(ptr @.strobj.4)
  %21 = call i32 @Strings.isBlank(ptr @.strobj.6)
  %22 = call i32 @Strings.equalsIgnoreCase(ptr @.strobj.8, ptr @.strobj.10)
  %23 = call i32 @Strings.equalsIgnoreCase(ptr @.strobj.12, ptr @.strobj.14)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %19, i32 %20, i32 %21, i32 %22, i32 %23)
  call void @__polaron_str_free(ptr %16)
  call void @__polaron_str_free(ptr %18)
  ret i32 0
}

define internal i32 @Strings.isSpaceChar(i32 %0) {
entry:
  %c = alloca i32, align 4
  store i32 %0, ptr %c, align 4
  %c1 = load i32, ptr %c, align 4
  %1 = icmp eq i32 %c1, 32
  %2 = zext i1 %1 to i32
  %sc.a = icmp ne i32 %2, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %c2 = load i32, ptr %c, align 4
  %3 = icmp eq i32 %c2, 9
  %4 = zext i1 %3 to i32
  %sc.b = icmp ne i32 %4, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %5 = zext i1 %sc to i32
  %sc.a3 = icmp ne i32 %5, 0
  br i1 %sc.a3, label %sc.end5, label %sc.rhs4

sc.rhs4:                                          ; preds = %sc.end
  %c6 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %c6, 10
  %7 = zext i1 %6 to i32
  %sc.b7 = icmp ne i32 %7, 0
  br label %sc.end5

sc.end5:                                          ; preds = %sc.rhs4, %sc.end
  %sc8 = phi i1 [ true, %sc.end ], [ %sc.b7, %sc.rhs4 ]
  %8 = zext i1 %sc8 to i32
  %sc.a9 = icmp ne i32 %8, 0
  br i1 %sc.a9, label %sc.end11, label %sc.rhs10

sc.rhs10:                                         ; preds = %sc.end5
  %c12 = load i32, ptr %c, align 4
  %9 = icmp eq i32 %c12, 13
  %10 = zext i1 %9 to i32
  %sc.b13 = icmp ne i32 %10, 0
  br label %sc.end11

sc.end11:                                         ; preds = %sc.rhs10, %sc.end5
  %sc14 = phi i1 [ true, %sc.end5 ], [ %sc.b13, %sc.rhs10 ]
  %11 = zext i1 %sc14 to i32
  ret i32 %11
}

define internal ptr @Strings.trimStart(ptr %0) {
entry:
  %i = alloca i32, align 4
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %text2 = load ptr, ptr %text, align 8
  %str.len = getelementptr inbounds %String, ptr %text2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %i5 = load i32, ptr %i, align 4
  %4 = add i32 %i5, 1
  store i32 %4, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %text6 = load ptr, ptr %text, align 8
  %i7 = load i32, ptr %i, align 4
  %5 = sext i32 %i7 to i64
  %text8 = load ptr, ptr %text, align 8
  %str.len9 = getelementptr inbounds %String, ptr %text8, i32 0, i32 0
  %len10 = load i64, ptr %str.len9, align 8
  %6 = trunc i64 %len10 to i32
  %7 = sext i32 %6 to i64
  %8 = sub i64 %7, %5
  %9 = add i64 %8, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %9)
  %str.data11 = getelementptr inbounds %String, ptr %text6, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %10 = getelementptr i8, ptr %data12, i64 %5
  %11 = call ptr @memcpy(ptr %sub.buf, ptr %10, i64 %8)
  %12 = getelementptr i8, ptr %sub.buf, i64 %8
  store i8 0, ptr %12, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %8, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %14, align 8
  %15 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %15, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy

sc.rhs:                                           ; preds = %while.cond
  %text3 = load ptr, ptr %text, align 8
  %i4 = load i32, ptr %i, align 4
  %16 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %text3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %16
  %ch = load i8, ptr %ch.addr, align 1
  %17 = zext i8 %ch to i32
  %18 = call i32 @Strings.isSpaceChar(i32 %17)
  %sc.b = icmp ne i32 %18, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %19 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end
}

define internal ptr @Strings.trimEnd(ptr %0) {
entry:
  %e = alloca i32, align 4
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  %text1 = load ptr, ptr %text, align 8
  %str.len = getelementptr inbounds %String, ptr %text1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %e, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %e2 = load i32, ptr %e, align 4
  %2 = icmp sgt i32 %e2, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %e5 = load i32, ptr %e, align 4
  %4 = sub i32 %e5, 1
  store i32 %4, ptr %e, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %text6 = load ptr, ptr %text, align 8
  %e7 = load i32, ptr %e, align 4
  %5 = sext i32 %e7 to i64
  %6 = sub i64 %5, 0
  %7 = add i64 %6, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %7)
  %str.data8 = getelementptr inbounds %String, ptr %text6, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %8 = getelementptr i8, ptr %data9, i64 0
  %9 = call ptr @memcpy(ptr %sub.buf, ptr %8, i64 %6)
  %10 = getelementptr i8, ptr %sub.buf, i64 %6
  store i8 0, ptr %10, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %6, ptr %11, align 8
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %13, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy

sc.rhs:                                           ; preds = %while.cond
  %text3 = load ptr, ptr %text, align 8
  %e4 = load i32, ptr %e, align 4
  %14 = sub i32 %e4, 1
  %15 = sext i32 %14 to i64
  %str.data = getelementptr inbounds %String, ptr %text3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %15
  %ch = load i8, ptr %ch.addr, align 1
  %16 = zext i8 %ch to i32
  %17 = call i32 @Strings.isSpaceChar(i32 %16)
  %sc.b = icmp ne i32 %17, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %18 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end
}

define internal i32 @Strings.isBlank(ptr %0) {
entry:
  %i = alloca i32, align 4
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %text2 = load ptr, ptr %text, align 8
  %str.len = getelementptr inbounds %String, ptr %text2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %text3 = load ptr, ptr %text, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %text3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = call i32 @Strings.isSpaceChar(i32 %5)
  %7 = icmp eq i32 %6, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

for.update:                                       ; preds = %if.end
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 1

if.then:                                          ; preds = %for.body
  ret i32 0

if.end:                                           ; preds = %for.body
  br label %for.update
}

define internal i32 @Strings.equalsIgnoreCase(ptr %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %str.len = getelementptr inbounds %String, ptr %a1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.data = getelementptr inbounds %String, ptr %a1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %2 = call ptr @__polaron_str_lower(ptr %data, i64 %len)
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %len, ptr %3, align 8
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %2, ptr %4, align 8
  %5 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %5, align 8
  %b2 = load ptr, ptr %b, align 8
  %str.len3 = getelementptr inbounds %String, ptr %b2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %str.data5 = getelementptr inbounds %String, ptr %b2, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %6 = call ptr @__polaron_str_lower(ptr %data6, i64 %len4)
  %newstr7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %7 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 0
  store i64 %len4, ptr %7, align 8
  %8 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 1
  store ptr %6, ptr %8, align 8
  %9 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 2
  store i64 0, ptr %9, align 8
  %str.data8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %str.data10 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %10 = call i32 @strcmp(ptr %data9, ptr %data11)
  %11 = icmp eq i32 %10, 0
  %12 = zext i1 %11 to i32
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr7)
  ret i32 %12
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

declare void @__polaron_str_free(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare ptr @__polaron_str_copy(ptr)

declare ptr @__polaron_str_lower(ptr, i64)
