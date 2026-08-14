; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/humanize.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/humanize.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@.str = private unnamed_addr constant [25 x i8] c"b1=%s b2=%s b3=%s b4=%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [41 x i8] c"o1=%s o2=%s o3=%s o11=%s o21=%s o112=%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1305 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1306 = private global %String { i64 16, ptr @.strdata.1305, i64 0 }
@.strdata.1307 = private constant [17 x i8] c"division by zero\00"
@.strobj.1308 = private global %String { i64 16, ptr @.strdata.1307, i64 0 }
@.fail.2847 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4405:25  in Humanize.bytes\0A\00", align 1
@.faila.2848 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2849 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2850 = private constant [2 x i8] c"B\00"
@.strobj.2851 = private global %String { i64 1, ptr @.strdata.2850, i64 0 }
@.fail.2852 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4405:39  in Humanize.bytes\0A\00", align 1
@.faila.2853 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2854 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2855 = private constant [3 x i8] c"KB\00"
@.strobj.2856 = private global %String { i64 2, ptr @.strdata.2855, i64 0 }
@.fail.2857 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4405:54  in Humanize.bytes\0A\00", align 1
@.faila.2858 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2859 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2860 = private constant [3 x i8] c"MB\00"
@.strobj.2861 = private global %String { i64 2, ptr @.strdata.2860, i64 0 }
@.fail.2862 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4405:69  in Humanize.bytes\0A\00", align 1
@.faila.2863 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2864 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2865 = private constant [3 x i8] c"GB\00"
@.strobj.2866 = private global %String { i64 2, ptr @.strdata.2865, i64 0 }
@.fail.2867 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4405:84  in Humanize.bytes\0A\00", align 1
@.faila.2868 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2869 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2870 = private constant [3 x i8] c"TB\00"
@.strobj.2871 = private global %String { i64 2, ptr @.strdata.2870, i64 0 }
@.fail.2872 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4411:78  in Humanize.bytes\0A\00", align 1
@.faila.2873 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2874 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2875 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4415:50  in Humanize.bytes\0A\00", align 1
@.faila.2876 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2877 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2878 = private constant [3 x i8] c"th\00"
@.strobj.2879 = private global %String { i64 2, ptr @.strdata.2878, i64 0 }
@.strdata.2880 = private constant [3 x i8] c"st\00"
@.strobj.2881 = private global %String { i64 2, ptr @.strdata.2880, i64 0 }
@.strdata.2882 = private constant [3 x i8] c"nd\00"
@.strobj.2883 = private global %String { i64 2, ptr @.strdata.2882, i64 0 }
@.strdata.2884 = private constant [3 x i8] c"rd\00"
@.strobj.2885 = private global %String { i64 2, ptr @.strdata.2884, i64 0 }
@.strdata.5306 = private constant [1 x i8] zeroinitializer
@.strobj.5307 = private global %String { i64 0, ptr @.strdata.5306, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }

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
  %16 = call ptr @Humanize.bytes(i64 500)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %17 = call ptr @Humanize.bytes(i64 1536)
  %str.data1 = getelementptr inbounds %String, ptr %17, i32 0, i32 1
  %data2 = load ptr, ptr %str.data1, align 8
  %18 = call ptr @Humanize.bytes(i64 1048576)
  %str.data3 = getelementptr inbounds %String, ptr %18, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %19 = call ptr @Humanize.bytes(i64 5368709120)
  %str.data5 = getelementptr inbounds %String, ptr %19, i32 0, i32 1
  %data6 = load ptr, ptr %str.data5, align 8
  %20 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, ptr %data2, ptr %data4, ptr %data6)
  call void @__polaron_str_free(ptr %16)
  call void @__polaron_str_free(ptr %17)
  call void @__polaron_str_free(ptr %18)
  call void @__polaron_str_free(ptr %19)
  %21 = call ptr @Humanize.ordinal(i32 1)
  %str.data7 = getelementptr inbounds %String, ptr %21, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %22 = call ptr @Humanize.ordinal(i32 2)
  %str.data9 = getelementptr inbounds %String, ptr %22, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %23 = call ptr @Humanize.ordinal(i32 3)
  %str.data11 = getelementptr inbounds %String, ptr %23, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %24 = call ptr @Humanize.ordinal(i32 11)
  %str.data13 = getelementptr inbounds %String, ptr %24, i32 0, i32 1
  %data14 = load ptr, ptr %str.data13, align 8
  %25 = call ptr @Humanize.ordinal(i32 21)
  %str.data15 = getelementptr inbounds %String, ptr %25, i32 0, i32 1
  %data16 = load ptr, ptr %str.data15, align 8
  %26 = call ptr @Humanize.ordinal(i32 112)
  %str.data17 = getelementptr inbounds %String, ptr %26, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %27 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data8, ptr %data10, ptr %data12, ptr %data14, ptr %data16, ptr %data18)
  call void @__polaron_str_free(ptr %21)
  call void @__polaron_str_free(ptr %22)
  call void @__polaron_str_free(ptr %23)
  call void @__polaron_str_free(ptr %24)
  call void @__polaron_str_free(ptr %25)
  call void @__polaron_str_free(ptr %26)
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
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
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1306)
  ret ptr %strcpy
}

