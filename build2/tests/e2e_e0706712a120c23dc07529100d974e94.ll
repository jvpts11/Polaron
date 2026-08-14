; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/scanner_tokens.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/scanner_tokens.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Scanner = type { ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Scanner.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Scanner.hasNext, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Scanner.skipSpaces, ptr @Scanner.nextWord, ptr @Scanner.nextInt, ptr @Scanner.hasNextLine, ptr @Scanner.nextLine, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [20 x i8] c"  42 hello   world \00"
@.strobj = private global %String { i64 19, ptr @.strdata, i64 0 }
@.str = private unnamed_addr constant [24 x i8] c"n=%d a=%s b=%s more=%d\0A\00", align 1
@.strdata.1 = private constant [19 x i8] c"first\0Asecond\0Athird\00"
@.strobj.2 = private global %String { i64 18, ptr @.strdata.1, i64 0 }
@.str.3 = private unnamed_addr constant [19 x i8] c"l1=%s l2=%s l3=%s\0A\00", align 1
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %lines = alloca ptr, align 8
  %n = alloca i32, align 4
  %sc = alloca ptr, align 8
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
  %Scanner.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Scanner, ptr null, i64 1) to i64))
  call void @Scanner.Scanner(ptr %Scanner.obj, ptr @.strobj)
  store ptr %Scanner.obj, ptr %sc, align 8
  %sc1 = load ptr, ptr %sc, align 8
  %16 = call i32 @Scanner.nextInt(ptr %sc1)
  store i32 %16, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  %sc3 = load ptr, ptr %sc, align 8
  %17 = call ptr @Scanner.nextWord(ptr %sc3)
  %str.data = getelementptr inbounds %String, ptr %17, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %sc4 = load ptr, ptr %sc, align 8
  %18 = call ptr @Scanner.nextWord(ptr %sc4)
  %str.data5 = getelementptr inbounds %String, ptr %18, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %sc7 = load ptr, ptr %sc, align 8
  %19 = call i32 @Scanner.hasNext(ptr %sc7)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %n2, ptr %data, ptr %data6, i32 %19)
  call void @__polaron_str_free(ptr %17)
  call void @__polaron_str_free(ptr %18)
  %Scanner.obj8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Scanner, ptr null, i64 1) to i64))
  call void @Scanner.Scanner(ptr %Scanner.obj8, ptr @.strobj.2)
  store ptr %Scanner.obj8, ptr %lines, align 8
  %lines9 = load ptr, ptr %lines, align 8
  %21 = call ptr @Scanner.nextLine(ptr %lines9)
  %str.data10 = getelementptr inbounds %String, ptr %21, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %lines12 = load ptr, ptr %lines, align 8
  %22 = call ptr @Scanner.nextLine(ptr %lines12)
  %str.data13 = getelementptr inbounds %String, ptr %22, i32 0, i32 1
  %data14 = load ptr, ptr %str.data13, align 8
  %lines15 = load ptr, ptr %lines, align 8
  %23 = call ptr @Scanner.nextLine(ptr %lines15)
  %str.data16 = getelementptr inbounds %String, ptr %23, i32 0, i32 1
  %data17 = load ptr, ptr %str.data16, align 8
  %24 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr %data11, ptr %data14, ptr %data17)
  call void @__polaron_str_free(ptr %21)
  call void @__polaron_str_free(ptr %22)
  call void @__polaron_str_free(ptr %23)
  ret i32 0
}

