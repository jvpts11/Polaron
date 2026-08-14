; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_extras.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_extras.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_extras.pol:13:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_extras.pol:14:23  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_extras.pol:15:23  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_extras.pol:16:23  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [130 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/math_extras.pol:17:23  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [44 x i8] c"c52=%d c104=%d p53=%d var=%d std=%d med=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1319 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1320 = private global %String { i64 16, ptr @.strdata.1319, i64 0 }
@.strdata.1321 = private constant [17 x i8] c"division by zero\00"
@.strobj.1322 = private global %String { i64 16, ptr @.strdata.1321, i64 0 }
@.fail.3245 = private unnamed_addr constant [80 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5564:67  in Stats.sum\0A\00", align 1
@.faila.3246 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3247 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3266 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5587:21  in Stats.variance\0A\00", align 1
@.faila.3267 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3268 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3269 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5601:60  in Stats.median\0A\00", align 1
@.faila.3270 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3271 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3272 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5601:60  in Stats.median\0A\00", align 1
@.faila.3273 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3274 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3275 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5603:21  in Stats.median\0A\00", align 1
@.faila.3276 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3277 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3278 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5605:21  in Stats.median\0A\00", align 1
@.faila.3279 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3280 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3281 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5606:34  in Stats.median\0A\00", align 1
@.faila.3282 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3283 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3284 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5606:34  in Stats.median\0A\00", align 1
@.faila.3285 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3286 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3287 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5609:30  in Stats.median\0A\00", align 1
@.faila.3288 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3289 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3290 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5611:17  in Stats.median\0A\00", align 1
@.faila.3291 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3292 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5320 = private constant [1 x i8] zeroinitializer
@.strobj.5321 = private global %String { i64 0, ptr @.strdata.5320, i64 0 }
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %xs = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 28)
  store i64 5, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 20)
  store ptr %arr, ptr %xs, align 8
  %xs2 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %xs2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %xs2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 5, ptr %arr.elem, align 4
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %xs4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %xs4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 1, ptr %arr.elem10, align 4
  %xs11 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %xs11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %xs11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 3, ptr %arr.elem17, align 4
  %xs18 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %xs18, align 8
  %arr.oob20 = icmp uge i64 3, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok15
  %arr.data23 = getelementptr i8, ptr %xs18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 3
  store i32 2, ptr %arr.elem24, align 4
  %xs25 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len26 = load i64, ptr %xs25, align 8
  %arr.oob27 = icmp uge i64 4, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %xs25, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 4
  store i32 4, ptr %arr.elem31, align 4
  %17 = call i32 @IntMath.nCr(i32 5, i32 2)
  %18 = call i32 @IntMath.nCr(i32 10, i32 4)
  %19 = call i32 @IntMath.nPr(i32 5, i32 3)
  %xs32 = load ptr, ptr %xs, align 8
  %20 = call i32 @Stats.variance(ptr %xs32)
  %xs33 = load ptr, ptr %xs, align 8
  %21 = call i32 @Stats.stddev(ptr %xs33)
  %xs34 = load ptr, ptr %xs, align 8
  %22 = call i32 @Stats.median(ptr %xs34)
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22)
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

define internal void @Exception.Exception(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  ret void
}

define internal void @ArithmeticException.ArithmeticException(ptr %0) {
entry:
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ArithmeticException, ptr %0, i32 0, i32 0
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1320)
  ret ptr %strcpy
}

define internal void @DivideByZeroException.DivideByZeroException(ptr %0) {
entry:
  call void @ArithmeticException.ArithmeticException(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DivideByZeroException, ptr %0, i32 0, i32 0
  store ptr @DivideByZeroException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @DivideByZeroException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1322)
  ret ptr %strcpy
}

define internal i32 @IntMath.isqrt(i32 %0) {
entry:
  %r = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = icmp slt i32 %n1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  store i32 0, ptr %r, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %r2 = load i32, ptr %r, align 4
  %3 = add i32 %r2, 1
  %r3 = load i32, ptr %r, align 4
  %4 = add i32 %r3, 1
  %5 = mul i32 %3, %4
  %n4 = load i32, ptr %n, align 4
  %6 = icmp sle i32 %5, %n4
  %7 = zext i1 %6 to i32
  br i1 %6, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %r5 = load i32, ptr %r, align 4
  %8 = add i32 %r5, 1
  store i32 %8, ptr %r, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %r6 = load i32, ptr %r, align 4
  ret i32 %r6
}

