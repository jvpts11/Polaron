; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/recursion_opt.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/recursion_opt.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private unnamed_addr global ptr null
@Test.skipWhy = private unnamed_addr global ptr null
@.str = private unnamed_addr constant [24 x i8] c"fib=%d fact=%d even=%d\0A\00", align 1
@.strdata.5446 = private constant [1 x i8] zeroinitializer
@.strobj.5447 = private global %String { i64 0, ptr @.strdata.5446, i64 0 }
@.strdata.5448 = private constant [1 x i8] zeroinitializer
@.strobj.5449 = private global %String { i64 0, ptr @.strdata.5448, i64 0 }

; Function Attrs: nofree nosync nounwind memory(none)
define internal fastcc i32 @Main.fib(i32 %0) unnamed_addr #0 {
entry:
  %1 = icmp slt i32 %0, 2
  br i1 %1, label %common.ret, label %if.end

common.ret:                                       ; preds = %entry, %Main.fib.exit12
  %common.ret.op = phi i32 [ %227, %Main.fib.exit12 ], [ %0, %entry ]
  ret i32 %common.ret.op

if.end:                                           ; preds = %entry
  switch i32 %0, label %Main.fib.exit.i22 [
    i32 3, label %if.then.i10
    i32 2, label %if.then.i10
    i32 4, label %Main.fib.exit.i
  ]

Main.fib.exit.i22:                                ; preds = %if.end
  %2 = add nsw i32 %0, -4
  %3 = tail call fastcc i32 @Main.fib(i32 %2)
  %4 = add nsw i32 %0, -5
  %5 = tail call fastcc i32 @Main.fib(i32 %4)
  %6 = add i32 %5, %3
  %7 = icmp ult i32 %0, 6
  br i1 %7, label %Main.fib.exit124.thread, label %if.end.i7.i

if.end.i7.i:                                      ; preds = %Main.fib.exit.i22
  %8 = icmp eq i32 %0, 6
  %.pre592 = add nsw i32 %0, -6
  %9 = tail call fastcc i32 @Main.fib(i32 %.pre592)
  br i1 %8, label %if.end.i.i37.thread, label %if.end.i.i37

if.end.i.i37.thread:                              ; preds = %if.end.i7.i
  %10 = add i32 %6, 1
  %reass.add680 = shl i32 %9, 1
  %11 = add i32 %10, %reass.add680
  %12 = add i32 %11, 2
  br label %Main.fib.exit252

Main.fib.exit124.thread:                          ; preds = %Main.fib.exit.i22
  %factor591 = shl nuw nsw i32 %0, 1
  %13 = add nsw i32 %factor591, -8
  %14 = add i32 %13, %6
  br label %Main.fib.exit252

if.end.i.i37:                                     ; preds = %if.end.i7.i
  %15 = add nsw i32 %0, -7
  %16 = tail call fastcc i32 @Main.fib(i32 %15)
  %17 = add i32 %16, %9
  %18 = tail call fastcc i32 @Main.fib(i32 %.pre592)
  %19 = add i32 %17, %6
  %20 = add i32 %19, %18
  %cond = icmp eq i32 %0, 7
  br i1 %cond, label %Main.fib.exit.i40.thread633, label %Main.fib.exit.i22.i

Main.fib.exit.i40.thread633:                      ; preds = %if.end.i.i37
  %21 = add nsw i32 %0, -6
  br label %if.end.i.i73

Main.fib.exit.i22.i:                              ; preds = %if.end.i.i37
  %.pre594 = add nsw i32 %0, -7
  %22 = tail call fastcc i32 @Main.fib(i32 %.pre594)
  %23 = add nsw i32 %0, -8
  %24 = tail call fastcc i32 @Main.fib(i32 %23)
  %25 = add i32 %24, %22
  %26 = icmp ult i32 %0, 9
  br i1 %26, label %if.end.i.i.i46, label %if.end.i7.i.i