define internal void @DivideByZeroException.DivideByZeroException(ptr %0) {
entry:
  call void @ArithmeticException.ArithmeticException(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DivideByZeroException, ptr %0, i32 0, i32 0
  store ptr @DivideByZeroException.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal ptr @DivideByZeroException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1308)
  ret ptr %strcpy
}

define internal void @StringBuilder.StringBuilder(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 0
  store ptr @StringBuilder.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  store i32 16, ptr %cap, align 4, !tbaa !4
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %1 = ptrtoint ptr %mem.alloc to i64
  store i64 %1, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @StringBuilder.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %nb = alloca i64, align 8
  %n = alloca i32, align 4
  %extra = alloca i32, align 4
  store i32 %1, ptr %extra, align 4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %extra2 = load i32, ptr %extra, align 4
  %2 = add i32 %count1, %extra2
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap3 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %2, %cap3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap5 = load i32, ptr %cap4, align 4, !tbaa !4
  %5 = mul i32 %cap5, 2
  store i32 %5, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %n6 = load i32, ptr %n, align 4
  %count7 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %extra9 = load i32, ptr %extra, align 4
  %6 = add i32 %count8, %extra9
  %7 = icmp slt i32 %n6, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n10 = load i32, ptr %n, align 4
  %9 = mul i32 %n10, 2
  store i32 %9, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n11 = load i32, ptr %n, align 4
  %10 = zext i32 %n11 to i64
  %mem.alloc = call ptr @__polaron_malloc(i64 %10)
  %11 = ptrtoint ptr %mem.alloc to i64
  store i64 %11, ptr %nb, align 8
  %nb12 = load i64, ptr %nb, align 8
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf13 = load i64, ptr %buf, align 8, !tbaa !6
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !6
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !6
  %cap20 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %n21 = load i32, ptr %n, align 4
  store i32 %n21, ptr %cap20, align 4, !tbaa !4
  ret void
}

define internal ptr @StringBuilder.append(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  call void @StringBuilder.ensure(ptr %0, i32 %n2)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !4
  %3 = sext i32 %count4 to i64
  %4 = add i64 %buf3, %3
  %s5 = load ptr, ptr %s, align 8
  %5 = inttoptr i64 %4 to ptr
  %str.len6 = getelementptr inbounds %String, ptr %s5, i32 0, i32 0
  %len7 = load i64, ptr %str.len6, align 8
  %str.data = getelementptr inbounds %String, ptr %s5, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %6 = call ptr @memcpy(ptr %5, ptr %data, i64 %len7)
  %count8 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count9 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %n11 = load i32, ptr %n, align 4
  %7 = add i32 %count10, %n11
  store i32 %7, ptr %count8, align 4, !tbaa !4
  ret ptr %0
}

define internal ptr @StringBuilder.appendChar(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  store i32 %1, ptr %c, align 4
  call void @StringBuilder.ensure(ptr %0, i32 1)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %2 = sext i32 %count2 to i64
  %3 = add i64 %buf1, %2
  %c3 = load i32, ptr %c, align 4
  %4 = trunc i32 %c3 to i8
  %5 = inttoptr i64 %3 to ptr
  store i8 %4, ptr %5, align 1
  %count4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count5 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count6 = load i32, ptr %count5, align 4, !tbaa !4
  %6 = add i32 %count6, 1
  store i32 %6, ptr %count4, align 4, !tbaa !4
  ret ptr %0
}

