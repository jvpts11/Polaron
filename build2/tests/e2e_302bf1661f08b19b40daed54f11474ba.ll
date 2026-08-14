; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.fail = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:15:21  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:15:29  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:15:37  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:15:45  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:15:53  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:15:61  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:15:70  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:15:79  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [34 x i8] c"merged=%d covered=%d first=%d-%d\0A\00", align 1
@.fail.22 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:17:41  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:17:41  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:23  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:35  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:45  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:57  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:67  in main\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:79  in main\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:89  in main\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.49 = private unnamed_addr constant [131 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:99  in main\0A\00", align 1
@.faila.50 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.51 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.52 = private unnamed_addr constant [132 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/merge_kadane.pol:21:111  in main\0A\00", align 1
@.faila.53 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.54 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.55 = private unnamed_addr constant [11 x i8] c"kadane=%d\0A\00", align 1
@.fail.2139 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2720:17  in Kadane.maxSubarray\0A\00", align 1
@.faila.2140 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2141 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2142 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2721:17  in Kadane.maxSubarray\0A\00", align 1
@.faila.2143 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2144 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2145 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2723:21  in Kadane.maxSubarray\0A\00", align 1
@.faila.2146 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2147 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2148 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2724:21  in Kadane.maxSubarray\0A\00", align 1
@.faila.2149 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2150 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2151 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2724:43  in Kadane.maxSubarray\0A\00", align 1
@.faila.2152 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2153 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2154 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2736:21  in IntervalMerge.merge\0A\00", align 1
@.faila.2155 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2156 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2157 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2736:41  in IntervalMerge.merge\0A\00", align 1
@.faila.2158 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2159 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2160 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2738:21  in IntervalMerge.merge\0A\00", align 1
@.faila.2161 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2162 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2163 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2738:68  in IntervalMerge.merge\0A\00", align 1
@.faila.2164 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2165 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2166 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2738:68  in IntervalMerge.merge\0A\00", align 1
@.faila.2167 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2168 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2169 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2738:91  in IntervalMerge.merge\0A\00", align 1
@.faila.2170 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2171 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2172 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2738:91  in IntervalMerge.merge\0A\00", align 1
@.faila.2173 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2174 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2175 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2739:33  in IntervalMerge.merge\0A\00", align 1
@.faila.2176 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2177 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2178 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2739:49  in IntervalMerge.merge\0A\00", align 1
@.faila.2179 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2180 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2181 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2744:21  in IntervalMerge.merge\0A\00", align 1
@.faila.2182 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2183 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2184 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2744:21  in IntervalMerge.merge\0A\00", align 1
@.faila.2185 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2186 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2187 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2745:25  in IntervalMerge.merge\0A\00", align 1
@.faila.2188 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2189 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2190 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2745:25  in IntervalMerge.merge\0A\00", align 1
@.faila.2191 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2192 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2193 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2745:70  in IntervalMerge.merge\0A\00", align 1
@.faila.2194 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2195 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2196 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2745:70  in IntervalMerge.merge\0A\00", align 1
@.faila.2197 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2198 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2199 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2747:39  in IntervalMerge.merge\0A\00", align 1
@.faila.2200 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2201 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2202 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2747:39  in IntervalMerge.merge\0A\00", align 1
@.faila.2203 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2204 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2205 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2747:64  in IntervalMerge.merge\0A\00", align 1
@.faila.2206 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2207 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2208 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2747:64  in IntervalMerge.merge\0A\00", align 1
@.faila.2209 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2210 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2211 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2754:71  in IntervalMerge.coveredLength\0A\00", align 1
@.faila.2212 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2213 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2214 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2754:71  in IntervalMerge.coveredLength\0A\00", align 1
@.faila.2215 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2216 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5363 = private constant [1 x i8] zeroinitializer
@.strobj.5364 = private global %String { i64 0, ptr @.strdata.5363, i64 0 }
@.strdata.5365 = private constant [1 x i8] zeroinitializer
@.strobj.5366 = private global %String { i64 0, ptr @.strdata.5365, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %arr78 = alloca ptr, align 8
  %m = alloca i32, align 4
  %e = alloca ptr, align 8
  %s = alloca ptr, align 8
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
  store ptr %arr, ptr %s, align 8
  %arr2 = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr2, align 8
  %arr.data3 = getelementptr i8, ptr %arr2, i64 8
  %17 = call ptr @memset(ptr %arr.data3, i32 0, i64 16)
  store ptr %arr2, ptr %e, align 8
  %s4 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %s4, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data5 = getelementptr i8, ptr %s4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data5, i64 0
  store i32 1, ptr %arr.elem, align 4
  %e6 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %arr.len7 = load i64, ptr %e6, align 8
  %arr.oob8 = icmp uge i64 0, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 0, ptr @.failb.3, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %e6, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 0
  store i32 3, ptr %arr.elem12, align 4
  %s13 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %arr.len14 = load i64, ptr %s13, align 8
  %arr.oob15 = icmp uge i64 1, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad16:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 1, ptr @.failb.6, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok10
  %arr.data18 = getelementptr i8, ptr %s13, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 1
  store i32 2, ptr %arr.elem19, align 4
  %e20 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %arr.len21 = load i64, ptr %e20, align 8
  %arr.oob22 = icmp uge i64 1, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

idx.bad23:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 1, ptr @.failb.9, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok17
  %arr.data25 = getelementptr i8, ptr %e20, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 1
  store i32 6, ptr %arr.elem26, align 4
  %s27 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %arr.len28 = load i64, ptr %s27, align 8
  %arr.oob29 = icmp uge i64 2, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 2, ptr @.failb.12, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok24
  %arr.data32 = getelementptr i8, ptr %s27, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 2
  store i32 8, ptr %arr.elem33, align 4
  %e34 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %arr.len35 = load i64, ptr %e34, align 8
  %arr.oob36 = icmp uge i64 2, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !2

idx.bad37:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 2, ptr @.failb.15, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %idx.ok31
  %arr.data39 = getelementptr i8, ptr %e34, i64 8
  %arr.elem40 = getelementptr inbounds i32, ptr %arr.data39, i64 2
  store i32 10, ptr %arr.elem40, align 4
  %s41 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %arr.len42 = load i64, ptr %s41, align 8
  %arr.oob43 = icmp uge i64 3, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !2

idx.bad44:                                        ; preds = %idx.ok38
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 3, ptr @.failb.18, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok38
  %arr.data46 = getelementptr i8, ptr %s41, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 3
  store i32 15, ptr %arr.elem47, align 4
  %e48 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %arr.len49 = load i64, ptr %e48, align 8
  %arr.oob50 = icmp uge i64 3, %arr.len49
  br i1 %arr.oob50, label %idx.bad51, label %idx.ok52, !prof !2

idx.bad51:                                        ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 3, ptr @.failb.21, i64 %arr.len49, i32 70)
  unreachable

idx.ok52:                                         ; preds = %idx.ok45
  %arr.data53 = getelementptr i8, ptr %e48, i64 8
  %arr.elem54 = getelementptr inbounds i32, ptr %arr.data53, i64 3
  store i32 18, ptr %arr.elem54, align 4
  %s55 = load ptr, ptr %s, align 8
  %e56 = load ptr, ptr %e, align 8
  %18 = call i32 @IntervalMerge.merge(ptr %s55, ptr %e56, i32 4)
  store i32 %18, ptr %m, align 4
  %m57 = load i32, ptr %m, align 4
  %s58 = load ptr, ptr %s, align 8
  %e59 = load ptr, ptr %e, align 8
  %m60 = load i32, ptr %m, align 4
  %19 = call i32 @IntervalMerge.coveredLength(ptr %s58, ptr %e59, i32 %m60)
  %s61 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %arr.len62 = load i64, ptr %s61, align 8
  %arr.oob63 = icmp uge i64 0, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !2

idx.bad64:                                        ; preds = %idx.ok52
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 0, ptr @.failb.24, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %idx.ok52
  %arr.data66 = getelementptr i8, ptr %s61, i64 8
  %arr.elem67 = getelementptr inbounds i32, ptr %arr.data66, i64 0
  %elem = load i32, ptr %arr.elem67, align 4
  %e68 = load ptr, ptr %e, align 8, !nonnull !0, !dereferenceable !1
  %arr.len69 = load i64, ptr %e68, align 8
  %arr.oob70 = icmp uge i64 0, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !2

idx.bad71:                                        ; preds = %idx.ok65
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 0, ptr @.failb.27, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok65
  %arr.data73 = getelementptr i8, ptr %e68, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 0
  %elem75 = load i32, ptr %arr.elem74, align 4
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %m57, i32 %19, i32 %elem, i32 %elem75)
  %arr76 = call ptr @__polaron_malloc(i64 44)
  store i64 9, ptr %arr76, align 8
  %arr.data77 = getelementptr i8, ptr %arr76, i64 8
  %21 = call ptr @memset(ptr %arr.data77, i32 0, i64 36)
  store ptr %arr76, ptr %arr78, align 8
  %arr79 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len80 = load i64, ptr %arr79, align 8
  %arr.oob81 = icmp uge i64 0, %arr.len80
  br i1 %arr.oob81, label %idx.bad82, label %idx.ok83, !prof !2

idx.bad82:                                        ; preds = %idx.ok72
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 0, ptr @.failb.30, i64 %arr.len80, i32 70)
  unreachable

