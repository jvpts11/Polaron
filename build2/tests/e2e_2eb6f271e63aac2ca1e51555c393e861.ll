; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/huffman.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/huffman.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Huffman = type { ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i32, ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Huffman.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Huffman.codeOf, ptr @Huffman.encode, ptr @Huffman.decode, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@.strdata = private constant [54 x i8] c"this is an example of a huffman tree compression test\00"
@.strobj = private global %String { i64 53, ptr @.strdata, i64 0 }
@.str = private unnamed_addr constant [32 x i8] c"rawbits=%d encbits=%d match=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"round=%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1307 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1308 = private global %String { i64 16, ptr @.strdata.1307, i64 0 }
@.strdata.1309 = private constant [17 x i8] c"division by zero\00"
@.strobj.1310 = private global %String { i64 16, ptr @.strdata.1309, i64 0 }
@.fail.2945 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4791:29  in Huffman.Huffman\0A\00", align 1
@.faila.2946 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2947 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2948 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4791:29  in Huffman.Huffman\0A\00", align 1
@.faila.2949 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2950 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2951 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4795:21  in Huffman.Huffman\0A\00", align 1
@.faila.2952 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2953 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2954 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4797:39  in Huffman.Huffman\0A\00", align 1
@.faila.2955 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2956 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2957 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4797:39  in Huffman.Huffman\0A\00", align 1
@.faila.2958 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2959 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2960 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4798:38  in Huffman.Huffman\0A\00", align 1
@.faila.2961 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2962 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2963 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4799:39  in Huffman.Huffman\0A\00", align 1
@.faila.2964 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2965 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2966 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4800:40  in Huffman.Huffman\0A\00", align 1
@.faila.2967 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2968 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2969 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4801:41  in Huffman.Huffman\0A\00", align 1
@.faila.2970 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2971 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2972 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4802:35  in Huffman.Huffman\0A\00", align 1
@.faila.2973 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2974 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2975 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4812:25  in Huffman.Huffman\0A\00", align 1
@.faila.2976 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2977 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2978 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4815:33  in Huffman.Huffman\0A\00", align 1
@.faila.2979 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2980 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2981 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4815:33  in Huffman.Huffman\0A\00", align 1
@.faila.2982 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2983 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2984 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4818:44  in Huffman.Huffman\0A\00", align 1
@.faila.2985 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2986 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2987 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4818:44  in Huffman.Huffman\0A\00", align 1
@.faila.2988 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2989 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2990 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4824:35  in Huffman.Huffman\0A\00", align 1
@.faila.2991 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2992 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2993 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4824:35  in Huffman.Huffman\0A\00", align 1
@.faila.2994 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2995 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2996 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4824:35  in Huffman.Huffman\0A\00", align 1
@.faila.2997 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.2998 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.2999 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4825:35  in Huffman.Huffman\0A\00", align 1
@.faila.3000 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3001 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3002 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4826:36  in Huffman.Huffman\0A\00", align 1
@.faila.3003 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3004 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3005 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4827:34  in Huffman.Huffman\0A\00", align 1
@.faila.3006 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3007 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3008 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4828:37  in Huffman.Huffman\0A\00", align 1
@.faila.3009 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3010 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3011 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4829:36  in Huffman.Huffman\0A\00", align 1
@.faila.3012 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3013 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3014 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4830:33  in Huffman.Huffman\0A\00", align 1
@.faila.3015 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3016 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3017 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4831:37  in Huffman.Huffman\0A\00", align 1
@.faila.3018 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3019 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3020 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4832:34  in Huffman.Huffman\0A\00", align 1
@.faila.3021 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3022 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3023 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4833:30  in Huffman.Huffman\0A\00", align 1
@.faila.3024 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3025 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3026 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4834:31  in Huffman.Huffman\0A\00", align 1
@.faila.3027 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3028 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3029 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4835:31  in Huffman.Huffman\0A\00", align 1
@.faila.3030 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3031 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3032 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4841:21  in Huffman.Huffman\0A\00", align 1
@.faila.3033 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3034 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3035 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4845:25  in Huffman.Huffman\0A\00", align 1
@.faila.3036 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3037 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3038 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4846:36  in Huffman.Huffman\0A\00", align 1
@.faila.3039 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3040 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3041 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4846:36  in Huffman.Huffman\0A\00", align 1
@.faila.3042 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3043 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3044 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4848:34  in Huffman.Huffman\0A\00", align 1
@.faila.3045 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3046 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3047 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4853:29  in Huffman.Huffman\0A\00", align 1
@.faila.3048 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3049 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3050 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4855:49  in Huffman.Huffman\0A\00", align 1
@.faila.3051 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3052 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3053 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4855:49  in Huffman.Huffman\0A\00", align 1
@.faila.3054 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3055 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3056 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4861:66  in Huffman.codeOf\0A\00", align 1
@.faila.3057 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3058 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3059 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4866:30  in Huffman.encode\0A\00", align 1
@.faila.3060 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3061 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3062 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4873:17  in Huffman.decode\0A\00", align 1
@.faila.3063 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3064 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3065 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4874:72  in Huffman.decode\0A\00", align 1
@.faila.3066 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3067 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3068 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4879:55  in Huffman.decode\0A\00", align 1
@.faila.3069 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3070 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3071 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4879:88  in Huffman.decode\0A\00", align 1
@.faila.3072 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3073 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3074 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4880:21  in Huffman.decode\0A\00", align 1
@.faila.3075 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3076 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3077 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:4881:38  in Huffman.decode\0A\00", align 1
@.faila.3078 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3079 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %ok = alloca i32, align 4
  %rawBits = alloca i32, align 4
  %back = alloca ptr, align 8
  %bits = alloca ptr, align 8
  %h = alloca ptr, align 8
  %text = alloca ptr, align 8
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  store ptr %strcpy, ptr %text, align 8
  %Huffman.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Huffman, ptr null, i64 1) to i64))
  %text1 = load ptr, ptr %text, align 8
  call void @Huffman.Huffman(ptr %Huffman.obj, ptr %text1)
  store ptr %Huffman.obj, ptr %h, align 8
  %h2 = load ptr, ptr %h, align 8
  %text3 = load ptr, ptr %text, align 8
  %16 = call ptr @Huffman.encode(ptr %h2, ptr %text3)
  %strcpy4 = call ptr @__polaron_str_copy(ptr %16)
  store ptr %strcpy4, ptr %bits, align 8
  call void @__polaron_str_free(ptr %16)
  %h5 = load ptr, ptr %h, align 8
  %bits6 = load ptr, ptr %bits, align 8
  %17 = call ptr @Huffman.decode(ptr %h5, ptr %bits6)
  %strcpy7 = call ptr @__polaron_str_copy(ptr %17)
  store ptr %strcpy7, ptr %back, align 8
  call void @__polaron_str_free(ptr %17)
  %text8 = load ptr, ptr %text, align 8
  %str.len = getelementptr inbounds %String, ptr %text8, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %18 = trunc i64 %len to i32
  %19 = mul i32 %18, 8
  store i32 %19, ptr %rawBits, align 4
  %back9 = load ptr, ptr %back, align 8
  %text10 = load ptr, ptr %text, align 8
  %str.data = getelementptr inbounds %String, ptr %back9, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data11 = getelementptr inbounds %String, ptr %text10, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %20 = call i32 @strcmp(ptr %data, ptr %data12)
  %21 = icmp eq i32 %20, 0
  %22 = zext i1 %21 to i32
  store i32 %22, ptr %ok, align 4
  %rawBits13 = load i32, ptr %rawBits, align 4
  %bits14 = load ptr, ptr %bits, align 8
  %str.len15 = getelementptr inbounds %String, ptr %bits14, i32 0, i32 0
  %len16 = load i64, ptr %str.len15, align 8
  %23 = trunc i64 %len16 to i32
  %ok17 = load i32, ptr %ok, align 4
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %rawBits13, i32 %23, i32 %ok17)
  %back18 = load ptr, ptr %back, align 8
  %str.data19 = getelementptr inbounds %String, ptr %back18, i32 0, i32 1
  %data20 = load ptr, ptr %str.data19, align 8
  %25 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data20)
  %26 = load ptr, ptr %back, align 8
  call void @__polaron_str_free(ptr %26)
  %27 = load ptr, ptr %bits, align 8
  call void @__polaron_str_free(ptr %27)
  %28 = load ptr, ptr %text, align 8
  call void @__polaron_str_free(ptr %28)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1308)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1310)
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

