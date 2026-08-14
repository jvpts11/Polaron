; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/zoned_datetime.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/zoned_datetime.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }
%class.Duration = type { ptr, i64 }
%class.Instant = type { ptr, i64 }
%class.ZoneOffset = type { ptr, i32 }
%class.ZonedDateTime = type { ptr, ptr, ptr }
%class.Date = type { ptr, i32, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ZonedDateTime.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @ZonedDateTime.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @ZonedDateTime.toInstant, ptr @ZonedDateTime.offset, ptr @ZonedDateTime.localSecs, ptr @ZonedDateTime.epochDay, ptr @ZonedDateTime.secondOfDay, ptr @ZonedDateTime.year, ptr @ZonedDateTime.month, ptr @ZonedDateTime.day, ptr @ZonedDateTime.hour, ptr @ZonedDateTime.minute, ptr @ZonedDateTime.second, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@Instant.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Instant.plus, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Instant.toEpochMillis, ptr @Instant.isBefore, ptr @Instant.isAfter, ptr @Instant.since, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Date.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Date.year, ptr @Date.month, ptr @Date.day, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Date.toEpochDay, ptr @Date.dayOfWeek, ptr @Date.addDays, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Duration.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Duration.compareTo, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Duration.toMillis, ptr @Duration.toSeconds, ptr @Duration.plus, ptr @Duration.minus, ptr @"Duration.TComparer$lessThan", ptr @Duration.lessThan, ptr @"Duration.TComparer$atMost", ptr @Duration.atMost, ptr @"Duration.TComparer$greaterThan", ptr @Duration.greaterThan, ptr @"Duration.TComparer$atLeast", ptr @Duration.atLeast, ptr @"Duration.TComparer$sameOrder", ptr @Duration.sameOrder, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ZoneOffset.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @ZoneOffset.totalSeconds, ptr @ZoneOffset.id, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [15 x i8] c"a=%d-%d-%d %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"b=%d-%d-%d %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1306 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1307 = private global %String { i64 16, ptr @.strdata.1306, i64 0 }
@.strdata.1308 = private constant [17 x i8] c"division by zero\00"
@.strobj.1309 = private global %String { i64 16, ptr @.strdata.1308, i64 0 }
@.strdata.3817 = private constant [2 x i8] c"Z\00"
@.strobj.3818 = private global %String { i64 1, ptr @.strdata.3817, i64 0 }
@.strdata.3819 = private constant [2 x i8] c"+\00"
@.strobj.3820 = private global %String { i64 1, ptr @.strdata.3819, i64 0 }
@.strdata.3821 = private constant [2 x i8] c"-\00"
@.strobj.3822 = private global %String { i64 1, ptr @.strdata.3821, i64 0 }
@.strdata.3823 = private constant [2 x i8] c"0\00"
@.strobj.3824 = private global %String { i64 1, ptr @.strdata.3823, i64 0 }
@.strdata.3825 = private constant [2 x i8] c":\00"
@.strobj.3826 = private global %String { i64 1, ptr @.strdata.3825, i64 0 }
@.strdata.3827 = private constant [2 x i8] c"0\00"
@.strobj.3828 = private global %String { i64 1, ptr @.strdata.3827, i64 0 }
@.strdata.3829 = private constant [2 x i8] c"-\00"
@.strobj.3830 = private global %String { i64 1, ptr @.strdata.3829, i64 0 }
@.strdata.3831 = private constant [2 x i8] c"0\00"
@.strobj.3832 = private global %String { i64 1, ptr @.strdata.3831, i64 0 }
@.strdata.3833 = private constant [2 x i8] c"-\00"
@.strobj.3834 = private global %String { i64 1, ptr @.strdata.3833, i64 0 }
@.strdata.3835 = private constant [2 x i8] c"0\00"
@.strobj.3836 = private global %String { i64 1, ptr @.strdata.3835, i64 0 }
@.strdata.3837 = private constant [2 x i8] c"T\00"
@.strobj.3838 = private global %String { i64 1, ptr @.strdata.3837, i64 0 }
@.strdata.3839 = private constant [2 x i8] c"0\00"
@.strobj.3840 = private global %String { i64 1, ptr @.strdata.3839, i64 0 }
@.strdata.3841 = private constant [2 x i8] c":\00"
@.strobj.3842 = private global %String { i64 1, ptr @.strdata.3841, i64 0 }
@.strdata.3843 = private constant [2 x i8] c"0\00"
@.strobj.3844 = private global %String { i64 1, ptr @.strdata.3843, i64 0 }
@.strdata.3845 = private constant [2 x i8] c":\00"
@.strobj.3846 = private global %String { i64 1, ptr @.strdata.3845, i64 0 }
@.strdata.3847 = private constant [2 x i8] c"0\00"
@.strobj.3848 = private global %String { i64 1, ptr @.strdata.3847, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }
@.strdata.5309 = private constant [1 x i8] zeroinitializer
@.strobj.5310 = private global %String { i64 0, ptr @.strdata.5309, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
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
  %16 = call ptr @Instant.ofEpochMillis(i64 0)
  %17 = call ptr @ZoneOffset.utc()
  %18 = call ptr @ZonedDateTime.ofInstant(ptr %16, ptr %17)
  store ptr %18, ptr %a, align 8
  %19 = call ptr @Instant.ofEpochMillis(i64 0)
  %20 = call ptr @ZoneOffset.ofHours(i32 -3)
  %21 = call ptr @ZonedDateTime.ofInstant(ptr %19, ptr %20)
  store ptr %21, ptr %b, align 8
  %a1 = load ptr, ptr %a, align 8
  %22 = call i32 @ZonedDateTime.year(ptr %a1)
  %a2 = load ptr, ptr %a, align 8
  %23 = call i32 @ZonedDateTime.month(ptr %a2)
  %a3 = load ptr, ptr %a, align 8
  %24 = call i32 @ZonedDateTime.day(ptr %a3)
  %a4 = load ptr, ptr %a, align 8
  %25 = call i32 @ZonedDateTime.hour(ptr %a4)
  %26 = call i32 (ptr, ...) @printf(ptr @.str, i32 %22, i32 %23, i32 %24, i32 %25)
  %b5 = load ptr, ptr %b, align 8
  %27 = call i32 @ZonedDateTime.year(ptr %b5)
  %b6 = load ptr, ptr %b, align 8
  %28 = call i32 @ZonedDateTime.month(ptr %b6)
  %b7 = load ptr, ptr %b, align 8
  %29 = call i32 @ZonedDateTime.day(ptr %b7)
  %b8 = load ptr, ptr %b, align 8
  %30 = call i32 @ZonedDateTime.hour(ptr %b8)
  %31 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %27, i32 %28, i32 %29, i32 %30)
  %b9 = load ptr, ptr %b, align 8
  %32 = call ptr @ZonedDateTime.toString(ptr %b9)
  %str.data = getelementptr inbounds %String, ptr %32, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %33 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr %data)
  call void @__polaron_str_free(ptr %32)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1307)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1309)
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