idx.ok83:                                         ; preds = %idx.ok72
  %arr.data84 = getelementptr i8, ptr %arr79, i64 8
  %arr.elem85 = getelementptr inbounds i32, ptr %arr.data84, i64 0
  store i32 -2, ptr %arr.elem85, align 4
  %arr86 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len87 = load i64, ptr %arr86, align 8
  %arr.oob88 = icmp uge i64 1, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !2

idx.bad89:                                        ; preds = %idx.ok83
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 1, ptr @.failb.33, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok83
  %arr.data91 = getelementptr i8, ptr %arr86, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 1
  store i32 1, ptr %arr.elem92, align 4
  %arr93 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len94 = load i64, ptr %arr93, align 8
  %arr.oob95 = icmp uge i64 2, %arr.len94
  br i1 %arr.oob95, label %idx.bad96, label %idx.ok97, !prof !2

idx.bad96:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 2, ptr @.failb.36, i64 %arr.len94, i32 70)
  unreachable

idx.ok97:                                         ; preds = %idx.ok90
  %arr.data98 = getelementptr i8, ptr %arr93, i64 8
  %arr.elem99 = getelementptr inbounds i32, ptr %arr.data98, i64 2
  store i32 -3, ptr %arr.elem99, align 4
  %arr100 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len101 = load i64, ptr %arr100, align 8
  %arr.oob102 = icmp uge i64 3, %arr.len101
  br i1 %arr.oob102, label %idx.bad103, label %idx.ok104, !prof !2

