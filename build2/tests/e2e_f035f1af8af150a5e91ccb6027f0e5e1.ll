; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/generator.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/generator.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.Sequences$evens$Gen" = type { ptr, i64, i32, i32, i32 }
%"class.Sequences$primes$Gen" = type { ptr, i64, i32, i32, i32 }
%class.DivideByZeroException = type { ptr }
%"Sequences$evens$genstate" = type { i32, i32, i32, i32 }
%"Sequences$primes$genstate" = type { i32, i32, i32 }
%class.Countdown = type { ptr, i32 }
%"class.Countdown$ticks$Gen" = type { ptr, i64, i32, i32, i32 }
%"Countdown$ticks$genstate" = type { i32, i32, ptr, i32 }
%"class.Iterator$int" = type { ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Countdown.vtable = private constant [352 x ptr] [ptr @Countdown.ticks, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Sequences$evens$Gen.vtable" = private constant [352 x ptr] [ptr null, ptr null, ptr @"Sequences$evens$Gen.pump", ptr @"Sequences$evens$Gen.hasNext", ptr @"Sequences$evens$Gen.next", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Sequences$evens$Gen.~Sequences$evens$Gen"]
@"Sequences$primes$Gen.vtable" = private constant [352 x ptr] [ptr null, ptr null, ptr @"Sequences$primes$Gen.pump", ptr @"Sequences$primes$Gen.hasNext", ptr @"Sequences$primes$Gen.next", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Sequences$primes$Gen.~Sequences$primes$Gen"]
@"Countdown$ticks$Gen.vtable" = private constant [352 x ptr] [ptr null, ptr null, ptr @"Countdown$ticks$Gen.pump", ptr @"Countdown$ticks$Gen.hasNext", ptr @"Countdown$ticks$Gen.next", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Countdown$ticks$Gen.~Countdown$ticks$Gen"]
@Object.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str = private unnamed_addr constant [10 x i8] c"evens=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [19 x i8] c"primes=%d last=%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"ticks=%d\0A\00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"first=%d more=%d\0A\00", align 1
@.strdata.1307 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1308 = private global %String { i64 16, ptr @.strdata.1307, i64 0 }
@.strdata.1309 = private constant [17 x i8] c"division by zero\00"
@.strobj.1310 = private global %String { i64 16, ptr @.strdata.1309, i64 0 }
@.strdata.5308 = private constant [1 x i8] zeroinitializer
@.strobj.5309 = private global %String { i64 0, ptr @.strdata.5308, i64 0 }
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }

define internal ptr @Sequences.evens(i32 %0) {
entry:
  %limit = alloca i32, align 4
  store i32 %0, ptr %limit, align 4
  %"Sequences$evens$Gen.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Sequences$evens$Gen", ptr null, i64 1) to i64))
  %limit1 = load i32, ptr %limit, align 4
  %1 = call i64 @"Sequences$evens$start"(i32 %limit1)
  call void @"Sequences$evens$Gen.Sequences$evens$Gen"(ptr %"Sequences$evens$Gen.obj", i64 %1)
  ret ptr %"Sequences$evens$Gen.obj"
}

define internal ptr @Sequences.primes() {
entry:
  %"Sequences$primes$Gen.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Sequences$primes$Gen", ptr null, i64 1) to i64))
  %0 = call i64 @"Sequences$primes$start"()
  call void @"Sequences$primes$Gen.Sequences$primes$Gen"(ptr %"Sequences$primes$Gen.obj", i64 %0)
  ret ptr %"Sequences$primes$Gen.obj"
}

define internal i32 @Sequences.isPrime(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %d = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %1 = icmp slt i32 %n1, 2
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  store i32 2, ptr %d, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end8, %if.end
  %d2 = load i32, ptr %d, align 4
  %d3 = load i32, ptr %d, align 4
  %3 = mul i32 %d2, %d3
  %n4 = load i32, ptr %n, align 4
  %4 = icmp sle i32 %3, %n4
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n5 = load i32, ptr %n, align 4
  %d6 = load i32, ptr %d, align 4
  %6 = icmp eq i32 %d6, 0
  %7 = icmp eq i32 %n5, -2147483648
  %8 = icmp eq i32 %d6, -1
  %9 = and i1 %7, %8
  %10 = or i1 %6, %9
  br i1 %10, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  ret i32 1

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %11 = srem i32 %n5, %d6
  %12 = icmp eq i32 %11, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then7, label %if.end8

if.then7:                                         ; preds = %div.ok
  ret i32 0

if.end8:                                          ; preds = %div.ok
  %d9 = load i32, ptr %d, align 4
  %14 = add i32 %d9, 1
  store i32 %14, ptr %d, align 4
  br label %while.cond
}

define internal i64 @"Sequences$evens$start"(i32 %0) {
entry:
  %gen.state = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"Sequences$evens$genstate", ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.state, i32 0, i32 0
  store i32 0, ptr %1, align 4
  %2 = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.state, i32 0, i32 2
  store i32 %0, ptr %2, align 4
  %3 = ptrtoint ptr %gen.state to i64
  ret i64 %3
}

define internal i64 @"Sequences$primes$start"() {
entry:
  %gen.state = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"Sequences$primes$genstate", ptr null, i64 1) to i64))
  %0 = getelementptr inbounds %"Sequences$primes$genstate", ptr %gen.state, i32 0, i32 0
  store i32 0, ptr %0, align 4
  %1 = ptrtoint ptr %gen.state to i64
  ret i64 %1
}

define internal void @Countdown.Countdown(ptr %0, i32 %1) {
entry:
  %from = alloca i32, align 4
  store i32 %1, ptr %from, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Countdown, ptr %0, i32 0, i32 0
  store ptr @Countdown.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %from1 = getelementptr inbounds %class.Countdown, ptr %0, i32 0, i32 1
  %from2 = load i32, ptr %from, align 4
  store i32 %from2, ptr %from1, align 4, !tbaa !4
  ret void
}

define internal ptr @Countdown.ticks(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %"Countdown$ticks$Gen.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Countdown$ticks$Gen", ptr null, i64 1) to i64))
  %1 = call i64 @"Countdown$ticks$start"(ptr %0)
  call void @"Countdown$ticks$Gen.Countdown$ticks$Gen"(ptr %"Countdown$ticks$Gen.obj", i64 %1)
  ret ptr %"Countdown$ticks$Gen.obj"
}

