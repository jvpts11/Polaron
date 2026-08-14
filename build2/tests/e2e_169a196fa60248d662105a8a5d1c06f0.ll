; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:14:22  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:14:31  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:14:40  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:14:49  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:16:23  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:16:33  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:16:43  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:16:53  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata = private constant [8 x i8] c"ABCBDAB\00"
@.strobj = private global %String { i64 7, ptr @.strdata, i64 0 }
@.strdata.22 = private constant [6 x i8] c"BDCAB\00"
@.strobj.23 = private global %String { i64 5, ptr @.strdata.22, i64 0 }
@.fail.24 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:22:22  in main\0A\00", align 1
@.faila.25 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.26 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.27 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:22:31  in main\0A\00", align 1
@.faila.28 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.29 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.30 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:22:40  in main\0A\00", align 1
@.faila.31 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.32 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.33 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:22:49  in main\0A\00", align 1
@.faila.34 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.35 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.36 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:22:58  in main\0A\00", align 1
@.faila.37 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.38 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.39 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:22:67  in main\0A\00", align 1
@.faila.40 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.41 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.42 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:22:76  in main\0A\00", align 1
@.faila.43 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.44 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.45 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:22:85  in main\0A\00", align 1
@.faila.46 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.47 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.48 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:23:22  in main\0A\00", align 1
@.faila.49 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.50 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.51 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:23:31  in main\0A\00", align 1
@.faila.52 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.53 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.54 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:23:40  in main\0A\00", align 1
@.faila.55 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.56 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.57 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:23:49  in main\0A\00", align 1
@.faila.58 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.59 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.60 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:23:58  in main\0A\00", align 1
@.faila.61 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.62 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.63 = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/algorithms.pol:23:67  in main\0A\00", align 1
@.faila.64 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.65 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [25 x i8] c"knap=%d lcs=%d sched=%d\0A\00", align 1
@.fail.2049 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2643:26  in Knapsack.maxValue\0A\00", align 1
@.faila.2050 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2051 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2052 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2644:25  in Knapsack.maxValue\0A\00", align 1
@.faila.2053 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2054 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2055 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2644:25  in Knapsack.maxValue\0A\00", align 1
@.faila.2056 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2057 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2058 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2644:25  in Knapsack.maxValue\0A\00", align 1
@.faila.2059 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2060 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2061 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2645:25  in Knapsack.maxValue\0A\00", align 1
@.faila.2062 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2063 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2064 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2645:51  in Knapsack.maxValue\0A\00", align 1
@.faila.2065 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2066 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2067 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2648:17  in Knapsack.maxValue\0A\00", align 1
@.faila.2068 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2069 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2070 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2661:41  in Lcs.length\0A\00", align 1
@.faila.2071 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2072 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2073 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2661:41  in Lcs.length\0A\00", align 1
@.faila.2074 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2075 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2076 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2663:29  in Lcs.length\0A\00", align 1
@.faila.2077 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2078 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2079 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2664:29  in Lcs.length\0A\00", align 1
@.faila.2080 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2081 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2082 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2665:58  in Lcs.length\0A\00", align 1
@.faila.2083 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2084 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2085 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2665:85  in Lcs.length\0A\00", align 1
@.faila.2086 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2087 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2088 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2669:17  in Lcs.length\0A\00", align 1
@.faila.2089 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2090 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2229 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2765:60  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2230 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2231 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2232 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2765:60  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2233 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2234 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2235 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2765:78  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2236 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2237 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2238 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2765:78  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2239 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2240 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2241 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2767:21  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2242 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2243 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2244 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2767:36  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2245 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2246 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2247 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2769:21  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2248 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2249 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2250 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2769:58  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2251 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2252 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2253 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2769:58  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2254 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2255 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2256 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2769:73  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2257 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2258 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2259 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2769:73  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2260 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2261 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2262 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2770:28  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2263 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2264 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2265 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2770:41  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2266 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2267 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2268 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2775:21  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2269 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2270 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2271 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2775:71  in IntervalScheduler.maxNonOverlapping\0A\00", align 1
@.faila.2272 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2273 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5375 = private constant [1 x i8] zeroinitializer
@.strobj.5376 = private global %String { i64 0, ptr @.strdata.5375, i64 0 }
@.strdata.5377 = private constant [1 x i8] zeroinitializer
@.strobj.5378 = private global %String { i64 0, ptr @.strdata.5377, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %sched = alloca i32, align 4
  %en = alloca ptr, align 8
  %st = alloca ptr, align 8
  %lcs = alloca i32, align 4
  %knap = alloca i32, align 4
  %val = alloca ptr, align 8
  %wt = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 16)
  store ptr %arr, ptr %wt, align 8
  %wt2 = load ptr, ptr %wt, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %wt2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %wt2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 1, ptr %arr.elem, align 4
  %wt4 = load ptr, ptr %wt, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %wt4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %wt4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 3, ptr %arr.elem10, align 4
  %wt11 = load ptr, ptr %wt, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %wt11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %wt11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 4, ptr %arr.elem17, align 4
  %wt18 = load ptr, ptr %wt, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %wt18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %wt18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 3
  store i32 5, ptr %arr.elem24, align 4
  %arr25 = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr25, align 8
  %arr.data26 = getelementptr i8, ptr %arr25, i64 8
  %17 = call ptr @memset(ptr %arr.data26, i32 0, i64 16)
  store ptr %arr25, ptr %val, align 8
  %val27 = load ptr, ptr %val, align 8, !nonnull !0, !dereferenceable !1
  %arr.len28 = load i64, ptr %val27, align 8
  %arr.oob29 = icmp uge i64 0, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 0, ptr @.failb.12, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok22
  %arr.data32 = getelementptr i8, ptr %val27, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 0
  store i32 1, ptr %arr.elem33, align 4
  %val34 = load ptr, ptr %val, align 8, !nonnull !0, !dereferenceable !1
  %arr.len35 = load i64, ptr %val34, align 8
  %arr.oob36 = icmp uge i64 1, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !2

