; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_slice.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_slice.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.Slice$int" = type { ptr, ptr, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"Slice$int.vtable" = private constant [349 x ptr] [ptr @"Slice$int.length", ptr @"Slice$int.get", ptr @"Slice$int.set", ptr @"Slice$int.sub", ptr @"Slice$int.toArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [135 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_slice.pol:14:26  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [20 x i8] c"len=%d s0=%d s3=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [35 x i8] c"a1=%d mid_len=%d mid0=%d copy1=%d\0A\00", align 1
@.fail.2 = private unnamed_addr constant [135 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_slice.pol:21:41  in main\0A\00", align 1
@.faila.3 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5 = private unnamed_addr constant [135 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_slice.pol:21:41  in main\0A\00", align 1
@.faila.6 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.7 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.8 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:642:21  in Slice$int.get\0A\00", align 1
@.faila.9 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.10 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.11 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:644:17  in Slice$int.get\0A\00", align 1
@.faila.12 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.13 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.14 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:648:57  in Slice$int.set\0A\00", align 1
@.faila.15 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.16 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.17 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:651:46  in Slice$int.set\0A\00", align 1
@.faila.18 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.19 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.20 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:658:69  in Slice$int.toArray\0A\00", align 1
@.faila.21 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.22 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.23 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:658:69  in Slice$int.toArray\0A\00", align 1
@.faila.24 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.25 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5333 = private constant [1 x i8] zeroinitializer
@.strobj.5334 = private global %String { i64 0, ptr @.strdata.5333, i64 0 }
@.strdata.5335 = private constant [1 x i8] zeroinitializer
@.strobj.5336 = private global %String { i64 0, ptr @.strdata.5335, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %copy = alloca ptr, align 8
  %mid = alloca ptr, align 8
  %s = alloca ptr, align 8
  %i = alloca i32, align 4
  %a = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 32)
  store i64 6, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 24)
  store ptr %arr, ptr %a, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i2 = load i32, ptr %i, align 4
  %17 = icmp slt i32 %i2, 6
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %a3 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i4 = load i32, ptr %i, align 4
  %19 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %a3, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %"Slice$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Slice$int", ptr null, i64 1) to i64))
  %a7 = load ptr, ptr %a, align 8
  call void @"Slice$int.Slice$int"(ptr %"Slice$int.obj", ptr %a7, i32 1, i32 4)
  store ptr %"Slice$int.obj", ptr %s, align 8
  %s8 = load ptr, ptr %s, align 8
  %22 = call i32 @"Slice$int.length"(ptr %s8)
  %s9 = load ptr, ptr %s, align 8
  %23 = call i32 @"Slice$int.get"(ptr %s9, i32 0)
  %s10 = load ptr, ptr %s, align 8
  %24 = call i32 @"Slice$int.get"(ptr %s10, i32 3)
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %22, i32 %23, i32 %24)
  %s11 = load ptr, ptr %s, align 8
  call void @"Slice$int.set"(ptr %s11, i32 0, i32 999)
  %s12 = load ptr, ptr %s, align 8
  %26 = call ptr @"Slice$int.sub"(ptr %s12, i32 1, i32 3)
  store ptr %26, ptr %mid, align 8
  %mid13 = load ptr, ptr %mid, align 8
  %27 = call ptr @"Slice$int.toArray"(ptr %mid13)
  store ptr %27, ptr %copy, align 8
  %a14 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len15 = load i64, ptr %a14, align 8
  %arr.oob16 = icmp uge i64 1, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %19, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data5 = getelementptr i8, ptr %a3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data5, i64 %19
  %i6 = load i32, ptr %i, align 4
  %28 = add i32 %i6, 1
  %29 = mul i32 %28, 10
  store i32 %29, ptr %arr.elem, align 4
  br label %for.update

idx.bad17:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.2, ptr @.faila.3, i64 1, ptr @.failb.4, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %for.end
  %arr.data19 = getelementptr i8, ptr %a14, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 1
  %elem = load i32, ptr %arr.elem20, align 4
  %mid21 = load ptr, ptr %mid, align 8
  %30 = call i32 @"Slice$int.length"(ptr %mid21)
  %mid22 = load ptr, ptr %mid, align 8
  %31 = call i32 @"Slice$int.get"(ptr %mid22, i32 0)
  %copy23 = load ptr, ptr %copy, align 8, !nonnull !0, !dereferenceable !1
  %arr.len24 = load i64, ptr %copy23, align 8
  %arr.oob25 = icmp uge i64 1, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !2

idx.bad26:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.5, ptr @.faila.6, i64 1, ptr @.failb.7, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %idx.ok18
  %arr.data28 = getelementptr i8, ptr %copy23, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 1
  %elem30 = load i32, ptr %arr.elem29, align 4
  %32 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %elem, i32 %30, i32 %31, i32 %elem30)
  ret i32 0
}

define internal void @"Slice$int.Slice$int"(ptr %0, ptr %1, i32 %2, i32 %3) {
entry:
  %len = alloca i32, align 4
  %start = alloca i32, align 4
  %array = alloca ptr, align 8
  store ptr %1, ptr %array, align 8
  store i32 %2, ptr %start, align 4
  store i32 %3, ptr %len, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 0
  store ptr @"Slice$int.vtable", ptr %vtbl.addr, align 8, !tbaa !3
  %backing = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %backing, align 8, !tbaa !3
  %backing1 = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %array2 = load ptr, ptr %array, align 8
  store ptr %array2, ptr %backing1, align 8, !tbaa !3
  %start3 = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 2
  %start4 = load i32, ptr %start, align 4
  store i32 %start4, ptr %start3, align 4, !tbaa !7
  %len5 = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 3
  %len6 = load i32, ptr %len, align 4
  store i32 %len6, ptr %len5, align 4, !tbaa !7
  ret void
}