if.end.i7.i.i:                                    ; preds = %Main.fib.exit.i22.i
  %27 = icmp eq i32 %0, 9
  %.pre628 = add nsw i32 %0, -9
  %28 = tail call fastcc i32 @Main.fib(i32 %.pre628)
  br i1 %27, label %Main.fib.exit.i40.thread634, label %Main.fib.exit.i40

Main.fib.exit.i40.thread634:                      ; preds = %if.end.i7.i.i
  %29 = add i32 %28, 1
  br label %if.end.i.i.i46

Main.fib.exit.i40:                                ; preds = %if.end.i7.i.i
  %30 = add nsw i32 %0, -10
  %31 = tail call fastcc i32 @Main.fib(i32 %30)
  %32 = add i32 %31, %28
  %33 = tail call fastcc i32 @Main.fib(i32 %.pre628)
  %34 = add i32 %33, %32
  br label %if.end.i.i.i46

if.end.i.i.i46:                                   ; preds = %Main.fib.exit.i22.i, %Main.fib.exit.i40, %Main.fib.exit.i40.thread634
  %.sink671 = phi i32 [ %34, %Main.fib.exit.i40 ], [ %29, %Main.fib.exit.i40.thread634 ], [ %.pre594, %Main.fib.exit.i22.i ]
  %35 = add i32 %.sink671, %25
  %36 = add nsw i32 %0, -7
  %37 = tail call fastcc i32 @Main.fib(i32 %36)
  %38 = add nsw i32 %0, -8
  %39 = tail call fastcc i32 @Main.fib(i32 %38)
  %40 = add i32 %39, %37
  br label %if.end.i.i73

if.then.i10:                                      ; preds = %if.end, %if.end
  %41 = add nsw i32 %0, -2
  br label %Main.fib.exit12

if.end.i.i73:                                     ; preds = %Main.fib.exit.i40.thread633, %if.end.i.i.i46
  %.pn = phi i32 [ %21, %Main.fib.exit.i40.thread633 ], [ %35, %if.end.i.i.i46 ]
  %.pre-phi597 = phi i32 [ 0, %Main.fib.exit.i40.thread633 ], [ %36, %if.end.i.i.i46 ]
  %42 = phi i32 [ 1, %Main.fib.exit.i40.thread633 ], [ %40, %if.end.i.i.i46 ]
  %43 = add i32 %18, %.pn
  %44 = tail call fastcc i32 @Main.fib(i32 %.pre-phi597)
  %45 = add i32 %43, %20
  %46 = add i32 %45, %42
  %47 = add i32 %46, %44
  %48 = icmp ult i32 %0, 8
  br i1 %48, label %Main.fib.exit12.i219, label %if.end.i16.i76

if.end.i16.i76:                                   ; preds = %if.end.i.i73
  %49 = icmp eq i32 %0, 8
  %.pre598 = add nsw i32 %0, -8
  %50 = tail call fastcc i32 @Main.fib(i32 %.pre598)
  br i1 %49, label %if.end.i.i145.thread, label %Main.fib.exit.i22.i82

if.end.i.i145.thread:                             ; preds = %if.end.i16.i76
  %51 = add i32 %50, 3
  br label %Main.fib.exit12.i219

Main.fib.exit.i22.i82:                            ; preds = %if.end.i16.i76
  %52 = add nsw i32 %0, -9
  %53 = tail call fastcc i32 @Main.fib(i32 %52)
  %54 = add i32 %53, %50
  %55 = icmp ult i32 %0, 10
  br i1 %55, label %if.end.i.i145.thread648, label %if.end.i7.i.i85

if.end.i7.i.i85:                                  ; preds = %Main.fib.exit.i22.i82
  %56 = icmp eq i32 %0, 10
  %.pre620 = add nsw i32 %0, -10
  %57 = tail call fastcc i32 @Main.fib(i32 %.pre620)
  br i1 %56, label %if.end.i.i37.i.thread, label %if.end.i.i37.i

