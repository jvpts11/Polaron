; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_affine.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_affine.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private unnamed_addr global ptr null
@Test.skipWhy = private unnamed_addr global ptr null
@.fail = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_affine.pol:16:69  in Main.blit\0A\00", align 1
@.fail.1 = private unnamed_addr constant [138 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_affine.pol:21:49  in Main.scaleAdd\0A\00", align 1
@.fail.13 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_affine.pol:28:25  in Main.matmul\0A\00", align 1
@.fail.34 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_affine.pol:47:61  in main\0A\00", align 1
@.fail.37 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/bce_affine.pol:48:61  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [8 x i8] c"sum=%d\0A\00", align 1
@.strdata.5488 = private constant [1 x i8] zeroinitializer
@.strobj.5489 = private global %String { i64 0, ptr @.strdata.5488, i64 0 }
@.strdata.5490 = private constant [1 x i8] zeroinitializer
@.strobj.5491 = private global %String { i64 0, ptr @.strdata.5490, i64 0 }

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
  br i1 %7, label %argv.body, label %for.body.i.preheader

argv.body:                                        ; preds = %entry, %argv.body
  %argv.i.0317 = phi i64 [ %8, %argv.body ], [ 0, %entry ]
  %8 = add nuw nsw i64 %argv.i.0317, 1
  %9 = getelementptr ptr, ptr %1, i64 %8
  %argv.s = load ptr, ptr %9, align 8
  %argv.rawlen = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %argv.s)
  %newstr = tail call ptr @__polaron_malloc(i64 24)
  store i64 %argv.rawlen, ptr %newstr, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 1
  store ptr %argv.s, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 2
  store i64 0, ptr %11, align 8
  %12 = getelementptr ptr, ptr %arr.data, i64 %argv.i.0317
  store ptr %newstr, ptr %12, align 8
  %exitcond.not = icmp eq i64 %8, %4
  br i1 %exitcond.not, label %for.body.i.preheader, label %argv.body

for.body.i.preheader:                             ; preds = %argv.body, %entry
  %strcpy.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5489)
  %13 = load ptr, ptr @Test.criterion, align 8
  tail call void @__polaron_str_free(ptr %13)
  store ptr %strcpy.i, ptr @Test.criterion, align 8
  %strcpy1.i = tail call ptr @__polaron_str_copy(ptr nonnull @.strobj.5491)
  %14 = load ptr, ptr @Test.skipWhy, align 8
  tail call void @__polaron_str_free(ptr %14)
  store ptr %strcpy1.i, ptr @Test.skipWhy, align 8
  %arr = tail call ptr @__polaron_malloc(i64 1208)
  store i64 300, ptr %arr, align 8
  %arr.data2 = getelementptr i8, ptr %arr, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(1200) %arr.data2, i8 0, i64 1200, i1 false)
  br label %for.body.i

for.body.i:                                       ; preds = %for.body.i.preheader, %for.body.i
  %indvars.iv.i = phi i64 [ %indvars.iv.next.i, %for.body.i ], [ 0, %for.body.i.preheader ]
  %15 = trunc i64 %indvars.iv.i to i32
  %sext = shl i64 %indvars.iv.i, 32
  %16 = ashr exact i64 %sext, 32
  %arr.elem.i = getelementptr inbounds i32, ptr %arr.data2, i64 %16
  store i32 %15, ptr %arr.elem.i, align 4
  %indvars.iv.next.i = add nuw nsw i64 %indvars.iv.i, 1
  %exitcond.not.i = icmp eq i64 %indvars.iv.next.i, 100
  br i1 %exitcond.not.i, label %Main.blit.exit, label %for.body.i

idx.bad.i:                                        ; preds = %for.body19.i.1, %for.body19.i.2
  %.lcssa359 = phi i64 [ %30, %for.body19.i.2 ], [ %23, %for.body19.i.1 ]
  %arr.len.i.lcssa = phi i64 [ %arr.len.i.2, %for.body19.i.2 ], [ %arr.len.i.1, %for.body19.i.1 ]
  tail call void @__polaron_fail(ptr nonnull @.fail, ptr nonnull @.faila.38, i64 %.lcssa359, ptr nonnull @.failb.39, i64 %arr.len.i.lcssa, i32 70)
  unreachable