define internal void @Duration.Duration(ptr %0, i64 %1) {
entry:
  %millis = alloca i64, align 8
  store i64 %1, ptr %millis, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 0
  store ptr @Duration.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %millis1 = load i64, ptr %millis, align 8
  store i64 %millis1, ptr %ms, align 8, !tbaa !6
  ret void
}

define internal i32 @Duration.compareTo(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %theirs = alloca i64, align 8
  %mine = alloca i64, align 8
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
  store i64 %ms1, ptr %mine, align 8
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Duration.toMillis(ptr %other2)
  store i64 %3, ptr %theirs, align 8
  %mine3 = load i64, ptr %mine, align 8
  %theirs4 = load i64, ptr %theirs, align 8
  %4 = icmp slt i64 %mine3, %theirs4
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 -1

if.end:                                           ; preds = %entry
  %mine5 = load i64, ptr %mine, align 8
  %theirs6 = load i64, ptr %theirs, align 8
  %6 = icmp sgt i64 %mine5, %theirs6
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end
  ret i32 1

if.end8:                                          ; preds = %if.end
  ret i32 0
}

define internal i64 @Duration.toMillis(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
  ret i64 %ms1
}

define internal i64 @Duration.toSeconds(ptr nonnull align 8 dereferenceable(16) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
  %1 = icmp eq i64 %ms1, -9223372036854775808
  %2 = and i1 %1, false
  %3 = or i1 false, %2
  br i1 %3, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %4 = sdiv i64 %ms1, 1000
  ret i64 %4
}

define internal ptr @Duration.plus(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %Duration.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Duration.toMillis(ptr %other2)
  %4 = add i64 %ms1, %3
  call void @Duration.Duration(ptr %Duration.obj, i64 %4)
  ret ptr %Duration.obj
}

define internal ptr @Duration.minus(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %Duration.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  %ms = getelementptr inbounds %class.Duration, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8, !tbaa !6
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Duration.toMillis(ptr %other2)
  %4 = sub i64 %ms1, %3
  call void @Duration.Duration(ptr %Duration.obj, i64 %4)
  ret ptr %Duration.obj
}

define internal i32 @"Duration.TComparer$lessThan"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp slt i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.lessThan(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp slt i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @"Duration.TComparer$atMost"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sle i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.atMost(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sle i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @"Duration.TComparer$greaterThan"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sgt i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.greaterThan(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sgt i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @"Duration.TComparer$atLeast"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sge i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.atLeast(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp sge i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @"Duration.TComparer$sameOrder"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Duration.sameOrder(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %other, align 8
  %other1 = load ptr, ptr %other, align 8
  %3 = call i32 @Duration.compareTo(ptr %0, ptr %other1)
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal void @Instant.Instant(ptr %0, i64 %1) {
entry:
  %ms = alloca i64, align 8
  store i64 %1, ptr %ms, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 0
  store ptr @Instant.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %ms1 = load i64, ptr %ms, align 8
  store i64 %ms1, ptr %epochMs, align 8, !tbaa !6
  ret void
}

define internal ptr @Instant.ofEpochMillis(i64 %0) {
entry:
  %ms = alloca i64, align 8
  store i64 %0, ptr %ms, align 8
  %Instant.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  %ms1 = load i64, ptr %ms, align 8
  call void @Instant.Instant(ptr %Instant.obj, i64 %ms1)
  ret ptr %Instant.obj
}

define internal i64 @Instant.toEpochMillis(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !6
  ret i64 %epochMs1
}

define internal i32 @Instant.isBefore(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Instant.copy = alloca %class.Instant, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Instant.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy, ptr %other, align 8
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !6
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Instant.toEpochMillis(ptr %other2)
  %4 = icmp slt i64 %epochMs1, %3
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal i32 @Instant.isAfter(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Instant.copy = alloca %class.Instant, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Instant.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy, ptr %other, align 8
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !6
  %other2 = load ptr, ptr %other, align 8
  %3 = call i64 @Instant.toEpochMillis(ptr %other2)
  %4 = icmp sgt i64 %epochMs1, %3
  %5 = zext i1 %4 to i32
  ret i32 %5
}

define internal ptr @Instant.plus(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Duration.copy = alloca %class.Duration, align 8
  %d = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Duration.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  store ptr %Duration.copy, ptr %d, align 8
  %Instant.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !6
  %d2 = load ptr, ptr %d, align 8
  %3 = call i64 @Duration.toMillis(ptr %d2)
  %4 = add i64 %epochMs1, %3
  call void @Instant.Instant(ptr %Instant.obj, i64 %4)
  ret ptr %Instant.obj
}

define internal ptr @Instant.since(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Instant.copy = alloca %class.Instant, align 8
  %earlier = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Instant.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy, ptr %earlier, align 8
  %Duration.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Duration, ptr null, i64 1) to i64))
  %epochMs = getelementptr inbounds %class.Instant, ptr %0, i32 0, i32 1
  %epochMs1 = load i64, ptr %epochMs, align 8, !tbaa !6
  %earlier2 = load ptr, ptr %earlier, align 8
  %3 = call i64 @Instant.toEpochMillis(ptr %earlier2)
  %4 = sub i64 %epochMs1, %3
  call void @Duration.Duration(ptr %Duration.obj, i64 %4)
  ret ptr %Duration.obj
}

define internal void @ZoneOffset.ZoneOffset(ptr %0, i32 %1) {
entry:
  %totalSeconds = alloca i32, align 4
  store i32 %1, ptr %totalSeconds, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ZoneOffset, ptr %0, i32 0, i32 0
  store ptr @ZoneOffset.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %secs = getelementptr inbounds %class.ZoneOffset, ptr %0, i32 0, i32 1
  %totalSeconds1 = load i32, ptr %totalSeconds, align 4
  store i32 %totalSeconds1, ptr %secs, align 4, !tbaa !4
  ret void
}

define internal ptr @ZoneOffset.ofHours(i32 %0) {
entry:
  %h = alloca i32, align 4
  store i32 %0, ptr %h, align 4
  %ZoneOffset.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ZoneOffset, ptr null, i64 1) to i64))
  %h1 = load i32, ptr %h, align 4
  %1 = mul i32 %h1, 3600
  call void @ZoneOffset.ZoneOffset(ptr %ZoneOffset.obj, i32 %1)
  ret ptr %ZoneOffset.obj
}

