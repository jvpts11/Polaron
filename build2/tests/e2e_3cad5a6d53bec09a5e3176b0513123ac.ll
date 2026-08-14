; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_direct.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_direct.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private unnamed_addr global ptr null
@Test.skipWhy = private unnamed_addr global ptr null
@.fail = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_direct.pol:17:38  in main\0A\00", align 1
@.fail.16 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/matmul_direct.pol:23:25  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [13 x i8] c"checksum=%d\0A\00", align 1
@.strdata.5470 = private constant [1 x i8] zeroinitializer
@.strobj.5471 = private global %String { i64 0, ptr @.strdata.5470, i64 0 }
@.strdata.5472 = private constant [1 x i8] zeroinitializer
@.strobj.5473 = private global %String { i64 0, ptr @.strdata.5472, i64 0 }

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
  %argv.i.0447 = phi i64 [ %8, %argv.body ], [ 0, %entry ]
  %8 = add nuw nsw i64 %argv.i.0447, 1
  %9 = getelementptr ptr, ptr %1, i64 %8
  %argv.s = load ptr, ptr %9, align 8
  %argv.rawlen = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %argv.s)
  %newstr = tail call ptr @__polaron_malloc(i64 24)
  store i64 %argv.rawlen, ptr %newstr, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 1
  store ptr %argv.s, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 2
  store i64 0, ptr %11, align 8
  %12 = getelementptr ptr, ptr %arr.data, i64 %argv.i.0447
  store ptr %newstr, ptr %12, align 8
  %exitcond.not = icmp eq i64 %8, %4
  br i1 %exitcond.not, label %argv.end, label %argv.body

argv.end:                                         ; preds = %argv.body, %entry
  %strcpy.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5471)
  %13 = load ptr, ptr @Test.criterion, align 8
  tail call void @__polaron_str_free(ptr %13)
  store ptr %strcpy.i, ptr @Test.criterion, align 8
  %strcpy1.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5473)
  %14 = load ptr, ptr @Test.skipWhy, align 8
  tail call void @__polaron_str_free(ptr %14)
  store ptr %strcpy1.i, ptr @Test.skipWhy, align 8
  %arr = tail call ptr @__polaron_malloc(i64 80008)
  store i64 10000, ptr %arr, align 8
  %arr.data3 = getelementptr i8, ptr %arr, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(80000) %arr.data3, i8 0, i64 80000, i1 false)
  %arr6 = tail call ptr @__polaron_malloc(i64 80008)
  store i64 10000, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(80000) %arr.data7, i8 0, i64 80000, i1 false)
  %arr10 = tail call ptr @__polaron_malloc(i64 80008)
  store i64 10000, ptr %arr10, align 8
  %arr.data11 = getelementptr i8, ptr %arr10, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(80000) %arr.data11, i8 0, i64 80000, i1 false)
  br label %sc.rhs

sc.rhs:                                           ; preds = %argv.end, %if.end
  %indvars.iv493 = phi i64 [ 0, %argv.end ], [ %indvars.iv.next494, %if.end ]
  %15 = mul nuw nsw i64 %indvars.iv493, 100
  %.not429 = icmp ugt i64 %indvars.iv493, 99
  br i1 %.not429, label %for.body68, label %div.ok

if.end:                                           ; preds = %div.ok, %div.ok98
  %indvars.iv.next494 = add nuw nsw i64 %indvars.iv493, 1
  %exitcond496.not = icmp eq i64 %indvars.iv.next494, 100
  br i1 %exitcond496.not, label %for.cond108.preheader, label %sc.rhs

div.ok:                                           ; preds = %sc.rhs, %div.ok
  %indvars.iv = phi i64 [ %indvars.iv.next, %div.ok ], [ 0, %sc.rhs ]
  %16 = add nuw nsw i64 %indvars.iv, %indvars.iv493
  %17 = add nuw nsw i64 %indvars.iv, %15
  %arr.elem = getelementptr inbounds double, ptr %arr.data3, i64 %17
  %18 = trunc i64 %16 to i32
  %19 = urem i32 %18, 7
  %20 = sitofp i32 %19 to double
  %21 = fmul double %20, 5.000000e-01
  store double %21, ptr %arr.elem, align 8
  %22 = mul nuw nsw i64 %indvars.iv, %indvars.iv493
  %arr.elem59 = getelementptr inbounds double, ptr %arr.data7, i64 %17
  %23 = trunc i64 %22 to i32
  %24 = urem i32 %23, 11
  %25 = sitofp i32 %24 to double
  %26 = fmul double %25, 2.500000e-01
  store double %26, ptr %arr.elem59, align 8
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond489.not = icmp eq i64 %indvars.iv.next, 100
  br i1 %exitcond489.not, label %if.end, label %div.ok