if.end.i.i37.i.thread:                            ; preds = %if.end.i7.i.i85
  %58 = add i32 %54, 1
  %59 = add i32 %58, %57
  %60 = add i32 %57, 1
  %61 = add i32 %59, %60
  %62 = add i32 %61, %52
  br label %Main.fib.exit.i22.i154

if.end.i.i145.thread648:                          ; preds = %Main.fib.exit.i22.i82
  %63 = add i32 %.pre598, %54
  %64 = add i32 %63, 1
  %65 = add nuw nsw i32 %64, %52
  %66 = tail call fastcc i32 @Main.fib(i32 %.pre598)
  %67 = add i32 %54, %65
  %68 = add i32 %67, %66
  br label %Main.fib.exit.i.i217

if.end.i.i37.i:                                   ; preds = %if.end.i7.i.i85
  %69 = add nsw i32 %0, -11
  %70 = tail call fastcc i32 @Main.fib(i32 %69)
  %71 = add i32 %70, %57
  %72 = tail call fastcc i32 @Main.fib(i32 %.pre620)
  %73 = add i32 %71, %54
  %74 = add i32 %73, %72
  %cond670 = icmp eq i32 %0, 11
  br i1 %cond670, label %Main.fib.exit.i40.i.thread641, label %Main.fib.exit.i22.i.i

Main.fib.exit.i40.i.thread641:                    ; preds = %if.end.i.i37.i
  %75 = add nsw i32 %0, -10
  br label %if.end.i.i145

Main.fib.exit.i22.i.i:                            ; preds = %if.end.i.i37.i
  %.pre622 = add nsw i32 %0, -11
  %76 = tail call fastcc i32 @Main.fib(i32 %.pre622)
  %77 = add nsw i32 %0, -12
  %78 = tail call fastcc i32 @Main.fib(i32 %77)
  %79 = add i32 %78, %76
  %80 = icmp ult i32 %0, 13
  br i1 %80, label %if.end.i.i.i46.i, label %if.end.i7.i.i.i

if.end.i7.i.i.i:                                  ; preds = %Main.fib.exit.i22.i.i
  %81 = icmp eq i32 %0, 13
  %.pre626 = add nsw i32 %0, -13
  %82 = tail call fastcc i32 @Main.fib(i32 %.pre626)
  br i1 %81, label %Main.fib.exit.i40.i.thread642, label %Main.fib.exit.i40.i

Main.fib.exit.i40.i.thread642:                    ; preds = %if.end.i7.i.i.i
  %83 = add i32 %82, 1
  br label %if.end.i.i.i46.i

Main.fib.exit.i40.i:                              ; preds = %if.end.i7.i.i.i
  %84 = add nsw i32 %0, -14
  %85 = tail call fastcc i32 @Main.fib(i32 %84)
  %86 = add i32 %85, %82
  %87 = tail call fastcc i32 @Main.fib(i32 %.pre626)
  %88 = add i32 %87, %86
  br label %if.end.i.i.i46.i

if.end.i.i.i46.i:                                 ; preds = %Main.fib.exit.i22.i.i, %Main.fib.exit.i40.i, %Main.fib.exit.i40.i.thread642
  %.sink672 = phi i32 [ %88, %Main.fib.exit.i40.i ], [ %83, %Main.fib.exit.i40.i.thread642 ], [ %.pre622, %Main.fib.exit.i22.i.i ]
  %89 = add i32 %.sink672, %79
  %90 = add nsw i32 %0, -11
  %91 = tail call fastcc i32 @Main.fib(i32 %90)
  %92 = add nsw i32 %0, -12
  %93 = tail call fastcc i32 @Main.fib(i32 %92)
  %94 = add i32 %93, %91
  br label %if.end.i.i145