define internal void @Huffman.Huffman(ptr %0, ptr %1) {
entry:
  %j = alloca i32, align 4
  %sb = alloca ptr, align 8
  %node = alloca i32, align 4
  %d = alloca i32, align 4
  %tmp = alloca ptr, align 8
  %i339 = alloca i32, align 4
  %id204 = alloca i32, align 4
  %i126 = alloca i32, align 4
  %b2 = alloca i32, align 4
  %a = alloca i32, align 4
  %live = alloca i32, align 4
  %id = alloca i32, align 4
  %b = alloca i32, align 4
  %ch30 = alloca i32, align 4
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %cnt = alloca ptr, align 8
  %alive = alloca ptr, align 8
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 0
  store ptr @Huffman.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %freq = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  store ptr null, ptr %freq, align 8, !tbaa !0
  %left = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 2
  store ptr null, ptr %left, align 8, !tbaa !0
  %right = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 3
  store ptr null, ptr %right, align 8, !tbaa !0
  %parent = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 4
  store ptr null, ptr %parent, align 8, !tbaa !0
  %bit = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 5
  store ptr null, ptr %bit, align 8, !tbaa !0
  %sym = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 6
  store ptr null, ptr %sym, align 8, !tbaa !0
  %codes = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 9
  store ptr null, ptr %codes, align 8, !tbaa !0
  %freq1 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 2056)
  store i64 512, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %2 = call ptr @memset(ptr %arr.data, i32 0, i64 2048)
  store ptr %arr, ptr %freq1, align 8, !tbaa !0
  %left2 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 2056)
  store i64 512, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %3 = call ptr @memset(ptr %arr.data4, i32 0, i64 2048)
  store ptr %arr3, ptr %left2, align 8, !tbaa !0
  %right5 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 2056)
  store i64 512, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %4 = call ptr @memset(ptr %arr.data7, i32 0, i64 2048)
  store ptr %arr6, ptr %right5, align 8, !tbaa !0
  %parent8 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 4
  %arr9 = call ptr @__polaron_malloc(i64 2056)
  store i64 512, ptr %arr9, align 8
  %arr.data10 = getelementptr i8, ptr %arr9, i64 8
  %5 = call ptr @memset(ptr %arr.data10, i32 0, i64 2048)
  store ptr %arr9, ptr %parent8, align 8, !tbaa !0
  %bit11 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 5
  %arr12 = call ptr @__polaron_malloc(i64 2056)
  store i64 512, ptr %arr12, align 8
  %arr.data13 = getelementptr i8, ptr %arr12, i64 8
  %6 = call ptr @memset(ptr %arr.data13, i32 0, i64 2048)
  store ptr %arr12, ptr %bit11, align 8, !tbaa !0
  %sym14 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 6
  %arr15 = call ptr @__polaron_malloc(i64 2056)
  store i64 512, ptr %arr15, align 8
  %arr.data16 = getelementptr i8, ptr %arr15, i64 8
  %7 = call ptr @memset(ptr %arr.data16, i32 0, i64 2048)
  store ptr %arr15, ptr %sym14, align 8, !tbaa !0
  %codes17 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 9
  %arr18 = call ptr @__polaron_malloc(i64 2056)
  store i64 256, ptr %arr18, align 8
  %arr.data19 = getelementptr i8, ptr %arr18, i64 8
  %8 = call ptr @memset(ptr %arr.data19, i32 0, i64 2048)
  store ptr %arr18, ptr %codes17, align 8, !tbaa !0
  %arr20 = call ptr @__polaron_malloc(i64 520)
  store i64 512, ptr %arr20, align 8
  %arr.data21 = getelementptr i8, ptr %arr20, i64 8
  %9 = call ptr @memset(ptr %arr.data21, i32 0, i64 512)
  store ptr %arr20, ptr %alive, align 8
  %arr22 = call ptr @__polaron_malloc(i64 1032)
  store i64 256, ptr %arr22, align 8
  %arr.data23 = getelementptr i8, ptr %arr22, i64 8
  %10 = call ptr @memset(ptr %arr.data23, i32 0, i64 1024)
  store ptr %arr22, ptr %cnt, align 8
  %data24 = load ptr, ptr %data, align 8
  %str.len = getelementptr inbounds %String, ptr %data24, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %11 = trunc i64 %len to i32
  store i32 %11, ptr %n, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i25 = load i32, ptr %i, align 4
  %n26 = load i32, ptr %n, align 4
  %12 = icmp slt i32 %i25, %n26
  %13 = zext i1 %12 to i32
  br i1 %12, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data27 = load ptr, ptr %data, align 8
  %i28 = load i32, ptr %i, align 4
  %14 = sext i32 %i28 to i64
  %str.data = getelementptr inbounds %String, ptr %data27, i32 0, i32 1
  %data29 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data29, i64 %14
  %ch = load i8, ptr %ch.addr, align 1
  %15 = zext i8 %ch to i32
  %16 = and i32 %15, 255
  store i32 %16, ptr %ch30, align 4
  %cnt31 = load ptr, ptr %cnt, align 8, !nonnull !8, !dereferenceable !9
  %ch32 = load i32, ptr %ch30, align 4
  %17 = sext i32 %ch32 to i64
  %arr.len = load i64, ptr %cnt31, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok39
  %18 = load i32, ptr %i, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 7
  store i32 0, ptr %count, align 4, !tbaa !4
  store i32 0, ptr %b, align 4
  br label %for.cond42

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.2945, ptr @.faila.2946, i64 %17, ptr @.failb.2947, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data33 = getelementptr i8, ptr %cnt31, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data33, i64 %17
  %cnt34 = load ptr, ptr %cnt, align 8, !nonnull !8, !dereferenceable !9
  %ch35 = load i32, ptr %ch30, align 4
  %20 = sext i32 %ch35 to i64
  %arr.len36 = load i64, ptr %cnt34, align 8
  %arr.oob37 = icmp uge i64 %20, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !10

idx.bad38:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.2948, ptr @.faila.2949, i64 %20, ptr @.failb.2950, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok
  %arr.data40 = getelementptr i8, ptr %cnt34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %20
  %elem = load i32, ptr %arr.elem41, align 4
  %21 = add i32 %elem, 1
  store i32 %21, ptr %arr.elem, align 4
  br label %for.update

for.cond42:                                       ; preds = %for.update44, %for.end
  %b46 = load i32, ptr %b, align 4
  %22 = icmp slt i32 %b46, 256
  %23 = zext i1 %22 to i32
  br i1 %22, label %for.body43, label %for.end45

for.body43:                                       ; preds = %for.cond42
  %cnt47 = load ptr, ptr %cnt, align 8, !nonnull !8, !dereferenceable !9
  %b48 = load i32, ptr %b, align 4
  %24 = sext i32 %b48 to i64
  %arr.len49 = load i64, ptr %cnt47, align 8
  %arr.oob50 = icmp uge i64 %24, %arr.len49
  br i1 %arr.oob50, label %idx.bad51, label %idx.ok52, !prof !10

for.update44:                                     ; preds = %if.end
  %25 = load i32, ptr %b, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %b, align 4
  br label %for.cond42

for.end45:                                        ; preds = %for.cond42
  %count123 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 7
  %count124 = load i32, ptr %count123, align 4, !tbaa !4
  store i32 %count124, ptr %live, align 4
  %root = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 8
  store i32 0, ptr %root, align 4, !tbaa !4
  br label %while.cond

idx.bad51:                                        ; preds = %for.body43
  call void @__polaron_fail(ptr @.fail.2951, ptr @.faila.2952, i64 %24, ptr @.failb.2953, i64 %arr.len49, i32 70)
  unreachable