Main.blit.exit:                                   ; preds = %for.body.i
  %len7.i.1.pre = load i64, ptr %arr, align 8
  %17 = trunc i64 %len7.i.1.pre to i32
  %.not.i.1 = icmp slt i32 %17, 200
  br i1 %.not.i.1, label %for.body19.i.1, label %for.body.i.1

for.body.i.1:                                     ; preds = %Main.blit.exit, %for.body.i.1
  %indvars.iv.i.1 = phi i64 [ %indvars.iv.next.i.1, %for.body.i.1 ], [ 0, %Main.blit.exit ]
  %18 = trunc i64 %indvars.iv.i.1 to i32
  %19 = add nuw nsw i32 %18, 100
  %20 = sext i32 %19 to i64
  %arr.elem.i.1 = getelementptr inbounds i32, ptr %arr.data2, i64 %20
  store i32 %19, ptr %arr.elem.i.1, align 4
  %indvars.iv.next.i.1 = add nuw nsw i64 %indvars.iv.i.1, 1
  %exitcond.not.i.1 = icmp eq i64 %indvars.iv.next.i.1, 100
  br i1 %exitcond.not.i.1, label %Main.blit.exit.1, label %for.body.i.1

for.body19.i.1:                                   ; preds = %Main.blit.exit, %idx.ok.i.1
  %indvars.iv51.i.1 = phi i64 [ %indvars.iv.next52.i.1, %idx.ok.i.1 ], [ 0, %Main.blit.exit ]
  %21 = trunc i64 %indvars.iv51.i.1 to i32
  %22 = add nuw i32 %21, 100
  %23 = sext i32 %22 to i64
  %arr.len.i.1 = load i64, ptr %arr, align 8
  %arr.oob.not.i.1 = icmp ugt i64 %arr.len.i.1, %23
  br i1 %arr.oob.not.i.1, label %idx.ok.i.1, label %idx.bad.i, !prof !0

idx.ok.i.1:                                       ; preds = %for.body19.i.1
  %arr.elem28.i.1 = getelementptr inbounds i32, ptr %arr.data2, i64 %23
  store i32 %22, ptr %arr.elem28.i.1, align 4
  %indvars.iv.next52.i.1 = add nuw nsw i64 %indvars.iv51.i.1, 1
  %exitcond53.not.i.1 = icmp eq i64 %indvars.iv.next52.i.1, 100
  br i1 %exitcond53.not.i.1, label %Main.blit.exit.1, label %for.body19.i.1

Main.blit.exit.1:                                 ; preds = %for.body.i.1, %idx.ok.i.1
  %len7.i.2 = load i64, ptr %arr, align 8
  %24 = trunc i64 %len7.i.2 to i32
  %.not.i.2 = icmp slt i32 %24, 300
  br i1 %.not.i.2, label %for.body19.i.2, label %for.body.i.2

for.body.i.2:                                     ; preds = %Main.blit.exit.1, %for.body.i.2
  %indvars.iv.i.2 = phi i64 [ %indvars.iv.next.i.2, %for.body.i.2 ], [ 0, %Main.blit.exit.1 ]
  %25 = trunc i64 %indvars.iv.i.2 to i32
  %26 = add nuw nsw i32 %25, 200
  %27 = sext i32 %26 to i64
  %arr.elem.i.2 = getelementptr inbounds i32, ptr %arr.data2, i64 %27
  store i32 %26, ptr %arr.elem.i.2, align 4
  %indvars.iv.next.i.2 = add nuw nsw i64 %indvars.iv.i.2, 1
  %exitcond.not.i.2 = icmp eq i64 %indvars.iv.next.i.2, 100
  br i1 %exitcond.not.i.2, label %Main.blit.exit.2, label %for.body.i.2

for.body19.i.2:                                   ; preds = %Main.blit.exit.1, %idx.ok.i.2
  %indvars.iv51.i.2 = phi i64 [ %indvars.iv.next52.i.2, %idx.ok.i.2 ], [ 0, %Main.blit.exit.1 ]
  %28 = trunc i64 %indvars.iv51.i.2 to i32
  %29 = add nuw i32 %28, 200
  %30 = sext i32 %29 to i64
  %arr.len.i.2 = load i64, ptr %arr, align 8
  %arr.oob.not.i.2 = icmp ugt i64 %arr.len.i.2, %30
  br i1 %arr.oob.not.i.2, label %idx.ok.i.2, label %idx.bad.i, !prof !0