idx.bad103:                                       ; preds = %idx.ok97
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 3, ptr @.failb.39, i64 %arr.len101, i32 70)
  unreachable

idx.ok104:                                        ; preds = %idx.ok97
  %arr.data105 = getelementptr i8, ptr %arr100, i64 8
  %arr.elem106 = getelementptr inbounds i32, ptr %arr.data105, i64 3
  store i32 4, ptr %arr.elem106, align 4
  %arr107 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len108 = load i64, ptr %arr107, align 8
  %arr.oob109 = icmp uge i64 4, %arr.len108
  br i1 %arr.oob109, label %idx.bad110, label %idx.ok111, !prof !2

idx.bad110:                                       ; preds = %idx.ok104
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 4, ptr @.failb.42, i64 %arr.len108, i32 70)
  unreachable

idx.ok111:                                        ; preds = %idx.ok104
  %arr.data112 = getelementptr i8, ptr %arr107, i64 8
  %arr.elem113 = getelementptr inbounds i32, ptr %arr.data112, i64 4
  store i32 -1, ptr %arr.elem113, align 4
  %arr114 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len115 = load i64, ptr %arr114, align 8
  %arr.oob116 = icmp uge i64 5, %arr.len115
  br i1 %arr.oob116, label %idx.bad117, label %idx.ok118, !prof !2

idx.bad117:                                       ; preds = %idx.ok111
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 5, ptr @.failb.45, i64 %arr.len115, i32 70)
  unreachable

idx.ok118:                                        ; preds = %idx.ok111
  %arr.data119 = getelementptr i8, ptr %arr114, i64 8
  %arr.elem120 = getelementptr inbounds i32, ptr %arr.data119, i64 5
  store i32 2, ptr %arr.elem120, align 4
  %arr121 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len122 = load i64, ptr %arr121, align 8
  %arr.oob123 = icmp uge i64 6, %arr.len122
  br i1 %arr.oob123, label %idx.bad124, label %idx.ok125, !prof !2

idx.bad124:                                       ; preds = %idx.ok118
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 6, ptr @.failb.48, i64 %arr.len122, i32 70)
  unreachable

idx.ok125:                                        ; preds = %idx.ok118
  %arr.data126 = getelementptr i8, ptr %arr121, i64 8
  %arr.elem127 = getelementptr inbounds i32, ptr %arr.data126, i64 6
  store i32 1, ptr %arr.elem127, align 4
  %arr128 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len129 = load i64, ptr %arr128, align 8
  %arr.oob130 = icmp uge i64 7, %arr.len129
  br i1 %arr.oob130, label %idx.bad131, label %idx.ok132, !prof !2

idx.bad131:                                       ; preds = %idx.ok125
  call void @__polaron_fail(ptr @.fail.49, ptr @.faila.50, i64 7, ptr @.failb.51, i64 %arr.len129, i32 70)
  unreachable