idx.ok52:                                         ; preds = %for.body43
  %arr.data53 = getelementptr i8, ptr %cnt47, i64 8
  %arr.elem54 = getelementptr inbounds i32, ptr %arr.data53, i64 %24
  %elem55 = load i32, ptr %arr.elem54, align 4
  %27 = icmp sgt i32 %elem55, 0
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok52
  %count56 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 7
  %count57 = load i32, ptr %count56, align 4, !tbaa !4
  store i32 %count57, ptr %id, align 4
  %freq58 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %freq59 = load ptr, ptr %freq58, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id60 = load i32, ptr %id, align 4
  %29 = sext i32 %id60 to i64
  %arr.len61 = load i64, ptr %freq59, align 8
  %arr.oob62 = icmp uge i64 %29, %arr.len61
  br i1 %arr.oob62, label %idx.bad63, label %idx.ok64, !prof !10

if.end:                                           ; preds = %idx.ok118, %idx.ok52
  br label %for.update44

idx.bad63:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.2954, ptr @.faila.2955, i64 %29, ptr @.failb.2956, i64 %arr.len61, i32 70)
  unreachable

idx.ok64:                                         ; preds = %if.then
  %arr.data65 = getelementptr i8, ptr %freq59, i64 8
  %arr.elem66 = getelementptr inbounds i32, ptr %arr.data65, i64 %29
  %cnt67 = load ptr, ptr %cnt, align 8, !nonnull !8, !dereferenceable !9
  %b68 = load i32, ptr %b, align 4
  %30 = sext i32 %b68 to i64
  %arr.len69 = load i64, ptr %cnt67, align 8
  %arr.oob70 = icmp uge i64 %30, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !10

idx.bad71:                                        ; preds = %idx.ok64
  call void @__polaron_fail(ptr @.fail.2957, ptr @.faila.2958, i64 %30, ptr @.failb.2959, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok64
  %arr.data73 = getelementptr i8, ptr %cnt67, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %30
  %elem75 = load i32, ptr %arr.elem74, align 4
  store i32 %elem75, ptr %arr.elem66, align 4
  %sym76 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 6
  %sym77 = load ptr, ptr %sym76, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id78 = load i32, ptr %id, align 4
  %31 = sext i32 %id78 to i64
  %arr.len79 = load i64, ptr %sym77, align 8
  %arr.oob80 = icmp uge i64 %31, %arr.len79
  br i1 %arr.oob80, label %idx.bad81, label %idx.ok82, !prof !10

idx.bad81:                                        ; preds = %idx.ok72
  call void @__polaron_fail(ptr @.fail.2960, ptr @.faila.2961, i64 %31, ptr @.failb.2962, i64 %arr.len79, i32 70)
  unreachable

idx.ok82:                                         ; preds = %idx.ok72
  %arr.data83 = getelementptr i8, ptr %sym77, i64 8
  %arr.elem84 = getelementptr inbounds i32, ptr %arr.data83, i64 %31
  %b85 = load i32, ptr %b, align 4
  store i32 %b85, ptr %arr.elem84, align 4
  %left86 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 2
  %left87 = load ptr, ptr %left86, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id88 = load i32, ptr %id, align 4
  %32 = sext i32 %id88 to i64
  %arr.len89 = load i64, ptr %left87, align 8
  %arr.oob90 = icmp uge i64 %32, %arr.len89
  br i1 %arr.oob90, label %idx.bad91, label %idx.ok92, !prof !10

idx.bad91:                                        ; preds = %idx.ok82
  call void @__polaron_fail(ptr @.fail.2963, ptr @.faila.2964, i64 %32, ptr @.failb.2965, i64 %arr.len89, i32 70)
  unreachable

idx.ok92:                                         ; preds = %idx.ok82
  %arr.data93 = getelementptr i8, ptr %left87, i64 8
  %arr.elem94 = getelementptr inbounds i32, ptr %arr.data93, i64 %32
  store i32 -1, ptr %arr.elem94, align 4
  %right95 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 3
  %right96 = load ptr, ptr %right95, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id97 = load i32, ptr %id, align 4
  %33 = sext i32 %id97 to i64
  %arr.len98 = load i64, ptr %right96, align 8
  %arr.oob99 = icmp uge i64 %33, %arr.len98
  br i1 %arr.oob99, label %idx.bad100, label %idx.ok101, !prof !10

idx.bad100:                                       ; preds = %idx.ok92
  call void @__polaron_fail(ptr @.fail.2966, ptr @.faila.2967, i64 %33, ptr @.failb.2968, i64 %arr.len98, i32 70)
  unreachable

idx.ok101:                                        ; preds = %idx.ok92
  %arr.data102 = getelementptr i8, ptr %right96, i64 8
  %arr.elem103 = getelementptr inbounds i32, ptr %arr.data102, i64 %33
  store i32 -1, ptr %arr.elem103, align 4
  %parent104 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 4
  %parent105 = load ptr, ptr %parent104, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id106 = load i32, ptr %id, align 4
  %34 = sext i32 %id106 to i64
  %arr.len107 = load i64, ptr %parent105, align 8
  %arr.oob108 = icmp uge i64 %34, %arr.len107
  br i1 %arr.oob108, label %idx.bad109, label %idx.ok110, !prof !10

idx.bad109:                                       ; preds = %idx.ok101
  call void @__polaron_fail(ptr @.fail.2969, ptr @.faila.2970, i64 %34, ptr @.failb.2971, i64 %arr.len107, i32 70)
  unreachable

idx.ok110:                                        ; preds = %idx.ok101
  %arr.data111 = getelementptr i8, ptr %parent105, i64 8
  %arr.elem112 = getelementptr inbounds i32, ptr %arr.data111, i64 %34
  store i32 -1, ptr %arr.elem112, align 4
  %alive113 = load ptr, ptr %alive, align 8, !nonnull !8, !dereferenceable !9
  %id114 = load i32, ptr %id, align 4
  %35 = sext i32 %id114 to i64
  %arr.len115 = load i64, ptr %alive113, align 8
  %arr.oob116 = icmp uge i64 %35, %arr.len115
  br i1 %arr.oob116, label %idx.bad117, label %idx.ok118, !prof !10

idx.bad117:                                       ; preds = %idx.ok110
  call void @__polaron_fail(ptr @.fail.2972, ptr @.faila.2973, i64 %35, ptr @.failb.2974, i64 %arr.len115, i32 70)
  unreachable

idx.ok118:                                        ; preds = %idx.ok110
  %arr.data119 = getelementptr i8, ptr %alive113, i64 8
  %arr.elem120 = getelementptr inbounds i8, ptr %arr.data119, i64 %35
  store i8 1, ptr %arr.elem120, align 1
  %count121 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 7
  %id122 = load i32, ptr %id, align 4
  %36 = add i32 %id122, 1
  store i32 %36, ptr %count121, align 4, !tbaa !4
  br label %if.end

while.cond:                                       ; preds = %idx.ok331, %for.end45
  %live125 = load i32, ptr %live, align 4
  %37 = icmp sgt i32 %live125, 1
  %38 = zext i1 %37 to i32
  br i1 %37, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  store i32 -1, ptr %a, align 4
  store i32 -1, ptr %b2, align 4
  store i32 0, ptr %i126, align 4
  br label %for.cond127

while.end:                                        ; preds = %while.cond
  store i32 0, ptr %i339, align 4
  br label %for.cond340

for.cond127:                                      ; preds = %for.update129, %while.body
  %i131 = load i32, ptr %i126, align 4
  %count132 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 7
  %count133 = load i32, ptr %count132, align 4, !tbaa !4
  %39 = icmp slt i32 %i131, %count133
  %40 = zext i1 %39 to i32
  br i1 %39, label %for.body128, label %for.end130

for.body128:                                      ; preds = %for.cond127
  %alive134 = load ptr, ptr %alive, align 8, !nonnull !8, !dereferenceable !9
  %i135 = load i32, ptr %i126, align 4
  %41 = sext i32 %i135 to i64
  %arr.len136 = load i64, ptr %alive134, align 8
  %arr.oob137 = icmp uge i64 %41, %arr.len136
  br i1 %arr.oob137, label %idx.bad138, label %idx.ok139, !prof !10

for.update129:                                    ; preds = %if.end144
  %42 = load i32, ptr %i126, align 4
  %43 = add i32 %42, 1
  store i32 %43, ptr %i126, align 4
  br label %for.cond127

for.end130:                                       ; preds = %for.cond127
  %count202 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 7
  %count203 = load i32, ptr %count202, align 4, !tbaa !4
  store i32 %count203, ptr %id204, align 4
  %freq205 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %freq206 = load ptr, ptr %freq205, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id207 = load i32, ptr %id204, align 4
  %44 = sext i32 %id207 to i64
  %arr.len208 = load i64, ptr %freq206, align 8
  %arr.oob209 = icmp uge i64 %44, %arr.len208
  br i1 %arr.oob209, label %idx.bad210, label %idx.ok211, !prof !10

idx.bad138:                                       ; preds = %for.body128
  call void @__polaron_fail(ptr @.fail.2975, ptr @.faila.2976, i64 %41, ptr @.failb.2977, i64 %arr.len136, i32 70)
  unreachable

idx.ok139:                                        ; preds = %for.body128
  %arr.data140 = getelementptr i8, ptr %alive134, i64 8
  %arr.elem141 = getelementptr inbounds i8, ptr %arr.data140, i64 %41
  %elem142 = load i8, ptr %arr.elem141, align 1
  %45 = zext i8 %elem142 to i32
  %46 = icmp ne i32 %45, 0
  br i1 %46, label %if.then143, label %if.end144

if.then143:                                       ; preds = %idx.ok139
  %a145 = load i32, ptr %a, align 4
  %47 = icmp eq i32 %a145, -1
  %48 = zext i1 %47 to i32
  br i1 %47, label %if.then146, label %if.else

if.end144:                                        ; preds = %if.end147, %idx.ok139
  br label %for.update129

if.then146:                                       ; preds = %if.then143
  %i148 = load i32, ptr %i126, align 4
  store i32 %i148, ptr %a, align 4
  br label %if.end147

if.else:                                          ; preds = %if.then143
  %freq149 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %freq150 = load ptr, ptr %freq149, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i151 = load i32, ptr %i126, align 4
  %49 = sext i32 %i151 to i64
  %arr.len152 = load i64, ptr %freq150, align 8
  %arr.oob153 = icmp uge i64 %49, %arr.len152
  br i1 %arr.oob153, label %idx.bad154, label %idx.ok155, !prof !10

if.end147:                                        ; preds = %if.end171, %if.then146
  br label %if.end144

idx.bad154:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.2978, ptr @.faila.2979, i64 %49, ptr @.failb.2980, i64 %arr.len152, i32 70)
  unreachable

