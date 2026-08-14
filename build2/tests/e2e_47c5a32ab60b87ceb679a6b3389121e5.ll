; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/freestanding_kernel.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/freestanding_kernel.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

declare i32 @putchar(i32)

define i32 @main(i32 %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %msg = alloca ptr, align 8
  %buf = alloca i64, align 8
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
  %mem.alloc = call ptr @__polaron_malloc(i64 8)
  %16 = ptrtoint ptr %mem.alloc to i64
  store i64 %16, ptr %buf, align 8
  %buf1 = load i64, ptr %buf, align 8
  %17 = inttoptr i64 %buf1 to ptr
  store ptr %17, ptr %msg, align 8
  %msg2 = load ptr, ptr %msg, align 8
  %ptr.elem = getelementptr i32, ptr %msg2, i64 0
  store i32 79, ptr %ptr.elem, align 1
  %msg3 = load ptr, ptr %msg, align 8
  %ptr.elem4 = getelementptr i32, ptr %msg3, i64 1
  store i32 75, ptr %ptr.elem4, align 1
  %msg5 = load ptr, ptr %msg, align 8
  %ptr.elem6 = getelementptr i32, ptr %msg5, i64 2
  store i32 10, ptr %ptr.elem6, align 1
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i7 = load i32, ptr %i, align 4
  %18 = icmp slt i32 %i7, 3
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %msg8 = load ptr, ptr %msg, align 8
  %i9 = load i32, ptr %i, align 4
  %20 = sext i32 %i9 to i64
  %ptr.elem10 = getelementptr i32, ptr %msg8, i64 %20
  %elem = load i32, ptr %ptr.elem10, align 1
  %21 = call i32 @putchar(i32 %elem)
  br label %for.update

for.update:                                       ; preds = %for.body
  %22 = load i32, ptr %i, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %buf11 = load i64, ptr %buf, align 8
  %24 = inttoptr i64 %buf11 to ptr
  call void @__polaron_free(ptr %24)
  ret i32 0
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare void @__polaron_free(ptr)