idx.ok132:                                        ; preds = %idx.ok125
  %arr.data133 = getelementptr i8, ptr %arr128, i64 8
  %arr.elem134 = getelementptr inbounds i32, ptr %arr.data133, i64 7
  store i32 -5, ptr %arr.elem134, align 4
  %arr135 = load ptr, ptr %arr78, align 8, !nonnull !0, !dereferenceable !1
  %arr.len136 = load i64, ptr %arr135, align 8
  %arr.oob137 = icmp uge i64 8, %arr.len136
  br i1 %arr.oob137, label %idx.bad138, label %idx.ok139, !prof !2

idx.bad138:                                       ; preds = %idx.ok132
  call void @__polaron_fail(ptr @.fail.52, ptr @.faila.53, i64 8, ptr @.failb.54, i64 %arr.len136, i32 70)
  unreachable

idx.ok139:                                        ; preds = %idx.ok132
  %arr.data140 = getelementptr i8, ptr %arr135, i64 8
  %arr.elem141 = getelementptr inbounds i32, ptr %arr.data140, i64 8
  store i32 4, ptr %arr.elem141, align 4
  %arr142 = load ptr, ptr %arr78, align 8
  %22 = call i32 @Kadane.maxSubarray(ptr %arr142, i32 9)
  %23 = call i32 (ptr, ...) @printf(ptr @.str.55, i32 %22)
  ret i32 0
}