define internal i64 @"Countdown$ticks$start"(ptr %0) {
entry:
  %gen.state = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"Countdown$ticks$genstate", ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.state, i32 0, i32 0
  store i32 0, ptr %1, align 4
  %2 = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.state, i32 0, i32 2
  store ptr %0, ptr %2, align 8
  %3 = ptrtoint ptr %gen.state to i64
  ret i64 %3
}

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown210 = alloca ptr, align 8
  %exc.cleanup188 = alloca ptr, align 8
  %exc.thrown179 = alloca ptr, align 8
  %exc.cleanup157 = alloca ptr, align 8
  %exc.thrown147 = alloca ptr, align 8
  %exc.cleanup125 = alloca ptr, align 8
  %first = alloca i32, align 4
  %it = alloca ptr, align 8
  %exc.thrown119 = alloca ptr, align 8
  %exc.cleanup97 = alloca ptr, align 8
  %fe.i70 = alloca i32, align 4
  %t = alloca i32, align 4
  %fe.it69 = alloca ptr, align 8
  %exc.thrown67 = alloca ptr, align 8
  %exc.cleanup51 = alloca ptr, align 8
  %steps = alloca i32, align 4
  %c = alloca ptr, align 8
  %exc.thrown47 = alloca ptr, align 8
  %exc.cleanup31 = alloca ptr, align 8
  %fe.i9 = alloca i32, align 4
  %p = alloca i32, align 4
  %fe.it8 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %exc.cleanup = alloca ptr, align 8
  %count = alloca i32, align 4
  %last = alloca i32, align 4
  %fe.i = alloca i32, align 4
  %e = alloca i32, align 4
  %fe.it = alloca ptr, align 8
  %sum = alloca i32, align 4
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
  store i32 0, ptr %sum, align 4
  %16 = call ptr @Sequences.evens(i32 8)
  store ptr %16, ptr %fe.it, align 8
  store i32 0, ptr %fe.i, align 4
  br label %fei.cond

fei.cond:                                         ; preds = %fei.update, %argv.end
  %fei.itv = load ptr, ptr %fe.it, align 8
  %it.vtbl.addr = getelementptr inbounds %"class.Iterator$int", ptr %fei.itv, i32 0, i32 0
  %it.vtbl = load ptr, ptr %it.vtbl.addr, align 8, !tbaa !0
  %it.slot = getelementptr [351 x ptr], ptr %it.vtbl, i64 0, i64 3
  %it.fn = load ptr, ptr %it.slot, align 8
  %17 = call i32 %it.fn(ptr %fei.itv)
  %18 = icmp ne i32 %17, 0
  br i1 %18, label %fei.body, label %fei.end

fei.body:                                         ; preds = %fei.cond
  %fei.itv2 = load ptr, ptr %fe.it, align 8
  %it.vtbl.addr1 = getelementptr inbounds %"class.Iterator$int", ptr %fei.itv2, i32 0, i32 0
  %it.vtbl2 = load ptr, ptr %it.vtbl.addr1, align 8, !tbaa !0
  %it.slot3 = getelementptr [351 x ptr], ptr %it.vtbl2, i64 0, i64 4
  %it.fn4 = load ptr, ptr %it.slot3, align 8
  %19 = call i32 %it.fn4(ptr %fei.itv2)
  store i32 %19, ptr %e, align 4
  %sum5 = load i32, ptr %sum, align 4
  %e6 = load i32, ptr %e, align 4
  %20 = add i32 %sum5, %e6
  store i32 %20, ptr %sum, align 4
  br label %fei.update

fei.update:                                       ; preds = %fei.body
  %fei.iv = load i32, ptr %fe.i, align 4
  %21 = add i32 %fei.iv, 1
  store i32 %21, ptr %fe.i, align 4
  br label %fei.cond

fei.end:                                          ; preds = %fei.cond
  %sum7 = load i32, ptr %sum, align 4
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %sum7)
  store i32 0, ptr %last, align 4
  store i32 0, ptr %count, align 4
  %23 = invoke ptr @Sequences.primes()
          to label %invoke.cont unwind label %cleanup

cleanup:                                          ; preds = %fei.end
  %24 = catchswitch within none [label %cleanup.dispatch] unwind to caller

cleanup.dispatch:                                 ; preds = %cleanup
  %25 = catchpad within %24 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup]
  catchret from %25 to label %cleanup.run

cleanup.run:                                      ; preds = %cleanup.dispatch
  %cleanup.obj = load ptr, ptr %exc.cleanup, align 8
  %26 = load ptr, ptr %fe.it, align 8
  call void @__polaron_check_live(ptr %26)
  %vtbl.addr = getelementptr inbounds %"class.Iterator$int", ptr %26, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [352 x ptr], ptr %vtbl, i64 0, i64 351
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %27 = icmp ne ptr %dtor.fn, null
  br i1 %27, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %cleanup.run
  call void %dtor.fn(ptr %26)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %cleanup.run
  call void @__polaron_free(ptr %26)
  store ptr %cleanup.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

invoke.cont:                                      ; preds = %fei.end
  store ptr %23, ptr %fe.it8, align 8
  store i32 0, ptr %fe.i9, align 4
  br label %fei.cond10

fei.cond10:                                       ; preds = %fei.update12, %invoke.cont
  %fei.itv14 = load ptr, ptr %fe.it8, align 8
  %it.vtbl.addr15 = getelementptr inbounds %"class.Iterator$int", ptr %fei.itv14, i32 0, i32 0
  %it.vtbl16 = load ptr, ptr %it.vtbl.addr15, align 8, !tbaa !0
  %it.slot17 = getelementptr [351 x ptr], ptr %it.vtbl16, i64 0, i64 3
  %it.fn18 = load ptr, ptr %it.slot17, align 8
  %28 = call i32 %it.fn18(ptr %fei.itv14)
  %29 = icmp ne i32 %28, 0
  br i1 %29, label %fei.body11, label %fei.end13

fei.body11:                                       ; preds = %fei.cond10
  %fei.itv219 = load ptr, ptr %fe.it8, align 8
  %it.vtbl.addr20 = getelementptr inbounds %"class.Iterator$int", ptr %fei.itv219, i32 0, i32 0
  %it.vtbl21 = load ptr, ptr %it.vtbl.addr20, align 8, !tbaa !0
  %it.slot22 = getelementptr [351 x ptr], ptr %it.vtbl21, i64 0, i64 4
  %it.fn23 = load ptr, ptr %it.slot22, align 8
  %30 = call i32 %it.fn23(ptr %fei.itv219)
  store i32 %30, ptr %p, align 4
  %p24 = load i32, ptr %p, align 4
  %31 = icmp sgt i32 %p24, 30
  %32 = zext i1 %31 to i32
  br i1 %31, label %if.then, label %if.end

fei.update12:                                     ; preds = %if.end
  %fei.iv27 = load i32, ptr %fe.i9, align 4
  %33 = add i32 %fei.iv27, 1
  store i32 %33, ptr %fe.i9, align 4
  br label %fei.cond10

fei.end13:                                        ; preds = %if.then, %fei.cond10
  %count28 = load i32, ptr %count, align 4
  %last29 = load i32, ptr %last, align 4
  %34 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %count28, i32 %last29)
  %Countdown.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Countdown, ptr null, i64 1) to i64))
  invoke void @Countdown.Countdown(ptr %Countdown.obj, i32 3)
          to label %invoke.cont48 unwind label %cleanup30

if.then:                                          ; preds = %fei.body11
  br label %fei.end13

if.end:                                           ; preds = %fei.body11
  %p25 = load i32, ptr %p, align 4
  store i32 %p25, ptr %last, align 4
  %count26 = load i32, ptr %count, align 4
  %35 = add i32 %count26, 1
  store i32 %35, ptr %count, align 4
  br label %fei.update12

cleanup30:                                        ; preds = %fei.end13
  %36 = catchswitch within none [label %cleanup.dispatch32] unwind to caller

cleanup.dispatch32:                               ; preds = %cleanup30
  %37 = catchpad within %36 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup31]
  catchret from %37 to label %cleanup.run33