idx.bad37:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 1, ptr @.failb.15, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %idx.ok31
  %arr.data39 = getelementptr i8, ptr %val34, i64 8
  %arr.elem40 = getelementptr inbounds i32, ptr %arr.data39, i64 1
  store i32 4, ptr %arr.elem40, align 4
  %val41 = load ptr, ptr %val, align 8, !nonnull !0, !dereferenceable !1
  %arr.len42 = load i64, ptr %val41, align 8
  %arr.oob43 = icmp uge i64 2, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !2

idx.bad44:                                        ; preds = %idx.ok38
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 2, ptr @.failb.18, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok38
  %arr.data46 = getelementptr i8, ptr %val41, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 2
  store i32 5, ptr %arr.elem47, align 4
  %val48 = load ptr, ptr %val, align 8, !nonnull !0, !dereferenceable !1
  %arr.len49 = load i64, ptr %val48, align 8
  %arr.oob50 = icmp uge i64 3, %arr.len49
  br i1 %arr.oob50, label %idx.bad51, label %idx.ok52, !prof !2

idx.bad51:                                        ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 3, ptr @.failb.21, i64 %arr.len49, i32 70)
  unreachable

idx.ok52:                                         ; preds = %idx.ok45
  %arr.data53 = getelementptr i8, ptr %val48, i64 8
  %arr.elem54 = getelementptr inbounds i32, ptr %arr.data53, i64 3
  store i32 7, ptr %arr.elem54, align 4
  %wt55 = load ptr, ptr %wt, align 8
  %val56 = load ptr, ptr %val, align 8
  %18 = call i32 @Knapsack.maxValue(ptr %wt55, ptr %val56, i32 4, i32 7)
  store i32 %18, ptr %knap, align 4
  %19 = call i32 @Lcs.length(ptr @.strobj, ptr @.strobj.23)
  store i32 %19, ptr %lcs, align 4
  %arr57 = call ptr @__polaron_malloc(i64 36)
  store i64 7, ptr %arr57, align 8
  %arr.data58 = getelementptr i8, ptr %arr57, i64 8
  %20 = call ptr @memset(ptr %arr.data58, i32 0, i64 28)
  store ptr %arr57, ptr %st, align 8
  %arr59 = call ptr @__polaron_malloc(i64 36)
  store i64 7, ptr %arr59, align 8
  %arr.data60 = getelementptr i8, ptr %arr59, i64 8
  %21 = call ptr @memset(ptr %arr.data60, i32 0, i64 28)
  store ptr %arr59, ptr %en, align 8
  %st61 = load ptr, ptr %st, align 8, !nonnull !0, !dereferenceable !1
  %arr.len62 = load i64, ptr %st61, align 8
  %arr.oob63 = icmp uge i64 0, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !2