define internal i32 @Kadane.maxSubarray(ptr %0, i32 %1) {
entry:
  %ext = alloca i32, align 4
  %i = alloca i32, align 4
  %cur = alloca i32, align 4
  %best = alloca i32, align 4
  %n = alloca i32, align 4
  %a = alloca ptr, align 8
  store ptr %0, ptr %a, align 8
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %2 = icmp eq i32 %n1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %a2 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %a2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.2139, ptr @.faila.2140, i64 0, ptr @.failb.2141, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %a2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %best, align 4
  %a3 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %arr.len4 = load i64, ptr %a3, align 8
  %arr.oob5 = icmp uge i64 0, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !2

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2142, ptr @.faila.2143, i64 0, ptr @.failb.2144, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %a3, i64 8
  %arr.elem9 = getelementptr inbounds i32, ptr %arr.data8, i64 0
  %elem10 = load i32, ptr %arr.elem9, align 4
  store i32 %elem10, ptr %cur, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok7
  %i11 = load i32, ptr %i, align 4
  %n12 = load i32, ptr %n, align 4
  %4 = icmp slt i32 %i11, %n12
  %5 = zext i1 %4 to i32
  br i1 %4, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %cur13 = load i32, ptr %cur, align 4
  %a14 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i15 = load i32, ptr %i, align 4
  %6 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %a14, align 8
  %arr.oob17 = icmp uge i64 %6, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

for.update:                                       ; preds = %if.end48
  %7 = load i32, ptr %i, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best50 = load i32, ptr %best, align 4
  ret i32 %best50

idx.bad18:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2145, ptr @.faila.2146, i64 %6, ptr @.failb.2147, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %for.body
  %arr.data20 = getelementptr i8, ptr %a14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %6
  %elem22 = load i32, ptr %arr.elem21, align 4
  %9 = add i32 %cur13, %elem22
  store i32 %9, ptr %ext, align 4
  %a23 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i24 = load i32, ptr %i, align 4
  %10 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %a23, align 8
  %arr.oob26 = icmp uge i64 %10, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !2

idx.bad27:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.2148, ptr @.faila.2149, i64 %10, ptr @.failb.2150, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok19
  %arr.data29 = getelementptr i8, ptr %a23, i64 8
  %arr.elem30 = getelementptr inbounds i32, ptr %arr.data29, i64 %10
  %elem31 = load i32, ptr %arr.elem30, align 4
  %ext32 = load i32, ptr %ext, align 4
  %11 = icmp sgt i32 %elem31, %ext32
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then33, label %if.else

if.then33:                                        ; preds = %idx.ok28
  %a35 = load ptr, ptr %a, align 8, !nonnull !0, !dereferenceable !1
  %i36 = load i32, ptr %i, align 4
  %13 = sext i32 %i36 to i64
  %arr.len37 = load i64, ptr %a35, align 8
  %arr.oob38 = icmp uge i64 %13, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

if.else:                                          ; preds = %idx.ok28
  %ext44 = load i32, ptr %ext, align 4
  store i32 %ext44, ptr %cur, align 4
  br label %if.end34

if.end34:                                         ; preds = %if.else, %idx.ok40
  %cur45 = load i32, ptr %cur, align 4
  %best46 = load i32, ptr %best, align 4
  %14 = icmp sgt i32 %cur45, %best46
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then47, label %if.end48

idx.bad39:                                        ; preds = %if.then33
  call void @__polaron_fail(ptr @.fail.2151, ptr @.faila.2152, i64 %13, ptr @.failb.2153, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %if.then33
  %arr.data41 = getelementptr i8, ptr %a35, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %13
  %elem43 = load i32, ptr %arr.elem42, align 4
  store i32 %elem43, ptr %cur, align 4
  br label %if.end34

if.then47:                                        ; preds = %if.end34
  %cur49 = load i32, ptr %cur, align 4
  store i32 %cur49, ptr %best, align 4
  br label %if.end48

if.end48:                                         ; preds = %if.then47, %if.end34
  br label %for.update
}

define internal i32 @IntervalMerge.merge(ptr %0, ptr %1, i32 %2) {
entry:
  %i80 = alloca i32, align 4
  %count = alloca i32, align 4
  %j = alloca i32, align 4
  %ke = alloca i32, align 4
  %ks = alloca i32, align 4
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %ends = alloca ptr, align 8
  %starts = alloca ptr, align 8
  store ptr %0, ptr %starts, align 8
  store ptr %1, ptr %ends, align 8
  store i32 %2, ptr %n, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %i1, %n2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %starts3 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %i4 = load i32, ptr %i, align 4
  %5 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %starts3, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok75
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %n79 = load i32, ptr %n, align 4
  %8 = icmp eq i32 %n79, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2154, ptr @.faila.2155, i64 %5, ptr @.failb.2156, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %starts3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %ks, align 4
  %ends5 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %10 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %ends5, align 8
  %arr.oob8 = icmp uge i64 %10, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2157, ptr @.faila.2158, i64 %10, ptr @.failb.2159, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %ends5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %10
  %elem13 = load i32, ptr %arr.elem12, align 4
  store i32 %elem13, ptr %ke, align 4
  %i14 = load i32, ptr %i, align 4
  %11 = sub i32 %i14, 1
  store i32 %11, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok56, %idx.ok10
  %j15 = load i32, ptr %j, align 4
  %12 = icmp sge i32 %j15, 0
  %13 = zext i1 %12 to i32
  %sc.a = icmp ne i32 %13, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %starts26 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %j27 = load i32, ptr %j, align 4
  %14 = add i32 %j27, 1
  %15 = sext i32 %14 to i64
  %arr.len28 = load i64, ptr %starts26, align 8
  %arr.oob29 = icmp uge i64 %15, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

while.end:                                        ; preds = %sc.end
  %starts61 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %j62 = load i32, ptr %j, align 4
  %16 = add i32 %j62, 1
  %17 = sext i32 %16 to i64
  %arr.len63 = load i64, ptr %starts61, align 8
  %arr.oob64 = icmp uge i64 %17, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !2

sc.rhs:                                           ; preds = %while.cond
  %starts16 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %j17 = load i32, ptr %j, align 4
  %18 = sext i32 %j17 to i64
  %arr.len18 = load i64, ptr %starts16, align 8
  %arr.oob19 = icmp uge i64 %18, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !2

sc.end:                                           ; preds = %idx.ok21, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok21 ]
  %19 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad20:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.2160, ptr @.faila.2161, i64 %18, ptr @.failb.2162, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %sc.rhs
  %arr.data22 = getelementptr i8, ptr %starts16, i64 8
  %arr.elem23 = getelementptr inbounds i32, ptr %arr.data22, i64 %18
  %elem24 = load i32, ptr %arr.elem23, align 4
  %ks25 = load i32, ptr %ks, align 4
  %20 = icmp sgt i32 %elem24, %ks25
  %21 = zext i1 %20 to i32
  %sc.b = icmp ne i32 %21, 0
  br label %sc.end

idx.bad30:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.2163, ptr @.faila.2164, i64 %15, ptr @.failb.2165, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %while.body
  %arr.data32 = getelementptr i8, ptr %starts26, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %15
  %starts34 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %j35 = load i32, ptr %j, align 4
  %22 = sext i32 %j35 to i64
  %arr.len36 = load i64, ptr %starts34, align 8
  %arr.oob37 = icmp uge i64 %22, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad38:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.2166, ptr @.faila.2167, i64 %22, ptr @.failb.2168, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok31
  %arr.data40 = getelementptr i8, ptr %starts34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %22
  %elem42 = load i32, ptr %arr.elem41, align 4
  store i32 %elem42, ptr %arr.elem33, align 4
  %ends43 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %j44 = load i32, ptr %j, align 4
  %23 = add i32 %j44, 1
  %24 = sext i32 %23 to i64
  %arr.len45 = load i64, ptr %ends43, align 8
  %arr.oob46 = icmp uge i64 %24, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

idx.bad47:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.2169, ptr @.faila.2170, i64 %24, ptr @.failb.2171, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok39
  %arr.data49 = getelementptr i8, ptr %ends43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %24
  %ends51 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %j52 = load i32, ptr %j, align 4
  %25 = sext i32 %j52 to i64
  %arr.len53 = load i64, ptr %ends51, align 8
  %arr.oob54 = icmp uge i64 %25, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !2

idx.bad55:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.2172, ptr @.faila.2173, i64 %25, ptr @.failb.2174, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok48
  %arr.data57 = getelementptr i8, ptr %ends51, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 %25
  %elem59 = load i32, ptr %arr.elem58, align 4
  store i32 %elem59, ptr %arr.elem50, align 4
  %j60 = load i32, ptr %j, align 4
  %26 = sub i32 %j60, 1
  store i32 %26, ptr %j, align 4
  br label %while.cond

idx.bad65:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.2175, ptr @.faila.2176, i64 %17, ptr @.failb.2177, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %while.end
  %arr.data67 = getelementptr i8, ptr %starts61, i64 8
  %arr.elem68 = getelementptr inbounds i32, ptr %arr.data67, i64 %17
  %ks69 = load i32, ptr %ks, align 4
  store i32 %ks69, ptr %arr.elem68, align 4
  %ends70 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %j71 = load i32, ptr %j, align 4
  %27 = add i32 %j71, 1
  %28 = sext i32 %27 to i64
  %arr.len72 = load i64, ptr %ends70, align 8
  %arr.oob73 = icmp uge i64 %28, %arr.len72
  br i1 %arr.oob73, label %idx.bad74, label %idx.ok75, !prof !2

idx.bad74:                                        ; preds = %idx.ok66
  call void @__polaron_fail(ptr @.fail.2178, ptr @.faila.2179, i64 %28, ptr @.failb.2180, i64 %arr.len72, i32 70)
  unreachable

idx.ok75:                                         ; preds = %idx.ok66
  %arr.data76 = getelementptr i8, ptr %ends70, i64 8
  %arr.elem77 = getelementptr inbounds i32, ptr %arr.data76, i64 %28
  %ke78 = load i32, ptr %ke, align 4
  store i32 %ke78, ptr %arr.elem77, align 4
  br label %for.update

if.then:                                          ; preds = %for.end
  ret i32 0

if.end:                                           ; preds = %for.end
  store i32 1, ptr %count, align 4
  store i32 1, ptr %i80, align 4
  br label %for.cond81

for.cond81:                                       ; preds = %for.update83, %if.end
  %i85 = load i32, ptr %i80, align 4
  %n86 = load i32, ptr %n, align 4
  %29 = icmp slt i32 %i85, %n86
  %30 = zext i1 %29 to i32
  br i1 %29, label %for.body82, label %for.end84

for.body82:                                       ; preds = %for.cond81
  %starts87 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %i88 = load i32, ptr %i80, align 4
  %31 = sext i32 %i88 to i64
  %arr.len89 = load i64, ptr %starts87, align 8
  %arr.oob90 = icmp uge i64 %31, %arr.len89
  br i1 %arr.oob90, label %idx.bad91, label %idx.ok92, !prof !2

for.update83:                                     ; preds = %if.end106
  %32 = load i32, ptr %i80, align 4
  %33 = add i32 %32, 1
  store i32 %33, ptr %i80, align 4
  br label %for.cond81

for.end84:                                        ; preds = %for.cond81
  %count179 = load i32, ptr %count, align 4
  ret i32 %count179

idx.bad91:                                        ; preds = %for.body82
  call void @__polaron_fail(ptr @.fail.2181, ptr @.faila.2182, i64 %31, ptr @.failb.2183, i64 %arr.len89, i32 70)
  unreachable

idx.ok92:                                         ; preds = %for.body82
  %arr.data93 = getelementptr i8, ptr %starts87, i64 8
  %arr.elem94 = getelementptr inbounds i32, ptr %arr.data93, i64 %31
  %elem95 = load i32, ptr %arr.elem94, align 4
  %ends96 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %count97 = load i32, ptr %count, align 4
  %34 = sub i32 %count97, 1
  %35 = sext i32 %34 to i64
  %arr.len98 = load i64, ptr %ends96, align 8
  %arr.oob99 = icmp uge i64 %35, %arr.len98
  br i1 %arr.oob99, label %idx.bad100, label %idx.ok101, !prof !2

idx.bad100:                                       ; preds = %idx.ok92
  call void @__polaron_fail(ptr @.fail.2184, ptr @.faila.2185, i64 %35, ptr @.failb.2186, i64 %arr.len98, i32 70)
  unreachable

idx.ok101:                                        ; preds = %idx.ok92
  %arr.data102 = getelementptr i8, ptr %ends96, i64 8
  %arr.elem103 = getelementptr inbounds i32, ptr %arr.data102, i64 %35
  %elem104 = load i32, ptr %arr.elem103, align 4
  %36 = icmp sle i32 %elem95, %elem104
  %37 = zext i1 %36 to i32
  br i1 %36, label %if.then105, label %if.else

if.then105:                                       ; preds = %idx.ok101
  %ends107 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %i108 = load i32, ptr %i80, align 4
  %38 = sext i32 %i108 to i64
  %arr.len109 = load i64, ptr %ends107, align 8
  %arr.oob110 = icmp uge i64 %38, %arr.len109
  br i1 %arr.oob110, label %idx.bad111, label %idx.ok112, !prof !2

if.else:                                          ; preds = %idx.ok101
  %starts144 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %count145 = load i32, ptr %count, align 4
  %39 = sext i32 %count145 to i64
  %arr.len146 = load i64, ptr %starts144, align 8
  %arr.oob147 = icmp uge i64 %39, %arr.len146
  br i1 %arr.oob147, label %idx.bad148, label %idx.ok149, !prof !2

if.end106:                                        ; preds = %idx.ok174, %if.end126
  br label %for.update83

idx.bad111:                                       ; preds = %if.then105
  call void @__polaron_fail(ptr @.fail.2187, ptr @.faila.2188, i64 %38, ptr @.failb.2189, i64 %arr.len109, i32 70)
  unreachable

idx.ok112:                                        ; preds = %if.then105
  %arr.data113 = getelementptr i8, ptr %ends107, i64 8
  %arr.elem114 = getelementptr inbounds i32, ptr %arr.data113, i64 %38
  %elem115 = load i32, ptr %arr.elem114, align 4
  %ends116 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %count117 = load i32, ptr %count, align 4
  %40 = sub i32 %count117, 1
  %41 = sext i32 %40 to i64
  %arr.len118 = load i64, ptr %ends116, align 8
  %arr.oob119 = icmp uge i64 %41, %arr.len118
  br i1 %arr.oob119, label %idx.bad120, label %idx.ok121, !prof !2

idx.bad120:                                       ; preds = %idx.ok112
  call void @__polaron_fail(ptr @.fail.2190, ptr @.faila.2191, i64 %41, ptr @.failb.2192, i64 %arr.len118, i32 70)
  unreachable

idx.ok121:                                        ; preds = %idx.ok112
  %arr.data122 = getelementptr i8, ptr %ends116, i64 8
  %arr.elem123 = getelementptr inbounds i32, ptr %arr.data122, i64 %41
  %elem124 = load i32, ptr %arr.elem123, align 4
  %42 = icmp sgt i32 %elem115, %elem124
  %43 = zext i1 %42 to i32
  br i1 %42, label %if.then125, label %if.end126

if.then125:                                       ; preds = %idx.ok121
  %ends127 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %count128 = load i32, ptr %count, align 4
  %44 = sub i32 %count128, 1
  %45 = sext i32 %44 to i64
  %arr.len129 = load i64, ptr %ends127, align 8
  %arr.oob130 = icmp uge i64 %45, %arr.len129
  br i1 %arr.oob130, label %idx.bad131, label %idx.ok132, !prof !2

if.end126:                                        ; preds = %idx.ok140, %idx.ok121
  br label %if.end106

idx.bad131:                                       ; preds = %if.then125
  call void @__polaron_fail(ptr @.fail.2193, ptr @.faila.2194, i64 %45, ptr @.failb.2195, i64 %arr.len129, i32 70)
  unreachable

idx.ok132:                                        ; preds = %if.then125
  %arr.data133 = getelementptr i8, ptr %ends127, i64 8
  %arr.elem134 = getelementptr inbounds i32, ptr %arr.data133, i64 %45
  %ends135 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %i136 = load i32, ptr %i80, align 4
  %46 = sext i32 %i136 to i64
  %arr.len137 = load i64, ptr %ends135, align 8
  %arr.oob138 = icmp uge i64 %46, %arr.len137
  br i1 %arr.oob138, label %idx.bad139, label %idx.ok140, !prof !2

idx.bad139:                                       ; preds = %idx.ok132
  call void @__polaron_fail(ptr @.fail.2196, ptr @.faila.2197, i64 %46, ptr @.failb.2198, i64 %arr.len137, i32 70)
  unreachable

idx.ok140:                                        ; preds = %idx.ok132
  %arr.data141 = getelementptr i8, ptr %ends135, i64 8
  %arr.elem142 = getelementptr inbounds i32, ptr %arr.data141, i64 %46
  %elem143 = load i32, ptr %arr.elem142, align 4
  store i32 %elem143, ptr %arr.elem134, align 4
  br label %if.end126

idx.bad148:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.2199, ptr @.faila.2200, i64 %39, ptr @.failb.2201, i64 %arr.len146, i32 70)
  unreachable