define internal ptr @ZoneOffset.utc() {
entry:
  %ZoneOffset.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ZoneOffset, ptr null, i64 1) to i64))
  call void @ZoneOffset.ZoneOffset(ptr %ZoneOffset.obj, i32 0)
  ret ptr %ZoneOffset.obj
}

define internal i32 @ZoneOffset.totalSeconds(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %secs = getelementptr inbounds %class.ZoneOffset, ptr %0, i32 0, i32 1
  %secs1 = load i32, ptr %secs, align 4, !tbaa !4
  ret i32 %secs1
}

define internal ptr @ZoneOffset.id(ptr nonnull align 8 dereferenceable(16) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %sb = alloca ptr, align 8
  %mm = alloca i32, align 4
  %exc.thrown19 = alloca ptr, align 8
  %exc.thrown15 = alloca ptr, align 8
  %hh = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %sign = alloca ptr, align 8
  %t = alloca i32, align 4
  %secs = getelementptr inbounds %class.ZoneOffset, ptr %0, i32 0, i32 1
  %secs1 = load i32, ptr %secs, align 4, !tbaa !4
  %1 = icmp eq i32 %secs1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.3818)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %secs2 = getelementptr inbounds %class.ZoneOffset, ptr %0, i32 0, i32 1
  %secs3 = load i32, ptr %secs2, align 4, !tbaa !4
  store i32 %secs3, ptr %t, align 4
  %strcpy4 = call ptr @__polaron_str_copy(ptr @.strobj.3820)
  store ptr %strcpy4, ptr %sign, align 8
  %t5 = load i32, ptr %t, align 4
  %3 = icmp slt i32 %t5, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then6, label %if.end7

if.then6:                                         ; preds = %if.end
  %strcpy8 = call ptr @__polaron_str_copy(ptr @.strobj.3822)
  %5 = load ptr, ptr %sign, align 8
  call void @__polaron_str_free(ptr %5)
  store ptr %strcpy8, ptr %sign, align 8
  %t9 = load i32, ptr %t, align 4
  %6 = sub i32 0, %t9
  store i32 %6, ptr %t, align 4
  br label %if.end7

if.end7:                                          ; preds = %if.then6, %if.end
  %t10 = load i32, ptr %t, align 4
  %7 = icmp eq i32 %t10, -2147483648
  %8 = and i1 %7, false
  %9 = or i1 false, %8
  br i1 %9, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end7
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end7
  %10 = sdiv i32 %t10, 3600
  store i32 %10, ptr %hh, align 4
  %t11 = load i32, ptr %t, align 4
  %11 = icmp eq i32 %t11, -2147483648
  %12 = and i1 %11, false
  %13 = or i1 false, %12
  br i1 %13, label %div.bad12, label %div.ok13

div.bad12:                                        ; preds = %div.ok
  %exc14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc14)
  store ptr %exc14, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

div.ok13:                                         ; preds = %div.ok
  %14 = sdiv i32 %t11, 60
  %15 = icmp eq i32 %14, -2147483648
  %16 = and i1 %15, false
  %17 = or i1 false, %16
  br i1 %17, label %div.bad16, label %div.ok17

div.bad16:                                        ; preds = %div.ok13
  %exc18 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc18)
  store ptr %exc18, ptr %exc.thrown19, align 8
  call void @_CxxThrowException(ptr %exc.thrown19, ptr @_TI1PEAX)
  unreachable

div.ok17:                                         ; preds = %div.ok13
  %18 = srem i32 %14, 60
  store i32 %18, ptr %mm, align 4
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb20 = load ptr, ptr %sb, align 8
  %sign21 = load ptr, ptr %sign, align 8
  %19 = call ptr @StringBuilder.append(ptr %sb20, ptr %sign21)
  %hh22 = load i32, ptr %hh, align 4
  %20 = icmp slt i32 %hh22, 10
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then23, label %if.end24

if.then23:                                        ; preds = %div.ok17
  %sb25 = load ptr, ptr %sb, align 8
  %22 = call ptr @StringBuilder.append(ptr %sb25, ptr @.strobj.3824)
  br label %if.end24

if.end24:                                         ; preds = %if.then23, %div.ok17
  %sb26 = load ptr, ptr %sb, align 8
  %hh27 = load i32, ptr %hh, align 4
  %23 = call ptr @StringBuilder.appendInt(ptr %sb26, i32 %hh27)
  %sb28 = load ptr, ptr %sb, align 8
  %24 = call ptr @StringBuilder.append(ptr %sb28, ptr @.strobj.3826)
  %mm29 = load i32, ptr %mm, align 4
  %25 = icmp slt i32 %mm29, 10
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then30, label %if.end31

if.then30:                                        ; preds = %if.end24
  %sb32 = load ptr, ptr %sb, align 8
  %27 = call ptr @StringBuilder.append(ptr %sb32, ptr @.strobj.3828)
  br label %if.end31