cleanup.run33:                                    ; preds = %cleanup.dispatch32
  %cleanup.obj34 = load ptr, ptr %exc.cleanup31, align 8
  %38 = load ptr, ptr %fe.it8, align 8
  call void @__polaron_check_live(ptr %38)
  %vtbl.addr35 = getelementptr inbounds %"class.Iterator$int", ptr %38, i32 0, i32 0
  %vtbl36 = load ptr, ptr %vtbl.addr35, align 8, !tbaa !0
  %dtor.slot37 = getelementptr [352 x ptr], ptr %vtbl36, i64 0, i64 351
  %dtor.fn38 = load ptr, ptr %dtor.slot37, align 8
  %39 = icmp ne ptr %dtor.fn38, null
  br i1 %39, label %dtor.call39, label %dtor.free40

dtor.call39:                                      ; preds = %cleanup.run33
  call void %dtor.fn38(ptr %38)
  br label %dtor.free40

dtor.free40:                                      ; preds = %dtor.call39, %cleanup.run33
  call void @__polaron_free(ptr %38)
  %40 = load ptr, ptr %fe.it, align 8
  call void @__polaron_check_live(ptr %40)
  %vtbl.addr41 = getelementptr inbounds %"class.Iterator$int", ptr %40, i32 0, i32 0
  %vtbl42 = load ptr, ptr %vtbl.addr41, align 8, !tbaa !0
  %dtor.slot43 = getelementptr [352 x ptr], ptr %vtbl42, i64 0, i64 351
  %dtor.fn44 = load ptr, ptr %dtor.slot43, align 8
  %41 = icmp ne ptr %dtor.fn44, null
  br i1 %41, label %dtor.call45, label %dtor.free46

dtor.call45:                                      ; preds = %dtor.free40
  call void %dtor.fn44(ptr %40)
  br label %dtor.free46

dtor.free46:                                      ; preds = %dtor.call45, %dtor.free40
  call void @__polaron_free(ptr %40)
  store ptr %cleanup.obj34, ptr %exc.thrown47, align 8
  call void @_CxxThrowException(ptr %exc.thrown47, ptr @_TI1PEAX)
  unreachable

invoke.cont48:                                    ; preds = %fei.end13
  store ptr %Countdown.obj, ptr %c, align 8
  store i32 0, ptr %steps, align 4
  %c49 = load ptr, ptr %c, align 8
  %42 = invoke ptr @Countdown.ticks(ptr %c49)
          to label %invoke.cont68 unwind label %cleanup50

cleanup50:                                        ; preds = %invoke.cont48
  %43 = catchswitch within none [label %cleanup.dispatch52] unwind to caller

cleanup.dispatch52:                               ; preds = %cleanup50
  %44 = catchpad within %43 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup51]
  catchret from %44 to label %cleanup.run53

cleanup.run53:                                    ; preds = %cleanup.dispatch52
  %cleanup.obj54 = load ptr, ptr %exc.cleanup51, align 8
  %45 = load ptr, ptr %fe.it8, align 8
  call void @__polaron_check_live(ptr %45)
  %vtbl.addr55 = getelementptr inbounds %"class.Iterator$int", ptr %45, i32 0, i32 0
  %vtbl56 = load ptr, ptr %vtbl.addr55, align 8, !tbaa !0
  %dtor.slot57 = getelementptr [352 x ptr], ptr %vtbl56, i64 0, i64 351
  %dtor.fn58 = load ptr, ptr %dtor.slot57, align 8
  %46 = icmp ne ptr %dtor.fn58, null
  br i1 %46, label %dtor.call59, label %dtor.free60

dtor.call59:                                      ; preds = %cleanup.run53
  call void %dtor.fn58(ptr %45)
  br label %dtor.free60

dtor.free60:                                      ; preds = %dtor.call59, %cleanup.run53
  call void @__polaron_free(ptr %45)
  %47 = load ptr, ptr %fe.it, align 8
  call void @__polaron_check_live(ptr %47)
  %vtbl.addr61 = getelementptr inbounds %"class.Iterator$int", ptr %47, i32 0, i32 0
  %vtbl62 = load ptr, ptr %vtbl.addr61, align 8, !tbaa !0
  %dtor.slot63 = getelementptr [352 x ptr], ptr %vtbl62, i64 0, i64 351
  %dtor.fn64 = load ptr, ptr %dtor.slot63, align 8
  %48 = icmp ne ptr %dtor.fn64, null
  br i1 %48, label %dtor.call65, label %dtor.free66

dtor.call65:                                      ; preds = %dtor.free60
  call void %dtor.fn64(ptr %47)
  br label %dtor.free66

dtor.free66:                                      ; preds = %dtor.call65, %dtor.free60
  call void @__polaron_free(ptr %47)
  store ptr %cleanup.obj54, ptr %exc.thrown67, align 8
  call void @_CxxThrowException(ptr %exc.thrown67, ptr @_TI1PEAX)
  unreachable

invoke.cont68:                                    ; preds = %invoke.cont48
  store ptr %42, ptr %fe.it69, align 8
  store i32 0, ptr %fe.i70, align 4
  br label %fei.cond71

fei.cond71:                                       ; preds = %fei.update73, %invoke.cont68
  %fei.itv75 = load ptr, ptr %fe.it69, align 8
  %it.vtbl.addr76 = getelementptr inbounds %"class.Iterator$int", ptr %fei.itv75, i32 0, i32 0
  %it.vtbl77 = load ptr, ptr %it.vtbl.addr76, align 8, !tbaa !0
  %it.slot78 = getelementptr [351 x ptr], ptr %it.vtbl77, i64 0, i64 3
  %it.fn79 = load ptr, ptr %it.slot78, align 8
  %49 = call i32 %it.fn79(ptr %fei.itv75)
  %50 = icmp ne i32 %49, 0
  br i1 %50, label %fei.body72, label %fei.end74

fei.body72:                                       ; preds = %fei.cond71
  %fei.itv280 = load ptr, ptr %fe.it69, align 8
  %it.vtbl.addr81 = getelementptr inbounds %"class.Iterator$int", ptr %fei.itv280, i32 0, i32 0
  %it.vtbl82 = load ptr, ptr %it.vtbl.addr81, align 8, !tbaa !0
  %it.slot83 = getelementptr [351 x ptr], ptr %it.vtbl82, i64 0, i64 4
  %it.fn84 = load ptr, ptr %it.slot83, align 8
  %51 = call i32 %it.fn84(ptr %fei.itv280)
  store i32 %51, ptr %t, align 4
  %steps85 = load i32, ptr %steps, align 4
  %52 = mul i32 %steps85, 10
  %t86 = load i32, ptr %t, align 4
  %53 = add i32 %52, %t86
  store i32 %53, ptr %steps, align 4
  br label %fei.update73

fei.update73:                                     ; preds = %fei.body72
  %fei.iv87 = load i32, ptr %fe.i70, align 4
  %54 = add i32 %fei.iv87, 1
  store i32 %54, ptr %fe.i70, align 4
  br label %fei.cond71