define internal i32 @IntMath.nCr(i32 %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %result = alloca i32, align 4
  %k = alloca i32, align 4
  %r = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  store i32 %1, ptr %r, align 4
  %r1 = load i32, ptr %r, align 4
  %2 = icmp slt i32 %r1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %r2 = load i32, ptr %r, align 4
  %n3 = load i32, ptr %n, align 4
  %4 = icmp sgt i32 %r2, %n3
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i32 0

if.end:                                           ; preds = %sc.end
  %r4 = load i32, ptr %r, align 4
  store i32 %r4, ptr %k, align 4
  %k5 = load i32, ptr %k, align 4
  %n6 = load i32, ptr %n, align 4
  %k7 = load i32, ptr %k, align 4
  %7 = sub i32 %n6, %k7
  %8 = icmp sgt i32 %k5, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then8, label %if.end9

if.then8:                                         ; preds = %if.end
  %n10 = load i32, ptr %n, align 4
  %k11 = load i32, ptr %k, align 4
  %10 = sub i32 %n10, %k11
  store i32 %10, ptr %k, align 4
  br label %if.end9

if.end9:                                          ; preds = %if.then8, %if.end
  store i32 1, ptr %result, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end9
  %i12 = load i32, ptr %i, align 4
  %k13 = load i32, ptr %k, align 4
  %11 = icmp sle i32 %i12, %k13
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %result14 = load i32, ptr %result, align 4
  %n15 = load i32, ptr %n, align 4
  %k16 = load i32, ptr %k, align 4
  %13 = sub i32 %n15, %k16
  %i17 = load i32, ptr %i, align 4
  %14 = add i32 %13, %i17
  %15 = mul i32 %result14, %14
  %i18 = load i32, ptr %i, align 4
  %16 = icmp eq i32 %i18, 0
  %17 = icmp eq i32 %15, -2147483648
  %18 = icmp eq i32 %i18, -1
  %19 = and i1 %17, %18
  %20 = or i1 %16, %19
  br i1 %20, label %div.bad, label %div.ok

for.update:                                       ; preds = %div.ok
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %result19 = load i32, ptr %result, align 4
  ret i32 %result19

div.bad:                                          ; preds = %for.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.body
  %23 = sdiv i32 %15, %i18
  store i32 %23, ptr %result, align 4
  br label %for.update
}

define internal i32 @IntMath.nPr(i32 %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %result = alloca i32, align 4
  %r = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  store i32 %1, ptr %r, align 4
  %r1 = load i32, ptr %r, align 4
  %2 = icmp slt i32 %r1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %r2 = load i32, ptr %r, align 4
  %n3 = load i32, ptr %n, align 4
  %4 = icmp sgt i32 %r2, %n3
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  ret i32 0

if.end:                                           ; preds = %sc.end
  store i32 1, ptr %result, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i4 = load i32, ptr %i, align 4
  %r5 = load i32, ptr %r, align 4
  %7 = icmp slt i32 %i4, %r5
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %result6 = load i32, ptr %result, align 4
  %n7 = load i32, ptr %n, align 4
  %i8 = load i32, ptr %i, align 4
  %9 = sub i32 %n7, %i8
  %10 = mul i32 %result6, %9
  store i32 %10, ptr %result, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %result9 = load i32, ptr %result, align 4
  ret i32 %result9
}

define internal i32 @Stats.sum(ptr %0) {
entry:
  %i = alloca i32, align 4
  %s = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  store i32 0, ptr %s, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %xs2 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs2, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s3 = load i32, ptr %s, align 4
  %xs4 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %xs4, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s6 = load i32, ptr %s, align 4
  ret i32 %s6

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3245, ptr @.faila.3246, i64 %4, ptr @.failb.3247, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %xs4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %7 = add i32 %s3, %elem
  store i32 %7, ptr %s, align 4
  br label %for.update
}

define internal i32 @Stats.mean(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs1, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %xs2 = load ptr, ptr %xs, align 8
  %4 = call i32 @Stats.sum(ptr %xs2)
  %xs3 = load ptr, ptr %xs, align 8
  %len4 = load i64, ptr %xs3, align 8
  %5 = trunc i64 %len4 to i32
  %6 = icmp eq i32 %5, 0
  %7 = icmp eq i32 %4, -2147483648
  %8 = icmp eq i32 %5, -1
  %9 = and i1 %7, %8
  %10 = or i1 %6, %9
  br i1 %10, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end
  %11 = sdiv i32 %4, %5
  ret i32 %11
}