define internal ptr @StringBuilder.appendInt(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i8, align 1
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %exc.thrown15 = alloca ptr, align 8
  %d = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %start = alloca i32, align 4
  %v = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  call void @StringBuilder.ensure(ptr %0, i32 12)
  %value1 = load i32, ptr %value, align 4
  %2 = icmp eq i32 %value1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %4 = call ptr @StringBuilder.appendChar(ptr %0, i32 48)
  ret ptr %4

if.end:                                           ; preds = %entry
  %value2 = load i32, ptr %value, align 4
  store i32 %value2, ptr %v, align 4
  %v3 = load i32, ptr %v, align 4
  %5 = icmp sgt i32 %v3, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then4, label %if.else

if.then4:                                         ; preds = %if.end
  %v6 = load i32, ptr %v, align 4
  %7 = sub i32 0, %v6
  store i32 %7, ptr %v, align 4
  br label %if.end5

if.else:                                          ; preds = %if.end
  %8 = call ptr @StringBuilder.appendChar(ptr %0, i32 45)
  br label %if.end5

if.end5:                                          ; preds = %if.else, %if.then4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count, align 4, !tbaa !4
  store i32 %count7, ptr %start, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok13, %if.end5
  %v8 = load i32, ptr %v, align 4
  %9 = icmp ne i32 %v8, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v9 = load i32, ptr %v, align 4
  %11 = icmp eq i32 %v9, -2147483648
  %12 = and i1 %11, false
  %13 = or i1 false, %12
  br i1 %13, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  %start16 = load i32, ptr %start, align 4
  store i32 %start16, ptr %a, align 4
  %count17 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %14 = sub i32 %count18, 1
  store i32 %14, ptr %b, align 4
  br label %while.cond19

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %15 = srem i32 %v9, 10
  %16 = sub i32 0, %15
  store i32 %16, ptr %d, align 4
  %d10 = load i32, ptr %d, align 4
  %17 = add i32 48, %d10
  %18 = call ptr @StringBuilder.appendChar(ptr %0, i32 %17)
  %v11 = load i32, ptr %v, align 4
  %19 = icmp eq i32 %v11, -2147483648
  %20 = and i1 %19, false
  %21 = or i1 false, %20
  br i1 %21, label %div.bad12, label %div.ok13

div.bad12:                                        ; preds = %div.ok
  %exc14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc14)
  store ptr %exc14, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

div.ok13:                                         ; preds = %div.ok
  %22 = sdiv i32 %v11, 10
  store i32 %22, ptr %v, align 4
  br label %while.cond

while.cond19:                                     ; preds = %while.body20, %while.end
  %a22 = load i32, ptr %a, align 4
  %b23 = load i32, ptr %b, align 4
  %23 = icmp slt i32 %a22, %b23
  %24 = zext i1 %23 to i32
  br i1 %23, label %while.body20, label %while.end21

while.body20:                                     ; preds = %while.cond19
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf24 = load i64, ptr %buf, align 8, !tbaa !6
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !6
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !6
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !6
  %b35 = load i32, ptr %b, align 4
  %34 = sext i32 %b35 to i64
  %35 = add i64 %buf34, %34
  %t36 = load i8, ptr %t, align 1
  %36 = inttoptr i64 %35 to ptr
  store i8 %t36, ptr %36, align 1
  %a37 = load i32, ptr %a, align 4
  %37 = add i32 %a37, 1
  store i32 %37, ptr %a, align 4
  %b38 = load i32, ptr %b, align 4
  %38 = sub i32 %b38, 1
  store i32 %38, ptr %b, align 4
  br label %while.cond19

while.end21:                                      ; preds = %while.cond19
  ret ptr %0
}

define internal i32 @StringBuilder.length(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal ptr @StringBuilder.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count2 to i64
  %2 = inttoptr i64 %buf1 to ptr
  %3 = add i64 %1, 1
  %fb.buf = call ptr @__polaron_malloc(i64 %3)
  %4 = call ptr @memcpy(ptr %fb.buf, ptr %2, i64 %1)
  %5 = getelementptr i8, ptr %fb.buf, i64 %1
  store i8 0, ptr %5, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %1, ptr %6, align 8
  %7 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %fb.buf, ptr %7, align 8
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %8, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy
}

define internal ptr @StringBuilder.clear(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret ptr %0
}