idx.ok155:                                        ; preds = %if.else
  %arr.data156 = getelementptr i8, ptr %freq150, i64 8
  %arr.elem157 = getelementptr inbounds i32, ptr %arr.data156, i64 %49
  %elem158 = load i32, ptr %arr.elem157, align 4
  %freq159 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %freq160 = load ptr, ptr %freq159, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %a161 = load i32, ptr %a, align 4
  %50 = sext i32 %a161 to i64
  %arr.len162 = load i64, ptr %freq160, align 8
  %arr.oob163 = icmp uge i64 %50, %arr.len162
  br i1 %arr.oob163, label %idx.bad164, label %idx.ok165, !prof !10

idx.bad164:                                       ; preds = %idx.ok155
  call void @__polaron_fail(ptr @.fail.2981, ptr @.faila.2982, i64 %50, ptr @.failb.2983, i64 %arr.len162, i32 70)
  unreachable

idx.ok165:                                        ; preds = %idx.ok155
  %arr.data166 = getelementptr i8, ptr %freq160, i64 8
  %arr.elem167 = getelementptr inbounds i32, ptr %arr.data166, i64 %50
  %elem168 = load i32, ptr %arr.elem167, align 4
  %51 = icmp slt i32 %elem158, %elem168
  %52 = zext i1 %51 to i32
  br i1 %51, label %if.then169, label %if.else170

if.then169:                                       ; preds = %idx.ok165
  %a172 = load i32, ptr %a, align 4
  store i32 %a172, ptr %b2, align 4
  %i173 = load i32, ptr %i126, align 4
  store i32 %i173, ptr %a, align 4
  br label %if.end171

if.else170:                                       ; preds = %idx.ok165
  %b2174 = load i32, ptr %b2, align 4
  %53 = icmp eq i32 %b2174, -1
  %54 = zext i1 %53 to i32
  br i1 %53, label %if.then175, label %if.else176

if.end171:                                        ; preds = %if.end177, %if.then169
  br label %if.end147

if.then175:                                       ; preds = %if.else170
  %i178 = load i32, ptr %i126, align 4
  store i32 %i178, ptr %b2, align 4
  br label %if.end177

if.else176:                                       ; preds = %if.else170
  %freq179 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %freq180 = load ptr, ptr %freq179, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i181 = load i32, ptr %i126, align 4
  %55 = sext i32 %i181 to i64
  %arr.len182 = load i64, ptr %freq180, align 8
  %arr.oob183 = icmp uge i64 %55, %arr.len182
  br i1 %arr.oob183, label %idx.bad184, label %idx.ok185, !prof !10

if.end177:                                        ; preds = %if.end200, %if.then175
  br label %if.end171

idx.bad184:                                       ; preds = %if.else176
  call void @__polaron_fail(ptr @.fail.2984, ptr @.faila.2985, i64 %55, ptr @.failb.2986, i64 %arr.len182, i32 70)
  unreachable

idx.ok185:                                        ; preds = %if.else176
  %arr.data186 = getelementptr i8, ptr %freq180, i64 8
  %arr.elem187 = getelementptr inbounds i32, ptr %arr.data186, i64 %55
  %elem188 = load i32, ptr %arr.elem187, align 4
  %freq189 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %freq190 = load ptr, ptr %freq189, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %b2191 = load i32, ptr %b2, align 4
  %56 = sext i32 %b2191 to i64
  %arr.len192 = load i64, ptr %freq190, align 8
  %arr.oob193 = icmp uge i64 %56, %arr.len192
  br i1 %arr.oob193, label %idx.bad194, label %idx.ok195, !prof !10

idx.bad194:                                       ; preds = %idx.ok185
  call void @__polaron_fail(ptr @.fail.2987, ptr @.faila.2988, i64 %56, ptr @.failb.2989, i64 %arr.len192, i32 70)
  unreachable

idx.ok195:                                        ; preds = %idx.ok185
  %arr.data196 = getelementptr i8, ptr %freq190, i64 8
  %arr.elem197 = getelementptr inbounds i32, ptr %arr.data196, i64 %56
  %elem198 = load i32, ptr %arr.elem197, align 4
  %57 = icmp slt i32 %elem188, %elem198
  %58 = zext i1 %57 to i32
  br i1 %57, label %if.then199, label %if.end200

if.then199:                                       ; preds = %idx.ok195
  %i201 = load i32, ptr %i126, align 4
  store i32 %i201, ptr %b2, align 4
  br label %if.end200

if.end200:                                        ; preds = %if.then199, %idx.ok195
  br label %if.end177

idx.bad210:                                       ; preds = %for.end130
  call void @__polaron_fail(ptr @.fail.2990, ptr @.faila.2991, i64 %44, ptr @.failb.2992, i64 %arr.len208, i32 70)
  unreachable

idx.ok211:                                        ; preds = %for.end130
  %arr.data212 = getelementptr i8, ptr %freq206, i64 8
  %arr.elem213 = getelementptr inbounds i32, ptr %arr.data212, i64 %44
  %freq214 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %freq215 = load ptr, ptr %freq214, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %a216 = load i32, ptr %a, align 4
  %59 = sext i32 %a216 to i64
  %arr.len217 = load i64, ptr %freq215, align 8
  %arr.oob218 = icmp uge i64 %59, %arr.len217
  br i1 %arr.oob218, label %idx.bad219, label %idx.ok220, !prof !10

idx.bad219:                                       ; preds = %idx.ok211
  call void @__polaron_fail(ptr @.fail.2993, ptr @.faila.2994, i64 %59, ptr @.failb.2995, i64 %arr.len217, i32 70)
  unreachable

