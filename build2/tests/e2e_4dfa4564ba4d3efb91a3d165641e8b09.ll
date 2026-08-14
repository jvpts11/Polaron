; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sieve_bloom_deque.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sieve_bloom_deque.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Sieve = type { ptr, ptr, i32 }
%class.BloomFilter = type { ptr, ptr, i32 }
%"class.Deque$int" = type { ptr, ptr, i32, i32 }
%class.DivideByZeroException = type { ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@BloomFilter.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BloomFilter.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BloomFilter.idx, ptr @BloomFilter.mightContain, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Deque$int.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr @"Deque$int.toArray", ptr @"Deque$int.size", ptr @"Deque$int.isEmpty", ptr null, ptr @"Deque$int.grow", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Deque$int.addLast", ptr @"Deque$int.addFirst", ptr @"Deque$int.removeFirst", ptr @"Deque$int.removeLast", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Deque$int.~Deque$int"]
@Object.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Sieve.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Sieve.count, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Sieve.isPrime, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [4 x i8] c"cat\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c"dog\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.fail = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sieve_bloom_deque.pol:24:17  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [63 x i8] c"p2=%d p15=%d cnt=%d cat=%d fish=%d pf=%d pb=%d front=%d sz=%d\0A\00", align 1
@.strdata.3 = private constant [4 x i8] c"cat\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [5 x i8] c"fish\00"
@.strobj.6 = private global %String { i64 4, ptr @.strdata.5, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.fail.681 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:749:31  in Deque$int.grow\0A\00", align 1
@.faila.682 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.683 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.684 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:749:31  in Deque$int.grow\0A\00", align 1
@.faila.685 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.686 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.687 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:757:74  in Deque$int.addLast\0A\00", align 1
@.faila.688 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.689 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.690 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:763:38  in Deque$int.addFirst\0A\00", align 1
@.faila.691 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.692 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.693 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:767:17  in Deque$int.removeFirst\0A\00", align 1
@.faila.694 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.695 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.696 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:774:17  in Deque$int.removeLast\0A\00", align 1
@.faila.697 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.698 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.699 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:779:28  in Deque$int.toArray\0A\00", align 1
@.faila.700 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.701 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.702 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:779:28  in Deque$int.toArray\0A\00", align 1
@.faila.703 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.704 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1339 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1340 = private global %String { i64 16, ptr @.strdata.1339, i64 0 }
@.strdata.1341 = private constant [17 x i8] c"division by zero\00"
@.strobj.1342 = private global %String { i64 16, ptr @.strdata.1341, i64 0 }
@.fail.1891 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2489:56  in BloomFilter.add\0A\00", align 1
@.faila.1892 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1893 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1894 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2490:56  in BloomFilter.add\0A\00", align 1
@.faila.1895 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1896 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1897 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2494:17  in BloomFilter.mightContain\0A\00", align 1
@.faila.1898 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1899 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1900 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2494:17  in BloomFilter.mightContain\0A\00", align 1
@.faila.1901 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1902 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3424 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5806:21  in Sieve.Sieve\0A\00", align 1
@.faila.3425 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3426 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3427 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5807:96  in Sieve.Sieve\0A\00", align 1
@.faila.3428 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3429 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3430 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5813:17  in Sieve.isPrime\0A\00", align 1
@.faila.3431 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3432 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3433 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5818:21  in Sieve.count\0A\00", align 1
@.faila.3434 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3435 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5340 = private constant [1 x i8] zeroinitializer
@.strobj.5341 = private global %String { i64 0, ptr @.strdata.5340, i64 0 }
@.strdata.5342 = private constant [1 x i8] zeroinitializer
@.strobj.5343 = private global %String { i64 0, ptr @.strdata.5342, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %front = alloca i32, align 4
  %pb = alloca i32, align 4
  %pf = alloca i32, align 4
  %dq = alloca ptr, align 8
  %bf = alloca ptr, align 8
  %si = alloca ptr, align 8
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
  %Sieve.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Sieve, ptr null, i64 1) to i64))
  call void @Sieve.Sieve(ptr %Sieve.obj, i32 30)
  store ptr %Sieve.obj, ptr %si, align 8
  %BloomFilter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BloomFilter, ptr null, i64 1) to i64))
  call void @BloomFilter.BloomFilter(ptr %BloomFilter.obj, i32 256)
  store ptr %BloomFilter.obj, ptr %bf, align 8
  %bf1 = load ptr, ptr %bf, align 8
  call void @BloomFilter.add(ptr %bf1, ptr @.strobj)
  %bf2 = load ptr, ptr %bf, align 8
  call void @BloomFilter.add(ptr %bf2, ptr @.strobj.2)
  %"Deque$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Deque$int", ptr null, i64 1) to i64))
  call void @"Deque$int.Deque$int"(ptr %"Deque$int.obj")
  store ptr %"Deque$int.obj", ptr %dq, align 8
  %dq3 = load ptr, ptr %dq, align 8
  call void @"Deque$int.addLast"(ptr %dq3, i32 1)
  %dq4 = load ptr, ptr %dq, align 8
  call void @"Deque$int.addLast"(ptr %dq4, i32 2)
  %dq5 = load ptr, ptr %dq, align 8
  call void @"Deque$int.addFirst"(ptr %dq5, i32 0)
  %dq6 = load ptr, ptr %dq, align 8
  %16 = call i32 @"Deque$int.removeFirst"(ptr %dq6)
  store i32 %16, ptr %pf, align 4
  %dq7 = load ptr, ptr %dq, align 8
  %17 = call i32 @"Deque$int.removeLast"(ptr %dq7)
  store i32 %17, ptr %pb, align 4
  %dq8 = load ptr, ptr %dq, align 8
  %18 = call ptr @"Deque$int.toArray"(ptr %dq8)
  %arr.len = load i64, ptr %18, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data9 = getelementptr i8, ptr %18, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %front, align 4
  %si10 = load ptr, ptr %si, align 8
  %19 = call i32 @Sieve.isPrime(ptr %si10, i32 2)
  %si11 = load ptr, ptr %si, align 8
  %20 = call i32 @Sieve.isPrime(ptr %si11, i32 15)
  %si12 = load ptr, ptr %si, align 8
  %21 = call i32 @Sieve.count(ptr %si12)
  %bf13 = load ptr, ptr %bf, align 8
  %22 = call i32 @BloomFilter.mightContain(ptr %bf13, ptr @.strobj.4)
  %bf14 = load ptr, ptr %bf, align 8
  %23 = call i32 @BloomFilter.mightContain(ptr %bf14, ptr @.strobj.6)
  %pf15 = load i32, ptr %pf, align 4
  %pb16 = load i32, ptr %pb, align 4
  %front17 = load i32, ptr %front, align 4
  %dq18 = load ptr, ptr %dq, align 8
  %24 = call i32 @"Deque$int.size"(ptr %dq18)
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %19, i32 %20, i32 %21, i32 %22, i32 %23, i32 %pf15, i32 %pb16, i32 %front17, i32 %24)
  ret i32 0
}

