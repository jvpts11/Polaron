; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/../performance tests/matrixmul.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/../performance tests/matrixmul.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private unnamed_addr global ptr null
@Test.skipWhy = private unnamed_addr global ptr null
@.fail = private unnamed_addr constant [141 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/../performance tests/matrixmul.pol:18:38  in main\0A\00", align 1
@.fail.4 = private unnamed_addr constant [141 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/../performance tests/matrixmul.pol:23:21  in main\0A\00", align 1
@.fail.19 = private unnamed_addr constant [141 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/../performance tests/matrixmul.pol:25:25  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"checksum=%d\0A\00", align 1
@.strdata.5473 = private constant [1 x i8] zeroinitializer
@.strobj.5474 = private global %String { i64 0, ptr @.strdata.5473, i64 0 }
@.strdata.5475 = private constant [1 x i8] zeroinitializer
@.strobj.5476 = private global %String { i64 0, ptr @.strdata.5475, i64 0 }

define noundef i32 @main(i32 %0, ptr nocapture readonly %1) local_unnamed_addr personality ptr @__CxxFrameHandler3 {
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
  %argv.i.0518 = phi i64 [ %8, %argv.body ], [ 0, %entry ]
  %8 = add nuw nsw i64 %argv.i.0518, 1
  %9 = getelementptr ptr, ptr %1, i64 %8
  %argv.s = load ptr, ptr %9, align 8
  %argv.rawlen = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %argv.s)
  %newstr = tail call ptr @__polaron_malloc(i64 24)
  store i64 %argv.rawlen, ptr %newstr, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 1
  store ptr %argv.s, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 2
  store i64 0, ptr %11, align 8
  %12 = getelementptr ptr, ptr %arr.data, i64 %argv.i.0518
  store ptr %newstr, ptr %12, align 8
  %exitcond.not = icmp eq i64 %8, %4
  br i1 %exitcond.not, label %argv.end, label %argv.body

argv.end:                                         ; preds = %argv.body, %entry
  %strcpy.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5474)
  %13 = load ptr, ptr @Test.criterion, align 8
  tail call void @__polaron_str_free(ptr %13)
  store ptr %strcpy.i, ptr @Test.criterion, align 8
  %strcpy1.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5476)
  %14 = load ptr, ptr @Test.skipWhy, align 8
  tail call void @__polaron_str_free(ptr %14)
  store ptr %strcpy1.i, ptr @Test.skipWhy, align 8
  %arr = tail call ptr @__polaron_malloc(i64 2097160)
  store i64 262144, ptr %arr, align 8
  %arr.data3 = getelementptr i8, ptr %arr, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(2097152) %arr.data3, i8 0, i64 2097152, i1 false)
  %arr6 = tail call ptr @__polaron_malloc(i64 2097160)
  store i64 262144, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(2097152) %arr.data7, i8 0, i64 2097152, i1 false)
  %arr10 = tail call ptr @__polaron_malloc(i64 2097160)
  store i64 262144, ptr %arr10, align 8
  %arr.data11 = getelementptr i8, ptr %arr10, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(2097152) %arr.data11, i8 0, i64 2097152, i1 false)
  br label %sc.rhs

sc.rhs:                                           ; preds = %argv.end, %if.end
  %indvars.iv569 = phi i64 [ 0, %argv.end ], [ %indvars.iv.next570, %if.end ]
  %15 = shl nuw nsw i64 %indvars.iv569, 9
  %.not498 = icmp ugt i64 %indvars.iv569, 511
  br i1 %.not498, label %for.body68, label %div.ok

if.end:                                           ; preds = %div.ok, %div.ok98
  %indvars.iv.next570 = add nuw nsw i64 %indvars.iv569, 1
  %exitcond572.not = icmp eq i64 %indvars.iv.next570, 512
  br i1 %exitcond572.not, label %sc.rhs108, label %sc.rhs