if.end31:                                         ; preds = %if.then30, %if.end24
  %sb33 = load ptr, ptr %sb, align 8
  %mm34 = load i32, ptr %mm, align 4
  %28 = call ptr @StringBuilder.appendInt(ptr %sb33, i32 %mm34)
  %sb35 = load ptr, ptr %sb, align 8
  %29 = call ptr @StringBuilder.toString(ptr %sb35)
  %strcpy36 = call ptr @__polaron_str_copy(ptr %29)
  call void @__polaron_str_free(ptr %29)
  %30 = load ptr, ptr %sign, align 8
  call void @__polaron_str_free(ptr %30)
  ret ptr %strcpy36
}

define internal void @ZonedDateTime.ZonedDateTime(ptr %0, ptr %1, ptr %2) {
entry:
  %ZoneOffset.copy = alloca %class.ZoneOffset, align 8
  %offset = alloca ptr, align 8
  %Instant.copy = alloca %class.Instant, align 8
  %instant = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %Instant.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy, ptr %instant, align 8
  %4 = call ptr @memcpy(ptr %ZoneOffset.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.ZoneOffset, ptr null, i64 1) to i64))
  store ptr %ZoneOffset.copy, ptr %offset, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 0
  store ptr @ZonedDateTime.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %point = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 1
  store ptr null, ptr %point, align 8, !tbaa !0
  %zone = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 2
  store ptr null, ptr %zone, align 8, !tbaa !0
  %point1 = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 1
  %instant2 = load ptr, ptr %instant, align 8
  %Instant.copy3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  %5 = call ptr @memcpy(ptr %Instant.copy3, ptr %instant2, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy3, ptr %point1, align 8, !tbaa !0
  %zone4 = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 2
  %offset5 = load ptr, ptr %offset, align 8
  %ZoneOffset.copy6 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ZoneOffset, ptr null, i64 1) to i64))
  %6 = call ptr @memcpy(ptr %ZoneOffset.copy6, ptr %offset5, i64 ptrtoint (ptr getelementptr (%class.ZoneOffset, ptr null, i64 1) to i64))
  store ptr %ZoneOffset.copy6, ptr %zone4, align 8, !tbaa !0
  ret void
}

define internal ptr @ZonedDateTime.ofInstant(ptr %0, ptr %1) {
entry:
  %ZoneOffset.copy = alloca %class.ZoneOffset, align 8
  %off = alloca ptr, align 8
  %Instant.copy = alloca %class.Instant, align 8
  %i = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Instant.copy, ptr %0, i64 ptrtoint (ptr getelementptr (%class.Instant, ptr null, i64 1) to i64))
  store ptr %Instant.copy, ptr %i, align 8
  %3 = call ptr @memcpy(ptr %ZoneOffset.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.ZoneOffset, ptr null, i64 1) to i64))
  store ptr %ZoneOffset.copy, ptr %off, align 8
  %ZonedDateTime.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ZonedDateTime, ptr null, i64 1) to i64))
  %i1 = load ptr, ptr %i, align 8
  %off2 = load ptr, ptr %off, align 8
  call void @ZonedDateTime.ZonedDateTime(ptr %ZonedDateTime.obj, ptr %i1, ptr %off2)
  ret ptr %ZonedDateTime.obj
}

define internal ptr @ZonedDateTime.toInstant(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %point = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 1
  %point1 = load ptr, ptr %point, align 8, !tbaa !0
  ret ptr %point1
}

define internal ptr @ZonedDateTime.offset(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %zone = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 2
  %zone1 = load ptr, ptr %zone, align 8, !tbaa !0
  ret ptr %zone1
}

define internal i64 @ZonedDateTime.localSecs(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %point = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 1
  %point1 = load ptr, ptr %point, align 8, !tbaa !0
  %1 = call i64 @Instant.toEpochMillis(ptr %point1)
  %2 = icmp eq i64 %1, -9223372036854775808
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
  %5 = sdiv i64 %1, 1000
  %zone = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 2
  %zone2 = load ptr, ptr %zone, align 8, !tbaa !0
  %6 = call i32 @ZoneOffset.totalSeconds(ptr %zone2)
  %7 = sext i32 %6 to i64
  %8 = add i64 %5, %7
  ret i64 %8
}

define internal i64 @ZonedDateTime.epochDay(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %sod = alloca i64, align 8
  %day = alloca i64, align 8
  %exc.thrown = alloca ptr, align 8
  %ls = alloca i64, align 8
  %1 = call i64 @ZonedDateTime.localSecs(ptr %0)
  store i64 %1, ptr %ls, align 8
  %ls1 = load i64, ptr %ls, align 8
  %2 = icmp eq i64 %ls1, -9223372036854775808
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
  %5 = sdiv i64 %ls1, 86400
  store i64 %5, ptr %day, align 8
  %ls2 = load i64, ptr %ls, align 8
  %day3 = load i64, ptr %day, align 8
  %6 = mul i64 %day3, 86400
  %7 = sub i64 %ls2, %6
  store i64 %7, ptr %sod, align 8
  %sod4 = load i64, ptr %sod, align 8
  %8 = icmp slt i64 %sod4, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %div.ok
  %day5 = load i64, ptr %day, align 8
  %10 = sub i64 %day5, 1
  store i64 %10, ptr %day, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %div.ok
  %day6 = load i64, ptr %day, align 8
  ret i64 %day6
}

define internal i32 @ZonedDateTime.secondOfDay(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %sod = alloca i64, align 8
  %day = alloca i64, align 8
  %exc.thrown = alloca ptr, align 8
  %ls = alloca i64, align 8
  %1 = call i64 @ZonedDateTime.localSecs(ptr %0)
  store i64 %1, ptr %ls, align 8
  %ls1 = load i64, ptr %ls, align 8
  %2 = icmp eq i64 %ls1, -9223372036854775808
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
  %5 = sdiv i64 %ls1, 86400
  store i64 %5, ptr %day, align 8
  %ls2 = load i64, ptr %ls, align 8
  %day3 = load i64, ptr %day, align 8
  %6 = mul i64 %day3, 86400
  %7 = sub i64 %ls2, %6
  store i64 %7, ptr %sod, align 8
  %sod4 = load i64, ptr %sod, align 8
  %8 = icmp slt i64 %sod4, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %div.ok
  %sod5 = load i64, ptr %sod, align 8
  %10 = add i64 %sod5, 86400
  store i64 %10, ptr %sod, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %div.ok
  %sod6 = load i64, ptr %sod, align 8
  %11 = trunc i64 %sod6 to i32
  ret i32 %11
}

