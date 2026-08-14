; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/subprocess.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/subprocess.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.Subprocess = type { ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Subprocess.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Subprocess.isValid, ptr @Subprocess.write, ptr @Subprocess.read, ptr @Subprocess.isAlive, ptr @Subprocess.canRead, ptr @Subprocess.closeInput, ptr @Subprocess.close, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [5 x i8] c"sort\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"spawn failed\00", align 1
@.strdata.2 = private constant [21 x i8] c"banana\0Aapple\0Acherry\0A\00"
@.strobj.3 = private global %String { i64 20, ptr @.strdata.2, i64 0 }
@.strdata.4 = private constant [1 x i8] zeroinitializer
@.strobj.5 = private global %String { i64 0, ptr @.strdata.4, i64 0 }
@.str.6 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %chunk = alloca ptr, align 8
  %out = alloca ptr, align 8
  %proc = alloca ptr, align 8
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
  %16 = call ptr @Subprocess.start(ptr @.strobj)
  store ptr %16, ptr %proc, align 8
  %proc1 = load ptr, ptr %proc, align 8
  %17 = call i32 @Subprocess.isValid(ptr %proc1)
  %18 = icmp eq i32 %17, 0
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  %20 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.1)
  ret i32 0

if.end:                                           ; preds = %argv.end
  %proc2 = load ptr, ptr %proc, align 8
  %21 = call i32 @Subprocess.write(ptr %proc2, ptr @.strobj.3)
  %proc3 = load ptr, ptr %proc, align 8
  call void @Subprocess.closeInput(ptr %proc3)
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5)
  store ptr %strcpy, ptr %out, align 8
  %proc4 = load ptr, ptr %proc, align 8
  %22 = call ptr @Subprocess.read(ptr %proc4)
  %strcpy5 = call ptr @__polaron_str_copy(ptr %22)
  store ptr %strcpy5, ptr %chunk, align 8
  call void @__polaron_str_free(ptr %22)
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %chunk6 = load ptr, ptr %chunk, align 8
  %str.len = getelementptr inbounds %String, ptr %chunk6, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %23 = trunc i64 %len to i32
  %24 = icmp sgt i32 %23, 0
  %25 = zext i1 %24 to i32
  br i1 %24, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %out7 = load ptr, ptr %out, align 8
  %chunk8 = load ptr, ptr %chunk, align 8
  %str.len9 = getelementptr inbounds %String, ptr %out7, i32 0, i32 0
  %len10 = load i64, ptr %str.len9, align 8
  %str.len11 = getelementptr inbounds %String, ptr %chunk8, i32 0, i32 0
  %len12 = load i64, ptr %str.len11, align 8
  %26 = add i64 %len10, %len12
  %27 = add i64 %26, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %27)
  %str.data = getelementptr inbounds %String, ptr %out7, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %28 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len10)
  %str.data13 = getelementptr inbounds %String, ptr %chunk8, i32 0, i32 1
  %data14 = load ptr, ptr %str.data13, align 8
  %29 = getelementptr i8, ptr %cat.buf, i64 %len10
  %30 = call ptr @memcpy(ptr %29, ptr %data14, i64 %len12)
  %31 = getelementptr i8, ptr %cat.buf, i64 %26
  store i8 0, ptr %31, align 1
  %newstr15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %32 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 0
  store i64 %26, ptr %32, align 8
  %33 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 1
  store ptr %cat.buf, ptr %33, align 8
  %34 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 2
  store i64 0, ptr %34, align 8
  %strcpy16 = call ptr @__polaron_str_copy(ptr %newstr15)
  %35 = load ptr, ptr %out, align 8
  call void @__polaron_str_free(ptr %35)
  store ptr %strcpy16, ptr %out, align 8
  call void @__polaron_str_free(ptr %newstr15)
  %proc17 = load ptr, ptr %proc, align 8
  %36 = call ptr @Subprocess.read(ptr %proc17)
  %strcpy18 = call ptr @__polaron_str_copy(ptr %36)
  %37 = load ptr, ptr %chunk, align 8
  call void @__polaron_str_free(ptr %37)
  store ptr %strcpy18, ptr %chunk, align 8
  call void @__polaron_str_free(ptr %36)
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %proc19 = load ptr, ptr %proc, align 8
  call void @Subprocess.close(ptr %proc19)
  %out20 = load ptr, ptr %out, align 8
  %str.data21 = getelementptr inbounds %String, ptr %out20, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %38 = call i32 (ptr, ...) @printf(ptr @.str.6, ptr %data22)
  %39 = load ptr, ptr %chunk, align 8
  call void @__polaron_str_free(ptr %39)
  %40 = load ptr, ptr %out, align 8
  call void @__polaron_str_free(ptr %40)
  ret i32 0
}