define internal i32 @Stats.variance(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %d = alloca i32, align 4
  %i = alloca i32, align 4
  %acc = alloca i32, align 4
  %mean = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs1, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %xs2 = load ptr, ptr %xs, align 8
  %4 = call i32 @Stats.mean(ptr %xs2)
  store i32 %4, ptr %mean, align 4
  store i32 0, ptr %acc, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i3 = load i32, ptr %i, align 4
  %xs4 = load ptr, ptr %xs, align 8
  %len5 = load i64, ptr %xs4, align 8
  %5 = trunc i64 %len5 to i32
  %6 = icmp slt i32 %i3, %5
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %xs6 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %8 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %xs6, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %acc12 = load i32, ptr %acc, align 4
  %xs13 = load ptr, ptr %xs, align 8
  %len14 = load i64, ptr %xs13, align 8
  %11 = trunc i64 %len14 to i32
  %12 = icmp eq i32 %11, 0
  %13 = icmp eq i32 %acc12, -2147483648
  %14 = icmp eq i32 %11, -1
  %15 = and i1 %13, %14
  %16 = or i1 %12, %15
  br i1 %16, label %div.bad, label %div.ok

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3266, ptr @.faila.3267, i64 %8, ptr @.failb.3268, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %xs6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %elem = load i32, ptr %arr.elem, align 4
  %mean8 = load i32, ptr %mean, align 4
  %17 = sub i32 %elem, %mean8
  store i32 %17, ptr %d, align 4
  %acc9 = load i32, ptr %acc, align 4
  %d10 = load i32, ptr %d, align 4
  %d11 = load i32, ptr %d, align 4
  %18 = mul i32 %d10, %d11
  %19 = add i32 %acc9, %18
  store i32 %19, ptr %acc, align 4
  br label %for.update

div.bad:                                          ; preds = %for.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.end
  %20 = sdiv i32 %acc12, %11
  ret i32 %20
}

define internal i32 @Stats.stddev(ptr %0) {
entry:
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8
  %1 = call i32 @Stats.variance(ptr %xs1)
  %2 = call i32 @IntMath.isqrt(i32 %1)
  ret i32 %2
}

