; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/debug_info.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/debug_info.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [11 x i8] c"r=%d t=%d\0A\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define internal i32 @Calc.sumTo(i32 %0) !dbg !4 {
entry:
  %i = alloca i32, align 4
  %acc = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4, !dbg !12
  call void @llvm.dbg.declare(metadata ptr %n, metadata !9, metadata !DIExpression()), !dbg !13
  store i32 0, ptr %acc, align 4, !dbg !14
  call void @llvm.dbg.declare(metadata ptr %acc, metadata !10, metadata !DIExpression()), !dbg !14
  store i32 1, ptr %i, align 4, !dbg !15
  call void @llvm.dbg.declare(metadata ptr %i, metadata !11, metadata !DIExpression()), !dbg !15
  br label %for.cond, !dbg !15

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4, !dbg !15
  %n2 = load i32, ptr %n, align 4, !dbg !15
  %1 = icmp sle i32 %i1, %n2, !dbg !15
  %2 = zext i1 %1 to i32, !dbg !15
  br i1 %1, label %for.body, label %for.end, !dbg !15

for.body:                                         ; preds = %for.cond
  %acc3 = load i32, ptr %acc, align 4, !dbg !16
  %i4 = load i32, ptr %i, align 4, !dbg !16
  %3 = add i32 %acc3, %i4, !dbg !16
  store i32 %3, ptr %acc, align 4, !dbg !16
  br label %for.update, !dbg !16

for.update:                                       ; preds = %for.body
  %4 = load i32, ptr %i, align 4, !dbg !17
  %5 = add i32 %4, 1, !dbg !17
  store i32 %5, ptr %i, align 4, !dbg !17
  br label %for.cond, !dbg !17

for.end:                                          ; preds = %for.cond
  %acc5 = load i32, ptr %acc, align 4, !dbg !18
  ret i32 %acc5, !dbg !18
}

define internal i32 @Calc.addTwo(i32 %0, i32 %1) !dbg !19 {
entry:
  %s = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %0, ptr %a, align 4, !dbg !24
  call void @llvm.dbg.declare(metadata ptr %a, metadata !21, metadata !DIExpression()), !dbg !25
  store i32 %1, ptr %b, align 4, !dbg !24
  call void @llvm.dbg.declare(metadata ptr %b, metadata !22, metadata !DIExpression()), !dbg !26
  %a1 = load i32, ptr %a, align 4, !dbg !27
  %b2 = load i32, ptr %b, align 4, !dbg !27
  %2 = add i32 %a1, %b2, !dbg !27
  store i32 %2, ptr %s, align 4, !dbg !27
  call void @llvm.dbg.declare(metadata ptr %s, metadata !23, metadata !DIExpression()), !dbg !27
  %s3 = load i32, ptr %s, align 4, !dbg !28
  ret i32 %s3, !dbg !28
}

define i32 @main(i32 %0, ptr %1) !dbg !29 {
entry:
  %t = alloca i32, align 4, !dbg !35
  %r = alloca i32, align 4, !dbg !35
  %y = alloca i32, align 4, !dbg !35
  %x = alloca i32, align 4, !dbg !35
  %args = alloca ptr, align 8, !dbg !35
  %argv.i = alloca i64, align 8, !dbg !35
  %2 = sext i32 %0 to i64, !dbg !35
  %3 = sub i64 %2, 1, !dbg !35
  %4 = icmp slt i64 %3, 0, !dbg !35
  %5 = select i1 %4, i64 0, i64 %3, !dbg !35
  %6 = mul i64 %5, 8, !dbg !35
  %7 = add i64 8, %6, !dbg !35
  %argv.arr = call ptr @__polaron_malloc(i64 %7), !dbg !35
  store i64 %5, ptr %argv.arr, align 8, !dbg !35
  %arr.data = getelementptr i8, ptr %argv.arr, i64 8, !dbg !35
  store i64 0, ptr %argv.i, align 8, !dbg !35
  br label %argv.cond, !dbg !35

argv.cond:                                        ; preds = %argv.body, %entry
  %argv.iv = load i64, ptr %argv.i, align 8, !dbg !35
  %8 = icmp slt i64 %argv.iv, %5, !dbg !35
  br i1 %8, label %argv.body, label %argv.end, !dbg !35

argv.body:                                        ; preds = %argv.cond
  %9 = add i64 %argv.iv, 1, !dbg !35
  %10 = getelementptr ptr, ptr %1, i64 %9, !dbg !35
  %argv.s = load ptr, ptr %10, align 8, !dbg !35
  %argv.rawlen = call i64 @strlen(ptr %argv.s), !dbg !35
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64)), !dbg !35
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0, !dbg !35
  store i64 %argv.rawlen, ptr %11, align 8, !dbg !35
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1, !dbg !35
  store ptr %argv.s, ptr %12, align 8, !dbg !35
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2, !dbg !35
  store i64 0, ptr %13, align 8, !dbg !35
  %14 = getelementptr ptr, ptr %arr.data, i64 %argv.iv, !dbg !35
  store ptr %newstr, ptr %14, align 8, !dbg !35
  %15 = add i64 %argv.iv, 1, !dbg !35
  store i64 %15, ptr %argv.i, align 8, !dbg !35
  br label %argv.cond, !dbg !35

