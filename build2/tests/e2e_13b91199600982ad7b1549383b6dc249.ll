; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sealed_enum_permits_body.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sealed_enum_permits_body.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.3 = private unnamed_addr constant [19 x i8] c"n=%d ord=%d sz=%d\0A\00", align 1
@.strdata = private constant [14 x i8] c"it was caught\00"
@.strobj = private global %String { i64 13, ptr @.strdata, i64 0 }
@.strdata.1299 = private constant [12 x i8] c"it got away\00"
@.strobj.1300 = private global %String { i64 11, ptr @.strdata.1299, i64 0 }
@.strdata.1301 = private constant [19 x i8] c"it ran out of food\00"
@.strobj.1302 = private global %String { i64 18, ptr @.strdata.1301, i64 0 }
@.strdata.5314 = private constant [1 x i8] zeroinitializer
@.strobj.5315 = private global %String { i64 0, ptr @.strdata.5314, i64 0 }
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }

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
  %16 = call ptr @Ending.said(i32 0)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %17 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %16)
  %18 = call ptr @Ending.said(i32 1)
  %str.data1 = getelementptr inbounds %String, ptr %18, i32 0, i32 1
  %data2 = load ptr, ptr %str.data1, align 8
  %19 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data2)
  call void @__polaron_str_free(ptr %18)
  %20 = call ptr @Ending.said(i32 2)
  %str.data3 = getelementptr inbounds %String, ptr %20, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %21 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr %data4)
  call void @__polaron_str_free(ptr %20)
  %22 = call i32 (ptr, ...) @printf(ptr @.str.3, i32 3, i32 2, i32 4)
  ret i32 0
}

define internal ptr @Ending.said(i32 %0) {
entry:
  %is = icmp eq i32 %0, 0
  br i1 %is, label %matchx.case, label %matchx.next

matchx.end:                                       ; preds = %matchx.case4, %matchx.case1, %matchx.case
  %matchx = phi ptr [ @.strobj, %matchx.case ], [ @.strobj.1300, %matchx.case1 ], [ @.strobj.1302, %matchx.case4 ]
  %strcpy = call ptr @__polaron_str_copy(ptr %matchx)
  ret ptr %strcpy

matchx.case:                                      ; preds = %entry
  br label %matchx.end

matchx.next:                                      ; preds = %entry
  %is3 = icmp eq i32 %0, 1
  br i1 %is3, label %matchx.case1, label %matchx.next2

matchx.case1:                                     ; preds = %matchx.next
  br label %matchx.end

matchx.next2:                                     ; preds = %matchx.next
  %is6 = icmp eq i32 %0, 2
  br i1 %is6, label %matchx.case4, label %matchx.next5

matchx.case4:                                     ; preds = %matchx.next2
  br label %matchx.end

matchx.next5:                                     ; preds = %matchx.next2
  unreachable
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

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