idx.ok220:                                        ; preds = %idx.ok211
  %arr.data221 = getelementptr i8, ptr %freq215, i64 8
  %arr.elem222 = getelementptr inbounds i32, ptr %arr.data221, i64 %59
  %elem223 = load i32, ptr %arr.elem222, align 4
  %freq224 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 1
  %freq225 = load ptr, ptr %freq224, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %b2226 = load i32, ptr %b2, align 4
  %60 = sext i32 %b2226 to i64
  %arr.len227 = load i64, ptr %freq225, align 8
  %arr.oob228 = icmp uge i64 %60, %arr.len227
  br i1 %arr.oob228, label %idx.bad229, label %idx.ok230, !prof !10

idx.bad229:                                       ; preds = %idx.ok220
  call void @__polaron_fail(ptr @.fail.2996, ptr @.faila.2997, i64 %60, ptr @.failb.2998, i64 %arr.len227, i32 70)
  unreachable

idx.ok230:                                        ; preds = %idx.ok220
  %arr.data231 = getelementptr i8, ptr %freq225, i64 8
  %arr.elem232 = getelementptr inbounds i32, ptr %arr.data231, i64 %60
  %elem233 = load i32, ptr %arr.elem232, align 4
  %61 = add i32 %elem223, %elem233
  store i32 %61, ptr %arr.elem213, align 4
  %left234 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 2
  %left235 = load ptr, ptr %left234, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id236 = load i32, ptr %id204, align 4
  %62 = sext i32 %id236 to i64
  %arr.len237 = load i64, ptr %left235, align 8
  %arr.oob238 = icmp uge i64 %62, %arr.len237
  br i1 %arr.oob238, label %idx.bad239, label %idx.ok240, !prof !10

idx.bad239:                                       ; preds = %idx.ok230
  call void @__polaron_fail(ptr @.fail.2999, ptr @.faila.3000, i64 %62, ptr @.failb.3001, i64 %arr.len237, i32 70)
  unreachable

idx.ok240:                                        ; preds = %idx.ok230
  %arr.data241 = getelementptr i8, ptr %left235, i64 8
  %arr.elem242 = getelementptr inbounds i32, ptr %arr.data241, i64 %62
  %a243 = load i32, ptr %a, align 4
  store i32 %a243, ptr %arr.elem242, align 4
  %right244 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 3
  %right245 = load ptr, ptr %right244, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id246 = load i32, ptr %id204, align 4
  %63 = sext i32 %id246 to i64
  %arr.len247 = load i64, ptr %right245, align 8
  %arr.oob248 = icmp uge i64 %63, %arr.len247
  br i1 %arr.oob248, label %idx.bad249, label %idx.ok250, !prof !10

idx.bad249:                                       ; preds = %idx.ok240
  call void @__polaron_fail(ptr @.fail.3002, ptr @.faila.3003, i64 %63, ptr @.failb.3004, i64 %arr.len247, i32 70)
  unreachable

idx.ok250:                                        ; preds = %idx.ok240
  %arr.data251 = getelementptr i8, ptr %right245, i64 8
  %arr.elem252 = getelementptr inbounds i32, ptr %arr.data251, i64 %63
  %b2253 = load i32, ptr %b2, align 4
  store i32 %b2253, ptr %arr.elem252, align 4
  %sym254 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 6
  %sym255 = load ptr, ptr %sym254, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id256 = load i32, ptr %id204, align 4
  %64 = sext i32 %id256 to i64
  %arr.len257 = load i64, ptr %sym255, align 8
  %arr.oob258 = icmp uge i64 %64, %arr.len257
  br i1 %arr.oob258, label %idx.bad259, label %idx.ok260, !prof !10

idx.bad259:                                       ; preds = %idx.ok250
  call void @__polaron_fail(ptr @.fail.3005, ptr @.faila.3006, i64 %64, ptr @.failb.3007, i64 %arr.len257, i32 70)
  unreachable

idx.ok260:                                        ; preds = %idx.ok250
  %arr.data261 = getelementptr i8, ptr %sym255, i64 8
  %arr.elem262 = getelementptr inbounds i32, ptr %arr.data261, i64 %64
  store i32 -1, ptr %arr.elem262, align 4
  %parent263 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 4
  %parent264 = load ptr, ptr %parent263, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %id265 = load i32, ptr %id204, align 4
  %65 = sext i32 %id265 to i64
  %arr.len266 = load i64, ptr %parent264, align 8
  %arr.oob267 = icmp uge i64 %65, %arr.len266
  br i1 %arr.oob267, label %idx.bad268, label %idx.ok269, !prof !10

idx.bad268:                                       ; preds = %idx.ok260
  call void @__polaron_fail(ptr @.fail.3008, ptr @.faila.3009, i64 %65, ptr @.failb.3010, i64 %arr.len266, i32 70)
  unreachable

idx.ok269:                                        ; preds = %idx.ok260
  %arr.data270 = getelementptr i8, ptr %parent264, i64 8
  %arr.elem271 = getelementptr inbounds i32, ptr %arr.data270, i64 %65
  store i32 -1, ptr %arr.elem271, align 4
  %parent272 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 4
  %parent273 = load ptr, ptr %parent272, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %a274 = load i32, ptr %a, align 4
  %66 = sext i32 %a274 to i64
  %arr.len275 = load i64, ptr %parent273, align 8
  %arr.oob276 = icmp uge i64 %66, %arr.len275
  br i1 %arr.oob276, label %idx.bad277, label %idx.ok278, !prof !10

idx.bad277:                                       ; preds = %idx.ok269
  call void @__polaron_fail(ptr @.fail.3011, ptr @.faila.3012, i64 %66, ptr @.failb.3013, i64 %arr.len275, i32 70)
  unreachable

idx.ok278:                                        ; preds = %idx.ok269
  %arr.data279 = getelementptr i8, ptr %parent273, i64 8
  %arr.elem280 = getelementptr inbounds i32, ptr %arr.data279, i64 %66
  %id281 = load i32, ptr %id204, align 4
  store i32 %id281, ptr %arr.elem280, align 4
  %bit282 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 5
  %bit283 = load ptr, ptr %bit282, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %a284 = load i32, ptr %a, align 4
  %67 = sext i32 %a284 to i64
  %arr.len285 = load i64, ptr %bit283, align 8
  %arr.oob286 = icmp uge i64 %67, %arr.len285
  br i1 %arr.oob286, label %idx.bad287, label %idx.ok288, !prof !10

idx.bad287:                                       ; preds = %idx.ok278
  call void @__polaron_fail(ptr @.fail.3014, ptr @.faila.3015, i64 %67, ptr @.failb.3016, i64 %arr.len285, i32 70)
  unreachable

idx.ok288:                                        ; preds = %idx.ok278
  %arr.data289 = getelementptr i8, ptr %bit283, i64 8
  %arr.elem290 = getelementptr inbounds i32, ptr %arr.data289, i64 %67
  store i32 0, ptr %arr.elem290, align 4
  %parent291 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 4
  %parent292 = load ptr, ptr %parent291, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %b2293 = load i32, ptr %b2, align 4
  %68 = sext i32 %b2293 to i64
  %arr.len294 = load i64, ptr %parent292, align 8
  %arr.oob295 = icmp uge i64 %68, %arr.len294
  br i1 %arr.oob295, label %idx.bad296, label %idx.ok297, !prof !10

idx.bad296:                                       ; preds = %idx.ok288
  call void @__polaron_fail(ptr @.fail.3017, ptr @.faila.3018, i64 %68, ptr @.failb.3019, i64 %arr.len294, i32 70)
  unreachable

idx.ok297:                                        ; preds = %idx.ok288
  %arr.data298 = getelementptr i8, ptr %parent292, i64 8
  %arr.elem299 = getelementptr inbounds i32, ptr %arr.data298, i64 %68
  %id300 = load i32, ptr %id204, align 4
  store i32 %id300, ptr %arr.elem299, align 4
  %bit301 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 5
  %bit302 = load ptr, ptr %bit301, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %b2303 = load i32, ptr %b2, align 4
  %69 = sext i32 %b2303 to i64
  %arr.len304 = load i64, ptr %bit302, align 8
  %arr.oob305 = icmp uge i64 %69, %arr.len304
  br i1 %arr.oob305, label %idx.bad306, label %idx.ok307, !prof !10