define internal i32 @ZonedDateTime.year(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %1 = call i64 @ZonedDateTime.epochDay(ptr %0)
  %2 = trunc i64 %1 to i32
  %3 = call ptr @Date.fromEpochDay(i32 %2)
  %4 = call i32 @Date.year(ptr %3)
  ret i32 %4
}

define internal i32 @ZonedDateTime.month(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %1 = call i64 @ZonedDateTime.epochDay(ptr %0)
  %2 = trunc i64 %1 to i32
  %3 = call ptr @Date.fromEpochDay(i32 %2)
  %4 = call i32 @Date.month(ptr %3)
  ret i32 %4
}

define internal i32 @ZonedDateTime.day(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %1 = call i64 @ZonedDateTime.epochDay(ptr %0)
  %2 = trunc i64 %1 to i32
  %3 = call ptr @Date.fromEpochDay(i32 %2)
  %4 = call i32 @Date.day(ptr %3)
  ret i32 %4
}

define internal i32 @ZonedDateTime.hour(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %1 = call i32 @ZonedDateTime.secondOfDay(ptr %0)
  %2 = icmp eq i32 %1, -2147483648
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
  %5 = sdiv i32 %1, 3600
  ret i32 %5
}

define internal i32 @ZonedDateTime.minute(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown4 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %1 = call i32 @ZonedDateTime.secondOfDay(ptr %0)
  %2 = icmp eq i32 %1, -2147483648
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
  %5 = sdiv i32 %1, 60
  %6 = icmp eq i32 %5, -2147483648
  %7 = and i1 %6, false
  %8 = or i1 false, %7
  br i1 %8, label %div.bad1, label %div.ok2

div.bad1:                                         ; preds = %div.ok
  %exc3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc3)
  store ptr %exc3, ptr %exc.thrown4, align 8
  call void @_CxxThrowException(ptr %exc.thrown4, ptr @_TI1PEAX)
  unreachable

div.ok2:                                          ; preds = %div.ok
  %9 = srem i32 %5, 60
  ret i32 %9
}

define internal i32 @ZonedDateTime.second(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %1 = call i32 @ZonedDateTime.secondOfDay(ptr %0)
  %2 = icmp eq i32 %1, -2147483648
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
  %5 = srem i32 %1, 60
  ret i32 %5
}

define internal ptr @ZonedDateTime.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %ss = alloca i32, align 4
  %mi = alloca i32, align 4
  %hh = alloca i32, align 4
  %dd = alloca i32, align 4
  %mo = alloca i32, align 4
  %sb = alloca ptr, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb1 = load ptr, ptr %sb, align 8
  %1 = call i32 @ZonedDateTime.year(ptr %0)
  %2 = call ptr @StringBuilder.appendInt(ptr %sb1, i32 %1)
  %sb2 = load ptr, ptr %sb, align 8
  %3 = call ptr @StringBuilder.append(ptr %sb2, ptr @.strobj.3830)
  %4 = call i32 @ZonedDateTime.month(ptr %0)
  store i32 %4, ptr %mo, align 4
  %mo3 = load i32, ptr %mo, align 4
  %5 = icmp slt i32 %mo3, 10
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %sb4 = load ptr, ptr %sb, align 8
  %7 = call ptr @StringBuilder.append(ptr %sb4, ptr @.strobj.3832)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %sb5 = load ptr, ptr %sb, align 8
  %mo6 = load i32, ptr %mo, align 4
  %8 = call ptr @StringBuilder.appendInt(ptr %sb5, i32 %mo6)
  %sb7 = load ptr, ptr %sb, align 8
  %9 = call ptr @StringBuilder.append(ptr %sb7, ptr @.strobj.3834)
  %10 = call i32 @ZonedDateTime.day(ptr %0)
  store i32 %10, ptr %dd, align 4
  %dd8 = load i32, ptr %dd, align 4
  %11 = icmp slt i32 %dd8, 10
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then9, label %if.end10

if.then9:                                         ; preds = %if.end
  %sb11 = load ptr, ptr %sb, align 8
  %13 = call ptr @StringBuilder.append(ptr %sb11, ptr @.strobj.3836)
  br label %if.end10

if.end10:                                         ; preds = %if.then9, %if.end
  %sb12 = load ptr, ptr %sb, align 8
  %dd13 = load i32, ptr %dd, align 4
  %14 = call ptr @StringBuilder.appendInt(ptr %sb12, i32 %dd13)
  %sb14 = load ptr, ptr %sb, align 8
  %15 = call ptr @StringBuilder.append(ptr %sb14, ptr @.strobj.3838)
  %16 = call i32 @ZonedDateTime.hour(ptr %0)
  store i32 %16, ptr %hh, align 4
  %hh15 = load i32, ptr %hh, align 4
  %17 = icmp slt i32 %hh15, 10
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then16, label %if.end17

if.then16:                                        ; preds = %if.end10
  %sb18 = load ptr, ptr %sb, align 8
  %19 = call ptr @StringBuilder.append(ptr %sb18, ptr @.strobj.3840)
  br label %if.end17

if.end17:                                         ; preds = %if.then16, %if.end10
  %sb19 = load ptr, ptr %sb, align 8
  %hh20 = load i32, ptr %hh, align 4
  %20 = call ptr @StringBuilder.appendInt(ptr %sb19, i32 %hh20)
  %sb21 = load ptr, ptr %sb, align 8
  %21 = call ptr @StringBuilder.append(ptr %sb21, ptr @.strobj.3842)
  %22 = call i32 @ZonedDateTime.minute(ptr %0)
  store i32 %22, ptr %mi, align 4
  %mi22 = load i32, ptr %mi, align 4
  %23 = icmp slt i32 %mi22, 10
  %24 = zext i1 %23 to i32
  br i1 %23, label %if.then23, label %if.end24

