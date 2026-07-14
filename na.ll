; ModuleID = 'tests\samples\named_args.ldp3'
source_filename = "tests\\samples\\named_args.ldp3"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@.strdata = private constant [3 x i8] c"a=\00"
@.strobj = private global %String { i64 2, ptr @.strdata, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.2 = private constant [3 x i8] c"b=\00"
@.strobj.3 = private global %String { i64 2, ptr @.strdata.2, i64 0 }
@.str.4 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5 = private constant [3 x i8] c"c=\00"
@.strobj.6 = private global %String { i64 2, ptr @.strdata.5, i64 0 }
@.str.7 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.8 = private constant [3 x i8] c"d=\00"
@.strobj.9 = private global %String { i64 2, ptr @.strdata.8, i64 0 }
@.str.10 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.11 = private constant [3 x i8] c"e=\00"
@.strobj.12 = private global %String { i64 2, ptr @.strdata.11, i64 0 }
@.str.13 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.14 = private constant [3 x i8] c"f=\00"
@.strobj.15 = private global %String { i64 2, ptr @.strdata.14, i64 0 }
@.str.16 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

define internal i32 @Speaker.describe(i32 %0, i32 %1) {
entry:
  %duration = alloca i32, align 4
  %volume = alloca i32, align 4
  store i32 %0, ptr %volume, align 4
  store i32 %1, ptr %duration, align 4
  %volume1 = load i32, ptr %volume, align 4
  %2 = mul i32 %volume1, 100
  %duration2 = load i32, ptr %duration, align 4
  %3 = add i32 %2, %duration2
  ret i32 %3
}

define internal i32 @Speaker.configure(i32 %0, i32 %1, i32 %2) {
entry:
  %r = alloca i32, align 4
  %repeat = alloca i32, align 4
  %duration = alloca i32, align 4
  %volume = alloca i32, align 4
  store i32 %0, ptr %volume, align 4
  store i32 %1, ptr %duration, align 4
  store i32 %2, ptr %repeat, align 4
  store i32 0, ptr %r, align 4
  %repeat1 = load i32, ptr %repeat, align 4
  %3 = icmp ne i32 %repeat1, 0
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, ptr %r, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %volume2 = load i32, ptr %volume, align 4
  %4 = mul i32 %volume2, 100
  %duration3 = load i32, ptr %duration, align 4
  %5 = mul i32 %duration3, 10
  %6 = add i32 %4, %5
  %r4 = load i32, ptr %r, align 4
  %7 = add i32 %6, %r4
  ret i32 %7
}

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
  %argv.arr = call ptr @__ldp3_malloc(i64 %7)
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
  %argv.len = call i64 @strlen(ptr %argv.s)
  %newstr = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %argv.len, ptr %11, align 8
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
  %16 = call i32 @Speaker.describe(i32 5, i32 2)
  %itoa.buf = call ptr @__ldp3_malloc(i64 24)
  %17 = sext i32 %16 to i64
  %18 = call i64 @__ldp3_itoa(i64 %17, ptr %itoa.buf)
  %newstr1 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %19 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 0
  store i64 %18, ptr %19, align 8
  %20 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 1
  store ptr %itoa.buf, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 2
  store i64 0, ptr %21, align 8
  %len = load i64, ptr @.strobj, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 0
  %len2 = load i64, ptr %str.len, align 8
  %22 = add i64 %len, %len2
  %23 = add i64 %22, 1
  %cat.buf = call ptr @__ldp3_malloc(i64 %23)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %24 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %25 = getelementptr i8, ptr %cat.buf, i64 %len
  %str.data = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 1
  %data3 = load ptr, ptr %str.data, align 8
  %26 = call ptr @memcpy(ptr %25, ptr %data3, i64 %len2)
  %27 = getelementptr i8, ptr %cat.buf, i64 %22
  store i8 0, ptr %27, align 1
  %newstr4 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %28 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %22, ptr %28, align 8
  %29 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %cat.buf, ptr %29, align 8
  %30 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %30, align 8
  %str.data5 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %31 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data6)
  %32 = call i32 @Speaker.describe(i32 5, i32 2)
  %itoa.buf7 = call ptr @__ldp3_malloc(i64 24)
  %33 = sext i32 %32 to i64
  %34 = call i64 @__ldp3_itoa(i64 %33, ptr %itoa.buf7)
  %newstr8 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 0
  store i64 %34, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  store ptr %itoa.buf7, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %len9 = load i64, ptr @.strobj.3, align 8
  %str.len10 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 0
  %len11 = load i64, ptr %str.len10, align 8
  %38 = add i64 %len9, %len11
  %39 = add i64 %38, 1
  %cat.buf12 = call ptr @__ldp3_malloc(i64 %39)
  %data13 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.3, i32 0, i32 1), align 8
  %40 = call ptr @memcpy(ptr %cat.buf12, ptr %data13, i64 %len9)
  %41 = getelementptr i8, ptr %cat.buf12, i64 %len9
  %str.data14 = getelementptr inbounds %String, ptr %newstr8, i32 0, i32 1
  %data15 = load ptr, ptr %str.data14, align 8
  %42 = call ptr @memcpy(ptr %41, ptr %data15, i64 %len11)
  %43 = getelementptr i8, ptr %cat.buf12, i64 %38
  store i8 0, ptr %43, align 1
  %newstr16 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %44 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  store i64 %38, ptr %44, align 8
  %45 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  store ptr %cat.buf12, ptr %45, align 8
  %46 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 2
  store i64 0, ptr %46, align 8
  %str.data17 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %47 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr %data18)
  %48 = call i32 @Speaker.describe(i32 5, i32 2)
  %itoa.buf19 = call ptr @__ldp3_malloc(i64 24)
  %49 = sext i32 %48 to i64
  %50 = call i64 @__ldp3_itoa(i64 %49, ptr %itoa.buf19)
  %newstr20 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %51 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 0
  store i64 %50, ptr %51, align 8
  %52 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 1
  store ptr %itoa.buf19, ptr %52, align 8
  %53 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 2
  store i64 0, ptr %53, align 8
  %len21 = load i64, ptr @.strobj.6, align 8
  %str.len22 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 0
  %len23 = load i64, ptr %str.len22, align 8
  %54 = add i64 %len21, %len23
  %55 = add i64 %54, 1
  %cat.buf24 = call ptr @__ldp3_malloc(i64 %55)
  %data25 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %56 = call ptr @memcpy(ptr %cat.buf24, ptr %data25, i64 %len21)
  %57 = getelementptr i8, ptr %cat.buf24, i64 %len21
  %str.data26 = getelementptr inbounds %String, ptr %newstr20, i32 0, i32 1
  %data27 = load ptr, ptr %str.data26, align 8
  %58 = call ptr @memcpy(ptr %57, ptr %data27, i64 %len23)
  %59 = getelementptr i8, ptr %cat.buf24, i64 %54
  store i8 0, ptr %59, align 1
  %newstr28 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %60 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 0
  store i64 %54, ptr %60, align 8
  %61 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 1
  store ptr %cat.buf24, ptr %61, align 8
  %62 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 2
  store i64 0, ptr %62, align 8
  %str.data29 = getelementptr inbounds %String, ptr %newstr28, i32 0, i32 1
  %data30 = load ptr, ptr %str.data29, align 8
  %63 = call i32 (ptr, ...) @printf(ptr @.str.7, ptr %data30)
  %64 = call i32 @Speaker.describe(i32 5, i32 2)
  %itoa.buf31 = call ptr @__ldp3_malloc(i64 24)
  %65 = sext i32 %64 to i64
  %66 = call i64 @__ldp3_itoa(i64 %65, ptr %itoa.buf31)
  %newstr32 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %67 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 0
  store i64 %66, ptr %67, align 8
  %68 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  store ptr %itoa.buf31, ptr %68, align 8
  %69 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 2
  store i64 0, ptr %69, align 8
  %len33 = load i64, ptr @.strobj.9, align 8
  %str.len34 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 0
  %len35 = load i64, ptr %str.len34, align 8
  %70 = add i64 %len33, %len35
  %71 = add i64 %70, 1
  %cat.buf36 = call ptr @__ldp3_malloc(i64 %71)
  %data37 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.9, i32 0, i32 1), align 8
  %72 = call ptr @memcpy(ptr %cat.buf36, ptr %data37, i64 %len33)
  %73 = getelementptr i8, ptr %cat.buf36, i64 %len33
  %str.data38 = getelementptr inbounds %String, ptr %newstr32, i32 0, i32 1
  %data39 = load ptr, ptr %str.data38, align 8
  %74 = call ptr @memcpy(ptr %73, ptr %data39, i64 %len35)
  %75 = getelementptr i8, ptr %cat.buf36, i64 %70
  store i8 0, ptr %75, align 1
  %newstr40 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %76 = getelementptr inbounds %String, ptr %newstr40, i32 0, i32 0
  store i64 %70, ptr %76, align 8
  %77 = getelementptr inbounds %String, ptr %newstr40, i32 0, i32 1
  store ptr %cat.buf36, ptr %77, align 8
  %78 = getelementptr inbounds %String, ptr %newstr40, i32 0, i32 2
  store i64 0, ptr %78, align 8
  %str.data41 = getelementptr inbounds %String, ptr %newstr40, i32 0, i32 1
  %data42 = load ptr, ptr %str.data41, align 8
  %79 = call i32 (ptr, ...) @printf(ptr @.str.10, ptr %data42)
  %80 = call i32 @Speaker.configure(i32 5, i32 2, i32 1)
  %itoa.buf43 = call ptr @__ldp3_malloc(i64 24)
  %81 = sext i32 %80 to i64
  %82 = call i64 @__ldp3_itoa(i64 %81, ptr %itoa.buf43)
  %newstr44 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %83 = getelementptr inbounds %String, ptr %newstr44, i32 0, i32 0
  store i64 %82, ptr %83, align 8
  %84 = getelementptr inbounds %String, ptr %newstr44, i32 0, i32 1
  store ptr %itoa.buf43, ptr %84, align 8
  %85 = getelementptr inbounds %String, ptr %newstr44, i32 0, i32 2
  store i64 0, ptr %85, align 8
  %len45 = load i64, ptr @.strobj.12, align 8
  %str.len46 = getelementptr inbounds %String, ptr %newstr44, i32 0, i32 0
  %len47 = load i64, ptr %str.len46, align 8
  %86 = add i64 %len45, %len47
  %87 = add i64 %86, 1
  %cat.buf48 = call ptr @__ldp3_malloc(i64 %87)
  %data49 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.12, i32 0, i32 1), align 8
  %88 = call ptr @memcpy(ptr %cat.buf48, ptr %data49, i64 %len45)
  %89 = getelementptr i8, ptr %cat.buf48, i64 %len45
  %str.data50 = getelementptr inbounds %String, ptr %newstr44, i32 0, i32 1
  %data51 = load ptr, ptr %str.data50, align 8
  %90 = call ptr @memcpy(ptr %89, ptr %data51, i64 %len47)
  %91 = getelementptr i8, ptr %cat.buf48, i64 %86
  store i8 0, ptr %91, align 1
  %newstr52 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %92 = getelementptr inbounds %String, ptr %newstr52, i32 0, i32 0
  store i64 %86, ptr %92, align 8
  %93 = getelementptr inbounds %String, ptr %newstr52, i32 0, i32 1
  store ptr %cat.buf48, ptr %93, align 8
  %94 = getelementptr inbounds %String, ptr %newstr52, i32 0, i32 2
  store i64 0, ptr %94, align 8
  %str.data53 = getelementptr inbounds %String, ptr %newstr52, i32 0, i32 1
  %data54 = load ptr, ptr %str.data53, align 8
  %95 = call i32 (ptr, ...) @printf(ptr @.str.13, ptr %data54)
  %96 = call i32 @Speaker.configure(i32 5, i32 2, i32 0)
  %itoa.buf55 = call ptr @__ldp3_malloc(i64 24)
  %97 = sext i32 %96 to i64
  %98 = call i64 @__ldp3_itoa(i64 %97, ptr %itoa.buf55)
  %newstr56 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %99 = getelementptr inbounds %String, ptr %newstr56, i32 0, i32 0
  store i64 %98, ptr %99, align 8
  %100 = getelementptr inbounds %String, ptr %newstr56, i32 0, i32 1
  store ptr %itoa.buf55, ptr %100, align 8
  %101 = getelementptr inbounds %String, ptr %newstr56, i32 0, i32 2
  store i64 0, ptr %101, align 8
  %len57 = load i64, ptr @.strobj.15, align 8
  %str.len58 = getelementptr inbounds %String, ptr %newstr56, i32 0, i32 0
  %len59 = load i64, ptr %str.len58, align 8
  %102 = add i64 %len57, %len59
  %103 = add i64 %102, 1
  %cat.buf60 = call ptr @__ldp3_malloc(i64 %103)
  %data61 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.15, i32 0, i32 1), align 8
  %104 = call ptr @memcpy(ptr %cat.buf60, ptr %data61, i64 %len57)
  %105 = getelementptr i8, ptr %cat.buf60, i64 %len57
  %str.data62 = getelementptr inbounds %String, ptr %newstr56, i32 0, i32 1
  %data63 = load ptr, ptr %str.data62, align 8
  %106 = call ptr @memcpy(ptr %105, ptr %data63, i64 %len59)
  %107 = getelementptr i8, ptr %cat.buf60, i64 %102
  store i8 0, ptr %107, align 1
  %newstr64 = call ptr @__ldp3_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %108 = getelementptr inbounds %String, ptr %newstr64, i32 0, i32 0
  store i64 %102, ptr %108, align 8
  %109 = getelementptr inbounds %String, ptr %newstr64, i32 0, i32 1
  store ptr %cat.buf60, ptr %109, align 8
  %110 = getelementptr inbounds %String, ptr %newstr64, i32 0, i32 2
  store i64 0, ptr %110, align 8
  %str.data65 = getelementptr inbounds %String, ptr %newstr64, i32 0, i32 1
  %data66 = load ptr, ptr %str.data65, align 8
  %111 = call i32 (ptr, ...) @printf(ptr @.str.16, ptr %data66)
  ret i32 0
}

declare noalias ptr @__ldp3_malloc(i64)

declare i64 @strlen(ptr)

declare i64 @__ldp3_itoa(i64, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)