idx.bad306:                                       ; preds = %idx.ok297
  call void @__polaron_fail(ptr @.fail.3020, ptr @.faila.3021, i64 %69, ptr @.failb.3022, i64 %arr.len304, i32 70)
  unreachable

idx.ok307:                                        ; preds = %idx.ok297
  %arr.data308 = getelementptr i8, ptr %bit302, i64 8
  %arr.elem309 = getelementptr inbounds i32, ptr %arr.data308, i64 %69
  store i32 1, ptr %arr.elem309, align 4
  %alive310 = load ptr, ptr %alive, align 8, !nonnull !8, !dereferenceable !9
  %a311 = load i32, ptr %a, align 4
  %70 = sext i32 %a311 to i64
  %arr.len312 = load i64, ptr %alive310, align 8
  %arr.oob313 = icmp uge i64 %70, %arr.len312
  br i1 %arr.oob313, label %idx.bad314, label %idx.ok315, !prof !10

idx.bad314:                                       ; preds = %idx.ok307
  call void @__polaron_fail(ptr @.fail.3023, ptr @.faila.3024, i64 %70, ptr @.failb.3025, i64 %arr.len312, i32 70)
  unreachable

idx.ok315:                                        ; preds = %idx.ok307
  %arr.data316 = getelementptr i8, ptr %alive310, i64 8
  %arr.elem317 = getelementptr inbounds i8, ptr %arr.data316, i64 %70
  store i8 0, ptr %arr.elem317, align 1
  %alive318 = load ptr, ptr %alive, align 8, !nonnull !8, !dereferenceable !9
  %b2319 = load i32, ptr %b2, align 4
  %71 = sext i32 %b2319 to i64
  %arr.len320 = load i64, ptr %alive318, align 8
  %arr.oob321 = icmp uge i64 %71, %arr.len320
  br i1 %arr.oob321, label %idx.bad322, label %idx.ok323, !prof !10

idx.bad322:                                       ; preds = %idx.ok315
  call void @__polaron_fail(ptr @.fail.3026, ptr @.faila.3027, i64 %71, ptr @.failb.3028, i64 %arr.len320, i32 70)
  unreachable

idx.ok323:                                        ; preds = %idx.ok315
  %arr.data324 = getelementptr i8, ptr %alive318, i64 8
  %arr.elem325 = getelementptr inbounds i8, ptr %arr.data324, i64 %71
  store i8 0, ptr %arr.elem325, align 1
  %alive326 = load ptr, ptr %alive, align 8, !nonnull !8, !dereferenceable !9
  %id327 = load i32, ptr %id204, align 4
  %72 = sext i32 %id327 to i64
  %arr.len328 = load i64, ptr %alive326, align 8
  %arr.oob329 = icmp uge i64 %72, %arr.len328
  br i1 %arr.oob329, label %idx.bad330, label %idx.ok331, !prof !10

idx.bad330:                                       ; preds = %idx.ok323
  call void @__polaron_fail(ptr @.fail.3029, ptr @.faila.3030, i64 %72, ptr @.failb.3031, i64 %arr.len328, i32 70)
  unreachable

idx.ok331:                                        ; preds = %idx.ok323
  %arr.data332 = getelementptr i8, ptr %alive326, i64 8
  %arr.elem333 = getelementptr inbounds i8, ptr %arr.data332, i64 %72
  store i8 1, ptr %arr.elem333, align 1
  %count334 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 7
  %id335 = load i32, ptr %id204, align 4
  %73 = add i32 %id335, 1
  store i32 %73, ptr %count334, align 4, !tbaa !4
  %root336 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 8
  %id337 = load i32, ptr %id204, align 4
  store i32 %id337, ptr %root336, align 4, !tbaa !4
  %live338 = load i32, ptr %live, align 4
  %74 = sub i32 %live338, 1
  store i32 %74, ptr %live, align 4
  br label %while.cond

for.cond340:                                      ; preds = %for.update342, %while.end
  %i344 = load i32, ptr %i339, align 4
  %count345 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 7
  %count346 = load i32, ptr %count345, align 4, !tbaa !4
  %75 = icmp slt i32 %i344, %count346
  %76 = zext i1 %75 to i32
  br i1 %75, label %for.body341, label %for.end343

for.body341:                                      ; preds = %for.cond340
  %left347 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 2
  %left348 = load ptr, ptr %left347, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i349 = load i32, ptr %i339, align 4
  %77 = sext i32 %i349 to i64
  %arr.len350 = load i64, ptr %left348, align 8
  %arr.oob351 = icmp uge i64 %77, %arr.len350
  br i1 %arr.oob351, label %idx.bad352, label %idx.ok353, !prof !10

for.update342:                                    ; preds = %if.end358
  %78 = load i32, ptr %i339, align 4
  %79 = add i32 %78, 1
  store i32 %79, ptr %i339, align 4
  br label %for.cond340

for.end343:                                       ; preds = %for.cond340
  ret void

idx.bad352:                                       ; preds = %for.body341
  call void @__polaron_fail(ptr @.fail.3032, ptr @.faila.3033, i64 %77, ptr @.failb.3034, i64 %arr.len350, i32 70)
  unreachable

idx.ok353:                                        ; preds = %for.body341
  %arr.data354 = getelementptr i8, ptr %left348, i64 8
  %arr.elem355 = getelementptr inbounds i32, ptr %arr.data354, i64 %77
  %elem356 = load i32, ptr %arr.elem355, align 4
  %80 = icmp eq i32 %elem356, -1
  %81 = zext i1 %80 to i32
  br i1 %80, label %if.then357, label %if.end358

if.then357:                                       ; preds = %idx.ok353
  %arr359 = call ptr @__polaron_malloc(i64 264)
  store i64 64, ptr %arr359, align 8
  %arr.data360 = getelementptr i8, ptr %arr359, i64 8
  %82 = call ptr @memset(ptr %arr.data360, i32 0, i64 256)
  store ptr %arr359, ptr %tmp, align 8
  store i32 0, ptr %d, align 4
  %i361 = load i32, ptr %i339, align 4
  store i32 %i361, ptr %node, align 4
  br label %while.cond362

if.end358:                                        ; preds = %idx.ok444, %idx.ok353
  br label %for.update342

while.cond362:                                    ; preds = %idx.ok400, %if.then357
  %parent365 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 4
  %parent366 = load ptr, ptr %parent365, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %node367 = load i32, ptr %node, align 4
  %83 = sext i32 %node367 to i64
  %arr.len368 = load i64, ptr %parent366, align 8
  %arr.oob369 = icmp uge i64 %83, %arr.len368
  br i1 %arr.oob369, label %idx.bad370, label %idx.ok371, !prof !10

while.body363:                                    ; preds = %idx.ok371
  %tmp375 = load ptr, ptr %tmp, align 8, !nonnull !8, !dereferenceable !9
  %d376 = load i32, ptr %d, align 4
  %84 = sext i32 %d376 to i64
  %arr.len377 = load i64, ptr %tmp375, align 8
  %arr.oob378 = icmp uge i64 %84, %arr.len377
  br i1 %arr.oob378, label %idx.bad379, label %idx.ok380, !prof !10

while.end364:                                     ; preds = %idx.ok371
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %d404 = load i32, ptr %d, align 4
  %85 = icmp eq i32 %d404, 0
  %86 = zext i1 %85 to i32
  br i1 %85, label %if.then405, label %if.end406

idx.bad370:                                       ; preds = %while.cond362
  call void @__polaron_fail(ptr @.fail.3035, ptr @.faila.3036, i64 %83, ptr @.failb.3037, i64 %arr.len368, i32 70)
  unreachable

idx.ok371:                                        ; preds = %while.cond362
  %arr.data372 = getelementptr i8, ptr %parent366, i64 8
  %arr.elem373 = getelementptr inbounds i32, ptr %arr.data372, i64 %83
  %elem374 = load i32, ptr %arr.elem373, align 4
  %87 = icmp ne i32 %elem374, -1
  %88 = zext i1 %87 to i32
  br i1 %87, label %while.body363, label %while.end364

idx.bad379:                                       ; preds = %while.body363
  call void @__polaron_fail(ptr @.fail.3038, ptr @.faila.3039, i64 %84, ptr @.failb.3040, i64 %arr.len377, i32 70)
  unreachable

