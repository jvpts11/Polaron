; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.MinStack = type { ptr, ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@MinStack.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr @MinStack.peek, ptr null, ptr @MinStack.size, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @MinStack.push, ptr @MinStack.pop, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @MinStack.getMin, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [35 x i8] c"min1=%d popped=%d min2=%d size=%d\0A\00", align 1
@.fail = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:21:21  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:21:29  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:21:37  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:21:47  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:21:57  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:21:65  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:21:73  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:21:81  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.22 = private unnamed_addr constant [21 x i8] c"w=%d,%d,%d,%d,%d,%d\0A\00", align 1
@.fail.23 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:23:41  in main\0A\00", align 1
@.faila.24 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.25 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.26 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:23:41  in main\0A\00", align 1
@.faila.27 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.28 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.29 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:23:41  in main\0A\00", align 1
@.faila.30 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.31 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.32 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:23:41  in main\0A\00", align 1
@.faila.33 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.34 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.35 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:23:41  in main\0A\00", align 1
@.faila.36 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.37 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.38 = private unnamed_addr constant [134 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/minstack_window.pol:23:41  in main\0A\00", align 1
@.faila.39 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.40 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1824 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2335:37  in MinStack.push\0A\00", align 1
@.faila.1825 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1826 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1827 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2336:17  in MinStack.push\0A\00", align 1
@.faila.1828 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1829 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1830 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2336:89  in MinStack.push\0A\00", align 1
@.faila.1831 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1832 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1833 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2337:44  in MinStack.push\0A\00", align 1
@.faila.1834 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1835 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1836 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2337:44  in MinStack.push\0A\00", align 1
@.faila.1837 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1838 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1839 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2341:72  in MinStack.pop\0A\00", align 1
@.faila.1840 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1841 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1842 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2342:48  in MinStack.peek\0A\00", align 1
@.faila.1843 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1844 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1845 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2343:50  in MinStack.getMin\0A\00", align 1
@.faila.1846 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1847 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2100 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2708:21  in SlidingWindowMax.maxOfEach\0A\00", align 1
@.faila.2101 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2102 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2103 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2709:21  in SlidingWindowMax.maxOfEach\0A\00", align 1
@.faila.2104 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2105 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2106 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2709:21  in SlidingWindowMax.maxOfEach\0A\00", align 1
@.faila.2107 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2108 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2109 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2709:21  in SlidingWindowMax.maxOfEach\0A\00", align 1
@.faila.2110 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2111 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2112 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2710:30  in SlidingWindowMax.maxOfEach\0A\00", align 1
@.faila.2113 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2114 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2115 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2711:47  in SlidingWindowMax.maxOfEach\0A\00", align 1
@.faila.2116 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2117 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2118 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2711:47  in SlidingWindowMax.maxOfEach\0A\00", align 1
@.faila.2119 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2120 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2121 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2711:47  in SlidingWindowMax.maxOfEach\0A\00", align 1
@.faila.2122 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2123 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5348 = private constant [1 x i8] zeroinitializer
@.strobj.5349 = private global %String { i64 0, ptr @.strdata.5348, i64 0 }
@.strdata.5350 = private constant [1 x i8] zeroinitializer
@.strobj.5351 = private global %String { i64 0, ptr @.strdata.5350, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %w = alloca ptr, align 8
  %a = alloca ptr, align 8
  %m2 = alloca i32, align 4
  %p = alloca i32, align 4
  %m1 = alloca i32, align 4
  %st = alloca ptr, align 8
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
  %MinStack.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.MinStack, ptr null, i64 1) to i64))
  call void @MinStack.MinStack(ptr %MinStack.obj, i32 8)
  store ptr %MinStack.obj, ptr %st, align 8
  %st1 = load ptr, ptr %st, align 8
  call void @MinStack.push(ptr %st1, i32 3)
  %st2 = load ptr, ptr %st, align 8
  call void @MinStack.push(ptr %st2, i32 5)
  %st3 = load ptr, ptr %st, align 8
  call void @MinStack.push(ptr %st3, i32 2)
  %st4 = load ptr, ptr %st, align 8
  call void @MinStack.push(ptr %st4, i32 1)
  %st5 = load ptr, ptr %st, align 8
  %16 = call i32 @MinStack.getMin(ptr %st5)
  store i32 %16, ptr %m1, align 4
  %st6 = load ptr, ptr %st, align 8
  %17 = call i32 @MinStack.pop(ptr %st6)
  store i32 %17, ptr %p, align 4
  %st7 = load ptr, ptr %st, align 8
  %18 = call i32 @MinStack.getMin(ptr %st7)
  store i32 %18, ptr %m2, align 4
  %m18 = load i32, ptr %m1, align 4
  %p9 = load i32, ptr %p, align 4
  %m210 = load i32, ptr %m2, align 4
  %st11 = load ptr, ptr %st, align 8
  %19 = call i32 @MinStack.size(ptr %st11)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %m18, i32 %p9, i32 %m210, i32 %19)
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data12 = getelementptr i8, ptr %arr, i64 8
  %21 = call ptr @memset(ptr %arr.data12, i32 0, i64 32)
  store ptr %arr, ptr %a, align 8
  %a13 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a13, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data14 = getelementptr i8, ptr %a13, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data14, i64 0
  store i32 1, ptr %arr.elem, align 4
  %a15 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len16 = load i64, ptr %a15, align 8
  %arr.oob17 = icmp uge i64 1, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