define internal void @"Deque$int.Deque$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 0
  store ptr @"Deque$int.vtable", ptr %vtbl.addr, align 8, !tbaa !1
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !1
  %data1 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 16)
  store ptr %arr, ptr %data1, align 8, !tbaa !1
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %head, align 4, !tbaa !5
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !5
  ret void
}

define internal void @"Deque$int.~Deque$int"(ptr %0) {
entry:
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !1
  call void @__polaron_free(ptr %data1)
  ret void
}

define internal void @"Deque$int.grow"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !5
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data2 = load ptr, ptr %data, align 8, !tbaa !1
  %len = load i64, ptr %data2, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %count1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %data3 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data3, align 8, !tbaa !1
  %len5 = load i64, ptr %data4, align 8
  %4 = trunc i64 %len5 to i32
  %5 = mul i32 %4, 2
  %6 = sext i32 %5 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %9 = call ptr @memset(ptr %arr.data, i32 0, i64 %7)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count8 = load i32, ptr %count7, align 4, !tbaa !5
  %10 = icmp slt i32 %i6, %count8
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger9 = load ptr, ptr %bigger, align 8, !nonnull !7, !dereferenceable !8
  %i10 = load i32, ptr %i, align 4
  %12 = sext i32 %i10 to i64
  %arr.len = load i64, ptr %bigger9, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