idx.ok.i.2:                                       ; preds = %for.body19.i.2
  %arr.elem28.i.2 = getelementptr inbounds i32, ptr %arr.data2, i64 %30
  store i32 %29, ptr %arr.elem28.i.2, align 4
  %indvars.iv.next52.i.2 = add nuw nsw i64 %indvars.iv51.i.2, 1
  %exitcond53.not.i.2 = icmp eq i64 %indvars.iv.next52.i.2, 100
  br i1 %exitcond53.not.i.2, label %Main.blit.exit.2, label %for.body19.i.2

Main.blit.exit.2:                                 ; preds = %for.body.i.2, %idx.ok.i.2
  %arr8 = tail call ptr @__polaron_malloc(i64 408)
  store i64 100, ptr %arr8, align 8
  %arr.data9 = getelementptr i8, ptr %arr8, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(400) %arr.data9, i8 0, i64 400, i1 false)
  br label %for.body12

if.end:                                           ; preds = %for.body12
  %len10.i = load i64, ptr %arr, align 8
  %31 = trunc i64 %len10.i to i32
  %32 = icmp sgt i32 %31, 299
  br i1 %32, label %while.cond.preheader.i, label %if.else.i272

while.cond.preheader.i:                           ; preds = %if.end
  %invariant.gep.i = getelementptr i8, ptr %arr, i64 808
  br label %while.body.i

if.else.i272:                                     ; preds = %if.end
  %umax.i = tail call i64 @llvm.umax.i64(i64 %len10.i, i64 200)
  %33 = add i64 %umax.i, -200
  br label %while.body54.i

while.body.i:                                     ; preds = %while.body.i, %while.cond.preheader.i
  %indvars.iv120.i = phi i64 [ 0, %while.cond.preheader.i ], [ %indvars.iv.next121.i, %while.body.i ]
  %gep.i = getelementptr i32, ptr %invariant.gep.i, i64 %indvars.iv120.i
  %elem.i = load i32, ptr %gep.i, align 4
  %arr.elem50.i = getelementptr inbounds i32, ptr %arr.data9, i64 %indvars.iv120.i
  %elem51.i = load i32, ptr %arr.elem50.i, align 4
  %34 = shl i32 %elem51.i, 1
  %35 = add i32 %34, %elem.i
  store i32 %35, ptr %gep.i, align 4
  %indvars.iv.next121.i = add nuw nsw i64 %indvars.iv120.i, 1
  %exitcond122.not.i = icmp eq i64 %indvars.iv.next121.i, 100
  br i1 %exitcond122.not.i, label %div.ok.preheader, label %while.body.i

while.body54.i:                                   ; preds = %idx.ok78.i, %if.else.i272
  %indvars.iv.i273 = phi i64 [ 0, %if.else.i272 ], [ %indvars.iv.next.i276, %idx.ok78.i ]
  %36 = add nuw nsw i64 %indvars.iv.i273, 200
  %exitcond.not.i274 = icmp eq i64 %indvars.iv.i273, %33
  br i1 %exitcond.not.i274, label %idx.bad.i277, label %idx.ok78.i, !prof !1

idx.bad.i277:                                     ; preds = %while.body54.i
  tail call void @__polaron_fail(ptr nonnull @.fail.1, ptr nonnull @.faila.38, i64 %36, ptr nonnull @.failb.39, i64 %len10.i, i32 70)
  unreachable

idx.ok78.i:                                       ; preds = %while.body54.i
  %arr.elem62.i = getelementptr inbounds i32, ptr %arr.data2, i64 %36
  %elem72.i = load i32, ptr %arr.elem62.i, align 4
  %arr.elem80.i = getelementptr inbounds i32, ptr %arr.data9, i64 %indvars.iv.i273
  %elem81.i = load i32, ptr %arr.elem80.i, align 4
  %37 = shl i32 %elem81.i, 1
  %38 = add i32 %37, %elem72.i
  store i32 %38, ptr %arr.elem62.i, align 4
  %indvars.iv.next.i276 = add nuw nsw i64 %indvars.iv.i273, 1
  %exitcond119.not.i = icmp eq i64 %indvars.iv.next.i276, 100
  br i1 %exitcond119.not.i, label %div.ok.preheader, label %while.body54.i