if.end.i.i145:                                    ; preds = %if.end.i.i.i46.i, %Main.fib.exit.i40.i.thread641
  %.pn677 = phi i32 [ %75, %Main.fib.exit.i40.i.thread641 ], [ %89, %if.end.i.i.i46.i ]
  %.pre-phi625 = phi i32 [ 0, %Main.fib.exit.i40.i.thread641 ], [ %90, %if.end.i.i.i46.i ]
  %95 = phi i32 [ 1, %Main.fib.exit.i40.i.thread641 ], [ %94, %if.end.i.i.i46.i ]
  %96 = add i32 %72, %.pn677
  %97 = tail call fastcc i32 @Main.fib(i32 %.pre-phi625)
  %98 = add i32 %97, %95
  %99 = add i32 %74, %96
  %100 = add i32 %99, %98
  br label %Main.fib.exit.i22.i154

Main.fib.exit.i22.i154:                           ; preds = %if.end.i.i145, %if.end.i.i37.i.thread
  %.sink674 = phi i32 [ %100, %if.end.i.i145 ], [ %62, %if.end.i.i37.i.thread ]
  %101 = tail call fastcc i32 @Main.fib(i32 %.pre598)
  %102 = add i32 %54, %.sink674
  %103 = add i32 %102, %101
  %104 = add nsw i32 %0, -9
  %105 = tail call fastcc i32 @Main.fib(i32 %104)
  %106 = add nsw i32 %0, -10
  %107 = tail call fastcc i32 @Main.fib(i32 %106)
  %108 = add i32 %107, %105
  %109 = icmp eq i32 %0, 10
  br i1 %109, label %if.end.i.i.i214.thread586, label %if.end.i7.i.i157

if.end.i7.i.i157:                                 ; preds = %Main.fib.exit.i22.i154
  %110 = icmp eq i32 %0, 11
  %.pre602 = add nsw i32 %0, -11
  %111 = tail call fastcc i32 @Main.fib(i32 %.pre602)
  br i1 %110, label %if.end.i.i37.i172.thread, label %if.end.i.i37.i172

if.end.i.i37.i172.thread:                         ; preds = %if.end.i7.i.i157
  %112 = add i32 %108, 1
  %reass.add = shl i32 %111, 1
  %113 = add i32 %112, %reass.add
  %114 = add i32 %113, 2
  br label %Main.fib.exit12.i107.i

if.end.i.i.i214.thread586:                        ; preds = %Main.fib.exit.i22.i154
  %115 = add i32 %108, 2
  br label %Main.fib.exit124.i

if.end.i.i37.i172:                                ; preds = %if.end.i7.i.i157
  %116 = add nsw i32 %0, -12
  %117 = tail call fastcc i32 @Main.fib(i32 %116)
  %118 = add i32 %117, %111
  %119 = tail call fastcc i32 @Main.fib(i32 %.pre602)
  %120 = add i32 %118, %108
  %121 = add i32 %120, %119
  %cond668 = icmp eq i32 %0, 12
  br i1 %cond668, label %Main.fib.exit.i40.i195.thread657, label %Main.fib.exit.i22.i.i181

Main.fib.exit.i40.i195.thread657:                 ; preds = %if.end.i.i37.i172
  %122 = add nsw i32 %0, -11
  br label %if.end.i.i73.i

Main.fib.exit.i22.i.i181:                         ; preds = %if.end.i.i37.i172
  %.pre604 = add nsw i32 %0, -12
  %123 = tail call fastcc i32 @Main.fib(i32 %.pre604)
  %124 = add nsw i32 %0, -13
  %125 = tail call fastcc i32 @Main.fib(i32 %124)
  %126 = add i32 %125, %123
  %127 = icmp ult i32 %0, 14
  br i1 %127, label %if.end.i.i.i46.i201, label %if.end.i7.i.i.i184

if.end.i7.i.i.i184:                               ; preds = %Main.fib.exit.i22.i.i181
  %128 = icmp eq i32 %0, 14
  %.pre618 = add nsw i32 %0, -14
  %129 = tail call fastcc i32 @Main.fib(i32 %.pre618)
  br i1 %128, label %Main.fib.exit.i40.i195.thread658, label %Main.fib.exit.i40.i195