define internal void @"StringBuilder.~StringBuilder"(ptr %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !6
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !6
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal ptr @Humanize.bytes(i64 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown61 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %whole = alloca i32, align 4
  %sb = alloca ptr, align 8
  %u = alloca i32, align 4
  %d = alloca double, align 8
  %units = alloca ptr, align 8
  %n = alloca i64, align 8
  store i64 %0, ptr %n, align 8
  %arr = call ptr @__polaron_malloc(i64 48)
  store i64 5, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 40)
  store ptr %arr, ptr %units, align 8
  %units1 = load ptr, ptr %units, align 8, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %units1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.2847, ptr @.faila.2848, i64 0, ptr @.failb.2849, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %units1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data2, i64 0
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2851)
  %2 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %arr.elem, align 8
  %units3 = load ptr, ptr %units, align 8, !nonnull !8, !dereferenceable !9
  %arr.len4 = load i64, ptr %units3, align 8
  %arr.oob5 = icmp uge i64 1, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !10

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2852, ptr @.faila.2853, i64 1, ptr @.failb.2854, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %units3, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 1
  %strcpy10 = call ptr @__polaron_str_copy(ptr @.strobj.2856)
  %3 = load ptr, ptr %arr.elem9, align 8
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy10, ptr %arr.elem9, align 8
  %units11 = load ptr, ptr %units, align 8, !nonnull !8, !dereferenceable !9
  %arr.len12 = load i64, ptr %units11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !10

