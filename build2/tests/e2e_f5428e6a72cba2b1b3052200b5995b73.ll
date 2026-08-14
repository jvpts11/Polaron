; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/named_args.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/named_args.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [3 x i8] c"a=\00"
@.strobj = private global %String { i64 2, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c" b=\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [4 x i8] c" c=\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [4 x i8] c" d=\00"
@.strobj.6 = private global %String { i64 3, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [4 x i8] c" e=\00"
@.strobj.8 = private global %String { i64 3, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [4 x i8] c" f=\00"
@.strobj.10 = private global %String { i64 3, ptr @.strdata.9, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }

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
  %f = alloca i32, align 4
  %e = alloca i32, align 4
  %d = alloca i32, align 4
  %c = alloca i32, align 4
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
  %16 = call i32 @Speaker.describe(i32 5, i32 2)
  store i32 %16, ptr %a, align 4
  %17 = call i32 @Speaker.describe(i32 5, i32 2)
  store i32 %17, ptr %b, align 4
  %18 = call i32 @Speaker.describe(i32 5, i32 2)
  store i32 %18, ptr %c, align 4
  %19 = call i32 @Speaker.describe(i32 5, i32 2)
  store i32 %19, ptr %d, align 4
  %20 = call i32 @Speaker.configure(i32 5, i32 2, i32 1)
  store i32 %20, ptr %e, align 4
  %21 = call i32 @Speaker.configure(i32 5, i32 2, i32 0)
  store i32 %21, ptr %f, align 4
  %a1 = load i32, ptr %a, align 4
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %22 = sext i32 %a1 to i64
  %23 = call i64 @__polaron_itoa(i64 %22, ptr %itoa.buf)
  %newstr2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %24 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 0
  store i64 %23, ptr %24, align 8
  %25 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 1
  store ptr %itoa.buf, ptr %25, align 8
  %26 = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 2
  store i64 0, ptr %26, align 8
  %len = load i64, ptr @.strobj, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 0
  %len3 = load i64, ptr %str.len, align 8
  %27 = add i64 %len, %len3
  %28 = add i64 %27, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %28)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %29 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %newstr2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data, align 8
  %30 = getelementptr i8, ptr %cat.buf, i64 %len
  %31 = call ptr @memcpy(ptr %30, ptr %data4, i64 %len3)
  %32 = getelementptr i8, ptr %cat.buf, i64 %27
  store i8 0, ptr %32, align 1
  %newstr5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %33 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 0
  store i64 %27, ptr %33, align 8
  %34 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 1
  store ptr %cat.buf, ptr %34, align 8
  %35 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 2
  store i64 0, ptr %35, align 8
  %str.len6 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 0
  %len7 = load i64, ptr %str.len6, align 8
  %len8 = load i64, ptr @.strobj.2, align 8
  %36 = add i64 %len7, %len8
  %37 = add i64 %36, 1
  %cat.buf9 = call ptr @__polaron_malloc(i64 %37)
  %str.data10 = getelementptr inbounds %String, ptr %newstr5, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %38 = call ptr @memcpy(ptr %cat.buf9, ptr %data11, i64 %len7)
  %data12 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %39 = getelementptr i8, ptr %cat.buf9, i64 %len7
  %40 = call ptr @memcpy(ptr %39, ptr %data12, i64 %len8)
  %41 = getelementptr i8, ptr %cat.buf9, i64 %36
  store i8 0, ptr %41, align 1
  %newstr13 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %42 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 0
  store i64 %36, ptr %42, align 8
  %43 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 1
  store ptr %cat.buf9, ptr %43, align 8
  %44 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 2
  store i64 0, ptr %44, align 8
  %b14 = load i32, ptr %b, align 4
  %itoa.buf15 = call ptr @__polaron_malloc(i64 24)
  %45 = sext i32 %b14 to i64
  %46 = call i64 @__polaron_itoa(i64 %45, ptr %itoa.buf15)
  %newstr16 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %47 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  store i64 %46, ptr %47, align 8
  %48 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  store ptr %itoa.buf15, ptr %48, align 8
  %49 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 2
  store i64 0, ptr %49, align 8
  %str.len17 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  %str.len19 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 0
  %len20 = load i64, ptr %str.len19, align 8
  %50 = add i64 %len18, %len20
  %51 = add i64 %50, 1
  %cat.buf21 = call ptr @__polaron_malloc(i64 %51)
  %str.data22 = getelementptr inbounds %String, ptr %newstr13, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %52 = call ptr @memcpy(ptr %cat.buf21, ptr %data23, i64 %len18)
  %str.data24 = getelementptr inbounds %String, ptr %newstr16, i32 0, i32 1
  %data25 = load ptr, ptr %str.data24, align 8
  %53 = getelementptr i8, ptr %cat.buf21, i64 %len18
  %54 = call ptr @memcpy(ptr %53, ptr %data25, i64 %len20)
  %55 = getelementptr i8, ptr %cat.buf21, i64 %50
  store i8 0, ptr %55, align 1
  %newstr26 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %56 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 0
  store i64 %50, ptr %56, align 8
  %57 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 1
  store ptr %cat.buf21, ptr %57, align 8
  %58 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 2
  store i64 0, ptr %58, align 8
  %str.len27 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 0
  %len28 = load i64, ptr %str.len27, align 8
  %len29 = load i64, ptr @.strobj.4, align 8
  %59 = add i64 %len28, %len29
  %60 = add i64 %59, 1
  %cat.buf30 = call ptr @__polaron_malloc(i64 %60)
  %str.data31 = getelementptr inbounds %String, ptr %newstr26, i32 0, i32 1
  %data32 = load ptr, ptr %str.data31, align 8
  %61 = call ptr @memcpy(ptr %cat.buf30, ptr %data32, i64 %len28)
  %data33 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %62 = getelementptr i8, ptr %cat.buf30, i64 %len28
  %63 = call ptr @memcpy(ptr %62, ptr %data33, i64 %len29)
  %64 = getelementptr i8, ptr %cat.buf30, i64 %59
  store i8 0, ptr %64, align 1
  %newstr34 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %65 = getelementptr inbounds %String, ptr %newstr34, i32 0, i32 0
  store i64 %59, ptr %65, align 8
  %66 = getelementptr inbounds %String, ptr %newstr34, i32 0, i32 1
  store ptr %cat.buf30, ptr %66, align 8
  %67 = getelementptr inbounds %String, ptr %newstr34, i32 0, i32 2
  store i64 0, ptr %67, align 8
  %c35 = load i32, ptr %c, align 4
  %itoa.buf36 = call ptr @__polaron_malloc(i64 24)
  %68 = sext i32 %c35 to i64
  %69 = call i64 @__polaron_itoa(i64 %68, ptr %itoa.buf36)
  %newstr37 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %70 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 0
  store i64 %69, ptr %70, align 8
  %71 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 1
  store ptr %itoa.buf36, ptr %71, align 8
  %72 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 2
  store i64 0, ptr %72, align 8
  %str.len38 = getelementptr inbounds %String, ptr %newstr34, i32 0, i32 0
  %len39 = load i64, ptr %str.len38, align 8
  %str.len40 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 0
  %len41 = load i64, ptr %str.len40, align 8
  %73 = add i64 %len39, %len41
  %74 = add i64 %73, 1
  %cat.buf42 = call ptr @__polaron_malloc(i64 %74)
  %str.data43 = getelementptr inbounds %String, ptr %newstr34, i32 0, i32 1
  %data44 = load ptr, ptr %str.data43, align 8
  %75 = call ptr @memcpy(ptr %cat.buf42, ptr %data44, i64 %len39)
  %str.data45 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 1
  %data46 = load ptr, ptr %str.data45, align 8
  %76 = getelementptr i8, ptr %cat.buf42, i64 %len39
  %77 = call ptr @memcpy(ptr %76, ptr %data46, i64 %len41)
  %78 = getelementptr i8, ptr %cat.buf42, i64 %73
  store i8 0, ptr %78, align 1
  %newstr47 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %79 = getelementptr inbounds %String, ptr %newstr47, i32 0, i32 0
  store i64 %73, ptr %79, align 8
  %80 = getelementptr inbounds %String, ptr %newstr47, i32 0, i32 1
  store ptr %cat.buf42, ptr %80, align 8
  %81 = getelementptr inbounds %String, ptr %newstr47, i32 0, i32 2
  store i64 0, ptr %81, align 8
  %str.len48 = getelementptr inbounds %String, ptr %newstr47, i32 0, i32 0
  %len49 = load i64, ptr %str.len48, align 8
  %len50 = load i64, ptr @.strobj.6, align 8
  %82 = add i64 %len49, %len50
  %83 = add i64 %82, 1
  %cat.buf51 = call ptr @__polaron_malloc(i64 %83)
  %str.data52 = getelementptr inbounds %String, ptr %newstr47, i32 0, i32 1
  %data53 = load ptr, ptr %str.data52, align 8
  %84 = call ptr @memcpy(ptr %cat.buf51, ptr %data53, i64 %len49)
  %data54 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %85 = getelementptr i8, ptr %cat.buf51, i64 %len49
  %86 = call ptr @memcpy(ptr %85, ptr %data54, i64 %len50)
  %87 = getelementptr i8, ptr %cat.buf51, i64 %82
  store i8 0, ptr %87, align 1
  %newstr55 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %88 = getelementptr inbounds %String, ptr %newstr55, i32 0, i32 0
  store i64 %82, ptr %88, align 8
  %89 = getelementptr inbounds %String, ptr %newstr55, i32 0, i32 1
  store ptr %cat.buf51, ptr %89, align 8
  %90 = getelementptr inbounds %String, ptr %newstr55, i32 0, i32 2
  store i64 0, ptr %90, align 8
  %d56 = load i32, ptr %d, align 4
  %itoa.buf57 = call ptr @__polaron_malloc(i64 24)
  %91 = sext i32 %d56 to i64
  %92 = call i64 @__polaron_itoa(i64 %91, ptr %itoa.buf57)
  %newstr58 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %93 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 0
  store i64 %92, ptr %93, align 8
  %94 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 1
  store ptr %itoa.buf57, ptr %94, align 8
  %95 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 2
  store i64 0, ptr %95, align 8
  %str.len59 = getelementptr inbounds %String, ptr %newstr55, i32 0, i32 0
  %len60 = load i64, ptr %str.len59, align 8
  %str.len61 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 0
  %len62 = load i64, ptr %str.len61, align 8
  %96 = add i64 %len60, %len62
  %97 = add i64 %96, 1
  %cat.buf63 = call ptr @__polaron_malloc(i64 %97)
  %str.data64 = getelementptr inbounds %String, ptr %newstr55, i32 0, i32 1
  %data65 = load ptr, ptr %str.data64, align 8
  %98 = call ptr @memcpy(ptr %cat.buf63, ptr %data65, i64 %len60)
  %str.data66 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 1
  %data67 = load ptr, ptr %str.data66, align 8
  %99 = getelementptr i8, ptr %cat.buf63, i64 %len60
  %100 = call ptr @memcpy(ptr %99, ptr %data67, i64 %len62)
  %101 = getelementptr i8, ptr %cat.buf63, i64 %96
  store i8 0, ptr %101, align 1
  %newstr68 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %102 = getelementptr inbounds %String, ptr %newstr68, i32 0, i32 0
  store i64 %96, ptr %102, align 8
  %103 = getelementptr inbounds %String, ptr %newstr68, i32 0, i32 1
  store ptr %cat.buf63, ptr %103, align 8
  %104 = getelementptr inbounds %String, ptr %newstr68, i32 0, i32 2
  store i64 0, ptr %104, align 8
  %str.len69 = getelementptr inbounds %String, ptr %newstr68, i32 0, i32 0
  %len70 = load i64, ptr %str.len69, align 8
  %len71 = load i64, ptr @.strobj.8, align 8
  %105 = add i64 %len70, %len71
  %106 = add i64 %105, 1
  %cat.buf72 = call ptr @__polaron_malloc(i64 %106)
  %str.data73 = getelementptr inbounds %String, ptr %newstr68, i32 0, i32 1
  %data74 = load ptr, ptr %str.data73, align 8
  %107 = call ptr @memcpy(ptr %cat.buf72, ptr %data74, i64 %len70)
  %data75 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.8, i32 0, i32 1), align 8
  %108 = getelementptr i8, ptr %cat.buf72, i64 %len70
  %109 = call ptr @memcpy(ptr %108, ptr %data75, i64 %len71)
  %110 = getelementptr i8, ptr %cat.buf72, i64 %105
  store i8 0, ptr %110, align 1
  %newstr76 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %111 = getelementptr inbounds %String, ptr %newstr76, i32 0, i32 0
  store i64 %105, ptr %111, align 8
  %112 = getelementptr inbounds %String, ptr %newstr76, i32 0, i32 1
  store ptr %cat.buf72, ptr %112, align 8
  %113 = getelementptr inbounds %String, ptr %newstr76, i32 0, i32 2
  store i64 0, ptr %113, align 8
  %e77 = load i32, ptr %e, align 4
  %itoa.buf78 = call ptr @__polaron_malloc(i64 24)
  %114 = sext i32 %e77 to i64
  %115 = call i64 @__polaron_itoa(i64 %114, ptr %itoa.buf78)
  %newstr79 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %116 = getelementptr inbounds %String, ptr %newstr79, i32 0, i32 0
  store i64 %115, ptr %116, align 8
  %117 = getelementptr inbounds %String, ptr %newstr79, i32 0, i32 1
  store ptr %itoa.buf78, ptr %117, align 8
  %118 = getelementptr inbounds %String, ptr %newstr79, i32 0, i32 2
  store i64 0, ptr %118, align 8
  %str.len80 = getelementptr inbounds %String, ptr %newstr76, i32 0, i32 0
  %len81 = load i64, ptr %str.len80, align 8
  %str.len82 = getelementptr inbounds %String, ptr %newstr79, i32 0, i32 0
  %len83 = load i64, ptr %str.len82, align 8
  %119 = add i64 %len81, %len83
  %120 = add i64 %119, 1
  %cat.buf84 = call ptr @__polaron_malloc(i64 %120)
  %str.data85 = getelementptr inbounds %String, ptr %newstr76, i32 0, i32 1
  %data86 = load ptr, ptr %str.data85, align 8
  %121 = call ptr @memcpy(ptr %cat.buf84, ptr %data86, i64 %len81)
  %str.data87 = getelementptr inbounds %String, ptr %newstr79, i32 0, i32 1
  %data88 = load ptr, ptr %str.data87, align 8
  %122 = getelementptr i8, ptr %cat.buf84, i64 %len81
  %123 = call ptr @memcpy(ptr %122, ptr %data88, i64 %len83)
  %124 = getelementptr i8, ptr %cat.buf84, i64 %119
  store i8 0, ptr %124, align 1
  %newstr89 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %125 = getelementptr inbounds %String, ptr %newstr89, i32 0, i32 0
  store i64 %119, ptr %125, align 8
  %126 = getelementptr inbounds %String, ptr %newstr89, i32 0, i32 1
  store ptr %cat.buf84, ptr %126, align 8
  %127 = getelementptr inbounds %String, ptr %newstr89, i32 0, i32 2
  store i64 0, ptr %127, align 8
  %str.len90 = getelementptr inbounds %String, ptr %newstr89, i32 0, i32 0
  %len91 = load i64, ptr %str.len90, align 8
  %len92 = load i64, ptr @.strobj.10, align 8
  %128 = add i64 %len91, %len92
  %129 = add i64 %128, 1
  %cat.buf93 = call ptr @__polaron_malloc(i64 %129)
  %str.data94 = getelementptr inbounds %String, ptr %newstr89, i32 0, i32 1
  %data95 = load ptr, ptr %str.data94, align 8
  %130 = call ptr @memcpy(ptr %cat.buf93, ptr %data95, i64 %len91)
  %data96 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.10, i32 0, i32 1), align 8
  %131 = getelementptr i8, ptr %cat.buf93, i64 %len91
  %132 = call ptr @memcpy(ptr %131, ptr %data96, i64 %len92)
  %133 = getelementptr i8, ptr %cat.buf93, i64 %128
  store i8 0, ptr %133, align 1
  %newstr97 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %134 = getelementptr inbounds %String, ptr %newstr97, i32 0, i32 0
  store i64 %128, ptr %134, align 8
  %135 = getelementptr inbounds %String, ptr %newstr97, i32 0, i32 1
  store ptr %cat.buf93, ptr %135, align 8
  %136 = getelementptr inbounds %String, ptr %newstr97, i32 0, i32 2
  store i64 0, ptr %136, align 8
  %f98 = load i32, ptr %f, align 4
  %itoa.buf99 = call ptr @__polaron_malloc(i64 24)
  %137 = sext i32 %f98 to i64
  %138 = call i64 @__polaron_itoa(i64 %137, ptr %itoa.buf99)
  %newstr100 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %139 = getelementptr inbounds %String, ptr %newstr100, i32 0, i32 0
  store i64 %138, ptr %139, align 8
  %140 = getelementptr inbounds %String, ptr %newstr100, i32 0, i32 1
  store ptr %itoa.buf99, ptr %140, align 8
  %141 = getelementptr inbounds %String, ptr %newstr100, i32 0, i32 2
  store i64 0, ptr %141, align 8
  %str.len101 = getelementptr inbounds %String, ptr %newstr97, i32 0, i32 0
  %len102 = load i64, ptr %str.len101, align 8
  %str.len103 = getelementptr inbounds %String, ptr %newstr100, i32 0, i32 0
  %len104 = load i64, ptr %str.len103, align 8
  %142 = add i64 %len102, %len104
  %143 = add i64 %142, 1
  %cat.buf105 = call ptr @__polaron_malloc(i64 %143)
  %str.data106 = getelementptr inbounds %String, ptr %newstr97, i32 0, i32 1
  %data107 = load ptr, ptr %str.data106, align 8
  %144 = call ptr @memcpy(ptr %cat.buf105, ptr %data107, i64 %len102)
  %str.data108 = getelementptr inbounds %String, ptr %newstr100, i32 0, i32 1
  %data109 = load ptr, ptr %str.data108, align 8
  %145 = getelementptr i8, ptr %cat.buf105, i64 %len102
  %146 = call ptr @memcpy(ptr %145, ptr %data109, i64 %len104)
  %147 = getelementptr i8, ptr %cat.buf105, i64 %142
  store i8 0, ptr %147, align 1
  %newstr110 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %148 = getelementptr inbounds %String, ptr %newstr110, i32 0, i32 0
  store i64 %142, ptr %148, align 8
  %149 = getelementptr inbounds %String, ptr %newstr110, i32 0, i32 1
  store ptr %cat.buf105, ptr %149, align 8
  %150 = getelementptr inbounds %String, ptr %newstr110, i32 0, i32 2
  store i64 0, ptr %150, align 8
  %str.data111 = getelementptr inbounds %String, ptr %newstr110, i32 0, i32 1
  %data112 = load ptr, ptr %str.data111, align 8
  %151 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data112)
  call void @__polaron_str_free(ptr %newstr2)
  call void @__polaron_str_free(ptr %newstr5)
  call void @__polaron_str_free(ptr %newstr13)
  call void @__polaron_str_free(ptr %newstr16)
  call void @__polaron_str_free(ptr %newstr26)
  call void @__polaron_str_free(ptr %newstr34)
  call void @__polaron_str_free(ptr %newstr37)
  call void @__polaron_str_free(ptr %newstr47)
  call void @__polaron_str_free(ptr %newstr55)
  call void @__polaron_str_free(ptr %newstr58)
  call void @__polaron_str_free(ptr %newstr68)
  call void @__polaron_str_free(ptr %newstr76)
  call void @__polaron_str_free(ptr %newstr79)
  call void @__polaron_str_free(ptr %newstr89)
  call void @__polaron_str_free(ptr %newstr97)
  call void @__polaron_str_free(ptr %newstr100)
  call void @__polaron_str_free(ptr %newstr110)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5320)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i64 @__polaron_itoa(i64, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
