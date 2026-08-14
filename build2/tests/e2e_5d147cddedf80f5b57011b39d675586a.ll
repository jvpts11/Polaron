; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/java_enum_order.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/java_enum_order.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Priority = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Priority.vtable = private constant [350 x ptr] [ptr @Priority.score, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Priority.LOW.__inst = private global ptr null
@Priority.HIGH.__inst = private global ptr null
@Priority.MEDIUM.__inst = private global ptr null
@.str = private unnamed_addr constant [13 x i8] c"%d %d %d %d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal void @Priority.Priority(ptr %0, i32 %1) {
entry:
  %score = alloca i32, align 4
  store i32 %1, ptr %score, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Priority, ptr %0, i32 0, i32 0
  store ptr @Priority.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %score1 = getelementptr inbounds %class.Priority, ptr %0, i32 0, i32 1
  %score2 = load i32, ptr %score, align 4
  store i32 %score2, ptr %score1, align 4, !tbaa !4
  ret void
}

define internal i32 @Priority.score(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %score = getelementptr inbounds %class.Priority, ptr %0, i32 0, i32 1
  %score1 = load i32, ptr %score, align 4, !tbaa !4
  ret i32 %score1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %c = alloca ptr, align 8
  %b = alloca ptr, align 8
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
  %enum.cur = load ptr, ptr @Priority.LOW.__inst, align 8
  %16 = icmp eq ptr %enum.cur, null
  br i1 %16, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %argv.end
  %Priority = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Priority, ptr null, i64 1) to i64))
  call void @Priority.Priority(ptr %Priority, i32 1)
  store ptr %Priority, ptr @Priority.LOW.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %argv.end
  %Priority1 = load ptr, ptr @Priority.LOW.__inst, align 8
  store ptr %Priority1, ptr %a, align 8
  %enum.cur2 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %17 = icmp eq ptr %enum.cur2, null
  br i1 %17, label %enumc.init3, label %enumc.done4

enumc.init3:                                      ; preds = %enumc.done
  %Priority5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Priority, ptr null, i64 1) to i64))
  call void @Priority.Priority(ptr %Priority5, i32 9)
  store ptr %Priority5, ptr @Priority.HIGH.__inst, align 8
  br label %enumc.done4

enumc.done4:                                      ; preds = %enumc.init3, %enumc.done
  %Priority6 = load ptr, ptr @Priority.HIGH.__inst, align 8
  store ptr %Priority6, ptr %b, align 8
  %enum.cur7 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %18 = icmp eq ptr %enum.cur7, null
  br i1 %18, label %enumc.init8, label %enumc.done9

enumc.init8:                                      ; preds = %enumc.done4
  %Priority10 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Priority, ptr null, i64 1) to i64))
  call void @Priority.Priority(ptr %Priority10, i32 5)
  store ptr %Priority10, ptr @Priority.MEDIUM.__inst, align 8
  br label %enumc.done9

enumc.done9:                                      ; preds = %enumc.init8, %enumc.done4
  %Priority11 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  store ptr %Priority11, ptr %c, align 8
  %a12 = load ptr, ptr %a, align 8
  %b13 = load ptr, ptr %b, align 8
  %enum.ord.cur = load ptr, ptr @Priority.LOW.__inst, align 8
  %19 = icmp eq ptr %a12, %enum.ord.cur
  %enum.ord = select i1 %19, i32 0, i32 -1
  %enum.ord.cur14 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %20 = icmp eq ptr %a12, %enum.ord.cur14
  %enum.ord15 = select i1 %20, i32 1, i32 %enum.ord
  %enum.ord.cur16 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %21 = icmp eq ptr %a12, %enum.ord.cur16
  %enum.ord17 = select i1 %21, i32 2, i32 %enum.ord15
  %enum.ord.cur18 = load ptr, ptr @Priority.LOW.__inst, align 8
  %22 = icmp eq ptr %b13, %enum.ord.cur18
  %enum.ord19 = select i1 %22, i32 0, i32 -1
  %enum.ord.cur20 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %23 = icmp eq ptr %b13, %enum.ord.cur20
  %enum.ord21 = select i1 %23, i32 1, i32 %enum.ord19
  %enum.ord.cur22 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %24 = icmp eq ptr %b13, %enum.ord.cur22
  %enum.ord23 = select i1 %24, i32 2, i32 %enum.ord21
  %25 = icmp slt i32 %enum.ord17, %enum.ord23
  %26 = zext i1 %25 to i32
  %b24 = load ptr, ptr %b, align 8
  %c25 = load ptr, ptr %c, align 8
  %enum.ord.cur26 = load ptr, ptr @Priority.LOW.__inst, align 8
  %27 = icmp eq ptr %b24, %enum.ord.cur26
  %enum.ord27 = select i1 %27, i32 0, i32 -1
  %enum.ord.cur28 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %28 = icmp eq ptr %b24, %enum.ord.cur28
  %enum.ord29 = select i1 %28, i32 1, i32 %enum.ord27
  %enum.ord.cur30 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %29 = icmp eq ptr %b24, %enum.ord.cur30
  %enum.ord31 = select i1 %29, i32 2, i32 %enum.ord29
  %enum.ord.cur32 = load ptr, ptr @Priority.LOW.__inst, align 8
  %30 = icmp eq ptr %c25, %enum.ord.cur32
  %enum.ord33 = select i1 %30, i32 0, i32 -1
  %enum.ord.cur34 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %31 = icmp eq ptr %c25, %enum.ord.cur34
  %enum.ord35 = select i1 %31, i32 1, i32 %enum.ord33
  %enum.ord.cur36 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %32 = icmp eq ptr %c25, %enum.ord.cur36
  %enum.ord37 = select i1 %32, i32 2, i32 %enum.ord35
  %33 = icmp sgt i32 %enum.ord31, %enum.ord37
  %34 = zext i1 %33 to i32
  %c38 = load ptr, ptr %c, align 8
  %enum.cur39 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %35 = icmp eq ptr %enum.cur39, null
  br i1 %35, label %enumc.init40, label %enumc.done41

