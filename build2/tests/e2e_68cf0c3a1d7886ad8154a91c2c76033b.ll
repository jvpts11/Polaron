; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/logger_levels.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/logger_levels.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Logger = type { ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Logger.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Logger.setLevel, ptr @Logger.emit, ptr @Logger.debug, ptr @Logger.info, ptr @Logger.warn, ptr @Logger.error, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [4 x i8] c"app\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"hidden\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [6 x i8] c"hello\00"
@.strobj.4 = private global %String { i64 5, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [8 x i8] c"careful\00"
@.strobj.6 = private global %String { i64 7, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [8 x i8] c"hidden2\00"
@.strobj.8 = private global %String { i64 7, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [5 x i8] c"boom\00"
@.strobj.10 = private global %String { i64 4, ptr @.strdata.9, i64 0 }
@.str = private unnamed_addr constant [13 x i8] c"[%s] %s: %s\0A\00", align 1
@.strdata.3875 = private constant [6 x i8] c"DEBUG\00"
@.strobj.3876 = private global %String { i64 5, ptr @.strdata.3875, i64 0 }
@.strdata.3877 = private constant [5 x i8] c"INFO\00"
@.strobj.3878 = private global %String { i64 4, ptr @.strdata.3877, i64 0 }
@.strdata.3879 = private constant [5 x i8] c"WARN\00"
@.strobj.3880 = private global %String { i64 4, ptr @.strdata.3879, i64 0 }
@.strdata.3881 = private constant [6 x i8] c"ERROR\00"
@.strobj.3882 = private global %String { i64 5, ptr @.strdata.3881, i64 0 }
@.strdata.5316 = private constant [1 x i8] zeroinitializer
@.strobj.5317 = private global %String { i64 0, ptr @.strdata.5316, i64 0 }
@.strdata.5318 = private constant [1 x i8] zeroinitializer
@.strobj.5319 = private global %String { i64 0, ptr @.strdata.5318, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %log = alloca ptr, align 8
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
  %Logger.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Logger, ptr null, i64 1) to i64))
  call void @Logger.Logger(ptr %Logger.obj, ptr @.strobj)
  store ptr %Logger.obj, ptr %log, align 8
  %log1 = load ptr, ptr %log, align 8
  call void @Logger.debug(ptr %log1, ptr @.strobj.2)
  %log2 = load ptr, ptr %log, align 8
  call void @Logger.info(ptr %log2, ptr @.strobj.4)
  %log3 = load ptr, ptr %log, align 8
  call void @Logger.warn(ptr %log3, ptr @.strobj.6)
  %log4 = load ptr, ptr %log, align 8
  call void @Logger.setLevel(ptr %log4, i32 2)
  %log5 = load ptr, ptr %log, align 8
  call void @Logger.info(ptr %log5, ptr @.strobj.8)
  %log6 = load ptr, ptr %log, align 8
  call void @Logger.error(ptr %log6, ptr @.strobj.10)
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

define internal void @Logger.Logger(ptr %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  store ptr %1, ptr %name, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 0
  store ptr @Logger.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %name1 = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 1
  store ptr null, ptr %name1, align 8, !tbaa !0
  %name2 = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 1
  %name3 = load ptr, ptr %name, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %name3)
  %2 = load ptr, ptr %name2, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %name2, align 8, !tbaa !0
  %minLevel = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 2
  store i32 1, ptr %minLevel, align 4, !tbaa !4
  ret void
}

define internal void @Logger.setLevel(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %level = alloca i32, align 4
  store i32 %1, ptr %level, align 4
  %minLevel = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 2
  %level1 = load i32, ptr %level, align 4
  store i32 %level1, ptr %minLevel, align 4, !tbaa !4
  ret void
}

define internal void @Logger.emit(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2) {
entry:
  %message = alloca ptr, align 8
  %level = alloca ptr, align 8
  store ptr %1, ptr %level, align 8
  store ptr %2, ptr %message, align 8
  %level1 = load ptr, ptr %level, align 8
  %str.data = getelementptr inbounds %String, ptr %level1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %name = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 1
  %name2 = load ptr, ptr %name, align 8, !tbaa !0
  %str.data3 = getelementptr inbounds %String, ptr %name2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %message5 = load ptr, ptr %message, align 8
  %str.data6 = getelementptr inbounds %String, ptr %message5, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %3 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, ptr %data4, ptr %data7)
  ret void
}

define internal void @Logger.debug(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %message = alloca ptr, align 8
  store ptr %1, ptr %message, align 8
  %minLevel = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 2
  %minLevel1 = load i32, ptr %minLevel, align 4, !tbaa !4
  %2 = icmp sle i32 %minLevel1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %message2 = load ptr, ptr %message, align 8
  call void @Logger.emit(ptr %0, ptr @.strobj.3876, ptr %message2)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Logger.info(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %message = alloca ptr, align 8
  store ptr %1, ptr %message, align 8
  %minLevel = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 2
  %minLevel1 = load i32, ptr %minLevel, align 4, !tbaa !4
  %2 = icmp sle i32 %minLevel1, 1
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %message2 = load ptr, ptr %message, align 8
  call void @Logger.emit(ptr %0, ptr @.strobj.3878, ptr %message2)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Logger.warn(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %message = alloca ptr, align 8
  store ptr %1, ptr %message, align 8
  %minLevel = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 2
  %minLevel1 = load i32, ptr %minLevel, align 4, !tbaa !4
  %2 = icmp sle i32 %minLevel1, 2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %message2 = load ptr, ptr %message, align 8
  call void @Logger.emit(ptr %0, ptr @.strobj.3880, ptr %message2)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Logger.error(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %message = alloca ptr, align 8
  store ptr %1, ptr %message, align 8
  %minLevel = getelementptr inbounds %class.Logger, ptr %0, i32 0, i32 2
  %minLevel1 = load i32, ptr %minLevel, align 4, !tbaa !4
  %2 = icmp sle i32 %minLevel1, 3
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %message2 = load ptr, ptr %message, align 8
  call void @Logger.emit(ptr %0, ptr @.strobj.3882, ptr %message2)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5317)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5319)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

declare i32 @printf(ptr, ...)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
