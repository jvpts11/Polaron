; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_builtins.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_builtins.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [12 x i8] c"count = %d\0A\00", align 1
@.fail = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_builtins.pol:15:17  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_builtins.pol:15:17  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_builtins.pol:15:17  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_builtins.pol:15:17  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.10 = private unnamed_addr constant [22 x i8] c"sum of ordinals = %d\0A\00", align 1
@.strdata.5318 = private constant [1 x i8] zeroinitializer
@.strobj.5319 = private global %String { i64 0, ptr @.strdata.5318, i64 0 }
@.strdata.5320 = private constant [1 x i8] zeroinitializer
@.strobj.5321 = private global %String { i64 0, ptr @.strdata.5320, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %fe.i = alloca i32, align 4
  %sum = alloca i32, align 4
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
  %16 = call i32 (ptr, ...) @printf(ptr @.str, i32 3)
  store i32 0, ptr %sum, align 4
  %enum.vals = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %enum.vals, align 8
  %arr.len = load i64, ptr %enum.vals, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data1 = getelementptr i8, ptr %enum.vals, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data1, i64 0
  store i32 0, ptr %arr.elem, align 4
  %arr.len2 = load i64, ptr %enum.vals, align 8
  %arr.oob3 = icmp uge i64 1, %arr.len2
  br i1 %arr.oob3, label %idx.bad4, label %idx.ok5, !prof !0

idx.bad4:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len2, i32 70)
  unreachable

idx.ok5:                                          ; preds = %idx.ok
  %arr.data6 = getelementptr i8, ptr %enum.vals, i64 8
  %arr.elem7 = getelementptr inbounds i32, ptr %arr.data6, i64 1
  store i32 1, ptr %arr.elem7, align 4
  %arr.len8 = load i64, ptr %enum.vals, align 8
  %arr.oob9 = icmp uge i64 2, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !0

idx.bad10:                                        ; preds = %idx.ok5
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %idx.ok5
  %arr.data12 = getelementptr i8, ptr %enum.vals, i64 8
  %arr.elem13 = getelementptr inbounds i32, ptr %arr.data12, i64 2
  store i32 2, ptr %arr.elem13, align 4
  %fe.len = load i64, ptr %enum.vals, align 8
  %fe.len32 = trunc i64 %fe.len to i32
  store i32 0, ptr %fe.i, align 4
  br label %fe.cond

fe.cond:                                          ; preds = %fe.update, %idx.ok11
  %fe.iv = load i32, ptr %fe.i, align 4
  %17 = icmp slt i32 %fe.iv, %fe.len32
  br i1 %17, label %fe.body, label %fe.end

fe.body:                                          ; preds = %fe.cond
  %18 = sext i32 %fe.iv to i64
  %arr.len14 = load i64, ptr %enum.vals, align 8
  %arr.oob15 = icmp uge i64 %18, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !0

fe.update:                                        ; preds = %idx.ok17
  %19 = load i32, ptr %fe.i, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %fe.i, align 4
  br label %fe.cond

fe.end:                                           ; preds = %fe.cond
  %sum22 = load i32, ptr %sum, align 4
  %21 = call i32 (ptr, ...) @printf(ptr @.str.10, i32 %sum22)
  ret i32 0

idx.bad16:                                        ; preds = %fe.body
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 %18, ptr @.failb.9, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %fe.body
  %arr.data18 = getelementptr i8, ptr %enum.vals, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 %18
  %fe.el = load i32, ptr %arr.elem19, align 4
  store i32 %fe.el, ptr %c, align 4
  %sum20 = load i32, ptr %sum, align 4
  %c21 = load i32, ptr %c, align 4
  %22 = add i32 %sum20, %c21
  store i32 %22, ptr %sum, align 4
  br label %fe.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5319)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5321)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!"branch_weights", i32 1, i32 1048576}
