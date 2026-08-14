; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/record_float_field.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/record_float_field.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Sample = type { i32, float, double }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [8 x i8] c"Sample(\00"
@.strobj = private global %String { i64 7, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [3 x i8] c", \00"
@.strobj.2 = private global %String { i64 2, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [3 x i8] c", \00"
@.strobj.4 = private global %String { i64 2, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [2 x i8] c")\00"
@.strobj.6 = private global %String { i64 1, ptr @.strdata.5, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }

define internal void @Sample.Sample(ptr %0, i32 %1, float %2, double %3) {
entry:
  %scale = alloca double, align 8
  %ratio = alloca float, align 4
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  store float %2, ptr %ratio, align 4
  store double %3, ptr %scale, align 8
  %n1 = getelementptr inbounds %class.Sample, ptr %0, i32 0, i32 0
  %n2 = load i32, ptr %n, align 4
  store i32 %n2, ptr %n1, align 4, !tbaa !0
  %ratio3 = getelementptr inbounds %class.Sample, ptr %0, i32 0, i32 1
  %ratio4 = load float, ptr %ratio, align 4
  store float %ratio4, ptr %ratio3, align 4, !tbaa !4
  %scale5 = getelementptr inbounds %class.Sample, ptr %0, i32 0, i32 2
  %scale6 = load double, ptr %scale, align 8
  store double %scale6, ptr %scale5, align 8, !tbaa !6
  ret void
}

define internal ptr @Sample.toString(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %n = getelementptr inbounds %class.Sample, ptr %0, i32 0, i32 0
  %n1 = load i32, ptr %n, align 4, !tbaa !0
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %1 = sext i32 %n1 to i64
  %2 = call i64 @__polaron_itoa(i64 %1, ptr %itoa.buf)
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %2, ptr %3, align 8
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %itoa.buf, ptr %4, align 8
  %5 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %5, align 8
  %len = load i64, ptr @.strobj, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  %len2 = load i64, ptr %str.len, align 8
  %6 = add i64 %len, %len2
  %7 = add i64 %6, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %7)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %8 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  %data3 = load ptr, ptr %str.data, align 8
  %9 = getelementptr i8, ptr %cat.buf, i64 %len
  %10 = call ptr @memcpy(ptr %9, ptr %data3, i64 %len2)
  %11 = getelementptr i8, ptr %cat.buf, i64 %6
  store i8 0, ptr %11, align 1
  %newstr4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %12 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %6, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %cat.buf, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %14, align 8
  %str.len5 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %len7 = load i64, ptr @.strobj.2, align 8
  %15 = add i64 %len6, %len7
  %16 = add i64 %15, 1
  %cat.buf8 = call ptr @__polaron_malloc(i64 %16)
  %str.data9 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %17 = call ptr @memcpy(ptr %cat.buf8, ptr %data10, i64 %len6)
  %data11 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %18 = getelementptr i8, ptr %cat.buf8, i64 %len6
  %19 = call ptr @memcpy(ptr %18, ptr %data11, i64 %len7)
  %20 = getelementptr i8, ptr %cat.buf8, i64 %15
  store i8 0, ptr %20, align 1
  %newstr12 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %21 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 0
  store i64 %15, ptr %21, align 8
  %22 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 1
  store ptr %cat.buf8, ptr %22, align 8
  %23 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 2
  store i64 0, ptr %23, align 8
  %ratio = getelementptr inbounds %class.Sample, ptr %0, i32 0, i32 1
  %ratio13 = load float, ptr %ratio, align 4, !tbaa !4
  %24 = fpext float %ratio13 to double
  %ftoa.buf = call ptr @__polaron_malloc(i64 32)
  %25 = call i64 @__polaron_ftoa(double %24, ptr %ftoa.buf)
  %newstr14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %26 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 0
  store i64 %25, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 1
  store ptr %ftoa.buf, ptr %27, align 8
  %28 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 2
  store i64 0, ptr %28, align 8
  %str.len15 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 0
  %len16 = load i64, ptr %str.len15, align 8
  %str.len17 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  %29 = add i64 %len16, %len18
  %30 = add i64 %29, 1
  %cat.buf19 = call ptr @__polaron_malloc(i64 %30)
  %str.data20 = getelementptr inbounds %String, ptr %newstr12, i32 0, i32 1
  %data21 = load ptr, ptr %str.data20, align 8
  %31 = call ptr @memcpy(ptr %cat.buf19, ptr %data21, i64 %len16)
  %str.data22 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %32 = getelementptr i8, ptr %cat.buf19, i64 %len16
  %33 = call ptr @memcpy(ptr %32, ptr %data23, i64 %len18)
  %34 = getelementptr i8, ptr %cat.buf19, i64 %29
  store i8 0, ptr %34, align 1
  %newstr24 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 0
  store i64 %29, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 1
  store ptr %cat.buf19, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %str.len25 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 0
  %len26 = load i64, ptr %str.len25, align 8
  %len27 = load i64, ptr @.strobj.4, align 8
  %38 = add i64 %len26, %len27
  %39 = add i64 %38, 1
  %cat.buf28 = call ptr @__polaron_malloc(i64 %39)
  %str.data29 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 1
  %data30 = load ptr, ptr %str.data29, align 8
  %40 = call ptr @memcpy(ptr %cat.buf28, ptr %data30, i64 %len26)
  %data31 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %41 = getelementptr i8, ptr %cat.buf28, i64 %len26
  %42 = call ptr @memcpy(ptr %41, ptr %data31, i64 %len27)
  %43 = getelementptr i8, ptr %cat.buf28, i64 %38
  store i8 0, ptr %43, align 1
  %newstr32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %44 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 0
  store i64 %38, ptr %44, align 8
  %45 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  store ptr %cat.buf28, ptr %45, align 8
  %46 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 2
  store i64 0, ptr %46, align 8
  %scale = getelementptr inbounds %class.Sample, ptr %0, i32 0, i32 2
  %scale33 = load double, ptr %scale, align 8, !tbaa !6
  %ftoa.buf34 = call ptr @__polaron_malloc(i64 32)
  %47 = call i64 @__polaron_ftoa(double %scale33, ptr %ftoa.buf34)
  %newstr35 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %48 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 0
  store i64 %47, ptr %48, align 8
  %49 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 1
  store ptr %ftoa.buf34, ptr %49, align 8
  %50 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 2
  store i64 0, ptr %50, align 8
  %str.len36 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 0
  %len37 = load i64, ptr %str.len36, align 8
  %str.len38 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 0
  %len39 = load i64, ptr %str.len38, align 8
  %51 = add i64 %len37, %len39
  %52 = add i64 %51, 1
  %cat.buf40 = call ptr @__polaron_malloc(i64 %52)
  %str.data41 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  %data42 = load ptr, ptr %str.data41, align 8
  %53 = call ptr @memcpy(ptr %cat.buf40, ptr %data42, i64 %len37)
  %str.data43 = getelementptr inbounds %String, ptr %newstr35, i32 0, i32 1
  %data44 = load ptr, ptr %str.data43, align 8
  %54 = getelementptr i8, ptr %cat.buf40, i64 %len37
  %55 = call ptr @memcpy(ptr %54, ptr %data44, i64 %len39)
  %56 = getelementptr i8, ptr %cat.buf40, i64 %51
  store i8 0, ptr %56, align 1
  %newstr45 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %57 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 0
  store i64 %51, ptr %57, align 8
  %58 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 1
  store ptr %cat.buf40, ptr %58, align 8
  %59 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 2
  store i64 0, ptr %59, align 8
  %str.len46 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 0
  %len47 = load i64, ptr %str.len46, align 8
  %len48 = load i64, ptr @.strobj.6, align 8
  %60 = add i64 %len47, %len48
  %61 = add i64 %60, 1
  %cat.buf49 = call ptr @__polaron_malloc(i64 %61)
  %str.data50 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 1
  %data51 = load ptr, ptr %str.data50, align 8
  %62 = call ptr @memcpy(ptr %cat.buf49, ptr %data51, i64 %len47)
  %data52 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %63 = getelementptr i8, ptr %cat.buf49, i64 %len47
  %64 = call ptr @memcpy(ptr %63, ptr %data52, i64 %len48)
  %65 = getelementptr i8, ptr %cat.buf49, i64 %60
  store i8 0, ptr %65, align 1
  %newstr53 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %66 = getelementptr inbounds %String, ptr %newstr53, i32 0, i32 0
  store i64 %60, ptr %66, align 8
  %67 = getelementptr inbounds %String, ptr %newstr53, i32 0, i32 1
  store ptr %cat.buf49, ptr %67, align 8
  %68 = getelementptr inbounds %String, ptr %newstr53, i32 0, i32 2
  store i64 0, ptr %68, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr53)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr4)
  call void @__polaron_str_free(ptr %newstr12)
  call void @__polaron_str_free(ptr %newstr14)
  call void @__polaron_str_free(ptr %newstr24)
  call void @__polaron_str_free(ptr %newstr32)
  call void @__polaron_str_free(ptr %newstr35)
  call void @__polaron_str_free(ptr %newstr45)
  call void @__polaron_str_free(ptr %newstr53)
  ret ptr %strcpy
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %f = alloca float, align 4
  %s = alloca ptr, align 8
  %Sample.obj = alloca %class.Sample, align 8
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
  call void @Sample.Sample(ptr %Sample.obj, i32 3, float 1.500000e+00, double 2.250000e+00)
  store ptr %Sample.obj, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %16 = call ptr @Sample.toString(ptr %s1)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %17 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %16)
  store float 5.000000e-01, ptr %f, align 4
  %f2 = load float, ptr %f, align 4
  %18 = fpext float %f2 to double
  %ftoa.buf = call ptr @__polaron_malloc(i64 32)
  %19 = call i64 @__polaron_ftoa(double %18, ptr %ftoa.buf)
  %newstr3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %20 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 0
  store i64 %19, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 1
  store ptr %ftoa.buf, ptr %21, align 8
  %22 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 2
  store i64 0, ptr %22, align 8
  %str.data4 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 1
  %data5 = load ptr, ptr %str.data4, align 8
  %23 = call i32 (ptr, ...) @printf(ptr @.str.7, ptr %data5)
  call void @__polaron_str_free(ptr %newstr3)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5315)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5317)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @memcpy(ptr, ptr, i64)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @__polaron_itoa(i64, ptr)

declare i64 @__polaron_ftoa(double, ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"f32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"f64", !2, i64 0}