fei.end74:                                        ; preds = %fei.cond71
  %steps88 = load i32, ptr %steps, align 4
  %55 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %steps88)
  %c89 = load ptr, ptr %c, align 8
  call void @__polaron_check_live(ptr %c89)
  %vtbl.addr90 = getelementptr inbounds %class.Countdown, ptr %c89, i32 0, i32 0
  %vtbl91 = load ptr, ptr %vtbl.addr90, align 8, !tbaa !0
  %dtor.slot92 = getelementptr [352 x ptr], ptr %vtbl91, i64 0, i64 351
  %dtor.fn93 = load ptr, ptr %dtor.slot92, align 8
  %56 = icmp ne ptr %dtor.fn93, null
  br i1 %56, label %dtor.call94, label %dtor.free95

dtor.call94:                                      ; preds = %fei.end74
  call void %dtor.fn93(ptr %c89)
  br label %dtor.free95

dtor.free95:                                      ; preds = %dtor.call94, %fei.end74
  call void @__polaron_free(ptr %c89)
  %57 = invoke ptr @Sequences.evens(i32 4)
          to label %invoke.cont120 unwind label %cleanup96

cleanup96:                                        ; preds = %dtor.free95
  %58 = catchswitch within none [label %cleanup.dispatch98] unwind to caller

cleanup.dispatch98:                               ; preds = %cleanup96
  %59 = catchpad within %58 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup97]
  catchret from %59 to label %cleanup.run99

cleanup.run99:                                    ; preds = %cleanup.dispatch98
  %cleanup.obj100 = load ptr, ptr %exc.cleanup97, align 8
  %60 = load ptr, ptr %fe.it69, align 8
  call void @__polaron_check_live(ptr %60)
  %vtbl.addr101 = getelementptr inbounds %"class.Iterator$int", ptr %60, i32 0, i32 0
  %vtbl102 = load ptr, ptr %vtbl.addr101, align 8, !tbaa !0
  %dtor.slot103 = getelementptr [352 x ptr], ptr %vtbl102, i64 0, i64 351
  %dtor.fn104 = load ptr, ptr %dtor.slot103, align 8
  %61 = icmp ne ptr %dtor.fn104, null
  br i1 %61, label %dtor.call105, label %dtor.free106

dtor.call105:                                     ; preds = %cleanup.run99
  call void %dtor.fn104(ptr %60)
  br label %dtor.free106

dtor.free106:                                     ; preds = %dtor.call105, %cleanup.run99
  call void @__polaron_free(ptr %60)
  %62 = load ptr, ptr %fe.it8, align 8
  call void @__polaron_check_live(ptr %62)
  %vtbl.addr107 = getelementptr inbounds %"class.Iterator$int", ptr %62, i32 0, i32 0
  %vtbl108 = load ptr, ptr %vtbl.addr107, align 8, !tbaa !0
  %dtor.slot109 = getelementptr [352 x ptr], ptr %vtbl108, i64 0, i64 351
  %dtor.fn110 = load ptr, ptr %dtor.slot109, align 8
  %63 = icmp ne ptr %dtor.fn110, null
  br i1 %63, label %dtor.call111, label %dtor.free112

dtor.call111:                                     ; preds = %dtor.free106
  call void %dtor.fn110(ptr %62)
  br label %dtor.free112

dtor.free112:                                     ; preds = %dtor.call111, %dtor.free106
  call void @__polaron_free(ptr %62)
  %64 = load ptr, ptr %fe.it, align 8
  call void @__polaron_check_live(ptr %64)
  %vtbl.addr113 = getelementptr inbounds %"class.Iterator$int", ptr %64, i32 0, i32 0
  %vtbl114 = load ptr, ptr %vtbl.addr113, align 8, !tbaa !0
  %dtor.slot115 = getelementptr [352 x ptr], ptr %vtbl114, i64 0, i64 351
  %dtor.fn116 = load ptr, ptr %dtor.slot115, align 8
  %65 = icmp ne ptr %dtor.fn116, null
  br i1 %65, label %dtor.call117, label %dtor.free118

dtor.call117:                                     ; preds = %dtor.free112
  call void %dtor.fn116(ptr %64)
  br label %dtor.free118

dtor.free118:                                     ; preds = %dtor.call117, %dtor.free112
  call void @__polaron_free(ptr %64)
  store ptr %cleanup.obj100, ptr %exc.thrown119, align 8
  call void @_CxxThrowException(ptr %exc.thrown119, ptr @_TI1PEAX)
  unreachable

invoke.cont120:                                   ; preds = %dtor.free95
  store ptr %57, ptr %it, align 8
  store i32 -1, ptr %first, align 4
  %it121 = load ptr, ptr %it, align 8
  %vtbl.addr122 = getelementptr inbounds %"class.Iterator$int", ptr %it121, i32 0, i32 0
  %vtbl123 = load ptr, ptr %vtbl.addr122, align 8, !tbaa !0
  %slot = getelementptr [351 x ptr], ptr %vtbl123, i64 0, i64 3
  %fn = load ptr, ptr %slot, align 8
  %66 = invoke i32 %fn(ptr %it121)
          to label %invoke.cont148 unwind label %cleanup124

cleanup124:                                       ; preds = %invoke.cont120
  %67 = catchswitch within none [label %cleanup.dispatch126] unwind to caller

cleanup.dispatch126:                              ; preds = %cleanup124
  %68 = catchpad within %67 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup125]
  catchret from %68 to label %cleanup.run127

cleanup.run127:                                   ; preds = %cleanup.dispatch126
  %cleanup.obj128 = load ptr, ptr %exc.cleanup125, align 8
  %69 = load ptr, ptr %fe.it69, align 8
  call void @__polaron_check_live(ptr %69)
  %vtbl.addr129 = getelementptr inbounds %"class.Iterator$int", ptr %69, i32 0, i32 0
  %vtbl130 = load ptr, ptr %vtbl.addr129, align 8, !tbaa !0
  %dtor.slot131 = getelementptr [352 x ptr], ptr %vtbl130, i64 0, i64 351
  %dtor.fn132 = load ptr, ptr %dtor.slot131, align 8
  %70 = icmp ne ptr %dtor.fn132, null
  br i1 %70, label %dtor.call133, label %dtor.free134

dtor.call133:                                     ; preds = %cleanup.run127
  call void %dtor.fn132(ptr %69)
  br label %dtor.free134

dtor.free134:                                     ; preds = %dtor.call133, %cleanup.run127
  call void @__polaron_free(ptr %69)
  %71 = load ptr, ptr %fe.it8, align 8
  call void @__polaron_check_live(ptr %71)
  %vtbl.addr135 = getelementptr inbounds %"class.Iterator$int", ptr %71, i32 0, i32 0
  %vtbl136 = load ptr, ptr %vtbl.addr135, align 8, !tbaa !0
  %dtor.slot137 = getelementptr [352 x ptr], ptr %vtbl136, i64 0, i64 351
  %dtor.fn138 = load ptr, ptr %dtor.slot137, align 8
  %72 = icmp ne ptr %dtor.fn138, null
  br i1 %72, label %dtor.call139, label %dtor.free140

dtor.call139:                                     ; preds = %dtor.free134
  call void %dtor.fn138(ptr %71)
  br label %dtor.free140

