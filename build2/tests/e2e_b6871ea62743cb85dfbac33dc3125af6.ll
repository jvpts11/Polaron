; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/paths_windows.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/paths_windows.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.strdata = private constant [6 x i8] c"x/y/z\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c"x/y\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.str = private unnamed_addr constant [29 x i8] c"baseOk=%d dirOk=%d fwdOk=%d\0A\00", align 1
@.strdata.3861 = private constant [1 x i8] zeroinitializer
@.strobj.3862 = private global %String { i64 0, ptr @.strdata.3861, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %fwdOk = alloca i32, align 4
  %dirOk = alloca i32, align 4
  %baseOk = alloca i32, align 4
  %dir = alloca ptr, align 8
  %base = alloca ptr, align 8
  %exe = alloca ptr, align 8
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
  %16 = call ptr @__polaron_executable_path()
  %exe.len = call i64 @strlen(ptr %16)
  %newstr1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 0
  store i64 %exe.len, ptr %17, align 8
  %18 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 1
  store ptr %16, ptr %18, align 8
  %19 = getelementptr inbounds %String, ptr %newstr1, i32 0, i32 2
  store i64 0, ptr %19, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr1)
  store ptr %strcpy, ptr %exe, align 8
  call void @__polaron_str_free(ptr %newstr1)
  %exe2 = load ptr, ptr %exe, align 8
  %20 = call ptr @Paths.basename(ptr %exe2)
  %strcpy3 = call ptr @__polaron_str_copy(ptr %20)
  store ptr %strcpy3, ptr %base, align 8
  call void @__polaron_str_free(ptr %20)
  %exe4 = load ptr, ptr %exe, align 8
  %21 = call ptr @Paths.dirname(ptr %exe4)
  %strcpy5 = call ptr @__polaron_str_copy(ptr %21)
  store ptr %strcpy5, ptr %dir, align 8
  call void @__polaron_str_free(ptr %21)
  %base6 = load ptr, ptr %base, align 8
  %str.len = getelementptr inbounds %String, ptr %base6, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %22 = trunc i64 %len to i32
  %23 = icmp sgt i32 %22, 0
  %24 = zext i1 %23 to i32
  %sc.a = icmp ne i32 %24, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %argv.end
  %base7 = load ptr, ptr %base, align 8
  %str.len8 = getelementptr inbounds %String, ptr %base7, i32 0, i32 0
  %len9 = load i64, ptr %str.len8, align 8
  %25 = trunc i64 %len9 to i32
  %exe10 = load ptr, ptr %exe, align 8
  %str.len11 = getelementptr inbounds %String, ptr %exe10, i32 0, i32 0
  %len12 = load i64, ptr %str.len11, align 8
  %26 = trunc i64 %len12 to i32
  %27 = icmp slt i32 %25, %26
  %28 = zext i1 %27 to i32
  %sc.b = icmp ne i32 %28, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %argv.end
  %sc = phi i1 [ false, %argv.end ], [ %sc.b, %sc.rhs ]
  %29 = zext i1 %sc to i32
  store i32 %29, ptr %baseOk, align 4
  %dir13 = load ptr, ptr %dir, align 8
  %str.len14 = getelementptr inbounds %String, ptr %dir13, i32 0, i32 0
  %len15 = load i64, ptr %str.len14, align 8
  %30 = trunc i64 %len15 to i32
  %31 = icmp sgt i32 %30, 0
  %32 = zext i1 %31 to i32
  %sc.a16 = icmp ne i32 %32, 0
  br i1 %sc.a16, label %sc.rhs17, label %sc.end18

sc.rhs17:                                         ; preds = %sc.end
  %dir19 = load ptr, ptr %dir, align 8
  %str.len20 = getelementptr inbounds %String, ptr %dir19, i32 0, i32 0
  %len21 = load i64, ptr %str.len20, align 8
  %33 = trunc i64 %len21 to i32
  %exe22 = load ptr, ptr %exe, align 8
  %str.len23 = getelementptr inbounds %String, ptr %exe22, i32 0, i32 0
  %len24 = load i64, ptr %str.len23, align 8
  %34 = trunc i64 %len24 to i32
  %35 = icmp slt i32 %33, %34
  %36 = zext i1 %35 to i32
  %sc.b25 = icmp ne i32 %36, 0
  br label %sc.end18

sc.end18:                                         ; preds = %sc.rhs17, %sc.end
  %sc26 = phi i1 [ false, %sc.end ], [ %sc.b25, %sc.rhs17 ]
  %37 = zext i1 %sc26 to i32
  store i32 %37, ptr %dirOk, align 4
  %38 = call ptr @Paths.dirname(ptr @.strobj)
  %str.data = getelementptr inbounds %String, ptr %38, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %data27 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %39 = call i32 @strcmp(ptr %data, ptr %data27)
  %40 = icmp eq i32 %39, 0
  %41 = zext i1 %40 to i32
  store i32 %41, ptr %fwdOk, align 4
  call void @__polaron_str_free(ptr %38)
  %baseOk28 = load i32, ptr %baseOk, align 4
  %tern.c = icmp ne i32 %baseOk28, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %sc.end18
  br label %tern.end

tern.else:                                        ; preds = %sc.end18
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ 1, %tern.then ], [ 0, %tern.else ]
  %dirOk29 = load i32, ptr %dirOk, align 4
  %tern.c30 = icmp ne i32 %dirOk29, 0
  br i1 %tern.c30, label %tern.then31, label %tern.else32

tern.then31:                                      ; preds = %tern.end
  br label %tern.end33

tern.else32:                                      ; preds = %tern.end
  br label %tern.end33