for.body12:                                       ; preds = %Main.blit.exit.2, %for.body12
  %indvars.iv = phi i64 [ 0, %Main.blit.exit.2 ], [ %indvars.iv.next, %for.body12 ]
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 %indvars.iv
  %39 = trunc i64 %indvars.iv to i32
  store i32 %39, ptr %arr.elem, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond367.not = icmp eq i64 %indvars.iv.next, 100
  br i1 %exitcond367.not, label %if.end, label %for.body12

div.ok.preheader:                                 ; preds = %idx.ok78.i, %while.body.i
  %arr35 = tail call ptr @__polaron_malloc(i64 264)
  store i64 64, ptr %arr35, align 8
  %arr.data36 = getelementptr i8, ptr %arr35, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(256) %arr.data36, i8 0, i64 256, i1 false)
  %arr39 = tail call ptr @__polaron_malloc(i64 264)
  store i64 64, ptr %arr39, align 8
  %arr.data40 = getelementptr i8, ptr %arr39, i64 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(256) %arr.data40, i8 0, i64 256, i1 false)
  %arr43 = tail call ptr @__polaron_malloc(i64 264)
  store i64 64, ptr %arr43, align 8
  %arr.data44 = getelementptr i8, ptr %arr43, i64 8
  br label %div.ok

if.end.i:                                         ; preds = %div.ok
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(256) %arr.data44, i8 0, i64 256, i1 false)
  br label %for.cond27.preheader.i

for.cond27.preheader.i:                           ; preds = %for.end30.i, %if.end.i
  %indvars.iv376 = phi i64 [ %indvars.iv.next377, %for.end30.i ], [ 0, %if.end.i ]
  %indvars.iv374 = phi i64 [ %indvars.iv.next375, %for.end30.i ], [ 0, %if.end.i ]
  %indvars.iv275.i = phi i64 [ %indvars.iv.next276.i, %for.end30.i ], [ 0, %if.end.i ]
  %umax = tail call i64 @llvm.umax.i64(i64 %indvars.iv374, i64 64)
  %40 = add i64 %umax, %indvars.iv376
  %41 = shl nuw nsw i64 %indvars.iv275.i, 3
  %arr.elem106.i = getelementptr inbounds i32, ptr %arr.data44, i64 %41
  %42 = or disjoint i64 %41, 1
  %arr.elem106.1.i = getelementptr inbounds i32, ptr %arr.data44, i64 %42
  %43 = or disjoint i64 %41, 2
  %arr.elem106.2.i = getelementptr inbounds i32, ptr %arr.data44, i64 %43
  %44 = or disjoint i64 %41, 3
  %arr.elem106.3.i = getelementptr inbounds i32, ptr %arr.data44, i64 %44
  %45 = or disjoint i64 %41, 4
  %arr.elem106.4.i = getelementptr inbounds i32, ptr %arr.data44, i64 %45
  %46 = or disjoint i64 %41, 5
  %arr.elem106.5.i = getelementptr inbounds i32, ptr %arr.data44, i64 %46
  %47 = or disjoint i64 %41, 6
  %arr.elem106.6.i = getelementptr inbounds i32, ptr %arr.data44, i64 %47
  %48 = or disjoint i64 %41, 7
  %arr.elem106.7.sink.i = getelementptr inbounds i32, ptr %arr.data44, i64 %48
  br label %for.body28.i

for.body28.i:                                     ; preds = %idx.ok40.i, %for.cond27.preheader.i
  %indvars.iv271.i = phi i64 [ 0, %for.cond27.preheader.i ], [ %indvars.iv.next272.i, %idx.ok40.i ]
  %49 = or disjoint i64 %indvars.iv271.i, %41
  %exitcond378.not = icmp eq i64 %indvars.iv271.i, %40
  br i1 %exitcond378.not, label %idx.bad39.i, label %idx.ok40.i, !prof !1