dtor.free140:                                     ; preds = %dtor.call139, %dtor.free134
  call void @__polaron_free(ptr %71)
  %73 = load ptr, ptr %fe.it, align 8
  call void @__polaron_check_live(ptr %73)
  %vtbl.addr141 = getelementptr inbounds %"class.Iterator$int", ptr %73, i32 0, i32 0
  %vtbl142 = load ptr, ptr %vtbl.addr141, align 8, !tbaa !0
  %dtor.slot143 = getelementptr [352 x ptr], ptr %vtbl142, i64 0, i64 351
  %dtor.fn144 = load ptr, ptr %dtor.slot143, align 8
  %74 = icmp ne ptr %dtor.fn144, null
  br i1 %74, label %dtor.call145, label %dtor.free146

dtor.call145:                                     ; preds = %dtor.free140
  call void %dtor.fn144(ptr %73)
  br label %dtor.free146

dtor.free146:                                     ; preds = %dtor.call145, %dtor.free140
  call void @__polaron_free(ptr %73)
  store ptr %cleanup.obj128, ptr %exc.thrown147, align 8
  call void @_CxxThrowException(ptr %exc.thrown147, ptr @_TI1PEAX)
  unreachable

invoke.cont148:                                   ; preds = %invoke.cont120
  %75 = icmp ne i32 %66, 0
  br i1 %75, label %if.then149, label %if.end150

if.then149:                                       ; preds = %invoke.cont148
  %it151 = load ptr, ptr %it, align 8
  %vtbl.addr152 = getelementptr inbounds %"class.Iterator$int", ptr %it151, i32 0, i32 0
  %vtbl153 = load ptr, ptr %vtbl.addr152, align 8, !tbaa !0
  %slot154 = getelementptr [351 x ptr], ptr %vtbl153, i64 0, i64 4
  %fn155 = load ptr, ptr %slot154, align 8
  %76 = invoke i32 %fn155(ptr %it151)
          to label %invoke.cont180 unwind label %cleanup156

if.end150:                                        ; preds = %invoke.cont180, %invoke.cont148
  %first181 = load i32, ptr %first, align 4
  %it182 = load ptr, ptr %it, align 8
  %vtbl.addr183 = getelementptr inbounds %"class.Iterator$int", ptr %it182, i32 0, i32 0
  %vtbl184 = load ptr, ptr %vtbl.addr183, align 8, !tbaa !0
  %slot185 = getelementptr [351 x ptr], ptr %vtbl184, i64 0, i64 3
  %fn186 = load ptr, ptr %slot185, align 8
  %77 = invoke i32 %fn186(ptr %it182)
          to label %invoke.cont211 unwind label %cleanup187

cleanup156:                                       ; preds = %if.then149
  %78 = catchswitch within none [label %cleanup.dispatch158] unwind to caller

cleanup.dispatch158:                              ; preds = %cleanup156
  %79 = catchpad within %78 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup157]
  catchret from %79 to label %cleanup.run159

cleanup.run159:                                   ; preds = %cleanup.dispatch158
  %cleanup.obj160 = load ptr, ptr %exc.cleanup157, align 8
  %80 = load ptr, ptr %fe.it69, align 8
  call void @__polaron_check_live(ptr %80)
  %vtbl.addr161 = getelementptr inbounds %"class.Iterator$int", ptr %80, i32 0, i32 0
  %vtbl162 = load ptr, ptr %vtbl.addr161, align 8, !tbaa !0
  %dtor.slot163 = getelementptr [352 x ptr], ptr %vtbl162, i64 0, i64 351
  %dtor.fn164 = load ptr, ptr %dtor.slot163, align 8
  %81 = icmp ne ptr %dtor.fn164, null
  br i1 %81, label %dtor.call165, label %dtor.free166

dtor.call165:                                     ; preds = %cleanup.run159
  call void %dtor.fn164(ptr %80)
  br label %dtor.free166

dtor.free166:                                     ; preds = %dtor.call165, %cleanup.run159
  call void @__polaron_free(ptr %80)
  %82 = load ptr, ptr %fe.it8, align 8
  call void @__polaron_check_live(ptr %82)
  %vtbl.addr167 = getelementptr inbounds %"class.Iterator$int", ptr %82, i32 0, i32 0
  %vtbl168 = load ptr, ptr %vtbl.addr167, align 8, !tbaa !0
  %dtor.slot169 = getelementptr [352 x ptr], ptr %vtbl168, i64 0, i64 351
  %dtor.fn170 = load ptr, ptr %dtor.slot169, align 8
  %83 = icmp ne ptr %dtor.fn170, null
  br i1 %83, label %dtor.call171, label %dtor.free172

dtor.call171:                                     ; preds = %dtor.free166
  call void %dtor.fn170(ptr %82)
  br label %dtor.free172

dtor.free172:                                     ; preds = %dtor.call171, %dtor.free166
  call void @__polaron_free(ptr %82)
  %84 = load ptr, ptr %fe.it, align 8
  call void @__polaron_check_live(ptr %84)
  %vtbl.addr173 = getelementptr inbounds %"class.Iterator$int", ptr %84, i32 0, i32 0
  %vtbl174 = load ptr, ptr %vtbl.addr173, align 8, !tbaa !0
  %dtor.slot175 = getelementptr [352 x ptr], ptr %vtbl174, i64 0, i64 351
  %dtor.fn176 = load ptr, ptr %dtor.slot175, align 8
  %85 = icmp ne ptr %dtor.fn176, null
  br i1 %85, label %dtor.call177, label %dtor.free178

dtor.call177:                                     ; preds = %dtor.free172
  call void %dtor.fn176(ptr %84)
  br label %dtor.free178

dtor.free178:                                     ; preds = %dtor.call177, %dtor.free172
  call void @__polaron_free(ptr %84)
  store ptr %cleanup.obj160, ptr %exc.thrown179, align 8
  call void @_CxxThrowException(ptr %exc.thrown179, ptr @_TI1PEAX)
  unreachable

invoke.cont180:                                   ; preds = %if.then149
  store i32 %76, ptr %first, align 4
  br label %if.end150

cleanup187:                                       ; preds = %if.end150
  %86 = catchswitch within none [label %cleanup.dispatch189] unwind to caller

cleanup.dispatch189:                              ; preds = %cleanup187
  %87 = catchpad within %86 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.cleanup188]
  catchret from %87 to label %cleanup.run190

cleanup.run190:                                   ; preds = %cleanup.dispatch189
  %cleanup.obj191 = load ptr, ptr %exc.cleanup188, align 8
  %88 = load ptr, ptr %fe.it69, align 8
  call void @__polaron_check_live(ptr %88)
  %vtbl.addr192 = getelementptr inbounds %"class.Iterator$int", ptr %88, i32 0, i32 0
  %vtbl193 = load ptr, ptr %vtbl.addr192, align 8, !tbaa !0
  %dtor.slot194 = getelementptr [352 x ptr], ptr %vtbl193, i64 0, i64 351
  %dtor.fn195 = load ptr, ptr %dtor.slot194, align 8
  %89 = icmp ne ptr %dtor.fn195, null
  br i1 %89, label %dtor.call196, label %dtor.free197

dtor.call196:                                     ; preds = %cleanup.run190
  call void %dtor.fn195(ptr %88)
  br label %dtor.free197

