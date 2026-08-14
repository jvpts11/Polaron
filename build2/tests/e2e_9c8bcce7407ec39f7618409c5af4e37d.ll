; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/static_from_static.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/static_from_static.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Rules.VILLAGE = private global i32 120
@Rules.HAMLET = private global i32 30
@Rules.PAIR = private global i32 150
@Rules.SPAN = private global float 2.500000e+00
@Rules.HALF = private global float 1.250000e+00
@Rules.BIG = private global i32 1
@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [30 x i8] c"village=%d hamlet=%d pair=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"span=%g half=%g\0A\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"statics fold\00", align 1
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

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
  %VILLAGE = load i32, ptr @Rules.VILLAGE, align 4
  %HAMLET = load i32, ptr @Rules.HAMLET, align 4
  %PAIR = load i32, ptr @Rules.PAIR, align 4
  %16 = call i32 (ptr, ...) @printf(ptr @.str, i32 %VILLAGE, i32 %HAMLET, i32 %PAIR)
  %SPAN = load float, ptr @Rules.SPAN, align 4
  %17 = fpext float %SPAN to double
  %HALF = load float, ptr @Rules.HALF, align 4
  %18 = fpext float %HALF to double
  %19 = call i32 (ptr, ...) @printf(ptr @.str.1, double %17, double %18)
  %HAMLET1 = load i32, ptr @Rules.HAMLET, align 4
  %20 = icmp eq i32 %HAMLET1, 30
  %21 = zext i1 %20 to i32
  %sc.a = icmp ne i32 %21, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %argv.end
  %PAIR2 = load i32, ptr @Rules.PAIR, align 4
  %22 = icmp eq i32 %PAIR2, 150
  %23 = zext i1 %22 to i32
  %sc.b = icmp ne i32 %23, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %argv.end
  %sc = phi i1 [ false, %argv.end ], [ %sc.b, %sc.rhs ]
  %24 = zext i1 %sc to i32
  %sc.a3 = icmp ne i32 %24, 0
  br i1 %sc.a3, label %sc.rhs4, label %sc.end5

sc.rhs4:                                          ; preds = %sc.end
  %BIG = load i32, ptr @Rules.BIG, align 4
  %sc.b6 = icmp ne i32 %BIG, 0
  br label %sc.end5

sc.end5:                                          ; preds = %sc.rhs4, %sc.end
  %sc7 = phi i1 [ false, %sc.end ], [ %sc.b6, %sc.rhs4 ]
  %25 = zext i1 %sc7 to i32
  br i1 %sc7, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end5
  %26 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr @.str.3)
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end5
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5311)
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
