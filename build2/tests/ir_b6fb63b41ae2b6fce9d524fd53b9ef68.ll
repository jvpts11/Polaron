; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_freestanding.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_freestanding.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%ReflectType = type { ptr, i64, ptr, ptr, i64, ptr, i64, ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr }
%class.Nic = type { i32 }
%ReflectMethod = type { ptr, ptr, i64, ptr, i64 }
%__box = type { ptr, i64 }

@.strdata = private constant [4 x i8] c"Nic\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [5 x i8] c"poll\00"
@.strobj.2 = private global %String { i64 4, ptr @.strdata.1, i64 0 }
@methods.Nic = private constant [1 x ptr] [ptr @.strobj.2]
@.strdata.3 = private constant [4 x i8] c"irq\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@fields.Nic = private constant [1 x ptr] [ptr @.strobj.4]
@annotations.Nic = private constant [0 x ptr] zeroinitializer
@methodfns.Nic = private constant [1 x ptr] [ptr @Nic.poll]
@fieldget.Nic = private constant [1 x ptr] [ptr @__fget.Nic.irq]
@fieldset.Nic = private constant [1 x ptr] [ptr @__fset.Nic.irq]
@methodann.Nic.0 = private constant [0 x ptr] zeroinitializer
@methodanncounts.Nic = private constant [1 x i64] zeroinitializer
@methodannptrs.Nic = private constant [1 x ptr] [ptr @methodann.Nic.0]
@methodrettags.Nic = private constant [1 x i64] [i64 1]
@type.Nic = private constant %ReflectType { ptr @.strobj, i64 1, ptr @methods.Nic, ptr @methodfns.Nic, i64 1, ptr @fields.Nic, i64 ptrtoint (ptr getelementptr (%class.Nic, ptr null, i64 1) to i64), ptr @Nic.Nic, i64 0, ptr @annotations.Nic, ptr @fieldget.Nic, ptr @fieldset.Nic, ptr @methodanncounts.Nic, ptr @methodannptrs.Nic, ptr @methodrettags.Nic }
@.strdata.5 = private constant [5 x i8] c"poll\00"
@.strobj.6 = private global %String { i64 4, ptr @.strdata.5, i64 0 }
@.panic = private unnamed_addr constant [61 x i8] c"reflection: Type.method(name) found no method with that name\00", align 1

define internal void @Nic.Nic(ptr %0) {
entry:
  %irq = getelementptr inbounds %class.Nic, ptr %0, i32 0, i32 0
  store i32 11, ptr %irq, align 4, !tbaa !0
  ret void
}

define internal i32 @Nic.poll(ptr nonnull align 4 dereferenceable(4) %0) {
entry:
  %irq = getelementptr inbounds %class.Nic, ptr %0, i32 0, i32 0
  %irq1 = load i32, ptr %irq, align 4, !tbaa !0
  ret i32 %irq1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %m = alloca ptr, align 8
  %mi = alloca i64, align 8
  %t = alloca ptr, align 8
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
  store ptr @type.Nic, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %16 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 1
  %17 = load i64, ptr %16, align 8
  %18 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 2
  %19 = load ptr, ptr %18, align 8
  %20 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 3
  %21 = load ptr, ptr %20, align 8
  %22 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 14
  %23 = load ptr, ptr %22, align 8
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %method = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%ReflectMethod, ptr null, i64 1) to i64))
  %24 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 0
  store ptr null, ptr %24, align 8
  %25 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  store ptr null, ptr %25, align 8
  %26 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  store i64 0, ptr %26, align 8
  store i64 0, ptr %mi, align 8
  br label %m.hdr

m.hdr:                                            ; preds = %m.next, %argv.end
  %i = load i64, ptr %mi, align 8
  %27 = icmp slt i64 %i, %17
  br i1 %27, label %m.body, label %m.miss

m.body:                                           ; preds = %m.hdr
  %28 = getelementptr ptr, ptr %19, i64 %i
  %mn = load ptr, ptr %28, align 8
  %str.data = getelementptr inbounds %String, ptr %mn, i32 0, i32 1
  %data2 = load ptr, ptr %str.data, align 8
  %29 = call i32 @strcmp(ptr %data2, ptr %data)
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %m.hit, label %m.next

m.hit:                                            ; preds = %m.body
  %31 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 0
  store ptr %mn, ptr %31, align 8
  %32 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 1
  %33 = getelementptr ptr, ptr %21, i64 %i
  %34 = load ptr, ptr %33, align 8
  store ptr %34, ptr %32, align 8
  %35 = getelementptr inbounds %ReflectMethod, ptr %method, i32 0, i32 4
  %36 = getelementptr i64, ptr %23, i64 %i
  %37 = load i64, ptr %36, align 8
  store i64 %37, ptr %35, align 8
  br label %m.end

m.next:                                           ; preds = %m.body
  %38 = add i64 %i, 1
  store i64 %38, ptr %mi, align 8
  br label %m.hdr

m.end:                                            ; preds = %m.hit
  store ptr %method, ptr %m, align 8
  %m3 = load ptr, ptr %m, align 8
  %39 = getelementptr inbounds %ReflectMethod, ptr %m3, i32 0, i32 1
  %m.fn = load ptr, ptr %39, align 8
  %byte = load i8, ptr %m.fn, align 1
  %40 = zext i8 %byte to i32
  ret i32 %40

m.miss:                                           ; preds = %m.hdr
  call void @__polaron_panic(ptr @.panic)
  unreachable
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define private ptr @__fget.Nic.irq(ptr %0) {
entry:
  %f.addr = getelementptr inbounds %class.Nic, ptr %0, i32 0, i32 0
  %f.val = load i32, ptr %f.addr, align 4, !tbaa !0
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr null, ptr %1, align 8
  %2 = sext i32 %f.val to i64
  %3 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %2, ptr %3, align 8
  ret ptr %box
}

define private void @__fset.Nic.irq(ptr %0, ptr %1) {
entry:
  %f.addr = getelementptr inbounds %class.Nic, ptr %0, i32 0, i32 0
  %2 = getelementptr inbounds %__box, ptr %1, i32 0, i32 1
  %unbox = load i64, ptr %2, align 8
  %3 = trunc i64 %unbox to i32
  store i32 %3, ptr %f.addr, align 4, !tbaa !0
  ret void
}

declare i32 @strcmp(ptr, ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