for.end30.i:                                      ; preds = %idx.ok40.i
  %indvars.iv.next276.i = add nuw nsw i64 %indvars.iv275.i, 1
  %exitcond278.not.i = icmp eq i64 %indvars.iv.next276.i, 8
  %indvars.iv.next375 = add nuw nsw i64 %indvars.iv374, 8
  %indvars.iv.next377 = add nsw i64 %indvars.iv376, -8
  br i1 %exitcond278.not.i, label %Main.matmul.exit, label %for.cond27.preheader.i

idx.bad39.i:                                      ; preds = %for.body28.i
  tail call void @__polaron_fail(ptr nonnull @.fail.13, ptr nonnull @.faila.38, i64 %49, ptr nonnull @.failb.39, i64 64, i32 70)
  unreachable

idx.ok40.i:                                       ; preds = %for.body28.i
  %arr.elem42.i = getelementptr inbounds i32, ptr %arr.data36, i64 %49
  %elem.i284 = load i32, ptr %arr.elem42.i, align 4
  %.pre.i = shl nuw nsw i64 %indvars.iv271.i, 3
  %elem113.i = load i32, ptr %arr.elem106.i, align 4
  %arr.elem120.i = getelementptr inbounds i32, ptr %arr.data40, i64 %.pre.i
  %elem121.i = load i32, ptr %arr.elem120.i, align 4
  %50 = mul i32 %elem121.i, %elem.i284
  %51 = add i32 %50, %elem113.i
  store i32 %51, ptr %arr.elem106.i, align 4
  %elem113.1.i = load i32, ptr %arr.elem106.1.i, align 4
  %52 = or disjoint i64 %.pre.i, 1
  %arr.elem120.1.i = getelementptr inbounds i32, ptr %arr.data40, i64 %52
  %elem121.1.i = load i32, ptr %arr.elem120.1.i, align 4
  %53 = mul i32 %elem121.1.i, %elem.i284
  %54 = add i32 %53, %elem113.1.i
  store i32 %54, ptr %arr.elem106.1.i, align 4
  %elem113.2.i = load i32, ptr %arr.elem106.2.i, align 4
  %55 = or disjoint i64 %.pre.i, 2
  %arr.elem120.2.i = getelementptr inbounds i32, ptr %arr.data40, i64 %55
  %elem121.2.i = load i32, ptr %arr.elem120.2.i, align 4
  %56 = mul i32 %elem121.2.i, %elem.i284
  %57 = add i32 %56, %elem113.2.i
  store i32 %57, ptr %arr.elem106.2.i, align 4
  %elem113.3.i = load i32, ptr %arr.elem106.3.i, align 4
  %58 = or disjoint i64 %.pre.i, 3
  %arr.elem120.3.i = getelementptr inbounds i32, ptr %arr.data40, i64 %58
  %elem121.3.i = load i32, ptr %arr.elem120.3.i, align 4
  %59 = mul i32 %elem121.3.i, %elem.i284
  %60 = add i32 %59, %elem113.3.i
  store i32 %60, ptr %arr.elem106.3.i, align 4
  %elem113.4.i = load i32, ptr %arr.elem106.4.i, align 4
  %61 = or disjoint i64 %.pre.i, 4
  %arr.elem120.4.i = getelementptr inbounds i32, ptr %arr.data40, i64 %61
  %elem121.4.i = load i32, ptr %arr.elem120.4.i, align 4
  %62 = mul i32 %elem121.4.i, %elem.i284
  %63 = add i32 %62, %elem113.4.i
  store i32 %63, ptr %arr.elem106.4.i, align 4
  %elem113.5.i = load i32, ptr %arr.elem106.5.i, align 4
  %64 = or disjoint i64 %.pre.i, 5
  %arr.elem120.5.i = getelementptr inbounds i32, ptr %arr.data40, i64 %64
  %elem121.5.i = load i32, ptr %arr.elem120.5.i, align 4
  %65 = mul i32 %elem121.5.i, %elem.i284
  %66 = add i32 %65, %elem113.5.i
  store i32 %66, ptr %arr.elem106.5.i, align 4
  %elem113.6.i = load i32, ptr %arr.elem106.6.i, align 4
  %67 = or disjoint i64 %.pre.i, 6
  %arr.elem120.6.i = getelementptr inbounds i32, ptr %arr.data40, i64 %67
  %elem121.6.i = load i32, ptr %arr.elem120.6.i, align 4
  %68 = mul i32 %elem121.6.i, %elem.i284
  %69 = add i32 %68, %elem113.6.i
  store i32 %69, ptr %arr.elem106.6.i, align 4
  %70 = or disjoint i64 %.pre.i, 7
  %elem113.7.sink.i = load i32, ptr %arr.elem106.7.sink.i, align 4
  %arr.elem120.7.i = getelementptr inbounds i32, ptr %arr.data40, i64 %70
  %elem121.7.i = load i32, ptr %arr.elem120.7.i, align 4
  %71 = mul i32 %elem121.7.i, %elem.i284
  %72 = add i32 %71, %elem113.7.sink.i
  store i32 %72, ptr %arr.elem106.7.sink.i, align 4
  %indvars.iv.next272.i = add nuw nsw i64 %indvars.iv271.i, 1
  %exitcond274.not.i = icmp eq i64 %indvars.iv.next272.i, 8
  br i1 %exitcond274.not.i, label %for.end30.i, label %for.body28.i

