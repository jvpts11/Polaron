; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/digraph.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/digraph.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.DiGraph = type { ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@DiGraph.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @DiGraph.addEdge, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @DiGraph.topoSort, ptr @DiGraph.hasCycle, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [35 x i8] c"order=%d,%d,%d,%d cnt=%d cycle=%d\0A\00", align 1
@.fail = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/digraph.pol:16:41  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/digraph.pol:16:41  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/digraph.pol:16:41  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [126 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/digraph.pol:16:41  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.10 = private unnamed_addr constant [13 x i8] c"cycleNow=%d\0A\00", align 1
@.fail.1818 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2392:89  in DiGraph.addEdge\0A\00", align 1
@.faila.1819 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1820 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1821 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2397:25  in DiGraph.topoSort\0A\00", align 1
@.faila.1822 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1823 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1824 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2397:71  in DiGraph.topoSort\0A\00", align 1
@.faila.1825 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1826 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1827 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2397:71  in DiGraph.topoSort\0A\00", align 1
@.faila.1828 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1829 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1830 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2407:25  in DiGraph.topoSort\0A\00", align 1
@.faila.1831 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1832 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1833 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2407:25  in DiGraph.topoSort\0A\00", align 1
@.faila.1834 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1835 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1836 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2412:36  in DiGraph.topoSort\0A\00", align 1
@.faila.1837 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1838 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1839 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2412:55  in DiGraph.topoSort\0A\00", align 1
@.faila.1840 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1841 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1842 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2414:29  in DiGraph.topoSort\0A\00", align 1
@.faila.1843 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1844 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1845 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2414:78  in DiGraph.topoSort\0A\00", align 1
@.faila.1846 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1847 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1848 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2414:78  in DiGraph.topoSort\0A\00", align 1
@.faila.1849 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1850 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5318 = private constant [1 x i8] zeroinitializer
@.strobj.5319 = private global %String { i64 0, ptr @.strdata.5318, i64 0 }
@.strdata.5320 = private constant [1 x i8] zeroinitializer
@.strobj.5321 = private global %String { i64 0, ptr @.strdata.5320, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %cnt = alloca i32, align 4
  %order = alloca ptr, align 8
  %g = alloca ptr, align 8
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
  %DiGraph.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DiGraph, ptr null, i64 1) to i64))
  call void @DiGraph.DiGraph(ptr %DiGraph.obj, i32 4)
  store ptr %DiGraph.obj, ptr %g, align 8
  %g1 = load ptr, ptr %g, align 8
  call void @DiGraph.addEdge(ptr %g1, i32 0, i32 1)
  %g2 = load ptr, ptr %g, align 8
  call void @DiGraph.addEdge(ptr %g2, i32 0, i32 2)
  %g3 = load ptr, ptr %g, align 8
  call void @DiGraph.addEdge(ptr %g3, i32 1, i32 3)
  %g4 = load ptr, ptr %g, align 8
  call void @DiGraph.addEdge(ptr %g4, i32 2, i32 3)
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data5 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data5, i32 0, i64 16)
  store ptr %arr, ptr %order, align 8
  %g6 = load ptr, ptr %g, align 8
  %order7 = load ptr, ptr %order, align 8
  %17 = call i32 @DiGraph.topoSort(ptr %g6, ptr %order7)
  store i32 %17, ptr %cnt, align 4
  %order8 = load ptr, ptr %order, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %order8, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data9 = getelementptr i8, ptr %order8, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %order10 = load ptr, ptr %order, align 8, !nonnull !0, !dereferenceable !1
  %arr.len11 = load i64, ptr %order10, align 8
  %arr.oob12 = icmp uge i64 1, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %order10, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 1
  %elem17 = load i32, ptr %arr.elem16, align 4
  %order18 = load ptr, ptr %order, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %order18, align 8
  %arr.oob20 = icmp uge i64 2, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok14
  %arr.data23 = getelementptr i8, ptr %order18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 2
  %elem25 = load i32, ptr %arr.elem24, align 4
  %order26 = load ptr, ptr %order, align 8, !nonnull !0, !dereferenceable !1
  %arr.len27 = load i64, ptr %order26, align 8
  %arr.oob28 = icmp uge i64 3, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !2