idx.bad18:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok
  %arr.data20 = getelementptr i8, ptr %a15, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 1
  store i32 3, ptr %arr.elem21, align 4
  %a22 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len23 = load i64, ptr %a22, align 8
  %arr.oob24 = icmp uge i64 2, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !2

idx.bad25:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok19
  %arr.data27 = getelementptr i8, ptr %a22, i64 8
  %arr.elem28 = getelementptr inbounds i32, ptr %arr.data27, i64 2
  store i32 -1, ptr %arr.elem28, align 4
  %a29 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len30 = load i64, ptr %a29, align 8
  %arr.oob31 = icmp uge i64 3, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

idx.bad32:                                        ; preds = %idx.ok26
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %idx.ok26
  %arr.data34 = getelementptr i8, ptr %a29, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 3
  store i32 -3, ptr %arr.elem35, align 4
  %a36 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len37 = load i64, ptr %a36, align 8
  %arr.oob38 = icmp uge i64 4, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad39:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok33
  %arr.data41 = getelementptr i8, ptr %a36, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 4
  store i32 5, ptr %arr.elem42, align 4
  %a43 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len44 = load i64, ptr %a43, align 8
  %arr.oob45 = icmp uge i64 5, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !2

idx.bad46:                                        ; preds = %idx.ok40
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 5, ptr @.failb.15, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %idx.ok40
  %arr.data48 = getelementptr i8, ptr %a43, i64 8
  %arr.elem49 = getelementptr inbounds i32, ptr %arr.data48, i64 5
  store i32 3, ptr %arr.elem49, align 4
  %a50 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len51 = load i64, ptr %a50, align 8
  %arr.oob52 = icmp uge i64 6, %arr.len51
  br i1 %arr.oob52, label %idx.bad53, label %idx.ok54, !prof !2

idx.bad53:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 6, ptr @.failb.18, i64 %arr.len51, i32 70)
  unreachable

idx.ok54:                                         ; preds = %idx.ok47
  %arr.data55 = getelementptr i8, ptr %a50, i64 8
  %arr.elem56 = getelementptr inbounds i32, ptr %arr.data55, i64 6
  store i32 6, ptr %arr.elem56, align 4
  %a57 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len58 = load i64, ptr %a57, align 8
  %arr.oob59 = icmp uge i64 7, %arr.len58
  br i1 %arr.oob59, label %idx.bad60, label %idx.ok61, !prof !2

idx.bad60:                                        ; preds = %idx.ok54
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 7, ptr @.failb.21, i64 %arr.len58, i32 70)
  unreachable

idx.ok61:                                         ; preds = %idx.ok54
  %arr.data62 = getelementptr i8, ptr %a57, i64 8
  %arr.elem63 = getelementptr inbounds i32, ptr %arr.data62, i64 7
  store i32 7, ptr %arr.elem63, align 4
  %a64 = load ptr, ptr %a, align 8
  %22 = call ptr @SlidingWindowMax.maxOfEach(ptr %a64, i32 8, i32 3)
  store ptr %22, ptr %w, align 8
  %w65 = load ptr, ptr %w, align 8, !nonnull !0, !dereferenceable !1
  %arr.len66 = load i64, ptr %w65, align 8
  %arr.oob67 = icmp uge i64 0, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !2