idx.bad64:                                        ; preds = %idx.ok52
  call void @__polaron_fail(ptr @.fail.24, ptr @.faila.25, i64 0, ptr @.failb.26, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %idx.ok52
  %arr.data66 = getelementptr i8, ptr %st61, i64 8
  %arr.elem67 = getelementptr inbounds i32, ptr %arr.data66, i64 0
  store i32 1, ptr %arr.elem67, align 4
  %en68 = load ptr, ptr %en, align 8, !nonnull !0, !dereferenceable !1
  %arr.len69 = load i64, ptr %en68, align 8
  %arr.oob70 = icmp uge i64 0, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !2

idx.bad71:                                        ; preds = %idx.ok65
  call void @__polaron_fail(ptr @.fail.27, ptr @.faila.28, i64 0, ptr @.failb.29, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok65
  %arr.data73 = getelementptr i8, ptr %en68, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 0
  store i32 3, ptr %arr.elem74, align 4
  %st75 = load ptr, ptr %st, align 8, !nonnull !0, !dereferenceable !1
  %arr.len76 = load i64, ptr %st75, align 8
  %arr.oob77 = icmp uge i64 1, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !2

idx.bad78:                                        ; preds = %idx.ok72
  call void @__polaron_fail(ptr @.fail.30, ptr @.faila.31, i64 1, ptr @.failb.32, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %idx.ok72
  %arr.data80 = getelementptr i8, ptr %st75, i64 8
  %arr.elem81 = getelementptr inbounds i32, ptr %arr.data80, i64 1
  store i32 2, ptr %arr.elem81, align 4
  %en82 = load ptr, ptr %en, align 8, !nonnull !0, !dereferenceable !1
  %arr.len83 = load i64, ptr %en82, align 8
  %arr.oob84 = icmp uge i64 1, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !2

idx.bad85:                                        ; preds = %idx.ok79
  call void @__polaron_fail(ptr @.fail.33, ptr @.faila.34, i64 1, ptr @.failb.35, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok79
  %arr.data87 = getelementptr i8, ptr %en82, i64 8
  %arr.elem88 = getelementptr inbounds i32, ptr %arr.data87, i64 1
  store i32 4, ptr %arr.elem88, align 4
  %st89 = load ptr, ptr %st, align 8, !nonnull !0, !dereferenceable !1
  %arr.len90 = load i64, ptr %st89, align 8
  %arr.oob91 = icmp uge i64 2, %arr.len90
  br i1 %arr.oob91, label %idx.bad92, label %idx.ok93, !prof !2

idx.bad92:                                        ; preds = %idx.ok86
  call void @__polaron_fail(ptr @.fail.36, ptr @.faila.37, i64 2, ptr @.failb.38, i64 %arr.len90, i32 70)
  unreachable

idx.ok93:                                         ; preds = %idx.ok86
  %arr.data94 = getelementptr i8, ptr %st89, i64 8
  %arr.elem95 = getelementptr inbounds i32, ptr %arr.data94, i64 2
  store i32 3, ptr %arr.elem95, align 4
  %en96 = load ptr, ptr %en, align 8, !nonnull !0, !dereferenceable !1
  %arr.len97 = load i64, ptr %en96, align 8
  %arr.oob98 = icmp uge i64 2, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !2

idx.bad99:                                        ; preds = %idx.ok93
  call void @__polaron_fail(ptr @.fail.39, ptr @.faila.40, i64 2, ptr @.failb.41, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok93
  %arr.data101 = getelementptr i8, ptr %en96, i64 8
  %arr.elem102 = getelementptr inbounds i32, ptr %arr.data101, i64 2
  store i32 5, ptr %arr.elem102, align 4
  %st103 = load ptr, ptr %st, align 8, !nonnull !0, !dereferenceable !1
  %arr.len104 = load i64, ptr %st103, align 8
  %arr.oob105 = icmp uge i64 3, %arr.len104
  br i1 %arr.oob105, label %idx.bad106, label %idx.ok107, !prof !2

idx.bad106:                                       ; preds = %idx.ok100
  call void @__polaron_fail(ptr @.fail.42, ptr @.faila.43, i64 3, ptr @.failb.44, i64 %arr.len104, i32 70)
  unreachable

idx.ok107:                                        ; preds = %idx.ok100
  %arr.data108 = getelementptr i8, ptr %st103, i64 8
  %arr.elem109 = getelementptr inbounds i32, ptr %arr.data108, i64 3
  store i32 0, ptr %arr.elem109, align 4
  %en110 = load ptr, ptr %en, align 8, !nonnull !0, !dereferenceable !1
  %arr.len111 = load i64, ptr %en110, align 8
  %arr.oob112 = icmp uge i64 3, %arr.len111
  br i1 %arr.oob112, label %idx.bad113, label %idx.ok114, !prof !2

idx.bad113:                                       ; preds = %idx.ok107
  call void @__polaron_fail(ptr @.fail.45, ptr @.faila.46, i64 3, ptr @.failb.47, i64 %arr.len111, i32 70)
  unreachable

idx.ok114:                                        ; preds = %idx.ok107
  %arr.data115 = getelementptr i8, ptr %en110, i64 8
  %arr.elem116 = getelementptr inbounds i32, ptr %arr.data115, i64 3
  store i32 6, ptr %arr.elem116, align 4
  %st117 = load ptr, ptr %st, align 8, !nonnull !0, !dereferenceable !1
  %arr.len118 = load i64, ptr %st117, align 8
  %arr.oob119 = icmp uge i64 4, %arr.len118
  br i1 %arr.oob119, label %idx.bad120, label %idx.ok121, !prof !2

idx.bad120:                                       ; preds = %idx.ok114
  call void @__polaron_fail(ptr @.fail.48, ptr @.faila.49, i64 4, ptr @.failb.50, i64 %arr.len118, i32 70)
  unreachable

idx.ok121:                                        ; preds = %idx.ok114
  %arr.data122 = getelementptr i8, ptr %st117, i64 8
  %arr.elem123 = getelementptr inbounds i32, ptr %arr.data122, i64 4
  store i32 5, ptr %arr.elem123, align 4
  %en124 = load ptr, ptr %en, align 8, !nonnull !0, !dereferenceable !1
  %arr.len125 = load i64, ptr %en124, align 8
  %arr.oob126 = icmp uge i64 4, %arr.len125
  br i1 %arr.oob126, label %idx.bad127, label %idx.ok128, !prof !2

idx.bad127:                                       ; preds = %idx.ok121
  call void @__polaron_fail(ptr @.fail.51, ptr @.faila.52, i64 4, ptr @.failb.53, i64 %arr.len125, i32 70)
  unreachable

idx.ok128:                                        ; preds = %idx.ok121
  %arr.data129 = getelementptr i8, ptr %en124, i64 8
  %arr.elem130 = getelementptr inbounds i32, ptr %arr.data129, i64 4
  store i32 7, ptr %arr.elem130, align 4
  %st131 = load ptr, ptr %st, align 8, !nonnull !0, !dereferenceable !1
  %arr.len132 = load i64, ptr %st131, align 8
  %arr.oob133 = icmp uge i64 5, %arr.len132
  br i1 %arr.oob133, label %idx.bad134, label %idx.ok135, !prof !2

idx.bad134:                                       ; preds = %idx.ok128
  call void @__polaron_fail(ptr @.fail.54, ptr @.faila.55, i64 5, ptr @.failb.56, i64 %arr.len132, i32 70)
  unreachable

idx.ok135:                                        ; preds = %idx.ok128
  %arr.data136 = getelementptr i8, ptr %st131, i64 8
  %arr.elem137 = getelementptr inbounds i32, ptr %arr.data136, i64 5
  store i32 8, ptr %arr.elem137, align 4
  %en138 = load ptr, ptr %en, align 8, !nonnull !0, !dereferenceable !1
  %arr.len139 = load i64, ptr %en138, align 8
  %arr.oob140 = icmp uge i64 5, %arr.len139
  br i1 %arr.oob140, label %idx.bad141, label %idx.ok142, !prof !2

idx.bad141:                                       ; preds = %idx.ok135
  call void @__polaron_fail(ptr @.fail.57, ptr @.faila.58, i64 5, ptr @.failb.59, i64 %arr.len139, i32 70)
  unreachable

idx.ok142:                                        ; preds = %idx.ok135
  %arr.data143 = getelementptr i8, ptr %en138, i64 8
  %arr.elem144 = getelementptr inbounds i32, ptr %arr.data143, i64 5
  store i32 9, ptr %arr.elem144, align 4
  %st145 = load ptr, ptr %st, align 8, !nonnull !0, !dereferenceable !1
  %arr.len146 = load i64, ptr %st145, align 8
  %arr.oob147 = icmp uge i64 6, %arr.len146
  br i1 %arr.oob147, label %idx.bad148, label %idx.ok149, !prof !2

idx.bad148:                                       ; preds = %idx.ok142
  call void @__polaron_fail(ptr @.fail.60, ptr @.faila.61, i64 6, ptr @.failb.62, i64 %arr.len146, i32 70)
  unreachable

idx.ok149:                                        ; preds = %idx.ok142
  %arr.data150 = getelementptr i8, ptr %st145, i64 8
  %arr.elem151 = getelementptr inbounds i32, ptr %arr.data150, i64 6
  store i32 5, ptr %arr.elem151, align 4
  %en152 = load ptr, ptr %en, align 8, !nonnull !0, !dereferenceable !1
  %arr.len153 = load i64, ptr %en152, align 8
  %arr.oob154 = icmp uge i64 6, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !2

idx.bad155:                                       ; preds = %idx.ok149
  call void @__polaron_fail(ptr @.fail.63, ptr @.faila.64, i64 6, ptr @.failb.65, i64 %arr.len153, i32 70)
  unreachable

idx.ok156:                                        ; preds = %idx.ok149
  %arr.data157 = getelementptr i8, ptr %en152, i64 8
  %arr.elem158 = getelementptr inbounds i32, ptr %arr.data157, i64 6
  store i32 9, ptr %arr.elem158, align 4
  %st159 = load ptr, ptr %st, align 8
  %en160 = load ptr, ptr %en, align 8
  %22 = call i32 @IntervalScheduler.maxNonOverlapping(ptr %st159, ptr %en160, i32 7)
  store i32 %22, ptr %sched, align 4
  %knap161 = load i32, ptr %knap, align 4
  %lcs162 = load i32, ptr %lcs, align 4
  %sched163 = load i32, ptr %sched, align 4
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %knap161, i32 %lcs162, i32 %sched163)
  ret i32 0
}

define internal i32 @Knapsack.maxValue(ptr %0, ptr %1, i32 %2, i32 %3) {
entry:
  %cand = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %dp = alloca ptr, align 8
  %capacity = alloca i32, align 4
  %n = alloca i32, align 4
  %values = alloca ptr, align 8
  %weights = alloca ptr, align 8
  store ptr %0, ptr %weights, align 8
  store ptr %1, ptr %values, align 8
  store i32 %2, ptr %n, align 4
  store i32 %3, ptr %capacity, align 4
  %capacity1 = load i32, ptr %capacity, align 4
  %4 = add i32 %capacity1, 1
  %5 = sext i32 %4 to i64
  %6 = mul i64 %5, 4
  %7 = add i64 8, %6
  %arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %8 = call ptr @memset(ptr %arr.data, i32 0, i64 %6)
  store ptr %arr, ptr %dp, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %n3 = load i32, ptr %n, align 4
  %9 = icmp slt i32 %i2, %n3
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %capacity4 = load i32, ptr %capacity, align 4
  store i32 %capacity4, ptr %c, align 4
  br label %for.cond5

for.update:                                       ; preds = %for.end8
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dp60 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %capacity61 = load i32, ptr %capacity, align 4
  %13 = sext i32 %capacity61 to i64
  %arr.len62 = load i64, ptr %dp60, align 8
  %arr.oob63 = icmp uge i64 %13, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !2

for.cond5:                                        ; preds = %for.update7, %for.body
  %c9 = load i32, ptr %c, align 4
  %weights10 = load ptr, ptr %weights, align 8, !nonnull !0, !dereferenceable !1
  %i11 = load i32, ptr %i, align 4
  %14 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %weights10, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.body6:                                        ; preds = %idx.ok
  %dp13 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %c14 = load i32, ptr %c, align 4
  %weights15 = load ptr, ptr %weights, align 8, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %weights15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

for.update7:                                      ; preds = %if.end
  %c59 = load i32, ptr %c, align 4
  %16 = sub i32 %c59, 1
  store i32 %16, ptr %c, align 4
  br label %for.cond5

for.end8:                                         ; preds = %idx.ok
  br label %for.update

idx.bad:                                          ; preds = %for.cond5
  call void @__polaron_fail(ptr @.fail.2049, ptr @.faila.2050, i64 %14, ptr @.failb.2051, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.cond5
  %arr.data12 = getelementptr i8, ptr %weights10, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data12, i64 %14
  %elem = load i32, ptr %arr.elem, align 4
  %17 = icmp sge i32 %c9, %elem
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body6, label %for.end8

idx.bad19:                                        ; preds = %for.body6
  call void @__polaron_fail(ptr @.fail.2052, ptr @.faila.2053, i64 %15, ptr @.failb.2054, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body6
  %arr.data21 = getelementptr i8, ptr %weights15, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 %15
  %elem23 = load i32, ptr %arr.elem22, align 4
  %19 = sub i32 %c14, %elem23
  %20 = sext i32 %19 to i64
  %arr.len24 = load i64, ptr %dp13, align 8
  %arr.oob25 = icmp uge i64 %20, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !2

idx.bad26:                                        ; preds = %idx.ok20
  call void @__polaron_fail(ptr @.fail.2055, ptr @.faila.2056, i64 %20, ptr @.failb.2057, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %idx.ok20
  %arr.data28 = getelementptr i8, ptr %dp13, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 %20
  %elem30 = load i32, ptr %arr.elem29, align 4
  %values31 = load ptr, ptr %values, align 8, !nonnull !0, !dereferenceable !1
  %i32 = load i32, ptr %i, align 4
  %21 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %values31, align 8
  %arr.oob34 = icmp uge i64 %21, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.fail.2058, ptr @.faila.2059, i64 %21, ptr @.failb.2060, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok27
  %arr.data37 = getelementptr i8, ptr %values31, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 %21
  %elem39 = load i32, ptr %arr.elem38, align 4
  %22 = add i32 %elem30, %elem39
  store i32 %22, ptr %cand, align 4
  %cand40 = load i32, ptr %cand, align 4
  %dp41 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %c42 = load i32, ptr %c, align 4
  %23 = sext i32 %c42 to i64
  %arr.len43 = load i64, ptr %dp41, align 8
  %arr.oob44 = icmp uge i64 %23, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !2

idx.bad45:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.2061, ptr @.faila.2062, i64 %23, ptr @.failb.2063, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok36
  %arr.data47 = getelementptr i8, ptr %dp41, i64 8
  %arr.elem48 = getelementptr inbounds i32, ptr %arr.data47, i64 %23
  %elem49 = load i32, ptr %arr.elem48, align 4
  %24 = icmp sgt i32 %cand40, %elem49
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok46
  %dp50 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %c51 = load i32, ptr %c, align 4
  %26 = sext i32 %c51 to i64
  %arr.len52 = load i64, ptr %dp50, align 8
  %arr.oob53 = icmp uge i64 %26, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !2

if.end:                                           ; preds = %idx.ok55, %idx.ok46
  br label %for.update7

idx.bad54:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2064, ptr @.faila.2065, i64 %26, ptr @.failb.2066, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %if.then
  %arr.data56 = getelementptr i8, ptr %dp50, i64 8
  %arr.elem57 = getelementptr inbounds i32, ptr %arr.data56, i64 %26
  %cand58 = load i32, ptr %cand, align 4
  store i32 %cand58, ptr %arr.elem57, align 4
  br label %if.end

idx.bad64:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.2067, ptr @.faila.2068, i64 %13, ptr @.failb.2069, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %for.end
  %arr.data66 = getelementptr i8, ptr %dp60, i64 8
  %arr.elem67 = getelementptr inbounds i32, ptr %arr.data66, i64 %13
  %elem68 = load i32, ptr %arr.elem67, align 4
  ret i32 %elem68
}

define internal i32 @Lcs.length(ptr %0, ptr %1) {
entry:
  %left = alloca i32, align 4
  %up = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %w = alloca i32, align 4
  %dp = alloca ptr, align 8
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store ptr %1, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %str.len = getelementptr inbounds %String, ptr %a1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %m, align 4
  %b2 = load ptr, ptr %b, align 8
  %str.len3 = getelementptr inbounds %String, ptr %b2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %n, align 4
  %m5 = load i32, ptr %m, align 4
  %4 = add i32 %m5, 1
  %n6 = load i32, ptr %n, align 4
  %5 = add i32 %n6, 1
  %6 = mul i32 %4, %5
  %7 = sext i32 %6 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %10 = call ptr @memset(ptr %arr.data, i32 0, i64 %8)
  store ptr %arr, ptr %dp, align 8
  %n7 = load i32, ptr %n, align 4
  %11 = add i32 %n7, 1
  store i32 %11, ptr %w, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i8 = load i32, ptr %i, align 4
  %m9 = load i32, ptr %m, align 4
  %12 = icmp sle i32 %i8, %m9
  %13 = zext i1 %12 to i32
  br i1 %12, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 1, ptr %j, align 4
  br label %for.cond10

for.update:                                       ; preds = %for.end13
  %14 = load i32, ptr %i, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dp88 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %m89 = load i32, ptr %m, align 4
  %w90 = load i32, ptr %w, align 4
  %16 = mul i32 %m89, %w90
  %n91 = load i32, ptr %n, align 4
  %17 = add i32 %16, %n91
  %18 = sext i32 %17 to i64
  %arr.len92 = load i64, ptr %dp88, align 8
  %arr.oob93 = icmp uge i64 %18, %arr.len92
  br i1 %arr.oob93, label %idx.bad94, label %idx.ok95, !prof !2

for.cond10:                                       ; preds = %for.update12, %for.body
  %j14 = load i32, ptr %j, align 4
  %n15 = load i32, ptr %n, align 4
  %19 = icmp sle i32 %j14, %n15
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body11, label %for.end13

for.body11:                                       ; preds = %for.cond10
  %a16 = load ptr, ptr %a, align 8
  %i17 = load i32, ptr %i, align 4
  %21 = sub i32 %i17, 1
  %22 = sext i32 %21 to i64
  %str.data = getelementptr inbounds %String, ptr %a16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %22
  %ch = load i8, ptr %ch.addr, align 1
  %23 = zext i8 %ch to i32
  %b18 = load ptr, ptr %b, align 8
  %j19 = load i32, ptr %j, align 4
  %24 = sub i32 %j19, 1
  %25 = sext i32 %24 to i64
  %str.data20 = getelementptr inbounds %String, ptr %b18, i32 0, i32 1
  %data21 = load ptr, ptr %str.data20, align 8
  %ch.addr22 = getelementptr i8, ptr %data21, i64 %25
  %ch23 = load i8, ptr %ch.addr22, align 1
  %26 = zext i8 %ch23 to i32
  %27 = icmp eq i32 %23, %26
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then, label %if.else

for.update12:                                     ; preds = %if.end
  %29 = load i32, ptr %j, align 4
  %30 = add i32 %29, 1
  store i32 %30, ptr %j, align 4
  br label %for.cond10

for.end13:                                        ; preds = %for.cond10
  br label %for.update

if.then:                                          ; preds = %for.body11
  %dp24 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %i25 = load i32, ptr %i, align 4
  %w26 = load i32, ptr %w, align 4
  %31 = mul i32 %i25, %w26
  %j27 = load i32, ptr %j, align 4
  %32 = add i32 %31, %j27
  %33 = sext i32 %32 to i64
  %arr.len = load i64, ptr %dp24, align 8
  %arr.oob = icmp uge i64 %33, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.else:                                          ; preds = %for.body11
  %dp39 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %i40 = load i32, ptr %i, align 4
  %34 = sub i32 %i40, 1
  %w41 = load i32, ptr %w, align 4
  %35 = mul i32 %34, %w41
  %j42 = load i32, ptr %j, align 4
  %36 = add i32 %35, %j42
  %37 = sext i32 %36 to i64
  %arr.len43 = load i64, ptr %dp39, align 8
  %arr.oob44 = icmp uge i64 %37, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !2

if.end:                                           ; preds = %if.end65, %idx.ok36
  br label %for.update12

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2070, ptr @.faila.2071, i64 %33, ptr @.failb.2072, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data28 = getelementptr i8, ptr %dp24, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data28, i64 %33
  %dp29 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %i30 = load i32, ptr %i, align 4
  %38 = sub i32 %i30, 1
  %w31 = load i32, ptr %w, align 4
  %39 = mul i32 %38, %w31
  %j32 = load i32, ptr %j, align 4
  %40 = sub i32 %j32, 1
  %41 = add i32 %39, %40
  %42 = sext i32 %41 to i64
  %arr.len33 = load i64, ptr %dp29, align 8
  %arr.oob34 = icmp uge i64 %42, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2073, ptr @.faila.2074, i64 %42, ptr @.failb.2075, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok
  %arr.data37 = getelementptr i8, ptr %dp29, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 %42
  %elem = load i32, ptr %arr.elem38, align 4
  %43 = add i32 %elem, 1
  store i32 %43, ptr %arr.elem, align 4
  br label %if.end

idx.bad45:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.2076, ptr @.faila.2077, i64 %37, ptr @.failb.2078, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %if.else
  %arr.data47 = getelementptr i8, ptr %dp39, i64 8
  %arr.elem48 = getelementptr inbounds i32, ptr %arr.data47, i64 %37
  %elem49 = load i32, ptr %arr.elem48, align 4
  store i32 %elem49, ptr %up, align 4
  %dp50 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %i51 = load i32, ptr %i, align 4
  %w52 = load i32, ptr %w, align 4
  %44 = mul i32 %i51, %w52
  %j53 = load i32, ptr %j, align 4
  %45 = sub i32 %j53, 1
  %46 = add i32 %44, %45
  %47 = sext i32 %46 to i64
  %arr.len54 = load i64, ptr %dp50, align 8
  %arr.oob55 = icmp uge i64 %47, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !2

idx.bad56:                                        ; preds = %idx.ok46
  call void @__polaron_fail(ptr @.fail.2079, ptr @.faila.2080, i64 %47, ptr @.failb.2081, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %idx.ok46
  %arr.data58 = getelementptr i8, ptr %dp50, i64 8
  %arr.elem59 = getelementptr inbounds i32, ptr %arr.data58, i64 %47
  %elem60 = load i32, ptr %arr.elem59, align 4
  store i32 %elem60, ptr %left, align 4
  %up61 = load i32, ptr %up, align 4
  %left62 = load i32, ptr %left, align 4
  %48 = icmp sgt i32 %up61, %left62
  %49 = zext i1 %48 to i32
  br i1 %48, label %if.then63, label %if.else64

if.then63:                                        ; preds = %idx.ok57
  %dp66 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %i67 = load i32, ptr %i, align 4
  %w68 = load i32, ptr %w, align 4
  %50 = mul i32 %i67, %w68
  %j69 = load i32, ptr %j, align 4
  %51 = add i32 %50, %j69
  %52 = sext i32 %51 to i64
  %arr.len70 = load i64, ptr %dp66, align 8
  %arr.oob71 = icmp uge i64 %52, %arr.len70
  br i1 %arr.oob71, label %idx.bad72, label %idx.ok73, !prof !2

if.else64:                                        ; preds = %idx.ok57
  %dp77 = load ptr, ptr %dp, align 8, !nonnull !0, !dereferenceable !1
  %i78 = load i32, ptr %i, align 4
  %w79 = load i32, ptr %w, align 4
  %53 = mul i32 %i78, %w79
  %j80 = load i32, ptr %j, align 4
  %54 = add i32 %53, %j80
  %55 = sext i32 %54 to i64
  %arr.len81 = load i64, ptr %dp77, align 8
  %arr.oob82 = icmp uge i64 %55, %arr.len81
  br i1 %arr.oob82, label %idx.bad83, label %idx.ok84, !prof !2

if.end65:                                         ; preds = %idx.ok84, %idx.ok73
  br label %if.end

idx.bad72:                                        ; preds = %if.then63
  call void @__polaron_fail(ptr @.fail.2082, ptr @.faila.2083, i64 %52, ptr @.failb.2084, i64 %arr.len70, i32 70)
  unreachable

idx.ok73:                                         ; preds = %if.then63
  %arr.data74 = getelementptr i8, ptr %dp66, i64 8
  %arr.elem75 = getelementptr inbounds i32, ptr %arr.data74, i64 %52
  %up76 = load i32, ptr %up, align 4
  store i32 %up76, ptr %arr.elem75, align 4
  br label %if.end65

idx.bad83:                                        ; preds = %if.else64
  call void @__polaron_fail(ptr @.fail.2085, ptr @.faila.2086, i64 %55, ptr @.failb.2087, i64 %arr.len81, i32 70)
  unreachable

idx.ok84:                                         ; preds = %if.else64
  %arr.data85 = getelementptr i8, ptr %dp77, i64 8
  %arr.elem86 = getelementptr inbounds i32, ptr %arr.data85, i64 %55
  %left87 = load i32, ptr %left, align 4
  store i32 %left87, ptr %arr.elem86, align 4
  br label %if.end65

idx.bad94:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.2088, ptr @.faila.2089, i64 %18, ptr @.failb.2090, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %for.end
  %arr.data96 = getelementptr i8, ptr %dp88, i64 8
  %arr.elem97 = getelementptr inbounds i32, ptr %arr.data96, i64 %18
  %elem98 = load i32, ptr %arr.elem97, align 4
  ret i32 %elem98
}

define internal i32 @IntervalScheduler.maxNonOverlapping(ptr %0, ptr %1, i32 %2) {
entry:
  %i125 = alloca i32, align 4
  %lastEnd = alloca i32, align 4
  %count = alloca i32, align 4
  %j = alloca i32, align 4
  %ks = alloca i32, align 4
  %ke = alloca i32, align 4
  %i35 = alloca i32, align 4
  %i = alloca i32, align 4
  %e = alloca ptr, align 8
  %s = alloca ptr, align 8
  %n = alloca i32, align 4
  %ends = alloca ptr, align 8
  %starts = alloca ptr, align 8
  store ptr %0, ptr %starts, align 8
  store ptr %1, ptr %ends, align 8
  store i32 %2, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %3 = sext i32 %n1 to i64
  %4 = mul i64 %3, 4
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %s, align 8
  %n2 = load i32, ptr %n, align 4
  %7 = sext i32 %n2 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr3 = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %10 = call ptr @memset(ptr %arr.data4, i32 0, i64 %8)
  store ptr %arr3, ptr %e, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i5 = load i32, ptr %i, align 4
  %n6 = load i32, ptr %n, align 4
  %11 = icmp slt i32 %i5, %n6
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s7 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i8 = load i32, ptr %i, align 4
  %13 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %s7, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok31
  %14 = load i32, ptr %i, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %i35, align 4
  br label %for.cond36

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2229, ptr @.faila.2230, i64 %13, ptr @.failb.2231, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data9 = getelementptr i8, ptr %s7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 %13
  %starts10 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %i11 = load i32, ptr %i, align 4
  %16 = sext i32 %i11 to i64
  %arr.len12 = load i64, ptr %starts10, align 8
  %arr.oob13 = icmp uge i64 %16, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2232, ptr @.faila.2233, i64 %16, ptr @.failb.2234, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %starts10, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %16
  %elem = load i32, ptr %arr.elem17, align 4
  store i32 %elem, ptr %arr.elem, align 4
  %e18 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %i19 = load i32, ptr %i, align 4
  %17 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %e18, align 8
  %arr.oob21 = icmp uge i64 %17, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

idx.bad22:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.2235, ptr @.faila.2236, i64 %17, ptr @.failb.2237, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok15
  %arr.data24 = getelementptr i8, ptr %e18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %17
  %ends26 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %18 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %ends26, align 8
  %arr.oob29 = icmp uge i64 %18, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.2238, ptr @.faila.2239, i64 %18, ptr @.failb.2240, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok23
  %arr.data32 = getelementptr i8, ptr %ends26, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %18
  %elem34 = load i32, ptr %arr.elem33, align 4
  store i32 %elem34, ptr %arr.elem25, align 4
  br label %for.update

for.cond36:                                       ; preds = %for.update38, %for.end
  %i40 = load i32, ptr %i35, align 4
  %n41 = load i32, ptr %n, align 4
  %19 = icmp slt i32 %i40, %n41
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body37, label %for.end39

for.body37:                                       ; preds = %for.cond36
  %e42 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %i43 = load i32, ptr %i35, align 4
  %21 = sext i32 %i43 to i64
  %arr.len44 = load i64, ptr %e42, align 8
  %arr.oob45 = icmp uge i64 %21, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !2

for.update38:                                     ; preds = %idx.ok121
  %22 = load i32, ptr %i35, align 4
  %23 = add i32 %22, 1
  store i32 %23, ptr %i35, align 4
  br label %for.cond36

for.end39:                                        ; preds = %for.cond36
  store i32 0, ptr %count, align 4
  store i32 -2147483647, ptr %lastEnd, align 4
  store i32 0, ptr %i125, align 4
  br label %for.cond126

idx.bad46:                                        ; preds = %for.body37
  call void @__polaron_fail(ptr @.fail.2241, ptr @.faila.2242, i64 %21, ptr @.failb.2243, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %for.body37
  %arr.data48 = getelementptr i8, ptr %e42, i64 8
  %arr.elem49 = getelementptr inbounds i32, ptr %arr.data48, i64 %21
  %elem50 = load i32, ptr %arr.elem49, align 4
  store i32 %elem50, ptr %ke, align 4
  %s51 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i52 = load i32, ptr %i35, align 4
  %24 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %s51, align 8
  %arr.oob54 = icmp uge i64 %24, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !2

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.2244, ptr @.faila.2245, i64 %24, ptr @.failb.2246, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok47
  %arr.data57 = getelementptr i8, ptr %s51, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 %24
  %elem59 = load i32, ptr %arr.elem58, align 4
  store i32 %elem59, ptr %ks, align 4
  %i60 = load i32, ptr %i35, align 4
  %25 = sub i32 %i60, 1
  store i32 %25, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok102, %idx.ok56
  %j61 = load i32, ptr %j, align 4
  %26 = icmp sge i32 %j61, 0
  %27 = zext i1 %26 to i32
  %sc.a = icmp ne i32 %27, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %e72 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %j73 = load i32, ptr %j, align 4
  %28 = add i32 %j73, 1
  %29 = sext i32 %28 to i64
  %arr.len74 = load i64, ptr %e72, align 8
  %arr.oob75 = icmp uge i64 %29, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !2

while.end:                                        ; preds = %sc.end
  %e107 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %j108 = load i32, ptr %j, align 4
  %30 = add i32 %j108, 1
  %31 = sext i32 %30 to i64
  %arr.len109 = load i64, ptr %e107, align 8
  %arr.oob110 = icmp uge i64 %31, %arr.len109
  br i1 %arr.oob110, label %idx.bad111, label %idx.ok112, !prof !2

sc.rhs:                                           ; preds = %while.cond
  %e62 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %j63 = load i32, ptr %j, align 4
  %32 = sext i32 %j63 to i64
  %arr.len64 = load i64, ptr %e62, align 8
  %arr.oob65 = icmp uge i64 %32, %arr.len64
  br i1 %arr.oob65, label %idx.bad66, label %idx.ok67, !prof !2

sc.end:                                           ; preds = %idx.ok67, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok67 ]
  %33 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad66:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.2247, ptr @.faila.2248, i64 %32, ptr @.failb.2249, i64 %arr.len64, i32 70)
  unreachable

idx.ok67:                                         ; preds = %sc.rhs
  %arr.data68 = getelementptr i8, ptr %e62, i64 8
  %arr.elem69 = getelementptr inbounds i32, ptr %arr.data68, i64 %32
  %elem70 = load i32, ptr %arr.elem69, align 4
  %ke71 = load i32, ptr %ke, align 4
  %34 = icmp sgt i32 %elem70, %ke71
  %35 = zext i1 %34 to i32
  %sc.b = icmp ne i32 %35, 0
  br label %sc.end

idx.bad76:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.2250, ptr @.faila.2251, i64 %29, ptr @.failb.2252, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %while.body
  %arr.data78 = getelementptr i8, ptr %e72, i64 8
  %arr.elem79 = getelementptr inbounds i32, ptr %arr.data78, i64 %29
  %e80 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %j81 = load i32, ptr %j, align 4
  %36 = sext i32 %j81 to i64
  %arr.len82 = load i64, ptr %e80, align 8
  %arr.oob83 = icmp uge i64 %36, %arr.len82
  br i1 %arr.oob83, label %idx.bad84, label %idx.ok85, !prof !2

idx.bad84:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.2253, ptr @.faila.2254, i64 %36, ptr @.failb.2255, i64 %arr.len82, i32 70)
  unreachable

idx.ok85:                                         ; preds = %idx.ok77
  %arr.data86 = getelementptr i8, ptr %e80, i64 8
  %arr.elem87 = getelementptr inbounds i32, ptr %arr.data86, i64 %36
  %elem88 = load i32, ptr %arr.elem87, align 4
  store i32 %elem88, ptr %arr.elem79, align 4
  %s89 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %j90 = load i32, ptr %j, align 4
  %37 = add i32 %j90, 1
  %38 = sext i32 %37 to i64
  %arr.len91 = load i64, ptr %s89, align 8
  %arr.oob92 = icmp uge i64 %38, %arr.len91
  br i1 %arr.oob92, label %idx.bad93, label %idx.ok94, !prof !2

idx.bad93:                                        ; preds = %idx.ok85
  call void @__polaron_fail(ptr @.fail.2256, ptr @.faila.2257, i64 %38, ptr @.failb.2258, i64 %arr.len91, i32 70)
  unreachable

idx.ok94:                                         ; preds = %idx.ok85
  %arr.data95 = getelementptr i8, ptr %s89, i64 8
  %arr.elem96 = getelementptr inbounds i32, ptr %arr.data95, i64 %38
  %s97 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %j98 = load i32, ptr %j, align 4
  %39 = sext i32 %j98 to i64
  %arr.len99 = load i64, ptr %s97, align 8
  %arr.oob100 = icmp uge i64 %39, %arr.len99
  br i1 %arr.oob100, label %idx.bad101, label %idx.ok102, !prof !2

idx.bad101:                                       ; preds = %idx.ok94
  call void @__polaron_fail(ptr @.fail.2259, ptr @.faila.2260, i64 %39, ptr @.failb.2261, i64 %arr.len99, i32 70)
  unreachable

idx.ok102:                                        ; preds = %idx.ok94
  %arr.data103 = getelementptr i8, ptr %s97, i64 8
  %arr.elem104 = getelementptr inbounds i32, ptr %arr.data103, i64 %39
  %elem105 = load i32, ptr %arr.elem104, align 4
  store i32 %elem105, ptr %arr.elem96, align 4
  %j106 = load i32, ptr %j, align 4
  %40 = sub i32 %j106, 1
  store i32 %40, ptr %j, align 4
  br label %while.cond

idx.bad111:                                       ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.2262, ptr @.faila.2263, i64 %31, ptr @.failb.2264, i64 %arr.len109, i32 70)
  unreachable

idx.ok112:                                        ; preds = %while.end
  %arr.data113 = getelementptr i8, ptr %e107, i64 8
  %arr.elem114 = getelementptr inbounds i32, ptr %arr.data113, i64 %31
  %ke115 = load i32, ptr %ke, align 4
  store i32 %ke115, ptr %arr.elem114, align 4
  %s116 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %j117 = load i32, ptr %j, align 4
  %41 = add i32 %j117, 1
  %42 = sext i32 %41 to i64
  %arr.len118 = load i64, ptr %s116, align 8
  %arr.oob119 = icmp uge i64 %42, %arr.len118
  br i1 %arr.oob119, label %idx.bad120, label %idx.ok121, !prof !2

idx.bad120:                                       ; preds = %idx.ok112
  call void @__polaron_fail(ptr @.fail.2265, ptr @.faila.2266, i64 %42, ptr @.failb.2267, i64 %arr.len118, i32 70)
  unreachable

idx.ok121:                                        ; preds = %idx.ok112
  %arr.data122 = getelementptr i8, ptr %s116, i64 8
  %arr.elem123 = getelementptr inbounds i32, ptr %arr.data122, i64 %42
  %ks124 = load i32, ptr %ks, align 4
  store i32 %ks124, ptr %arr.elem123, align 4
  br label %for.update38

for.cond126:                                      ; preds = %for.update128, %for.end39
  %i130 = load i32, ptr %i125, align 4
  %n131 = load i32, ptr %n, align 4
  %43 = icmp slt i32 %i130, %n131
  %44 = zext i1 %43 to i32
  br i1 %43, label %for.body127, label %for.end129

for.body127:                                      ; preds = %for.cond126
  %s132 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i133 = load i32, ptr %i125, align 4
  %45 = sext i32 %i133 to i64
  %arr.len134 = load i64, ptr %s132, align 8
  %arr.oob135 = icmp uge i64 %45, %arr.len134
  br i1 %arr.oob135, label %idx.bad136, label %idx.ok137, !prof !2

for.update128:                                    ; preds = %if.end
  %46 = load i32, ptr %i125, align 4
  %47 = add i32 %46, 1
  store i32 %47, ptr %i125, align 4
  br label %for.cond126

for.end129:                                       ; preds = %for.cond126
  %count152 = load i32, ptr %count, align 4
  ret i32 %count152

idx.bad136:                                       ; preds = %for.body127
  call void @__polaron_fail(ptr @.fail.2268, ptr @.faila.2269, i64 %45, ptr @.failb.2270, i64 %arr.len134, i32 70)
  unreachable

idx.ok137:                                        ; preds = %for.body127
  %arr.data138 = getelementptr i8, ptr %s132, i64 8
  %arr.elem139 = getelementptr inbounds i32, ptr %arr.data138, i64 %45
  %elem140 = load i32, ptr %arr.elem139, align 4
  %lastEnd141 = load i32, ptr %lastEnd, align 4
  %48 = icmp sge i32 %elem140, %lastEnd141
  %49 = zext i1 %48 to i32
  br i1 %48, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok137
  %count142 = load i32, ptr %count, align 4
  %50 = add i32 %count142, 1
  store i32 %50, ptr %count, align 4
  %e143 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %i144 = load i32, ptr %i125, align 4
  %51 = sext i32 %i144 to i64
  %arr.len145 = load i64, ptr %e143, align 8
  %arr.oob146 = icmp uge i64 %51, %arr.len145
  br i1 %arr.oob146, label %idx.bad147, label %idx.ok148, !prof !2

if.end:                                           ; preds = %idx.ok148, %idx.ok137
  br label %for.update128

idx.bad147:                                       ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2271, ptr @.faila.2272, i64 %51, ptr @.failb.2273, i64 %arr.len145, i32 70)
  unreachable

idx.ok148:                                        ; preds = %if.then
  %arr.data149 = getelementptr i8, ptr %e143, i64 8
  %arr.elem150 = getelementptr inbounds i32, ptr %arr.data149, i64 %51
  %elem151 = load i32, ptr %arr.elem150, align 4
  store i32 %elem151, ptr %lastEnd, align 4
  br label %if.end
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5376)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5378)
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

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