idx.bad29:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %idx.ok22
  %arr.data31 = getelementptr i8, ptr %order26, i64 8
  %arr.elem32 = getelementptr inbounds i32, ptr %arr.data31, i64 3
  %elem33 = load i32, ptr %arr.elem32, align 4
  %cnt34 = load i32, ptr %cnt, align 4
  %g35 = load ptr, ptr %g, align 8
  %18 = call i32 @DiGraph.hasCycle(ptr %g35)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %elem, i32 %elem17, i32 %elem25, i32 %elem33, i32 %cnt34, i32 %18)
  %g36 = load ptr, ptr %g, align 8
  call void @DiGraph.addEdge(ptr %g36, i32 3, i32 0)
  %g37 = load ptr, ptr %g, align 8
  %20 = call i32 @DiGraph.hasCycle(ptr %g37)
  %21 = call i32 (ptr, ...) @printf(ptr @.str.10, i32 %20)
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal void @DiGraph.DiGraph(ptr %0, i32 %1) {
entry:
  %vertices = alloca i32, align 4
  store i32 %1, ptr %vertices, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 0
  store ptr @DiGraph.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %adj = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 1
  store ptr null, ptr %adj, align 8, !tbaa !3
  %n = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %vertices1 = load i32, ptr %vertices, align 4
  store i32 %vertices1, ptr %n, align 4, !tbaa !7
  %adj2 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 1
  %vertices3 = load i32, ptr %vertices, align 4
  %vertices4 = load i32, ptr %vertices, align 4
  %2 = mul i32 %vertices3, %vertices4
  %3 = sext i32 %2 to i64
  %4 = mul i64 %3, 4
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %adj2, align 8, !tbaa !3
  ret void
}

define internal void @DiGraph.addEdge(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %v = alloca i32, align 4
  %u = alloca i32, align 4
  store i32 %1, ptr %u, align 4
  store i32 %2, ptr %v, align 4
  %adj = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 1
  %adj1 = load ptr, ptr %adj, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %u2 = load i32, ptr %u, align 4
  %n = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n3 = load i32, ptr %n, align 4, !tbaa !7
  %3 = mul i32 %u2, %n3
  %v4 = load i32, ptr %v, align 4
  %4 = add i32 %3, %v4
  %5 = sext i32 %4 to i64
  %arr.len = load i64, ptr %adj1, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1818, ptr @.faila.1819, i64 %5, ptr @.failb.1820, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %adj1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  store i32 1, ptr %arr.elem, align 4
  ret void
}