for.update:                                       ; preds = %idx.ok22
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data25 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data26 = load ptr, ptr %data25, align 8, !tbaa !1
  call void @__polaron_free(ptr %data26)
  %data27 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %bigger28 = load ptr, ptr %bigger, align 8
  store ptr %bigger28, ptr %data27, align 8, !tbaa !1
  %head29 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %head29, align 4, !tbaa !5
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.681, ptr @.faila.682, i64 %12, ptr @.failb.683, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %bigger9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 %12
  %data12 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head14 = load i32, ptr %head, align 4, !tbaa !5
  %i15 = load i32, ptr %i, align 4
  %15 = add i32 %head14, %i15
  %data16 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data17 = load ptr, ptr %data16, align 8, !tbaa !1
  %len18 = load i64, ptr %data17, align 8
  %16 = trunc i64 %len18 to i32
  %17 = icmp eq i32 %16, 0
  %18 = icmp eq i32 %15, -2147483648
  %19 = icmp eq i32 %16, -1
  %20 = and i1 %18, %19
  %21 = or i1 %17, %20
  br i1 %21, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %22 = srem i32 %15, %16
  %23 = sext i32 %22 to i64
  %arr.len19 = load i64, ptr %data13, align 8
  %arr.oob20 = icmp uge i64 %23, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !0

idx.bad21:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.684, ptr @.faila.685, i64 %23, ptr @.failb.686, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %div.ok
  %arr.data23 = getelementptr i8, ptr %data13, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %23
  %elem = load i32, ptr %arr.elem24, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @"Deque$int.addLast"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  call void @"Deque$int.grow"(ptr %0)
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head2 = load i32, ptr %head, align 4, !tbaa !5
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count, align 4, !tbaa !5
  %2 = add i32 %head2, %count3
  %data4 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data5 = load ptr, ptr %data4, align 8, !tbaa !1
  %len = load i64, ptr %data5, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp eq i32 %3, 0
  %5 = icmp eq i32 %2, -2147483648
  %6 = icmp eq i32 %3, -1
  %7 = and i1 %5, %6
  %8 = or i1 %4, %7
  br i1 %8, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %9 = srem i32 %2, %3
  %10 = sext i32 %9 to i64
  %arr.len = load i64, ptr %data1, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.687, ptr @.faila.688, i64 %10, ptr @.failb.689, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %item6 = load i32, ptr %item, align 4
  store i32 %item6, ptr %arr.elem, align 4
  %count7 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count8 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count9 = load i32, ptr %count8, align 4, !tbaa !5
  %11 = add i32 %count9, 1
  store i32 %11, ptr %count7, align 4, !tbaa !5
  ret void
}

define internal void @"Deque$int.addFirst"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  call void @"Deque$int.grow"(ptr %0)
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head1 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head2 = load i32, ptr %head1, align 4, !tbaa !5
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data3 = load ptr, ptr %data, align 8, !tbaa !1
  %len = load i64, ptr %data3, align 8
  %2 = trunc i64 %len to i32
  %3 = add i32 %head2, %2
  %4 = sub i32 %3, 1
  %data4 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data5 = load ptr, ptr %data4, align 8, !tbaa !1
  %len6 = load i64, ptr %data5, align 8
  %5 = trunc i64 %len6 to i32
  %6 = icmp eq i32 %5, 0
  %7 = icmp eq i32 %4, -2147483648
  %8 = icmp eq i32 %5, -1
  %9 = and i1 %7, %8
  %10 = or i1 %6, %9
  br i1 %10, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %11 = srem i32 %4, %5
  store i32 %11, ptr %head, align 4, !tbaa !5
  %data7 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data7, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %head9 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head10 = load i32, ptr %head9, align 4, !tbaa !5
  %12 = sext i32 %head10 to i64
  %arr.len = load i64, ptr %data8, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.690, ptr @.faila.691, i64 %12, ptr @.failb.692, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %data8, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %12
  %item11 = load i32, ptr %item, align 4
  store i32 %item11, ptr %arr.elem, align 4
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count12 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count13 = load i32, ptr %count12, align 4, !tbaa !5
  %13 = add i32 %count13, 1
  store i32 %13, ptr %count, align 4, !tbaa !5
  ret void
}