tern.end33:                                       ; preds = %tern.else32, %tern.then31
  %tern34 = phi i32 [ 1, %tern.then31 ], [ 0, %tern.else32 ]
  %fwdOk35 = load i32, ptr %fwdOk, align 4
  %tern.c36 = icmp ne i32 %fwdOk35, 0
  br i1 %tern.c36, label %tern.then37, label %tern.else38

tern.then37:                                      ; preds = %tern.end33
  br label %tern.end39

tern.else38:                                      ; preds = %tern.end33
  br label %tern.end39

tern.end39:                                       ; preds = %tern.else38, %tern.then37
  %tern40 = phi i32 [ 1, %tern.then37 ], [ 0, %tern.else38 ]
  %42 = call i32 (ptr, ...) @printf(ptr @.str, i32 %tern, i32 %tern34, i32 %tern40)
  %43 = load ptr, ptr %dir, align 8
  call void @__polaron_str_free(ptr %43)
  %44 = load ptr, ptr %base, align 8
  call void @__polaron_str_free(ptr %44)
  %45 = load ptr, ptr %exe, align 8
  call void @__polaron_str_free(ptr %45)
  ret i32 0
}

define internal ptr @Paths.basename(ptr %0) {
entry:
  %cut = alloca i32, align 4
  %path = alloca ptr, align 8
  store ptr %0, ptr %path, align 8
  %path1 = load ptr, ptr %path, align 8
  %1 = call i32 @Paths.lastSep(ptr %path1)
  store i32 %1, ptr %cut, align 4
  %cut2 = load i32, ptr %cut, align 4
  %2 = icmp slt i32 %cut2, 0
  %3 = zext i1 %2 to i32
  %tern.c = icmp ne i32 %3, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %entry
  %path3 = load ptr, ptr %path, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %path3)
  br label %tern.end

tern.else:                                        ; preds = %entry
  %path4 = load ptr, ptr %path, align 8
  %cut5 = load i32, ptr %cut, align 4
  %4 = add i32 %cut5, 1
  %5 = sext i32 %4 to i64
  %path6 = load ptr, ptr %path, align 8
  %str.len = getelementptr inbounds %String, ptr %path6, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %6 = trunc i64 %len to i32
  %7 = sext i32 %6 to i64
  %8 = sub i64 %7, %5
  %9 = add i64 %8, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %9)
  %str.data = getelementptr inbounds %String, ptr %path4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %10 = getelementptr i8, ptr %data, i64 %5
  %11 = call ptr @memcpy(ptr %sub.buf, ptr %10, i64 %8)
  %12 = getelementptr i8, ptr %sub.buf, i64 %8
  store i8 0, ptr %12, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %8, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %14, align 8
  %15 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %15, align 8
  %strcpy7 = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi ptr [ %strcpy, %tern.then ], [ %strcpy7, %tern.else ]
  %strcpy8 = call ptr @__polaron_str_copy(ptr %tern)
  call void @__polaron_str_free(ptr %tern)
  ret ptr %strcpy8
}

define internal ptr @Paths.dirname(ptr %0) {
entry:
  %cut = alloca i32, align 4
  %path = alloca ptr, align 8
  store ptr %0, ptr %path, align 8
  %path1 = load ptr, ptr %path, align 8
  %1 = call i32 @Paths.lastSep(ptr %path1)
  store i32 %1, ptr %cut, align 4
  %cut2 = load i32, ptr %cut, align 4
  %2 = icmp slt i32 %cut2, 0
  %3 = zext i1 %2 to i32
  %tern.c = icmp ne i32 %3, 0
  br i1 %tern.c, label %tern.then, label %tern.else

tern.then:                                        ; preds = %entry
  br label %tern.end

tern.else:                                        ; preds = %entry
  %path3 = load ptr, ptr %path, align 8
  %cut4 = load i32, ptr %cut, align 4
  %4 = sext i32 %cut4 to i64
  %5 = sub i64 %4, 0
  %6 = add i64 %5, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %6)
  %str.data = getelementptr inbounds %String, ptr %path3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %7 = getelementptr i8, ptr %data, i64 0
  %8 = call ptr @memcpy(ptr %sub.buf, ptr %7, i64 %5)
  %9 = getelementptr i8, ptr %sub.buf, i64 %5
  store i8 0, ptr %9, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %5, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %11, align 8
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %12, align 8
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi ptr [ @.strobj.3862, %tern.then ], [ %newstr, %tern.else ]
  %strcpy = call ptr @__polaron_str_copy(ptr %tern)
  ret ptr %strcpy
}

define internal i32 @Paths.lastSep(ptr %0) {
entry:
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %last = alloca i32, align 4
  %path = alloca ptr, align 8
  store ptr %0, ptr %path, align 8
  store i32 -1, ptr %last, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %i1 = load i32, ptr %i, align 4
  %path2 = load ptr, ptr %path, align 8
  %str.len = getelementptr inbounds %String, ptr %path2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %path3 = load ptr, ptr %path, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %path3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %c, align 4
  %c5 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %c5, 47
  %7 = zext i1 %6 to i32
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

while.end:                                        ; preds = %while.cond
  %last9 = load i32, ptr %last, align 4
  ret i32 %last9

sc.rhs:                                           ; preds = %while.body
  %c6 = load i32, ptr %c, align 4
  %8 = icmp eq i32 %c6, 92
  %9 = zext i1 %8 to i32
  %sc.b = icmp ne i32 %9, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.body
  %sc = phi i1 [ true, %while.body ], [ %sc.b, %sc.rhs ]
  %10 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %i7 = load i32, ptr %i, align 4
  store i32 %i7, ptr %last, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  %i8 = load i32, ptr %i, align 4
  %11 = add i32 %i8, 1
  store i32 %11, ptr %i, align 4
  br label %while.cond
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_executable_path()

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @strcmp(ptr, ptr)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)