if.then23:                                        ; preds = %if.end17
  %sb25 = load ptr, ptr %sb, align 8
  %25 = call ptr @StringBuilder.append(ptr %sb25, ptr @.strobj.3844)
  br label %if.end24

if.end24:                                         ; preds = %if.then23, %if.end17
  %sb26 = load ptr, ptr %sb, align 8
  %mi27 = load i32, ptr %mi, align 4
  %26 = call ptr @StringBuilder.appendInt(ptr %sb26, i32 %mi27)
  %sb28 = load ptr, ptr %sb, align 8
  %27 = call ptr @StringBuilder.append(ptr %sb28, ptr @.strobj.3846)
  %28 = call i32 @ZonedDateTime.second(ptr %0)
  store i32 %28, ptr %ss, align 4
  %ss29 = load i32, ptr %ss, align 4
  %29 = icmp slt i32 %ss29, 10
  %30 = zext i1 %29 to i32
  br i1 %29, label %if.then30, label %if.end31

if.then30:                                        ; preds = %if.end24
  %sb32 = load ptr, ptr %sb, align 8
  %31 = call ptr @StringBuilder.append(ptr %sb32, ptr @.strobj.3848)
  br label %if.end31

if.end31:                                         ; preds = %if.then30, %if.end24
  %sb33 = load ptr, ptr %sb, align 8
  %ss34 = load i32, ptr %ss, align 4
  %32 = call ptr @StringBuilder.appendInt(ptr %sb33, i32 %ss34)
  %sb35 = load ptr, ptr %sb, align 8
  %zone = getelementptr inbounds %class.ZonedDateTime, ptr %0, i32 0, i32 2
  %zone36 = load ptr, ptr %zone, align 8, !tbaa !0
  %33 = call ptr @ZoneOffset.id(ptr %zone36)
  %34 = call ptr @StringBuilder.append(ptr %sb35, ptr %33)
  call void @__polaron_str_free(ptr %33)
  %sb37 = load ptr, ptr %sb, align 8
  %35 = call ptr @StringBuilder.toString(ptr %sb37)
  %strcpy = call ptr @__polaron_str_copy(ptr %35)
  call void @__polaron_str_free(ptr %35)
  ret ptr %strcpy
}

define internal void @Date.Date(ptr %0, i32 %1, i32 %2, i32 %3) {
entry:
  %day = alloca i32, align 4
  %month = alloca i32, align 4
  %year = alloca i32, align 4
  store i32 %1, ptr %year, align 4
  store i32 %2, ptr %month, align 4
  store i32 %3, ptr %day, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 0
  store ptr @Date.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %y = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 1
  %year1 = load i32, ptr %year, align 4
  store i32 %year1, ptr %y, align 4, !tbaa !4
  %mo = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 2
  %month2 = load i32, ptr %month, align 4
  store i32 %month2, ptr %mo, align 4, !tbaa !4
  %d = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 3
  %day3 = load i32, ptr %day, align 4
  store i32 %day3, ptr %d, align 4, !tbaa !4
  ret void
}

define internal i32 @Date.year(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %y = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 1
  %y1 = load i32, ptr %y, align 4, !tbaa !4
  ret i32 %y1
}

define internal i32 @Date.month(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %mo = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 2
  %mo1 = load i32, ptr %mo, align 4, !tbaa !4
  ret i32 %mo1
}

define internal i32 @Date.day(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %d = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 3
  %d1 = load i32, ptr %d, align 4, !tbaa !4
  ret i32 %d1
}

define internal i32 @Date.toEpochDay(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %doe = alloca i32, align 4
  %exc.thrown30 = alloca ptr, align 8
  %exc.thrown25 = alloca ptr, align 8
  %doy = alloca i32, align 4
  %exc.thrown18 = alloca ptr, align 8
  %mp = alloca i32, align 4
  %yoe = alloca i32, align 4
  %era = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %yy = alloca i32, align 4
  %y = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 1
  %y1 = load i32, ptr %y, align 4, !tbaa !4
  store i32 %y1, ptr %yy, align 4
  %mo = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 2
  %mo2 = load i32, ptr %mo, align 4, !tbaa !4
  %1 = icmp sle i32 %mo2, 2
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %yy3 = load i32, ptr %yy, align 4
  %3 = sub i32 %yy3, 1
  store i32 %3, ptr %yy, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %yy4 = load i32, ptr %yy, align 4
  %4 = icmp eq i32 %yy4, -2147483648
  %5 = and i1 %4, false
  %6 = or i1 false, %5
  br i1 %6, label %div.bad, label %div.ok

div.bad:                                          ; preds = %if.end
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end
  %7 = sdiv i32 %yy4, 400
  store i32 %7, ptr %era, align 4
  %yy5 = load i32, ptr %yy, align 4
  %era6 = load i32, ptr %era, align 4
  %8 = mul i32 %era6, 400
  %9 = sub i32 %yy5, %8
  store i32 %9, ptr %yoe, align 4
  %mo7 = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 2
  %mo8 = load i32, ptr %mo7, align 4, !tbaa !4
  store i32 %mo8, ptr %mp, align 4
  %mp9 = load i32, ptr %mp, align 4
  %10 = icmp sgt i32 %mp9, 2
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then10, label %if.else

if.then10:                                        ; preds = %div.ok
  %mp12 = load i32, ptr %mp, align 4
  %12 = sub i32 %mp12, 3
  store i32 %12, ptr %mp, align 4
  br label %if.end11

if.else:                                          ; preds = %div.ok
  %mp13 = load i32, ptr %mp, align 4
  %13 = add i32 %mp13, 9
  store i32 %13, ptr %mp, align 4
  br label %if.end11

if.end11:                                         ; preds = %if.else, %if.then10
  %mp14 = load i32, ptr %mp, align 4
  %14 = mul i32 153, %mp14
  %15 = add i32 %14, 2
  %16 = icmp eq i32 %15, -2147483648
  %17 = and i1 %16, false
  %18 = or i1 false, %17
  br i1 %18, label %div.bad15, label %div.ok16

div.bad15:                                        ; preds = %if.end11
  %exc17 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc17)
  store ptr %exc17, ptr %exc.thrown18, align 8
  call void @_CxxThrowException(ptr %exc.thrown18, ptr @_TI1PEAX)
  unreachable