define internal i32 @"Deque$int.removeFirst"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %v = alloca i32, align 4
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head2 = load i32, ptr %head, align 4, !tbaa !5
  %1 = sext i32 %head2 to i64
  %arr.len = load i64, ptr %data1, align 8
  %arr.oob = icmp uge i64 %1, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.693, ptr @.faila.694, i64 %1, ptr @.failb.695, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %1
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %v, align 4
  %head3 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head4 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head5 = load i32, ptr %head4, align 4, !tbaa !5
  %2 = add i32 %head5, 1
  %data6 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data7 = load ptr, ptr %data6, align 8, !tbaa !1
  %len = load i64, ptr %data7, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp eq i32 %3, 0
  %5 = icmp eq i32 %2, -2147483648
  %6 = icmp eq i32 %3, -1
  %7 = and i1 %5, %6
  %8 = or i1 %4, %7
  br i1 %8, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %9 = srem i32 %2, %3
  store i32 %9, ptr %head3, align 4, !tbaa !5
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count8 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count9 = load i32, ptr %count8, align 4, !tbaa !5
  %10 = sub i32 %count9, 1
  store i32 %10, ptr %count, align 4, !tbaa !5
  %v10 = load i32, ptr %v, align 4
  ret i32 %v10
}

define internal i32 @"Deque$int.removeLast"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count1 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count2 = load i32, ptr %count1, align 4, !tbaa !5
  %1 = sub i32 %count2, 1
  store i32 %1, ptr %count, align 4, !tbaa !5
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data3 = load ptr, ptr %data, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head4 = load i32, ptr %head, align 4, !tbaa !5
  %count5 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count6 = load i32, ptr %count5, align 4, !tbaa !5
  %2 = add i32 %head4, %count6
  %data7 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data7, align 8, !tbaa !1
  %len = load i64, ptr %data8, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp eq i32 %3, 0
  %5 = icmp eq i32 %2, -2147483648
  %6 = icmp eq i32 %3, -1
  %7 = and i1 %5, %6
  %8 = or i1 %4, %7
  br i1 %8, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %9 = srem i32 %2, %3
  %10 = sext i32 %9 to i64
  %arr.len = load i64, ptr %data3, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.696, ptr @.faila.697, i64 %10, ptr @.failb.698, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %data3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal ptr @"Deque$int.toArray"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !5
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %count3 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count4 = load i32, ptr %count3, align 4, !tbaa !5
  %5 = icmp slt i32 %i2, %count4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out5 = load ptr, ptr %out, align 8, !nonnull !7, !dereferenceable !8
  %i6 = load i32, ptr %i, align 4
  %7 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %out5, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

for.update:                                       ; preds = %idx.ok16
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out19 = load ptr, ptr %out, align 8
  ret ptr %out19

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.699, ptr @.faila.700, i64 %7, ptr @.failb.701, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %out5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data7, i64 %7
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head, align 4, !tbaa !5
  %i10 = load i32, ptr %i, align 4
  %10 = add i32 %head9, %i10
  %data11 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data12 = load ptr, ptr %data11, align 8, !tbaa !1
  %len = load i64, ptr %data12, align 8
  %11 = trunc i64 %len to i32
  %12 = icmp eq i32 %11, 0
  %13 = icmp eq i32 %10, -2147483648
  %14 = icmp eq i32 %11, -1
  %15 = and i1 %13, %14
  %16 = or i1 %12, %15
  br i1 %16, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %17 = srem i32 %10, %11
  %18 = sext i32 %17 to i64
  %arr.len13 = load i64, ptr %data8, align 8
  %arr.oob14 = icmp uge i64 %18, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !0

idx.bad15:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.702, ptr @.faila.703, i64 %18, ptr @.failb.704, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %div.ok
  %arr.data17 = getelementptr i8, ptr %data8, i64 8
  %arr.elem18 = getelementptr inbounds i32, ptr %arr.data17, i64 %18
  %elem = load i32, ptr %arr.elem18, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @"Deque$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !5
  ret i32 %count1
}

define internal i32 @"Deque$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !5
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !1
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
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !1
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1340)
  ret ptr %strcpy
}

define internal void @DivideByZeroException.DivideByZeroException(ptr %0) {
entry:
  call void @ArithmeticException.ArithmeticException(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DivideByZeroException, ptr %0, i32 0, i32 0
  store ptr @DivideByZeroException.vtable, ptr %vtbl.addr, align 8, !tbaa !1
  ret void
}

define internal ptr @DivideByZeroException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1342)
  ret ptr %strcpy
}

define internal void @BloomFilter.BloomFilter(ptr %0, i32 %1) {
entry:
  %size = alloca i32, align 4
  store i32 %1, ptr %size, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 0
  store ptr @BloomFilter.vtable, ptr %vtbl.addr, align 8, !tbaa !1
  %bits = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 1
  store ptr null, ptr %bits, align 8, !tbaa !1
  %m = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 2
  %size1 = load i32, ptr %size, align 4
  store i32 %size1, ptr %m, align 4, !tbaa !5
  %bits2 = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 1
  %size3 = load i32, ptr %size, align 4
  %2 = sext i32 %size3 to i64
  %3 = mul i64 %2, 1
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %bits2, align 8, !tbaa !1
  ret void
}