argv.end:                                         ; preds = %argv.cond
  store ptr %argv.arr, ptr %args, align 8, !dbg !35
  call void @Test.__onClassLoad(), !dbg !35
  store i32 10, ptr %x, align 4, !dbg !36
  call void @llvm.dbg.declare(metadata ptr %x, metadata !31, metadata !DIExpression()), !dbg !36
  store i32 32, ptr %y, align 4, !dbg !37
  call void @llvm.dbg.declare(metadata ptr %y, metadata !32, metadata !DIExpression()), !dbg !37
  %x1 = load i32, ptr %x, align 4, !dbg !38
  %y2 = load i32, ptr %y, align 4, !dbg !38
  %16 = call i32 @Calc.addTwo(i32 %x1, i32 %y2), !dbg !38
  store i32 %16, ptr %r, align 4, !dbg !38
  call void @llvm.dbg.declare(metadata ptr %r, metadata !33, metadata !DIExpression()), !dbg !38
  %17 = call i32 @Calc.sumTo(i32 5), !dbg !39
  store i32 %17, ptr %t, align 4, !dbg !39
  call void @llvm.dbg.declare(metadata ptr %t, metadata !34, metadata !DIExpression()), !dbg !39
  %r3 = load i32, ptr %r, align 4, !dbg !40
  %t4 = load i32, ptr %t, align 4, !dbg !40
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 %r3, i32 %t4), !dbg !40
  ret i32 0, !dbg !40
}

define internal void @Test.__onClassLoad() !dbg !41 {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306), !dbg !43
  %0 = load ptr, ptr @Test.criterion, align 8, !dbg !43
  call void @__polaron_str_free(ptr %0), !dbg !43
  store ptr %strcpy, ptr @Test.criterion, align 8, !dbg !43
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308), !dbg !44
  %1 = load ptr, ptr @Test.skipWhy, align 8, !dbg !44
  call void @__polaron_str_free(ptr %1), !dbg !44
  store ptr %strcpy1, ptr @Test.skipWhy, align 8, !dbg !44
  ret void, !dbg !44
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "polc", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug)
!1 = !DIFile(filename: "debug_info.pol", directory: "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = distinct !DISubprogram(name: "Calc.sumTo", linkageName: "Calc.sumTo", scope: !1, file: !1, line: 9, type: !5, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !8)
!5 = !DISubroutineType(types: !6)
!6 = !{!7}
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!9, !10, !11}
!9 = !DILocalVariable(name: "n", arg: 1, scope: !4, file: !1, line: 9, type: !7)
!10 = !DILocalVariable(name: "acc", scope: !4, file: !1, line: 10, type: !7)
!11 = !DILocalVariable(name: "i", scope: !4, file: !1, line: 11, type: !7)
!12 = !DILocation(line: 9, column: 59, scope: !4)
!13 = !DILocation(line: 9, column: 40, scope: !4)
!14 = !DILocation(line: 10, column: 17, scope: !4)
!15 = !DILocation(line: 11, column: 22, scope: !4)
!16 = !DILocation(line: 12, column: 25, scope: !4)
!17 = !DILocation(line: 11, column: 50, scope: !4)
!18 = !DILocation(line: 14, column: 17, scope: !4)
!19 = distinct !DISubprogram(name: "Calc.addTwo", linkageName: "Calc.addTwo", scope: !1, file: !1, line: 17, type: !5, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !20)
!20 = !{!21, !22, !23}
!21 = !DILocalVariable(name: "a", arg: 1, scope: !19, file: !1, line: 17, type: !7)
!22 = !DILocalVariable(name: "b", arg: 2, scope: !19, file: !1, line: 17, type: !7)
!23 = !DILocalVariable(name: "s", scope: !19, file: !1, line: 18, type: !7)
!24 = !DILocation(line: 17, column: 67, scope: !19)
!25 = !DILocation(line: 17, column: 41, scope: !19)
!26 = !DILocation(line: 17, column: 48, scope: !19)
!27 = !DILocation(line: 18, column: 17, scope: !19)
!28 = !DILocation(line: 19, column: 17, scope: !19)
!29 = distinct !DISubprogram(name: "main", linkageName: "main", scope: !1, file: !1, line: 24, type: !5, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !30)
!30 = !{!31, !32, !33, !34}
!31 = !DILocalVariable(name: "x", scope: !29, file: !1, line: 25, type: !7)
!32 = !DILocalVariable(name: "y", scope: !29, file: !1, line: 26, type: !7)
!33 = !DILocalVariable(name: "r", scope: !29, file: !1, line: 27, type: !7)
!34 = !DILocalVariable(name: "t", scope: !29, file: !1, line: 28, type: !7)
!35 = !DILocation(line: 24, column: 67, scope: !29)
!36 = !DILocation(line: 25, column: 17, scope: !29)
!37 = !DILocation(line: 26, column: 17, scope: !29)
!38 = !DILocation(line: 27, column: 17, scope: !29)
!39 = !DILocation(line: 28, column: 17, scope: !29)
!40 = !DILocation(line: 29, column: 41, scope: !29)
!41 = distinct !DISubprogram(name: "Test.__onClassLoad", linkageName: "Test.__onClassLoad", scope: !42, file: !42, line: 9291, type: !5, scopeLine: 9291, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0)
!42 = !DIFile(filename: "<prelude>", directory: "")
!43 = !DILocation(line: 9292, column: 32, scope: !41)
!44 = !DILocation(line: 9293, column: 30, scope: !41)