for.body68:                                       ; preds = %sc.rhs, %div.ok98
  %indvars.iv490 = phi i64 [ %indvars.iv.next491, %div.ok98 ], [ 0, %sc.rhs ]
  %27 = add nuw nsw i64 %indvars.iv490, %15
  %arr.oob.not = icmp ult i64 %27, 10000
  br i1 %arr.oob.not, label %div.ok98, label %idx.bad, !prof !0

idx.bad:                                          ; preds = %for.body68
  tail call void @__polaron_fail(ptr nonnull @.fail, ptr nonnull @.faila.17, i64 %27, ptr nonnull @.failb.18, i64 10000, i32 70)
  unreachable

div.ok98:                                         ; preds = %for.body68
  %28 = add nuw nsw i64 %indvars.iv490, %indvars.iv493
  %arr.elem78 = getelementptr inbounds double, ptr %arr.data3, i64 %27
  %29 = trunc i64 %28 to i32
  %30 = urem i32 %29, 7
  %31 = sitofp i32 %30 to double
  %32 = fmul double %31, 5.000000e-01
  store double %32, ptr %arr.elem78, align 8
  %33 = mul nuw nsw i64 %indvars.iv490, %indvars.iv493
  %arr.elem94 = getelementptr inbounds double, ptr %arr.data7, i64 %27
  %34 = trunc i64 %33 to i32
  %35 = urem i32 %34, 11
  %36 = sitofp i32 %35 to double
  %37 = fmul double %36, 2.500000e-01
  store double %37, ptr %arr.elem94, align 8
  %indvars.iv.next491 = add nuw nsw i64 %indvars.iv490, 1
  %exitcond492.not = icmp eq i64 %indvars.iv.next491, 100
  br i1 %exitcond492.not, label %if.end, label %for.body68

for.cond108.preheader:                            ; preds = %if.end, %for.end111
  %indvars.iv507 = phi i64 [ %indvars.iv.next508, %for.end111 ], [ 0, %if.end ]
  %38 = mul nuw nsw i64 %indvars.iv507, 100
  %.not427 = icmp ugt i64 %indvars.iv507, 99
  %invariant.gep = getelementptr double, ptr %arr.data11, i64 %38
  br label %sc.rhs114

for.end111:                                       ; preds = %if.end166
  %indvars.iv.next508 = add nuw nsw i64 %indvars.iv507, 1
  %exitcond510.not = icmp eq i64 %indvars.iv.next508, 100
  br i1 %exitcond510.not, label %div.ok280, label %for.cond108.preheader

sc.rhs114:                                        ; preds = %for.cond108.preheader, %if.end166
  %indvars.iv503 = phi i64 [ 0, %for.cond108.preheader ], [ %indvars.iv.next504, %if.end166 ]
  %.pre = mul nuw nsw i64 %indvars.iv503, 100
  %.not = icmp ugt i64 %indvars.iv503, 99
  %or.cond = or i1 %.not427, %.not
  %39 = add nuw nsw i64 %indvars.iv503, %38
  br i1 %or.cond, label %if.else165, label %for.cond168.preheader

for.cond168.preheader:                            ; preds = %sc.rhs114
  %arr.oob191.not = icmp ult i64 %39, 10000
  br i1 %arr.oob191.not, label %for.cond168.preheader.split, label %idx.bad192, !prof !0

for.cond168.preheader.split:                      ; preds = %for.cond168.preheader
  %arr.elem195 = getelementptr inbounds double, ptr %arr.data3, i64 %39
  %elem196 = load double, ptr %arr.elem195, align 8
  %invariant.gep544 = getelementptr double, ptr %arr.data7, i64 %.pre
  br label %for.body169

if.else165:                                       ; preds = %sc.rhs114
  %arr.elem241 = getelementptr inbounds double, ptr %arr.data3, i64 %39
  %arr.oob237.not = icmp ult i64 %39, 10000
  br label %for.body206

if.end166:                                        ; preds = %for.body169, %idx.ok250
  %indvars.iv.next504 = add nuw nsw i64 %indvars.iv503, 1
  %exitcond506.not = icmp eq i64 %indvars.iv.next504, 100
  br i1 %exitcond506.not, label %for.end111, label %sc.rhs114