dtor.free197:                                     ; preds = %dtor.call196, %cleanup.run190
  call void @__polaron_free(ptr %88)
  %90 = load ptr, ptr %fe.it8, align 8
  call void @__polaron_check_live(ptr %90)
  %vtbl.addr198 = getelementptr inbounds %"class.Iterator$int", ptr %90, i32 0, i32 0
  %vtbl199 = load ptr, ptr %vtbl.addr198, align 8, !tbaa !0
  %dtor.slot200 = getelementptr [352 x ptr], ptr %vtbl199, i64 0, i64 351
  %dtor.fn201 = load ptr, ptr %dtor.slot200, align 8
  %91 = icmp ne ptr %dtor.fn201, null
  br i1 %91, label %dtor.call202, label %dtor.free203

dtor.call202:                                     ; preds = %dtor.free197
  call void %dtor.fn201(ptr %90)
  br label %dtor.free203

dtor.free203:                                     ; preds = %dtor.call202, %dtor.free197
  call void @__polaron_free(ptr %90)
  %92 = load ptr, ptr %fe.it, align 8
  call void @__polaron_check_live(ptr %92)
  %vtbl.addr204 = getelementptr inbounds %"class.Iterator$int", ptr %92, i32 0, i32 0
  %vtbl205 = load ptr, ptr %vtbl.addr204, align 8, !tbaa !0
  %dtor.slot206 = getelementptr [352 x ptr], ptr %vtbl205, i64 0, i64 351
  %dtor.fn207 = load ptr, ptr %dtor.slot206, align 8
  %93 = icmp ne ptr %dtor.fn207, null
  br i1 %93, label %dtor.call208, label %dtor.free209

dtor.call208:                                     ; preds = %dtor.free203
  call void %dtor.fn207(ptr %92)
  br label %dtor.free209

dtor.free209:                                     ; preds = %dtor.call208, %dtor.free203
  call void @__polaron_free(ptr %92)
  store ptr %cleanup.obj191, ptr %exc.thrown210, align 8
  call void @_CxxThrowException(ptr %exc.thrown210, ptr @_TI1PEAX)
  unreachable

invoke.cont211:                                   ; preds = %if.end150
  %94 = call i32 (ptr, ...) @printf(ptr @.str.3, i32 %first181, i32 %77)
  %it212 = load ptr, ptr %it, align 8
  call void @__polaron_check_live(ptr %it212)
  %vtbl.addr213 = getelementptr inbounds %"class.Iterator$int", ptr %it212, i32 0, i32 0
  %vtbl214 = load ptr, ptr %vtbl.addr213, align 8, !tbaa !0
  %dtor.slot215 = getelementptr [352 x ptr], ptr %vtbl214, i64 0, i64 351
  %dtor.fn216 = load ptr, ptr %dtor.slot215, align 8
  %95 = icmp ne ptr %dtor.fn216, null
  br i1 %95, label %dtor.call217, label %dtor.free218

dtor.call217:                                     ; preds = %invoke.cont211
  call void %dtor.fn216(ptr %it212)
  br label %dtor.free218

dtor.free218:                                     ; preds = %dtor.call217, %invoke.cont211
  call void @__polaron_free(ptr %it212)
  %96 = load ptr, ptr %fe.it69, align 8
  call void @__polaron_check_live(ptr %96)
  %vtbl.addr219 = getelementptr inbounds %"class.Iterator$int", ptr %96, i32 0, i32 0
  %vtbl220 = load ptr, ptr %vtbl.addr219, align 8, !tbaa !0
  %dtor.slot221 = getelementptr [352 x ptr], ptr %vtbl220, i64 0, i64 351
  %dtor.fn222 = load ptr, ptr %dtor.slot221, align 8
  %97 = icmp ne ptr %dtor.fn222, null
  br i1 %97, label %dtor.call223, label %dtor.free224

dtor.call223:                                     ; preds = %dtor.free218
  call void %dtor.fn222(ptr %96)
  br label %dtor.free224

dtor.free224:                                     ; preds = %dtor.call223, %dtor.free218
  call void @__polaron_free(ptr %96)
  %98 = load ptr, ptr %fe.it8, align 8
  call void @__polaron_check_live(ptr %98)
  %vtbl.addr225 = getelementptr inbounds %"class.Iterator$int", ptr %98, i32 0, i32 0
  %vtbl226 = load ptr, ptr %vtbl.addr225, align 8, !tbaa !0
  %dtor.slot227 = getelementptr [352 x ptr], ptr %vtbl226, i64 0, i64 351
  %dtor.fn228 = load ptr, ptr %dtor.slot227, align 8
  %99 = icmp ne ptr %dtor.fn228, null
  br i1 %99, label %dtor.call229, label %dtor.free230

dtor.call229:                                     ; preds = %dtor.free224
  call void %dtor.fn228(ptr %98)
  br label %dtor.free230

dtor.free230:                                     ; preds = %dtor.call229, %dtor.free224
  call void @__polaron_free(ptr %98)
  %100 = load ptr, ptr %fe.it, align 8
  call void @__polaron_check_live(ptr %100)
  %vtbl.addr231 = getelementptr inbounds %"class.Iterator$int", ptr %100, i32 0, i32 0
  %vtbl232 = load ptr, ptr %vtbl.addr231, align 8, !tbaa !0
  %dtor.slot233 = getelementptr [352 x ptr], ptr %vtbl232, i64 0, i64 351
  %dtor.fn234 = load ptr, ptr %dtor.slot233, align 8
  %101 = icmp ne ptr %dtor.fn234, null
  br i1 %101, label %dtor.call235, label %dtor.free236

dtor.call235:                                     ; preds = %dtor.free230
  call void %dtor.fn234(ptr %100)
  br label %dtor.free236

dtor.free236:                                     ; preds = %dtor.call235, %dtor.free230
  call void @__polaron_free(ptr %100)
  ret i32 0
}

define internal i32 @"Sequences$evens$resume"(i64 %0) {
entry:
  %gen.st = inttoptr i64 %0 to ptr
  %limit = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.st, i32 0, i32 2
  %n = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.st, i32 0, i32 3
  %gen.st.addr = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.st, i32 0, i32 0
  %gen.state = load i32, ptr %gen.st.addr, align 4
  switch i32 %gen.state, label %gen.done [
    i32 0, label %gen.body
    i32 1, label %gen.resume1
  ]

gen.body:                                         ; preds = %entry
  store i32 0, ptr %n, align 4
  br label %while.cond

gen.done:                                         ; preds = %while.end, %entry
  ret i32 0

while.cond:                                       ; preds = %gen.resume1, %gen.body
  %n1 = load i32, ptr %n, align 4
  %limit2 = load i32, ptr %limit, align 4
  %1 = icmp sle i32 %n1, %limit2
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n3 = load i32, ptr %n, align 4
  %gen.cur = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.st, i32 0, i32 1
  store i32 %n3, ptr %gen.cur, align 4
  %gen.st4 = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.st, i32 0, i32 0
  store i32 1, ptr %gen.st4, align 4
  ret i32 1

while.end:                                        ; preds = %while.cond
  %gen.st.addr6 = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.st, i32 0, i32 0
  store i32 -1, ptr %gen.st.addr6, align 4
  br label %gen.done

gen.resume1:                                      ; preds = %entry
  %n5 = load i32, ptr %n, align 4
  %3 = add i32 %n5, 2
  store i32 %3, ptr %n, align 4
  br label %while.cond
}