enumc.init40:                                     ; preds = %enumc.done9
  %Priority42 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Priority, ptr null, i64 1) to i64))
  call void @Priority.Priority(ptr %Priority42, i32 5)
  store ptr %Priority42, ptr @Priority.MEDIUM.__inst, align 8
  br label %enumc.done41

enumc.done41:                                     ; preds = %enumc.init40, %enumc.done9
  %Priority43 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %enum.ord.cur44 = load ptr, ptr @Priority.LOW.__inst, align 8
  %36 = icmp eq ptr %c38, %enum.ord.cur44
  %enum.ord45 = select i1 %36, i32 0, i32 -1
  %enum.ord.cur46 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %37 = icmp eq ptr %c38, %enum.ord.cur46
  %enum.ord47 = select i1 %37, i32 1, i32 %enum.ord45
  %enum.ord.cur48 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %38 = icmp eq ptr %c38, %enum.ord.cur48
  %enum.ord49 = select i1 %38, i32 2, i32 %enum.ord47
  %enum.ord.cur50 = load ptr, ptr @Priority.LOW.__inst, align 8
  %39 = icmp eq ptr %Priority43, %enum.ord.cur50
  %enum.ord51 = select i1 %39, i32 0, i32 -1
  %enum.ord.cur52 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %40 = icmp eq ptr %Priority43, %enum.ord.cur52
  %enum.ord53 = select i1 %40, i32 1, i32 %enum.ord51
  %enum.ord.cur54 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %41 = icmp eq ptr %Priority43, %enum.ord.cur54
  %enum.ord55 = select i1 %41, i32 2, i32 %enum.ord53
  %42 = icmp sle i32 %enum.ord49, %enum.ord55
  %43 = zext i1 %42 to i32
  %b56 = load ptr, ptr %b, align 8
  %a57 = load ptr, ptr %a, align 8
  %enum.ord.cur58 = load ptr, ptr @Priority.LOW.__inst, align 8
  %44 = icmp eq ptr %b56, %enum.ord.cur58
  %enum.ord59 = select i1 %44, i32 0, i32 -1
  %enum.ord.cur60 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %45 = icmp eq ptr %b56, %enum.ord.cur60
  %enum.ord61 = select i1 %45, i32 1, i32 %enum.ord59
  %enum.ord.cur62 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %46 = icmp eq ptr %b56, %enum.ord.cur62
  %enum.ord63 = select i1 %46, i32 2, i32 %enum.ord61
  %enum.ord.cur64 = load ptr, ptr @Priority.LOW.__inst, align 8
  %47 = icmp eq ptr %a57, %enum.ord.cur64
  %enum.ord65 = select i1 %47, i32 0, i32 -1
  %enum.ord.cur66 = load ptr, ptr @Priority.MEDIUM.__inst, align 8
  %48 = icmp eq ptr %a57, %enum.ord.cur66
  %enum.ord67 = select i1 %48, i32 1, i32 %enum.ord65
  %enum.ord.cur68 = load ptr, ptr @Priority.HIGH.__inst, align 8
  %49 = icmp eq ptr %a57, %enum.ord.cur68
  %enum.ord69 = select i1 %49, i32 2, i32 %enum.ord67
  %50 = icmp sge i32 %enum.ord63, %enum.ord69
  %51 = zext i1 %50 to i32
  %52 = call i32 (ptr, ...) @printf(ptr @.str, i32 %26, i32 %34, i32 %43, i32 %51)
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

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