Main.matmul.exit:                                 ; preds = %for.end30.i
  %len128 = load i64, ptr %arr, align 8
  %73 = trunc i64 %len128 to i32
  %74 = icmp sgt i32 %73, 299
  br i1 %74, label %for.body136, label %for.body148.preheader

for.body148.preheader:                            ; preds = %Main.matmul.exit
  %.not = icmp ult i64 %len128, 300
  br label %for.body148

div.ok:                                           ; preds = %div.ok.preheader, %div.ok
  %indvars.iv371 = phi i64 [ 0, %div.ok.preheader ], [ %indvars.iv.next372, %div.ok ]
  %arr.elem75 = getelementptr inbounds i32, ptr %arr.data36, i64 %indvars.iv371
  %75 = trunc i64 %indvars.iv371 to i32
  %76 = and i32 %75, 3
  store i32 %76, ptr %arr.elem75, align 4
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data40, i64 %indvars.iv371
  %.lhs.trunc = trunc i64 %indvars.iv371 to i8
  %77 = urem i8 %.lhs.trunc, 3
  %.zext = zext nneg i8 %77 to i32
  store i32 %.zext, ptr %arr.elem80, align 4
  %indvars.iv.next372 = add nuw nsw i64 %indvars.iv371, 1
  %exitcond373.not = icmp eq i64 %indvars.iv.next372, 64
  br i1 %exitcond373.not, label %if.end.i, label %div.ok

for.body136:                                      ; preds = %Main.matmul.exit, %for.body136
  %indvars.iv382 = phi i64 [ %indvars.iv.next383, %for.body136 ], [ 0, %Main.matmul.exit ]
  %sum.0324 = phi i32 [ %78, %for.body136 ], [ 0, %Main.matmul.exit ]
  %arr.elem145 = getelementptr inbounds i32, ptr %arr.data2, i64 %indvars.iv382
  %elem = load i32, ptr %arr.elem145, align 4
  %78 = add i32 %elem, %sum.0324
  %indvars.iv.next383 = add nuw nsw i64 %indvars.iv382, 1
  %exitcond384.not = icmp eq i64 %indvars.iv.next383, 300
  br i1 %exitcond384.not, label %sc.rhs163, label %for.body136

for.body148:                                      ; preds = %for.body148.preheader, %idx.ok159
  %indvars.iv379 = phi i64 [ 0, %for.body148.preheader ], [ %indvars.iv.next380, %idx.ok159 ]
  %sum.1322 = phi i32 [ 0, %for.body148.preheader ], [ %79, %idx.ok159 ]
  br i1 %.not, label %idx.bad158, label %idx.ok159, !prof !1

idx.bad158:                                       ; preds = %for.body148
  tail call void @__polaron_fail(ptr nonnull @.fail.34, ptr nonnull @.faila.38, i64 %len128, ptr nonnull @.failb.39, i64 %len128, i32 70)
  unreachable