idx.ok380:                                        ; preds = %while.body363
  %arr.data381 = getelementptr i8, ptr %tmp375, i64 8
  %arr.elem382 = getelementptr inbounds i32, ptr %arr.data381, i64 %84
  %bit383 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 5
  %bit384 = load ptr, ptr %bit383, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %node385 = load i32, ptr %node, align 4
  %89 = sext i32 %node385 to i64
  %arr.len386 = load i64, ptr %bit384, align 8
  %arr.oob387 = icmp uge i64 %89, %arr.len386
  br i1 %arr.oob387, label %idx.bad388, label %idx.ok389, !prof !10

idx.bad388:                                       ; preds = %idx.ok380
  call void @__polaron_fail(ptr @.fail.3041, ptr @.faila.3042, i64 %89, ptr @.failb.3043, i64 %arr.len386, i32 70)
  unreachable

idx.ok389:                                        ; preds = %idx.ok380
  %arr.data390 = getelementptr i8, ptr %bit384, i64 8
  %arr.elem391 = getelementptr inbounds i32, ptr %arr.data390, i64 %89
  %elem392 = load i32, ptr %arr.elem391, align 4
  store i32 %elem392, ptr %arr.elem382, align 4
  %d393 = load i32, ptr %d, align 4
  %90 = add i32 %d393, 1
  store i32 %90, ptr %d, align 4
  %parent394 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 4
  %parent395 = load ptr, ptr %parent394, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %node396 = load i32, ptr %node, align 4
  %91 = sext i32 %node396 to i64
  %arr.len397 = load i64, ptr %parent395, align 8
  %arr.oob398 = icmp uge i64 %91, %arr.len397
  br i1 %arr.oob398, label %idx.bad399, label %idx.ok400, !prof !10

idx.bad399:                                       ; preds = %idx.ok389
  call void @__polaron_fail(ptr @.fail.3044, ptr @.faila.3045, i64 %91, ptr @.failb.3046, i64 %arr.len397, i32 70)
  unreachable

idx.ok400:                                        ; preds = %idx.ok389
  %arr.data401 = getelementptr i8, ptr %parent395, i64 8
  %arr.elem402 = getelementptr inbounds i32, ptr %arr.data401, i64 %91
  %elem403 = load i32, ptr %arr.elem402, align 4
  store i32 %elem403, ptr %node, align 4
  br label %while.cond362

if.then405:                                       ; preds = %while.end364
  %sb407 = load ptr, ptr %sb, align 8
  %92 = call ptr @StringBuilder.appendChar(ptr %sb407, i32 48)
  br label %if.end406

if.end406:                                        ; preds = %if.then405, %while.end364
  %d408 = load i32, ptr %d, align 4
  %93 = sub i32 %d408, 1
  store i32 %93, ptr %j, align 4
  br label %for.cond409

for.cond409:                                      ; preds = %for.update411, %if.end406
  %j413 = load i32, ptr %j, align 4
  %94 = icmp sge i32 %j413, 0
  %95 = zext i1 %94 to i32
  br i1 %94, label %for.body410, label %for.end412

for.body410:                                      ; preds = %for.cond409
  %tmp414 = load ptr, ptr %tmp, align 8, !nonnull !8, !dereferenceable !9
  %j415 = load i32, ptr %j, align 4
  %96 = sext i32 %j415 to i64
  %arr.len416 = load i64, ptr %tmp414, align 8
  %arr.oob417 = icmp uge i64 %96, %arr.len416
  br i1 %arr.oob417, label %idx.bad418, label %idx.ok419, !prof !10

for.update411:                                    ; preds = %if.end425
  %j428 = load i32, ptr %j, align 4
  %97 = sub i32 %j428, 1
  store i32 %97, ptr %j, align 4
  br label %for.cond409

for.end412:                                       ; preds = %for.cond409
  %codes429 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 9
  %codes430 = load ptr, ptr %codes429, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %sym431 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 6
  %sym432 = load ptr, ptr %sym431, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i433 = load i32, ptr %i339, align 4
  %98 = sext i32 %i433 to i64
  %arr.len434 = load i64, ptr %sym432, align 8
  %arr.oob435 = icmp uge i64 %98, %arr.len434
  br i1 %arr.oob435, label %idx.bad436, label %idx.ok437, !prof !10

idx.bad418:                                       ; preds = %for.body410
  call void @__polaron_fail(ptr @.fail.3047, ptr @.faila.3048, i64 %96, ptr @.failb.3049, i64 %arr.len416, i32 70)
  unreachable

idx.ok419:                                        ; preds = %for.body410
  %arr.data420 = getelementptr i8, ptr %tmp414, i64 8
  %arr.elem421 = getelementptr inbounds i32, ptr %arr.data420, i64 %96
  %elem422 = load i32, ptr %arr.elem421, align 4
  %99 = icmp eq i32 %elem422, 0
  %100 = zext i1 %99 to i32
  br i1 %99, label %if.then423, label %if.else424

if.then423:                                       ; preds = %idx.ok419
  %sb426 = load ptr, ptr %sb, align 8
  %101 = call ptr @StringBuilder.appendChar(ptr %sb426, i32 48)
  br label %if.end425

if.else424:                                       ; preds = %idx.ok419
  %sb427 = load ptr, ptr %sb, align 8
  %102 = call ptr @StringBuilder.appendChar(ptr %sb427, i32 49)
  br label %if.end425

if.end425:                                        ; preds = %if.else424, %if.then423
  br label %for.update411

idx.bad436:                                       ; preds = %for.end412
  call void @__polaron_fail(ptr @.fail.3050, ptr @.faila.3051, i64 %98, ptr @.failb.3052, i64 %arr.len434, i32 70)
  unreachable

idx.ok437:                                        ; preds = %for.end412
  %arr.data438 = getelementptr i8, ptr %sym432, i64 8
  %arr.elem439 = getelementptr inbounds i32, ptr %arr.data438, i64 %98
  %elem440 = load i32, ptr %arr.elem439, align 4
  %103 = sext i32 %elem440 to i64
  %arr.len441 = load i64, ptr %codes430, align 8
  %arr.oob442 = icmp uge i64 %103, %arr.len441
  br i1 %arr.oob442, label %idx.bad443, label %idx.ok444, !prof !10

idx.bad443:                                       ; preds = %idx.ok437
  call void @__polaron_fail(ptr @.fail.3053, ptr @.faila.3054, i64 %103, ptr @.failb.3055, i64 %arr.len441, i32 70)
  unreachable

idx.ok444:                                        ; preds = %idx.ok437
  %arr.data445 = getelementptr i8, ptr %codes430, i64 8
  %arr.elem446 = getelementptr inbounds ptr, ptr %arr.data445, i64 %103
  %sb447 = load ptr, ptr %sb, align 8
  %104 = call ptr @StringBuilder.toString(ptr %sb447)
  %strcpy = call ptr @__polaron_str_copy(ptr %104)
  %105 = load ptr, ptr %arr.elem446, align 8
  call void @__polaron_str_free(ptr %105)
  store ptr %strcpy, ptr %arr.elem446, align 8
  call void @__polaron_str_free(ptr %104)
  br label %if.end358
}

define internal ptr @Huffman.codeOf(ptr nonnull align 8 dereferenceable(72) %0, i32 %1) {
entry:
  %byteValue = alloca i32, align 4
  store i32 %1, ptr %byteValue, align 4
  %codes = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 9
  %codes1 = load ptr, ptr %codes, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %byteValue2 = load i32, ptr %byteValue, align 4
  %2 = and i32 %byteValue2, 255
  %3 = sext i32 %2 to i64
  %arr.len = load i64, ptr %codes1, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3056, ptr @.faila.3057, i64 %3, ptr @.failb.3058, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %codes1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %3
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy
}