idx.ok149:                                        ; preds = %if.else
  %arr.data150 = getelementptr i8, ptr %starts144, i64 8
  %arr.elem151 = getelementptr inbounds i32, ptr %arr.data150, i64 %39
  %starts152 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %i153 = load i32, ptr %i80, align 4
  %47 = sext i32 %i153 to i64
  %arr.len154 = load i64, ptr %starts152, align 8
  %arr.oob155 = icmp uge i64 %47, %arr.len154
  br i1 %arr.oob155, label %idx.bad156, label %idx.ok157, !prof !2

idx.bad156:                                       ; preds = %idx.ok149
  call void @__polaron_fail(ptr @.fail.2202, ptr @.faila.2203, i64 %47, ptr @.failb.2204, i64 %arr.len154, i32 70)
  unreachable

idx.ok157:                                        ; preds = %idx.ok149
  %arr.data158 = getelementptr i8, ptr %starts152, i64 8
  %arr.elem159 = getelementptr inbounds i32, ptr %arr.data158, i64 %47
  %elem160 = load i32, ptr %arr.elem159, align 4
  store i32 %elem160, ptr %arr.elem151, align 4
  %ends161 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %count162 = load i32, ptr %count, align 4
  %48 = sext i32 %count162 to i64
  %arr.len163 = load i64, ptr %ends161, align 8
  %arr.oob164 = icmp uge i64 %48, %arr.len163
  br i1 %arr.oob164, label %idx.bad165, label %idx.ok166, !prof !2