Main.fib.exit.i40.i195.thread658:                 ; preds = %if.end.i7.i.i.i184
  %130 = add i32 %129, 1
  br label %if.end.i.i.i46.i201

Main.fib.exit.i40.i195:                           ; preds = %if.end.i7.i.i.i184
  %131 = add nsw i32 %0, -15
  %132 = tail call fastcc i32 @Main.fib(i32 %131)
  %133 = add i32 %132, %129
  %134 = tail call fastcc i32 @Main.fib(i32 %.pre618)
  %135 = add i32 %134, %133
  br label %if.end.i.i.i46.i201

if.end.i.i.i46.i201:                              ; preds = %Main.fib.exit.i22.i.i181, %Main.fib.exit.i40.i195, %Main.fib.exit.i40.i195.thread658
  %.sink675 = phi i32 [ %135, %Main.fib.exit.i40.i195 ], [ %130, %Main.fib.exit.i40.i195.thread658 ], [ %.pre604, %Main.fib.exit.i22.i.i181 ]
  %136 = add i32 %.sink675, %126
  %137 = add nsw i32 %0, -12
  %138 = tail call fastcc i32 @Main.fib(i32 %137)
  %139 = add nsw i32 %0, -13
  %140 = tail call fastcc i32 @Main.fib(i32 %139)
  %141 = add i32 %140, %138
  br label %if.end.i.i73.i

if.end.i.i73.i:                                   ; preds = %Main.fib.exit.i40.i195.thread657, %if.end.i.i.i46.i201
  %.pn678 = phi i32 [ %122, %Main.fib.exit.i40.i195.thread657 ], [ %136, %if.end.i.i.i46.i201 ]
  %.pre-phi607 = phi i32 [ 0, %Main.fib.exit.i40.i195.thread657 ], [ %137, %if.end.i.i.i46.i201 ]
  %142 = phi i32 [ 1, %Main.fib.exit.i40.i195.thread657 ], [ %141, %if.end.i.i.i46.i201 ]
  %143 = add i32 %119, %.pn678
  %144 = tail call fastcc i32 @Main.fib(i32 %.pre-phi607)
  %145 = add i32 %143, %121
  %146 = add i32 %145, %142
  %147 = add i32 %146, %144
  %148 = icmp ult i32 %0, 13
  br i1 %148, label %Main.fib.exit12.i107.i, label %if.end.i16.i76.i

if.end.i16.i76.i:                                 ; preds = %if.end.i.i73.i
  %149 = icmp eq i32 %0, 13
  br i1 %149, label %Main.fib.exit.i.i105.i, label %Main.fib.exit.i22.i82.i

Main.fib.exit.i22.i82.i:                          ; preds = %if.end.i16.i76.i
  %150 = add nsw i32 %0, -13
  %151 = tail call fastcc i32 @Main.fib(i32 %150)
  %152 = add nsw i32 %0, -14
  %153 = tail call fastcc i32 @Main.fib(i32 %152)
  %154 = add i32 %153, %151
  %155 = icmp ult i32 %0, 15
  br i1 %155, label %Main.fib.exit.i40.i.i.thread, label %if.end.i7.i.i85.i

if.end.i7.i.i85.i:                                ; preds = %Main.fib.exit.i22.i82.i
  %156 = icmp eq i32 %0, 15
  %.pre610 = add nsw i32 %0, -15
  %157 = tail call fastcc i32 @Main.fib(i32 %.pre610)
  br i1 %156, label %if.end.i.i37.i.i.thread, label %if.end.i.i37.i.i

if.end.i.i37.i.i.thread:                          ; preds = %if.end.i7.i.i85.i
  %158 = add i32 %154, 1
  %159 = add i32 %158, %157
  %160 = add i32 %157, 1
  br label %if.end.i.i.i102.i