idx.bad68:                                        ; preds = %idx.ok61
  call void @__polaron_fail(ptr @.fail.23, ptr @.faila.24, i64 0, ptr @.failb.25, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %idx.ok61
  %arr.data70 = getelementptr i8, ptr %w65, i64 8
  %arr.elem71 = getelementptr inbounds i32, ptr %arr.data70, i64 0
  %elem = load i32, ptr %arr.elem71, align 4
  %w72 = load ptr, ptr %w, align 8, !nonnull !0, !dereferenceable !1
  %arr.len73 = load i64, ptr %w72, align 8
  %arr.oob74 = icmp uge i64 1, %arr.len73
  br i1 %arr.oob74, label %idx.bad75, label %idx.ok76, !prof !2

idx.bad75:                                        ; preds = %idx.ok69
  call void @__polaron_fail(ptr @.fail.26, ptr @.faila.27, i64 1, ptr @.failb.28, i64 %arr.len73, i32 70)
  unreachable

idx.ok76:                                         ; preds = %idx.ok69
  %arr.data77 = getelementptr i8, ptr %w72, i64 8
  %arr.elem78 = getelementptr inbounds i32, ptr %arr.data77, i64 1
  %elem79 = load i32, ptr %arr.elem78, align 4
  %w80 = load ptr, ptr %w, align 8, !nonnull !0, !dereferenceable !1
  %arr.len81 = load i64, ptr %w80, align 8
  %arr.oob82 = icmp uge i64 2, %arr.len81
  br i1 %arr.oob82, label %idx.bad83, label %idx.ok84, !prof !2

idx.bad83:                                        ; preds = %idx.ok76
  call void @__polaron_fail(ptr @.fail.29, ptr @.faila.30, i64 2, ptr @.failb.31, i64 %arr.len81, i32 70)
  unreachable

idx.ok84:                                         ; preds = %idx.ok76
  %arr.data85 = getelementptr i8, ptr %w80, i64 8
  %arr.elem86 = getelementptr inbounds i32, ptr %arr.data85, i64 2
  %elem87 = load i32, ptr %arr.elem86, align 4
  %w88 = load ptr, ptr %w, align 8, !nonnull !0, !dereferenceable !1
  %arr.len89 = load i64, ptr %w88, align 8
  %arr.oob90 = icmp uge i64 3, %arr.len89
  br i1 %arr.oob90, label %idx.bad91, label %idx.ok92, !prof !2

idx.bad91:                                        ; preds = %idx.ok84
  call void @__polaron_fail(ptr @.fail.32, ptr @.faila.33, i64 3, ptr @.failb.34, i64 %arr.len89, i32 70)
  unreachable

idx.ok92:                                         ; preds = %idx.ok84
  %arr.data93 = getelementptr i8, ptr %w88, i64 8
  %arr.elem94 = getelementptr inbounds i32, ptr %arr.data93, i64 3
  %elem95 = load i32, ptr %arr.elem94, align 4
  %w96 = load ptr, ptr %w, align 8, !nonnull !0, !dereferenceable !1
  %arr.len97 = load i64, ptr %w96, align 8
  %arr.oob98 = icmp uge i64 4, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !2

idx.bad99:                                        ; preds = %idx.ok92
  call void @__polaron_fail(ptr @.fail.35, ptr @.faila.36, i64 4, ptr @.failb.37, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok92
  %arr.data101 = getelementptr i8, ptr %w96, i64 8
  %arr.elem102 = getelementptr inbounds i32, ptr %arr.data101, i64 4
  %elem103 = load i32, ptr %arr.elem102, align 4
  %w104 = load ptr, ptr %w, align 8, !nonnull !0, !dereferenceable !1
  %arr.len105 = load i64, ptr %w104, align 8
  %arr.oob106 = icmp uge i64 5, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !2

idx.bad107:                                       ; preds = %idx.ok100
  call void @__polaron_fail(ptr @.fail.38, ptr @.faila.39, i64 5, ptr @.failb.40, i64 %arr.len105, i32 70)
  unreachable

idx.ok108:                                        ; preds = %idx.ok100
  %arr.data109 = getelementptr i8, ptr %w104, i64 8
  %arr.elem110 = getelementptr inbounds i32, ptr %arr.data109, i64 5
  %elem111 = load i32, ptr %arr.elem110, align 4
  %23 = call i32 (ptr, ...) @printf(ptr @.str.22, i32 %elem, i32 %elem79, i32 %elem87, i32 %elem95, i32 %elem103, i32 %elem111)
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

define internal void @MinStack.MinStack(ptr %0, i32 %1) {
entry:
  %capacity = alloca i32, align 4
  store i32 %1, ptr %capacity, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 0
  store ptr @MinStack.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %vals = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 1
  store ptr null, ptr %vals, align 8, !tbaa !3
  %mins = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 2
  store ptr null, ptr %mins, align 8, !tbaa !3
  %vals1 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 1
  %capacity2 = load i32, ptr %capacity, align 4
  %2 = sext i32 %capacity2 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %vals1, align 8, !tbaa !3
  %mins3 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 2
  %capacity4 = load i32, ptr %capacity, align 4
  %6 = sext i32 %capacity4 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr5 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr5, align 8
  %arr.data6 = getelementptr i8, ptr %arr5, i64 8
  %9 = call ptr @memset(ptr %arr.data6, i32 0, i64 %7)
  store ptr %arr5, ptr %mins3, align 8, !tbaa !3
  %top = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  store i32 0, ptr %top, align 4, !tbaa !7
  ret void
}

define internal void @MinStack.push(ptr nonnull align 8 dereferenceable(32) %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %vals = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 1
  %vals1 = load ptr, ptr %vals, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %top = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top2 = load i32, ptr %top, align 4, !tbaa !7
  %2 = sext i32 %top2 to i64
  %arr.len = load i64, ptr %vals1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1824, ptr @.faila.1825, i64 %2, ptr @.failb.1826, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %vals1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %v3 = load i32, ptr %v, align 4
  store i32 %v3, ptr %arr.elem, align 4
  %top4 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top5 = load i32, ptr %top4, align 4, !tbaa !7
  %3 = icmp eq i32 %top5, 0
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %idx.ok
  %v6 = load i32, ptr %v, align 4
  %mins = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 2
  %mins7 = load ptr, ptr %mins, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %top8 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top9 = load i32, ptr %top8, align 4, !tbaa !7
  %5 = sub i32 %top9, 1
  %6 = sext i32 %5 to i64
  %arr.len10 = load i64, ptr %mins7, align 8
  %arr.oob11 = icmp uge i64 %6, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !2

sc.end:                                           ; preds = %idx.ok13, %idx.ok
  %sc = phi i1 [ true, %idx.ok ], [ %sc.b, %idx.ok13 ]
  %7 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.else

idx.bad12:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1827, ptr @.faila.1828, i64 %6, ptr @.failb.1829, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %sc.rhs
  %arr.data14 = getelementptr i8, ptr %mins7, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %6
  %elem = load i32, ptr %arr.elem15, align 4
  %8 = icmp slt i32 %v6, %elem
  %9 = zext i1 %8 to i32
  %sc.b = icmp ne i32 %9, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %mins16 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 2
  %mins17 = load ptr, ptr %mins16, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %top18 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top19 = load i32, ptr %top18, align 4, !tbaa !7
  %10 = sext i32 %top19 to i64
  %arr.len20 = load i64, ptr %mins17, align 8
  %arr.oob21 = icmp uge i64 %10, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

if.else:                                          ; preds = %sc.end
  %mins27 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 2
  %mins28 = load ptr, ptr %mins27, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %top29 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top30 = load i32, ptr %top29, align 4, !tbaa !7
  %11 = sext i32 %top30 to i64
  %arr.len31 = load i64, ptr %mins28, align 8
  %arr.oob32 = icmp uge i64 %11, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !2

if.end:                                           ; preds = %idx.ok44, %idx.ok23
  %top48 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top49 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top50 = load i32, ptr %top49, align 4, !tbaa !7
  %12 = add i32 %top50, 1
  store i32 %12, ptr %top48, align 4, !tbaa !7
  ret void

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1830, ptr @.faila.1831, i64 %10, ptr @.failb.1832, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %mins17, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %10
  %v26 = load i32, ptr %v, align 4
  store i32 %v26, ptr %arr.elem25, align 4
  br label %if.end

idx.bad33:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1833, ptr @.faila.1834, i64 %11, ptr @.failb.1835, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.else
  %arr.data35 = getelementptr i8, ptr %mins28, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %11
  %mins37 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 2
  %mins38 = load ptr, ptr %mins37, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %top39 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top40 = load i32, ptr %top39, align 4, !tbaa !7
  %13 = sub i32 %top40, 1
  %14 = sext i32 %13 to i64
  %arr.len41 = load i64, ptr %mins38, align 8
  %arr.oob42 = icmp uge i64 %14, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !2

idx.bad43:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.1836, ptr @.faila.1837, i64 %14, ptr @.failb.1838, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %idx.ok34
  %arr.data45 = getelementptr i8, ptr %mins38, i64 8
  %arr.elem46 = getelementptr inbounds i32, ptr %arr.data45, i64 %14
  %elem47 = load i32, ptr %arr.elem46, align 4
  store i32 %elem47, ptr %arr.elem36, align 4
  br label %if.end
}

define internal i32 @MinStack.pop(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %top = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top1 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top2 = load i32, ptr %top1, align 4, !tbaa !7
  %1 = sub i32 %top2, 1
  store i32 %1, ptr %top, align 4, !tbaa !7
  %vals = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 1
  %vals3 = load ptr, ptr %vals, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %top4 = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top5 = load i32, ptr %top4, align 4, !tbaa !7
  %2 = sext i32 %top5 to i64
  %arr.len = load i64, ptr %vals3, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1839, ptr @.faila.1840, i64 %2, ptr @.failb.1841, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %vals3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @MinStack.peek(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %vals = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 1
  %vals1 = load ptr, ptr %vals, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %top = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top2 = load i32, ptr %top, align 4, !tbaa !7
  %1 = sub i32 %top2, 1
  %2 = sext i32 %1 to i64
  %arr.len = load i64, ptr %vals1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1842, ptr @.faila.1843, i64 %2, ptr @.failb.1844, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %vals1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @MinStack.getMin(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %mins = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 2
  %mins1 = load ptr, ptr %mins, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %top = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top2 = load i32, ptr %top, align 4, !tbaa !7
  %1 = sub i32 %top2, 1
  %2 = sext i32 %1 to i64
  %arr.len = load i64, ptr %mins1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1845, ptr @.faila.1846, i64 %2, ptr @.failb.1847, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %mins1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @MinStack.size(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %top = getelementptr inbounds %class.MinStack, ptr %0, i32 0, i32 3
  %top1 = load i32, ptr %top, align 4, !tbaa !7
  ret i32 %top1
}

define internal ptr @SlidingWindowMax.maxOfEach(ptr %0, i32 %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %oi = alloca i32, align 4
  %tail = alloca i32, align 4
  %head = alloca i32, align 4
  %dq = alloca ptr, align 8
  %out = alloca ptr, align 8
  %k = alloca i32, align 4
  %n = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %n, align 4
  store i32 %2, ptr %k, align 4
  %n1 = load i32, ptr %n, align 4
  %k2 = load i32, ptr %k, align 4
  %3 = sub i32 %n1, %k2
  %4 = add i32 %3, 1
  %5 = sext i32 %4 to i64
  %6 = mul i64 %5, 4
  %7 = add i64 8, %6
  %arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %8 = call ptr @memset(ptr %arr.data, i32 0, i64 %6)
  store ptr %arr, ptr %out, align 8
  %n3 = load i32, ptr %n, align 4
  %9 = sext i32 %n3 to i64
  %10 = mul i64 %9, 4
  %11 = add i64 8, %10
  %arr4 = call ptr @__polaron_malloc(i64 %11)
  store i64 %9, ptr %arr4, align 8
  %arr.data5 = getelementptr i8, ptr %arr4, i64 8
  %12 = call ptr @memset(ptr %arr.data5, i32 0, i64 %10)
  store ptr %arr4, ptr %dq, align 8
  store i32 0, ptr %head, align 4
  store i32 0, ptr %tail, align 4
  store i32 0, ptr %oi, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %n7 = load i32, ptr %n, align 4
  %13 = icmp slt i32 %i6, %n7
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  br label %while.cond

for.update:                                       ; preds = %if.end
  %15 = load i32, ptr %i, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out91 = load ptr, ptr %out, align 8
  ret ptr %out91

while.cond:                                       ; preds = %while.body, %for.body
  %head8 = load i32, ptr %head, align 4
  %tail9 = load i32, ptr %tail, align 4
  %17 = icmp slt i32 %head8, %tail9
  %18 = zext i1 %17 to i32
  %sc.a = icmp ne i32 %18, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %head15 = load i32, ptr %head, align 4
  %19 = add i32 %head15, 1
  store i32 %19, ptr %head, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  br label %while.cond16

sc.rhs:                                           ; preds = %while.cond
  %dq10 = load ptr, ptr %dq, align 8, !nonnull !0, !dereferenceable !1
  %head11 = load i32, ptr %head, align 4
  %20 = sext i32 %head11 to i64
  %arr.len = load i64, ptr %dq10, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

sc.end:                                           ; preds = %idx.ok, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok ]
  %21 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.2100, ptr @.faila.2101, i64 %20, ptr @.failb.2102, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data12 = getelementptr i8, ptr %dq10, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data12, i64 %20
  %elem = load i32, ptr %arr.elem, align 4
  %i13 = load i32, ptr %i, align 4
  %k14 = load i32, ptr %k, align 4
  %22 = sub i32 %i13, %k14
  %23 = icmp sle i32 %elem, %22
  %24 = zext i1 %23 to i32
  %sc.b = icmp ne i32 %24, 0
  br label %sc.end

while.cond16:                                     ; preds = %while.body17, %while.end
  %head19 = load i32, ptr %head, align 4
  %tail20 = load i32, ptr %tail, align 4
  %25 = icmp slt i32 %head19, %tail20
  %26 = zext i1 %25 to i32
  %sc.a21 = icmp ne i32 %26, 0
  br i1 %sc.a21, label %sc.rhs22, label %sc.end23

while.body17:                                     ; preds = %sc.end23
  %tail52 = load i32, ptr %tail, align 4
  %27 = sub i32 %tail52, 1
  store i32 %27, ptr %tail, align 4
  br label %while.cond16

while.end18:                                      ; preds = %sc.end23
  %dq53 = load ptr, ptr %dq, align 8, !nonnull !0, !dereferenceable !1
  %tail54 = load i32, ptr %tail, align 4
  %28 = sext i32 %tail54 to i64
  %arr.len55 = load i64, ptr %dq53, align 8
  %arr.oob56 = icmp uge i64 %28, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

sc.rhs22:                                         ; preds = %while.cond16
  %a24 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %dq25 = load ptr, ptr %dq, align 8, !nonnull !0, !dereferenceable !1
  %tail26 = load i32, ptr %tail, align 4
  %29 = sub i32 %tail26, 1
  %30 = sext i32 %29 to i64
  %arr.len27 = load i64, ptr %dq25, align 8
  %arr.oob28 = icmp uge i64 %30, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !2

sc.end23:                                         ; preds = %idx.ok46, %while.cond16
  %sc51 = phi i1 [ false, %while.cond16 ], [ %sc.b50, %idx.ok46 ]
  %31 = zext i1 %sc51 to i32
  br i1 %sc51, label %while.body17, label %while.end18

idx.bad29:                                        ; preds = %sc.rhs22
  call void @__polaron_fail(ptr @.fail.2103, ptr @.faila.2104, i64 %30, ptr @.failb.2105, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %sc.rhs22
  %arr.data31 = getelementptr i8, ptr %dq25, i64 8
  %arr.elem32 = getelementptr inbounds i32, ptr %arr.data31, i64 %30
  %elem33 = load i32, ptr %arr.elem32, align 4
  %32 = sext i32 %elem33 to i64
  %arr.len34 = load i64, ptr %a24, align 8
  %arr.oob35 = icmp uge i64 %32, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !2

idx.bad36:                                        ; preds = %idx.ok30
  call void @__polaron_fail(ptr @.fail.2106, ptr @.faila.2107, i64 %32, ptr @.failb.2108, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %idx.ok30
  %arr.data38 = getelementptr i8, ptr %a24, i64 8
  %arr.elem39 = getelementptr inbounds i32, ptr %arr.data38, i64 %32
  %elem40 = load i32, ptr %arr.elem39, align 4
  %a41 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i42 = load i32, ptr %i, align 4
  %33 = sext i32 %i42 to i64
  %arr.len43 = load i64, ptr %a41, align 8
  %arr.oob44 = icmp uge i64 %33, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !2

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.2109, ptr @.faila.2110, i64 %33, ptr @.failb.2111, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok37
  %arr.data47 = getelementptr i8, ptr %a41, i64 8
  %arr.elem48 = getelementptr inbounds i32, ptr %arr.data47, i64 %33
  %elem49 = load i32, ptr %arr.elem48, align 4
  %34 = icmp sle i32 %elem40, %elem49
  %35 = zext i1 %34 to i32
  %sc.b50 = icmp ne i32 %35, 0
  br label %sc.end23

idx.bad57:                                        ; preds = %while.end18
  call void @__polaron_fail(ptr @.fail.2112, ptr @.faila.2113, i64 %28, ptr @.failb.2114, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %while.end18
  %arr.data59 = getelementptr i8, ptr %dq53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %28
  %i61 = load i32, ptr %i, align 4
  store i32 %i61, ptr %arr.elem60, align 4
  %tail62 = load i32, ptr %tail, align 4
  %36 = add i32 %tail62, 1
  store i32 %36, ptr %tail, align 4
  %i63 = load i32, ptr %i, align 4
  %k64 = load i32, ptr %k, align 4
  %37 = sub i32 %k64, 1
  %38 = icmp sge i32 %i63, %37
  %39 = zext i1 %38 to i32
  br i1 %38, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok58
  %out65 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %oi66 = load i32, ptr %oi, align 4
  %40 = sext i32 %oi66 to i64
  %arr.len67 = load i64, ptr %out65, align 8
  %arr.oob68 = icmp uge i64 %40, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !2

if.end:                                           ; preds = %idx.ok86, %idx.ok58
  br label %for.update

idx.bad69:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2115, ptr @.faila.2116, i64 %40, ptr @.failb.2117, i64 %arr.len67, i32 70)
  unreachable

idx.ok70:                                         ; preds = %if.then
  %arr.data71 = getelementptr i8, ptr %out65, i64 8
  %arr.elem72 = getelementptr inbounds i32, ptr %arr.data71, i64 %40
  %a73 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %dq74 = load ptr, ptr %dq, align 8, !nonnull !0, !dereferenceable !1
  %head75 = load i32, ptr %head, align 4
  %41 = sext i32 %head75 to i64
  %arr.len76 = load i64, ptr %dq74, align 8
  %arr.oob77 = icmp uge i64 %41, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !2

idx.bad78:                                        ; preds = %idx.ok70
  call void @__polaron_fail(ptr @.fail.2118, ptr @.faila.2119, i64 %41, ptr @.failb.2120, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %idx.ok70
  %arr.data80 = getelementptr i8, ptr %dq74, i64 8
  %arr.elem81 = getelementptr inbounds i32, ptr %arr.data80, i64 %41
  %elem82 = load i32, ptr %arr.elem81, align 4
  %42 = sext i32 %elem82 to i64
  %arr.len83 = load i64, ptr %a73, align 8
  %arr.oob84 = icmp uge i64 %42, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !2

idx.bad85:                                        ; preds = %idx.ok79
  call void @__polaron_fail(ptr @.fail.2121, ptr @.faila.2122, i64 %42, ptr @.failb.2123, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok79
  %arr.data87 = getelementptr i8, ptr %a73, i64 8
  %arr.elem88 = getelementptr inbounds i32, ptr %arr.data87, i64 %42
  %elem89 = load i32, ptr %arr.elem88, align 4
  store i32 %elem89, ptr %arr.elem72, align 4
  %oi90 = load i32, ptr %oi, align 4
  %43 = add i32 %oi90, 1
  store i32 %43, ptr %oi, align 4
  br label %if.end
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5349)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5351)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

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