define internal i32 @Object.equals(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal i32 @Object.hashCode(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 0
}

define internal i32 @Object.equalsKey(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal void @Object.Object(ptr %0) {
entry:
  %vtbl.addr = getelementptr inbounds %class.Object, ptr %0, i32 0, i32 0
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @Scanner.Scanner(ptr %0, ptr %1) {
entry:
  %text = alloca ptr, align 8
  store ptr %1, ptr %text, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 0
  store ptr @Scanner.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %src = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  store ptr null, ptr %src, align 8, !tbaa !0
  %src1 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %text2 = load ptr, ptr %text, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %text2)
  %2 = load ptr, ptr %src1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %src1, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @Scanner.isSpace(i32 %0) {
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

define internal void @Scanner.skipSpaces(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %pos = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %src = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src2 = load ptr, ptr %src, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %src2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %pos7 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos8 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos9 = load i32, ptr %pos8, align 4, !tbaa !4
  %4 = add i32 %pos9, 1
  store i32 %4, ptr %pos7, align 4, !tbaa !4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  ret void

sc.rhs:                                           ; preds = %while.cond
  %src3 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src4 = load ptr, ptr %src3, align 8, !tbaa !0
  %pos5 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos6 = load i32, ptr %pos5, align 4, !tbaa !4
  %5 = sext i32 %pos6 to i64
  %str.data = getelementptr inbounds %String, ptr %src4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = call i32 @Scanner.isSpace(i32 %6)
  %sc.b = icmp ne i32 %7, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %8 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end
}

define internal i32 @Scanner.hasNext(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  call void @Scanner.skipSpaces(ptr %0)
  %pos = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %src = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src2 = load ptr, ptr %src, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %src2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @Scanner.nextWord(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %start = alloca i32, align 4
  call void @Scanner.skipSpaces(ptr %0)
  %pos = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  store i32 %pos1, ptr %start, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %pos2 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos3 = load i32, ptr %pos2, align 4, !tbaa !4
  %src = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src4 = load ptr, ptr %src, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %src4, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %pos3, %1
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %pos9 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos10 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos11 = load i32, ptr %pos10, align 4, !tbaa !4
  %4 = add i32 %pos11, 1
  store i32 %4, ptr %pos9, align 4, !tbaa !4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %src12 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src13 = load ptr, ptr %src12, align 8, !tbaa !0
  %start14 = load i32, ptr %start, align 4
  %5 = sext i32 %start14 to i64
  %pos15 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos16 = load i32, ptr %pos15, align 4, !tbaa !4
  %6 = sext i32 %pos16 to i64
  %7 = sub i64 %6, %5
  %8 = add i64 %7, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %8)
  %str.data17 = getelementptr inbounds %String, ptr %src13, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %9 = getelementptr i8, ptr %data18, i64 %5
  %10 = call ptr @memcpy(ptr %sub.buf, ptr %9, i64 %7)
  %11 = getelementptr i8, ptr %sub.buf, i64 %7
  store i8 0, ptr %11, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %7, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %14, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy

sc.rhs:                                           ; preds = %while.cond
  %src5 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src6 = load ptr, ptr %src5, align 8, !tbaa !0
  %pos7 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos8 = load i32, ptr %pos7, align 4, !tbaa !4
  %15 = sext i32 %pos8 to i64
  %str.data = getelementptr inbounds %String, ptr %src6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %15
  %ch = load i8, ptr %ch.addr, align 1
  %16 = zext i8 %ch to i32
  %17 = call i32 @Scanner.isSpace(i32 %16)
  %18 = icmp eq i32 %17, 0
  %19 = zext i1 %18 to i32
  %sc.b = icmp ne i32 %19, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %20 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end
}

define internal i32 @Scanner.nextInt(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %1 = call ptr @Scanner.nextWord(ptr %0)
  %str.data = getelementptr inbounds %String, ptr %1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %2 = call i32 @atoi(ptr %data)
  call void @__polaron_str_free(ptr %1)
  ret i32 %2
}

define internal i32 @Scanner.hasNextLine(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %src = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src2 = load ptr, ptr %src, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %src2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @Scanner.nextLine(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %line = alloca ptr, align 8
  %start = alloca i32, align 4
  %pos = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  store i32 %pos1, ptr %start, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %pos2 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos3 = load i32, ptr %pos2, align 4, !tbaa !4
  %src = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src4 = load ptr, ptr %src, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %src4, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %pos3, %1
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %pos9 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos10 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos11 = load i32, ptr %pos10, align 4, !tbaa !4
  %4 = add i32 %pos11, 1
  store i32 %4, ptr %pos9, align 4, !tbaa !4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %src12 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src13 = load ptr, ptr %src12, align 8, !tbaa !0
  %start14 = load i32, ptr %start, align 4
  %5 = sext i32 %start14 to i64
  %pos15 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos16 = load i32, ptr %pos15, align 4, !tbaa !4
  %6 = sext i32 %pos16 to i64
  %7 = sub i64 %6, %5
  %8 = add i64 %7, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %8)
  %str.data17 = getelementptr inbounds %String, ptr %src13, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %9 = getelementptr i8, ptr %data18, i64 %5
  %10 = call ptr @memcpy(ptr %sub.buf, ptr %9, i64 %7)
  %11 = getelementptr i8, ptr %sub.buf, i64 %7
  store i8 0, ptr %11, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %7, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %14, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy, ptr %line, align 8
  call void @__polaron_str_free(ptr %newstr)
  %pos19 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos20 = load i32, ptr %pos19, align 4, !tbaa !4
  %src21 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src22 = load ptr, ptr %src21, align 8, !tbaa !0
  %str.len23 = getelementptr inbounds %String, ptr %src22, i32 0, i32 0
  %len24 = load i64, ptr %str.len23, align 8
  %15 = trunc i64 %len24 to i32
  %16 = icmp slt i32 %pos20, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then, label %if.end

sc.rhs:                                           ; preds = %while.cond
  %src5 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 1
  %src6 = load ptr, ptr %src5, align 8, !tbaa !0
  %pos7 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos8 = load i32, ptr %pos7, align 4, !tbaa !4
  %18 = sext i32 %pos8 to i64
  %str.data = getelementptr inbounds %String, ptr %src6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %18
  %ch = load i8, ptr %ch.addr, align 1
  %19 = zext i8 %ch to i32
  %20 = icmp ne i32 %19, 10
  %21 = zext i1 %20 to i32
  %sc.b = icmp ne i32 %21, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %22 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

if.then:                                          ; preds = %while.end
  %pos25 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos26 = getelementptr inbounds %class.Scanner, ptr %0, i32 0, i32 2
  %pos27 = load i32, ptr %pos26, align 4, !tbaa !4
  %23 = add i32 %pos27, 1
  store i32 %23, ptr %pos25, align 4, !tbaa !4
  br label %if.end

if.end:                                           ; preds = %if.then, %while.end
  %line28 = load ptr, ptr %line, align 8
  %strcpy29 = call ptr @__polaron_str_copy(ptr %line28)
  %24 = load ptr, ptr %line, align 8
  call void @__polaron_str_free(ptr %24)
  ret ptr %strcpy29
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5311)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5313)
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

declare ptr @__polaron_str_copy(ptr)

declare i32 @atoi(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