Main.fib.exit.i40.i.i.thread:                     ; preds = %Main.fib.exit.i22.i82.i
  %161 = add i32 %150, %154
  br label %if.end.i.i.i102.i

if.end.i.i37.i.i:                                 ; preds = %if.end.i7.i.i85.i
  %162 = add nsw i32 %0, -16
  %163 = tail call fastcc i32 @Main.fib(i32 %162)
  %164 = add i32 %163, %157
  %165 = tail call fastcc i32 @Main.fib(i32 %.pre610)
  %166 = add i32 %164, %154
  %167 = add i32 %166, %165
  %cond669 = icmp eq i32 %0, 16
  br i1 %cond669, label %Main.fib.exit.i40.i.i.thread665, label %Main.fib.exit.i22.i.i.i

Main.fib.exit.i40.i.i.thread665:                  ; preds = %if.end.i.i37.i.i
  %168 = add nsw i32 %0, -15
  br label %Main.fib.exit.i.i49.i.i

Main.fib.exit.i22.i.i.i:                          ; preds = %if.end.i.i37.i.i
  %.pre612 = add nsw i32 %0, -16
  %169 = tail call fastcc i32 @Main.fib(i32 %.pre612)
  %170 = add nsw i32 %0, -17
  %171 = tail call fastcc i32 @Main.fib(i32 %170)
  %172 = add i32 %171, %169
  %173 = icmp ult i32 %0, 18
  br i1 %173, label %if.end.i.i.i46.i.i, label %if.end.i7.i.i.i.i

if.end.i7.i.i.i.i:                                ; preds = %Main.fib.exit.i22.i.i.i
  %174 = icmp eq i32 %0, 18
  %.pre616 = add nsw i32 %0, -18
  %175 = tail call fastcc i32 @Main.fib(i32 %.pre616)
  br i1 %174, label %Main.fib.exit.i40.i.i.thread666, label %Main.fib.exit.i40.i.i

Main.fib.exit.i40.i.i.thread666:                  ; preds = %if.end.i7.i.i.i.i
  %176 = add i32 %175, 1
  br label %if.end.i.i.i46.i.i

Main.fib.exit.i40.i.i:                            ; preds = %if.end.i7.i.i.i.i
  %177 = add nsw i32 %0, -19
  %178 = tail call fastcc i32 @Main.fib(i32 %177)
  %179 = add i32 %178, %175
  %180 = tail call fastcc i32 @Main.fib(i32 %.pre616)
  %181 = add i32 %180, %179
  br label %if.end.i.i.i46.i.i

if.end.i.i.i46.i.i:                               ; preds = %Main.fib.exit.i22.i.i.i, %Main.fib.exit.i40.i.i, %Main.fib.exit.i40.i.i.thread666
  %.sink676 = phi i32 [ %181, %Main.fib.exit.i40.i.i ], [ %176, %Main.fib.exit.i40.i.i.thread666 ], [ %.pre612, %Main.fib.exit.i22.i.i.i ]
  %182 = add i32 %.sink676, %172
  %183 = add nsw i32 %0, -16
  %184 = tail call fastcc i32 @Main.fib(i32 %183)
  %185 = add nsw i32 %0, -17
  %186 = tail call fastcc i32 @Main.fib(i32 %185)
  %187 = add i32 %186, %184
  br label %Main.fib.exit.i.i49.i.i

Main.fib.exit.i.i49.i.i:                          ; preds = %Main.fib.exit.i40.i.i.thread665, %if.end.i.i.i46.i.i
  %.pn679 = phi i32 [ %168, %Main.fib.exit.i40.i.i.thread665 ], [ %182, %if.end.i.i.i46.i.i ]
  %.pre-phi615 = phi i32 [ 0, %Main.fib.exit.i40.i.i.thread665 ], [ %183, %if.end.i.i.i46.i.i ]
  %188 = phi i32 [ 1, %Main.fib.exit.i40.i.i.thread665 ], [ %187, %if.end.i.i.i46.i.i ]
  %189 = add i32 %165, %.pn679
  %190 = tail call fastcc i32 @Main.fib(i32 %.pre-phi615)
  %191 = add i32 %190, %188
  br label %if.end.i.i.i102.i