define internal i32 @Stats.median(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %j = alloca i32, align 4
  %key = alloca i32, align 4
  %i17 = alloca i32, align 4
  %i = alloca i32, align 4
  %c = alloca ptr, align 8
  %n = alloca i32, align 4
  %xs = alloca ptr, align 8
  store ptr %0, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8
  %len = load i64, ptr %xs1, align 8
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
  %4 = sext i32 %n3 to i64
  %5 = mul i64 %4, 4
  %6 = add i64 8, %5
  %arr = call ptr @__polaron_malloc(i64 %6)
  store i64 %4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %7 = call ptr @memset(ptr %arr.data, i32 0, i64 %5)
  store ptr %arr, ptr %c, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %8 = icmp slt i32 %i4, %n5
  %9 = zext i1 %8 to i32
  br i1 %8, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %c6 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %10 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %c6, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok14
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %i17, align 4
  br label %for.cond18

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3269, ptr @.faila.3270, i64 %10, ptr @.failb.3271, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %c6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data8, i64 %10
  %xs9 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %13 = sext i32 %i10 to i64
  %arr.len11 = load i64, ptr %xs9, align 8
  %arr.oob12 = icmp uge i64 %13, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3272, ptr @.faila.3273, i64 %13, ptr @.failb.3274, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %xs9, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %13
  %elem = load i32, ptr %arr.elem16, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

for.cond18:                                       ; preds = %for.update20, %for.end
  %i22 = load i32, ptr %i17, align 4
  %n23 = load i32, ptr %n, align 4
  %14 = icmp slt i32 %i22, %n23
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body19, label %for.end21

for.body19:                                       ; preds = %for.cond18
  %c24 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %i25 = load i32, ptr %i17, align 4
  %16 = sext i32 %i25 to i64
  %arr.len26 = load i64, ptr %c24, align 8
  %arr.oob27 = icmp uge i64 %16, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

for.update20:                                     ; preds = %idx.ok68
  %17 = load i32, ptr %i17, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i17, align 4
  br label %for.cond18

for.end21:                                        ; preds = %for.cond18
  %c72 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %n73 = load i32, ptr %n, align 4
  %19 = icmp eq i32 %n73, -2147483648
  %20 = and i1 %19, false
  %21 = or i1 false, %20
  br i1 %21, label %div.bad, label %div.ok

idx.bad28:                                        ; preds = %for.body19
  call void @__polaron_fail(ptr @.fail.3275, ptr @.faila.3276, i64 %16, ptr @.failb.3277, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %for.body19
  %arr.data30 = getelementptr i8, ptr %c24, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %16
  %elem32 = load i32, ptr %arr.elem31, align 4
  store i32 %elem32, ptr %key, align 4
  %i33 = load i32, ptr %i17, align 4
  %22 = sub i32 %i33, 1
  store i32 %22, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok58, %idx.ok29
  %j34 = load i32, ptr %j, align 4
  %23 = icmp sge i32 %j34, 0
  %24 = zext i1 %23 to i32
  %sc.a = icmp ne i32 %24, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %c45 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %j46 = load i32, ptr %j, align 4
  %25 = add i32 %j46, 1
  %26 = sext i32 %25 to i64
  %arr.len47 = load i64, ptr %c45, align 8
  %arr.oob48 = icmp uge i64 %26, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

while.end:                                        ; preds = %sc.end
  %c63 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %j64 = load i32, ptr %j, align 4
  %27 = add i32 %j64, 1
  %28 = sext i32 %27 to i64
  %arr.len65 = load i64, ptr %c63, align 8
  %arr.oob66 = icmp uge i64 %28, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !2

sc.rhs:                                           ; preds = %while.cond
  %c35 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %j36 = load i32, ptr %j, align 4
  %29 = sext i32 %j36 to i64
  %arr.len37 = load i64, ptr %c35, align 8
  %arr.oob38 = icmp uge i64 %29, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

sc.end:                                           ; preds = %idx.ok40, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok40 ]
  %30 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad39:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.3278, ptr @.faila.3279, i64 %29, ptr @.failb.3280, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %sc.rhs
  %arr.data41 = getelementptr i8, ptr %c35, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %29
  %elem43 = load i32, ptr %arr.elem42, align 4
  %key44 = load i32, ptr %key, align 4
  %31 = icmp sgt i32 %elem43, %key44
  %32 = zext i1 %31 to i32
  %sc.b = icmp ne i32 %32, 0
  br label %sc.end

idx.bad49:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.3281, ptr @.faila.3282, i64 %26, ptr @.failb.3283, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %while.body
  %arr.data51 = getelementptr i8, ptr %c45, i64 8
  %arr.elem52 = getelementptr inbounds i32, ptr %arr.data51, i64 %26
  %c53 = load ptr, ptr %c, align 8, !nonnull !0, !dereferenceable !1
  %j54 = load i32, ptr %j, align 4
  %33 = sext i32 %j54 to i64
  %arr.len55 = load i64, ptr %c53, align 8
  %arr.oob56 = icmp uge i64 %33, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

idx.bad57:                                        ; preds = %idx.ok50
  call void @__polaron_fail(ptr @.fail.3284, ptr @.faila.3285, i64 %33, ptr @.failb.3286, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok50
  %arr.data59 = getelementptr i8, ptr %c53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %33
  %elem61 = load i32, ptr %arr.elem60, align 4
  store i32 %elem61, ptr %arr.elem52, align 4
  %j62 = load i32, ptr %j, align 4
  %34 = sub i32 %j62, 1
  store i32 %34, ptr %j, align 4
  br label %while.cond

idx.bad67:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.3287, ptr @.faila.3288, i64 %28, ptr @.failb.3289, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %while.end
  %arr.data69 = getelementptr i8, ptr %c63, i64 8
  %arr.elem70 = getelementptr inbounds i32, ptr %arr.data69, i64 %28
  %key71 = load i32, ptr %key, align 4
  store i32 %key71, ptr %arr.elem70, align 4
  br label %for.update20

div.bad:                                          ; preds = %for.end21
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %for.end21
  %35 = sdiv i32 %n73, 2
  %36 = sext i32 %35 to i64
  %arr.len74 = load i64, ptr %c72, align 8
  %arr.oob75 = icmp uge i64 %36, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !2

idx.bad76:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.3290, ptr @.faila.3291, i64 %36, ptr @.failb.3292, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %div.ok
  %arr.data78 = getelementptr i8, ptr %c72, i64 8
  %arr.elem79 = getelementptr inbounds i32, ptr %arr.data78, i64 %36
  %elem80 = load i32, ptr %arr.elem79, align 4
  ret i32 %elem80
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5321)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5323)
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

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

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
