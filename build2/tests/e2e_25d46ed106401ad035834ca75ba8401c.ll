; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/parse_double.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/parse_double.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [5 x i8] c"3.14\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"-1.5e2\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [3 x i8] c"42\00"
@.strobj.4 = private global %String { i64 2, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [26 x i8] c"a=%d b=%d c=%d exe_ok=%d\0A\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %exe = alloca ptr, align 8
  %c = alloca ptr, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %a, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.2)
  store ptr %strcpy1, ptr %b, align 8
  %strcpy2 = call ptr @__polaron_str_copy(ptr @.strobj.4)
  store ptr %strcpy2, ptr %c, align 8
  %16 = call ptr @__polaron_executable_path()
  %exe.len = call i64 @strlen(ptr %16)
  %newstr3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 0
  store i64 %exe.len, ptr %17, align 8
  %18 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 1
  store ptr %16, ptr %18, align 8
  %19 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 2
  store i64 0, ptr %19, align 8
  %strcpy4 = call ptr @__polaron_str_copy(ptr %newstr3)
  store ptr %strcpy4, ptr %exe, align 8
  call void @__polaron_str_free(ptr %newstr3)
  %a5 = load ptr, ptr %a, align 8
  %str.data = getelementptr inbounds %String, ptr %a5, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %20 = call double @atof(ptr %data)
  %21 = fmul double %20, 1.000000e+02
  %22 = call i32 @llvm.fptosi.sat.i32.f64(double %21)
  %b6 = load ptr, ptr %b, align 8
  %str.data7 = getelementptr inbounds %String, ptr %b6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %23 = call double @atof(ptr %data8)
  %24 = call i32 @llvm.fptosi.sat.i32.f64(double %23)
  %c9 = load ptr, ptr %c, align 8
  %str.data10 = getelementptr inbounds %String, ptr %c9, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %25 = call double @atof(ptr %data11)
  %26 = call i32 @llvm.fptosi.sat.i32.f64(double %25)
  %exe12 = load ptr, ptr %exe, align 8
  %str.len = getelementptr inbounds %String, ptr %exe12, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %27 = trunc i64 %len to i32
  %28 = icmp sgt i32 %27, 0
  %29 = zext i1 %28 to i32
  %tern.c = icmp ne i32 %29, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %argv.end
  br label %tern.end

tern.else:                                        ; preds = %argv.end
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ 1, %tern.then ], [ 0, %tern.else ]
  %30 = call i32 (ptr, ...) @printf(ptr @.str, i32 %22, i32 %24, i32 %26, i32 %tern)
  %31 = load ptr, ptr %exe, align 8
  call void @__polaron_str_free(ptr %31)
  %32 = load ptr, ptr %c, align 8
  call void @__polaron_str_free(ptr %32)
  %33 = load ptr, ptr %b, align 8
  call void @__polaron_str_free(ptr %33)
  %34 = load ptr, ptr %a, align 8
  call void @__polaron_str_free(ptr %34)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare ptr @__polaron_executable_path()

declare void @__polaron_str_free(ptr)

declare double @atof(ptr)

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #0

declare i32 @printf(ptr, ...)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