div.ok:                                           ; preds = %sc.rhs, %div.ok
  %indvars.iv = phi i64 [ %indvars.iv.next, %div.ok ], [ 0, %sc.rhs ]
  %16 = add nuw nsw i64 %indvars.iv, %indvars.iv569
  %17 = or disjoint i64 %indvars.iv, %15
  %arr.elem = getelementptr inbounds double, ptr %arr.data3, i64 %17
  %18 = trunc i64 %16 to i32
  %19 = urem i32 %18, 100
  %20 = sitofp i32 %19 to double
  %21 = fmul double %20, 5.000000e-01
  store double %21, ptr %arr.elem, align 8
  %22 = mul nuw nsw i64 %indvars.iv, %indvars.iv569
  %arr.elem59 = getelementptr inbounds double, ptr %arr.data7, i64 %17
  %23 = trunc i64 %22 to i32
  %24 = urem i32 %23, 100
  %25 = sitofp i32 %24 to double
  %26 = fmul double %25, 2.500000e-01
  store double %26, ptr %arr.elem59, align 8
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond565.not = icmp eq i64 %indvars.iv.next, 512
  br i1 %exitcond565.not, label %if.end, label %div.ok

for.body68:                                       ; preds = %sc.rhs, %div.ok98
  %indvars.iv566 = phi i64 [ %indvars.iv.next567, %div.ok98 ], [ 0, %sc.rhs ]
  %27 = or disjoint i64 %indvars.iv566, %15
  %arr.oob.not = icmp ult i64 %27, 262144
  br i1 %arr.oob.not, label %div.ok98, label %idx.bad, !prof !0

idx.bad:                                          ; preds = %for.body68
  tail call void @__polaron_fail(ptr nonnull @.fail, ptr nonnull @.faila.20, i64 %27, ptr nonnull @.failb.21, i64 262144, i32 70)
  unreachable

div.ok98:                                         ; preds = %for.body68
  %28 = add nuw nsw i64 %indvars.iv566, %indvars.iv569
  %arr.elem78 = getelementptr inbounds double, ptr %arr.data3, i64 %27
  %29 = trunc i64 %28 to i32
  %30 = urem i32 %29, 100
  %31 = sitofp i32 %30 to double
  %32 = fmul double %31, 5.000000e-01
  store double %32, ptr %arr.elem78, align 8
  %33 = mul nuw nsw i64 %indvars.iv566, %indvars.iv569
  %arr.elem94 = getelementptr inbounds double, ptr %arr.data7, i64 %27
  %34 = trunc i64 %33 to i32
  %35 = urem i32 %34, 100
  %36 = sitofp i32 %35 to double
  %37 = fmul double %36, 2.500000e-01
  store double %37, ptr %arr.elem94, align 8
  %indvars.iv.next567 = add nuw nsw i64 %indvars.iv566, 1
  %exitcond568.not = icmp eq i64 %indvars.iv.next567, 512
  br i1 %exitcond568.not, label %if.end, label %for.body68

sc.rhs108:                                        ; preds = %if.end, %for.end160
  %indvar = phi i64 [ %indvar.next, %for.end160 ], [ 0, %if.end ]
  %38 = shl nuw nsw i64 %indvar, 9
  %.not = icmp ugt i64 %indvar, 511
  br i1 %.not, label %for.body142, label %for.body129.preheader

for.body129.preheader:                            ; preds = %sc.rhs108
  %39 = shl nuw nsw i64 %indvar, 12
  %40 = or disjoint i64 %39, 8
  %scevgep = getelementptr i8, ptr %arr10, i64 %40
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(4096) %scevgep, i8 0, i64 4096, i1 false)
  br label %sc.rhs170.preheader

sc.rhs170.preheader:                              ; preds = %idx.ok154, %for.body129.preheader
  br label %sc.rhs170

for.body142:                                      ; preds = %sc.rhs108, %idx.ok154
  %indvars.iv575 = phi i64 [ %indvars.iv.next576, %idx.ok154 ], [ 0, %sc.rhs108 ]
  %41 = or disjoint i64 %indvars.iv575, %38
  %arr.oob152.not = icmp ult i64 %41, 262144
  br i1 %arr.oob152.not, label %idx.ok154, label %idx.bad153, !prof !0

