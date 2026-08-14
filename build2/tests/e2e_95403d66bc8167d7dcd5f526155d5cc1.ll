; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/goto_abstainfrom.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/goto_abstainfrom.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@abstain.Main.run.body = private global i32 0
@.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"body\0A\00", align 1
@.str.2 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"unreachable\0A\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5 = private unnamed_addr constant [12 x i8] c"after goto\0A\00", align 1
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }

define internal void @Main.run(i32 %0) {
entry:
  %mode = alloca i32, align 4
  store i32 %0, ptr %mode, align 4
  %mode1 = load i32, ptr %mode, align 4
  %1 = icmp eq i32 %mode1, 1
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %3 = atomicrmw add ptr @abstain.Main.run.body, i32 1 seq_cst, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %mode2 = load i32, ptr %mode, align 4
  %4 = icmp eq i32 %mode2, 2
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end
  %6 = atomicrmw sub ptr @abstain.Main.run.body, i32 1 seq_cst, align 4
  br label %if.end4

if.end4:                                          ; preds = %if.then3, %if.end
  br label %label.body

label.body:                                       ; preds = %if.end4
  %abstain.c = load atomic i32, ptr @abstain.Main.run.body seq_cst, align 4
  %7 = icmp ne i32 %abstain.c, 0
  br i1 %7, label %label.off, label %label.on

label.on:                                         ; preds = %label.body
  %8 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.1)
  ret void

label.off:                                        ; preds = %label.body
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %x = alloca i32, align 4
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
  store i32 1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %16 = icmp eq i32 %x1, 1
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  br label %label.skip

if.end:                                           ; preds = %argv.end
  %18 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr @.str.3)
  br label %label.skip

label.skip:                                       ; preds = %if.end, %if.then
  %19 = call i32 (ptr, ...) @printf(ptr @.str.4, ptr @.str.5)
  call void @Main.run(i32 0)
  call void @Main.run(i32 1)
  call void @Main.run(i32 0)
  call void @Main.run(i32 2)
  ret i32 0
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5311)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare i32 @printf(ptr, ...)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)
