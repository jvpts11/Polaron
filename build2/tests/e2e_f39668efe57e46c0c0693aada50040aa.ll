; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/volatile_method.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/volatile_method.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private unnamed_addr global ptr null
@Test.skipWhy = private unnamed_addr global ptr null
@Sensor.vtable = private constant [349 x ptr] [ptr @Sensor.read, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [6 x i8] c"v=%d\0A\00", align 1
@.strdata.5446 = private constant [1 x i8] zeroinitializer
@.strobj.5447 = private global %String { i64 0, ptr @.strdata.5446, i64 0 }
@.strdata.5448 = private constant [1 x i8] zeroinitializer
@.strobj.5449 = private global %String { i64 0, ptr @.strdata.5448, i64 0 }

; Function Attrs: noinline optnone
define internal i32 @Sensor.read(ptr nonnull align 8 %0) #0 {
entry:
  ret i32 42
}

define noundef i32 @main(i32 %0, ptr nocapture readonly %1) local_unnamed_addr {
entry:
  %2 = tail call i32 @llvm.smax.i32(i32 %0, i32 1)
  %3 = zext nneg i32 %2 to i64
  %4 = add nsw i64 %3, -1
  %5 = shl nuw nsw i64 %4, 3
  %6 = add nuw nsw i64 %5, 8
  %argv.arr = tail call ptr @__polaron_malloc(i64 %6)
  %arr.data = getelementptr i8, ptr %argv.arr, i64 8
  %7 = icmp sgt i32 %0, 1
  br i1 %7, label %argv.body, label %argv.end

argv.body:                                        ; preds = %entry, %argv.body
  %argv.i.03 = phi i64 [ %8, %argv.body ], [ 0, %entry ]
  %8 = add nuw nsw i64 %argv.i.03, 1
  %9 = getelementptr ptr, ptr %1, i64 %8
  %argv.s = load ptr, ptr %9, align 8
  %argv.rawlen = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %argv.s)
  %newstr = tail call ptr @__polaron_malloc(i64 24)
  store i64 %argv.rawlen, ptr %newstr, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 1
  store ptr %argv.s, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 2
  store i64 0, ptr %11, align 8
  %12 = getelementptr ptr, ptr %arr.data, i64 %argv.i.03
  store ptr %newstr, ptr %12, align 8
  %exitcond.not = icmp eq i64 %8, %4
  br i1 %exitcond.not, label %argv.end, label %argv.body

argv.end:                                         ; preds = %argv.body, %entry
  %strcpy.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5447)
  %13 = load ptr, ptr @Test.criterion, align 8
  tail call void @__polaron_str_free(ptr %13)
  store ptr %strcpy.i, ptr @Test.criterion, align 8
  %strcpy1.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5449)
  %14 = load ptr, ptr @Test.skipWhy, align 8
  tail call void @__polaron_str_free(ptr %14)
  store ptr %strcpy1.i, ptr @Test.skipWhy, align 8
  %Sensor.obj = tail call ptr @__polaron_malloc(i64 8)
  store ptr @Sensor.vtable, ptr %Sensor.obj, align 8, !tbaa !0
  %15 = tail call i32 @Sensor.read(ptr poison)
  %16 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.str, i32 42)
  tail call void @__polaron_check_live(ptr nonnull %Sensor.obj)
  %vtbl = load ptr, ptr %Sensor.obj, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %.not = icmp eq ptr %dtor.fn, null
  br i1 %.not, label %dtor.free, label %dtor.call

dtor.call:                                        ; preds = %argv.end
  tail call void %dtor.fn(ptr nonnull %Sensor.obj)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %argv.end
  tail call void @__polaron_free(ptr nonnull %Sensor.obj)
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @Object.equals(ptr nocapture nonnull readnone align 8 %0, ptr nocapture readnone %1) #1 {
entry:
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @Object.hashCode(ptr nocapture nonnull readnone align 8 %0) #1 {
entry:
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define internal noundef i32 @Object.equalsKey(ptr nocapture nonnull readnone align 8 %0, ptr nocapture readnone %1) #1 {
entry:
  ret i32 0
}

declare noalias ptr @__polaron_malloc(i64) local_unnamed_addr

; Function Attrs: mustprogress nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr nocapture) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #3

declare void @__polaron_check_live(ptr) local_unnamed_addr

declare void @__polaron_free(ptr) local_unnamed_addr

declare void @__polaron_str_free(ptr) local_unnamed_addr

declare ptr @__polaron_str_copy(ptr) local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #4

attributes #0 = { noinline optnone }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #2 = { mustprogress nofree nounwind willreturn memory(argmem: read) }
attributes #3 = { nofree nounwind }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