idx.bad165:                                       ; preds = %idx.ok157
  call void @__polaron_fail(ptr @.fail.2205, ptr @.faila.2206, i64 %48, ptr @.failb.2207, i64 %arr.len163, i32 70)
  unreachable

idx.ok166:                                        ; preds = %idx.ok157
  %arr.data167 = getelementptr i8, ptr %ends161, i64 8
  %arr.elem168 = getelementptr inbounds i32, ptr %arr.data167, i64 %48
  %ends169 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %i170 = load i32, ptr %i80, align 4
  %49 = sext i32 %i170 to i64
  %arr.len171 = load i64, ptr %ends169, align 8
  %arr.oob172 = icmp uge i64 %49, %arr.len171
  br i1 %arr.oob172, label %idx.bad173, label %idx.ok174, !prof !2

idx.bad173:                                       ; preds = %idx.ok166
  call void @__polaron_fail(ptr @.fail.2208, ptr @.faila.2209, i64 %49, ptr @.failb.2210, i64 %arr.len171, i32 70)
  unreachable

idx.ok174:                                        ; preds = %idx.ok166
  %arr.data175 = getelementptr i8, ptr %ends169, i64 8
  %arr.elem176 = getelementptr inbounds i32, ptr %arr.data175, i64 %49
  %elem177 = load i32, ptr %arr.elem176, align 4
  store i32 %elem177, ptr %arr.elem168, align 4
  %count178 = load i32, ptr %count, align 4
  %50 = add i32 %count178, 1
  store i32 %50, ptr %count, align 4
  br label %if.end106
}