for.body169:                                      ; preds = %for.cond168.preheader.split, %for.body169
  %indvars.iv497 = phi i64 [ 0, %for.cond168.preheader.split ], [ %indvars.iv.next498, %for.body169 ]
  %gep = getelementptr double, ptr %invariant.gep, i64 %indvars.iv497
  %elem = load double, ptr %gep, align 8
  %gep545 = getelementptr double, ptr %invariant.gep544, i64 %indvars.iv497
  %elem203 = load double, ptr %gep545, align 8
  %40 = fmul double %elem196, %elem203
  %41 = fadd double %elem, %40
  store double %41, ptr %gep, align 8
  %indvars.iv.next498 = add nuw nsw i64 %indvars.iv497, 1
  %exitcond499.not = icmp eq i64 %indvars.iv.next498, 100
  br i1 %exitcond499.not, label %if.end166, label %for.body169

idx.bad192:                                       ; preds = %for.cond168.preheader
  tail call void @__polaron_fail(ptr nonnull @.fail.16, ptr nonnull @.faila.17, i64 %39, ptr nonnull @.failb.18, i64 10000, i32 70)
  unreachable

for.body206:                                      ; preds = %if.else165, %idx.ok250
  %indvars.iv500 = phi i64 [ 0, %if.else165 ], [ %indvars.iv.next501, %idx.ok250 ]
  %42 = add nuw nsw i64 %indvars.iv500, %38
  %arr.oob216.not = icmp ult i64 %42, 10000
  br i1 %arr.oob216.not, label %idx.ok218, label %idx.bad217, !prof !0

idx.bad217:                                       ; preds = %for.body206
  tail call void @__polaron_fail(ptr nonnull @.fail.16, ptr nonnull @.faila.17, i64 %42, ptr nonnull @.failb.18, i64 10000, i32 70)
  unreachable

idx.ok218:                                        ; preds = %for.body206
  %arr.elem220 = getelementptr inbounds double, ptr %arr.data11, i64 %42
  %elem231 = load double, ptr %arr.elem220, align 8
  br i1 %arr.oob237.not, label %idx.ok239, label %idx.bad238, !prof !0

idx.bad238:                                       ; preds = %idx.ok218
  tail call void @__polaron_fail(ptr nonnull @.fail.16, ptr nonnull @.faila.17, i64 %39, ptr nonnull @.failb.18, i64 10000, i32 70)
  unreachable

idx.ok239:                                        ; preds = %idx.ok218
  %43 = add nuw nsw i64 %indvars.iv500, %.pre
  %arr.oob248.not = icmp ult i64 %43, 10000
  br i1 %arr.oob248.not, label %idx.ok250, label %idx.bad249, !prof !0

idx.bad249:                                       ; preds = %idx.ok239
  tail call void @__polaron_fail(ptr nonnull @.fail.16, ptr nonnull @.faila.17, i64 %43, ptr nonnull @.failb.18, i64 10000, i32 70)
  unreachable

idx.ok250:                                        ; preds = %idx.ok239
  %elem242 = load double, ptr %arr.elem241, align 8
  %arr.elem252 = getelementptr inbounds double, ptr %arr.data7, i64 %43
  %elem253 = load double, ptr %arr.elem252, align 8
  %44 = fmul double %elem242, %elem253
  %45 = fadd double %elem231, %44
  store double %45, ptr %arr.elem220, align 8
  %indvars.iv.next501 = add nuw nsw i64 %indvars.iv500, 1
  %exitcond502.not = icmp eq i64 %indvars.iv.next501, 100
  br i1 %exitcond502.not, label %if.end166, label %for.body206

if.end264:                                        ; preds = %div.ok280
  %46 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.str, i32 %49)
  tail call void @__polaron_free(ptr nonnull %arr)
  tail call void @__polaron_free(ptr nonnull %arr6)
  tail call void @__polaron_free(ptr nonnull %arr10)
  ret i32 0

div.ok280:                                        ; preds = %for.end111, %div.ok280
  %indvars.iv514 = phi i64 [ %indvars.iv.next515, %div.ok280 ], [ 0, %for.end111 ]
  %acc.1459 = phi i32 [ %49, %div.ok280 ], [ 0, %for.end111 ]
  %arr.elem277 = getelementptr inbounds double, ptr %arr.data11, i64 %indvars.iv514
  %elem278 = load double, ptr %arr.elem277, align 8
  %47 = tail call i32 @llvm.fptosi.sat.i32.f64(double %elem278)
  %48 = add i32 %47, %acc.1459
  %49 = srem i32 %48, 1000000007
  %indvars.iv.next515 = add nuw nsw i64 %indvars.iv514, 1
  %exitcond516.not = icmp eq i64 %indvars.iv.next515, 10000
  br i1 %exitcond516.not, label %if.end264, label %div.ok280
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