idx.bad153:                                       ; preds = %for.body142
  tail call void @__polaron_fail(ptr nonnull @.fail.4, ptr nonnull @.faila.20, i64 %41, ptr nonnull @.failb.21, i64 262144, i32 70)
  unreachable

idx.ok154:                                        ; preds = %for.body142
  %arr.elem156 = getelementptr inbounds double, ptr %arr.data11, i64 %41
  store double 0.000000e+00, ptr %arr.elem156, align 8
  %indvars.iv.next576 = add nuw nsw i64 %indvars.iv575, 1
  %exitcond577.not = icmp eq i64 %indvars.iv.next576, 512
  br i1 %exitcond577.not, label %sc.rhs170.preheader, label %for.body142

for.end160:                                       ; preds = %if.end215
  %indvar.next = add nuw nsw i64 %indvar, 1
  %exitcond589.not = icmp eq i64 %indvar.next, 512
  br i1 %exitcond589.not, label %div.ok329, label %sc.rhs108

sc.rhs170:                                        ; preds = %sc.rhs170.preheader, %if.end215
  %indvars.iv584 = phi i64 [ %indvars.iv.next585, %if.end215 ], [ 0, %sc.rhs170.preheader ]
  %.pre = shl nuw nsw i64 %indvars.iv584, 9
  %42 = or i64 %indvar, %indvars.iv584
  %or.cond.not = icmp ult i64 %42, 512
  %43 = or disjoint i64 %indvars.iv584, %38
  br i1 %or.cond.not, label %for.cond217.preheader, label %if.else214

for.cond217.preheader:                            ; preds = %sc.rhs170
  %arr.oob240.not = icmp ult i64 %43, 262144
  br i1 %arr.oob240.not, label %for.cond217.preheader.split, label %idx.bad241, !prof !0

for.cond217.preheader.split:                      ; preds = %for.cond217.preheader
  %arr.elem244 = getelementptr inbounds double, ptr %arr.data3, i64 %43
  %elem245 = load double, ptr %arr.elem244, align 8
  br label %for.body218

if.else214:                                       ; preds = %sc.rhs170
  %arr.elem290 = getelementptr inbounds double, ptr %arr.data3, i64 %43
  %arr.oob286.not = icmp ult i64 %43, 262144
  br label %for.body255

if.end215:                                        ; preds = %idx.ok299, %for.body218
  %indvars.iv.next585 = add nuw nsw i64 %indvars.iv584, 1
  %exitcond587.not = icmp eq i64 %indvars.iv.next585, 512
  br i1 %exitcond587.not, label %for.end160, label %sc.rhs170

for.body218:                                      ; preds = %for.cond217.preheader.split, %for.body218
  %indvars.iv578 = phi i64 [ 0, %for.cond217.preheader.split ], [ %indvars.iv.next579, %for.body218 ]
  %44 = or disjoint i64 %indvars.iv578, %38
  %arr.elem228 = getelementptr inbounds double, ptr %arr.data11, i64 %44
  %elem = load double, ptr %arr.elem228, align 8
  %45 = or disjoint i64 %indvars.iv578, %.pre
  %arr.elem251 = getelementptr inbounds double, ptr %arr.data7, i64 %45
  %elem252 = load double, ptr %arr.elem251, align 8
  %46 = fmul double %elem245, %elem252
  %47 = fadd double %elem, %46
  store double %47, ptr %arr.elem228, align 8
  %indvars.iv.next579 = add nuw nsw i64 %indvars.iv578, 1
  %exitcond580.not = icmp eq i64 %indvars.iv.next579, 512
  br i1 %exitcond580.not, label %if.end215, label %for.body218

idx.bad241:                                       ; preds = %for.cond217.preheader
  tail call void @__polaron_fail(ptr nonnull @.fail.19, ptr nonnull @.faila.20, i64 %43, ptr nonnull @.failb.21, i64 262144, i32 70)
  unreachable

for.body255:                                      ; preds = %if.else214, %idx.ok299
  %indvars.iv581 = phi i64 [ 0, %if.else214 ], [ %indvars.iv.next582, %idx.ok299 ]
  %48 = or disjoint i64 %indvars.iv581, %38
  %arr.oob265.not = icmp ult i64 %48, 262144
  br i1 %arr.oob265.not, label %idx.ok267, label %idx.bad266, !prof !0

