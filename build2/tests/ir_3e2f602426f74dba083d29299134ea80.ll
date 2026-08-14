; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_freestanding.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_freestanding.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Heap.next = private global i64 0
@Heap.armed = private global i32 0
@.strdata = private constant [6 x i8] c"hello\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [6 x i8] c"world\00"
@.strobj.2 = private global %String { i64 5, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [11 x i8] c"bare metal\00"
@.strobj.4 = private global %String { i64 10, ptr @.strdata.3, i64 0 }

define internal i64 @Heap.allocate(i64 %0) {
entry:
  %at = alloca i64, align 8
  %size = alloca i64, align 8
  store i64 %0, ptr %size, align 8
  %armed = load i32, ptr @Heap.armed, align 4
  %1 = icmp eq i32 %armed, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i64 1048576, ptr @Heap.next, align 8
  store i32 1, ptr @Heap.armed, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %next = load i64, ptr @Heap.next, align 8
  store i64 %next, ptr %at, align 8
  %next1 = load i64, ptr @Heap.next, align 8
  %size2 = load i64, ptr %size, align 8
  %3 = add i64 %next1, %size2
  %4 = add i64 %3, 15
  store i64 %4, ptr @Heap.next, align 8
  %at3 = load i64, ptr %at, align 8
  ret i64 %at3
}

define internal void @Heap.release(i64 %0) {
entry:
  %p = alloca i64, align 8
  store i64 %0, ptr %p, align 8
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %scratch = alloca ptr, align 8
  %greeting = alloca ptr, align 8
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %greeting, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.2)
  store ptr %strcpy1, ptr %scratch, align 8
  %strcpy2 = call ptr @__polaron_str_copy(ptr @.strobj.4)
  %16 = load ptr, ptr %scratch, align 8
  call void @__polaron_str_free(ptr %16)
  store ptr %strcpy2, ptr %scratch, align 8
  %greeting3 = load ptr, ptr %greeting, align 8
  %str.len = getelementptr inbounds %String, ptr %greeting3, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %17 = trunc i64 %len to i32
  %scratch4 = load ptr, ptr %scratch, align 8
  %str.len5 = getelementptr inbounds %String, ptr %scratch4, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %18 = trunc i64 %len6 to i32
  %19 = add i32 %17, %18
  %20 = load ptr, ptr %scratch, align 8
  call void @__polaron_str_free(ptr %20)
  %21 = load ptr, ptr %greeting, align 8
  call void @__polaron_str_free(ptr %21)
  ret i32 %19
}

define noalias ptr @__polaron_malloc(i64 %0) {
entry:
  %1 = call i64 @Heap.allocate(i64 %0)
  %2 = inttoptr i64 %1 to ptr
  ret ptr %2
}

declare i64 @strlen(ptr)

define internal ptr @__polaron_str_copy(ptr %0) {
entry:
  %1 = icmp eq ptr %0, null
  br i1 %1, label %isnull, label %copy

copy:                                             ; preds = %entry
  %src.len.p = getelementptr inbounds { i64, ptr, i64 }, ptr %0, i32 0, i32 0
  %src.len = load i64, ptr %src.len.p, align 8
  %src.data.p = getelementptr inbounds { i64, ptr, i64 }, ptr %0, i32 0, i32 1
  %src.data = load ptr, ptr %src.data.p, align 8
  %str.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr ({ i64, ptr, i64 }, ptr null, i64 1) to i64))
  %2 = add i64 %src.len, 1
  %str.buf = call ptr @__polaron_malloc(i64 %2)
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %str.buf, ptr align 1 %src.data, i64 %src.len, i1 false)
  %3 = getelementptr i8, ptr %str.buf, i64 %src.len
  store i8 0, ptr %3, align 1
  %4 = getelementptr inbounds { i64, ptr, i64 }, ptr %str.obj, i32 0, i32 0
  store i64 %src.len, ptr %4, align 8
  %5 = getelementptr inbounds { i64, ptr, i64 }, ptr %str.obj, i32 0, i32 1
  store ptr %str.buf, ptr %5, align 8
  %6 = getelementptr inbounds { i64, ptr, i64 }, ptr %str.obj, i32 0, i32 2
  store i64 0, ptr %6, align 8
  ret ptr %str.obj

isnull:                                           ; preds = %entry
  ret ptr null
}

define internal void @__polaron_str_free(ptr %0) {
entry:
  %1 = icmp eq ptr %0, null
  br i1 %1, label %done, label %free

free:                                             ; preds = %entry
  %s.data.p = getelementptr inbounds { i64, ptr, i64 }, ptr %0, i32 0, i32 1
  %2 = load ptr, ptr %s.data.p, align 8
  call void @__polaron_free(ptr %2)
  call void @__polaron_free(ptr %0)
  br label %done

done:                                             ; preds = %free, %entry
  ret void
}

define void @__polaron_free(ptr %0) {
entry:
  %1 = ptrtoint ptr %0 to i64
  call void @Heap.release(i64 %1)
  ret void
}

define void @__polaron_check_live(ptr %0) {
entry:
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #0

attributes #0 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