define internal i32 @"Sequences$evens$current"(i64 %0) {
entry:
  %gen.st = inttoptr i64 %0 to ptr
  %1 = getelementptr inbounds %"Sequences$evens$genstate", ptr %gen.st, i32 0, i32 1
  %gen.cur = load i32, ptr %1, align 4
  ret i32 %gen.cur
}

define internal void @"Sequences$evens$free"(i64 %0) {
entry:
  %1 = inttoptr i64 %0 to ptr
  call void @__polaron_free(ptr %1)
  ret void
}

define internal void @"Sequences$evens$Gen.Sequences$evens$Gen"(ptr %0, i64 %1) {
entry:
  %st = alloca i64, align 8
  store i64 %1, ptr %st, align 8
  %vtbl.addr = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 0
  store ptr @"Sequences$evens$Gen.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %st1 = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 1
  %st2 = load i64, ptr %st, align 8
  store i64 %st2, ptr %st1, align 8, !tbaa !6
  %buffered = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 2
  store i32 0, ptr %buffered, align 4, !tbaa !4
  %finished = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 3
  store i32 0, ptr %finished, align 4, !tbaa !4
  ret void
}

define internal void @"Sequences$evens$Gen.pump"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %buffered = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 2
  %buffered1 = load i32, ptr %buffered, align 4, !tbaa !4
  %1 = icmp ne i32 %buffered1, 0
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %finished = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 3
  %finished2 = load i32, ptr %finished, align 4, !tbaa !4
  %2 = icmp ne i32 %finished2, 0
  br i1 %2, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end
  ret void

if.end4:                                          ; preds = %if.end
  %st = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 1
  %st5 = load i64, ptr %st, align 8, !tbaa !6
  %3 = call i32 @"Sequences$evens$resume"(i64 %st5)
  %4 = icmp ne i32 %3, 0
  br i1 %4, label %if.then6, label %if.else

if.then6:                                         ; preds = %if.end4
  %buf = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 4
  %st8 = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 1
  %st9 = load i64, ptr %st8, align 8, !tbaa !6
  %5 = call i32 @"Sequences$evens$current"(i64 %st9)
  store i32 %5, ptr %buf, align 4, !tbaa !4
  %buffered10 = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 2
  store i32 1, ptr %buffered10, align 4, !tbaa !4
  br label %if.end7

if.else:                                          ; preds = %if.end4
  %finished11 = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 3
  store i32 1, ptr %finished11, align 4, !tbaa !4
  br label %if.end7

if.end7:                                          ; preds = %if.else, %if.then6
  ret void
}

define internal i32 @"Sequences$evens$Gen.hasNext"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  call void @"Sequences$evens$Gen.pump"(ptr %0)
  %buffered = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 2
  %buffered1 = load i32, ptr %buffered, align 4, !tbaa !4
  ret i32 %buffered1
}

define internal i32 @"Sequences$evens$Gen.next"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  call void @"Sequences$evens$Gen.pump"(ptr %0)
  %buffered = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 2
  store i32 0, ptr %buffered, align 4, !tbaa !4
  %buf = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 4
  %buf1 = load i32, ptr %buf, align 4, !tbaa !4
  ret i32 %buf1
}

define internal void @"Sequences$evens$Gen.~Sequences$evens$Gen"(ptr %0) {
entry:
  %st = getelementptr inbounds %"class.Sequences$evens$Gen", ptr %0, i32 0, i32 1
  %st1 = load i64, ptr %st, align 8, !tbaa !6
  call void @"Sequences$evens$free"(i64 %st1)
  ret void
}

define internal i32 @"Sequences$primes$resume"(i64 %0) {
entry:
  %gen.st = inttoptr i64 %0 to ptr
  %n = getelementptr inbounds %"Sequences$primes$genstate", ptr %gen.st, i32 0, i32 2
  %gen.st.addr = getelementptr inbounds %"Sequences$primes$genstate", ptr %gen.st, i32 0, i32 0
  %gen.state = load i32, ptr %gen.st.addr, align 4
  switch i32 %gen.state, label %gen.done [
    i32 0, label %gen.body
    i32 1, label %gen.resume1
  ]

gen.body:                                         ; preds = %entry
  store i32 2, ptr %n, align 4
  br label %while.cond

gen.done:                                         ; preds = %while.end, %entry
  ret i32 0

while.cond:                                       ; preds = %if.end, %gen.body
  br i1 true, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n1 = load i32, ptr %n, align 4
  %1 = call i32 @Sequences.isPrime(i32 %n1)
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  %gen.st.addr5 = getelementptr inbounds %"Sequences$primes$genstate", ptr %gen.st, i32 0, i32 0
  store i32 -1, ptr %gen.st.addr5, align 4
  br label %gen.done

if.then:                                          ; preds = %while.body
  %n2 = load i32, ptr %n, align 4
  %gen.cur = getelementptr inbounds %"Sequences$primes$genstate", ptr %gen.st, i32 0, i32 1
  store i32 %n2, ptr %gen.cur, align 4
  %gen.st3 = getelementptr inbounds %"Sequences$primes$genstate", ptr %gen.st, i32 0, i32 0
  store i32 1, ptr %gen.st3, align 4
  ret i32 1

if.end:                                           ; preds = %gen.resume1, %while.body
  %n4 = load i32, ptr %n, align 4
  %3 = add i32 %n4, 1
  store i32 %3, ptr %n, align 4
  br label %while.cond

gen.resume1:                                      ; preds = %entry
  br label %if.end
}

define internal i32 @"Sequences$primes$current"(i64 %0) {
entry:
  %gen.st = inttoptr i64 %0 to ptr
  %1 = getelementptr inbounds %"Sequences$primes$genstate", ptr %gen.st, i32 0, i32 1
  %gen.cur = load i32, ptr %1, align 4
  ret i32 %gen.cur
}

define internal void @"Sequences$primes$free"(i64 %0) {
entry:
  %1 = inttoptr i64 %0 to ptr
  call void @__polaron_free(ptr %1)
  ret void
}

define internal void @"Sequences$primes$Gen.Sequences$primes$Gen"(ptr %0, i64 %1) {
entry:
  %st = alloca i64, align 8
  store i64 %1, ptr %st, align 8
  %vtbl.addr = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 0
  store ptr @"Sequences$primes$Gen.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %st1 = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 1
  %st2 = load i64, ptr %st, align 8
  store i64 %st2, ptr %st1, align 8, !tbaa !6
  %buffered = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 2
  store i32 0, ptr %buffered, align 4, !tbaa !4
  %finished = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 3
  store i32 0, ptr %finished, align 4, !tbaa !4
  ret void
}

define internal void @"Sequences$primes$Gen.pump"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %buffered = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 2
  %buffered1 = load i32, ptr %buffered, align 4, !tbaa !4
  %1 = icmp ne i32 %buffered1, 0
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %finished = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 3
  %finished2 = load i32, ptr %finished, align 4, !tbaa !4
  %2 = icmp ne i32 %finished2, 0
  br i1 %2, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end
  ret void

if.end4:                                          ; preds = %if.end
  %st = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 1
  %st5 = load i64, ptr %st, align 8, !tbaa !6
  %3 = call i32 @"Sequences$primes$resume"(i64 %st5)
  %4 = icmp ne i32 %3, 0
  br i1 %4, label %if.then6, label %if.else

