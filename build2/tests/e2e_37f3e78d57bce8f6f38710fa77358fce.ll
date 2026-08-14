; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/decimal_math.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/decimal_math.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [2 x i8] c" \00"
@.strobj = private global %String { i64 1, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [2 x i8] c" \00"
@.strobj.2 = private global %String { i64 1, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c" \00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %neg = alloca i128, align 16
  %out = alloca ptr, align 8
  %b = alloca i128, align 16
  %a = alloca i128, align 16
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
  store i128 1500000000000000000, ptr %a, align 16
  store i128 300000000000000000, ptr %b, align 16
  %a1 = load i128, ptr %a, align 16
  %b2 = load i128, ptr %b, align 16
  %16 = add i128 %a1, %b2
  %17 = icmp slt i128 %16, 0
  %18 = sub i128 0, %16
  %19 = select i1 %17, i128 %18, i128 %16
  %20 = sdiv i128 %19, 1000000000000000000
  %21 = trunc i128 %20 to i64
  %22 = srem i128 %19, 1000000000000000000
  %23 = trunc i128 %22 to i64
  %dbuf = call ptr @__polaron_malloc(i64 64)
  %24 = zext i1 %17 to i32
  %25 = call i64 @__polaron_decimal_str(i32 %24, i64 %21, i64 %23, ptr %dbuf)
  %newstr3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %26 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 0
  store i64 %25, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 1
  store ptr %dbuf, ptr %27, align 8
  %28 = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 2
  store i64 0, ptr %28, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len4 = load i64, ptr @.strobj, align 8
  %29 = add i64 %len, %len4
  %30 = add i64 %29, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %30)
  %str.data = getelementptr inbounds %String, ptr %newstr3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %31 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data5 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %32 = getelementptr i8, ptr %cat.buf, i64 %len
  %33 = call ptr @memcpy(ptr %32, ptr %data5, i64 %len4)
  %34 = getelementptr i8, ptr %cat.buf, i64 %29
  store i8 0, ptr %34, align 1
  %newstr6 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr6, i32 0, i32 0
  store i64 %29, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr6, i32 0, i32 1
  store ptr %cat.buf, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr6, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %a7 = load i128, ptr %a, align 16
  %b8 = load i128, ptr %b, align 16
  %38 = sext i128 %b8 to i256
  %39 = sext i128 %a7 to i256
  %40 = mul i256 %39, %38
  %41 = sdiv i256 %40, 1000000000000000000
  %42 = trunc i256 %41 to i128
  %43 = icmp slt i128 %42, 0
  %44 = sub i128 0, %42
  %45 = select i1 %43, i128 %44, i128 %42
  %46 = sdiv i128 %45, 1000000000000000000
  %47 = trunc i128 %46 to i64
  %48 = srem i128 %45, 1000000000000000000
  %49 = trunc i128 %48 to i64
  %dbuf9 = call ptr @__polaron_malloc(i64 64)
  %50 = zext i1 %43 to i32
  %51 = call i64 @__polaron_decimal_str(i32 %50, i64 %47, i64 %49, ptr %dbuf9)
  %newstr10 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %52 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 0
  store i64 %51, ptr %52, align 8
  %53 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 1
  store ptr %dbuf9, ptr %53, align 8
  %54 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 2
  store i64 0, ptr %54, align 8
  %str.len11 = getelementptr inbounds %String, ptr %newstr6, i32 0, i32 0
  %len12 = load i64, ptr %str.len11, align 8
  %str.len13 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 0
  %len14 = load i64, ptr %str.len13, align 8
  %55 = add i64 %len12, %len14
  %56 = add i64 %55, 1
  %cat.buf15 = call ptr @__polaron_malloc(i64 %56)
  %str.data16 = getelementptr inbounds %String, ptr %newstr6, i32 0, i32 1
  %data17 = load ptr, ptr %str.data16, align 8
  %57 = call ptr @memcpy(ptr %cat.buf15, ptr %data17, i64 %len12)
  %str.data18 = getelementptr inbounds %String, ptr %newstr10, i32 0, i32 1
  %data19 = load ptr, ptr %str.data18, align 8
  %58 = getelementptr i8, ptr %cat.buf15, i64 %len12
  %59 = call ptr @memcpy(ptr %58, ptr %data19, i64 %len14)
  %60 = getelementptr i8, ptr %cat.buf15, i64 %55
  store i8 0, ptr %60, align 1
  %newstr20 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %61 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 0
  store i64 %55, ptr %61, align 8
  %62 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 1
  store ptr %cat.buf15, ptr %62, align 8
  %63 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 2
  store i64 0, ptr %63, align 8
  %str.len21 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 0
  %len22 = load i64, ptr %str.len21, align 8
  %len23 = load i64, ptr @.strobj.2, align 8
  %64 = add i64 %len22, %len23
  %65 = add i64 %64, 1
  %cat.buf24 = call ptr @__polaron_malloc(i64 %65)
  %str.data25 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 1
  %data26 = load ptr, ptr %str.data25, align 8
  %66 = call ptr @memcpy(ptr %cat.buf24, ptr %data26, i64 %len22)
  %data27 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %67 = getelementptr i8, ptr %cat.buf24, i64 %len22
  %68 = call ptr @memcpy(ptr %67, ptr %data27, i64 %len23)
  %69 = getelementptr i8, ptr %cat.buf24, i64 %64
  store i8 0, ptr %69, align 1
  %newstr28 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %70 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 0
  store i64 %64, ptr %70, align 8
  %71 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 1
  store ptr %cat.buf24, ptr %71, align 8
  %72 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 2
  store i64 0, ptr %72, align 8
  %a29 = load i128, ptr %a, align 16
  %b30 = load i128, ptr %b, align 16
  %73 = sub i128 %a29, %b30
  %74 = icmp slt i128 %73, 0
  %75 = sub i128 0, %73
  %76 = select i1 %74, i128 %75, i128 %73
  %77 = sdiv i128 %76, 1000000000000000000
  %78 = trunc i128 %77 to i64
  %79 = srem i128 %76, 1000000000000000000
  %80 = trunc i128 %79 to i64
  %dbuf31 = call ptr @__polaron_malloc(i64 64)
  %81 = zext i1 %74 to i32
  %82 = call i64 @__polaron_decimal_str(i32 %81, i64 %78, i64 %80, ptr %dbuf31)
  %newstr32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %83 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 0
  store i64 %82, ptr %83, align 8
  %84 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  store ptr %dbuf31, ptr %84, align 8
  %85 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 2
  store i64 0, ptr %85, align 8
  %str.len33 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 0
  %len34 = load i64, ptr %str.len33, align 8
  %str.len35 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 0
  %len36 = load i64, ptr %str.len35, align 8
  %86 = add i64 %len34, %len36
  %87 = add i64 %86, 1
  %cat.buf37 = call ptr @__polaron_malloc(i64 %87)
  %str.data38 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 1
  %data39 = load ptr, ptr %str.data38, align 8
  %88 = call ptr @memcpy(ptr %cat.buf37, ptr %data39, i64 %len34)
  %str.data40 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  %data41 = load ptr, ptr %str.data40, align 8
  %89 = getelementptr i8, ptr %cat.buf37, i64 %len34
  %90 = call ptr @memcpy(ptr %89, ptr %data41, i64 %len36)
  %91 = getelementptr i8, ptr %cat.buf37, i64 %86
  store i8 0, ptr %91, align 1
  %newstr42 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %92 = getelementptr inbounds %String, ptr %newstr42, i32 0, i32 0
  store i64 %86, ptr %92, align 8
  %93 = getelementptr inbounds %String, ptr %newstr42, i32 0, i32 1
  store ptr %cat.buf37, ptr %93, align 8
  %94 = getelementptr inbounds %String, ptr %newstr42, i32 0, i32 2
  store i64 0, ptr %94, align 8
  %str.len43 = getelementptr inbounds %String, ptr %newstr42, i32 0, i32 0
  %len44 = load i64, ptr %str.len43, align 8
  %len45 = load i64, ptr @.strobj.4, align 8
  %95 = add i64 %len44, %len45
  %96 = add i64 %95, 1
  %cat.buf46 = call ptr @__polaron_malloc(i64 %96)
  %str.data47 = getelementptr inbounds %String, ptr %newstr42, i32 0, i32 1
  %data48 = load ptr, ptr %str.data47, align 8
  %97 = call ptr @memcpy(ptr %cat.buf46, ptr %data48, i64 %len44)
  %data49 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %98 = getelementptr i8, ptr %cat.buf46, i64 %len44
  %99 = call ptr @memcpy(ptr %98, ptr %data49, i64 %len45)
  %100 = getelementptr i8, ptr %cat.buf46, i64 %95
  store i8 0, ptr %100, align 1
  %newstr50 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %101 = getelementptr inbounds %String, ptr %newstr50, i32 0, i32 0
  store i64 %95, ptr %101, align 8
  %102 = getelementptr inbounds %String, ptr %newstr50, i32 0, i32 1
  store ptr %cat.buf46, ptr %102, align 8
  %103 = getelementptr inbounds %String, ptr %newstr50, i32 0, i32 2
  store i64 0, ptr %103, align 8
  %a51 = load i128, ptr %a, align 16
  %b52 = load i128, ptr %b, align 16
  %104 = sext i128 %a51 to i256
  %105 = mul i256 %104, 1000000000000000000
  %106 = sext i128 %b52 to i256
  %107 = sdiv i256 %105, %106
  %108 = trunc i256 %107 to i128
  %109 = icmp slt i128 %108, 0
  %110 = sub i128 0, %108
  %111 = select i1 %109, i128 %110, i128 %108
  %112 = sdiv i128 %111, 1000000000000000000
  %113 = trunc i128 %112 to i64
  %114 = srem i128 %111, 1000000000000000000
  %115 = trunc i128 %114 to i64
  %dbuf53 = call ptr @__polaron_malloc(i64 64)
  %116 = zext i1 %109 to i32
  %117 = call i64 @__polaron_decimal_str(i32 %116, i64 %113, i64 %115, ptr %dbuf53)
  %newstr54 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %118 = getelementptr inbounds %String, ptr %newstr54, i32 0, i32 0
  store i64 %117, ptr %118, align 8
  %119 = getelementptr inbounds %String, ptr %newstr54, i32 0, i32 1
  store ptr %dbuf53, ptr %119, align 8
  %120 = getelementptr inbounds %String, ptr %newstr54, i32 0, i32 2
  store i64 0, ptr %120, align 8
  %str.len55 = getelementptr inbounds %String, ptr %newstr50, i32 0, i32 0
  %len56 = load i64, ptr %str.len55, align 8
  %str.len57 = getelementptr inbounds %String, ptr %newstr54, i32 0, i32 0
  %len58 = load i64, ptr %str.len57, align 8
  %121 = add i64 %len56, %len58
  %122 = add i64 %121, 1
  %cat.buf59 = call ptr @__polaron_malloc(i64 %122)
  %str.data60 = getelementptr inbounds %String, ptr %newstr50, i32 0, i32 1
  %data61 = load ptr, ptr %str.data60, align 8
  %123 = call ptr @memcpy(ptr %cat.buf59, ptr %data61, i64 %len56)
  %str.data62 = getelementptr inbounds %String, ptr %newstr54, i32 0, i32 1
  %data63 = load ptr, ptr %str.data62, align 8
  %124 = getelementptr i8, ptr %cat.buf59, i64 %len56
  %125 = call ptr @memcpy(ptr %124, ptr %data63, i64 %len58)
  %126 = getelementptr i8, ptr %cat.buf59, i64 %121
  store i8 0, ptr %126, align 1
  %newstr64 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %127 = getelementptr inbounds %String, ptr %newstr64, i32 0, i32 0
  store i64 %121, ptr %127, align 8
  %128 = getelementptr inbounds %String, ptr %newstr64, i32 0, i32 1
  store ptr %cat.buf59, ptr %128, align 8
  %129 = getelementptr inbounds %String, ptr %newstr64, i32 0, i32 2
  store i64 0, ptr %129, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr64)
  store ptr %strcpy, ptr %out, align 8
  call void @__polaron_str_free(ptr %newstr3)
  call void @__polaron_str_free(ptr %newstr6)
  call void @__polaron_str_free(ptr %newstr10)
  call void @__polaron_str_free(ptr %newstr20)
  call void @__polaron_str_free(ptr %newstr28)
  call void @__polaron_str_free(ptr %newstr32)
  call void @__polaron_str_free(ptr %newstr42)
  call void @__polaron_str_free(ptr %newstr50)
  call void @__polaron_str_free(ptr %newstr54)
  call void @__polaron_str_free(ptr %newstr64)
  %out65 = load ptr, ptr %out, align 8
  %str.data66 = getelementptr inbounds %String, ptr %out65, i32 0, i32 1
  %data67 = load ptr, ptr %str.data66, align 8
  %130 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data67)
  store i128 -2750000000000000000, ptr %neg, align 16
  %neg68 = load i128, ptr %neg, align 16
  %131 = icmp slt i128 %neg68, 0
  %132 = sub i128 0, %neg68
  %133 = select i1 %131, i128 %132, i128 %neg68
  %134 = sdiv i128 %133, 1000000000000000000
  %135 = trunc i128 %134 to i64
  %136 = srem i128 %133, 1000000000000000000
  %137 = trunc i128 %136 to i64
  %dbuf69 = call ptr @__polaron_malloc(i64 64)
  %138 = zext i1 %131 to i32
  %139 = call i64 @__polaron_decimal_str(i32 %138, i64 %135, i64 %137, ptr %dbuf69)
  %newstr70 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %140 = getelementptr inbounds %String, ptr %newstr70, i32 0, i32 0
  store i64 %139, ptr %140, align 8
  %141 = getelementptr inbounds %String, ptr %newstr70, i32 0, i32 1
  store ptr %dbuf69, ptr %141, align 8
  %142 = getelementptr inbounds %String, ptr %newstr70, i32 0, i32 2
  store i64 0, ptr %142, align 8
  %str.data71 = getelementptr inbounds %String, ptr %newstr70, i32 0, i32 1
  %data72 = load ptr, ptr %str.data71, align 8
  %143 = call i32 (ptr, ...) @printf(ptr @.str.5, ptr %data72)
  call void @__polaron_str_free(ptr %newstr70)
  %144 = load ptr, ptr %out, align 8
  call void @__polaron_str_free(ptr %144)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5315)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i64 @__polaron_decimal_str(i32, i64, i64, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)
