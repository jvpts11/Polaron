; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Board = type { ptr, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Board.vtable = private constant [354 x ptr] [ptr @Board.place, ptr @Board.line, ptr @Board.winner, ptr @Board.isFull, ptr @Board.show, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Board.~Board"]
@Object.vtable = private constant [354 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:25:35  in Board.Board\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:37:17  in Board.place\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [137 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:40:33  in Board.place\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:46:17  in Board.line\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:50:17  in Board.line\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:51:21  in Board.line\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [138 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:82:21  in Board.isFull\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:91:42  in Board.show\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:91:42  in Board.show\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:91:42  in Board.show\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [16 x i8] c" %c | %c | %c \0A\00", align 1
@.str.28 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.29 = private unnamed_addr constant [12 x i8] c"---+---+---\00", align 1
@.fail.30 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:93:42  in Board.show\0A\00", align 1
@.faila.31 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.32 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.33 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:93:42  in Board.show\0A\00", align 1
@.faila.34 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.35 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.36 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:93:42  in Board.show\0A\00", align 1
@.faila.37 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.38 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.39 = private unnamed_addr constant [16 x i8] c" %c | %c | %c \0A\00", align 1
@.str.40 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.41 = private unnamed_addr constant [12 x i8] c"---+---+---\00", align 1
@.fail.42 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:95:42  in Board.show\0A\00", align 1
@.faila.43 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.44 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.45 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:95:42  in Board.show\0A\00", align 1
@.faila.46 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.47 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.48 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/tic_tac_toe.pol:95:42  in Board.show\0A\00", align 1
@.faila.49 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.50 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.51 = private unnamed_addr constant [16 x i8] c" %c | %c | %c \0A\00", align 1
@.str.52 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.53 = private unnamed_addr constant [38 x i8] c"Tic-Tac-Toe! Choose positions 1 to 9.\00", align 1
@.str.54 = private unnamed_addr constant [35 x i8] c"Player %c's turn. Position (1-9):\0A\00", align 1
@.str.55 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.56 = private unnamed_addr constant [25 x i8] c"Invalid move, try again.\00", align 1
@.str.57 = private unnamed_addr constant [17 x i8] c"Player %c wins!\0A\00", align 1
@.str.58 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.59 = private unnamed_addr constant [13 x i8] c"It's a draw!\00", align 1
@.strdata.5367 = private constant [1 x i8] zeroinitializer
@.strobj.5368 = private global %String { i64 0, ptr @.strdata.5367, i64 0 }
@.strdata.5369 = private constant [1 x i8] zeroinitializer
@.strobj.5370 = private global %String { i64 0, ptr @.strdata.5369, i64 0 }

define internal void @Board.Board(ptr %0) {
entry:
  %i = alloca i32, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 0
  store ptr @Board.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %cells = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  store ptr null, ptr %cells, align 8, !tbaa !0
  %cells1 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 44)
  store i64 9, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 36)
  store ptr %arr, ptr %cells1, align 8, !tbaa !0
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok, %entry
  %i2 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %i2, 9
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %cells3 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells4 = load ptr, ptr %cells3, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %cells4, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

while.end:                                        ; preds = %while.cond
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %4, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data6 = getelementptr i8, ptr %cells4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data6, i64 %4
  store i32 32, ptr %arr.elem, align 4
  %i7 = load i32, ptr %i, align 4
  %5 = add i32 %i7, 1
  store i32 %5, ptr %i, align 4
  br label %while.cond
}

define internal i32 @Board.place(ptr nonnull align 8 dereferenceable(16) %0, i32 %1, i32 %2) {
entry:
  %player = alloca i32, align 4
  %pos = alloca i32, align 4
  store i32 %1, ptr %pos, align 4
  store i32 %2, ptr %player, align 4
  %pos1 = load i32, ptr %pos, align 4
  %3 = icmp slt i32 %pos1, 0
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %pos2 = load i32, ptr %pos, align 4
  %5 = icmp sgt i32 %pos2, 8
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i32 0

if.end:                                           ; preds = %sc.end
  %cells = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells3 = load ptr, ptr %cells, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %pos4 = load i32, ptr %pos, align 4
  %8 = sext i32 %pos4 to i64
  %arr.len = load i64, ptr %cells3, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %8, ptr @.failb.3, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %cells3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %elem = load i32, ptr %arr.elem, align 4
  %9 = icmp ne i32 %elem, 32
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then5, label %if.end6

if.then5:                                         ; preds = %idx.ok
  ret i32 0

if.end6:                                          ; preds = %idx.ok
  %cells7 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells8 = load ptr, ptr %cells7, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %pos9 = load i32, ptr %pos, align 4
  %11 = sext i32 %pos9 to i64
  %arr.len10 = load i64, ptr %cells8, align 8
  %arr.oob11 = icmp uge i64 %11, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !6

idx.bad12:                                        ; preds = %if.end6
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 %11, ptr @.failb.6, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %if.end6
  %arr.data14 = getelementptr i8, ptr %cells8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %11
  %player16 = load i32, ptr %player, align 4
  store i32 %player16, ptr %arr.elem15, align 4
  ret i32 1
}

define internal i32 @Board.line(ptr nonnull align 8 dereferenceable(16) %0, i32 %1, i32 %2, i32 %3) {
entry:
  %first = alloca i32, align 4
  %c = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %1, ptr %a, align 4
  store i32 %2, ptr %b, align 4
  store i32 %3, ptr %c, align 4
  %cells = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells1 = load ptr, ptr %cells, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %a2 = load i32, ptr %a, align 4
  %4 = sext i32 %a2 to i64
  %arr.len = load i64, ptr %cells1, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 %4, ptr @.failb.9, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %cells1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %first, align 4
  %first3 = load i32, ptr %first, align 4
  %5 = icmp eq i32 %first3, 32
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 32

if.end:                                           ; preds = %idx.ok
  %cells4 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells5 = load ptr, ptr %cells4, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %b6 = load i32, ptr %b, align 4
  %7 = sext i32 %b6 to i64
  %arr.len7 = load i64, ptr %cells5, align 8
  %arr.oob8 = icmp uge i64 %7, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !6

idx.bad9:                                         ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 %7, ptr @.failb.12, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %if.end
  %arr.data11 = getelementptr i8, ptr %cells5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %7
  %elem13 = load i32, ptr %arr.elem12, align 4
  %first14 = load i32, ptr %first, align 4
  %8 = icmp eq i32 %elem13, %first14
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then15, label %if.end16

if.then15:                                        ; preds = %idx.ok10
  %cells17 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells18 = load ptr, ptr %cells17, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %c19 = load i32, ptr %c, align 4
  %10 = sext i32 %c19 to i64
  %arr.len20 = load i64, ptr %cells18, align 8
  %arr.oob21 = icmp uge i64 %10, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !6

if.end16:                                         ; preds = %if.end29, %idx.ok10
  ret i32 32

idx.bad22:                                        ; preds = %if.then15
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 %10, ptr @.failb.15, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then15
  %arr.data24 = getelementptr i8, ptr %cells18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %10
  %elem26 = load i32, ptr %arr.elem25, align 4
  %first27 = load i32, ptr %first, align 4
  %11 = icmp eq i32 %elem26, %first27
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then28, label %if.end29

if.then28:                                        ; preds = %idx.ok23
  %first30 = load i32, ptr %first, align 4
  ret i32 %first30

if.end29:                                         ; preds = %idx.ok23
  br label %if.end16
}

define internal i32 @Board.winner(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %w = alloca i32, align 4
  %1 = call i32 @Board.line(ptr %0, i32 0, i32 1, i32 2)
  store i32 %1, ptr %w, align 4
  %w1 = load i32, ptr %w, align 4
  %2 = icmp ne i32 %w1, 32
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %w2 = load i32, ptr %w, align 4
  ret i32 %w2

if.end:                                           ; preds = %entry
  %4 = call i32 @Board.line(ptr %0, i32 3, i32 4, i32 5)
  store i32 %4, ptr %w, align 4
  %w3 = load i32, ptr %w, align 4
  %5 = icmp ne i32 %w3, 32
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.end
  %w6 = load i32, ptr %w, align 4
  ret i32 %w6

if.end5:                                          ; preds = %if.end
  %7 = call i32 @Board.line(ptr %0, i32 6, i32 7, i32 8)
  store i32 %7, ptr %w, align 4
  %w7 = load i32, ptr %w, align 4
  %8 = icmp ne i32 %w7, 32
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end5
  %w10 = load i32, ptr %w, align 4
  ret i32 %w10

if.end9:                                          ; preds = %if.end5
  %10 = call i32 @Board.line(ptr %0, i32 0, i32 3, i32 6)
  store i32 %10, ptr %w, align 4
  %w11 = load i32, ptr %w, align 4
  %11 = icmp ne i32 %w11, 32
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then12, label %if.end13

if.then12:                                        ; preds = %if.end9
  %w14 = load i32, ptr %w, align 4
  ret i32 %w14

if.end13:                                         ; preds = %if.end9
  %13 = call i32 @Board.line(ptr %0, i32 1, i32 4, i32 7)
  store i32 %13, ptr %w, align 4
  %w15 = load i32, ptr %w, align 4
  %14 = icmp ne i32 %w15, 32
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then16, label %if.end17

if.then16:                                        ; preds = %if.end13
  %w18 = load i32, ptr %w, align 4
  ret i32 %w18

if.end17:                                         ; preds = %if.end13
  %16 = call i32 @Board.line(ptr %0, i32 2, i32 5, i32 8)
  store i32 %16, ptr %w, align 4
  %w19 = load i32, ptr %w, align 4
  %17 = icmp ne i32 %w19, 32
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then20, label %if.end21

if.then20:                                        ; preds = %if.end17
  %w22 = load i32, ptr %w, align 4
  ret i32 %w22

if.end21:                                         ; preds = %if.end17
  %19 = call i32 @Board.line(ptr %0, i32 0, i32 4, i32 8)
  store i32 %19, ptr %w, align 4
  %w23 = load i32, ptr %w, align 4
  %20 = icmp ne i32 %w23, 32
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then24, label %if.end25

if.then24:                                        ; preds = %if.end21
  %w26 = load i32, ptr %w, align 4
  ret i32 %w26

if.end25:                                         ; preds = %if.end21
  %22 = call i32 @Board.line(ptr %0, i32 2, i32 4, i32 6)
  store i32 %22, ptr %w, align 4
  %w27 = load i32, ptr %w, align 4
  %23 = icmp ne i32 %w27, 32
  %24 = zext i1 %23 to i32
  br i1 %23, label %if.then28, label %if.end29

if.then28:                                        ; preds = %if.end25
  %w30 = load i32, ptr %w, align 4
  ret i32 %w30

if.end29:                                         ; preds = %if.end25
  ret i32 32
}

define internal i32 @Board.isFull(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %i = alloca i32, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %i1 = load i32, ptr %i, align 4
  %cells = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells2 = load ptr, ptr %cells, align 8, !tbaa !0
  %len = load i64, ptr %cells2, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %cells3 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells4 = load ptr, ptr %cells3, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %cells4, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

while.end:                                        ; preds = %while.cond
  ret i32 1

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 %4, ptr @.failb.18, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %cells4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %5 = icmp eq i32 %elem, 32
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 0

if.end:                                           ; preds = %idx.ok
  %i6 = load i32, ptr %i, align 4
  %7 = add i32 %i6, 1
  store i32 %7, ptr %i, align 4
  br label %while.cond
}

define internal void @Board.show(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %cells = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells1 = load ptr, ptr %cells, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len = load i64, ptr %cells1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 0, ptr @.failb.21, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %cells1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %cells2 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells3 = load ptr, ptr %cells2, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len4 = load i64, ptr %cells3, align 8
  %arr.oob5 = icmp uge i64 1, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !6

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 1, ptr @.failb.24, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %cells3, i64 8
  %arr.elem9 = getelementptr inbounds i32, ptr %arr.data8, i64 1
  %elem10 = load i32, ptr %arr.elem9, align 4
  %cells11 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells12 = load ptr, ptr %cells11, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len13 = load i64, ptr %cells12, align 8
  %arr.oob14 = icmp uge i64 2, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !6

idx.bad15:                                        ; preds = %idx.ok7
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 2, ptr @.failb.27, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok7
  %arr.data17 = getelementptr i8, ptr %cells12, i64 8
  %arr.elem18 = getelementptr inbounds i32, ptr %arr.data17, i64 2
  %elem19 = load i32, ptr %arr.elem18, align 4
  %1 = call i32 (ptr, ...) @printf(ptr @.str, i32 %elem, i32 %elem10, i32 %elem19)
  %2 = call i32 (ptr, ...) @printf(ptr @.str.28, ptr @.str.29)
  %cells20 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells21 = load ptr, ptr %cells20, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len22 = load i64, ptr %cells21, align 8
  %arr.oob23 = icmp uge i64 3, %arr.len22
  br i1 %arr.oob23, label %idx.bad24, label %idx.ok25, !prof !6

idx.bad24:                                        ; preds = %idx.ok16
  call void @__polaron_fail(ptr @.fail.30, ptr @.faila.31, i64 3, ptr @.failb.32, i64 %arr.len22, i32 70)
  unreachable

idx.ok25:                                         ; preds = %idx.ok16
  %arr.data26 = getelementptr i8, ptr %cells21, i64 8
  %arr.elem27 = getelementptr inbounds i32, ptr %arr.data26, i64 3
  %elem28 = load i32, ptr %arr.elem27, align 4
  %cells29 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells30 = load ptr, ptr %cells29, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len31 = load i64, ptr %cells30, align 8
  %arr.oob32 = icmp uge i64 4, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !6

idx.bad33:                                        ; preds = %idx.ok25
  call void @__polaron_fail(ptr @.fail.33, ptr @.faila.34, i64 4, ptr @.failb.35, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %idx.ok25
  %arr.data35 = getelementptr i8, ptr %cells30, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 4
  %elem37 = load i32, ptr %arr.elem36, align 4
  %cells38 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells39 = load ptr, ptr %cells38, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len40 = load i64, ptr %cells39, align 8
  %arr.oob41 = icmp uge i64 5, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !6

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.36, ptr @.faila.37, i64 5, ptr @.failb.38, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %cells39, i64 8
  %arr.elem45 = getelementptr inbounds i32, ptr %arr.data44, i64 5
  %elem46 = load i32, ptr %arr.elem45, align 4
  %3 = call i32 (ptr, ...) @printf(ptr @.str.39, i32 %elem28, i32 %elem37, i32 %elem46)
  %4 = call i32 (ptr, ...) @printf(ptr @.str.40, ptr @.str.41)
  %cells47 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells48 = load ptr, ptr %cells47, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len49 = load i64, ptr %cells48, align 8
  %arr.oob50 = icmp uge i64 6, %arr.len49
  br i1 %arr.oob50, label %idx.bad51, label %idx.ok52, !prof !6

idx.bad51:                                        ; preds = %idx.ok43
  call void @__polaron_fail(ptr @.fail.42, ptr @.faila.43, i64 6, ptr @.failb.44, i64 %arr.len49, i32 70)
  unreachable

idx.ok52:                                         ; preds = %idx.ok43
  %arr.data53 = getelementptr i8, ptr %cells48, i64 8
  %arr.elem54 = getelementptr inbounds i32, ptr %arr.data53, i64 6
  %elem55 = load i32, ptr %arr.elem54, align 4
  %cells56 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells57 = load ptr, ptr %cells56, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len58 = load i64, ptr %cells57, align 8
  %arr.oob59 = icmp uge i64 7, %arr.len58
  br i1 %arr.oob59, label %idx.bad60, label %idx.ok61, !prof !6

idx.bad60:                                        ; preds = %idx.ok52
  call void @__polaron_fail(ptr @.fail.45, ptr @.faila.46, i64 7, ptr @.failb.47, i64 %arr.len58, i32 70)
  unreachable

idx.ok61:                                         ; preds = %idx.ok52
  %arr.data62 = getelementptr i8, ptr %cells57, i64 8
  %arr.elem63 = getelementptr inbounds i32, ptr %arr.data62, i64 7
  %elem64 = load i32, ptr %arr.elem63, align 4
  %cells65 = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells66 = load ptr, ptr %cells65, align 8, !tbaa !0, !nonnull !4, !dereferenceable !5
  %arr.len67 = load i64, ptr %cells66, align 8
  %arr.oob68 = icmp uge i64 8, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !6

idx.bad69:                                        ; preds = %idx.ok61
  call void @__polaron_fail(ptr @.fail.48, ptr @.faila.49, i64 8, ptr @.failb.50, i64 %arr.len67, i32 70)
  unreachable

idx.ok70:                                         ; preds = %idx.ok61
  %arr.data71 = getelementptr i8, ptr %cells66, i64 8
  %arr.elem72 = getelementptr inbounds i32, ptr %arr.data71, i64 8
  %elem73 = load i32, ptr %arr.elem72, align 4
  %5 = call i32 (ptr, ...) @printf(ptr @.str.51, i32 %elem55, i32 %elem64, i32 %elem73)
  ret void
}

define internal void @"Board.~Board"(ptr %0) {
entry:
  %cells = getelementptr inbounds %class.Board, ptr %0, i32 0, i32 1
  %cells1 = load ptr, ptr %cells, align 8, !tbaa !0
  call void @__polaron_free(ptr %cells1)
  ret void
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %w = alloca i32, align 4
  %ok = alloca i32, align 4
  %pos = alloca i32, align 4
  %rlen = alloca i64, align 8
  %over = alloca i32, align 4
  %current = alloca i32, align 4
  %board = alloca ptr, align 8
  store ptr null, ptr %board, align 8
  %Board.obj = alloca %class.Board, align 8
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
  call void @Board.Board(ptr %Board.obj)
  store ptr %Board.obj, ptr %board, align 8
  store i32 88, ptr %current, align 4
  store i32 0, ptr %over, align 4
  %16 = call i32 (ptr, ...) @printf(ptr @.str.52, ptr @.str.53)
  br label %while.cond

while.cond:                                       ; preds = %if.end, %argv.end
  %over1 = load i32, ptr %over, align 4
  %17 = icmp eq i32 %over1, 0
  %18 = zext i1 %17 to i32
  br i1 %17, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %board2 = load ptr, ptr %board, align 8
  invoke void @Board.show(ptr %board2)
          to label %invoke.cont unwind label %cleanup.Board

while.end:                                        ; preds = %while.cond
  %19 = load ptr, ptr %board, align 8
  %20 = icmp ne ptr %19, null
  br i1 %20, label %dtor.live, label %dtor.done

cleanup.Board:                                    ; preds = %while.body
  %21 = cleanuppad within none []
  %22 = load ptr, ptr %board, align 8
  call void @"Board.~Board"(ptr %22) [ "funclet"(token %21) ]
  cleanupret from %21 unwind to caller

invoke.cont:                                      ; preds = %while.body
  %current3 = load i32, ptr %current, align 4
  %23 = call i32 (ptr, ...) @printf(ptr @.str.54, i32 %current3)
  %line = call ptr @polaron_read_line(ptr %rlen)
  %24 = load i64, ptr %rlen, align 8
  %newstr4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %25 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %24, ptr %25, align 8
  %26 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %line, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %27, align 8
  %str.data = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %28 = call i32 @atoi(ptr %data)
  store i32 %28, ptr %pos, align 4
  call void @__polaron_str_free(ptr %newstr4)
  %board5 = load ptr, ptr %board, align 8
  %pos6 = load i32, ptr %pos, align 4
  %29 = sub i32 %pos6, 1
  %current7 = load i32, ptr %current, align 4
  %30 = invoke i32 @Board.place(ptr %board5, i32 %29, i32 %current7)
          to label %invoke.cont9 unwind label %cleanup.Board8

cleanup.Board8:                                   ; preds = %invoke.cont
  %31 = cleanuppad within none []
  %32 = load ptr, ptr %board, align 8
  call void @"Board.~Board"(ptr %32) [ "funclet"(token %31) ]
  cleanupret from %31 unwind to caller

invoke.cont9:                                     ; preds = %invoke.cont
  store i32 %30, ptr %ok, align 4
  %ok10 = load i32, ptr %ok, align 4
  %33 = icmp eq i32 %ok10, 0
  %34 = zext i1 %33 to i32
  br i1 %33, label %if.then, label %if.else

if.then:                                          ; preds = %invoke.cont9
  %35 = call i32 (ptr, ...) @printf(ptr @.str.55, ptr @.str.56)
  br label %if.end

if.else:                                          ; preds = %invoke.cont9
  %board11 = load ptr, ptr %board, align 8
  %36 = invoke i32 @Board.winner(ptr %board11)
          to label %invoke.cont13 unwind label %cleanup.Board12

if.end:                                           ; preds = %if.end17, %if.then
  br label %while.cond

cleanup.Board12:                                  ; preds = %if.else
  %37 = cleanuppad within none []
  %38 = load ptr, ptr %board, align 8
  call void @"Board.~Board"(ptr %38) [ "funclet"(token %37) ]
  cleanupret from %37 unwind to caller

invoke.cont13:                                    ; preds = %if.else
  store i32 %36, ptr %w, align 4
  %w14 = load i32, ptr %w, align 4
  %39 = icmp ne i32 %w14, 32
  %40 = zext i1 %39 to i32
  br i1 %39, label %if.then15, label %if.else16

if.then15:                                        ; preds = %invoke.cont13
  %board18 = load ptr, ptr %board, align 8
  invoke void @Board.show(ptr %board18)
          to label %invoke.cont20 unwind label %cleanup.Board19

if.else16:                                        ; preds = %invoke.cont13
  %board22 = load ptr, ptr %board, align 8
  %41 = invoke i32 @Board.isFull(ptr %board22)
          to label %invoke.cont24 unwind label %cleanup.Board23

if.end17:                                         ; preds = %if.end27, %invoke.cont20
  br label %if.end

cleanup.Board19:                                  ; preds = %if.then15
  %42 = cleanuppad within none []
  %43 = load ptr, ptr %board, align 8
  call void @"Board.~Board"(ptr %43) [ "funclet"(token %42) ]
  cleanupret from %42 unwind to caller

invoke.cont20:                                    ; preds = %if.then15
  %w21 = load i32, ptr %w, align 4
  %44 = call i32 (ptr, ...) @printf(ptr @.str.57, i32 %w21)
  store i32 1, ptr %over, align 4
  br label %if.end17

cleanup.Board23:                                  ; preds = %if.else16
  %45 = cleanuppad within none []
  %46 = load ptr, ptr %board, align 8
  call void @"Board.~Board"(ptr %46) [ "funclet"(token %45) ]
  cleanupret from %45 unwind to caller

invoke.cont24:                                    ; preds = %if.else16
  %47 = icmp ne i32 %41, 0
  br i1 %47, label %if.then25, label %if.else26

if.then25:                                        ; preds = %invoke.cont24
  %board28 = load ptr, ptr %board, align 8
  invoke void @Board.show(ptr %board28)
          to label %invoke.cont30 unwind label %cleanup.Board29

if.else26:                                        ; preds = %invoke.cont24
  %current31 = load i32, ptr %current, align 4
  %48 = icmp eq i32 %current31, 88
  %49 = zext i1 %48 to i32
  br i1 %48, label %if.then32, label %if.else33

if.end27:                                         ; preds = %if.end34, %invoke.cont30
  br label %if.end17

cleanup.Board29:                                  ; preds = %if.then25
  %50 = cleanuppad within none []
  %51 = load ptr, ptr %board, align 8
  call void @"Board.~Board"(ptr %51) [ "funclet"(token %50) ]
  cleanupret from %50 unwind to caller

invoke.cont30:                                    ; preds = %if.then25
  %52 = call i32 (ptr, ...) @printf(ptr @.str.58, ptr @.str.59)
  store i32 1, ptr %over, align 4
  br label %if.end27

if.then32:                                        ; preds = %if.else26
  store i32 79, ptr %current, align 4
  br label %if.end34

if.else33:                                        ; preds = %if.else26
  store i32 88, ptr %current, align 4
  br label %if.end34

if.end34:                                         ; preds = %if.else33, %if.then32
  br label %if.end27

dtor.live:                                        ; preds = %while.end
  call void @"Board.~Board"(ptr %19)
  br label %dtor.done

dtor.done:                                        ; preds = %dtor.live, %while.end
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

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5368)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5370)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare void @__polaron_free(ptr)

declare i64 @strlen(ptr)

declare i32 @__CxxFrameHandler3(...)

declare ptr @polaron_read_line(ptr)

declare i32 @atoi(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{}
!5 = !{i64 8}
!6 = !{!"branch_weights", i32 1, i32 1048576}