define internal ptr @Huffman.encode(ptr nonnull align 8 dereferenceable(72) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %sb = alloca ptr, align 8
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %data1 = load ptr, ptr %data, align 8
  %str.len = getelementptr inbounds %String, ptr %data1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %n3 = load i32, ptr %n, align 4
  %3 = icmp slt i32 %i2, %n3
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sb4 = load ptr, ptr %sb, align 8
  %codes = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 9
  %codes5 = load ptr, ptr %codes, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %data6 = load ptr, ptr %data, align 8
  %i7 = load i32, ptr %i, align 4
  %5 = sext i32 %i7 to i64
  %str.data = getelementptr inbounds %String, ptr %data6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data8, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = and i32 %6, 255
  %8 = sext i32 %7 to i64
  %arr.len = load i64, ptr %codes5, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb9 = load ptr, ptr %sb, align 8
  %11 = call ptr @StringBuilder.toString(ptr %sb9)
  %strcpy = call ptr @__polaron_str_copy(ptr %11)
  call void @__polaron_str_free(ptr %11)
  ret ptr %strcpy

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3059, ptr @.faila.3060, i64 %8, ptr @.failb.3061, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %codes5, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %8
  %elem = load ptr, ptr %arr.elem, align 8
  %12 = call ptr @StringBuilder.append(ptr %sb4, ptr %elem)
  br label %for.update
}

define internal ptr @Huffman.decode(ptr nonnull align 8 dereferenceable(72) %0, ptr %1) {
entry:
  %i20 = alloca i32, align 4
  %node = alloca i32, align 4
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %sb = alloca ptr, align 8
  %bits = alloca ptr, align 8
  store ptr %1, ptr %bits, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %bits1 = load ptr, ptr %bits, align 8
  %str.len = getelementptr inbounds %String, ptr %bits1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %left = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %root = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 8
  %root3 = load i32, ptr %root, align 4, !tbaa !4
  %3 = sext i32 %root3 to i64
  %arr.len = load i64, ptr %left2, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3062, ptr @.faila.3063, i64 %3, ptr @.failb.3064, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %left2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %3
  %elem = load i32, ptr %arr.elem, align 4
  %4 = icmp eq i32 %elem, -1
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  store i32 0, ptr %i, align 4
  br label %for.cond

if.end:                                           ; preds = %idx.ok
  %root18 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 8
  %root19 = load i32, ptr %root18, align 4, !tbaa !4
  store i32 %root19, ptr %node, align 4
  store i32 0, ptr %i20, align 4
  br label %for.cond21

for.cond:                                         ; preds = %for.update, %if.then
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %6 = icmp slt i32 %i4, %n5
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sb6 = load ptr, ptr %sb, align 8
  %sym = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 6
  %sym7 = load ptr, ptr %sym, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %root8 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 8
  %root9 = load i32, ptr %root8, align 4, !tbaa !4
  %8 = sext i32 %root9 to i64
  %arr.len10 = load i64, ptr %sym7, align 8
  %arr.oob11 = icmp uge i64 %8, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !10

for.update:                                       ; preds = %idx.ok13
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb17 = load ptr, ptr %sb, align 8
  %11 = call ptr @StringBuilder.toString(ptr %sb17)
  %strcpy = call ptr @__polaron_str_copy(ptr %11)
  call void @__polaron_str_free(ptr %11)
  ret ptr %strcpy

idx.bad12:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3065, ptr @.faila.3066, i64 %8, ptr @.failb.3067, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %for.body
  %arr.data14 = getelementptr i8, ptr %sym7, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %8
  %elem16 = load i32, ptr %arr.elem15, align 4
  %12 = call ptr @StringBuilder.appendChar(ptr %sb6, i32 %elem16)
  br label %for.update

for.cond21:                                       ; preds = %for.update23, %if.end
  %i25 = load i32, ptr %i20, align 4
  %n26 = load i32, ptr %n, align 4
  %13 = icmp slt i32 %i25, %n26
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body22, label %for.end24

for.body22:                                       ; preds = %for.cond21
  %bits27 = load ptr, ptr %bits, align 8
  %i28 = load i32, ptr %i20, align 4
  %15 = sext i32 %i28 to i64
  %str.data = getelementptr inbounds %String, ptr %bits27, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %15
  %ch = load i8, ptr %ch.addr, align 1
  %16 = zext i8 %ch to i32
  %17 = icmp eq i32 %16, 48
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then29, label %if.else

for.update23:                                     ; preds = %if.end61
  %19 = load i32, ptr %i20, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %i20, align 4
  br label %for.cond21

for.end24:                                        ; preds = %for.cond21
  %sb75 = load ptr, ptr %sb, align 8
  %21 = call ptr @StringBuilder.toString(ptr %sb75)
  %strcpy76 = call ptr @__polaron_str_copy(ptr %21)
  call void @__polaron_str_free(ptr %21)
  ret ptr %strcpy76

if.then29:                                        ; preds = %for.body22
  %left31 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 2
  %left32 = load ptr, ptr %left31, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %node33 = load i32, ptr %node, align 4
  %22 = sext i32 %node33 to i64
  %arr.len34 = load i64, ptr %left32, align 8
  %arr.oob35 = icmp uge i64 %22, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !10

if.else:                                          ; preds = %for.body22
  %right = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 3
  %right41 = load ptr, ptr %right, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %node42 = load i32, ptr %node, align 4
  %23 = sext i32 %node42 to i64
  %arr.len43 = load i64, ptr %right41, align 8
  %arr.oob44 = icmp uge i64 %23, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !10

if.end30:                                         ; preds = %idx.ok46, %idx.ok37
  %left50 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 2
  %left51 = load ptr, ptr %left50, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %node52 = load i32, ptr %node, align 4
  %24 = sext i32 %node52 to i64
  %arr.len53 = load i64, ptr %left51, align 8
  %arr.oob54 = icmp uge i64 %24, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !10

idx.bad36:                                        ; preds = %if.then29
  call void @__polaron_fail(ptr @.fail.3068, ptr @.faila.3069, i64 %22, ptr @.failb.3070, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %if.then29
  %arr.data38 = getelementptr i8, ptr %left32, i64 8
  %arr.elem39 = getelementptr inbounds i32, ptr %arr.data38, i64 %22
  %elem40 = load i32, ptr %arr.elem39, align 4
  store i32 %elem40, ptr %node, align 4
  br label %if.end30

idx.bad45:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.3071, ptr @.faila.3072, i64 %23, ptr @.failb.3073, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %if.else
  %arr.data47 = getelementptr i8, ptr %right41, i64 8
  %arr.elem48 = getelementptr inbounds i32, ptr %arr.data47, i64 %23
  %elem49 = load i32, ptr %arr.elem48, align 4
  store i32 %elem49, ptr %node, align 4
  br label %if.end30

idx.bad55:                                        ; preds = %if.end30
  call void @__polaron_fail(ptr @.fail.3074, ptr @.faila.3075, i64 %24, ptr @.failb.3076, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %if.end30
  %arr.data57 = getelementptr i8, ptr %left51, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 %24
  %elem59 = load i32, ptr %arr.elem58, align 4
  %25 = icmp eq i32 %elem59, -1
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then60, label %if.end61

if.then60:                                        ; preds = %idx.ok56
  %sb62 = load ptr, ptr %sb, align 8
  %sym63 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 6
  %sym64 = load ptr, ptr %sym63, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %node65 = load i32, ptr %node, align 4
  %27 = sext i32 %node65 to i64
  %arr.len66 = load i64, ptr %sym64, align 8
  %arr.oob67 = icmp uge i64 %27, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !10

if.end61:                                         ; preds = %idx.ok69, %idx.ok56
  br label %for.update23

idx.bad68:                                        ; preds = %if.then60
  call void @__polaron_fail(ptr @.fail.3077, ptr @.faila.3078, i64 %27, ptr @.failb.3079, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %if.then60
  %arr.data70 = getelementptr i8, ptr %sym64, i64 8
  %arr.elem71 = getelementptr inbounds i32, ptr %arr.data70, i64 %27
  %elem72 = load i32, ptr %arr.elem71, align 4
  %28 = call ptr @StringBuilder.appendChar(ptr %sb62, i32 %elem72)
  %root73 = getelementptr inbounds %class.Huffman, ptr %0, i32 0, i32 8
  %root74 = load i32, ptr %root73, align 4, !tbaa !4
  store i32 %root74, ptr %node, align 4
  br label %if.end61
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5309)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5311)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @strcmp(ptr, ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

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
