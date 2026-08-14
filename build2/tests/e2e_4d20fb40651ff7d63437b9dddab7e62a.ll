; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bits.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bits.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [56 x i8] c"pc=%d lz=%d tz=%d p16=%d p17=%d np17=%d np16=%d rev=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

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
  %16 = call i32 @Bits.popcount(i32 255)
  %17 = call i32 @Bits.leadingZeros(i32 1)
  %18 = call i32 @Bits.trailingZeros(i32 24)
  %19 = call i32 @Bits.isPow2(i32 16)
  %20 = call i32 @Bits.isPow2(i32 17)
  %21 = call i32 @Bits.nextPow2(i32 17)
  %22 = call i32 @Bits.nextPow2(i32 16)
  %23 = call i32 @Bits.reverse(i32 252645135)
  %24 = call i32 @Bits.popcount(i32 %23)
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22, i32 %24)
  ret i32 0
}

define internal i32 @Bits.popcount(i32 %0) {
entry:
  %c = alloca i32, align 4
  %v = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  store i32 %x1, ptr %v, align 4
  store i32 0, ptr %c, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %v2 = load i32, ptr %v, align 4
  %1 = icmp ne i32 %v2, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %c3 = load i32, ptr %c, align 4
  %v4 = load i32, ptr %v, align 4
  %3 = and i32 %v4, 1
  %4 = add i32 %c3, %3
  store i32 %4, ptr %c, align 4
  %v5 = load i32, ptr %v, align 4
  %5 = lshr i32 %v5, 1
  store i32 %5, ptr %v, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %c6 = load i32, ptr %c, align 4
  ret i32 %c6
}

define internal i32 @Bits.leadingZeros(i32 %0) {
entry:
  %n = alloca i32, align 4
  %v = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  store i32 %x1, ptr %v, align 4
  %v2 = load i32, ptr %v, align 4
  %1 = icmp eq i32 %v2, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 32

if.end:                                           ; preds = %entry
  store i32 0, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %v3 = load i32, ptr %v, align 4
  %3 = and i32 %v3, -2147483648
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n4 = load i32, ptr %n, align 4
  %6 = add i32 %n4, 1
  store i32 %6, ptr %n, align 4
  %v5 = load i32, ptr %v, align 4
  %7 = shl i32 %v5, 1
  store i32 %7, ptr %v, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n6 = load i32, ptr %n, align 4
  ret i32 %n6
}

define internal i32 @Bits.trailingZeros(i32 %0) {
entry:
  %n = alloca i32, align 4
  %v = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %1 = icmp eq i32 %x1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 32

if.end:                                           ; preds = %entry
  %x2 = load i32, ptr %x, align 4
  store i32 %x2, ptr %v, align 4
  store i32 0, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %v3 = load i32, ptr %v, align 4
  %3 = and i32 %v3, 1
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n4 = load i32, ptr %n, align 4
  %6 = add i32 %n4, 1
  store i32 %6, ptr %n, align 4
  %v5 = load i32, ptr %v, align 4
  %7 = lshr i32 %v5, 1
  store i32 %7, ptr %v, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n6 = load i32, ptr %n, align 4
  ret i32 %n6
}

define internal i32 @Bits.isPow2(i32 %0) {
entry:
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = icmp sgt i32 %n1, 0
  %2 = zext i1 %1 to i32
  %sc.a = icmp ne i32 %2, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %n2 = load i32, ptr %n, align 4
  %n3 = load i32, ptr %n, align 4
  %3 = sub i32 %n3, 1
  %4 = and i32 %n2, %3
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  ret i32 %7
}

define internal i32 @Bits.nextPow2(i32 %0) {
entry:
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = icmp sle i32 %n1, 1
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 1

if.end:                                           ; preds = %entry
  %n2 = load i32, ptr %n, align 4
  %3 = sub i32 %n2, 1
  %4 = call i32 @Bits.leadingZeros(i32 %3)
  %5 = sub i32 32, %4
  %6 = icmp ult i32 %5, 32
  %7 = select i1 %6, i32 %5, i32 0
  %8 = shl i32 1, %7
  %9 = select i1 %6, i32 %8, i32 0
  ret i32 %9
}

define internal i32 @Bits.reverse(i32 %0) {
entry:
  %i = alloca i32, align 4
  %r = alloca i32, align 4
  %v = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  store i32 %x1, ptr %v, align 4
  store i32 0, ptr %r, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %1 = icmp slt i32 %i2, 32
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %r3 = load i32, ptr %r, align 4
  %3 = shl i32 %r3, 1
  %v4 = load i32, ptr %v, align 4
  %4 = and i32 %v4, 1
  %5 = or i32 %3, %4
  store i32 %5, ptr %r, align 4
  %v5 = load i32, ptr %v, align 4
  %6 = lshr i32 %v5, 1
  store i32 %6, ptr %v, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %7 = load i32, ptr %i, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %r6 = load i32, ptr %r, align 4
  ret i32 %r6
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
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