define internal i32 @IntervalMerge.coveredLength(ptr %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %total = alloca i32, align 4
  %mergedCount = alloca i32, align 4
  %ends = alloca ptr, align 8
  %starts = alloca ptr, align 8
  store ptr %0, ptr %starts, align 8
  store ptr %1, ptr %ends, align 8
  store i32 %2, ptr %mergedCount, align 4
  store i32 0, ptr %total, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %mergedCount2 = load i32, ptr %mergedCount, align 4
  %3 = icmp slt i32 %i1, %mergedCount2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %total3 = load i32, ptr %total, align 4
  %ends4 = load ptr, ptr %ends, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %5 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %ends4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok11
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %total15 = load i32, ptr %total, align 4
  ret i32 %total15

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2211, ptr @.faila.2212, i64 %5, ptr @.failb.2213, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %ends4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  %starts6 = load ptr, ptr %starts, align 8, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %8 = sext i32 %i7 to i64
  %arr.len8 = load i64, ptr %starts6, align 8
  %arr.oob9 = icmp uge i64 %8, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !2

idx.bad10:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2214, ptr @.faila.2215, i64 %8, ptr @.failb.2216, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %idx.ok
  %arr.data12 = getelementptr i8, ptr %starts6, i64 8
  %arr.elem13 = getelementptr inbounds i32, ptr %arr.data12, i64 %8
  %elem14 = load i32, ptr %arr.elem13, align 4
  %9 = sub i32 %elem, %elem14
  %10 = add i32 %total3, %9
  store i32 %10, ptr %total, align 4
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5364)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5366)
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