idx.bad266:                                       ; preds = %for.body255
  tail call void @__polaron_fail(ptr nonnull @.fail.19, ptr nonnull @.faila.20, i64 %48, ptr nonnull @.failb.21, i64 262144, i32 70)
  unreachable

idx.ok267:                                        ; preds = %for.body255
  %arr.elem269 = getelementptr inbounds double, ptr %arr.data11, i64 %48
  %elem280 = load double, ptr %arr.elem269, align 8
  br i1 %arr.oob286.not, label %idx.ok288, label %idx.bad287, !prof !0

idx.bad287:                                       ; preds = %idx.ok267
  tail call void @__polaron_fail(ptr nonnull @.fail.19, ptr nonnull @.faila.20, i64 %43, ptr nonnull @.failb.21, i64 262144, i32 70)
  unreachable

idx.ok288:                                        ; preds = %idx.ok267
  %49 = add nuw nsw i64 %indvars.iv581, %.pre
  %arr.oob297.not = icmp ult i64 %49, 262144
  br i1 %arr.oob297.not, label %idx.ok299, label %idx.bad298, !prof !0

idx.bad298:                                       ; preds = %idx.ok288
  tail call void @__polaron_fail(ptr nonnull @.fail.19, ptr nonnull @.faila.20, i64 %49, ptr nonnull @.failb.21, i64 262144, i32 70)
  unreachable

idx.ok299:                                        ; preds = %idx.ok288
  %elem291 = load double, ptr %arr.elem290, align 8
  %arr.elem301 = getelementptr inbounds double, ptr %arr.data7, i64 %49
  %elem302 = load double, ptr %arr.elem301, align 8
  %50 = fmul double %elem291, %elem302
  %51 = fadd double %elem280, %50
  store double %51, ptr %arr.elem269, align 8
  %indvars.iv.next582 = add nuw nsw i64 %indvars.iv581, 1
  %exitcond583.not = icmp eq i64 %indvars.iv.next582, 512
  br i1 %exitcond583.not, label %if.end215, label %for.body255

if.end313:                                        ; preds = %div.ok329
  %52 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.str, i32 %55)
  tail call void @__polaron_free(ptr nonnull %arr)
  tail call void @__polaron_free(ptr nonnull %arr6)
  tail call void @__polaron_free(ptr nonnull %arr10)
  ret i32 0

div.ok329:                                        ; preds = %for.end160, %div.ok329
  %indvars.iv593 = phi i64 [ %indvars.iv.next594, %div.ok329 ], [ 0, %for.end160 ]
  %acc.1531 = phi i32 [ %55, %div.ok329 ], [ 0, %for.end160 ]
  %arr.elem326 = getelementptr inbounds double, ptr %arr.data11, i64 %indvars.iv593
  %elem327 = load double, ptr %arr.elem326, align 8
  %53 = tail call i32 @llvm.fptosi.sat.i32.f64(double %elem327)
  %54 = add i32 %53, %acc.1531
  %55 = srem i32 %54, 1000000007
  %indvars.iv.next594 = add nuw nsw i64 %indvars.iv593, 1
  %exitcond595.not = icmp eq i64 %indvars.iv.next594, 262144
  br i1 %exitcond595.not, label %if.end313, label %div.ok329
}

declare noalias ptr @__polaron_malloc(i64) local_unnamed_addr

; Function Attrs: mustprogress nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr nocapture) local_unnamed_addr #0

declare i32 @__CxxFrameHandler3(...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #2

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #3

declare void @__polaron_free(ptr) local_unnamed_addr

declare void @__polaron_str_free(ptr) local_unnamed_addr

declare ptr @__polaron_str_copy(ptr) local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #4

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #5

attributes #0 = { mustprogress nofree nounwind willreturn memory(argmem: read) }
attributes #1 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nofree nounwind }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!0 = !{!"branch_weights", i32 1048576, i32 1}