define internal i32 @BloomFilter.idx(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %r = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %h = alloca i32, align 4
  store i32 %1, ptr %h, align 4
  %h1 = load i32, ptr %h, align 4
  %m = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 2
  %m2 = load i32, ptr %m, align 4, !tbaa !5
  %2 = icmp eq i32 %m2, 0
  %3 = icmp eq i32 %h1, -2147483648
  %4 = icmp eq i32 %m2, -1
  %5 = and i1 %3, %4
  %6 = or i1 %2, %5
  br i1 %6, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %7 = srem i32 %h1, %m2
  store i32 %7, ptr %r, align 4
  %r3 = load i32, ptr %r, align 4
  %8 = icmp slt i32 %r3, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %div.ok
  %r4 = load i32, ptr %r, align 4
  %m5 = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 2
  %m6 = load i32, ptr %m5, align 4, !tbaa !5
  %10 = add i32 %r4, %m6
  ret i32 %10

if.end:                                           ; preds = %div.ok
  %r7 = load i32, ptr %r, align 4
  ret i32 %r7
}

define internal void @BloomFilter.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %bits = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 1
  %bits1 = load ptr, ptr %bits, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %key2 = load ptr, ptr %key, align 8
  %2 = call i32 @Digest.fnv1a(ptr %key2)
  %3 = call i32 @BloomFilter.idx(ptr %0, i32 %2)
  %4 = sext i32 %3 to i64
  %arr.len = load i64, ptr %bits1, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1891, ptr @.faila.1892, i64 %4, ptr @.failb.1893, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %bits1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %4
  store i8 1, ptr %arr.elem, align 1
  %bits3 = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 1
  %bits4 = load ptr, ptr %bits3, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %key5 = load ptr, ptr %key, align 8
  %5 = call i32 @Digest.crc32(ptr %key5)
  %6 = call i32 @BloomFilter.idx(ptr %0, i32 %5)
  %7 = sext i32 %6 to i64
  %arr.len6 = load i64, ptr %bits4, align 8
  %arr.oob7 = icmp uge i64 %7, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !0

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1894, ptr @.faila.1895, i64 %7, ptr @.failb.1896, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %bits4, i64 8
  %arr.elem11 = getelementptr inbounds i8, ptr %arr.data10, i64 %7
  store i8 1, ptr %arr.elem11, align 1
  ret void
}

define internal i32 @BloomFilter.mightContain(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %bits = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 1
  %bits1 = load ptr, ptr %bits, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %key2 = load ptr, ptr %key, align 8
  %2 = call i32 @Digest.fnv1a(ptr %key2)
  %3 = call i32 @BloomFilter.idx(ptr %0, i32 %2)
  %4 = sext i32 %3 to i64
  %arr.len = load i64, ptr %bits1, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1897, ptr @.faila.1898, i64 %4, ptr @.failb.1899, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %bits1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %4
  %elem = load i8, ptr %arr.elem, align 1
  %5 = zext i8 %elem to i32
  %sc.a = icmp ne i32 %5, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %idx.ok
  %bits3 = getelementptr inbounds %class.BloomFilter, ptr %0, i32 0, i32 1
  %bits4 = load ptr, ptr %bits3, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %key5 = load ptr, ptr %key, align 8
  %6 = call i32 @Digest.crc32(ptr %key5)
  %7 = call i32 @BloomFilter.idx(ptr %0, i32 %6)
  %8 = sext i32 %7 to i64
  %arr.len6 = load i64, ptr %bits4, align 8
  %arr.oob7 = icmp uge i64 %8, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !0

sc.end:                                           ; preds = %idx.ok9, %idx.ok
  %sc = phi i1 [ false, %idx.ok ], [ %sc.b, %idx.ok9 ]
  %9 = zext i1 %sc to i32
  ret i32 %9

idx.bad8:                                         ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1900, ptr @.faila.1901, i64 %8, ptr @.failb.1902, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %sc.rhs
  %arr.data10 = getelementptr i8, ptr %bits4, i64 8
  %arr.elem11 = getelementptr inbounds i8, ptr %arr.data10, i64 %8
  %elem12 = load i8, ptr %arr.elem11, align 1
  %10 = zext i8 %elem12 to i32
  %sc.b = icmp ne i32 %10, 0
  br label %sc.end
}