define internal i32 @Object.equals(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal i32 @Object.hashCode(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  ret i32 0
}

define internal i32 @Object.equalsKey(ptr nonnull align 8 dereferenceable(8) %0, ptr %1) {
entry:
  %Object.copy = alloca %class.Object, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Object.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Object, ptr null, i64 1) to i64))
  store ptr %Object.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = icmp eq ptr %0, %other1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal void @Object.Object(ptr %0) {
entry:
  %vtbl.addr = getelementptr inbounds %class.Object, ptr %0, i32 0, i32 0
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @Subprocess.Subprocess(ptr %0, i64 %1) {
entry:
  %h = alloca i64, align 8
  store i64 %1, ptr %h, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 0
  store ptr @Subprocess.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %h1 = load i64, ptr %h, align 8
  store i64 %h1, ptr %handle, align 8, !tbaa !4
  ret void
}

define internal ptr @Subprocess.start(ptr %0) {
entry:
  %command = alloca ptr, align 8
  store ptr %0, ptr %command, align 8
  %Subprocess.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Subprocess, ptr null, i64 1) to i64))
  %command1 = load ptr, ptr %command, align 8
  %str.data = getelementptr inbounds %String, ptr %command1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %1 = call i64 @__polaron_subproc_spawn_ex(ptr %data, i64 0, i64 0)
  call void @Subprocess.Subprocess(ptr %Subprocess.obj, i64 %1)
  ret ptr %Subprocess.obj
}

define internal i32 @Subprocess.isValid(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %1 = icmp ne i64 %handle1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal i32 @Subprocess.write(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %data2 = load ptr, ptr %data, align 8
  %str.data = getelementptr inbounds %String, ptr %data2, i32 0, i32 1
  %data3 = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %data2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = call i64 @__polaron_subproc_write(i64 %handle1, ptr %data3, i64 %len)
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define internal ptr @Subprocess.read(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %sp.len = alloca i64, align 8
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %1 = call ptr @__polaron_subproc_read(i64 %handle1, ptr %sp.len)
  %sp.n = load i64, ptr %sp.len, align 8
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %2 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %sp.n, ptr %2, align 8
  %3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %1, ptr %3, align 8
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %4, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy
}

define internal i32 @Subprocess.isAlive(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %1 = call i32 @__polaron_subproc_alive(i64 %handle1)
  ret i32 %1
}

define internal i32 @Subprocess.canRead(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  %1 = call i32 @__polaron_subproc_can_read(i64 %handle1)
  ret i32 %1
}

define internal void @Subprocess.closeInput(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  call void @__polaron_subproc_close_stdin(i64 %handle1)
  ret void
}

define internal void @Subprocess.close(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !4
  call void @__polaron_subproc_close(i64 %handle1)
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @__polaron_subproc_spawn_ex(ptr, i64, i64)

declare i64 @__polaron_subproc_write(i64, ptr, i64)

declare ptr @__polaron_subproc_read(i64, ptr)

declare i32 @__polaron_subproc_alive(i64)

declare i32 @__polaron_subproc_can_read(i64)

declare void @__polaron_subproc_close_stdin(i64)

declare void @__polaron_subproc_close(i64)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i64", !2, i64 0}
