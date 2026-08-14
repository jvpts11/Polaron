; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_random.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_random.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [19 x i8] c"count=%d valid=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %valid = alloca i32, align 4
  %r = alloca i32, align 4
  %c = alloca i32, align 4
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
  store i32 4, ptr %c, align 4
  %rand = call i32 @rand()
  %enum.random = srem i32 %rand, 4
  store i32 %enum.random, ptr %r, align 4
  %r1 = load i32, ptr %r, align 4
  %16 = icmp eq i32 %r1, 0
  %17 = zext i1 %16 to i32
  %sc.a = icmp ne i32 %17, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %argv.end
  %r2 = load i32, ptr %r, align 4
  %18 = icmp eq i32 %r2, 1
  %19 = zext i1 %18 to i32
  %sc.b = icmp ne i32 %19, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %argv.end
  %sc = phi i1 [ true, %argv.end ], [ %sc.b, %sc.rhs ]
  %20 = zext i1 %sc to i32
  %sc.a3 = icmp ne i32 %20, 0
  br i1 %sc.a3, label %sc.end5, label %sc.rhs4

sc.rhs4:                                          ; preds = %sc.end
  %r6 = load i32, ptr %r, align 4
  %21 = icmp eq i32 %r6, 2
  %22 = zext i1 %21 to i32
  %sc.b7 = icmp ne i32 %22, 0
  br label %sc.end5

sc.end5:                                          ; preds = %sc.rhs4, %sc.end
  %sc8 = phi i1 [ true, %sc.end ], [ %sc.b7, %sc.rhs4 ]
  %23 = zext i1 %sc8 to i32
  %sc.a9 = icmp ne i32 %23, 0
  br i1 %sc.a9, label %sc.end11, label %sc.rhs10

sc.rhs10:                                         ; preds = %sc.end5
  %r12 = load i32, ptr %r, align 4
  %24 = icmp eq i32 %r12, 3
  %25 = zext i1 %24 to i32
  %sc.b13 = icmp ne i32 %25, 0
  br label %sc.end11

sc.end11:                                         ; preds = %sc.rhs10, %sc.end5
  %sc14 = phi i1 [ true, %sc.end5 ], [ %sc.b13, %sc.rhs10 ]
  %26 = zext i1 %sc14 to i32
  store i32 %26, ptr %valid, align 4
  %c15 = load i32, ptr %c, align 4
  %valid16 = load i32, ptr %valid, align 4
  %27 = call i32 (ptr, ...) @printf(ptr @.str, i32 %c15, i32 %valid16)
  ret i32 0
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

declare i32 @rand()

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