idx.bad14:                                        ; preds = %idx.ok7
  call void @__polaron_fail(ptr @.fail.2857, ptr @.faila.2858, i64 2, ptr @.failb.2859, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok7
  %arr.data16 = getelementptr i8, ptr %units11, i64 8
  %arr.elem17 = getelementptr inbounds ptr, ptr %arr.data16, i64 2
  %strcpy18 = call ptr @__polaron_str_copy(ptr @.strobj.2861)
  %4 = load ptr, ptr %arr.elem17, align 8
  call void @__polaron_str_free(ptr %4)
  store ptr %strcpy18, ptr %arr.elem17, align 8
  %units19 = load ptr, ptr %units, align 8, !nonnull !8, !dereferenceable !9
  %arr.len20 = load i64, ptr %units19, align 8
  %arr.oob21 = icmp uge i64 3, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

idx.bad22:                                        ; preds = %idx.ok15
  call void @__polaron_fail(ptr @.fail.2862, ptr @.faila.2863, i64 3, ptr @.failb.2864, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok15
  %arr.data24 = getelementptr i8, ptr %units19, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 3
  %strcpy26 = call ptr @__polaron_str_copy(ptr @.strobj.2866)
  %5 = load ptr, ptr %arr.elem25, align 8
  call void @__polaron_str_free(ptr %5)
  store ptr %strcpy26, ptr %arr.elem25, align 8
  %units27 = load ptr, ptr %units, align 8, !nonnull !8, !dereferenceable !9
  %arr.len28 = load i64, ptr %units27, align 8
  %arr.oob29 = icmp uge i64 4, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !10

idx.bad30:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.2867, ptr @.faila.2868, i64 4, ptr @.failb.2869, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok23
  %arr.data32 = getelementptr i8, ptr %units27, i64 8
  %arr.elem33 = getelementptr inbounds ptr, ptr %arr.data32, i64 4
  %strcpy34 = call ptr @__polaron_str_copy(ptr @.strobj.2871)
  %6 = load ptr, ptr %arr.elem33, align 8
  call void @__polaron_str_free(ptr %6)
  store ptr %strcpy34, ptr %arr.elem33, align 8
  %n35 = load i64, ptr %n, align 8
  %7 = sitofp i64 %n35 to double
  store double %7, ptr %d, align 8
  store i32 0, ptr %u, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok31
  %d36 = load double, ptr %d, align 8
  %8 = fcmp oge double %d36, 1.024000e+03
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %d38 = load double, ptr %d, align 8
  %10 = fdiv double %d38, 1.024000e+03
  store double %10, ptr %d, align 8
  %u39 = load i32, ptr %u, align 4
  %11 = add i32 %u39, 1
  store i32 %11, ptr %u, align 4
  br label %while.cond

while.end:                                        ; preds = %sc.end
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %u40 = load i32, ptr %u, align 4
  %12 = icmp eq i32 %u40, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.else

sc.rhs:                                           ; preds = %while.cond
  %u37 = load i32, ptr %u, align 4
  %14 = icmp slt i32 %u37, 4
  %15 = zext i1 %14 to i32
  %sc.b = icmp ne i32 %15, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %16 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

if.then:                                          ; preds = %while.end
  %sb41 = load ptr, ptr %sb, align 8
  %n42 = load i64, ptr %n, align 8
  %17 = trunc i64 %n42 to i32
  %18 = call ptr @StringBuilder.appendInt(ptr %sb41, i32 %17)
  %sb43 = load ptr, ptr %sb, align 8
  %19 = call ptr @StringBuilder.appendChar(ptr %sb43, i32 32)
  %sb44 = load ptr, ptr %sb, align 8
  %units45 = load ptr, ptr %units, align 8, !nonnull !8, !dereferenceable !9
  %arr.len46 = load i64, ptr %units45, align 8
  %arr.oob47 = icmp uge i64 0, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !10

if.else:                                          ; preds = %while.end
  %d52 = load double, ptr %d, align 8
  %20 = fmul double %d52, 1.000000e+01
  %21 = fadd double %20, 5.000000e-01
  %22 = call i32 @llvm.fptosi.sat.i32.f64(double %21)
  store i32 %22, ptr %whole, align 4
  %sb53 = load ptr, ptr %sb, align 8
  %whole54 = load i32, ptr %whole, align 4
  %23 = icmp eq i32 %whole54, -2147483648
  %24 = and i1 %23, false
  %25 = or i1 false, %24
  br i1 %25, label %div.bad, label %div.ok

if.end:                                           ; preds = %idx.ok69, %idx.ok49
  %sb73 = load ptr, ptr %sb, align 8
  %26 = call ptr @StringBuilder.toString(ptr %sb73)
  %strcpy74 = call ptr @__polaron_str_copy(ptr %26)
  call void @__polaron_str_free(ptr %26)
  ret ptr %strcpy74

idx.bad48:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2872, ptr @.faila.2873, i64 0, ptr @.failb.2874, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %if.then
  %arr.data50 = getelementptr i8, ptr %units45, i64 8
  %arr.elem51 = getelementptr inbounds ptr, ptr %arr.data50, i64 0
  %elem = load ptr, ptr %arr.elem51, align 8
  %27 = call ptr @StringBuilder.append(ptr %sb44, ptr %elem)
  br label %if.end

div.bad:                                          ; preds = %if.else
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.else
  %28 = sdiv i32 %whole54, 10
  %29 = call ptr @StringBuilder.appendInt(ptr %sb53, i32 %28)
  %sb55 = load ptr, ptr %sb, align 8
  %30 = call ptr @StringBuilder.appendChar(ptr %sb55, i32 46)
  %sb56 = load ptr, ptr %sb, align 8
  %whole57 = load i32, ptr %whole, align 4
  %31 = icmp eq i32 %whole57, -2147483648
  %32 = and i1 %31, false
  %33 = or i1 false, %32
  br i1 %33, label %div.bad58, label %div.ok59

div.bad58:                                        ; preds = %div.ok
  %exc60 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc60)
  store ptr %exc60, ptr %exc.thrown61, align 8
  call void @_CxxThrowException(ptr %exc.thrown61, ptr @_TI1PEAX)
  unreachable

div.ok59:                                         ; preds = %div.ok
  %34 = srem i32 %whole57, 10
  %35 = call ptr @StringBuilder.appendInt(ptr %sb56, i32 %34)
  %sb62 = load ptr, ptr %sb, align 8
  %36 = call ptr @StringBuilder.appendChar(ptr %sb62, i32 32)
  %sb63 = load ptr, ptr %sb, align 8
  %units64 = load ptr, ptr %units, align 8, !nonnull !8, !dereferenceable !9
  %u65 = load i32, ptr %u, align 4
  %37 = sext i32 %u65 to i64
  %arr.len66 = load i64, ptr %units64, align 8
  %arr.oob67 = icmp uge i64 %37, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !10

idx.bad68:                                        ; preds = %div.ok59
  call void @__polaron_fail(ptr @.fail.2875, ptr @.faila.2876, i64 %37, ptr @.failb.2877, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %div.ok59
  %arr.data70 = getelementptr i8, ptr %units64, i64 8
  %arr.elem71 = getelementptr inbounds ptr, ptr %arr.data70, i64 %37
  %elem72 = load ptr, ptr %arr.elem71, align 8
  %38 = call ptr @StringBuilder.append(ptr %sb63, ptr %elem72)
  br label %if.end
}

define internal ptr @Humanize.ordinal(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %m10 = alloca i32, align 4
  %exc.thrown10 = alloca ptr, align 8
  %suf = alloca ptr, align 8
  %m100 = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %sb = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb1 = load ptr, ptr %sb, align 8
  %n2 = load i32, ptr %n, align 4
  %1 = call ptr @StringBuilder.appendInt(ptr %sb1, i32 %n2)
  %n3 = load i32, ptr %n, align 4
  %2 = icmp eq i32 %n3, -2147483648
  %3 = and i1 %2, false
  %4 = or i1 false, %3
  br i1 %4, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %5 = srem i32 %n3, 100
  store i32 %5, ptr %m100, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.2879)
  store ptr %strcpy, ptr %suf, align 8
  %m1004 = load i32, ptr %m100, align 4
  %6 = icmp slt i32 %m1004, 11
  %7 = zext i1 %6 to i32
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %div.ok
  %m1005 = load i32, ptr %m100, align 4
  %8 = icmp sgt i32 %m1005, 13
  %9 = zext i1 %8 to i32
  %sc.b = icmp ne i32 %9, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %div.ok
  %sc = phi i1 [ true, %div.ok ], [ %sc.b, %sc.rhs ]
  %10 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %n6 = load i32, ptr %n, align 4
  %11 = icmp eq i32 %n6, -2147483648
  %12 = and i1 %11, false
  %13 = or i1 false, %12
  br i1 %13, label %div.bad7, label %div.ok8

if.end:                                           ; preds = %if.end21, %sc.end
  %sb23 = load ptr, ptr %sb, align 8
  %suf24 = load ptr, ptr %suf, align 8
  %14 = call ptr @StringBuilder.append(ptr %sb23, ptr %suf24)
  %sb25 = load ptr, ptr %sb, align 8
  %15 = call ptr @StringBuilder.toString(ptr %sb25)
  %strcpy26 = call ptr @__polaron_str_copy(ptr %15)
  call void @__polaron_str_free(ptr %15)
  %16 = load ptr, ptr %suf, align 8
  call void @__polaron_str_free(ptr %16)
  ret ptr %strcpy26

div.bad7:                                         ; preds = %if.then
  %exc9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc9)
  store ptr %exc9, ptr %exc.thrown10, align 8
  call void @_CxxThrowException(ptr %exc.thrown10, ptr @_TI1PEAX)
  unreachable