if.end.i.i.i102.i:                                ; preds = %Main.fib.exit.i40.i.i.thread, %if.end.i.i37.i.i.thread, %Main.fib.exit.i.i49.i.i
  %192 = phi i32 [ %189, %Main.fib.exit.i.i49.i.i ], [ 1, %Main.fib.exit.i40.i.i.thread ], [ %160, %if.end.i.i37.i.i.thread ]
  %193 = phi i32 [ %167, %Main.fib.exit.i.i49.i.i ], [ %161, %Main.fib.exit.i40.i.i.thread ], [ %159, %if.end.i.i37.i.i.thread ]
  %194 = phi i32 [ %191, %Main.fib.exit.i.i49.i.i ], [ 0, %Main.fib.exit.i40.i.i.thread ], [ 1, %if.end.i.i37.i.i.thread ]
  %195 = add i32 %193, %192
  %196 = add i32 %195, %194
  br label %Main.fib.exit.i.i105.i

Main.fib.exit.i.i105.i:                           ; preds = %if.end.i16.i76.i, %if.end.i.i.i102.i
  %.pre-phi609 = phi i32 [ %150, %if.end.i.i.i102.i ], [ 0, %if.end.i16.i76.i ]
  %197 = phi i32 [ %196, %if.end.i.i.i102.i ], [ 2, %if.end.i16.i76.i ]
  %198 = phi i32 [ %154, %if.end.i.i.i102.i ], [ 1, %if.end.i16.i76.i ]
  %199 = tail call fastcc i32 @Main.fib(i32 %.pre-phi609)
  %200 = add i32 %199, %198
  br label %Main.fib.exit12.i107.i

Main.fib.exit12.i107.i:                           ; preds = %if.end.i.i37.i172.thread, %if.end.i.i73.i, %Main.fib.exit.i.i105.i
  %201 = phi i32 [ %197, %Main.fib.exit.i.i105.i ], [ 1, %if.end.i.i73.i ], [ 1, %if.end.i.i37.i172.thread ]
  %202 = phi i32 [ %147, %Main.fib.exit.i.i105.i ], [ %147, %if.end.i.i73.i ], [ %114, %if.end.i.i37.i172.thread ]
  %203 = phi i32 [ %200, %Main.fib.exit.i.i105.i ], [ 1, %if.end.i.i73.i ], [ 0, %if.end.i.i37.i172.thread ]
  %204 = add i32 %203, %201
  br label %Main.fib.exit124.i

Main.fib.exit124.i:                               ; preds = %if.end.i.i.i214.thread586, %Main.fib.exit12.i107.i
  %205 = phi i32 [ %202, %Main.fib.exit12.i107.i ], [ %115, %if.end.i.i.i214.thread586 ]
  %206 = phi i32 [ %204, %Main.fib.exit12.i107.i ], [ 1, %if.end.i.i.i214.thread586 ]
  %207 = add i32 %107, %206
  br label %Main.fib.exit.i.i217

Main.fib.exit.i.i217:                             ; preds = %if.end.i.i145.thread648, %Main.fib.exit124.i
  %208 = phi i32 [ %68, %if.end.i.i145.thread648 ], [ %103, %Main.fib.exit124.i ]
  %.pre-phi601 = phi i32 [ 0, %if.end.i.i145.thread648 ], [ %104, %Main.fib.exit124.i ]
  %209 = phi i32 [ 2, %if.end.i.i145.thread648 ], [ %205, %Main.fib.exit124.i ]
  %210 = phi i32 [ 1, %if.end.i.i145.thread648 ], [ %207, %Main.fib.exit124.i ]
  %211 = tail call fastcc i32 @Main.fib(i32 %.pre-phi601)
  %212 = add i32 %211, %210
  br label %Main.fib.exit12.i219

