; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_hoist.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_hoist.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private unnamed_addr global ptr null
@Test.skipWhy = private unnamed_addr global ptr null
@.str = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1
@.strdata.5458 = private constant [1 x i8] zeroinitializer
@.strobj.5459 = private global %String { i64 0, ptr @.strdata.5458, i64 0 }
@.strdata.5460 = private constant [1 x i8] zeroinitializer
@.strobj.5461 = private global %String { i64 0, ptr @.strdata.5460, i64 0 }

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
  %argv.i.0118 = phi i64 [ %8, %argv.body ], [ 0, %entry ]
  %8 = add nuw nsw i64 %argv.i.0118, 1
  %9 = getelementptr ptr, ptr %1, i64 %8
  %argv.s = load ptr, ptr %9, align 8
  %argv.rawlen = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %argv.s)
  %newstr = tail call ptr @__polaron_malloc(i64 24)
  store i64 %argv.rawlen, ptr %newstr, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 1
  store ptr %argv.s, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 2
  store i64 0, ptr %11, align 8
  %12 = getelementptr ptr, ptr %arr.data, i64 %argv.i.0118
  store ptr %newstr, ptr %12, align 8
  %exitcond.not = icmp eq i64 %8, %4
  br i1 %exitcond.not, label %argv.end, label %argv.body

argv.end:                                         ; preds = %argv.body, %entry
  %strcpy.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5459)
  %13 = load ptr, ptr @Test.criterion, align 8
  tail call void @__polaron_str_free(ptr %13)
  store ptr %strcpy.i, ptr @Test.criterion, align 8
  %strcpy1.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5461)
  %14 = load ptr, ptr @Test.skipWhy, align 8
  tail call void @__polaron_str_free(ptr %14)
  store ptr %strcpy1.i, ptr @Test.skipWhy, align 8
  %arr = tail call ptr @__polaron_malloc(i64 4008)
  store i64 1000, ptr %arr, align 8
  %arr.data2 = getelementptr i8, ptr %arr, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(4000) %arr.data2, i8 0, i64 4000, i1 false)
  br label %for.body.i

for.body.i:                                       ; preds = %argv.end, %for.body.i
  %indvars.iv36.i = phi i64 [ %indvars.iv.next37.i, %for.body.i ], [ 0, %argv.end ]
  %arr.elem.i = getelementptr inbounds i32, ptr %arr.data2, i64 %indvars.iv36.i
  %15 = trunc i64 %indvars.iv36.i to i32
  %16 = mul i32 %15, 3
  store i32 %16, ptr %arr.elem.i, align 4
  %indvars.iv.next37.i = add nuw nsw i64 %indvars.iv36.i, 1
  %exitcond38.not.i = icmp eq i64 %indvars.iv.next37.i, 1000
  br i1 %exitcond38.not.i, label %for.body58.preheader, label %for.body.i

for.body58.preheader:                             ; preds = %for.body.i
  %arr6 = tail call ptr @__polaron_malloc(i64 4008)
  store i64 1000, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(4000) %arr.data7, ptr noundef nonnull align 4 dereferenceable(4000) %arr.data2, i64 4000, i1 false)
  br label %for.body58

if.end55:                                         ; preds = %for.body58
  %17 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.str, i32 %18)
  tail call void @__polaron_free(ptr nonnull %arr)
  tail call void @__polaron_free(ptr nonnull %arr6)
  ret i32 0

for.body58:                                       ; preds = %for.body58.preheader, %for.body58
  %indvars.iv142 = phi i64 [ 0, %for.body58.preheader ], [ %indvars.iv.next143, %for.body58 ]
  %sum.1123 = phi i32 [ 0, %for.body58.preheader ], [ %18, %for.body58 ]
  %arr.elem67 = getelementptr inbounds i32, ptr %arr.data7, i64 %indvars.iv142
  %elem68 = load i32, ptr %arr.elem67, align 4
  %18 = add i32 %elem68, %sum.1123
  %indvars.iv.next143 = add nuw nsw i64 %indvars.iv142, 1
  %exitcond144.not = icmp eq i64 %indvars.iv.next143, 1000
  br i1 %exitcond144.not, label %if.end55, label %for.body58
}

declare noalias ptr @__polaron_malloc(i64) local_unnamed_addr

; Function Attrs: mustprogress nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr nocapture) local_unnamed_addr #0

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #1

declare void @__polaron_free(ptr) local_unnamed_addr

declare void @__polaron_str_free(ptr) local_unnamed_addr

declare ptr @__polaron_str_copy(ptr) local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #4

attributes #0 = { mustprogress nofree nounwind willreturn memory(argmem: read) }
attributes #1 = { nofree nounwind }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #4 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