idx.ok159:                                        ; preds = %for.body148
  %arr.elem161 = getelementptr inbounds i32, ptr %arr.data2, i64 %indvars.iv379
  %elem162 = load i32, ptr %arr.elem161, align 4
  %79 = add i32 %elem162, %sum.1322
  %indvars.iv.next380 = add nuw nsw i64 %indvars.iv379, 1
  %exitcond381.not = icmp eq i64 %indvars.iv.next380, 300
  br i1 %exitcond381.not, label %sc.rhs163, label %for.body148

sc.rhs163:                                        ; preds = %idx.ok159, %for.body136
  %sum.2 = phi i32 [ %78, %for.body136 ], [ %79, %idx.ok159 ]
  %len168 = load i64, ptr %arr43, align 8
  %80 = trunc i64 %len168 to i32
  %81 = icmp sgt i32 %80, 63
  br i1 %81, label %for.body176, label %for.body190.preheader

for.body190.preheader:                            ; preds = %sc.rhs163
  %.not396 = icmp ult i64 %len168, 64
  br label %for.body190

if.end173:                                        ; preds = %idx.ok202, %for.body176
  %sum.3 = phi i32 [ %83, %for.body176 ], [ %84, %idx.ok202 ]
  %82 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.str, i32 %sum.3)
  tail call void @__polaron_free(ptr nonnull %arr)
  tail call void @__polaron_free(ptr nonnull %arr8)
  tail call void @__polaron_free(ptr nonnull %arr35)
  tail call void @__polaron_free(ptr nonnull %arr39)
  tail call void @__polaron_free(ptr nonnull %arr43)
  ret i32 0

for.body176:                                      ; preds = %sc.rhs163, %for.body176
  %indvars.iv389 = phi i64 [ %indvars.iv.next390, %for.body176 ], [ 0, %sc.rhs163 ]
  %sum.4328 = phi i32 [ %83, %for.body176 ], [ %sum.2, %sc.rhs163 ]
  %arr.elem186 = getelementptr inbounds i32, ptr %arr.data44, i64 %indvars.iv389
  %elem187 = load i32, ptr %arr.elem186, align 4
  %83 = add i32 %elem187, %sum.4328
  %indvars.iv.next390 = add nuw nsw i64 %indvars.iv389, 1
  %exitcond391.not = icmp eq i64 %indvars.iv.next390, 64
  br i1 %exitcond391.not, label %if.end173, label %for.body176

for.body190:                                      ; preds = %for.body190.preheader, %idx.ok202
  %indvars.iv385 = phi i64 [ 0, %for.body190.preheader ], [ %indvars.iv.next386, %idx.ok202 ]
  %sum.5326 = phi i32 [ %sum.2, %for.body190.preheader ], [ %84, %idx.ok202 ]
  br i1 %.not396, label %idx.bad201, label %idx.ok202, !prof !1

idx.bad201:                                       ; preds = %for.body190
  tail call void @__polaron_fail(ptr nonnull @.fail.37, ptr nonnull @.faila.38, i64 %len168, ptr nonnull @.failb.39, i64 %len168, i32 70)
  unreachable

idx.ok202:                                        ; preds = %for.body190
  %arr.elem204 = getelementptr inbounds i32, ptr %arr.data44, i64 %indvars.iv385
  %elem205 = load i32, ptr %arr.elem204, align 4
  %84 = add i32 %elem205, %sum.5326
  %indvars.iv.next386 = add nuw nsw i64 %indvars.iv385, 1
  %exitcond388.not = icmp eq i64 %indvars.iv.next386, 64
  br i1 %exitcond388.not, label %if.end173, label %for.body190
}

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) local_unnamed_addr #0

declare noalias ptr @__polaron_malloc(i64) local_unnamed_addr

; Function Attrs: mustprogress nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr nocapture) local_unnamed_addr #1

declare i32 @__CxxFrameHandler3(...)

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #2

declare void @__polaron_free(ptr) local_unnamed_addr

declare void @__polaron_str_free(ptr) local_unnamed_addr

declare ptr @__polaron_str_copy(ptr) local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #3

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { mustprogress nofree nounwind willreturn memory(argmem: read) }
attributes #2 = { nofree nounwind }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!0 = !{!"branch_weights", i32 1048576, i32 1}
!1 = !{!"branch_weights", i32 1, i32 1048576}