define internal i32 @"Slice$int.length"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %len = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 3
  %len1 = load i32, ptr %len, align 4, !tbaa !7
  ret i32 %len1
}

define internal i32 @"Slice$int.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %i1 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %i1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i2 = load i32, ptr %i, align 4
  %len = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 3
  %len3 = load i32, ptr %len, align 4, !tbaa !7
  %4 = icmp sge i32 %i2, %len3
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %backing = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %backing4 = load ptr, ptr %backing, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %backing5 = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %backing6 = load ptr, ptr %backing5, align 8, !tbaa !3
  %len7 = load i64, ptr %backing6, align 8
  %7 = trunc i64 %len7 to i32
  %8 = sext i32 %7 to i64
  %arr.len = load i64, ptr %backing4, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %sc.end
  %backing8 = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %backing9 = load ptr, ptr %backing8, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %start = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 2
  %start10 = load i32, ptr %start, align 4, !tbaa !7
  %i11 = load i32, ptr %i, align 4
  %9 = add i32 %start10, %i11
  %10 = sext i32 %9 to i64
  %arr.len12 = load i64, ptr %backing9, align 8
  %arr.oob13 = icmp uge i64 %10, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.8, ptr @.faila.9, i64 %8, ptr @.failb.10, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %backing4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem

idx.bad14:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.11, ptr @.faila.12, i64 %10, ptr @.failb.13, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %if.end
  %arr.data16 = getelementptr i8, ptr %backing9, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %10
  %elem18 = load i32, ptr %arr.elem17, align 4
  ret i32 %elem18
}

define internal void @"Slice$int.set"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %value = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store i32 %2, ptr %value, align 4
  %i1 = load i32, ptr %i, align 4
  %3 = icmp slt i32 %i1, 0
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i2 = load i32, ptr %i, align 4
  %len = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 3
  %len3 = load i32, ptr %len, align 4, !tbaa !7
  %5 = icmp sge i32 %i2, %len3
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %backing = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %backing4 = load ptr, ptr %backing, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %backing5 = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %backing6 = load ptr, ptr %backing5, align 8, !tbaa !3
  %len7 = load i64, ptr %backing6, align 8
  %8 = trunc i64 %len7 to i32
  %9 = sext i32 %8 to i64
  %arr.len = load i64, ptr %backing4, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %sc.end
  %backing9 = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %backing10 = load ptr, ptr %backing9, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %start = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 2
  %start11 = load i32, ptr %start, align 4, !tbaa !7
  %i12 = load i32, ptr %i, align 4
  %10 = add i32 %start11, %i12
  %11 = sext i32 %10 to i64
  %arr.len13 = load i64, ptr %backing10, align 8
  %arr.oob14 = icmp uge i64 %11, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !2

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.14, ptr @.faila.15, i64 %9, ptr @.failb.16, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %backing4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %9
  %value8 = load i32, ptr %value, align 4
  store i32 %value8, ptr %arr.elem, align 4
  ret void

idx.bad15:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.17, ptr @.faila.18, i64 %11, ptr @.failb.19, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %if.end
  %arr.data17 = getelementptr i8, ptr %backing10, i64 8
  %arr.elem18 = getelementptr inbounds i32, ptr %arr.data17, i64 %11
  %value19 = load i32, ptr %value, align 4
  store i32 %value19, ptr %arr.elem18, align 4
  ret void
}

define internal ptr @"Slice$int.sub"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %to = alloca i32, align 4
  %from = alloca i32, align 4
  store i32 %1, ptr %from, align 4
  store i32 %2, ptr %to, align 4
  %"Slice$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Slice$int", ptr null, i64 1) to i64))
  %backing = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %backing1 = load ptr, ptr %backing, align 8, !tbaa !3
  %start = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 2
  %start2 = load i32, ptr %start, align 4, !tbaa !7
  %from3 = load i32, ptr %from, align 4
  %3 = add i32 %start2, %from3
  %to4 = load i32, ptr %to, align 4
  %from5 = load i32, ptr %from, align 4
  %4 = sub i32 %to4, %from5
  call void @"Slice$int.Slice$int"(ptr %"Slice$int.obj", ptr %backing1, i32 %3, i32 %4)
  ret ptr %"Slice$int.obj"
}

define internal ptr @"Slice$int.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %len = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 3
  %len1 = load i32, ptr %len, align 4, !tbaa !7
  %1 = sext i32 %len1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %len3 = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 3
  %len4 = load i32, ptr %len3, align 4, !tbaa !7
  %5 = icmp slt i32 %i2, %len4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out5 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %7 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %out5, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok14
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out17 = load ptr, ptr %out, align 8
  ret ptr %out17

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.20, ptr @.faila.21, i64 %7, ptr @.failb.22, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %out5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data7, i64 %7
  %backing = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 1
  %backing8 = load ptr, ptr %backing, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %start = getelementptr inbounds %"class.Slice$int", ptr %0, i32 0, i32 2
  %start9 = load i32, ptr %start, align 4, !tbaa !7
  %i10 = load i32, ptr %i, align 4
  %10 = add i32 %start9, %i10
  %11 = sext i32 %10 to i64
  %arr.len11 = load i64, ptr %backing8, align 8
  %arr.oob12 = icmp uge i64 %11, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.23, ptr @.faila.24, i64 %11, ptr @.failb.25, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %backing8, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %11
  %elem = load i32, ptr %arr.elem16, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5334)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5336)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !5, i64 0}
