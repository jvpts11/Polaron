; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ternary.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ternary.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [10 x i8] c"max = %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"min = %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [11 x i8] c"sign = %d\0A\00", align 1
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %sign = alloca i32, align 4
  %min = alloca i32, align 4
  %max = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
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
  store i32 7, ptr %a, align 4
  store i32 3, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %b2 = load i32, ptr %b, align 4
  %16 = icmp sgt i32 %a1, %b2
  %17 = zext i1 %16 to i32
  %tern.c = icmp ne i32 %17, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %argv.end
  %a3 = load i32, ptr %a, align 4
  br label %tern.end

tern.else:                                        ; preds = %argv.end
  %b4 = load i32, ptr %b, align 4
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ %a3, %tern.then ], [ %b4, %tern.else ]
  store i32 %tern, ptr %max, align 4
  %a5 = load i32, ptr %a, align 4
  %b6 = load i32, ptr %b, align 4
  %18 = icmp slt i32 %a5, %b6
  %19 = zext i1 %18 to i32
  %tern.c7 = icmp ne i32 %19, 0
  br i1 %tern.c7, label %tern.then8, label %tern.else9

tern.then8:                                       ; preds = %tern.end
  %a11 = load i32, ptr %a, align 4
  br label %tern.end10

tern.else9:                                       ; preds = %tern.end
  %b12 = load i32, ptr %b, align 4
  br label %tern.end10

tern.end10:                                       ; preds = %tern.else9, %tern.then8
  %tern13 = phi i32 [ %a11, %tern.then8 ], [ %b12, %tern.else9 ]
  store i32 %tern13, ptr %min, align 4
  %max14 = load i32, ptr %max, align 4
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %max14)
  %min15 = load i32, ptr %min, align 4
  %21 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %min15)
  %a16 = load i32, ptr %a, align 4
  %b17 = load i32, ptr %b, align 4
  %22 = sub i32 %a16, %b17
  %23 = icmp sgt i32 %22, 0
  %24 = zext i1 %23 to i32
  %tern.c18 = icmp ne i32 %24, 0
  br i1 %tern.c18, label %tern.then19, label %tern.else20

tern.then19:                                      ; preds = %tern.end10
  br label %tern.end21

tern.else20:                                      ; preds = %tern.end10
  %a22 = load i32, ptr %a, align 4
  %b23 = load i32, ptr %b, align 4
  %25 = icmp eq i32 %a22, %b23
  %26 = zext i1 %25 to i32
  %tern.c24 = icmp ne i32 %26, 0
  br i1 %tern.c24, label %tern.then25, label %tern.else26

tern.end21:                                       ; preds = %tern.end27, %tern.then19
  %tern29 = phi i32 [ 1, %tern.then19 ], [ %tern28, %tern.end27 ]
  store i32 %tern29, ptr %sign, align 4
  %sign30 = load i32, ptr %sign, align 4
  %27 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %sign30)
  ret i32 0

tern.then25:                                      ; preds = %tern.else20
  br label %tern.end27

tern.else26:                                      ; preds = %tern.else20
  br label %tern.end27

tern.end27:                                       ; preds = %tern.else26, %tern.then25
  %tern28 = phi i32 [ 0, %tern.then25 ], [ -1, %tern.else26 ]
  br label %tern.end21
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5310)
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