if.then6:                                         ; preds = %if.end4
  %buf = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 4
  %st8 = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 1
  %st9 = load i64, ptr %st8, align 8, !tbaa !6
  %5 = call i32 @"Sequences$primes$current"(i64 %st9)
  store i32 %5, ptr %buf, align 4, !tbaa !4
  %buffered10 = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 2
  store i32 1, ptr %buffered10, align 4, !tbaa !4
  br label %if.end7

if.else:                                          ; preds = %if.end4
  %finished11 = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 3
  store i32 1, ptr %finished11, align 4, !tbaa !4
  br label %if.end7

if.end7:                                          ; preds = %if.else, %if.then6
  ret void
}

define internal i32 @"Sequences$primes$Gen.hasNext"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  call void @"Sequences$primes$Gen.pump"(ptr %0)
  %buffered = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 2
  %buffered1 = load i32, ptr %buffered, align 4, !tbaa !4
  ret i32 %buffered1
}

define internal i32 @"Sequences$primes$Gen.next"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  call void @"Sequences$primes$Gen.pump"(ptr %0)
  %buffered = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 2
  store i32 0, ptr %buffered, align 4, !tbaa !4
  %buf = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 4
  %buf1 = load i32, ptr %buf, align 4, !tbaa !4
  ret i32 %buf1
}

define internal void @"Sequences$primes$Gen.~Sequences$primes$Gen"(ptr %0) {
entry:
  %st = getelementptr inbounds %"class.Sequences$primes$Gen", ptr %0, i32 0, i32 1
  %st1 = load i64, ptr %st, align 8, !tbaa !6
  call void @"Sequences$primes$free"(i64 %st1)
  ret void
}

define internal i32 @"Countdown$ticks$resume"(i64 %0) {
entry:
  %gen.st = inttoptr i64 %0 to ptr
  %gen.self.addr = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 2
  %gen.self = load ptr, ptr %gen.self.addr, align 8
  %t = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 3
  %gen.st.addr = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 0
  %gen.state = load i32, ptr %gen.st.addr, align 4
  switch i32 %gen.state, label %gen.done [
    i32 0, label %gen.body
    i32 1, label %gen.resume1
    i32 2, label %gen.resume2
  ]

gen.body:                                         ; preds = %entry
  %from = getelementptr inbounds %class.Countdown, ptr %gen.self, i32 0, i32 1
  %from1 = load i32, ptr %from, align 4, !tbaa !4
  store i32 %from1, ptr %t, align 4
  br label %while.cond

gen.done:                                         ; preds = %entry
  ret i32 0

while.cond:                                       ; preds = %gen.resume1, %gen.body
  %t2 = load i32, ptr %t, align 4
  %1 = icmp sgt i32 %t2, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %t3 = load i32, ptr %t, align 4
  %gen.cur = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 1
  store i32 %t3, ptr %gen.cur, align 4
  %gen.st4 = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 0
  store i32 1, ptr %gen.st4, align 4
  ret i32 1

while.end:                                        ; preds = %while.cond
  %gen.cur6 = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 1
  store i32 0, ptr %gen.cur6, align 4
  %gen.st7 = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 0
  store i32 2, ptr %gen.st7, align 4
  ret i32 1

gen.resume1:                                      ; preds = %entry
  %t5 = load i32, ptr %t, align 4
  %3 = sub i32 %t5, 1
  store i32 %3, ptr %t, align 4
  br label %while.cond

gen.resume2:                                      ; preds = %entry
  %gen.st8 = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 0
  store i32 -1, ptr %gen.st8, align 4
  ret i32 0
}

define internal i32 @"Countdown$ticks$current"(i64 %0) {
entry:
  %gen.st = inttoptr i64 %0 to ptr
  %1 = getelementptr inbounds %"Countdown$ticks$genstate", ptr %gen.st, i32 0, i32 1
  %gen.cur = load i32, ptr %1, align 4
  ret i32 %gen.cur
}

define internal void @"Countdown$ticks$free"(i64 %0) {
entry:
  %1 = inttoptr i64 %0 to ptr
  call void @__polaron_free(ptr %1)
  ret void
}

define internal void @"Countdown$ticks$Gen.Countdown$ticks$Gen"(ptr %0, i64 %1) {
entry:
  %st = alloca i64, align 8
  store i64 %1, ptr %st, align 8
  %vtbl.addr = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 0
  store ptr @"Countdown$ticks$Gen.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %st1 = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 1
  %st2 = load i64, ptr %st, align 8
  store i64 %st2, ptr %st1, align 8, !tbaa !6
  %buffered = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 2
  store i32 0, ptr %buffered, align 4, !tbaa !4
  %finished = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 3
  store i32 0, ptr %finished, align 4, !tbaa !4
  ret void
}

define internal void @"Countdown$ticks$Gen.pump"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %buffered = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 2
  %buffered1 = load i32, ptr %buffered, align 4, !tbaa !4
  %1 = icmp ne i32 %buffered1, 0
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %finished = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 3
  %finished2 = load i32, ptr %finished, align 4, !tbaa !4
  %2 = icmp ne i32 %finished2, 0
  br i1 %2, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end
  ret void

if.end4:                                          ; preds = %if.end
  %st = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 1
  %st5 = load i64, ptr %st, align 8, !tbaa !6
  %3 = call i32 @"Countdown$ticks$resume"(i64 %st5)
  %4 = icmp ne i32 %3, 0
  br i1 %4, label %if.then6, label %if.else

if.then6:                                         ; preds = %if.end4
  %buf = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 4
  %st8 = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 1
  %st9 = load i64, ptr %st8, align 8, !tbaa !6
  %5 = call i32 @"Countdown$ticks$current"(i64 %st9)
  store i32 %5, ptr %buf, align 4, !tbaa !4
  %buffered10 = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 2
  store i32 1, ptr %buffered10, align 4, !tbaa !4
  br label %if.end7

if.else:                                          ; preds = %if.end4
  %finished11 = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 3
  store i32 1, ptr %finished11, align 4, !tbaa !4
  br label %if.end7

if.end7:                                          ; preds = %if.else, %if.then6
  ret void
}

define internal i32 @"Countdown$ticks$Gen.hasNext"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  call void @"Countdown$ticks$Gen.pump"(ptr %0)
  %buffered = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 2
  %buffered1 = load i32, ptr %buffered, align 4, !tbaa !4
  ret i32 %buffered1
}

define internal i32 @"Countdown$ticks$Gen.next"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  call void @"Countdown$ticks$Gen.pump"(ptr %0)
  %buffered = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 2
  store i32 0, ptr %buffered, align 4, !tbaa !4
  %buf = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 4
  %buf1 = load i32, ptr %buf, align 4, !tbaa !4
  ret i32 %buf1
}

define internal void @"Countdown$ticks$Gen.~Countdown$ticks$Gen"(ptr %0) {
entry:
  %st = getelementptr inbounds %"class.Countdown$ticks$Gen", ptr %0, i32 0, i32 1
  %st1 = load i64, ptr %st, align 8, !tbaa !6
  call void @"Countdown$ticks$free"(i64 %st1)
  ret void
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

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare void @__polaron_free(ptr)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