div.ok16:                                         ; preds = %if.end11
  %19 = sdiv i32 %15, 5
  %d = getelementptr inbounds %class.Date, ptr %0, i32 0, i32 3
  %d19 = load i32, ptr %d, align 4, !tbaa !4
  %20 = add i32 %19, %d19
  %21 = sub i32 %20, 1
  store i32 %21, ptr %doy, align 4
  %yoe20 = load i32, ptr %yoe, align 4
  %22 = mul i32 %yoe20, 365
  %yoe21 = load i32, ptr %yoe, align 4
  %23 = icmp eq i32 %yoe21, -2147483648
  %24 = and i1 %23, false
  %25 = or i1 false, %24
  br i1 %25, label %div.bad22, label %div.ok23

div.bad22:                                        ; preds = %div.ok16
  %exc24 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc24)
  store ptr %exc24, ptr %exc.thrown25, align 8
  call void @_CxxThrowException(ptr %exc.thrown25, ptr @_TI1PEAX)
  unreachable

div.ok23:                                         ; preds = %div.ok16
  %26 = sdiv i32 %yoe21, 4
  %27 = add i32 %22, %26
  %yoe26 = load i32, ptr %yoe, align 4
  %28 = icmp eq i32 %yoe26, -2147483648
  %29 = and i1 %28, false
  %30 = or i1 false, %29
  br i1 %30, label %div.bad27, label %div.ok28

div.bad27:                                        ; preds = %div.ok23
  %exc29 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc29)
  store ptr %exc29, ptr %exc.thrown30, align 8
  call void @_CxxThrowException(ptr %exc.thrown30, ptr @_TI1PEAX)
  unreachable

div.ok28:                                         ; preds = %div.ok23
  %31 = sdiv i32 %yoe26, 100
  %32 = sub i32 %27, %31
  %doy31 = load i32, ptr %doy, align 4
  %33 = add i32 %32, %doy31
  store i32 %33, ptr %doe, align 4
  %era32 = load i32, ptr %era, align 4
  %34 = mul i32 %era32, 146097
  %doe33 = load i32, ptr %doe, align 4
  %35 = add i32 %34, %doe33
  %36 = sub i32 %35, 719468
  ret i32 %36
}

define internal i32 @Date.dayOfWeek(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %e = alloca i32, align 4
  %1 = call i32 @Date.toEpochDay(ptr %0)
  store i32 %1, ptr %e, align 4
  %e1 = load i32, ptr %e, align 4
  %2 = add i32 %e1, 4
  %3 = icmp eq i32 %2, -2147483648
  %4 = and i1 %3, false
  %5 = or i1 false, %4
  br i1 %5, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %6 = srem i32 %2, 7
  ret i32 %6
}

define internal ptr @Date.fromEpochDay(i32 %0) personality ptr @__CxxFrameHandler3 {
entry:
  %m = alloca i32, align 4
  %d = alloca i32, align 4
  %exc.thrown49 = alloca ptr, align 8
  %mp = alloca i32, align 4
  %exc.thrown43 = alloca ptr, align 8
  %doy = alloca i32, align 4
  %exc.thrown38 = alloca ptr, align 8
  %exc.thrown33 = alloca ptr, align 8
  %y = alloca i32, align 4
  %yoe = alloca i32, align 4
  %exc.thrown24 = alloca ptr, align 8
  %exc.thrown20 = alloca ptr, align 8
  %exc.thrown15 = alloca ptr, align 8
  %exc.thrown10 = alloca ptr, align 8
  %doe = alloca i32, align 4
  %era = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %z = alloca i32, align 4
  %z0 = alloca i32, align 4
  store i32 %0, ptr %z0, align 4
  %z01 = load i32, ptr %z0, align 4
  %1 = add i32 %z01, 719468
  store i32 %1, ptr %z, align 4
  %z2 = load i32, ptr %z, align 4
  %2 = icmp eq i32 %z2, -2147483648
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
  %5 = sdiv i32 %z2, 146097
  store i32 %5, ptr %era, align 4
  %z3 = load i32, ptr %z, align 4
  %era4 = load i32, ptr %era, align 4
  %6 = mul i32 %era4, 146097
  %7 = sub i32 %z3, %6
  store i32 %7, ptr %doe, align 4
  %doe5 = load i32, ptr %doe, align 4
  %doe6 = load i32, ptr %doe, align 4
  %8 = icmp eq i32 %doe6, -2147483648
  %9 = and i1 %8, false
  %10 = or i1 false, %9
  br i1 %10, label %div.bad7, label %div.ok8

div.bad7:                                         ; preds = %div.ok
  %exc9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc9)
  store ptr %exc9, ptr %exc.thrown10, align 8
  call void @_CxxThrowException(ptr %exc.thrown10, ptr @_TI1PEAX)
  unreachable

div.ok8:                                          ; preds = %div.ok
  %11 = sdiv i32 %doe6, 1460
  %12 = sub i32 %doe5, %11
  %doe11 = load i32, ptr %doe, align 4
  %13 = icmp eq i32 %doe11, -2147483648
  %14 = and i1 %13, false
  %15 = or i1 false, %14
  br i1 %15, label %div.bad12, label %div.ok13

div.bad12:                                        ; preds = %div.ok8
  %exc14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc14)
  store ptr %exc14, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

div.ok13:                                         ; preds = %div.ok8
  %16 = sdiv i32 %doe11, 36524
  %17 = add i32 %12, %16
  %doe16 = load i32, ptr %doe, align 4
  %18 = icmp eq i32 %doe16, -2147483648
  %19 = and i1 %18, false
  %20 = or i1 false, %19
  br i1 %20, label %div.bad17, label %div.ok18