Main.fib.exit12.i219:                             ; preds = %if.end.i.i73, %if.end.i.i145.thread, %Main.fib.exit.i.i217
  %213 = phi i32 [ %209, %Main.fib.exit.i.i217 ], [ 1, %if.end.i.i145.thread ], [ 1, %if.end.i.i73 ]
  %214 = phi i32 [ %208, %Main.fib.exit.i.i217 ], [ %51, %if.end.i.i145.thread ], [ 2, %if.end.i.i73 ]
  %215 = phi i32 [ %212, %Main.fib.exit.i.i217 ], [ %.pre-phi597, %if.end.i.i145.thread ], [ %.pre-phi597, %if.end.i.i73 ]
  %216 = add i32 %215, %213
  br label %Main.fib.exit252

Main.fib.exit252:                                 ; preds = %Main.fib.exit124.thread, %if.end.i.i37.thread, %Main.fib.exit12.i219
  %217 = phi i32 [ %214, %Main.fib.exit12.i219 ], [ 1, %if.end.i.i37.thread ], [ 1, %Main.fib.exit124.thread ]
  %218 = phi i32 [ %47, %Main.fib.exit12.i219 ], [ %12, %if.end.i.i37.thread ], [ %14, %Main.fib.exit124.thread ]
  %219 = phi i32 [ %216, %Main.fib.exit12.i219 ], [ 1, %if.end.i.i37.thread ], [ 0, %Main.fib.exit124.thread ]
  %220 = add i32 %219, %217
  br label %Main.fib.exit.i

Main.fib.exit.i:                                  ; preds = %if.end, %Main.fib.exit252
  %.pre-phi = phi i32 [ %2, %Main.fib.exit252 ], [ 0, %if.end ]
  %221 = phi i32 [ %218, %Main.fib.exit252 ], [ 2, %if.end ]
  %222 = phi i32 [ %220, %Main.fib.exit252 ], [ 1, %if.end ]
  %223 = tail call fastcc i32 @Main.fib(i32 %.pre-phi)
  %224 = add i32 %223, %222
  br label %Main.fib.exit12

Main.fib.exit12:                                  ; preds = %Main.fib.exit.i, %if.then.i10
  %225 = phi i32 [ 1, %if.then.i10 ], [ %221, %Main.fib.exit.i ]
  %226 = phi i32 [ %41, %if.then.i10 ], [ %224, %Main.fib.exit.i ]
  %227 = add i32 %226, %225
  br label %common.ret
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
  %argv.i.01 = phi i64 [ %8, %argv.body ], [ 0, %entry ]
  %8 = add nuw nsw i64 %argv.i.01, 1
  %9 = getelementptr ptr, ptr %1, i64 %8
  %argv.s = load ptr, ptr %9, align 8
  %argv.rawlen = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %argv.s)
  %newstr = tail call ptr @__polaron_malloc(i64 24)
  store i64 %argv.rawlen, ptr %newstr, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 1
  store ptr %argv.s, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i64 0, i32 2
  store i64 0, ptr %11, align 8
  %12 = getelementptr ptr, ptr %arr.data, i64 %argv.i.01
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
  %15 = tail call fastcc i32 @Main.fib(i32 20)
  %16 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.str, i32 %15, i32 479001600, i32 1)
  ret i32 0
}

declare noalias ptr @__polaron_malloc(i64) local_unnamed_addr

; Function Attrs: mustprogress nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr nocapture) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #2

declare void @__polaron_str_free(ptr) local_unnamed_addr

declare ptr @__polaron_str_copy(ptr) local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #3

attributes #0 = { nofree nosync nounwind memory(none) }
attributes #1 = { mustprogress nofree nounwind willreturn memory(argmem: read) }
attributes #2 = { nofree nounwind }
attributes #3 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