define internal void @Sieve.Sieve(ptr %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %limit = alloca i32, align 4
  store i32 %1, ptr %limit, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 0
  store ptr @Sieve.vtable, ptr %vtbl.addr, align 8, !tbaa !1
  %composite = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 1
  store ptr null, ptr %composite, align 8, !tbaa !1
  %limit1 = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 2
  %limit2 = load i32, ptr %limit, align 4
  store i32 %limit2, ptr %limit1, align 4, !tbaa !5
  %composite3 = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 1
  %limit4 = load i32, ptr %limit, align 4
  %2 = add i32 %limit4, 1
  %3 = sext i32 %2 to i64
  %4 = mul i64 %3, 1
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %composite3, align 8, !tbaa !1
  store i32 2, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i5 = load i32, ptr %i, align 4
  %i6 = load i32, ptr %i, align 4
  %7 = mul i32 %i5, %i6
  %limit7 = load i32, ptr %limit, align 4
  %8 = icmp sle i32 %7, %limit7
  %9 = zext i1 %8 to i32
  br i1 %8, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %composite8 = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 1
  %composite9 = load ptr, ptr %composite8, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %i10 = load i32, ptr %i, align 4
  %10 = sext i32 %i10 to i64
  %arr.len = load i64, ptr %composite9, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3424, ptr @.faila.3425, i64 %10, ptr @.failb.3426, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %composite9, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data11, i64 %10
  %elem = load i8, ptr %arr.elem, align 1
  %13 = zext i8 %elem to i32
  %14 = icmp eq i32 %13, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %i12 = load i32, ptr %i, align 4
  %i13 = load i32, ptr %i, align 4
  %16 = mul i32 %i12, %i13
  store i32 %16, ptr %j, align 4
  br label %for.cond14

if.end:                                           ; preds = %for.end17, %idx.ok
  br label %for.update

for.cond14:                                       ; preds = %for.update16, %if.then
  %j18 = load i32, ptr %j, align 4
  %limit19 = load i32, ptr %limit, align 4
  %17 = icmp sle i32 %j18, %limit19
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body15, label %for.end17

for.body15:                                       ; preds = %for.cond14
  %composite20 = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 1
  %composite21 = load ptr, ptr %composite20, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %j22 = load i32, ptr %j, align 4
  %19 = sext i32 %j22 to i64
  %arr.len23 = load i64, ptr %composite21, align 8
  %arr.oob24 = icmp uge i64 %19, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !0

for.update16:                                     ; preds = %idx.ok26
  %j29 = load i32, ptr %j, align 4
  %i30 = load i32, ptr %i, align 4
  %20 = add i32 %j29, %i30
  store i32 %20, ptr %j, align 4
  br label %for.cond14

for.end17:                                        ; preds = %for.cond14
  br label %if.end

idx.bad25:                                        ; preds = %for.body15
  call void @__polaron_fail(ptr @.fail.3427, ptr @.faila.3428, i64 %19, ptr @.failb.3429, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %for.body15
  %arr.data27 = getelementptr i8, ptr %composite21, i64 8
  %arr.elem28 = getelementptr inbounds i8, ptr %arr.data27, i64 %19
  store i8 1, ptr %arr.elem28, align 1
  br label %for.update16
}

define internal i32 @Sieve.isPrime(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %2 = icmp slt i32 %n1, 2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %composite = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 1
  %composite2 = load ptr, ptr %composite, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %n3 = load i32, ptr %n, align 4
  %4 = sext i32 %n3 to i64
  %arr.len = load i64, ptr %composite2, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.3430, ptr @.faila.3431, i64 %4, ptr @.failb.3432, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %composite2, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %4
  %elem = load i8, ptr %arr.elem, align 1
  %5 = zext i8 %elem to i32
  %6 = icmp eq i32 %5, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal i32 @Sieve.count(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %c = alloca i32, align 4
  store i32 0, ptr %c, align 4
  store i32 2, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %limit = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 2
  %limit2 = load i32, ptr %limit, align 4, !tbaa !5
  %1 = icmp sle i32 %i1, %limit2
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %composite = getelementptr inbounds %class.Sieve, ptr %0, i32 0, i32 1
  %composite3 = load ptr, ptr %composite, align 8, !tbaa !1, !nonnull !7, !dereferenceable !8
  %i4 = load i32, ptr %i, align 4
  %3 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %composite3, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !0

for.update:                                       ; preds = %if.end
  %4 = load i32, ptr %i, align 4
  %5 = add i32 %4, 1
  store i32 %5, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %c6 = load i32, ptr %c, align 4
  ret i32 %c6

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3433, ptr @.faila.3434, i64 %3, ptr @.failb.3435, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %composite3, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %3
  %elem = load i8, ptr %arr.elem, align 1
  %6 = zext i8 %elem to i32
  %7 = icmp eq i32 %6, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %c5 = load i32, ptr %c, align 4
  %9 = add i32 %c5, 1
  store i32 %9, ptr %c, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok
  br label %for.update
}

define internal i32 @Digest.crc32(ptr %0) {
entry:
  %b = alloca i32, align 4
  %i = alloca i32, align 4
  %poly = alloca i32, align 4
  %crc = alloca i32, align 4
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  store i32 -1, ptr %crc, align 4
  store i32 -306674912, ptr %poly, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %data2 = load ptr, ptr %data, align 8
  %str.len = getelementptr inbounds %String, ptr %data2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %crc3 = load i32, ptr %crc, align 4
  %data4 = load ptr, ptr %data, align 8
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %data4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data6, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = xor i32 %crc3, %5
  store i32 %6, ptr %crc, align 4
  store i32 0, ptr %b, align 4
  br label %for.cond7

for.update:                                       ; preds = %for.end10
  %7 = load i32, ptr %i, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %crc16 = load i32, ptr %crc, align 4
  %9 = xor i32 %crc16, -1
  store i32 %9, ptr %crc, align 4
  %crc17 = load i32, ptr %crc, align 4
  ret i32 %crc17

for.cond7:                                        ; preds = %for.update9, %for.body
  %b11 = load i32, ptr %b, align 4
  %10 = icmp slt i32 %b11, 8
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body8, label %for.end10

for.body8:                                        ; preds = %for.cond7
  %crc12 = load i32, ptr %crc, align 4
  %12 = and i32 %crc12, 1
  %13 = icmp ne i32 %12, 0
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.else

for.update9:                                      ; preds = %if.end
  %15 = load i32, ptr %b, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %b, align 4
  br label %for.cond7

for.end10:                                        ; preds = %for.cond7
  br label %for.update

if.then:                                          ; preds = %for.body8
  %crc13 = load i32, ptr %crc, align 4
  %17 = lshr i32 %crc13, 1
  %poly14 = load i32, ptr %poly, align 4
  %18 = xor i32 %17, %poly14
  store i32 %18, ptr %crc, align 4
  br label %if.end

if.else:                                          ; preds = %for.body8
  %crc15 = load i32, ptr %crc, align 4
  %19 = lshr i32 %crc15, 1
  store i32 %19, ptr %crc, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %for.update9
}

define internal i32 @Digest.fnv1a(ptr %0) {
entry:
  %i = alloca i32, align 4
  %prime = alloca i32, align 4
  %h = alloca i32, align 4
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  store i32 -2128831035, ptr %h, align 4
  store i32 16777619, ptr %prime, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %data2 = load ptr, ptr %data, align 8
  %str.len = getelementptr inbounds %String, ptr %data2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %h3 = load i32, ptr %h, align 4
  %data4 = load ptr, ptr %data, align 8
  %i5 = load i32, ptr %i, align 4
  %4 = sext i32 %i5 to i64
  %str.data = getelementptr inbounds %String, ptr %data4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data6, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  %6 = xor i32 %h3, %5
  %prime7 = load i32, ptr %prime, align 4
  %7 = mul i32 %6, %prime7
  store i32 %7, ptr %h, align 4
  br label %for.update

for.update:                                       ; preds = %for.body
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %h8 = load i32, ptr %h, align 4
  ret i32 %h8
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5341)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5343)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!"branch_weights", i32 1, i32 1048576}
!1 = !{!2, !2, i64 0}
!2 = !{!"ptr", !3, i64 0}
!3 = !{!"polaron char", !4, i64 0}
!4 = !{!"polaron TBAA"}
!5 = !{!6, !6, i64 0}
!6 = !{!"i32", !3, i64 0}
!7 = !{}
!8 = !{i64 8}