div.bad17:                                        ; preds = %div.ok13
  %exc19 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc19)
  store ptr %exc19, ptr %exc.thrown20, align 8
  call void @_CxxThrowException(ptr %exc.thrown20, ptr @_TI1PEAX)
  unreachable

div.ok18:                                         ; preds = %div.ok13
  %21 = sdiv i32 %doe16, 146096
  %22 = sub i32 %17, %21
  %23 = icmp eq i32 %22, -2147483648
  %24 = and i1 %23, false
  %25 = or i1 false, %24
  br i1 %25, label %div.bad21, label %div.ok22

div.bad21:                                        ; preds = %div.ok18
  %exc23 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc23)
  store ptr %exc23, ptr %exc.thrown24, align 8
  call void @_CxxThrowException(ptr %exc.thrown24, ptr @_TI1PEAX)
  unreachable

div.ok22:                                         ; preds = %div.ok18
  %26 = sdiv i32 %22, 365
  store i32 %26, ptr %yoe, align 4
  %yoe25 = load i32, ptr %yoe, align 4
  %era26 = load i32, ptr %era, align 4
  %27 = mul i32 %era26, 400
  %28 = add i32 %yoe25, %27
  store i32 %28, ptr %y, align 4
  %doe27 = load i32, ptr %doe, align 4
  %yoe28 = load i32, ptr %yoe, align 4
  %29 = mul i32 365, %yoe28
  %yoe29 = load i32, ptr %yoe, align 4
  %30 = icmp eq i32 %yoe29, -2147483648
  %31 = and i1 %30, false
  %32 = or i1 false, %31
  br i1 %32, label %div.bad30, label %div.ok31

div.bad30:                                        ; preds = %div.ok22
  %exc32 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc32)
  store ptr %exc32, ptr %exc.thrown33, align 8
  call void @_CxxThrowException(ptr %exc.thrown33, ptr @_TI1PEAX)
  unreachable

div.ok31:                                         ; preds = %div.ok22
  %33 = sdiv i32 %yoe29, 4
  %34 = add i32 %29, %33
  %yoe34 = load i32, ptr %yoe, align 4
  %35 = icmp eq i32 %yoe34, -2147483648
  %36 = and i1 %35, false
  %37 = or i1 false, %36
  br i1 %37, label %div.bad35, label %div.ok36

div.bad35:                                        ; preds = %div.ok31
  %exc37 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc37)
  store ptr %exc37, ptr %exc.thrown38, align 8
  call void @_CxxThrowException(ptr %exc.thrown38, ptr @_TI1PEAX)
  unreachable

div.ok36:                                         ; preds = %div.ok31
  %38 = sdiv i32 %yoe34, 100
  %39 = sub i32 %34, %38
  %40 = sub i32 %doe27, %39
  store i32 %40, ptr %doy, align 4
  %doy39 = load i32, ptr %doy, align 4
  %41 = mul i32 5, %doy39
  %42 = add i32 %41, 2
  %43 = icmp eq i32 %42, -2147483648
  %44 = and i1 %43, false
  %45 = or i1 false, %44
  br i1 %45, label %div.bad40, label %div.ok41

div.bad40:                                        ; preds = %div.ok36
  %exc42 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc42)
  store ptr %exc42, ptr %exc.thrown43, align 8
  call void @_CxxThrowException(ptr %exc.thrown43, ptr @_TI1PEAX)
  unreachable

div.ok41:                                         ; preds = %div.ok36
  %46 = sdiv i32 %42, 153
  store i32 %46, ptr %mp, align 4
  %doy44 = load i32, ptr %doy, align 4
  %mp45 = load i32, ptr %mp, align 4
  %47 = mul i32 153, %mp45
  %48 = add i32 %47, 2
  %49 = icmp eq i32 %48, -2147483648
  %50 = and i1 %49, false
  %51 = or i1 false, %50
  br i1 %51, label %div.bad46, label %div.ok47

div.bad46:                                        ; preds = %div.ok41
  %exc48 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc48)
  store ptr %exc48, ptr %exc.thrown49, align 8
  call void @_CxxThrowException(ptr %exc.thrown49, ptr @_TI1PEAX)
  unreachable

div.ok47:                                         ; preds = %div.ok41
  %52 = sdiv i32 %48, 5
  %53 = sub i32 %doy44, %52
  %54 = add i32 %53, 1
  store i32 %54, ptr %d, align 4
  %mp50 = load i32, ptr %mp, align 4
  store i32 %mp50, ptr %m, align 4
  %mp51 = load i32, ptr %mp, align 4
  %55 = icmp slt i32 %mp51, 10
  %56 = zext i1 %55 to i32
  br i1 %55, label %if.then, label %if.else

if.then:                                          ; preds = %div.ok47
  %mp52 = load i32, ptr %mp, align 4
  %57 = add i32 %mp52, 3
  store i32 %57, ptr %m, align 4
  br label %if.end

if.else:                                          ; preds = %div.ok47
  %mp53 = load i32, ptr %mp, align 4
  %58 = sub i32 %mp53, 9
  store i32 %58, ptr %m, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %m54 = load i32, ptr %m, align 4
  %59 = icmp sle i32 %m54, 2
  %60 = zext i1 %59 to i32
  br i1 %59, label %if.then55, label %if.end56

if.then55:                                        ; preds = %if.end
  %y57 = load i32, ptr %y, align 4
  %61 = add i32 %y57, 1
  store i32 %61, ptr %y, align 4
  br label %if.end56

if.end56:                                         ; preds = %if.then55, %if.end
  %Date.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Date, ptr null, i64 1) to i64))
  %y58 = load i32, ptr %y, align 4
  %m59 = load i32, ptr %m, align 4
  %d60 = load i32, ptr %d, align 4
  call void @Date.Date(ptr %Date.obj, i32 %y58, i32 %m59, i32 %d60)
  ret ptr %Date.obj
}

define internal ptr @Date.addDays(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %2 = call i32 @Date.toEpochDay(ptr %0)
  %n1 = load i32, ptr %n, align 4
  %3 = add i32 %2, %n1
  %4 = call ptr @Date.fromEpochDay(i32 %3)
  ret ptr %4
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5310)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
