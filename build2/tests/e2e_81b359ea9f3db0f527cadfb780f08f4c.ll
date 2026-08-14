; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_search.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/string_search.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@.str = private unnamed_addr constant [23 x i8] c"idx=%d cnt=%d miss=%d\0A\00", align 1
@.strdata = private constant [13 x i8] c"abxabcabcaby\00"
@.strobj = private global %String { i64 12, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"abcaby\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [5 x i8] c"aaaa\00"
@.strobj.4 = private global %String { i64 4, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [3 x i8] c"aa\00"
@.strobj.6 = private global %String { i64 2, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [6 x i8] c"hello\00"
@.strobj.8 = private global %String { i64 5, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [6 x i8] c"world\00"
@.strobj.10 = private global %String { i64 5, ptr @.strdata.9, i64 0 }
@.str.11 = private unnamed_addr constant [25 x i8] c"pal1=%d pal2=%d pal3=%d\0A\00", align 1
@.strdata.12 = private constant [6 x i8] c"babad\00"
@.strobj.13 = private global %String { i64 5, ptr @.strdata.12, i64 0 }
@.strdata.14 = private constant [5 x i8] c"cbbd\00"
@.strobj.15 = private global %String { i64 4, ptr @.strdata.14, i64 0 }
@.strdata.16 = private constant [17 x i8] c"forgeeksskeegfor\00"
@.strobj.17 = private global %String { i64 16, ptr @.strdata.16, i64 0 }
@.fail.2234 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3314:47  in Kmp.buildLps\0A\00", align 1
@.faila.2235 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2236 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2237 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3316:45  in Kmp.buildLps\0A\00", align 1
@.faila.2238 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2239 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2240 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3317:39  in Kmp.buildLps\0A\00", align 1
@.faila.2241 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2242 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2243 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3334:41  in Kmp.indexOf\0A\00", align 1
@.faila.2244 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2245 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2246 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3351:60  in Kmp.count\0A\00", align 1
@.faila.2247 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2248 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2249 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3353:41  in Kmp.count\0A\00", align 1
@.faila.2250 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2251 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2252 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3368:22  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2253 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2254 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2255 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3369:26  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2256 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2257 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2258 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3371:32  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2259 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2260 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2261 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3372:32  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2262 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2263 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2264 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3374:26  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2265 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2266 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2267 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3383:25  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2268 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2269 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2270 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3383:54  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2271 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2272 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2273 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3383:54  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2274 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2275 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2276 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3383:81  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2277 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2278 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2279 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3385:21  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2280 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2281 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2282 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3385:21  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2283 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2284 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2285 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3385:21  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2286 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2287 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2288 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3385:21  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2289 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2290 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2291 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3385:71  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2292 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2293 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2294 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3385:71  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2295 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2296 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2297 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3386:21  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2298 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2299 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2300 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3386:63  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2301 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2302 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2303 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3387:21  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2304 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2305 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2306 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:3387:45  in Manacher.longestPalindrome\0A\00", align 1
@.faila.2307 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2308 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }
@.strdata.5326 = private constant [1 x i8] zeroinitializer
@.strobj.5327 = private global %String { i64 0, ptr @.strdata.5326, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %16 = call i32 @Kmp.indexOf(ptr @.strobj, ptr @.strobj.2)
  %17 = call i32 @Kmp.count(ptr @.strobj.4, ptr @.strobj.6)
  %18 = call i32 @Kmp.indexOf(ptr @.strobj.8, ptr @.strobj.10)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18)
  %20 = call i32 @Manacher.longestPalindrome(ptr @.strobj.13)
  %21 = call i32 @Manacher.longestPalindrome(ptr @.strobj.15)
  %22 = call i32 @Manacher.longestPalindrome(ptr @.strobj.17)
  %23 = call i32 (ptr, ...) @printf(ptr @.str.11, i32 %20, i32 %21, i32 %22)
  ret i32 0
}

define internal ptr @Kmp.buildLps(ptr %0) {
entry:
  %i = alloca i32, align 4
  %len3 = alloca i32, align 4
  %lps = alloca ptr, align 8
  %m = alloca i32, align 4
  %p = alloca ptr, align 8
  store ptr %0, ptr %p, align 8
  %p1 = load ptr, ptr %p, align 8
  %str.len = getelementptr inbounds %String, ptr %p1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %m, align 4
  %m2 = load i32, ptr %m, align 4
  %2 = add i32 %m2, 1
  %3 = sext i32 %2 to i64
  %4 = mul i64 %3, 4
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %lps, align 8
  store i32 0, ptr %len3, align 4
  store i32 1, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %i4 = load i32, ptr %i, align 4
  %m5 = load i32, ptr %m, align 4
  %7 = icmp slt i32 %i4, %m5
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %p6 = load ptr, ptr %p, align 8
  %i7 = load i32, ptr %i, align 4
  %9 = sext i32 %i7 to i64
  %str.data = getelementptr inbounds %String, ptr %p6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %9
  %ch = load i8, ptr %ch.addr, align 1
  %10 = zext i8 %ch to i32
  %p8 = load ptr, ptr %p, align 8
  %len9 = load i32, ptr %len3, align 4
  %11 = sext i32 %len9 to i64
  %str.data10 = getelementptr inbounds %String, ptr %p8, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %ch.addr12 = getelementptr i8, ptr %data11, i64 %11
  %ch13 = load i8, ptr %ch.addr12, align 1
  %12 = zext i8 %ch13 to i32
  %13 = icmp eq i32 %10, %12
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.else

while.end:                                        ; preds = %while.cond
  %lps41 = load ptr, ptr %lps, align 8
  ret ptr %lps41

if.then:                                          ; preds = %while.body
  %len14 = load i32, ptr %len3, align 4
  %15 = add i32 %len14, 1
  store i32 %15, ptr %len3, align 4
  %lps15 = load ptr, ptr %lps, align 8, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %16 = sext i32 %i16 to i64
  %arr.len = load i64, ptr %lps15, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.else:                                          ; preds = %while.body
  %len20 = load i32, ptr %len3, align 4
  %17 = icmp ne i32 %len20, 0
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then21, label %if.else22

if.end:                                           ; preds = %if.end23, %idx.ok
  br label %while.cond

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2234, ptr @.faila.2235, i64 %16, ptr @.failb.2236, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data17 = getelementptr i8, ptr %lps15, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data17, i64 %16
  %len18 = load i32, ptr %len3, align 4
  store i32 %len18, ptr %arr.elem, align 4
  %i19 = load i32, ptr %i, align 4
  %19 = add i32 %i19, 1
  store i32 %19, ptr %i, align 4
  br label %if.end

if.then21:                                        ; preds = %if.else
  %lps24 = load ptr, ptr %lps, align 8, !nonnull !0, !dereferenceable !1
  %len25 = load i32, ptr %len3, align 4
  %20 = sub i32 %len25, 1
  %21 = sext i32 %20 to i64
  %arr.len26 = load i64, ptr %lps24, align 8
  %arr.oob27 = icmp uge i64 %21, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

if.else22:                                        ; preds = %if.else
  %lps32 = load ptr, ptr %lps, align 8, !nonnull !0, !dereferenceable !1
  %i33 = load i32, ptr %i, align 4
  %22 = sext i32 %i33 to i64
  %arr.len34 = load i64, ptr %lps32, align 8
  %arr.oob35 = icmp uge i64 %22, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !2

if.end23:                                         ; preds = %idx.ok37, %idx.ok29
  br label %if.end

idx.bad28:                                        ; preds = %if.then21
  call void @__polaron_fail(ptr @.fail.2237, ptr @.faila.2238, i64 %21, ptr @.failb.2239, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %if.then21
  %arr.data30 = getelementptr i8, ptr %lps24, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %21
  %elem = load i32, ptr %arr.elem31, align 4
  store i32 %elem, ptr %len3, align 4
  br label %if.end23

idx.bad36:                                        ; preds = %if.else22
  call void @__polaron_fail(ptr @.fail.2240, ptr @.faila.2241, i64 %22, ptr @.failb.2242, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %if.else22
  %arr.data38 = getelementptr i8, ptr %lps32, i64 8
  %arr.elem39 = getelementptr inbounds i32, ptr %arr.data38, i64 %22
  store i32 0, ptr %arr.elem39, align 4
  %i40 = load i32, ptr %i, align 4
  %23 = add i32 %i40, 1
  store i32 %23, ptr %i, align 4
  br label %if.end23
}

define internal i32 @Kmp.indexOf(ptr %0, ptr %1) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %lps = alloca ptr, align 8
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  %pattern = alloca ptr, align 8
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  store ptr %1, ptr %pattern, align 8
  %text1 = load ptr, ptr %text, align 8
  %str.len = getelementptr inbounds %String, ptr %text1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %pattern2 = load ptr, ptr %pattern, align 8
  %str.len3 = getelementptr inbounds %String, ptr %pattern2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %m, align 4
  %m5 = load i32, ptr %m, align 4
  %4 = icmp eq i32 %m5, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %pattern6 = load ptr, ptr %pattern, align 8
  %6 = call ptr @Kmp.buildLps(ptr %pattern6)
  store ptr %6, ptr %lps, align 8
  store i32 0, ptr %i, align 4
  store i32 0, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end18, %if.end
  %i7 = load i32, ptr %i, align 4
  %n8 = load i32, ptr %n, align 4
  %7 = icmp slt i32 %i7, %n8
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %text9 = load ptr, ptr %text, align 8
  %i10 = load i32, ptr %i, align 4
  %9 = sext i32 %i10 to i64
  %str.data = getelementptr inbounds %String, ptr %text9, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %9
  %ch = load i8, ptr %ch.addr, align 1
  %10 = zext i8 %ch to i32
  %pattern11 = load ptr, ptr %pattern, align 8
  %j12 = load i32, ptr %j, align 4
  %11 = sext i32 %j12 to i64
  %str.data13 = getelementptr inbounds %String, ptr %pattern11, i32 0, i32 1
  %data14 = load ptr, ptr %str.data13, align 8
  %ch.addr15 = getelementptr i8, ptr %data14, i64 %11
  %ch16 = load i8, ptr %ch.addr15, align 1
  %12 = zext i8 %ch16 to i32
  %13 = icmp eq i32 %10, %12
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then17, label %if.else

while.end:                                        ; preds = %while.cond
  ret i32 -1

if.then17:                                        ; preds = %while.body
  %i19 = load i32, ptr %i, align 4
  %15 = add i32 %i19, 1
  store i32 %15, ptr %i, align 4
  %j20 = load i32, ptr %j, align 4
  %16 = add i32 %j20, 1
  store i32 %16, ptr %j, align 4
  %j21 = load i32, ptr %j, align 4
  %m22 = load i32, ptr %m, align 4
  %17 = icmp eq i32 %j21, %m22
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then23, label %if.end24

if.else:                                          ; preds = %while.body
  %j27 = load i32, ptr %j, align 4
  %19 = icmp ne i32 %j27, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then28, label %if.else29

if.end18:                                         ; preds = %if.end30, %if.end24
  br label %while.cond

if.then23:                                        ; preds = %if.then17
  %i25 = load i32, ptr %i, align 4
  %m26 = load i32, ptr %m, align 4
  %21 = sub i32 %i25, %m26
  ret i32 %21

if.end24:                                         ; preds = %if.then17
  br label %if.end18

if.then28:                                        ; preds = %if.else
  %lps31 = load ptr, ptr %lps, align 8, !nonnull !0, !dereferenceable !1
  %j32 = load i32, ptr %j, align 4
  %22 = sub i32 %j32, 1
  %23 = sext i32 %22 to i64
  %arr.len = load i64, ptr %lps31, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.else29:                                        ; preds = %if.else
  %i33 = load i32, ptr %i, align 4
  %24 = add i32 %i33, 1
  store i32 %24, ptr %i, align 4
  br label %if.end30

if.end30:                                         ; preds = %if.else29, %idx.ok
  br label %if.end18

idx.bad:                                          ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.2243, ptr @.faila.2244, i64 %23, ptr @.failb.2245, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then28
  %arr.data = getelementptr i8, ptr %lps31, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %23
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %j, align 4
  br label %if.end30
}

define internal i32 @Kmp.count(ptr %0, ptr %1) {
entry:
  %total = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %lps = alloca ptr, align 8
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  %pattern = alloca ptr, align 8
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  store ptr %1, ptr %pattern, align 8
  %text1 = load ptr, ptr %text, align 8
  %str.len = getelementptr inbounds %String, ptr %text1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %pattern2 = load ptr, ptr %pattern, align 8
  %str.len3 = getelementptr inbounds %String, ptr %pattern2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %m, align 4
  %m5 = load i32, ptr %m, align 4
  %4 = icmp eq i32 %m5, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %pattern6 = load ptr, ptr %pattern, align 8
  %6 = call ptr @Kmp.buildLps(ptr %pattern6)
  store ptr %6, ptr %lps, align 8
  store i32 0, ptr %i, align 4
  store i32 0, ptr %j, align 4
  store i32 0, ptr %total, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end18, %if.end
  %i7 = load i32, ptr %i, align 4
  %n8 = load i32, ptr %n, align 4
  %7 = icmp slt i32 %i7, %n8
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %text9 = load ptr, ptr %text, align 8
  %i10 = load i32, ptr %i, align 4
  %9 = sext i32 %i10 to i64
  %str.data = getelementptr inbounds %String, ptr %text9, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %9
  %ch = load i8, ptr %ch.addr, align 1
  %10 = zext i8 %ch to i32
  %pattern11 = load ptr, ptr %pattern, align 8
  %j12 = load i32, ptr %j, align 4
  %11 = sext i32 %j12 to i64
  %str.data13 = getelementptr inbounds %String, ptr %pattern11, i32 0, i32 1
  %data14 = load ptr, ptr %str.data13, align 8
  %ch.addr15 = getelementptr i8, ptr %data14, i64 %11
  %ch16 = load i8, ptr %ch.addr15, align 1
  %12 = zext i8 %ch16 to i32
  %13 = icmp eq i32 %10, %12
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then17, label %if.else

while.end:                                        ; preds = %while.cond
  %total42 = load i32, ptr %total, align 4
  ret i32 %total42

if.then17:                                        ; preds = %while.body
  %i19 = load i32, ptr %i, align 4
  %15 = add i32 %i19, 1
  store i32 %15, ptr %i, align 4
  %j20 = load i32, ptr %j, align 4
  %16 = add i32 %j20, 1
  store i32 %16, ptr %j, align 4
  %j21 = load i32, ptr %j, align 4
  %m22 = load i32, ptr %m, align 4
  %17 = icmp eq i32 %j21, %m22
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then23, label %if.end24

if.else:                                          ; preds = %while.body
  %j28 = load i32, ptr %j, align 4
  %19 = icmp ne i32 %j28, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then29, label %if.else30

if.end18:                                         ; preds = %if.end31, %if.end24
  br label %while.cond

if.then23:                                        ; preds = %if.then17
  %total25 = load i32, ptr %total, align 4
  %21 = add i32 %total25, 1
  store i32 %21, ptr %total, align 4
  %lps26 = load ptr, ptr %lps, align 8, !nonnull !0, !dereferenceable !1
  %j27 = load i32, ptr %j, align 4
  %22 = sub i32 %j27, 1
  %23 = sext i32 %22 to i64
  %arr.len = load i64, ptr %lps26, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end24:                                         ; preds = %idx.ok, %if.then17
  br label %if.end18

idx.bad:                                          ; preds = %if.then23
  call void @__polaron_fail(ptr @.fail.2246, ptr @.faila.2247, i64 %23, ptr @.failb.2248, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then23
  %arr.data = getelementptr i8, ptr %lps26, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %23
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %j, align 4
  br label %if.end24

if.then29:                                        ; preds = %if.else
  %lps32 = load ptr, ptr %lps, align 8, !nonnull !0, !dereferenceable !1
  %j33 = load i32, ptr %j, align 4
  %24 = sub i32 %j33, 1
  %25 = sext i32 %24 to i64
  %arr.len34 = load i64, ptr %lps32, align 8
  %arr.oob35 = icmp uge i64 %25, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !2

if.else30:                                        ; preds = %if.else
  %i41 = load i32, ptr %i, align 4
  %26 = add i32 %i41, 1
  store i32 %26, ptr %i, align 4
  br label %if.end31

if.end31:                                         ; preds = %if.else30, %idx.ok37
  br label %if.end18

idx.bad36:                                        ; preds = %if.then29
  call void @__polaron_fail(ptr @.fail.2249, ptr @.faila.2250, i64 %25, ptr @.failb.2251, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %if.then29
  %arr.data38 = getelementptr i8, ptr %lps32, i64 8
  %arr.elem39 = getelementptr inbounds i32, ptr %arr.data38, i64 %25
  %elem40 = load i32, ptr %arr.elem39, align 4
  store i32 %elem40, ptr %j, align 4
  br label %if.end31
}

define internal i32 @Manacher.longestPalindrome(ptr %0) {
entry:
  %span = alloca i32, align 4
  %mirror = alloca i32, align 4
  %i46 = alloca i32, align 4
  %best = alloca i32, align 4
  %right = alloca i32, align 4
  %center = alloca i32, align 4
  %p = alloca ptr, align 8
  %i = alloca i32, align 4
  %c = alloca ptr, align 8
  %t = alloca i32, align 4
  %n = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %0, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  %2 = icmp eq i32 %n2, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %n3 = load i32, ptr %n, align 4
  %4 = mul i32 2, %n3
  %5 = add i32 %4, 3
  store i32 %5, ptr %t, align 4
  %t4 = load i32, ptr %t, align 4
  %6 = sext i32 %t4 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %9 = call ptr @memset(ptr %arr.data, i32 0, i64 %7)
  store ptr %arr, ptr %c, align 8
  %c5 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %c5, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.2252, ptr @.faila.2253, i64 0, ptr @.failb.2254, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data6 = getelementptr i8, ptr %c5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data6, i64 0
  store i32 1, ptr %arr.elem, align 4
  %c7 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %t8 = load i32, ptr %t, align 4
  %10 = sub i32 %t8, 1
  %11 = sext i32 %10 to i64
  %arr.len9 = load i64, ptr %c7, align 8
  %arr.oob10 = icmp uge i64 %11, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

idx.bad11:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2255, ptr @.faila.2256, i64 %11, ptr @.failb.2257, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %idx.ok
  %arr.data13 = getelementptr i8, ptr %c7, i64 8
  %arr.elem14 = getelementptr inbounds i32, ptr %arr.data13, i64 %11
  store i32 2, ptr %arr.elem14, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok12
  %i15 = load i32, ptr %i, align 4
  %n16 = load i32, ptr %n, align 4
  %12 = icmp slt i32 %i15, %n16
  %13 = zext i1 %12 to i32
  br i1 %12, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %c17 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %i18 = load i32, ptr %i, align 4
  %14 = mul i32 2, %i18
  %15 = add i32 2, %14
  %16 = sext i32 %15 to i64
  %arr.len19 = load i64, ptr %c17, align 8
  %arr.oob20 = icmp uge i64 %16, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

for.update:                                       ; preds = %idx.ok32
  %17 = load i32, ptr %i, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %c35 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %t36 = load i32, ptr %t, align 4
  %19 = sub i32 %t36, 2
  %20 = sext i32 %19 to i64
  %arr.len37 = load i64, ptr %c35, align 8
  %arr.oob38 = icmp uge i64 %20, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad21:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2258, ptr @.faila.2259, i64 %16, ptr @.failb.2260, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %for.body
  %arr.data23 = getelementptr i8, ptr %c17, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %16
  %s25 = load ptr, ptr %s, align 8
  %i26 = load i32, ptr %i, align 4
  %21 = sext i32 %i26 to i64
  %str.data = getelementptr inbounds %String, ptr %s25, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %21
  %ch = load i8, ptr %ch.addr, align 1
  %22 = zext i8 %ch to i32
  %23 = and i32 %22, 255
  store i32 %23, ptr %arr.elem24, align 4
  %c27 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %i28 = load i32, ptr %i, align 4
  %24 = mul i32 2, %i28
  %25 = add i32 1, %24
  %26 = sext i32 %25 to i64
  %arr.len29 = load i64, ptr %c27, align 8
  %arr.oob30 = icmp uge i64 %26, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !2

idx.bad31:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.2261, ptr @.faila.2262, i64 %26, ptr @.failb.2263, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok22
  %arr.data33 = getelementptr i8, ptr %c27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %26
  store i32 3, ptr %arr.elem34, align 4
  br label %for.update

idx.bad39:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.2264, ptr @.faila.2265, i64 %20, ptr @.failb.2266, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %for.end
  %arr.data41 = getelementptr i8, ptr %c35, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %20
  store i32 3, ptr %arr.elem42, align 4
  %t43 = load i32, ptr %t, align 4
  %27 = sext i32 %t43 to i64
  %28 = mul i64 %27, 4
  %29 = add i64 8, %28
  %arr44 = call ptr @__polaron_malloc(i64 %29)
  store i64 %27, ptr %arr44, align 8
  %arr.data45 = getelementptr i8, ptr %arr44, i64 8
  %30 = call ptr @memset(ptr %arr.data45, i32 0, i64 %28)
  store ptr %arr44, ptr %p, align 8
  store i32 0, ptr %center, align 4
  store i32 0, ptr %right, align 4
  store i32 0, ptr %best, align 4
  store i32 1, ptr %i46, align 4
  br label %for.cond47

for.cond47:                                       ; preds = %for.update49, %idx.ok40
  %i51 = load i32, ptr %i46, align 4
  %t52 = load i32, ptr %t, align 4
  %31 = sub i32 %t52, 1
  %32 = icmp slt i32 %i51, %31
  %33 = zext i1 %32 to i32
  br i1 %32, label %for.body48, label %for.end50

for.body48:                                       ; preds = %for.cond47
  %i53 = load i32, ptr %i46, align 4
  %right54 = load i32, ptr %right, align 4
  %34 = icmp slt i32 %i53, %right54
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then55, label %if.end56

for.update49:                                     ; preds = %if.end186
  %36 = load i32, ptr %i46, align 4
  %37 = add i32 %36, 1
  store i32 %37, ptr %i46, align 4
  br label %for.cond47

for.end50:                                        ; preds = %for.cond47
  %best196 = load i32, ptr %best, align 4
  ret i32 %best196

if.then55:                                        ; preds = %for.body48
  %center57 = load i32, ptr %center, align 4
  %38 = mul i32 2, %center57
  %i58 = load i32, ptr %i46, align 4
  %39 = sub i32 %38, %i58
  store i32 %39, ptr %mirror, align 4
  %right59 = load i32, ptr %right, align 4
  %i60 = load i32, ptr %i46, align 4
  %40 = sub i32 %right59, %i60
  store i32 %40, ptr %span, align 4
  %p61 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %mirror62 = load i32, ptr %mirror, align 4
  %41 = sext i32 %mirror62 to i64
  %arr.len63 = load i64, ptr %p61, align 8
  %arr.oob64 = icmp uge i64 %41, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !2

if.end56:                                         ; preds = %if.end71, %for.body48
  br label %while.cond

idx.bad65:                                        ; preds = %if.then55
  call void @__polaron_fail(ptr @.fail.2267, ptr @.faila.2268, i64 %41, ptr @.failb.2269, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %if.then55
  %arr.data67 = getelementptr i8, ptr %p61, i64 8
  %arr.elem68 = getelementptr inbounds i32, ptr %arr.data67, i64 %41
  %elem = load i32, ptr %arr.elem68, align 4
  %span69 = load i32, ptr %span, align 4
  %42 = icmp slt i32 %elem, %span69
  %43 = zext i1 %42 to i32
  br i1 %42, label %if.then70, label %if.else

if.then70:                                        ; preds = %idx.ok66
  %p72 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i73 = load i32, ptr %i46, align 4
  %44 = sext i32 %i73 to i64
  %arr.len74 = load i64, ptr %p72, align 8
  %arr.oob75 = icmp uge i64 %44, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !2

if.else:                                          ; preds = %idx.ok66
  %p89 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i90 = load i32, ptr %i46, align 4
  %45 = sext i32 %i90 to i64
  %arr.len91 = load i64, ptr %p89, align 8
  %arr.oob92 = icmp uge i64 %45, %arr.len91
  br i1 %arr.oob92, label %idx.bad93, label %idx.ok94, !prof !2

if.end71:                                         ; preds = %idx.ok94, %idx.ok85
  br label %if.end56

idx.bad76:                                        ; preds = %if.then70
  call void @__polaron_fail(ptr @.fail.2270, ptr @.faila.2271, i64 %44, ptr @.failb.2272, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %if.then70
  %arr.data78 = getelementptr i8, ptr %p72, i64 8
  %arr.elem79 = getelementptr inbounds i32, ptr %arr.data78, i64 %44
  %p80 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %mirror81 = load i32, ptr %mirror, align 4
  %46 = sext i32 %mirror81 to i64
  %arr.len82 = load i64, ptr %p80, align 8
  %arr.oob83 = icmp uge i64 %46, %arr.len82
  br i1 %arr.oob83, label %idx.bad84, label %idx.ok85, !prof !2

idx.bad84:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.2273, ptr @.faila.2274, i64 %46, ptr @.failb.2275, i64 %arr.len82, i32 70)
  unreachable

idx.ok85:                                         ; preds = %idx.ok77
  %arr.data86 = getelementptr i8, ptr %p80, i64 8
  %arr.elem87 = getelementptr inbounds i32, ptr %arr.data86, i64 %46
  %elem88 = load i32, ptr %arr.elem87, align 4
  store i32 %elem88, ptr %arr.elem79, align 4
  br label %if.end71

idx.bad93:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.2276, ptr @.faila.2277, i64 %45, ptr @.failb.2278, i64 %arr.len91, i32 70)
  unreachable

idx.ok94:                                         ; preds = %if.else
  %arr.data95 = getelementptr i8, ptr %p89, i64 8
  %arr.elem96 = getelementptr inbounds i32, ptr %arr.data95, i64 %45
  %span97 = load i32, ptr %span, align 4
  store i32 %span97, ptr %arr.elem96, align 4
  br label %if.end71

while.cond:                                       ; preds = %idx.ok147, %if.end56
  %c98 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %i99 = load i32, ptr %i46, align 4
  %p100 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i101 = load i32, ptr %i46, align 4
  %47 = sext i32 %i101 to i64
  %arr.len102 = load i64, ptr %p100, align 8
  %arr.oob103 = icmp uge i64 %47, %arr.len102
  br i1 %arr.oob103, label %idx.bad104, label %idx.ok105, !prof !2

while.body:                                       ; preds = %idx.ok130
  %p134 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i135 = load i32, ptr %i46, align 4
  %48 = sext i32 %i135 to i64
  %arr.len136 = load i64, ptr %p134, align 8
  %arr.oob137 = icmp uge i64 %48, %arr.len136
  br i1 %arr.oob137, label %idx.bad138, label %idx.ok139, !prof !2

while.end:                                        ; preds = %idx.ok130
  %i151 = load i32, ptr %i46, align 4
  %p152 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i153 = load i32, ptr %i46, align 4
  %49 = sext i32 %i153 to i64
  %arr.len154 = load i64, ptr %p152, align 8
  %arr.oob155 = icmp uge i64 %49, %arr.len154
  br i1 %arr.oob155, label %idx.bad156, label %idx.ok157, !prof !2

idx.bad104:                                       ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.2279, ptr @.faila.2280, i64 %47, ptr @.failb.2281, i64 %arr.len102, i32 70)
  unreachable

idx.ok105:                                        ; preds = %while.cond
  %arr.data106 = getelementptr i8, ptr %p100, i64 8
  %arr.elem107 = getelementptr inbounds i32, ptr %arr.data106, i64 %47
  %elem108 = load i32, ptr %arr.elem107, align 4
  %50 = add i32 %i99, %elem108
  %51 = add i32 %50, 1
  %52 = sext i32 %51 to i64
  %arr.len109 = load i64, ptr %c98, align 8
  %arr.oob110 = icmp uge i64 %52, %arr.len109
  br i1 %arr.oob110, label %idx.bad111, label %idx.ok112, !prof !2

idx.bad111:                                       ; preds = %idx.ok105
  call void @__polaron_fail(ptr @.fail.2282, ptr @.faila.2283, i64 %52, ptr @.failb.2284, i64 %arr.len109, i32 70)
  unreachable

idx.ok112:                                        ; preds = %idx.ok105
  %arr.data113 = getelementptr i8, ptr %c98, i64 8
  %arr.elem114 = getelementptr inbounds i32, ptr %arr.data113, i64 %52
  %elem115 = load i32, ptr %arr.elem114, align 4
  %c116 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %i117 = load i32, ptr %i46, align 4
  %p118 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i119 = load i32, ptr %i46, align 4
  %53 = sext i32 %i119 to i64
  %arr.len120 = load i64, ptr %p118, align 8
  %arr.oob121 = icmp uge i64 %53, %arr.len120
  br i1 %arr.oob121, label %idx.bad122, label %idx.ok123, !prof !2

idx.bad122:                                       ; preds = %idx.ok112
  call void @__polaron_fail(ptr @.fail.2285, ptr @.faila.2286, i64 %53, ptr @.failb.2287, i64 %arr.len120, i32 70)
  unreachable

idx.ok123:                                        ; preds = %idx.ok112
  %arr.data124 = getelementptr i8, ptr %p118, i64 8
  %arr.elem125 = getelementptr inbounds i32, ptr %arr.data124, i64 %53
  %elem126 = load i32, ptr %arr.elem125, align 4
  %54 = sub i32 %i117, %elem126
  %55 = sub i32 %54, 1
  %56 = sext i32 %55 to i64
  %arr.len127 = load i64, ptr %c116, align 8
  %arr.oob128 = icmp uge i64 %56, %arr.len127
  br i1 %arr.oob128, label %idx.bad129, label %idx.ok130, !prof !2

idx.bad129:                                       ; preds = %idx.ok123
  call void @__polaron_fail(ptr @.fail.2288, ptr @.faila.2289, i64 %56, ptr @.failb.2290, i64 %arr.len127, i32 70)
  unreachable

idx.ok130:                                        ; preds = %idx.ok123
  %arr.data131 = getelementptr i8, ptr %c116, i64 8
  %arr.elem132 = getelementptr inbounds i32, ptr %arr.data131, i64 %56
  %elem133 = load i32, ptr %arr.elem132, align 4
  %57 = icmp eq i32 %elem115, %elem133
  %58 = zext i1 %57 to i32
  br i1 %57, label %while.body, label %while.end

idx.bad138:                                       ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.2291, ptr @.faila.2292, i64 %48, ptr @.failb.2293, i64 %arr.len136, i32 70)
  unreachable

idx.ok139:                                        ; preds = %while.body
  %arr.data140 = getelementptr i8, ptr %p134, i64 8
  %arr.elem141 = getelementptr inbounds i32, ptr %arr.data140, i64 %48
  %p142 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i143 = load i32, ptr %i46, align 4
  %59 = sext i32 %i143 to i64
  %arr.len144 = load i64, ptr %p142, align 8
  %arr.oob145 = icmp uge i64 %59, %arr.len144
  br i1 %arr.oob145, label %idx.bad146, label %idx.ok147, !prof !2

idx.bad146:                                       ; preds = %idx.ok139
  call void @__polaron_fail(ptr @.fail.2294, ptr @.faila.2295, i64 %59, ptr @.failb.2296, i64 %arr.len144, i32 70)
  unreachable

idx.ok147:                                        ; preds = %idx.ok139
  %arr.data148 = getelementptr i8, ptr %p142, i64 8
  %arr.elem149 = getelementptr inbounds i32, ptr %arr.data148, i64 %59
  %elem150 = load i32, ptr %arr.elem149, align 4
  %60 = add i32 %elem150, 1
  store i32 %60, ptr %arr.elem141, align 4
  br label %while.cond

idx.bad156:                                       ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.2297, ptr @.faila.2298, i64 %49, ptr @.failb.2299, i64 %arr.len154, i32 70)
  unreachable

idx.ok157:                                        ; preds = %while.end
  %arr.data158 = getelementptr i8, ptr %p152, i64 8
  %arr.elem159 = getelementptr inbounds i32, ptr %arr.data158, i64 %49
  %elem160 = load i32, ptr %arr.elem159, align 4
  %61 = add i32 %i151, %elem160
  %right161 = load i32, ptr %right, align 4
  %62 = icmp sgt i32 %61, %right161
  %63 = zext i1 %62 to i32
  br i1 %62, label %if.then162, label %if.end163

if.then162:                                       ; preds = %idx.ok157
  %i164 = load i32, ptr %i46, align 4
  store i32 %i164, ptr %center, align 4
  %i165 = load i32, ptr %i46, align 4
  %p166 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i167 = load i32, ptr %i46, align 4
  %64 = sext i32 %i167 to i64
  %arr.len168 = load i64, ptr %p166, align 8
  %arr.oob169 = icmp uge i64 %64, %arr.len168
  br i1 %arr.oob169, label %idx.bad170, label %idx.ok171, !prof !2

if.end163:                                        ; preds = %idx.ok171, %idx.ok157
  %p175 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i176 = load i32, ptr %i46, align 4
  %65 = sext i32 %i176 to i64
  %arr.len177 = load i64, ptr %p175, align 8
  %arr.oob178 = icmp uge i64 %65, %arr.len177
  br i1 %arr.oob178, label %idx.bad179, label %idx.ok180, !prof !2

idx.bad170:                                       ; preds = %if.then162
  call void @__polaron_fail(ptr @.fail.2300, ptr @.faila.2301, i64 %64, ptr @.failb.2302, i64 %arr.len168, i32 70)
  unreachable

idx.ok171:                                        ; preds = %if.then162
  %arr.data172 = getelementptr i8, ptr %p166, i64 8
  %arr.elem173 = getelementptr inbounds i32, ptr %arr.data172, i64 %64
  %elem174 = load i32, ptr %arr.elem173, align 4
  %66 = add i32 %i165, %elem174
  store i32 %66, ptr %right, align 4
  br label %if.end163

idx.bad179:                                       ; preds = %if.end163
  call void @__polaron_fail(ptr @.fail.2303, ptr @.faila.2304, i64 %65, ptr @.failb.2305, i64 %arr.len177, i32 70)
  unreachable

idx.ok180:                                        ; preds = %if.end163
  %arr.data181 = getelementptr i8, ptr %p175, i64 8
  %arr.elem182 = getelementptr inbounds i32, ptr %arr.data181, i64 %65
  %elem183 = load i32, ptr %arr.elem182, align 4
  %best184 = load i32, ptr %best, align 4
  %67 = icmp sgt i32 %elem183, %best184
  %68 = zext i1 %67 to i32
  br i1 %67, label %if.then185, label %if.end186

if.then185:                                       ; preds = %idx.ok180
  %p187 = load ptr, ptr %p, align 8, !nonnull !0, !dereferenceable !1
  %i188 = load i32, ptr %i46, align 4
  %69 = sext i32 %i188 to i64
  %arr.len189 = load i64, ptr %p187, align 8
  %arr.oob190 = icmp uge i64 %69, %arr.len189
  br i1 %arr.oob190, label %idx.bad191, label %idx.ok192, !prof !2

if.end186:                                        ; preds = %idx.ok192, %idx.ok180
  br label %for.update49

idx.bad191:                                       ; preds = %if.then185
  call void @__polaron_fail(ptr @.fail.2306, ptr @.faila.2307, i64 %69, ptr @.failb.2308, i64 %arr.len189, i32 70)
  unreachable

idx.ok192:                                        ; preds = %if.then185
  %arr.data193 = getelementptr i8, ptr %p187, i64 8
  %arr.elem194 = getelementptr inbounds i32, ptr %arr.data193, i64 %69
  %elem195 = load i32, ptr %arr.elem194, align 4
  store i32 %elem195, ptr %best, align 4
  br label %if.end186
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5325)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5327)
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

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