define internal i32 @DiGraph.topoSort(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %pick = alloca i32, align 4
  %progress = alloca i32, align 4
  %cnt = alloca i32, align 4
  %done = alloca ptr, align 8
  %v = alloca i32, align 4
  %u = alloca i32, align 4
  %indeg = alloca ptr, align 8
  %order = alloca ptr, align 8
  store ptr %1, ptr %order, align 8
  %n = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4, !tbaa !7
  %2 = sext i32 %n1 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %indeg, align 8
  store i32 0, ptr %u, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %u2 = load i32, ptr %u, align 4
  %n3 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n4 = load i32, ptr %n3, align 4, !tbaa !7
  %6 = icmp slt i32 %u2, %n4
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %v, align 4
  br label %for.cond5

for.update:                                       ; preds = %for.end8
  %8 = load i32, ptr %u, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %u, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %n35 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n36 = load i32, ptr %n35, align 4, !tbaa !7
  %10 = sext i32 %n36 to i64
  %11 = mul i64 %10, 1
  %12 = add i64 8, %11
  %arr37 = call ptr @__polaron_malloc(i64 %12)
  store i64 %10, ptr %arr37, align 8
  %arr.data38 = getelementptr i8, ptr %arr37, i64 8
  %13 = call ptr @memset(ptr %arr.data38, i32 0, i64 %11)
  store ptr %arr37, ptr %done, align 8
  store i32 0, ptr %cnt, align 4
  store i32 1, ptr %progress, align 4
  br label %while.cond

for.cond5:                                        ; preds = %for.update7, %for.body
  %v9 = load i32, ptr %v, align 4
  %n10 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n11 = load i32, ptr %n10, align 4, !tbaa !7
  %14 = icmp slt i32 %v9, %n11
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body6, label %for.end8

for.body6:                                        ; preds = %for.cond5
  %adj = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 1
  %adj12 = load ptr, ptr %adj, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %u13 = load i32, ptr %u, align 4
  %n14 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n15 = load i32, ptr %n14, align 4, !tbaa !7
  %16 = mul i32 %u13, %n15
  %v16 = load i32, ptr %v, align 4
  %17 = add i32 %16, %v16
  %18 = sext i32 %17 to i64
  %arr.len = load i64, ptr %adj12, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update7:                                      ; preds = %if.end
  %19 = load i32, ptr %v, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %v, align 4
  br label %for.cond5

for.end8:                                         ; preds = %for.cond5
  br label %for.update

idx.bad:                                          ; preds = %for.body6
  call void @__polaron_fail(ptr @.fail.1821, ptr @.faila.1822, i64 %18, ptr @.failb.1823, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body6
  %arr.data17 = getelementptr i8, ptr %adj12, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data17, i64 %18
  %elem = load i32, ptr %arr.elem, align 4
  %21 = icmp eq i32 %elem, 1
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %indeg18 = load ptr, ptr %indeg, align 8, !nonnull !0, !dereferenceable !1
  %v19 = load i32, ptr %v, align 4
  %23 = sext i32 %v19 to i64
  %arr.len20 = load i64, ptr %indeg18, align 8
  %arr.oob21 = icmp uge i64 %23, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

if.end:                                           ; preds = %idx.ok31, %idx.ok
  br label %for.update7

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1824, ptr @.faila.1825, i64 %23, ptr @.failb.1826, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %indeg18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %23
  %indeg26 = load ptr, ptr %indeg, align 8, !nonnull !0, !dereferenceable !1
  %v27 = load i32, ptr %v, align 4
  %24 = sext i32 %v27 to i64
  %arr.len28 = load i64, ptr %indeg26, align 8
  %arr.oob29 = icmp uge i64 %24, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.1827, ptr @.faila.1828, i64 %24, ptr @.failb.1829, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok23
  %arr.data32 = getelementptr i8, ptr %indeg26, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %24
  %elem34 = load i32, ptr %arr.elem33, align 4
  %25 = add i32 %elem34, 1
  store i32 %25, ptr %arr.elem25, align 4
  br label %if.end

while.cond:                                       ; preds = %if.end73, %for.end
  %progress39 = load i32, ptr %progress, align 4
  %26 = icmp ne i32 %progress39, 0
  br i1 %26, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  store i32 -1, ptr %pick, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond40

while.end:                                        ; preds = %while.cond
  %cnt131 = load i32, ptr %cnt, align 4
  ret i32 %cnt131

while.cond40:                                     ; preds = %if.end65, %while.body
  %i43 = load i32, ptr %i, align 4
  %n44 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n45 = load i32, ptr %n44, align 4, !tbaa !7
  %27 = icmp slt i32 %i43, %n45
  %28 = zext i1 %27 to i32
  br i1 %27, label %while.body41, label %while.end42

while.body41:                                     ; preds = %while.cond40
  %done46 = load ptr, ptr %done, align 8, !nonnull !0, !dereferenceable !1
  %i47 = load i32, ptr %i, align 4
  %29 = sext i32 %i47 to i64
  %arr.len48 = load i64, ptr %done46, align 8
  %arr.oob49 = icmp uge i64 %29, %arr.len48
  br i1 %arr.oob49, label %idx.bad50, label %idx.ok51, !prof !2

while.end42:                                      ; preds = %while.cond40
  %pick70 = load i32, ptr %pick, align 4
  %30 = icmp eq i32 %pick70, -1
  %31 = zext i1 %30 to i32
  br i1 %30, label %if.then71, label %if.else72

idx.bad50:                                        ; preds = %while.body41
  call void @__polaron_fail(ptr @.fail.1830, ptr @.faila.1831, i64 %29, ptr @.failb.1832, i64 %arr.len48, i32 70)
  unreachable

idx.ok51:                                         ; preds = %while.body41
  %arr.data52 = getelementptr i8, ptr %done46, i64 8
  %arr.elem53 = getelementptr inbounds i8, ptr %arr.data52, i64 %29
  %elem54 = load i8, ptr %arr.elem53, align 1
  %32 = zext i8 %elem54 to i32
  %33 = icmp eq i32 %32, 0
  %34 = zext i1 %33 to i32
  %sc.a = icmp ne i32 %34, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %idx.ok51
  %indeg55 = load ptr, ptr %indeg, align 8, !nonnull !0, !dereferenceable !1
  %i56 = load i32, ptr %i, align 4
  %35 = sext i32 %i56 to i64
  %arr.len57 = load i64, ptr %indeg55, align 8
  %arr.oob58 = icmp uge i64 %35, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

sc.end:                                           ; preds = %idx.ok60, %idx.ok51
  %sc = phi i1 [ false, %idx.ok51 ], [ %sc.b, %idx.ok60 ]
  %36 = zext i1 %sc to i32
  br i1 %sc, label %if.then64, label %if.else

idx.bad59:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1833, ptr @.faila.1834, i64 %35, ptr @.failb.1835, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %sc.rhs
  %arr.data61 = getelementptr i8, ptr %indeg55, i64 8
  %arr.elem62 = getelementptr inbounds i32, ptr %arr.data61, i64 %35
  %elem63 = load i32, ptr %arr.elem62, align 4
  %37 = icmp eq i32 %elem63, 0
  %38 = zext i1 %37 to i32
  %sc.b = icmp ne i32 %38, 0
  br label %sc.end

if.then64:                                        ; preds = %sc.end
  %i66 = load i32, ptr %i, align 4
  store i32 %i66, ptr %pick, align 4
  %n67 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n68 = load i32, ptr %n67, align 4, !tbaa !7
  store i32 %n68, ptr %i, align 4
  br label %if.end65

if.else:                                          ; preds = %sc.end
  %i69 = load i32, ptr %i, align 4
  %39 = add i32 %i69, 1
  store i32 %39, ptr %i, align 4
  br label %if.end65

if.end65:                                         ; preds = %if.else, %if.then64
  br label %while.cond40

if.then71:                                        ; preds = %while.end42
  store i32 0, ptr %progress, align 4
  br label %if.end73

if.else72:                                        ; preds = %while.end42
  %done74 = load ptr, ptr %done, align 8, !nonnull !0, !dereferenceable !1
  %pick75 = load i32, ptr %pick, align 4
  %40 = sext i32 %pick75 to i64
  %arr.len76 = load i64, ptr %done74, align 8
  %arr.oob77 = icmp uge i64 %40, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !2

if.end73:                                         ; preds = %for.end95, %if.then71
  br label %while.cond

idx.bad78:                                        ; preds = %if.else72
  call void @__polaron_fail(ptr @.fail.1836, ptr @.faila.1837, i64 %40, ptr @.failb.1838, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %if.else72
  %arr.data80 = getelementptr i8, ptr %done74, i64 8
  %arr.elem81 = getelementptr inbounds i8, ptr %arr.data80, i64 %40
  store i8 1, ptr %arr.elem81, align 1
  %order82 = load ptr, ptr %order, align 8, !nonnull !0, !dereferenceable !1
  %cnt83 = load i32, ptr %cnt, align 4
  %41 = sext i32 %cnt83 to i64
  %arr.len84 = load i64, ptr %order82, align 8
  %arr.oob85 = icmp uge i64 %41, %arr.len84
  br i1 %arr.oob85, label %idx.bad86, label %idx.ok87, !prof !2

idx.bad86:                                        ; preds = %idx.ok79
  call void @__polaron_fail(ptr @.fail.1839, ptr @.faila.1840, i64 %41, ptr @.failb.1841, i64 %arr.len84, i32 70)
  unreachable

idx.ok87:                                         ; preds = %idx.ok79
  %arr.data88 = getelementptr i8, ptr %order82, i64 8
  %arr.elem89 = getelementptr inbounds i32, ptr %arr.data88, i64 %41
  %pick90 = load i32, ptr %pick, align 4
  store i32 %pick90, ptr %arr.elem89, align 4
  %cnt91 = load i32, ptr %cnt, align 4
  %42 = add i32 %cnt91, 1
  store i32 %42, ptr %cnt, align 4
  store i32 0, ptr %j, align 4
  br label %for.cond92

for.cond92:                                       ; preds = %for.update94, %idx.ok87
  %j96 = load i32, ptr %j, align 4
  %n97 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n98 = load i32, ptr %n97, align 4, !tbaa !7
  %43 = icmp slt i32 %j96, %n98
  %44 = zext i1 %43 to i32
  br i1 %43, label %for.body93, label %for.end95

for.body93:                                       ; preds = %for.cond92
  %adj99 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 1
  %adj100 = load ptr, ptr %adj99, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %pick101 = load i32, ptr %pick, align 4
  %n102 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n103 = load i32, ptr %n102, align 4, !tbaa !7
  %45 = mul i32 %pick101, %n103
  %j104 = load i32, ptr %j, align 4
  %46 = add i32 %45, %j104
  %47 = sext i32 %46 to i64
  %arr.len105 = load i64, ptr %adj100, align 8
  %arr.oob106 = icmp uge i64 %47, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !2

for.update94:                                     ; preds = %if.end113
  %48 = load i32, ptr %j, align 4
  %49 = add i32 %48, 1
  store i32 %49, ptr %j, align 4
  br label %for.cond92

for.end95:                                        ; preds = %for.cond92
  br label %if.end73

idx.bad107:                                       ; preds = %for.body93
  call void @__polaron_fail(ptr @.fail.1842, ptr @.faila.1843, i64 %47, ptr @.failb.1844, i64 %arr.len105, i32 70)
  unreachable

idx.ok108:                                        ; preds = %for.body93
  %arr.data109 = getelementptr i8, ptr %adj100, i64 8
  %arr.elem110 = getelementptr inbounds i32, ptr %arr.data109, i64 %47
  %elem111 = load i32, ptr %arr.elem110, align 4
  %50 = icmp eq i32 %elem111, 1
  %51 = zext i1 %50 to i32
  br i1 %50, label %if.then112, label %if.end113

if.then112:                                       ; preds = %idx.ok108
  %indeg114 = load ptr, ptr %indeg, align 8, !nonnull !0, !dereferenceable !1
  %j115 = load i32, ptr %j, align 4
  %52 = sext i32 %j115 to i64
  %arr.len116 = load i64, ptr %indeg114, align 8
  %arr.oob117 = icmp uge i64 %52, %arr.len116
  br i1 %arr.oob117, label %idx.bad118, label %idx.ok119, !prof !2

if.end113:                                        ; preds = %idx.ok127, %idx.ok108
  br label %for.update94

idx.bad118:                                       ; preds = %if.then112
  call void @__polaron_fail(ptr @.fail.1845, ptr @.faila.1846, i64 %52, ptr @.failb.1847, i64 %arr.len116, i32 70)
  unreachable

idx.ok119:                                        ; preds = %if.then112
  %arr.data120 = getelementptr i8, ptr %indeg114, i64 8
  %arr.elem121 = getelementptr inbounds i32, ptr %arr.data120, i64 %52
  %indeg122 = load ptr, ptr %indeg, align 8, !nonnull !0, !dereferenceable !1
  %j123 = load i32, ptr %j, align 4
  %53 = sext i32 %j123 to i64
  %arr.len124 = load i64, ptr %indeg122, align 8
  %arr.oob125 = icmp uge i64 %53, %arr.len124
  br i1 %arr.oob125, label %idx.bad126, label %idx.ok127, !prof !2

idx.bad126:                                       ; preds = %idx.ok119
  call void @__polaron_fail(ptr @.fail.1848, ptr @.faila.1849, i64 %53, ptr @.failb.1850, i64 %arr.len124, i32 70)
  unreachable

idx.ok127:                                        ; preds = %idx.ok119
  %arr.data128 = getelementptr i8, ptr %indeg122, i64 8
  %arr.elem129 = getelementptr inbounds i32, ptr %arr.data128, i64 %53
  %elem130 = load i32, ptr %arr.elem129, align 4
  %54 = sub i32 %elem130, 1
  store i32 %54, ptr %arr.elem121, align 4
  br label %if.end113
}

define internal i32 @DiGraph.hasCycle(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %o = alloca ptr, align 8
  %n = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4, !tbaa !7
  %1 = sext i32 %n1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %o, align 8
  %o2 = load ptr, ptr %o, align 8
  %5 = call i32 @DiGraph.topoSort(ptr %0, ptr %o2)
  %n3 = getelementptr inbounds %class.DiGraph, ptr %0, i32 0, i32 2
  %n4 = load i32, ptr %n3, align 4, !tbaa !7
  %6 = icmp slt i32 %5, %n4
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5319)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5321)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !5, i64 0}