div.ok8:                                          ; preds = %if.then
  %17 = srem i32 %n6, 10
  store i32 %17, ptr %m10, align 4
  %m1011 = load i32, ptr %m10, align 4
  %18 = icmp eq i32 %m1011, 1
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then12, label %if.end13

if.then12:                                        ; preds = %div.ok8
  %strcpy14 = call ptr @__polaron_str_copy(ptr @.strobj.2881)
  %20 = load ptr, ptr %suf, align 8
  call void @__polaron_str_free(ptr %20)
  store ptr %strcpy14, ptr %suf, align 8
  br label %if.end13

if.end13:                                         ; preds = %if.then12, %div.ok8
  %m1015 = load i32, ptr %m10, align 4
  %21 = icmp eq i32 %m1015, 2
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then16, label %if.end17

if.then16:                                        ; preds = %if.end13
  %strcpy18 = call ptr @__polaron_str_copy(ptr @.strobj.2883)
  %23 = load ptr, ptr %suf, align 8
  call void @__polaron_str_free(ptr %23)
  store ptr %strcpy18, ptr %suf, align 8
  br label %if.end17

if.end17:                                         ; preds = %if.then16, %if.end13
  %m1019 = load i32, ptr %m10, align 4
  %24 = icmp eq i32 %m1019, 3
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then20, label %if.end21

if.then20:                                        ; preds = %if.end17
  %strcpy22 = call ptr @__polaron_str_copy(ptr @.strobj.2885)
  %26 = load ptr, ptr %suf, align 8
  call void @__polaron_str_free(ptr %26)
  store ptr %strcpy22, ptr %suf, align 8
  br label %if.end21

if.end21:                                         ; preds = %if.then20, %if.end17
  br label %if.end
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5307)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #1

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
!8 = !{}
!9 = !{i64 8}
!10 = !{!"branch_weights", i32 1, i32 1048576}
