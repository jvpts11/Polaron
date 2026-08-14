; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/unary_ternary.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/unary_ternary.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [23 x i8] c"sign=%.1f r=%.1f k=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %k = alloca i32, align 4
  %r = alloca double, align 8
  %sign = alloca double, align 8
  %a = alloca double, align 8
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
  store double -2.000000e+00, ptr %a, align 8
  %a1 = load double, ptr %a, align 8
  %16 = fcmp olt double %a1, 0.000000e+00
  %17 = zext i1 %16 to i32
  %tern.c = icmp ne i32 %17, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %argv.end
  br label %tern.end

tern.else:                                        ; preds = %argv.end
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi double [ -1.000000e+00, %tern.then ], [ 1.000000e+00, %tern.else ]
  store double %tern, ptr %sign, align 8
  %a2 = load double, ptr %a, align 8
  %sign3 = load double, ptr %sign, align 8
  %18 = fmul double %a2, %sign3
  store double %18, ptr %r, align 8
  %a4 = load double, ptr %a, align 8
  %a5 = load double, ptr %a, align 8
  %19 = fcmp olt double %a5, 0.000000e+00
  %20 = zext i1 %19 to i32
  %tern.c6 = icmp ne i32 %20, 0
  br i1 %tern.c6, label %tern.then7, label %tern.else8

tern.then7:                                       ; preds = %tern.end
  br label %tern.end9

tern.else8:                                       ; preds = %tern.end
  br label %tern.end9

tern.end9:                                        ; preds = %tern.else8, %tern.then7
  %tern10 = phi double [ -5.000000e-01, %tern.then7 ], [ 5.000000e-01, %tern.else8 ]
  %21 = fadd double %a4, %tern10
  %22 = call i32 @llvm.fptosi.sat.i32.f64(double %21)
  store i32 %22, ptr %k, align 4
  %sign11 = load double, ptr %sign, align 8
  %r12 = load double, ptr %r, align 8
  %k13 = load i32, ptr %k, align 4
  %23 = call i32 (ptr, ...) @printf(ptr @.str, double %sign11, double %r12, i32 %k13)
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

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #0

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
