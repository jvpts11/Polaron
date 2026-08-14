; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/template_csv.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/template_csv.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.HashMap$String$String" = type { ptr, ptr, ptr, ptr, i32, i32 }
%"class.ArrayList$String" = type { ptr, ptr, i32 }
%class.DivideByZeroException = type { ptr }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$String" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"ArrayListIterator$String.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$String.hasNext", ptr @"ArrayListIterator$String.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"HashMap$String$String.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$String.size", ptr @"HashMap$String$String.isEmpty", ptr @"HashMap$String$String.slotFor", ptr @"HashMap$String$String.grow", ptr @"HashMap$String$String.put", ptr @"HashMap$String$String.get", ptr @"HashMap$String$String.containsKey", ptr @"HashMap$String$String.getOrDefault", ptr @"HashMap$String$String.merge", ptr @"HashMap$String$String.remove", ptr @"HashMap$String$String.keyArray", ptr @"HashMap$String$String.valueArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$String.~HashMap$String$String"]
@"ArrayList$String.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr @"ArrayList$String.toArray", ptr @"ArrayList$String.size", ptr @"ArrayList$String.isEmpty", ptr null, ptr null, ptr null, ptr @"ArrayList$String.get", ptr null, ptr null, ptr null, ptr @"ArrayList$String.remove", ptr null, ptr null, ptr @"ArrayList$String.add", ptr @"ArrayList$String.ensureCapacity", ptr @"ArrayList$String.set", ptr @"ArrayList$String.indexOf", ptr @"ArrayList$String.contains", ptr @"ArrayList$String.removeAt", ptr @"ArrayList$String.insertAt", ptr @"ArrayList$String.clear", ptr @"ArrayList$String.forEach", ptr @"ArrayList$String.filter", ptr @"ArrayList$String.any", ptr @"ArrayList$String.all", ptr @"ArrayList$String.count", ptr @"ArrayList$String.sortedBy", ptr @"ArrayList$String.mergeSortRange", ptr @"ArrayList$String.find", ptr @"ArrayList$String.min", ptr @"ArrayList$String.max", ptr @"ArrayList$String.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.~ArrayList$String"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@.strdata = private constant [5 x i8] c"name\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c"Ada\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c"n\00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [3 x i8] c"42\00"
@.strobj.6 = private global %String { i64 2, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [25 x i8] c"Hi {name}, n={n}, {miss}\00"
@.strobj.8 = private global %String { i64 24, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [10 x i8] c"a,\22b,c\22,d\00"
@.strobj.10 = private global %String { i64 9, ptr @.strdata.9, i64 0 }
@.str = private unnamed_addr constant [20 x i8] c"tpl=%s nf=%d f1=%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.contract.524 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.525 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.526 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.527 = private unnamed_addr constant [140 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.528 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.529 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.530 = private unnamed_addr constant [149 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.531 = private unnamed_addr constant [151 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.532 = private unnamed_addr constant [149 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.533 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1004:17  in HashMap$String$String.slotFor\0A\00", align 1
@.faila.534 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.535 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.536 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1005:21  in HashMap$String$String.slotFor\0A\00", align 1
@.faila.537 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.538 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.539 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1033:21  in HashMap$String$String.grow\0A\00", align 1
@.faila.540 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.541 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.542 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1034:25  in HashMap$String$String.grow\0A\00", align 1
@.faila.543 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.544 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.545 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1035:25  in HashMap$String$String.grow\0A\00", align 1
@.faila.546 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.547 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.548 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1036:38  in HashMap$String$String.grow\0A\00", align 1
@.faila.549 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.550 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.551 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$String$String.grow\0A\00", align 1
@.faila.552 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.553 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.554 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$String$String.grow\0A\00", align 1
@.faila.555 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.556 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.557 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$String$String.grow\0A\00", align 1
@.faila.558 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.559 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.560 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$String$String.grow\0A\00", align 1
@.faila.561 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.562 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.563 = private unnamed_addr constant [117 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.grow\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.564 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.565 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.566 = private unnamed_addr constant [123 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.grow\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.567 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.568 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.569 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$String.grow\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.570 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$String.grow\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.571 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.grow\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.572 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:17  in HashMap$String$String.put\0A\00", align 1
@.faila.573 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.574 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.575 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:55  in HashMap$String$String.put\0A\00", align 1
@.faila.576 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.577 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.578 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1049:30  in HashMap$String$String.put\0A\00", align 1
@.faila.579 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.580 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.581 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1050:32  in HashMap$String$String.put\0A\00", align 1
@.faila.582 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.583 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.584 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.put\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.585 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.586 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.587 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.put\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.588 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.589 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.590 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$String.put\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.591 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$String.put\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.592 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.put\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.593 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1053:17  in HashMap$String$String.get\0A\00", align 1
@.faila.594 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.595 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.596 = private unnamed_addr constant [104 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1056:17  in HashMap$String$String.containsKey\0A\00", align 1
@.faila.597 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.598 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.599 = private unnamed_addr constant [105 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:17  in HashMap$String$String.getOrDefault\0A\00", align 1
@.faila.600 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.601 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.602 = private unnamed_addr constant [105 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:42  in HashMap$String$String.getOrDefault\0A\00", align 1
@.faila.603 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.604 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.605 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1069:17  in HashMap$String$String.merge\0A\00", align 1
@.faila.606 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.607 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.608 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1070:34  in HashMap$String$String.merge\0A\00", align 1
@.faila.609 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.610 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.611 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1072:34  in HashMap$String$String.merge\0A\00", align 1
@.faila.612 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.613 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.614 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1073:36  in HashMap$String$String.merge\0A\00", align 1
@.faila.615 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.616 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.617 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$String$String.merge\0A\00", align 1
@.faila.618 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.619 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.620 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$String$String.merge\0A\00", align 1
@.faila.621 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.622 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.623 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.merge\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.624 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.625 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.626 = private unnamed_addr constant [124 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.merge\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.627 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.628 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.629 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$String.merge\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.630 = private unnamed_addr constant [135 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$String.merge\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.631 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.merge\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.632 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1080:17  in HashMap$String$String.remove\0A\00", align 1
@.faila.633 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.634 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.635 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.636 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.637 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.638 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.639 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.640 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.641 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.642 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1082:30  in HashMap$String$String.remove\0A\00", align 1
@.faila.643 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.644 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.645 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1085:17  in HashMap$String$String.remove\0A\00", align 1
@.faila.646 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.647 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.648 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1086:21  in HashMap$String$String.remove\0A\00", align 1
@.faila.649 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.650 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.651 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1087:21  in HashMap$String$String.remove\0A\00", align 1
@.faila.652 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.653 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.654 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1088:34  in HashMap$String$String.remove\0A\00", align 1
@.faila.655 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.656 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.657 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.658 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.659 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.660 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.661 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.662 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.663 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.664 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:21  in HashMap$String$String.keyArray\0A\00", align 1
@.faila.665 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.666 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.667 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$String$String.keyArray\0A\00", align 1
@.faila.668 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.669 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.670 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$String$String.keyArray\0A\00", align 1
@.faila.671 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.672 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.673 = private unnamed_addr constant [103 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:21  in HashMap$String$String.valueArray\0A\00", align 1
@.faila.674 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.675 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.676 = private unnamed_addr constant [103 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$String$String.valueArray\0A\00", align 1
@.faila.677 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.678 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.679 = private unnamed_addr constant [103 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$String$String.valueArray\0A\00", align 1
@.faila.680 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.681 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1098 = private unnamed_addr constant [124 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1099 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1100 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1101 = private unnamed_addr constant [141 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1102 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.1103 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1104 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1105 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.1106 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1107 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1108 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$String.add\0A\00", align 1
@.faila.1109 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1110 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1111 = private unnamed_addr constant [124 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$String.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.1112 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1113 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1114 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1115 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1116 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.1117 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1118 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1119 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.1120 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1121 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1122 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1123 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1124 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1125 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1126 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$String.get\0A\00", align 1
@.faila.1127 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1128 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1129 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$String.get\0A\00", align 1
@.faila.1130 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1131 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1132 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$String.set\0A\00", align 1
@.faila.1133 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1134 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1135 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1136 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$String.set\0A\00", align 1
@.faila.1137 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1138 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1139 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1140 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$String.indexOf\0A\00", align 1
@.faila.1141 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1142 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1143 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1144 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1145 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1146 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1147 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1148 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1149 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1150 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1151 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1152 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1153 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1154 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1155 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1156 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1157 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1158 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1159 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1160 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1161 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1162 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1163 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1164 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1165 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1166 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1167 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1168 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1169 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1170 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1171 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1172 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1173 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1174 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1175 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1176 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1177 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1178 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1179 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1180 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1181 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1182 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1183 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1184 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1185 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1186 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1187 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1188 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1189 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1190 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.1191 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1192 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1193 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.1194 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1195 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1196 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$String.forEach\0A\00", align 1
@.faila.1197 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1198 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1199 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$String.filter\0A\00", align 1
@.faila.1200 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1201 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1202 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$String.filter\0A\00", align 1
@.faila.1203 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1204 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1205 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$String.any\0A\00", align 1
@.faila.1206 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1207 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1208 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$String.all\0A\00", align 1
@.faila.1209 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1210 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1211 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$String.count\0A\00", align 1
@.faila.1212 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1213 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1214 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$String.sortedBy\0A\00", align 1
@.faila.1215 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1216 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1217 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1218 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1219 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1220 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1221 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1222 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1223 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1224 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1225 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1226 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1227 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1228 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1229 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1230 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1231 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1232 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1233 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1234 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1235 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1236 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1237 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1238 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1239 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1240 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1241 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1242 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1243 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1244 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1245 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1246 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1247 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1248 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1249 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1250 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1251 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1252 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1253 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1254 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1255 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1256 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1257 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1258 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1259 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1260 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1261 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1262 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1263 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1264 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1265 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1266 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1267 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1268 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1269 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1270 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1271 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1272 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1273 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1274 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1275 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1276 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1277 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1278 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1279 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1280 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1281 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1282 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$String.find\0A\00", align 1
@.faila.1283 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1284 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1285 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$String.find\0A\00", align 1
@.faila.1286 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1287 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1288 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$String.min\0A\00", align 1
@.faila.1289 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1290 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1291 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$String.min\0A\00", align 1
@.faila.1292 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1293 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1294 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$String.min\0A\00", align 1
@.faila.1295 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1296 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1297 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$String.max\0A\00", align 1
@.faila.1298 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1299 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1300 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$String.max\0A\00", align 1
@.faila.1301 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1302 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1303 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$String.max\0A\00", align 1
@.faila.1304 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1305 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1316 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1317 = private global %String { i64 16, ptr @.strdata.1316, i64 0 }
@.strdata.1318 = private constant [17 x i8] c"division by zero\00"
@.strobj.1319 = private global %String { i64 16, ptr @.strdata.1318, i64 0 }
@.strdata.5317 = private constant [1 x i8] zeroinitializer
@.strobj.5318 = private global %String { i64 0, ptr @.strdata.5317, i64 0 }
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  %r = alloca ptr, align 8
  %m = alloca ptr, align 8
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
  %"HashMap$String$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashMap$String$String", ptr null, i64 1) to i64))
  call void @"HashMap$String$String.HashMap$String$String"(ptr %"HashMap$String$String.obj")
  store ptr %"HashMap$String$String.obj", ptr %m, align 8
  %m1 = load ptr, ptr %m, align 8
  call void @"HashMap$String$String.put"(ptr %m1, ptr @.strobj, ptr @.strobj.2)
  %m2 = load ptr, ptr %m, align 8
  call void @"HashMap$String$String.put"(ptr %m2, ptr @.strobj.4, ptr @.strobj.6)
  %m3 = load ptr, ptr %m, align 8
  %16 = call ptr @Template.render(ptr @.strobj.8, ptr %m3)
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  store ptr %strcpy, ptr %r, align 8
  call void @__polaron_str_free(ptr %16)
  %17 = call ptr @Csv.parse(ptr @.strobj.10)
  store ptr %17, ptr %f, align 8
  %r4 = load ptr, ptr %r, align 8
  %str.data = getelementptr inbounds %String, ptr %r4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %f5 = load ptr, ptr %f, align 8
  %18 = call i32 @"ArrayList$String.size"(ptr %f5)
  %f6 = load ptr, ptr %f, align 8
  %19 = call ptr @"ArrayList$String.get"(ptr %f6, i32 1)
  %str.data7 = getelementptr inbounds %String, ptr %19, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %20 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, i32 %18, ptr %data8)
  call void @__polaron_str_free(ptr %19)
  %21 = load ptr, ptr %r, align 8
  call void @__polaron_str_free(ptr %21)
  ret i32 0
}

define internal void @"HashMap$String$String.HashMap$String$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 0
  store ptr @"HashMap$String$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %keys, align 8, !tbaa !0
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  store ptr null, ptr %values, align 8, !tbaa !0
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  store ptr null, ptr %used, align 8, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !4
  %keys1 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %keys1, align 8, !tbaa !0
  %values2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 64)
  store ptr %arr3, ptr %values2, align 8, !tbaa !0
  %used5 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %3 = call ptr @memset(ptr %arr.data7, i32 0, i64 8)
  store ptr %arr6, ptr %used5, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  %count8 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %4 = icmp sge i32 %count9, 0
  %5 = zext i1 %4 to i32
  %contract.ok = icmp ne i32 %5, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count10 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %contract.l = sext i32 %count11 to i64
  call void @__polaron_fail(ptr @.contract.524, ptr @.cl.525, i64 %contract.l, ptr @.cr.526, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count13 = load i32, ptr %count12, align 4, !tbaa !4
  %cap14 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %6 = icmp slt i32 %count13, %cap15
  %7 = zext i1 %6 to i32
  %contract.ok16 = icmp ne i32 %7, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  %count19 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %cap21 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap22 = load i32, ptr %cap21, align 4, !tbaa !4
  %contract.l23 = sext i32 %count20 to i64
  %contract.r = sext i32 %cap22 to i64
  call void @__polaron_fail(ptr @.contract.527, ptr @.cl.528, i64 %contract.l23, ptr @.cr.529, i64 %contract.r, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  %keys24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys25 = load ptr, ptr %keys24, align 8, !tbaa !0
  %len = load i64, ptr %keys25, align 8
  %8 = trunc i64 %len to i32
  %cap26 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap27 = load i32, ptr %cap26, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap27
  %10 = zext i1 %9 to i32
  %contract.ok28 = icmp ne i32 %10, 0
  br i1 %contract.ok28, label %contract.cont30, label %contract.fail29

contract.fail29:                                  ; preds = %contract.cont18
  call void @__polaron_fail(ptr @.contract.530, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont30:                                  ; preds = %contract.cont18
  %values31 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values32 = load ptr, ptr %values31, align 8, !tbaa !0
  %len33 = load i64, ptr %values32, align 8
  %11 = trunc i64 %len33 to i32
  %cap34 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap35
  %13 = zext i1 %12 to i32
  %contract.ok36 = icmp ne i32 %13, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %contract.cont30
  call void @__polaron_fail(ptr @.contract.531, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %contract.cont30
  %used39 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used40 = load ptr, ptr %used39, align 8, !tbaa !0
  %len41 = load i64, ptr %used40, align 8
  %14 = trunc i64 %len41 to i32
  %cap42 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap43 = load i32, ptr %cap42, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap43
  %16 = zext i1 %15 to i32
  %contract.ok44 = icmp ne i32 %16, 0
  br i1 %contract.ok44, label %contract.cont46, label %contract.fail45

contract.fail45:                                  ; preds = %contract.cont38
  call void @__polaron_fail(ptr @.contract.532, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont46:                                  ; preds = %contract.cont38
  ret void
}

define internal void @"HashMap$String$String.~HashMap$String$String"(ptr %0) {
entry:
  %ae.i5 = alloca i64, align 8
  %ae.i = alloca i64, align 8
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys1 = load ptr, ptr %keys, align 8, !tbaa !0
  %ae.len = load i64, ptr %keys1, align 8
  %arr.data = getelementptr i8, ptr %keys1, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

ae.cond:                                          ; preds = %ae.next, %entry
  %ae.iv = load i64, ptr %ae.i, align 8
  %1 = icmp ult i64 %ae.iv, %ae.len
  br i1 %1, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %2 = icmp ne ptr %ae.el, null
  br i1 %2, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %3 = add i64 %ae.iv, 1
  store i64 %3, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %keys1)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values2 = load ptr, ptr %values, align 8, !tbaa !0
  %ae.len3 = load i64, ptr %values2, align 8
  %arr.data4 = getelementptr i8, ptr %values2, i64 8
  store i64 0, ptr %ae.i5, align 8
  br label %ae.cond6

ae.cond6:                                         ; preds = %ae.next9, %ae.end
  %ae.iv11 = load i64, ptr %ae.i5, align 8
  %4 = icmp ult i64 %ae.iv11, %ae.len3
  br i1 %4, label %ae.body7, label %ae.end10

ae.body7:                                         ; preds = %ae.cond6
  %ae.ep12 = getelementptr ptr, ptr %arr.data4, i64 %ae.iv11
  %ae.el13 = load ptr, ptr %ae.ep12, align 8
  %5 = icmp ne ptr %ae.el13, null
  br i1 %5, label %ae.free8, label %ae.next9

ae.free8:                                         ; preds = %ae.body7
  call void @__polaron_str_free(ptr %ae.el13)
  store ptr null, ptr %ae.ep12, align 8
  br label %ae.next9

ae.next9:                                         ; preds = %ae.free8, %ae.body7
  %6 = add i64 %ae.iv11, 1
  store i64 %6, ptr %ae.i5, align 8
  br label %ae.cond6

ae.end10:                                         ; preds = %ae.cond6
  call void @__polaron_free(ptr %values2)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used14 = load ptr, ptr %used, align 8, !tbaa !0
  call void @__polaron_free(ptr %used14)
  ret void
}

define internal i32 @"HashMap$String$String.slotFor"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !4
  %15 = sub i32 %cap21, 1
  store i32 %15, ptr %mask, align 4
  %key22 = load ptr, ptr %key, align 8
  %16 = call i64 @__polaron_str_hash_obj(ptr %key22)
  %17 = trunc i64 %16 to i32
  %mask23 = load i32, ptr %mask, align 4
  %18 = and i32 %17, %mask23
  store i32 %18, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %used24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used25 = load ptr, ptr %used24, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %19 = sext i32 %i26 to i64
  %arr.len = load i64, ptr %used25, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %keys27 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys28 = load ptr, ptr %keys27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %20 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %keys28, align 8
  %arr.oob31 = icmp uge i64 %20, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

while.end:                                        ; preds = %idx.ok
  %i43 = load i32, ptr %i, align 4
  ret i32 %i43

idx.bad:                                          ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.533, ptr @.faila.534, i64 %19, ptr @.failb.535, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.cond
  %arr.data = getelementptr i8, ptr %used25, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %19
  %elem = load i8, ptr %arr.elem, align 1
  %21 = sext i8 %elem to i32
  %22 = icmp ne i32 %21, 0
  %23 = zext i1 %22 to i32
  br i1 %22, label %while.body, label %while.end

idx.bad32:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.536, ptr @.faila.537, i64 %20, ptr @.failb.538, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %while.body
  %arr.data34 = getelementptr i8, ptr %keys28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %20
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %key37 = load ptr, ptr %key, align 8
  %str.data = getelementptr inbounds %String, ptr %elem36, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data38 = getelementptr inbounds %String, ptr %key37, i32 0, i32 1
  %data39 = load ptr, ptr %str.data38, align 8
  %24 = call i32 @strcmp(ptr %data, ptr %data39)
  %25 = icmp eq i32 %24, 0
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok33
  %i40 = load i32, ptr %i, align 4
  ret i32 %i40

if.end:                                           ; preds = %idx.ok33
  %i41 = load i32, ptr %i, align 4
  %27 = add i32 %i41, 1
  %mask42 = load i32, ptr %mask, align 4
  %28 = and i32 %27, %mask42
  store i32 %28, ptr %i, align 4
  br label %while.cond
}

define internal void @"HashMap$String$String.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %ae.i123 = alloca i64, align 8
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldV = alloca ptr, align 8
  %oldK = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !4
  store i32 %cap21, ptr %oldCap, align 4
  %keys22 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys23 = load ptr, ptr %keys22, align 8, !tbaa !0
  store ptr %keys23, ptr %oldK, align 8
  %values24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !0
  store ptr %values25, ptr %oldV, align 8
  %used26 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used27 = load ptr, ptr %used26, align 8, !tbaa !0
  store ptr %used27, ptr %oldU, align 8
  %cap28 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %oldCap29 = load i32, ptr %oldCap, align 4
  %14 = mul i32 %oldCap29, 4
  store i32 %14, ptr %cap28, align 4, !tbaa !4
  %keys30 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %cap31 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap32 = load i32, ptr %cap31, align 4, !tbaa !4
  %15 = sext i32 %cap32 to i64
  %16 = mul i64 %15, 8
  %17 = add i64 8, %16
  %arr = call ptr @__polaron_malloc(i64 %17)
  store i64 %15, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %18 = call ptr @memset(ptr %arr.data, i32 0, i64 %16)
  store ptr %arr, ptr %keys30, align 8, !tbaa !0
  %values33 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %cap34 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %19 = sext i32 %cap35 to i64
  %20 = mul i64 %19, 8
  %21 = add i64 8, %20
  %arr36 = call ptr @__polaron_malloc(i64 %21)
  store i64 %19, ptr %arr36, align 8
  %arr.data37 = getelementptr i8, ptr %arr36, i64 8
  %22 = call ptr @memset(ptr %arr.data37, i32 0, i64 %20)
  store ptr %arr36, ptr %values33, align 8, !tbaa !0
  %used38 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %cap39 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap40 = load i32, ptr %cap39, align 4, !tbaa !4
  %23 = sext i32 %cap40 to i64
  %24 = mul i64 %23, 1
  %25 = add i64 8, %24
  %arr41 = call ptr @__polaron_malloc(i64 %25)
  store i64 %23, ptr %arr41, align 8
  %arr.data42 = getelementptr i8, ptr %arr41, i64 8
  %26 = call ptr @memset(ptr %arr.data42, i32 0, i64 %24)
  store ptr %arr41, ptr %used38, align 8, !tbaa !0
  %cap43 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !4
  %27 = sub i32 %cap44, 1
  store i32 %27, ptr %mask, align 4
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %j45 = load i32, ptr %j, align 4
  %oldCap46 = load i32, ptr %oldCap, align 4
  %28 = icmp slt i32 %j45, %oldCap46
  %29 = zext i1 %28 to i32
  br i1 %28, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %oldU47 = load ptr, ptr %oldU, align 8, !nonnull !6, !dereferenceable !7
  %j48 = load i32, ptr %j, align 4
  %30 = sext i32 %j48 to i64
  %arr.len = load i64, ptr %oldU47, align 8
  %arr.oob = icmp uge i64 %30, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %31 = load i32, ptr %j, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %oldK118 = load ptr, ptr %oldK, align 8
  %ae.len = load i64, ptr %oldK118, align 8
  %arr.data119 = getelementptr i8, ptr %oldK118, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.539, ptr @.faila.540, i64 %30, ptr @.failb.541, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data49 = getelementptr i8, ptr %oldU47, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data49, i64 %30
  %elem = load i8, ptr %arr.elem, align 1
  %33 = sext i8 %elem to i32
  %34 = icmp ne i32 %33, 0
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %oldK50 = load ptr, ptr %oldK, align 8, !nonnull !6, !dereferenceable !7
  %j51 = load i32, ptr %j, align 4
  %36 = sext i32 %j51 to i64
  %arr.len52 = load i64, ptr %oldK50, align 8
  %arr.oob53 = icmp uge i64 %36, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !8

if.end:                                           ; preds = %idx.ok113, %idx.ok
  br label %for.update

idx.bad54:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.542, ptr @.faila.543, i64 %36, ptr @.failb.544, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %if.then
  %arr.data56 = getelementptr i8, ptr %oldK50, i64 8
  %arr.elem57 = getelementptr inbounds ptr, ptr %arr.data56, i64 %36
  %elem58 = load ptr, ptr %arr.elem57, align 8
  %37 = call i64 @__polaron_str_hash_obj(ptr %elem58)
  %38 = trunc i64 %37 to i32
  %mask59 = load i32, ptr %mask, align 4
  %39 = and i32 %38, %mask59
  store i32 %39, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok55
  %used60 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used61 = load ptr, ptr %used60, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i62 = load i32, ptr %i, align 4
  %40 = sext i32 %i62 to i64
  %arr.len63 = load i64, ptr %used61, align 8
  %arr.oob64 = icmp uge i64 %40, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !8

while.body:                                       ; preds = %idx.ok66
  %i70 = load i32, ptr %i, align 4
  %41 = add i32 %i70, 1
  %mask71 = load i32, ptr %mask, align 4
  %42 = and i32 %41, %mask71
  store i32 %42, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %idx.ok66
  %used72 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used73 = load ptr, ptr %used72, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i74 = load i32, ptr %i, align 4
  %43 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %used73, align 8
  %arr.oob76 = icmp uge i64 %43, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !8

idx.bad65:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.545, ptr @.faila.546, i64 %40, ptr @.failb.547, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %while.cond
  %arr.data67 = getelementptr i8, ptr %used61, i64 8
  %arr.elem68 = getelementptr inbounds i8, ptr %arr.data67, i64 %40
  %elem69 = load i8, ptr %arr.elem68, align 1
  %44 = sext i8 %elem69 to i32
  %45 = icmp ne i32 %44, 0
  %46 = zext i1 %45 to i32
  br i1 %45, label %while.body, label %while.end

idx.bad77:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.548, ptr @.faila.549, i64 %43, ptr @.failb.550, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %while.end
  %arr.data79 = getelementptr i8, ptr %used73, i64 8
  %arr.elem80 = getelementptr inbounds i8, ptr %arr.data79, i64 %43
  store i8 1, ptr %arr.elem80, align 1
  %keys81 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys82 = load ptr, ptr %keys81, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i83 = load i32, ptr %i, align 4
  %47 = sext i32 %i83 to i64
  %arr.len84 = load i64, ptr %keys82, align 8
  %arr.oob85 = icmp uge i64 %47, %arr.len84
  br i1 %arr.oob85, label %idx.bad86, label %idx.ok87, !prof !8

idx.bad86:                                        ; preds = %idx.ok78
  call void @__polaron_fail(ptr @.fail.551, ptr @.faila.552, i64 %47, ptr @.failb.553, i64 %arr.len84, i32 70)
  unreachable

idx.ok87:                                         ; preds = %idx.ok78
  %arr.data88 = getelementptr i8, ptr %keys82, i64 8
  %arr.elem89 = getelementptr inbounds ptr, ptr %arr.data88, i64 %47
  %oldK90 = load ptr, ptr %oldK, align 8, !nonnull !6, !dereferenceable !7
  %j91 = load i32, ptr %j, align 4
  %48 = sext i32 %j91 to i64
  %arr.len92 = load i64, ptr %oldK90, align 8
  %arr.oob93 = icmp uge i64 %48, %arr.len92
  br i1 %arr.oob93, label %idx.bad94, label %idx.ok95, !prof !8

idx.bad94:                                        ; preds = %idx.ok87
  call void @__polaron_fail(ptr @.fail.554, ptr @.faila.555, i64 %48, ptr @.failb.556, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %idx.ok87
  %arr.data96 = getelementptr i8, ptr %oldK90, i64 8
  %arr.elem97 = getelementptr inbounds ptr, ptr %arr.data96, i64 %48
  %elem98 = load ptr, ptr %arr.elem97, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem98)
  %49 = load ptr, ptr %arr.elem89, align 8
  call void @__polaron_str_free(ptr %49)
  store ptr %strcpy, ptr %arr.elem89, align 8
  %values99 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values100 = load ptr, ptr %values99, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i101 = load i32, ptr %i, align 4
  %50 = sext i32 %i101 to i64
  %arr.len102 = load i64, ptr %values100, align 8
  %arr.oob103 = icmp uge i64 %50, %arr.len102
  br i1 %arr.oob103, label %idx.bad104, label %idx.ok105, !prof !8

idx.bad104:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.557, ptr @.faila.558, i64 %50, ptr @.failb.559, i64 %arr.len102, i32 70)
  unreachable

idx.ok105:                                        ; preds = %idx.ok95
  %arr.data106 = getelementptr i8, ptr %values100, i64 8
  %arr.elem107 = getelementptr inbounds ptr, ptr %arr.data106, i64 %50
  %oldV108 = load ptr, ptr %oldV, align 8, !nonnull !6, !dereferenceable !7
  %j109 = load i32, ptr %j, align 4
  %51 = sext i32 %j109 to i64
  %arr.len110 = load i64, ptr %oldV108, align 8
  %arr.oob111 = icmp uge i64 %51, %arr.len110
  br i1 %arr.oob111, label %idx.bad112, label %idx.ok113, !prof !8

idx.bad112:                                       ; preds = %idx.ok105
  call void @__polaron_fail(ptr @.fail.560, ptr @.faila.561, i64 %51, ptr @.failb.562, i64 %arr.len110, i32 70)
  unreachable

idx.ok113:                                        ; preds = %idx.ok105
  %arr.data114 = getelementptr i8, ptr %oldV108, i64 8
  %arr.elem115 = getelementptr inbounds ptr, ptr %arr.data114, i64 %51
  %elem116 = load ptr, ptr %arr.elem115, align 8
  %strcpy117 = call ptr @__polaron_str_copy(ptr %elem116)
  %52 = load ptr, ptr %arr.elem107, align 8
  call void @__polaron_str_free(ptr %52)
  store ptr %strcpy117, ptr %arr.elem107, align 8
  br label %if.end

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %53 = icmp ult i64 %ae.iv, %ae.len
  br i1 %53, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data119, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %54 = icmp ne ptr %ae.el, null
  br i1 %54, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %55 = add i64 %ae.iv, 1
  store i64 %55, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %oldK118)
  %oldV120 = load ptr, ptr %oldV, align 8
  %ae.len121 = load i64, ptr %oldV120, align 8
  %arr.data122 = getelementptr i8, ptr %oldV120, i64 8
  store i64 0, ptr %ae.i123, align 8
  br label %ae.cond124

ae.cond124:                                       ; preds = %ae.next127, %ae.end
  %ae.iv129 = load i64, ptr %ae.i123, align 8
  %56 = icmp ult i64 %ae.iv129, %ae.len121
  br i1 %56, label %ae.body125, label %ae.end128

ae.body125:                                       ; preds = %ae.cond124
  %ae.ep130 = getelementptr ptr, ptr %arr.data122, i64 %ae.iv129
  %ae.el131 = load ptr, ptr %ae.ep130, align 8
  %57 = icmp ne ptr %ae.el131, null
  br i1 %57, label %ae.free126, label %ae.next127

ae.free126:                                       ; preds = %ae.body125
  call void @__polaron_str_free(ptr %ae.el131)
  store ptr null, ptr %ae.ep130, align 8
  br label %ae.next127

ae.next127:                                       ; preds = %ae.free126, %ae.body125
  %58 = add i64 %ae.iv129, 1
  store i64 %58, ptr %ae.i123, align 8
  br label %ae.cond124

ae.end128:                                        ; preds = %ae.cond124
  call void @__polaron_free(ptr %oldV120)
  %oldU132 = load ptr, ptr %oldU, align 8
  call void @__polaron_free(ptr %oldU132)
  %count133 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count134 = load i32, ptr %count133, align 4, !tbaa !4
  %59 = icmp sge i32 %count134, 0
  %60 = zext i1 %59 to i32
  %contract.ok = icmp ne i32 %60, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %ae.end128
  %count135 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count136 = load i32, ptr %count135, align 4, !tbaa !4
  %contract.l = sext i32 %count136 to i64
  call void @__polaron_fail(ptr @.contract.563, ptr @.cl.564, i64 %contract.l, ptr @.cr.565, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %ae.end128
  %count137 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count138 = load i32, ptr %count137, align 4, !tbaa !4
  %cap139 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap140 = load i32, ptr %cap139, align 4, !tbaa !4
  %61 = icmp slt i32 %count138, %cap140
  %62 = zext i1 %61 to i32
  %contract.ok141 = icmp ne i32 %62, 0
  br i1 %contract.ok141, label %contract.cont143, label %contract.fail142

contract.fail142:                                 ; preds = %contract.cont
  %count144 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count145 = load i32, ptr %count144, align 4, !tbaa !4
  %cap146 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap147 = load i32, ptr %cap146, align 4, !tbaa !4
  %contract.l148 = sext i32 %count145 to i64
  %contract.r = sext i32 %cap147 to i64
  call void @__polaron_fail(ptr @.contract.566, ptr @.cl.567, i64 %contract.l148, ptr @.cr.568, i64 %contract.r, i32 1)
  unreachable

contract.cont143:                                 ; preds = %contract.cont
  %keys149 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys150 = load ptr, ptr %keys149, align 8, !tbaa !0
  %len151 = load i64, ptr %keys150, align 8
  %63 = trunc i64 %len151 to i32
  %cap152 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap153 = load i32, ptr %cap152, align 4, !tbaa !4
  %64 = icmp eq i32 %63, %cap153
  %65 = zext i1 %64 to i32
  %contract.ok154 = icmp ne i32 %65, 0
  br i1 %contract.ok154, label %contract.cont156, label %contract.fail155

contract.fail155:                                 ; preds = %contract.cont143
  call void @__polaron_fail(ptr @.contract.569, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont156:                                 ; preds = %contract.cont143
  %values157 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values158 = load ptr, ptr %values157, align 8, !tbaa !0
  %len159 = load i64, ptr %values158, align 8
  %66 = trunc i64 %len159 to i32
  %cap160 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap161 = load i32, ptr %cap160, align 4, !tbaa !4
  %67 = icmp eq i32 %66, %cap161
  %68 = zext i1 %67 to i32
  %contract.ok162 = icmp ne i32 %68, 0
  br i1 %contract.ok162, label %contract.cont164, label %contract.fail163

contract.fail163:                                 ; preds = %contract.cont156
  call void @__polaron_fail(ptr @.contract.570, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont164:                                 ; preds = %contract.cont156
  %used165 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used166 = load ptr, ptr %used165, align 8, !tbaa !0
  %len167 = load i64, ptr %used166, align 8
  %69 = trunc i64 %len167 to i32
  %cap168 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap169 = load i32, ptr %cap168, align 4, !tbaa !4
  %70 = icmp eq i32 %69, %cap169
  %71 = zext i1 %70 to i32
  %contract.ok170 = icmp ne i32 %71, 0
  br i1 %contract.ok170, label %contract.cont172, label %contract.fail171

contract.fail171:                                 ; preds = %contract.cont164
  call void @__polaron_fail(ptr @.contract.571, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont172:                                 ; preds = %contract.cont164
  ret void
}

define internal void @"HashMap$String$String.put"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, ptr %2) {
entry:
  %i = alloca i32, align 4
  %value = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store ptr %2, ptr %value, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %16 = add i32 %count21, 1
  %17 = mul i32 %16, 4
  %cap22 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !4
  %18 = mul i32 %cap23, 3
  %19 = icmp sge i32 %17, %18
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$String$String.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %21 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key24)
  store i32 %21, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %22 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %22, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.572, ptr @.faila.573, i64 %22, ptr @.failb.574, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %used26, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %22
  %elem = load i8, ptr %arr.elem, align 1
  %23 = sext i8 %elem to i32
  %24 = icmp eq i32 %23, 0
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then28, label %if.end29

if.then28:                                        ; preds = %idx.ok
  %used30 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %26 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %26, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.end29:                                         ; preds = %idx.ok36, %idx.ok
  %keys42 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %27 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %27, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.575, ptr @.faila.576, i64 %26, ptr @.failb.577, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %26
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %28 = add i32 %count41, 1
  store i32 %28, ptr %count39, align 4, !tbaa !4
  br label %if.end29

idx.bad47:                                        ; preds = %if.end29
  call void @__polaron_fail(ptr @.fail.578, ptr @.faila.579, i64 %27, ptr @.failb.580, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %if.end29
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds ptr, ptr %arr.data49, i64 %27
  %key51 = load ptr, ptr %key, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %key51)
  %29 = load ptr, ptr %arr.elem50, align 8
  call void @__polaron_str_free(ptr %29)
  store ptr %strcpy, ptr %arr.elem50, align 8
  %values52 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %30 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %30, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.581, ptr @.faila.582, i64 %30, ptr @.failb.583, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds ptr, ptr %arr.data59, i64 %30
  %value61 = load ptr, ptr %value, align 8
  %strcpy62 = call ptr @__polaron_str_copy(ptr %value61)
  %31 = load ptr, ptr %arr.elem60, align 8
  call void @__polaron_str_free(ptr %31)
  store ptr %strcpy62, ptr %arr.elem60, align 8
  %count63 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count64 = load i32, ptr %count63, align 4, !tbaa !4
  %32 = icmp sge i32 %count64, 0
  %33 = zext i1 %32 to i32
  %contract.ok = icmp ne i32 %33, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok58
  %count65 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count66 = load i32, ptr %count65, align 4, !tbaa !4
  %contract.l = sext i32 %count66 to i64
  call void @__polaron_fail(ptr @.contract.584, ptr @.cl.585, i64 %contract.l, ptr @.cr.586, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok58
  %count67 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count68 = load i32, ptr %count67, align 4, !tbaa !4
  %cap69 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap70 = load i32, ptr %cap69, align 4, !tbaa !4
  %34 = icmp slt i32 %count68, %cap70
  %35 = zext i1 %34 to i32
  %contract.ok71 = icmp ne i32 %35, 0
  br i1 %contract.ok71, label %contract.cont73, label %contract.fail72

contract.fail72:                                  ; preds = %contract.cont
  %count74 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count75 = load i32, ptr %count74, align 4, !tbaa !4
  %cap76 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap77 = load i32, ptr %cap76, align 4, !tbaa !4
  %contract.l78 = sext i32 %count75 to i64
  %contract.r = sext i32 %cap77 to i64
  call void @__polaron_fail(ptr @.contract.587, ptr @.cl.588, i64 %contract.l78, ptr @.cr.589, i64 %contract.r, i32 1)
  unreachable

contract.cont73:                                  ; preds = %contract.cont
  %keys79 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys80 = load ptr, ptr %keys79, align 8, !tbaa !0
  %len81 = load i64, ptr %keys80, align 8
  %36 = trunc i64 %len81 to i32
  %cap82 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap83 = load i32, ptr %cap82, align 4, !tbaa !4
  %37 = icmp eq i32 %36, %cap83
  %38 = zext i1 %37 to i32
  %contract.ok84 = icmp ne i32 %38, 0
  br i1 %contract.ok84, label %contract.cont86, label %contract.fail85

contract.fail85:                                  ; preds = %contract.cont73
  call void @__polaron_fail(ptr @.contract.590, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont86:                                  ; preds = %contract.cont73
  %values87 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values88 = load ptr, ptr %values87, align 8, !tbaa !0
  %len89 = load i64, ptr %values88, align 8
  %39 = trunc i64 %len89 to i32
  %cap90 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap91 = load i32, ptr %cap90, align 4, !tbaa !4
  %40 = icmp eq i32 %39, %cap91
  %41 = zext i1 %40 to i32
  %contract.ok92 = icmp ne i32 %41, 0
  br i1 %contract.ok92, label %contract.cont94, label %contract.fail93

contract.fail93:                                  ; preds = %contract.cont86
  call void @__polaron_fail(ptr @.contract.591, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont94:                                  ; preds = %contract.cont86
  %used95 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used96 = load ptr, ptr %used95, align 8, !tbaa !0
  %len97 = load i64, ptr %used96, align 8
  %42 = trunc i64 %len97 to i32
  %cap98 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap99 = load i32, ptr %cap98, align 4, !tbaa !4
  %43 = icmp eq i32 %42, %cap99
  %44 = zext i1 %43 to i32
  %contract.ok100 = icmp ne i32 %44, 0
  br i1 %contract.ok100, label %contract.cont102, label %contract.fail101

contract.fail101:                                 ; preds = %contract.cont94
  call void @__polaron_fail(ptr @.contract.592, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont102:                                 ; preds = %contract.cont94
  ret void
}

define internal ptr @"HashMap$String$String.get"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %values20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values21 = load ptr, ptr %values20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %values21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.593, ptr @.faila.594, i64 %16, ptr @.failb.595, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %values21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %16
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy
}

define internal i32 @"HashMap$String$String.containsKey"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %used20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used21 = load ptr, ptr %used20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %used21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.596, ptr @.faila.597, i64 %16, ptr @.failb.598, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used21, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %16
  %elem = load i8, ptr %arr.elem, align 1
  %17 = sext i8 %elem to i32
  %18 = icmp ne i32 %17, 0
  %19 = zext i1 %18 to i32
  ret i32 %19
}

define internal ptr @"HashMap$String$String.getOrDefault"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, ptr %2) {
entry:
  %i = alloca i32, align 4
  %defaultValue = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store ptr %2, ptr %defaultValue, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key20)
  store i32 %16, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %17 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.599, ptr @.faila.600, i64 %17, ptr @.failb.601, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used22, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %17
  %elem = load i8, ptr %arr.elem, align 1
  %18 = sext i8 %elem to i32
  %19 = icmp ne i32 %18, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %values24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %21 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %values25, align 8
  %arr.oob28 = icmp uge i64 %21, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !8

if.end:                                           ; preds = %idx.ok
  %defaultValue34 = load ptr, ptr %defaultValue, align 8
  %strcpy35 = call ptr @__polaron_str_copy(ptr %defaultValue34)
  ret ptr %strcpy35

idx.bad29:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.602, ptr @.faila.603, i64 %21, ptr @.failb.604, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then
  %arr.data31 = getelementptr i8, ptr %values25, i64 8
  %arr.elem32 = getelementptr inbounds ptr, ptr %arr.data31, i64 %21
  %elem33 = load ptr, ptr %arr.elem32, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem33)
  ret ptr %strcpy
}

define internal void @"HashMap$String$String.merge"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, ptr %2, ptr %3) {
entry:
  %i = alloca i32, align 4
  %combine = alloca ptr, align 8
  %value = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store ptr %2, ptr %value, align 8
  store ptr %3, ptr %combine, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %17 = add i32 %count21, 1
  %18 = mul i32 %17, 4
  %cap22 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !4
  %19 = mul i32 %cap23, 3
  %20 = icmp sge i32 %18, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$String$String.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %22 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key24)
  store i32 %22, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %23 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.605, ptr @.faila.606, i64 %23, ptr @.failb.607, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %used26, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %23
  %elem = load i8, ptr %arr.elem, align 1
  %24 = sext i8 %elem to i32
  %25 = icmp eq i32 %24, 0
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then28, label %if.else

if.then28:                                        ; preds = %idx.ok
  %used30 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %27 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %27, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.else:                                          ; preds = %idx.ok
  %values63 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values64 = load ptr, ptr %values63, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i65 = load i32, ptr %i, align 4
  %28 = sext i32 %i65 to i64
  %arr.len66 = load i64, ptr %values64, align 8
  %arr.oob67 = icmp uge i64 %28, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !8

if.end29:                                         ; preds = %idx.ok79, %idx.ok58
  %count85 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count86 = load i32, ptr %count85, align 4, !tbaa !4
  %29 = icmp sge i32 %count86, 0
  %30 = zext i1 %29 to i32
  %contract.ok = icmp ne i32 %30, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.608, ptr @.faila.609, i64 %27, ptr @.failb.610, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %27
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %31 = add i32 %count41, 1
  store i32 %31, ptr %count39, align 4, !tbaa !4
  %keys42 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %32 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %32, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.611, ptr @.faila.612, i64 %32, ptr @.failb.613, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds ptr, ptr %arr.data49, i64 %32
  %key51 = load ptr, ptr %key, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %key51)
  %33 = load ptr, ptr %arr.elem50, align 8
  call void @__polaron_str_free(ptr %33)
  store ptr %strcpy, ptr %arr.elem50, align 8
  %values52 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %34 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %34, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.614, ptr @.faila.615, i64 %34, ptr @.failb.616, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds ptr, ptr %arr.data59, i64 %34
  %value61 = load ptr, ptr %value, align 8
  %strcpy62 = call ptr @__polaron_str_copy(ptr %value61)
  %35 = load ptr, ptr %arr.elem60, align 8
  call void @__polaron_str_free(ptr %35)
  store ptr %strcpy62, ptr %arr.elem60, align 8
  br label %if.end29

idx.bad68:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.617, ptr @.faila.618, i64 %28, ptr @.failb.619, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %if.else
  %arr.data70 = getelementptr i8, ptr %values64, i64 8
  %arr.elem71 = getelementptr inbounds ptr, ptr %arr.data70, i64 %28
  %combine72 = load ptr, ptr %combine, align 8
  %code = load ptr, ptr %combine72, align 8
  %36 = getelementptr ptr, ptr %combine72, i32 1
  %env = load ptr, ptr %36, align 8
  %values73 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values74 = load ptr, ptr %values73, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i75 = load i32, ptr %i, align 4
  %37 = sext i32 %i75 to i64
  %arr.len76 = load i64, ptr %values74, align 8
  %arr.oob77 = icmp uge i64 %37, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !8

idx.bad78:                                        ; preds = %idx.ok69
  call void @__polaron_fail(ptr @.fail.620, ptr @.faila.621, i64 %37, ptr @.failb.622, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %idx.ok69
  %arr.data80 = getelementptr i8, ptr %values74, i64 8
  %arr.elem81 = getelementptr inbounds ptr, ptr %arr.data80, i64 %37
  %elem82 = load ptr, ptr %arr.elem81, align 8
  %value83 = load ptr, ptr %value, align 8
  %38 = call ptr %code(ptr %env, ptr %elem82, ptr %value83)
  %strcpy84 = call ptr @__polaron_str_copy(ptr %38)
  %39 = load ptr, ptr %arr.elem71, align 8
  call void @__polaron_str_free(ptr %39)
  store ptr %strcpy84, ptr %arr.elem71, align 8
  br label %if.end29

contract.fail:                                    ; preds = %if.end29
  %count87 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count88 = load i32, ptr %count87, align 4, !tbaa !4
  %contract.l = sext i32 %count88 to i64
  call void @__polaron_fail(ptr @.contract.623, ptr @.cl.624, i64 %contract.l, ptr @.cr.625, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end29
  %count89 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count90 = load i32, ptr %count89, align 4, !tbaa !4
  %cap91 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap92 = load i32, ptr %cap91, align 4, !tbaa !4
  %40 = icmp slt i32 %count90, %cap92
  %41 = zext i1 %40 to i32
  %contract.ok93 = icmp ne i32 %41, 0
  br i1 %contract.ok93, label %contract.cont95, label %contract.fail94

contract.fail94:                                  ; preds = %contract.cont
  %count96 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count97 = load i32, ptr %count96, align 4, !tbaa !4
  %cap98 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap99 = load i32, ptr %cap98, align 4, !tbaa !4
  %contract.l100 = sext i32 %count97 to i64
  %contract.r = sext i32 %cap99 to i64
  call void @__polaron_fail(ptr @.contract.626, ptr @.cl.627, i64 %contract.l100, ptr @.cr.628, i64 %contract.r, i32 1)
  unreachable

contract.cont95:                                  ; preds = %contract.cont
  %keys101 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys102 = load ptr, ptr %keys101, align 8, !tbaa !0
  %len103 = load i64, ptr %keys102, align 8
  %42 = trunc i64 %len103 to i32
  %cap104 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap105 = load i32, ptr %cap104, align 4, !tbaa !4
  %43 = icmp eq i32 %42, %cap105
  %44 = zext i1 %43 to i32
  %contract.ok106 = icmp ne i32 %44, 0
  br i1 %contract.ok106, label %contract.cont108, label %contract.fail107

contract.fail107:                                 ; preds = %contract.cont95
  call void @__polaron_fail(ptr @.contract.629, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont108:                                 ; preds = %contract.cont95
  %values109 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values110 = load ptr, ptr %values109, align 8, !tbaa !0
  %len111 = load i64, ptr %values110, align 8
  %45 = trunc i64 %len111 to i32
  %cap112 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap113 = load i32, ptr %cap112, align 4, !tbaa !4
  %46 = icmp eq i32 %45, %cap113
  %47 = zext i1 %46 to i32
  %contract.ok114 = icmp ne i32 %47, 0
  br i1 %contract.ok114, label %contract.cont116, label %contract.fail115

contract.fail115:                                 ; preds = %contract.cont108
  call void @__polaron_fail(ptr @.contract.630, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont116:                                 ; preds = %contract.cont108
  %used117 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used118 = load ptr, ptr %used117, align 8, !tbaa !0
  %len119 = load i64, ptr %used118, align 8
  %48 = trunc i64 %len119 to i32
  %cap120 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap121 = load i32, ptr %cap120, align 4, !tbaa !4
  %49 = icmp eq i32 %48, %cap121
  %50 = zext i1 %49 to i32
  %contract.ok122 = icmp ne i32 %50, 0
  br i1 %contract.ok122, label %contract.cont124, label %contract.fail123

contract.fail123:                                 ; preds = %contract.cont116
  call void @__polaron_fail(ptr @.contract.631, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont124:                                 ; preds = %contract.cont116
  ret void
}

define internal i32 @"HashMap$String$String.remove"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %rv = alloca ptr, align 8
  %rk = alloca ptr, align 8
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key20)
  store i32 %15, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %16 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.632, ptr @.faila.633, i64 %16, ptr @.failb.634, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used22, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %16
  %elem = load i8, ptr %arr.elem, align 1
  %17 = sext i8 %elem to i32
  %18 = icmp eq i32 %17, 0
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %count24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count25 = load i32, ptr %count24, align 4, !tbaa !4
  %20 = icmp sge i32 %count25, 0
  %21 = zext i1 %20 to i32
  %contract.ok = icmp ne i32 %21, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

if.end:                                           ; preds = %idx.ok
  %cap48 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap49 = load i32, ptr %cap48, align 4, !tbaa !4
  %22 = sub i32 %cap49, 1
  store i32 %22, ptr %mask, align 4
  %used50 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used51 = load ptr, ptr %used50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i52 = load i32, ptr %i, align 4
  %23 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %used51, align 8
  %arr.oob54 = icmp uge i64 %23, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

contract.fail:                                    ; preds = %if.then
  %count26 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !4
  %contract.l = sext i32 %count27 to i64
  call void @__polaron_fail(ptr @.contract.635, ptr @.cl.636, i64 %contract.l, ptr @.cr.637, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  %count28 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %cap30 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap31 = load i32, ptr %cap30, align 4, !tbaa !4
  %24 = icmp slt i32 %count29, %cap31
  %25 = zext i1 %24 to i32
  %contract.ok32 = icmp ne i32 %25, 0
  br i1 %contract.ok32, label %contract.cont34, label %contract.fail33

contract.fail33:                                  ; preds = %contract.cont
  %count35 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %cap37 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap38 = load i32, ptr %cap37, align 4, !tbaa !4
  %contract.l39 = sext i32 %count36 to i64
  %contract.r = sext i32 %cap38 to i64
  call void @__polaron_fail(ptr @.contract.638, ptr @.cl.639, i64 %contract.l39, ptr @.cr.640, i64 %contract.r, i32 1)
  unreachable

contract.cont34:                                  ; preds = %contract.cont
  %used40 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used41 = load ptr, ptr %used40, align 8, !tbaa !0
  %len42 = load i64, ptr %used41, align 8
  %26 = trunc i64 %len42 to i32
  %cap43 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !4
  %27 = icmp eq i32 %26, %cap44
  %28 = zext i1 %27 to i32
  %contract.ok45 = icmp ne i32 %28, 0
  br i1 %contract.ok45, label %contract.cont47, label %contract.fail46

contract.fail46:                                  ; preds = %contract.cont34
  call void @__polaron_fail(ptr @.contract.641, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret i32 0

idx.bad55:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.642, ptr @.faila.643, i64 %23, ptr @.failb.644, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %if.end
  %arr.data57 = getelementptr i8, ptr %used51, i64 8
  %arr.elem58 = getelementptr inbounds i8, ptr %arr.data57, i64 %23
  store i8 0, ptr %arr.elem58, align 1
  %count59 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count60 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count61 = load i32, ptr %count60, align 4, !tbaa !4
  %29 = sub i32 %count61, 1
  store i32 %29, ptr %count59, align 4, !tbaa !4
  %i62 = load i32, ptr %i, align 4
  %30 = add i32 %i62, 1
  %mask63 = load i32, ptr %mask, align 4
  %31 = and i32 %30, %mask63
  store i32 %31, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok101, %idx.ok56
  %used64 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used65 = load ptr, ptr %used64, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j66 = load i32, ptr %j, align 4
  %32 = sext i32 %j66 to i64
  %arr.len67 = load i64, ptr %used65, align 8
  %arr.oob68 = icmp uge i64 %32, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !8

while.body:                                       ; preds = %idx.ok70
  %keys74 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys75 = load ptr, ptr %keys74, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j76 = load i32, ptr %j, align 4
  %33 = sext i32 %j76 to i64
  %arr.len77 = load i64, ptr %keys75, align 8
  %arr.oob78 = icmp uge i64 %33, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !8

while.end:                                        ; preds = %idx.ok70
  %count111 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count112 = load i32, ptr %count111, align 4, !tbaa !4
  %34 = icmp sge i32 %count112, 0
  %35 = zext i1 %34 to i32
  %contract.ok113 = icmp ne i32 %35, 0
  br i1 %contract.ok113, label %contract.cont115, label %contract.fail114

idx.bad69:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.645, ptr @.faila.646, i64 %32, ptr @.failb.647, i64 %arr.len67, i32 70)
  unreachable

idx.ok70:                                         ; preds = %while.cond
  %arr.data71 = getelementptr i8, ptr %used65, i64 8
  %arr.elem72 = getelementptr inbounds i8, ptr %arr.data71, i64 %32
  %elem73 = load i8, ptr %arr.elem72, align 1
  %36 = sext i8 %elem73 to i32
  %37 = icmp ne i32 %36, 0
  %38 = zext i1 %37 to i32
  br i1 %37, label %while.body, label %while.end

idx.bad79:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.648, ptr @.faila.649, i64 %33, ptr @.failb.650, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %while.body
  %arr.data81 = getelementptr i8, ptr %keys75, i64 8
  %arr.elem82 = getelementptr inbounds ptr, ptr %arr.data81, i64 %33
  %elem83 = load ptr, ptr %arr.elem82, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem83)
  store ptr %strcpy, ptr %rk, align 8
  %values84 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values85 = load ptr, ptr %values84, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j86 = load i32, ptr %j, align 4
  %39 = sext i32 %j86 to i64
  %arr.len87 = load i64, ptr %values85, align 8
  %arr.oob88 = icmp uge i64 %39, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !8

idx.bad89:                                        ; preds = %idx.ok80
  call void @__polaron_fail(ptr @.fail.651, ptr @.faila.652, i64 %39, ptr @.failb.653, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok80
  %arr.data91 = getelementptr i8, ptr %values85, i64 8
  %arr.elem92 = getelementptr inbounds ptr, ptr %arr.data91, i64 %39
  %elem93 = load ptr, ptr %arr.elem92, align 8
  %strcpy94 = call ptr @__polaron_str_copy(ptr %elem93)
  store ptr %strcpy94, ptr %rv, align 8
  %used95 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used96 = load ptr, ptr %used95, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j97 = load i32, ptr %j, align 4
  %40 = sext i32 %j97 to i64
  %arr.len98 = load i64, ptr %used96, align 8
  %arr.oob99 = icmp uge i64 %40, %arr.len98
  br i1 %arr.oob99, label %idx.bad100, label %idx.ok101, !prof !8

idx.bad100:                                       ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.654, ptr @.faila.655, i64 %40, ptr @.failb.656, i64 %arr.len98, i32 70)
  unreachable

idx.ok101:                                        ; preds = %idx.ok90
  %arr.data102 = getelementptr i8, ptr %used96, i64 8
  %arr.elem103 = getelementptr inbounds i8, ptr %arr.data102, i64 %40
  store i8 0, ptr %arr.elem103, align 1
  %count104 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count105 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count106 = load i32, ptr %count105, align 4, !tbaa !4
  %41 = sub i32 %count106, 1
  store i32 %41, ptr %count104, align 4, !tbaa !4
  %rk107 = load ptr, ptr %rk, align 8
  %rv108 = load ptr, ptr %rv, align 8
  call void @"HashMap$String$String.put"(ptr %0, ptr %rk107, ptr %rv108)
  %j109 = load i32, ptr %j, align 4
  %42 = add i32 %j109, 1
  %mask110 = load i32, ptr %mask, align 4
  %43 = and i32 %42, %mask110
  store i32 %43, ptr %j, align 4
  %44 = load ptr, ptr %rv, align 8
  call void @__polaron_str_free(ptr %44)
  %45 = load ptr, ptr %rk, align 8
  call void @__polaron_str_free(ptr %45)
  br label %while.cond

contract.fail114:                                 ; preds = %while.end
  %count116 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count117 = load i32, ptr %count116, align 4, !tbaa !4
  %contract.l118 = sext i32 %count117 to i64
  call void @__polaron_fail(ptr @.contract.657, ptr @.cl.658, i64 %contract.l118, ptr @.cr.659, i64 0, i32 1)
  unreachable

contract.cont115:                                 ; preds = %while.end
  %count119 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count120 = load i32, ptr %count119, align 4, !tbaa !4
  %cap121 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap122 = load i32, ptr %cap121, align 4, !tbaa !4
  %46 = icmp slt i32 %count120, %cap122
  %47 = zext i1 %46 to i32
  %contract.ok123 = icmp ne i32 %47, 0
  br i1 %contract.ok123, label %contract.cont125, label %contract.fail124

contract.fail124:                                 ; preds = %contract.cont115
  %count126 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count127 = load i32, ptr %count126, align 4, !tbaa !4
  %cap128 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap129 = load i32, ptr %cap128, align 4, !tbaa !4
  %contract.l130 = sext i32 %count127 to i64
  %contract.r131 = sext i32 %cap129 to i64
  call void @__polaron_fail(ptr @.contract.660, ptr @.cl.661, i64 %contract.l130, ptr @.cr.662, i64 %contract.r131, i32 1)
  unreachable

contract.cont125:                                 ; preds = %contract.cont115
  %used132 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used133 = load ptr, ptr %used132, align 8, !tbaa !0
  %len134 = load i64, ptr %used133, align 8
  %48 = trunc i64 %len134 to i32
  %cap135 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap136 = load i32, ptr %cap135, align 4, !tbaa !4
  %49 = icmp eq i32 %48, %cap136
  %50 = zext i1 %49 to i32
  %contract.ok137 = icmp ne i32 %50, 0
  br i1 %contract.ok137, label %contract.cont139, label %contract.fail138

contract.fail138:                                 ; preds = %contract.cont125
  call void @__polaron_fail(ptr @.contract.663, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont139:                                 ; preds = %contract.cont125
  ret i32 1
}

define internal ptr @"HashMap$String$String.keyArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %14 = sext i32 %count21 to i64
  %15 = mul i64 %14, 8
  %16 = add i64 8, %15
  %arr = call ptr @__polaron_malloc(i64 %16)
  store i64 %14, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %17 = call ptr @memset(ptr %arr.data, i32 0, i64 %15)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %j, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i22 = load i32, ptr %i, align 4
  %cap23 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !4
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %20 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out48 = load ptr, ptr %out, align 8
  ret ptr %out48

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.664, ptr @.faila.665, i64 %20, ptr @.failb.666, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data28 = getelementptr i8, ptr %used26, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data28, i64 %20
  %elem = load i8, ptr %arr.elem, align 1
  %23 = sext i8 %elem to i32
  %24 = icmp ne i32 %23, 0
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %out29 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %j30 = load i32, ptr %j, align 4
  %26 = sext i32 %j30 to i64
  %arr.len31 = load i64, ptr %out29, align 8
  %arr.oob32 = icmp uge i64 %26, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !8

if.end:                                           ; preds = %idx.ok43, %idx.ok
  br label %for.update

idx.bad33:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.667, ptr @.faila.668, i64 %26, ptr @.failb.669, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds ptr, ptr %arr.data35, i64 %26
  %keys37 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys38 = load ptr, ptr %keys37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %keys38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.670, ptr @.faila.671, i64 %27, ptr @.failb.672, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %keys38, i64 8
  %arr.elem45 = getelementptr inbounds ptr, ptr %arr.data44, i64 %27
  %elem46 = load ptr, ptr %arr.elem45, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem46)
  %28 = load ptr, ptr %arr.elem36, align 8
  call void @__polaron_str_free(ptr %28)
  store ptr %strcpy, ptr %arr.elem36, align 8
  %j47 = load i32, ptr %j, align 4
  %29 = add i32 %j47, 1
  store i32 %29, ptr %j, align 4
  br label %if.end
}

define internal ptr @"HashMap$String$String.valueArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %14 = sext i32 %count21 to i64
  %15 = mul i64 %14, 8
  %16 = add i64 8, %15
  %arr = call ptr @__polaron_malloc(i64 %16)
  store i64 %14, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %17 = call ptr @memset(ptr %arr.data, i32 0, i64 %15)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %j, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i22 = load i32, ptr %i, align 4
  %cap23 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !4
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %20 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out48 = load ptr, ptr %out, align 8
  ret ptr %out48

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.673, ptr @.faila.674, i64 %20, ptr @.failb.675, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data28 = getelementptr i8, ptr %used26, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data28, i64 %20
  %elem = load i8, ptr %arr.elem, align 1
  %23 = sext i8 %elem to i32
  %24 = icmp ne i32 %23, 0
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %out29 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %j30 = load i32, ptr %j, align 4
  %26 = sext i32 %j30 to i64
  %arr.len31 = load i64, ptr %out29, align 8
  %arr.oob32 = icmp uge i64 %26, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !8

if.end:                                           ; preds = %idx.ok43, %idx.ok
  br label %for.update

idx.bad33:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.676, ptr @.faila.677, i64 %26, ptr @.failb.678, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds ptr, ptr %arr.data35, i64 %26
  %values37 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values38 = load ptr, ptr %values37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %values38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.679, ptr @.faila.680, i64 %27, ptr @.failb.681, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %values38, i64 8
  %arr.elem45 = getelementptr inbounds ptr, ptr %arr.data44, i64 %27
  %elem46 = load ptr, ptr %arr.elem45, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem46)
  %28 = load ptr, ptr %arr.elem36, align 8
  call void @__polaron_str_free(ptr %28)
  store ptr %strcpy, ptr %arr.elem36, align 8
  %j47 = load i32, ptr %j, align 4
  %29 = add i32 %j47, 1
  store i32 %29, ptr %j, align 4
  br label %if.end
}

define internal i32 @"HashMap$String$String.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  ret i32 %count21
}

define internal i32 @"HashMap$String$String.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %14 = icmp eq i32 %count21, 0
  %15 = zext i1 %14 to i32
  ret i32 %15
}

define internal void @"ArrayList$String.ArrayList$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.1098, ptr @.cl.1099, i64 %contract.l, ptr @.cr.1100, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1101, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$String.~ArrayList$String"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  %ae.len = load i64, ptr %data1, align 8
  %arr.data = getelementptr i8, ptr %data1, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

ae.cond:                                          ; preds = %ae.next, %entry
  %ae.iv = load i64, ptr %ae.i, align 8
  %1 = icmp ult i64 %ae.iv, %ae.len
  br i1 %1, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %2 = icmp ne ptr %ae.el, null
  br i1 %2, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %3 = add i64 %ae.iv, 1
  store i64 %3, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data1)
  ret void
}

define internal void @"ArrayList$String.add"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %old = alloca i32, align 4
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  store i32 %count7, ptr %old, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %7 = trunc i64 %len12 to i32
  %8 = icmp sge i32 %count9, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %10 = trunc i64 %len15 to i32
  %11 = mul i32 %10, 2
  %12 = sext i32 %11 to i64
  %13 = mul i64 %12, 8
  %14 = add i64 8, %13
  %arr = call ptr @__polaron_malloc(i64 %14)
  store i64 %12, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %15 = call ptr @memset(ptr %arr.data, i32 0, i64 %13)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

if.end:                                           ; preds = %ae.end, %entry
  %data36 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data37 = load ptr, ptr %data36, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count38 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count39 = load i32, ptr %count38, align 4, !tbaa !4
  %16 = sext i32 %count39 to i64
  %arr.len40 = load i64, ptr %data37, align 8
  %arr.oob41 = icmp uge i64 %16, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %17 = icmp slt i32 %i16, %count18
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger19 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i, align 4
  %19 = sext i32 %i20 to i64
  %arr.len = load i64, ptr %bigger19, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok28
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  %ae.len = load i64, ptr %data32, align 8
  %arr.data33 = getelementptr i8, ptr %data32, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1102, ptr @.faila.1103, i64 %19, ptr @.failb.1104, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %bigger19, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data21, i64 %19
  %data22 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %22 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %22, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1105, ptr @.faila.1106, i64 %22, ptr @.failb.1107, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok
  %arr.data29 = getelementptr i8, ptr %data23, i64 8
  %arr.elem30 = getelementptr inbounds ptr, ptr %arr.data29, i64 %22
  %elem = load ptr, ptr %arr.elem30, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  %23 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %23)
  store ptr %strcpy, ptr %arr.elem, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %24 = icmp ult i64 %ae.iv, %ae.len
  br i1 %24, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data33, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %25 = icmp ne ptr %ae.el, null
  br i1 %25, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %26 = add i64 %ae.iv, 1
  store i64 %26, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data32)
  %data34 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %bigger35 = load ptr, ptr %bigger, align 8
  store ptr %bigger35, ptr %data34, align 8, !tbaa !0
  br label %if.end

idx.bad42:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1108, ptr @.faila.1109, i64 %16, ptr @.failb.1110, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %if.end
  %arr.data44 = getelementptr i8, ptr %data37, i64 8
  %arr.elem45 = getelementptr inbounds ptr, ptr %arr.data44, i64 %16
  %item46 = load ptr, ptr %item, align 8
  %strcpy47 = call ptr @__polaron_str_copy(ptr %item46)
  %27 = load ptr, ptr %arr.elem45, align 8
  call void @__polaron_str_free(ptr %27)
  store ptr %strcpy47, ptr %arr.elem45, align 8
  %count48 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count49 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count50 = load i32, ptr %count49, align 4, !tbaa !4
  %28 = add i32 %count50, 1
  store i32 %28, ptr %count48, align 4, !tbaa !4
  %count51 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !4
  %old53 = load i32, ptr %old, align 4
  %29 = add i32 %old53, 1
  %30 = icmp eq i32 %count52, %29
  %31 = zext i1 %30 to i32
  %contract.ok = icmp ne i32 %31, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok43
  call void @__polaron_fail(ptr @.contract.1111, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok43
  %count54 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !4
  %32 = icmp sge i32 %count55, 0
  %33 = zext i1 %32 to i32
  %contract.ok56 = icmp ne i32 %33, 0
  br i1 %contract.ok56, label %contract.cont58, label %contract.fail57

contract.fail57:                                  ; preds = %contract.cont
  %count59 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count60 = load i32, ptr %count59, align 4, !tbaa !4
  %contract.l = sext i32 %count60 to i64
  call void @__polaron_fail(ptr @.contract.1112, ptr @.cl.1113, i64 %contract.l, ptr @.cr.1114, i64 0, i32 1)
  unreachable

contract.cont58:                                  ; preds = %contract.cont
  %count61 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count62 = load i32, ptr %count61, align 4, !tbaa !4
  %data63 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data64 = load ptr, ptr %data63, align 8, !tbaa !0
  %len65 = load i64, ptr %data64, align 8
  %34 = trunc i64 %len65 to i32
  %35 = icmp sle i32 %count62, %34
  %36 = zext i1 %35 to i32
  %contract.ok66 = icmp ne i32 %36, 0
  br i1 %contract.ok66, label %contract.cont68, label %contract.fail67

contract.fail67:                                  ; preds = %contract.cont58
  call void @__polaron_fail(ptr @.contract.1115, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont68:                                  ; preds = %contract.cont58
  ret void
}

define internal void @"ArrayList$String.ensureCapacity"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data7, align 8, !tbaa !0
  %len9 = load i64, ptr %data8, align 8
  %7 = trunc i64 %len9 to i32
  %8 = icmp sgt i32 %n6, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %n10 = load i32, ptr %n, align 4
  %10 = sext i32 %n10 to i64
  %11 = mul i64 %10, 8
  %12 = add i64 8, %11
  %arr = call ptr @__polaron_malloc(i64 %12)
  store i64 %10, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %13 = call ptr @memset(ptr %arr.data, i32 0, i64 %11)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

if.end:                                           ; preds = %ae.end, %entry
  %count31 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !4
  %14 = icmp sge i32 %count32, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count13 = load i32, ptr %count12, align 4, !tbaa !4
  %16 = icmp slt i32 %i11, %count13
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger14 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %18 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %bigger14, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok23
  %19 = load i32, ptr %i, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data26 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data27 = load ptr, ptr %data26, align 8, !tbaa !0
  %ae.len = load i64, ptr %data27, align 8
  %arr.data28 = getelementptr i8, ptr %data27, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1116, ptr @.faila.1117, i64 %18, ptr @.failb.1118, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1119, ptr @.faila.1120, i64 %21, ptr @.failb.1121, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %21
  %elem = load ptr, ptr %arr.elem25, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  %22 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %22)
  store ptr %strcpy, ptr %arr.elem, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %23 = icmp ult i64 %ae.iv, %ae.len
  br i1 %23, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data28, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %24 = icmp ne ptr %ae.el, null
  br i1 %24, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %25 = add i64 %ae.iv, 1
  store i64 %25, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data27)
  %data29 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %bigger30 = load ptr, ptr %bigger, align 8
  store ptr %bigger30, ptr %data29, align 8, !tbaa !0
  br label %if.end

contract.fail:                                    ; preds = %if.end
  %count33 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count34 = load i32, ptr %count33, align 4, !tbaa !4
  %contract.l = sext i32 %count34 to i64
  call void @__polaron_fail(ptr @.contract.1122, ptr @.cl.1123, i64 %contract.l, ptr @.cr.1124, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count35 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %data37 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !0
  %len39 = load i64, ptr %data38, align 8
  %26 = trunc i64 %len39 to i32
  %27 = icmp sle i32 %count36, %26
  %28 = zext i1 %27 to i32
  %contract.ok40 = icmp ne i32 %28, 0
  br i1 %contract.ok40, label %contract.cont42, label %contract.fail41

contract.fail41:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1125, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont42:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$String.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %i6 = load i32, ptr %i, align 4
  %7 = icmp slt i32 %i6, 0
  %8 = zext i1 %7 to i32
  %sc.a = icmp ne i32 %8, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i7 = load i32, ptr %i, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %9 = icmp sge i32 %i7, %count9
  %10 = zext i1 %9 to i32
  %sc.b = icmp ne i32 %10, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %11 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1126, ptr @.faila.1127, i64 %13, ptr @.failb.1128, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1129, ptr @.faila.1130, i64 %14, ptr @.failb.1131, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %if.end
  %arr.data22 = getelementptr i8, ptr %data16, i64 8
  %arr.elem23 = getelementptr inbounds ptr, ptr %arr.data22, i64 %14
  %elem24 = load ptr, ptr %arr.elem23, align 8
  %strcpy25 = call ptr @__polaron_str_copy(ptr %elem24)
  ret ptr %strcpy25
}

define internal void @"ArrayList$String.set"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store ptr %2, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %5 = trunc i64 %len to i32
  %6 = icmp sle i32 %count3, %5
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %i6 = load i32, ptr %i, align 4
  %8 = icmp slt i32 %i6, 0
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i7 = load i32, ptr %i, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %10 = icmp sge i32 %i7, %count9
  %11 = zext i1 %10 to i32
  %sc.b = icmp ne i32 %11, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %12 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data21 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %15 = sext i32 %i23 to i64
  %arr.len24 = load i64, ptr %data22, align 8
  %arr.oob25 = icmp uge i64 %15, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1132, ptr @.faila.1133, i64 %14, ptr @.failb.1134, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %14
  %item15 = load ptr, ptr %item, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %item15)
  %16 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %16)
  store ptr %strcpy, ptr %arr.elem, align 8
  %count16 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count17 = load i32, ptr %count16, align 4, !tbaa !4
  %data18 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data19 = load ptr, ptr %data18, align 8, !tbaa !0
  %len20 = load i64, ptr %data19, align 8
  %17 = trunc i64 %len20 to i32
  %18 = icmp sle i32 %count17, %17
  %19 = zext i1 %18 to i32
  %contract.ok = icmp ne i32 %19, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  call void @__polaron_fail(ptr @.contract.1135, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad26:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1136, ptr @.faila.1137, i64 %15, ptr @.failb.1138, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %if.end
  %arr.data28 = getelementptr i8, ptr %data22, i64 8
  %arr.elem29 = getelementptr inbounds ptr, ptr %arr.data28, i64 %15
  %item30 = load ptr, ptr %item, align 8
  %strcpy31 = call ptr @__polaron_str_copy(ptr %item30)
  %20 = load ptr, ptr %arr.elem29, align 8
  call void @__polaron_str_free(ptr %20)
  store ptr %strcpy31, ptr %arr.elem29, align 8
  %count32 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count33 = load i32, ptr %count32, align 4, !tbaa !4
  %data34 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data35 = load ptr, ptr %data34, align 8, !tbaa !0
  %len36 = load i64, ptr %data35, align 8
  %21 = trunc i64 %len36 to i32
  %22 = icmp sle i32 %count33, %21
  %23 = zext i1 %22 to i32
  %contract.ok37 = icmp ne i32 %23, 0
  br i1 %contract.ok37, label %contract.cont39, label %contract.fail38

contract.fail38:                                  ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.contract.1139, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont39:                                  ; preds = %idx.ok27
  ret void
}

define internal i32 @"ArrayList$String.indexOf"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data9 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data10 = load ptr, ptr %data9, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i11 = load i32, ptr %i, align 4
  %9 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %data10, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 -1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1140, ptr @.faila.1141, i64 %9, ptr @.failb.1142, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data10, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %9
  %elem = load ptr, ptr %arr.elem, align 8
  %item12 = load ptr, ptr %item, align 8
  %str.data = getelementptr inbounds %String, ptr %elem, i32 0, i32 1
  %data13 = load ptr, ptr %str.data, align 8
  %str.data14 = getelementptr inbounds %String, ptr %item12, i32 0, i32 1
  %data15 = load ptr, ptr %str.data14, align 8
  %12 = call i32 @strcmp(ptr %data13, ptr %data15)
  %13 = icmp eq i32 %12, 0
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %i16 = load i32, ptr %i, align 4
  ret i32 %i16

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$String.contains"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load ptr, ptr %item, align 8
  %7 = call i32 @"ArrayList$String.indexOf"(ptr %0, ptr %item6)
  %8 = icmp sge i32 %7, 0
  %9 = zext i1 %8 to i32
  ret i32 %9
}

define internal void @"ArrayList$String.removeAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %oob = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %i6 = load i32, ptr %i, align 4
  %7 = icmp slt i32 %i6, 0
  %8 = zext i1 %7 to i32
  %sc.a = icmp ne i32 %8, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i7 = load i32, ptr %i, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %9 = icmp sge i32 %i7, %count9
  %10 = zext i1 %9 to i32
  %sc.b = icmp ne i32 %10, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %11 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %i27 = load i32, ptr %i, align 4
  store i32 %i27, ptr %j, align 4
  br label %for.cond

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1143, ptr @.faila.1144, i64 %13, ptr @.failb.1145, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  store ptr %strcpy, ptr %oob, align 8
  %count15 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %14 = icmp sge i32 %count16, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %contract.l = sext i32 %count18 to i64
  call void @__polaron_fail(ptr @.contract.1146, ptr @.cl.1147, i64 %contract.l, ptr @.cr.1148, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %data21 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0
  %len23 = load i64, ptr %data22, align 8
  %16 = trunc i64 %len23 to i32
  %17 = icmp sle i32 %count20, %16
  %18 = zext i1 %17 to i32
  %contract.ok24 = icmp ne i32 %18, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1149, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont
  %19 = load ptr, ptr %oob, align 8
  call void @__polaron_str_free(ptr %19)
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j28 = load i32, ptr %j, align 4
  %count29 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %20 = sub i32 %count30, 1
  %21 = icmp slt i32 %j28, %20
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j33 = load i32, ptr %j, align 4
  %23 = sext i32 %j33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %23, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

for.update:                                       ; preds = %idx.ok46
  %24 = load i32, ptr %j, align 4
  %25 = add i32 %24, 1
  store i32 %25, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count51 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count52 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !4
  %26 = sub i32 %count53, 1
  store i32 %26, ptr %count51, align 4, !tbaa !4
  %count54 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !4
  %27 = icmp sge i32 %count55, 0
  %28 = zext i1 %27 to i32
  %contract.ok56 = icmp ne i32 %28, 0
  br i1 %contract.ok56, label %contract.cont58, label %contract.fail57

idx.bad36:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1150, ptr @.faila.1151, i64 %23, ptr @.failb.1152, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %for.body
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 %23
  %data40 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data41 = load ptr, ptr %data40, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j42 = load i32, ptr %j, align 4
  %29 = add i32 %j42, 1
  %30 = sext i32 %29 to i64
  %arr.len43 = load i64, ptr %data41, align 8
  %arr.oob44 = icmp uge i64 %30, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !8

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.1153, ptr @.faila.1154, i64 %30, ptr @.failb.1155, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok37
  %arr.data47 = getelementptr i8, ptr %data41, i64 8
  %arr.elem48 = getelementptr inbounds ptr, ptr %arr.data47, i64 %30
  %elem49 = load ptr, ptr %arr.elem48, align 8
  %strcpy50 = call ptr @__polaron_str_copy(ptr %elem49)
  %31 = load ptr, ptr %arr.elem39, align 8
  call void @__polaron_str_free(ptr %31)
  store ptr %strcpy50, ptr %arr.elem39, align 8
  br label %for.update

contract.fail57:                                  ; preds = %for.end
  %count59 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count60 = load i32, ptr %count59, align 4, !tbaa !4
  %contract.l61 = sext i32 %count60 to i64
  call void @__polaron_fail(ptr @.contract.1156, ptr @.cl.1157, i64 %contract.l61, ptr @.cr.1158, i64 0, i32 1)
  unreachable

contract.cont58:                                  ; preds = %for.end
  %count62 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count63 = load i32, ptr %count62, align 4, !tbaa !4
  %data64 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data65 = load ptr, ptr %data64, align 8, !tbaa !0
  %len66 = load i64, ptr %data65, align 8
  %32 = trunc i64 %len66 to i32
  %33 = icmp sle i32 %count63, %32
  %34 = zext i1 %33 to i32
  %contract.ok67 = icmp ne i32 %34, 0
  br i1 %contract.ok67, label %contract.cont69, label %contract.fail68

contract.fail68:                                  ; preds = %contract.cont58
  call void @__polaron_fail(ptr @.contract.1159, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont69:                                  ; preds = %contract.cont58
  ret void
}

define internal void @"ArrayList$String.insertAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %j = alloca i32, align 4
  %ae.i = alloca i64, align 8
  %k = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store ptr %2, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %5 = trunc i64 %len to i32
  %6 = icmp sle i32 %count3, %5
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %i6 = load i32, ptr %i, align 4
  %8 = icmp slt i32 %i6, 0
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i7 = load i32, ptr %i, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %10 = icmp sgt i32 %i7, %count9
  %11 = zext i1 %10 to i32
  %sc.b = icmp ne i32 %11, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %12 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %count28 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %data30 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data31 = load ptr, ptr %data30, align 8, !tbaa !0
  %len32 = load i64, ptr %data31, align 8
  %15 = trunc i64 %len32 to i32
  %16 = icmp sge i32 %count29, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then33, label %if.end34

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1160, ptr @.faila.1161, i64 %14, ptr @.failb.1162, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %14
  %item15 = load ptr, ptr %item, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %item15)
  %18 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %18)
  store ptr %strcpy, ptr %arr.elem, align 8
  %count16 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count17 = load i32, ptr %count16, align 4, !tbaa !4
  %19 = icmp sge i32 %count17, 0
  %20 = zext i1 %19 to i32
  %contract.ok = icmp ne i32 %20, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count18 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count19 = load i32, ptr %count18, align 4, !tbaa !4
  %contract.l = sext i32 %count19 to i64
  call void @__polaron_fail(ptr @.contract.1163, ptr @.cl.1164, i64 %contract.l, ptr @.cr.1165, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count20 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %data22 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0
  %len24 = load i64, ptr %data23, align 8
  %21 = trunc i64 %len24 to i32
  %22 = icmp sle i32 %count21, %21
  %23 = zext i1 %22 to i32
  %contract.ok25 = icmp ne i32 %23, 0
  br i1 %contract.ok25, label %contract.cont27, label %contract.fail26

contract.fail26:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1166, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont27:                                  ; preds = %contract.cont
  ret void

if.then33:                                        ; preds = %if.end
  %data35 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0
  %len37 = load i64, ptr %data36, align 8
  %24 = trunc i64 %len37 to i32
  %25 = mul i32 %24, 2
  %26 = sext i32 %25 to i64
  %27 = mul i64 %26, 8
  %28 = add i64 8, %27
  %arr = call ptr @__polaron_malloc(i64 %28)
  store i64 %26, ptr %arr, align 8
  %arr.data38 = getelementptr i8, ptr %arr, i64 8
  %29 = call ptr @memset(ptr %arr.data38, i32 0, i64 %27)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond

if.end34:                                         ; preds = %ae.end, %if.end
  %count65 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count66 = load i32, ptr %count65, align 4, !tbaa !4
  store i32 %count66, ptr %j, align 4
  br label %for.cond67

for.cond:                                         ; preds = %for.update, %if.then33
  %k39 = load i32, ptr %k, align 4
  %count40 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %30 = icmp slt i32 %k39, %count41
  %31 = zext i1 %30 to i32
  br i1 %30, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger42 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %k43 = load i32, ptr %k, align 4
  %32 = sext i32 %k43 to i64
  %arr.len44 = load i64, ptr %bigger42, align 8
  %arr.oob45 = icmp uge i64 %32, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !8

for.update:                                       ; preds = %idx.ok56
  %33 = load i32, ptr %k, align 4
  %34 = add i32 %33, 1
  store i32 %34, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data60 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data61 = load ptr, ptr %data60, align 8, !tbaa !0
  %ae.len = load i64, ptr %data61, align 8
  %arr.data62 = getelementptr i8, ptr %data61, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad46:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1167, ptr @.faila.1168, i64 %32, ptr @.failb.1169, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %for.body
  %arr.data48 = getelementptr i8, ptr %bigger42, i64 8
  %arr.elem49 = getelementptr inbounds ptr, ptr %arr.data48, i64 %32
  %data50 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %k52 = load i32, ptr %k, align 4
  %35 = sext i32 %k52 to i64
  %arr.len53 = load i64, ptr %data51, align 8
  %arr.oob54 = icmp uge i64 %35, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.1170, ptr @.faila.1171, i64 %35, ptr @.failb.1172, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok47
  %arr.data57 = getelementptr i8, ptr %data51, i64 8
  %arr.elem58 = getelementptr inbounds ptr, ptr %arr.data57, i64 %35
  %elem = load ptr, ptr %arr.elem58, align 8
  %strcpy59 = call ptr @__polaron_str_copy(ptr %elem)
  %36 = load ptr, ptr %arr.elem49, align 8
  call void @__polaron_str_free(ptr %36)
  store ptr %strcpy59, ptr %arr.elem49, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %37 = icmp ult i64 %ae.iv, %ae.len
  br i1 %37, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data62, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %38 = icmp ne ptr %ae.el, null
  br i1 %38, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %39 = add i64 %ae.iv, 1
  store i64 %39, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data61)
  %data63 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %bigger64 = load ptr, ptr %bigger, align 8
  store ptr %bigger64, ptr %data63, align 8, !tbaa !0
  br label %if.end34

for.cond67:                                       ; preds = %for.update69, %if.end34
  %j71 = load i32, ptr %j, align 4
  %i72 = load i32, ptr %i, align 4
  %40 = icmp sgt i32 %j71, %i72
  %41 = zext i1 %40 to i32
  br i1 %40, label %for.body68, label %for.end70

for.body68:                                       ; preds = %for.cond67
  %data73 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data74 = load ptr, ptr %data73, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j75 = load i32, ptr %j, align 4
  %42 = sext i32 %j75 to i64
  %arr.len76 = load i64, ptr %data74, align 8
  %arr.oob77 = icmp uge i64 %42, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !8

for.update69:                                     ; preds = %idx.ok88
  %43 = load i32, ptr %j, align 4
  %44 = sub i32 %43, 1
  store i32 %44, ptr %j, align 4
  br label %for.cond67

for.end70:                                        ; preds = %for.cond67
  %data93 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data94 = load ptr, ptr %data93, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i95 = load i32, ptr %i, align 4
  %45 = sext i32 %i95 to i64
  %arr.len96 = load i64, ptr %data94, align 8
  %arr.oob97 = icmp uge i64 %45, %arr.len96
  br i1 %arr.oob97, label %idx.bad98, label %idx.ok99, !prof !8

idx.bad78:                                        ; preds = %for.body68
  call void @__polaron_fail(ptr @.fail.1173, ptr @.faila.1174, i64 %42, ptr @.failb.1175, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %for.body68
  %arr.data80 = getelementptr i8, ptr %data74, i64 8
  %arr.elem81 = getelementptr inbounds ptr, ptr %arr.data80, i64 %42
  %data82 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data83 = load ptr, ptr %data82, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j84 = load i32, ptr %j, align 4
  %46 = sub i32 %j84, 1
  %47 = sext i32 %46 to i64
  %arr.len85 = load i64, ptr %data83, align 8
  %arr.oob86 = icmp uge i64 %47, %arr.len85
  br i1 %arr.oob86, label %idx.bad87, label %idx.ok88, !prof !8

idx.bad87:                                        ; preds = %idx.ok79
  call void @__polaron_fail(ptr @.fail.1176, ptr @.faila.1177, i64 %47, ptr @.failb.1178, i64 %arr.len85, i32 70)
  unreachable

idx.ok88:                                         ; preds = %idx.ok79
  %arr.data89 = getelementptr i8, ptr %data83, i64 8
  %arr.elem90 = getelementptr inbounds ptr, ptr %arr.data89, i64 %47
  %elem91 = load ptr, ptr %arr.elem90, align 8
  %strcpy92 = call ptr @__polaron_str_copy(ptr %elem91)
  %48 = load ptr, ptr %arr.elem81, align 8
  call void @__polaron_str_free(ptr %48)
  store ptr %strcpy92, ptr %arr.elem81, align 8
  br label %for.update69

idx.bad98:                                        ; preds = %for.end70
  call void @__polaron_fail(ptr @.fail.1179, ptr @.faila.1180, i64 %45, ptr @.failb.1181, i64 %arr.len96, i32 70)
  unreachable

idx.ok99:                                         ; preds = %for.end70
  %arr.data100 = getelementptr i8, ptr %data94, i64 8
  %arr.elem101 = getelementptr inbounds ptr, ptr %arr.data100, i64 %45
  %item102 = load ptr, ptr %item, align 8
  %strcpy103 = call ptr @__polaron_str_copy(ptr %item102)
  %49 = load ptr, ptr %arr.elem101, align 8
  call void @__polaron_str_free(ptr %49)
  store ptr %strcpy103, ptr %arr.elem101, align 8
  %count104 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count105 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count106 = load i32, ptr %count105, align 4, !tbaa !4
  %50 = add i32 %count106, 1
  store i32 %50, ptr %count104, align 4, !tbaa !4
  %count107 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count108 = load i32, ptr %count107, align 4, !tbaa !4
  %51 = icmp sge i32 %count108, 0
  %52 = zext i1 %51 to i32
  %contract.ok109 = icmp ne i32 %52, 0
  br i1 %contract.ok109, label %contract.cont111, label %contract.fail110

contract.fail110:                                 ; preds = %idx.ok99
  %count112 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count113 = load i32, ptr %count112, align 4, !tbaa !4
  %contract.l114 = sext i32 %count113 to i64
  call void @__polaron_fail(ptr @.contract.1182, ptr @.cl.1183, i64 %contract.l114, ptr @.cr.1184, i64 0, i32 1)
  unreachable

contract.cont111:                                 ; preds = %idx.ok99
  %count115 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count116 = load i32, ptr %count115, align 4, !tbaa !4
  %data117 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data118 = load ptr, ptr %data117, align 8, !tbaa !0
  %len119 = load i64, ptr %data118, align 8
  %53 = trunc i64 %len119 to i32
  %54 = icmp sle i32 %count116, %53
  %55 = zext i1 %54 to i32
  %contract.ok120 = icmp ne i32 %55, 0
  br i1 %contract.ok120, label %contract.cont122, label %contract.fail121

contract.fail121:                                 ; preds = %contract.cont111
  call void @__polaron_fail(ptr @.contract.1185, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont122:                                 ; preds = %contract.cont111
  ret void
}

define internal i32 @"ArrayList$String.remove"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load ptr, ptr %item, align 8
  %7 = call i32 @"ArrayList$String.indexOf"(ptr %0, ptr %item6)
  store i32 %7, ptr %i, align 4
  %i7 = load i32, ptr %i, align 4
  %8 = icmp slt i32 %i7, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %i8 = load i32, ptr %i, align 4
  call void @"ArrayList$String.removeAt"(ptr %0, i32 %i8)
  ret i32 1
}

define internal void @"ArrayList$String.clear"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !4
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.1186, ptr @.cl.1187, i64 %contract.l, ptr @.cr.1188, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1189, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$String.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = sext i32 %count7 to i64
  %7 = mul i64 %6, 8
  %8 = add i64 8, %7
  %arr = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %9 = call ptr @memset(ptr %arr.data, i32 0, i64 %7)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i8 = load i32, ptr %i, align 4
  %count9 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %10 = icmp slt i32 %i8, %count10
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out11 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %12 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %out11, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok20
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out23 = load ptr, ptr %out, align 8
  ret ptr %out23

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1190, ptr @.faila.1191, i64 %12, ptr @.failb.1192, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1193, ptr @.faila.1194, i64 %15, ptr @.failb.1195, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %15
  %elem = load ptr, ptr %arr.elem22, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  %16 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %16)
  store ptr %strcpy, ptr %arr.elem, align 8
  br label %for.update
}

define internal i32 @"ArrayList$String.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  ret i32 %count7
}

define internal i32 @"ArrayList$String.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = icmp eq i32 %count7, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal void @"ArrayList$String.forEach"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %action = alloca ptr, align 8
  store ptr %1, ptr %action, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1196, ptr @.faila.1197, i64 %10, ptr @.failb.1198, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  call void %code(ptr %env, ptr %elem)
  br label %for.update
}

define internal ptr @"ArrayList$String.filter"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %keep = alloca ptr, align 8
  store ptr %1, ptr %keep, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  call void @"ArrayList$String.ArrayList$String"(ptr %"ArrayList$String.obj")
  store ptr %"ArrayList$String.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$String.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %10 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %data14, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out27 = load ptr, ptr %out, align 8
  ret ptr %out27

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1199, ptr @.faila.1200, i64 %10, ptr @.failb.1201, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %out16 = load ptr, ptr %out, align 8
  %data17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1202, ptr @.faila.1203, i64 %15, ptr @.failb.1204, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %15
  %elem26 = load ptr, ptr %arr.elem25, align 8
  call void @"ArrayList$String.add"(ptr %out16, ptr %elem26)
  br label %if.end
}

define internal i32 @"ArrayList$String.any"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1205, ptr @.faila.1206, i64 %10, ptr @.failb.1207, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 1

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$String.all"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1208, ptr @.faila.1209, i64 %10, ptr @.failb.1210, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp eq i32 %13, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 0

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$String.count"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %hits = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  store i32 0, ptr %hits, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %hits14 = load i32, ptr %hits, align 4
  ret i32 %hits14

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1211, ptr @.faila.1212, i64 %10, ptr @.failb.1213, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %hits13 = load i32, ptr %hits, align 4
  %15 = add i32 %hits13, 1
  store i32 %15, ptr %hits, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok
  br label %for.update
}

define internal ptr @"ArrayList$String.sortedBy"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %ae.i = alloca i64, align 8
  %scratch = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  call void @"ArrayList$String.ArrayList$String"(ptr %"ArrayList$String.obj")
  store ptr %"ArrayList$String.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$String.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %9 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %data14, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out16 = load ptr, ptr %out, align 8
  %12 = call i32 @"ArrayList$String.size"(ptr %out16)
  %13 = icmp sgt i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1214, ptr @.faila.1215, i64 %9, ptr @.failb.1216, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %9
  %elem = load ptr, ptr %arr.elem, align 8
  call void @"ArrayList$String.add"(ptr %out12, ptr %elem)
  br label %for.update

if.then:                                          ; preds = %for.end
  %out17 = load ptr, ptr %out, align 8
  %15 = call i32 @"ArrayList$String.size"(ptr %out17)
  %16 = sext i32 %15 to i64
  %17 = mul i64 %16, 8
  %18 = add i64 8, %17
  %arr = call ptr @__polaron_malloc(i64 %18)
  store i64 %16, ptr %arr, align 8
  %arr.data18 = getelementptr i8, ptr %arr, i64 8
  %19 = call ptr @memset(ptr %arr.data18, i32 0, i64 %17)
  store ptr %arr, ptr %scratch, align 8
  %out19 = load ptr, ptr %out, align 8
  %scratch20 = load ptr, ptr %scratch, align 8
  %out21 = load ptr, ptr %out, align 8
  %20 = call i32 @"ArrayList$String.size"(ptr %out21)
  %21 = sub i32 %20, 1
  %compare22 = load ptr, ptr %compare, align 8
  call void @"ArrayList$String.mergeSortRange"(ptr %out19, ptr %scratch20, i32 0, i32 %21, ptr %compare22)
  %scratch23 = load ptr, ptr %scratch, align 8
  %ae.len = load i64, ptr %scratch23, align 8
  %arr.data24 = getelementptr i8, ptr %scratch23, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

if.end:                                           ; preds = %ae.end, %for.end
  %out25 = load ptr, ptr %out, align 8
  %count26 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count27 = load i32, ptr %count26, align 4, !tbaa !4
  %22 = icmp sge i32 %count27, 0
  %23 = zext i1 %22 to i32
  %contract.ok = icmp ne i32 %23, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

ae.cond:                                          ; preds = %ae.next, %if.then
  %ae.iv = load i64, ptr %ae.i, align 8
  %24 = icmp ult i64 %ae.iv, %ae.len
  br i1 %24, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data24, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %25 = icmp ne ptr %ae.el, null
  br i1 %25, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %26 = add i64 %ae.iv, 1
  store i64 %26, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %scratch23)
  br label %if.end

contract.fail:                                    ; preds = %if.end
  %count28 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %contract.l = sext i32 %count29 to i64
  call void @__polaron_fail(ptr @.contract.1217, ptr @.cl.1218, i64 %contract.l, ptr @.cr.1219, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count30 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %data32 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data33 = load ptr, ptr %data32, align 8, !tbaa !0
  %len34 = load i64, ptr %data33, align 8
  %27 = trunc i64 %len34 to i32
  %28 = icmp sle i32 %count31, %27
  %29 = zext i1 %28 to i32
  %contract.ok35 = icmp ne i32 %29, 0
  br i1 %contract.ok35, label %contract.cont37, label %contract.fail36

contract.fail36:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1220, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont37:                                  ; preds = %contract.cont
  ret ptr %out25
}

define internal void @"ArrayList$String.mergeSortRange"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3, ptr %4) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i32, align 4
  %k = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %mid = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %q = alloca i32, align 4
  %key = alloca ptr, align 8
  %p = alloca i32, align 4
  %compare = alloca ptr, align 8
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %tmp = alloca ptr, align 8
  store ptr %1, ptr %tmp, align 8
  store i32 %2, ptr %lo, align 4
  store i32 %3, ptr %hi, align 4
  store ptr %4, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %7 = trunc i64 %len to i32
  %8 = icmp sle i32 %count3, %7
  %9 = zext i1 %8 to i32
  %inv.assume5 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume5)
  %lo6 = load i32, ptr %lo, align 4
  %hi7 = load i32, ptr %hi, align 4
  %10 = icmp sge i32 %lo6, %hi7
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %12 = trunc i64 %len12 to i32
  %13 = icmp sle i32 %count9, %12
  %14 = zext i1 %13 to i32
  %contract.ok = icmp ne i32 %14, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

if.end:                                           ; preds = %entry
  %hi13 = load i32, ptr %hi, align 4
  %lo14 = load i32, ptr %lo, align 4
  %15 = sub i32 %hi13, %lo14
  %16 = icmp slt i32 %15, 16
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then15, label %if.end16

contract.fail:                                    ; preds = %if.then
  call void @__polaron_fail(ptr @.contract.1221, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  ret void

if.then15:                                        ; preds = %if.end
  %lo17 = load i32, ptr %lo, align 4
  %18 = add i32 %lo17, 1
  store i32 %18, ptr %p, align 4
  br label %for.cond

if.end16:                                         ; preds = %if.end
  %lo79 = load i32, ptr %lo, align 4
  %hi80 = load i32, ptr %hi, align 4
  %19 = add i32 %lo79, %hi80
  %20 = icmp eq i32 %19, -2147483648
  %21 = and i1 %20, false
  %22 = or i1 false, %21
  br i1 %22, label %div.bad, label %div.ok

for.cond:                                         ; preds = %for.update, %if.then15
  %p18 = load i32, ptr %p, align 4
  %hi19 = load i32, ptr %hi, align 4
  %23 = icmp sle i32 %p18, %hi19
  %24 = zext i1 %23 to i32
  br i1 %23, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data20 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p22 = load i32, ptr %p, align 4
  %25 = sext i32 %p22 to i64
  %arr.len = load i64, ptr %data21, align 8
  %arr.oob = icmp uge i64 %25, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok65
  %p70 = load i32, ptr %p, align 4
  %26 = add i32 %p70, 1
  store i32 %26, ptr %p, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count71 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count72 = load i32, ptr %count71, align 4, !tbaa !4
  %data73 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data74 = load ptr, ptr %data73, align 8, !tbaa !0
  %len75 = load i64, ptr %data74, align 8
  %27 = trunc i64 %len75 to i32
  %28 = icmp sle i32 %count72, %27
  %29 = zext i1 %28 to i32
  %contract.ok76 = icmp ne i32 %29, 0
  br i1 %contract.ok76, label %contract.cont78, label %contract.fail77

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1222, ptr @.faila.1223, i64 %25, ptr @.failb.1224, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %25
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  store ptr %strcpy, ptr %key, align 8
  %p23 = load i32, ptr %p, align 4
  %30 = sub i32 %p23, 1
  store i32 %30, ptr %q, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok53, %idx.ok
  %q24 = load i32, ptr %q, align 4
  %lo25 = load i32, ptr %lo, align 4
  %31 = icmp sge i32 %q24, %lo25
  %32 = zext i1 %31 to i32
  %sc.a = icmp ne i32 %32, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %data38 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data39 = load ptr, ptr %data38, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q40 = load i32, ptr %q, align 4
  %33 = add i32 %q40, 1
  %34 = sext i32 %33 to i64
  %arr.len41 = load i64, ptr %data39, align 8
  %arr.oob42 = icmp uge i64 %34, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

while.end:                                        ; preds = %sc.end
  %data59 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data60 = load ptr, ptr %data59, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q61 = load i32, ptr %q, align 4
  %35 = add i32 %q61, 1
  %36 = sext i32 %35 to i64
  %arr.len62 = load i64, ptr %data60, align 8
  %arr.oob63 = icmp uge i64 %36, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !8

sc.rhs:                                           ; preds = %while.cond
  %compare26 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare26, align 8
  %37 = getelementptr ptr, ptr %compare26, i32 1
  %env = load ptr, ptr %37, align 8
  %data27 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q29 = load i32, ptr %q, align 4
  %38 = sext i32 %q29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %38, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

sc.end:                                           ; preds = %idx.ok33, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok33 ]
  %39 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad32:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1225, ptr @.faila.1226, i64 %38, ptr @.failb.1227, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %sc.rhs
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %38
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %key37 = load ptr, ptr %key, align 8
  %40 = call i32 %code(ptr %env, ptr %elem36, ptr %key37)
  %41 = icmp sgt i32 %40, 0
  %42 = zext i1 %41 to i32
  %sc.b = icmp ne i32 %42, 0
  br label %sc.end

idx.bad43:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1228, ptr @.faila.1229, i64 %34, ptr @.failb.1230, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.body
  %arr.data45 = getelementptr i8, ptr %data39, i64 8
  %arr.elem46 = getelementptr inbounds ptr, ptr %arr.data45, i64 %34
  %data47 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q49 = load i32, ptr %q, align 4
  %43 = sext i32 %q49 to i64
  %arr.len50 = load i64, ptr %data48, align 8
  %arr.oob51 = icmp uge i64 %43, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !8

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.1231, ptr @.faila.1232, i64 %43, ptr @.failb.1233, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %data48, i64 8
  %arr.elem55 = getelementptr inbounds ptr, ptr %arr.data54, i64 %43
  %elem56 = load ptr, ptr %arr.elem55, align 8
  %strcpy57 = call ptr @__polaron_str_copy(ptr %elem56)
  %44 = load ptr, ptr %arr.elem46, align 8
  call void @__polaron_str_free(ptr %44)
  store ptr %strcpy57, ptr %arr.elem46, align 8
  %q58 = load i32, ptr %q, align 4
  %45 = sub i32 %q58, 1
  store i32 %45, ptr %q, align 4
  br label %while.cond

idx.bad64:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.1234, ptr @.faila.1235, i64 %36, ptr @.failb.1236, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %while.end
  %arr.data66 = getelementptr i8, ptr %data60, i64 8
  %arr.elem67 = getelementptr inbounds ptr, ptr %arr.data66, i64 %36
  %key68 = load ptr, ptr %key, align 8
  %strcpy69 = call ptr @__polaron_str_copy(ptr %key68)
  %46 = load ptr, ptr %arr.elem67, align 8
  call void @__polaron_str_free(ptr %46)
  store ptr %strcpy69, ptr %arr.elem67, align 8
  %47 = load ptr, ptr %key, align 8
  call void @__polaron_str_free(ptr %47)
  br label %for.update

contract.fail77:                                  ; preds = %for.end
  call void @__polaron_fail(ptr @.contract.1237, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont78:                                  ; preds = %for.end
  ret void

div.bad:                                          ; preds = %if.end16
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end16
  %48 = sdiv i32 %19, 2
  store i32 %48, ptr %mid, align 4
  %tmp81 = load ptr, ptr %tmp, align 8
  %lo82 = load i32, ptr %lo, align 4
  %mid83 = load i32, ptr %mid, align 4
  %compare84 = load ptr, ptr %compare, align 8
  call void @"ArrayList$String.mergeSortRange"(ptr %0, ptr %tmp81, i32 %lo82, i32 %mid83, ptr %compare84)
  %tmp85 = load ptr, ptr %tmp, align 8
  %mid86 = load i32, ptr %mid, align 4
  %49 = add i32 %mid86, 1
  %hi87 = load i32, ptr %hi, align 4
  %compare88 = load ptr, ptr %compare, align 8
  call void @"ArrayList$String.mergeSortRange"(ptr %0, ptr %tmp85, i32 %49, i32 %hi87, ptr %compare88)
  %compare89 = load ptr, ptr %compare, align 8
  %code90 = load ptr, ptr %compare89, align 8
  %50 = getelementptr ptr, ptr %compare89, i32 1
  %env91 = load ptr, ptr %50, align 8
  %data92 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data93 = load ptr, ptr %data92, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid94 = load i32, ptr %mid, align 4
  %51 = sext i32 %mid94 to i64
  %arr.len95 = load i64, ptr %data93, align 8
  %arr.oob96 = icmp uge i64 %51, %arr.len95
  br i1 %arr.oob96, label %idx.bad97, label %idx.ok98, !prof !8

idx.bad97:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1238, ptr @.faila.1239, i64 %51, ptr @.failb.1240, i64 %arr.len95, i32 70)
  unreachable

idx.ok98:                                         ; preds = %div.ok
  %arr.data99 = getelementptr i8, ptr %data93, i64 8
  %arr.elem100 = getelementptr inbounds ptr, ptr %arr.data99, i64 %51
  %elem101 = load ptr, ptr %arr.elem100, align 8
  %data102 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data103 = load ptr, ptr %data102, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid104 = load i32, ptr %mid, align 4
  %52 = add i32 %mid104, 1
  %53 = sext i32 %52 to i64
  %arr.len105 = load i64, ptr %data103, align 8
  %arr.oob106 = icmp uge i64 %53, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !8

idx.bad107:                                       ; preds = %idx.ok98
  call void @__polaron_fail(ptr @.fail.1241, ptr @.faila.1242, i64 %53, ptr @.failb.1243, i64 %arr.len105, i32 70)
  unreachable

idx.ok108:                                        ; preds = %idx.ok98
  %arr.data109 = getelementptr i8, ptr %data103, i64 8
  %arr.elem110 = getelementptr inbounds ptr, ptr %arr.data109, i64 %53
  %elem111 = load ptr, ptr %arr.elem110, align 8
  %54 = call i32 %code90(ptr %env91, ptr %elem101, ptr %elem111)
  %55 = icmp sle i32 %54, 0
  %56 = zext i1 %55 to i32
  br i1 %55, label %if.then112, label %if.end113

if.then112:                                       ; preds = %idx.ok108
  %count114 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count115 = load i32, ptr %count114, align 4, !tbaa !4
  %data116 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data117 = load ptr, ptr %data116, align 8, !tbaa !0
  %len118 = load i64, ptr %data117, align 8
  %57 = trunc i64 %len118 to i32
  %58 = icmp sle i32 %count115, %57
  %59 = zext i1 %58 to i32
  %contract.ok119 = icmp ne i32 %59, 0
  br i1 %contract.ok119, label %contract.cont121, label %contract.fail120

if.end113:                                        ; preds = %idx.ok108
  %lo122 = load i32, ptr %lo, align 4
  store i32 %lo122, ptr %i, align 4
  %mid123 = load i32, ptr %mid, align 4
  %60 = add i32 %mid123, 1
  store i32 %60, ptr %j, align 4
  %lo124 = load i32, ptr %lo, align 4
  store i32 %lo124, ptr %k, align 4
  br label %while.cond125

contract.fail120:                                 ; preds = %if.then112
  call void @__polaron_fail(ptr @.contract.1244, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont121:                                 ; preds = %if.then112
  ret void

while.cond125:                                    ; preds = %if.end161, %if.end113
  %i128 = load i32, ptr %i, align 4
  %mid129 = load i32, ptr %mid, align 4
  %61 = icmp sle i32 %i128, %mid129
  %62 = zext i1 %61 to i32
  %sc.a130 = icmp ne i32 %62, 0
  br i1 %sc.a130, label %sc.rhs131, label %sc.end132

while.body126:                                    ; preds = %sc.end132
  %compare137 = load ptr, ptr %compare, align 8
  %code138 = load ptr, ptr %compare137, align 8
  %63 = getelementptr ptr, ptr %compare137, i32 1
  %env139 = load ptr, ptr %63, align 8
  %data140 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data141 = load ptr, ptr %data140, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i142 = load i32, ptr %i, align 4
  %64 = sext i32 %i142 to i64
  %arr.len143 = load i64, ptr %data141, align 8
  %arr.oob144 = icmp uge i64 %64, %arr.len143
  br i1 %arr.oob144, label %idx.bad145, label %idx.ok146, !prof !8

while.end127:                                     ; preds = %sc.end132
  br label %while.cond203

sc.rhs131:                                        ; preds = %while.cond125
  %j133 = load i32, ptr %j, align 4
  %hi134 = load i32, ptr %hi, align 4
  %65 = icmp sle i32 %j133, %hi134
  %66 = zext i1 %65 to i32
  %sc.b135 = icmp ne i32 %66, 0
  br label %sc.end132

sc.end132:                                        ; preds = %sc.rhs131, %while.cond125
  %sc136 = phi i1 [ false, %while.cond125 ], [ %sc.b135, %sc.rhs131 ]
  %67 = zext i1 %sc136 to i32
  br i1 %sc136, label %while.body126, label %while.end127

idx.bad145:                                       ; preds = %while.body126
  call void @__polaron_fail(ptr @.fail.1245, ptr @.faila.1246, i64 %64, ptr @.failb.1247, i64 %arr.len143, i32 70)
  unreachable

idx.ok146:                                        ; preds = %while.body126
  %arr.data147 = getelementptr i8, ptr %data141, i64 8
  %arr.elem148 = getelementptr inbounds ptr, ptr %arr.data147, i64 %64
  %elem149 = load ptr, ptr %arr.elem148, align 8
  %data150 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data151 = load ptr, ptr %data150, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j152 = load i32, ptr %j, align 4
  %68 = sext i32 %j152 to i64
  %arr.len153 = load i64, ptr %data151, align 8
  %arr.oob154 = icmp uge i64 %68, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !8

idx.bad155:                                       ; preds = %idx.ok146
  call void @__polaron_fail(ptr @.fail.1248, ptr @.faila.1249, i64 %68, ptr @.failb.1250, i64 %arr.len153, i32 70)
  unreachable

idx.ok156:                                        ; preds = %idx.ok146
  %arr.data157 = getelementptr i8, ptr %data151, i64 8
  %arr.elem158 = getelementptr inbounds ptr, ptr %arr.data157, i64 %68
  %elem159 = load ptr, ptr %arr.elem158, align 8
  %69 = call i32 %code138(ptr %env139, ptr %elem149, ptr %elem159)
  %70 = icmp sle i32 %69, 0
  %71 = zext i1 %70 to i32
  br i1 %70, label %if.then160, label %if.else

if.then160:                                       ; preds = %idx.ok156
  %tmp162 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k163 = load i32, ptr %k, align 4
  %72 = sext i32 %k163 to i64
  %arr.len164 = load i64, ptr %tmp162, align 8
  %arr.oob165 = icmp uge i64 %72, %arr.len164
  br i1 %arr.oob165, label %idx.bad166, label %idx.ok167, !prof !8

if.else:                                          ; preds = %idx.ok156
  %tmp182 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k183 = load i32, ptr %k, align 4
  %73 = sext i32 %k183 to i64
  %arr.len184 = load i64, ptr %tmp182, align 8
  %arr.oob185 = icmp uge i64 %73, %arr.len184
  br i1 %arr.oob185, label %idx.bad186, label %idx.ok187, !prof !8

if.end161:                                        ; preds = %idx.ok196, %idx.ok176
  %k202 = load i32, ptr %k, align 4
  %74 = add i32 %k202, 1
  store i32 %74, ptr %k, align 4
  br label %while.cond125

idx.bad166:                                       ; preds = %if.then160
  call void @__polaron_fail(ptr @.fail.1251, ptr @.faila.1252, i64 %72, ptr @.failb.1253, i64 %arr.len164, i32 70)
  unreachable

idx.ok167:                                        ; preds = %if.then160
  %arr.data168 = getelementptr i8, ptr %tmp162, i64 8
  %arr.elem169 = getelementptr inbounds ptr, ptr %arr.data168, i64 %72
  %data170 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data171 = load ptr, ptr %data170, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i172 = load i32, ptr %i, align 4
  %75 = sext i32 %i172 to i64
  %arr.len173 = load i64, ptr %data171, align 8
  %arr.oob174 = icmp uge i64 %75, %arr.len173
  br i1 %arr.oob174, label %idx.bad175, label %idx.ok176, !prof !8

idx.bad175:                                       ; preds = %idx.ok167
  call void @__polaron_fail(ptr @.fail.1254, ptr @.faila.1255, i64 %75, ptr @.failb.1256, i64 %arr.len173, i32 70)
  unreachable

idx.ok176:                                        ; preds = %idx.ok167
  %arr.data177 = getelementptr i8, ptr %data171, i64 8
  %arr.elem178 = getelementptr inbounds ptr, ptr %arr.data177, i64 %75
  %elem179 = load ptr, ptr %arr.elem178, align 8
  %strcpy180 = call ptr @__polaron_str_copy(ptr %elem179)
  %76 = load ptr, ptr %arr.elem169, align 8
  call void @__polaron_str_free(ptr %76)
  store ptr %strcpy180, ptr %arr.elem169, align 8
  %i181 = load i32, ptr %i, align 4
  %77 = add i32 %i181, 1
  store i32 %77, ptr %i, align 4
  br label %if.end161

idx.bad186:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1257, ptr @.faila.1258, i64 %73, ptr @.failb.1259, i64 %arr.len184, i32 70)
  unreachable

idx.ok187:                                        ; preds = %if.else
  %arr.data188 = getelementptr i8, ptr %tmp182, i64 8
  %arr.elem189 = getelementptr inbounds ptr, ptr %arr.data188, i64 %73
  %data190 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data191 = load ptr, ptr %data190, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j192 = load i32, ptr %j, align 4
  %78 = sext i32 %j192 to i64
  %arr.len193 = load i64, ptr %data191, align 8
  %arr.oob194 = icmp uge i64 %78, %arr.len193
  br i1 %arr.oob194, label %idx.bad195, label %idx.ok196, !prof !8

idx.bad195:                                       ; preds = %idx.ok187
  call void @__polaron_fail(ptr @.fail.1260, ptr @.faila.1261, i64 %78, ptr @.failb.1262, i64 %arr.len193, i32 70)
  unreachable

idx.ok196:                                        ; preds = %idx.ok187
  %arr.data197 = getelementptr i8, ptr %data191, i64 8
  %arr.elem198 = getelementptr inbounds ptr, ptr %arr.data197, i64 %78
  %elem199 = load ptr, ptr %arr.elem198, align 8
  %strcpy200 = call ptr @__polaron_str_copy(ptr %elem199)
  %79 = load ptr, ptr %arr.elem189, align 8
  call void @__polaron_str_free(ptr %79)
  store ptr %strcpy200, ptr %arr.elem189, align 8
  %j201 = load i32, ptr %j, align 4
  %80 = add i32 %j201, 1
  store i32 %80, ptr %j, align 4
  br label %if.end161

while.cond203:                                    ; preds = %idx.ok222, %while.end127
  %i206 = load i32, ptr %i, align 4
  %mid207 = load i32, ptr %mid, align 4
  %81 = icmp sle i32 %i206, %mid207
  %82 = zext i1 %81 to i32
  br i1 %81, label %while.body204, label %while.end205

while.body204:                                    ; preds = %while.cond203
  %tmp208 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k209 = load i32, ptr %k, align 4
  %83 = sext i32 %k209 to i64
  %arr.len210 = load i64, ptr %tmp208, align 8
  %arr.oob211 = icmp uge i64 %83, %arr.len210
  br i1 %arr.oob211, label %idx.bad212, label %idx.ok213, !prof !8

while.end205:                                     ; preds = %while.cond203
  br label %while.cond229

idx.bad212:                                       ; preds = %while.body204
  call void @__polaron_fail(ptr @.fail.1263, ptr @.faila.1264, i64 %83, ptr @.failb.1265, i64 %arr.len210, i32 70)
  unreachable

idx.ok213:                                        ; preds = %while.body204
  %arr.data214 = getelementptr i8, ptr %tmp208, i64 8
  %arr.elem215 = getelementptr inbounds ptr, ptr %arr.data214, i64 %83
  %data216 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data217 = load ptr, ptr %data216, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i218 = load i32, ptr %i, align 4
  %84 = sext i32 %i218 to i64
  %arr.len219 = load i64, ptr %data217, align 8
  %arr.oob220 = icmp uge i64 %84, %arr.len219
  br i1 %arr.oob220, label %idx.bad221, label %idx.ok222, !prof !8

idx.bad221:                                       ; preds = %idx.ok213
  call void @__polaron_fail(ptr @.fail.1266, ptr @.faila.1267, i64 %84, ptr @.failb.1268, i64 %arr.len219, i32 70)
  unreachable

idx.ok222:                                        ; preds = %idx.ok213
  %arr.data223 = getelementptr i8, ptr %data217, i64 8
  %arr.elem224 = getelementptr inbounds ptr, ptr %arr.data223, i64 %84
  %elem225 = load ptr, ptr %arr.elem224, align 8
  %strcpy226 = call ptr @__polaron_str_copy(ptr %elem225)
  %85 = load ptr, ptr %arr.elem215, align 8
  call void @__polaron_str_free(ptr %85)
  store ptr %strcpy226, ptr %arr.elem215, align 8
  %i227 = load i32, ptr %i, align 4
  %86 = add i32 %i227, 1
  store i32 %86, ptr %i, align 4
  %k228 = load i32, ptr %k, align 4
  %87 = add i32 %k228, 1
  store i32 %87, ptr %k, align 4
  br label %while.cond203

while.cond229:                                    ; preds = %idx.ok248, %while.end205
  %j232 = load i32, ptr %j, align 4
  %hi233 = load i32, ptr %hi, align 4
  %88 = icmp sle i32 %j232, %hi233
  %89 = zext i1 %88 to i32
  br i1 %88, label %while.body230, label %while.end231

while.body230:                                    ; preds = %while.cond229
  %tmp234 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k235 = load i32, ptr %k, align 4
  %90 = sext i32 %k235 to i64
  %arr.len236 = load i64, ptr %tmp234, align 8
  %arr.oob237 = icmp uge i64 %90, %arr.len236
  br i1 %arr.oob237, label %idx.bad238, label %idx.ok239, !prof !8

while.end231:                                     ; preds = %while.cond229
  %lo255 = load i32, ptr %lo, align 4
  store i32 %lo255, ptr %t, align 4
  br label %for.cond256

idx.bad238:                                       ; preds = %while.body230
  call void @__polaron_fail(ptr @.fail.1269, ptr @.faila.1270, i64 %90, ptr @.failb.1271, i64 %arr.len236, i32 70)
  unreachable

idx.ok239:                                        ; preds = %while.body230
  %arr.data240 = getelementptr i8, ptr %tmp234, i64 8
  %arr.elem241 = getelementptr inbounds ptr, ptr %arr.data240, i64 %90
  %data242 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data243 = load ptr, ptr %data242, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j244 = load i32, ptr %j, align 4
  %91 = sext i32 %j244 to i64
  %arr.len245 = load i64, ptr %data243, align 8
  %arr.oob246 = icmp uge i64 %91, %arr.len245
  br i1 %arr.oob246, label %idx.bad247, label %idx.ok248, !prof !8

idx.bad247:                                       ; preds = %idx.ok239
  call void @__polaron_fail(ptr @.fail.1272, ptr @.faila.1273, i64 %91, ptr @.failb.1274, i64 %arr.len245, i32 70)
  unreachable

idx.ok248:                                        ; preds = %idx.ok239
  %arr.data249 = getelementptr i8, ptr %data243, i64 8
  %arr.elem250 = getelementptr inbounds ptr, ptr %arr.data249, i64 %91
  %elem251 = load ptr, ptr %arr.elem250, align 8
  %strcpy252 = call ptr @__polaron_str_copy(ptr %elem251)
  %92 = load ptr, ptr %arr.elem241, align 8
  call void @__polaron_str_free(ptr %92)
  store ptr %strcpy252, ptr %arr.elem241, align 8
  %j253 = load i32, ptr %j, align 4
  %93 = add i32 %j253, 1
  store i32 %93, ptr %j, align 4
  %k254 = load i32, ptr %k, align 4
  %94 = add i32 %k254, 1
  store i32 %94, ptr %k, align 4
  br label %while.cond229

for.cond256:                                      ; preds = %for.update258, %while.end231
  %t260 = load i32, ptr %t, align 4
  %hi261 = load i32, ptr %hi, align 4
  %95 = icmp sle i32 %t260, %hi261
  %96 = zext i1 %95 to i32
  br i1 %95, label %for.body257, label %for.end259

for.body257:                                      ; preds = %for.cond256
  %data262 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data263 = load ptr, ptr %data262, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %t264 = load i32, ptr %t, align 4
  %97 = sext i32 %t264 to i64
  %arr.len265 = load i64, ptr %data263, align 8
  %arr.oob266 = icmp uge i64 %97, %arr.len265
  br i1 %arr.oob266, label %idx.bad267, label %idx.ok268, !prof !8

for.update258:                                    ; preds = %idx.ok276
  %t281 = load i32, ptr %t, align 4
  %98 = add i32 %t281, 1
  store i32 %98, ptr %t, align 4
  br label %for.cond256

for.end259:                                       ; preds = %for.cond256
  %count282 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count283 = load i32, ptr %count282, align 4, !tbaa !4
  %data284 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data285 = load ptr, ptr %data284, align 8, !tbaa !0
  %len286 = load i64, ptr %data285, align 8
  %99 = trunc i64 %len286 to i32
  %100 = icmp sle i32 %count283, %99
  %101 = zext i1 %100 to i32
  %contract.ok287 = icmp ne i32 %101, 0
  br i1 %contract.ok287, label %contract.cont289, label %contract.fail288

idx.bad267:                                       ; preds = %for.body257
  call void @__polaron_fail(ptr @.fail.1275, ptr @.faila.1276, i64 %97, ptr @.failb.1277, i64 %arr.len265, i32 70)
  unreachable

idx.ok268:                                        ; preds = %for.body257
  %arr.data269 = getelementptr i8, ptr %data263, i64 8
  %arr.elem270 = getelementptr inbounds ptr, ptr %arr.data269, i64 %97
  %tmp271 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %t272 = load i32, ptr %t, align 4
  %102 = sext i32 %t272 to i64
  %arr.len273 = load i64, ptr %tmp271, align 8
  %arr.oob274 = icmp uge i64 %102, %arr.len273
  br i1 %arr.oob274, label %idx.bad275, label %idx.ok276, !prof !8

idx.bad275:                                       ; preds = %idx.ok268
  call void @__polaron_fail(ptr @.fail.1278, ptr @.faila.1279, i64 %102, ptr @.failb.1280, i64 %arr.len273, i32 70)
  unreachable

idx.ok276:                                        ; preds = %idx.ok268
  %arr.data277 = getelementptr i8, ptr %tmp271, i64 8
  %arr.elem278 = getelementptr inbounds ptr, ptr %arr.data277, i64 %102
  %elem279 = load ptr, ptr %arr.elem278, align 8
  %strcpy280 = call ptr @__polaron_str_copy(ptr %elem279)
  %103 = load ptr, ptr %arr.elem270, align 8
  call void @__polaron_str_free(ptr %103)
  store ptr %strcpy280, ptr %arr.elem270, align 8
  br label %for.update258

contract.fail288:                                 ; preds = %for.end259
  call void @__polaron_fail(ptr @.contract.1281, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont289:                                 ; preds = %for.end259
  ret void
}

define internal %__polaron_variant @"ArrayList$String.find"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret %__polaron_variant { i32 1, i64 0 }

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1282, ptr @.faila.1283, i64 %10, ptr @.failb.1284, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1285, ptr @.faila.1286, i64 %15, ptr @.failb.1287, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 %15
  %elem22 = load ptr, ptr %arr.elem21, align 8
  %var.enc.p = ptrtoint ptr %elem22 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val
}

define internal %__polaron_variant @"ArrayList$String.min"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1288, ptr @.faila.1289, i64 0, ptr @.failb.1290, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  store ptr %strcpy, ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

for.update:                                       ; preds = %if.end26
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best38 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best38 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  %15 = load ptr, ptr %best, align 8
  call void @__polaron_str_free(ptr %15)
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1291, ptr @.faila.1292, i64 %12, ptr @.failb.1293, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %12
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %best24 = load ptr, ptr %best, align 8
  %16 = call i32 %code(ptr %env, ptr %elem23, ptr %best24)
  %17 = icmp slt i32 %16, 0
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %19 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %19, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1294, ptr @.faila.1295, i64 %19, ptr @.failb.1296, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %19
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %strcpy37 = call ptr @__polaron_str_copy(ptr %elem36)
  %20 = load ptr, ptr %best, align 8
  call void @__polaron_str_free(ptr %20)
  store ptr %strcpy37, ptr %best, align 8
  br label %if.end26
}

define internal %__polaron_variant @"ArrayList$String.max"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1297, ptr @.faila.1298, i64 0, ptr @.failb.1299, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  store ptr %strcpy, ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

for.update:                                       ; preds = %if.end26
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best38 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best38 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  %15 = load ptr, ptr %best, align 8
  call void @__polaron_str_free(ptr %15)
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1300, ptr @.faila.1301, i64 %12, ptr @.failb.1302, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %12
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %best24 = load ptr, ptr %best, align 8
  %16 = call i32 %code(ptr %env, ptr %elem23, ptr %best24)
  %17 = icmp sgt i32 %16, 0
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %19 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %19, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1303, ptr @.faila.1304, i64 %19, ptr @.failb.1305, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %19
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %strcpy37 = call ptr @__polaron_str_copy(ptr %elem36)
  %20 = load ptr, ptr %best, align 8
  call void @__polaron_str_free(ptr %20)
  store ptr %strcpy37, ptr %best, align 8
  br label %if.end26
}

define internal ptr @"ArrayList$String.iterator"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayListIterator$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayListIterator$String", ptr null, i64 1) to i64))
  call void @"ArrayListIterator$String.ArrayListIterator$String"(ptr %"ArrayListIterator$String.obj", ptr %0)
  ret ptr %"ArrayListIterator$String.obj"
}

define internal void @"ArrayListIterator$String.ArrayListIterator$String"(ptr %0, ptr %1) {
entry:
  %"ArrayList$String.copy" = alloca %"class.ArrayList$String", align 8
  %list = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"ArrayList$String.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %"class.ArrayList$String", ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %"class.ArrayList$String", ptr %"ArrayList$String.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %"ArrayList$String.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %list1 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %list1, align 8, !tbaa !0
  %list2 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list3 = load ptr, ptr %list, align 8
  %"ArrayList$String.copy4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  %9 = call ptr @memcpy(ptr %"ArrayList$String.copy4", ptr %list3, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %"class.ArrayList$String", ptr %list3, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %arr.len5 = load i64, ptr %11, align 8
  %12 = mul i64 %arr.len5, 8
  %13 = add i64 8, %12
  %arr.copy6 = call ptr @__polaron_malloc(i64 %13)
  %14 = call ptr @memcpy(ptr %arr.copy6, ptr %11, i64 %13)
  %15 = getelementptr inbounds %"class.ArrayList$String", ptr %"ArrayList$String.copy4", i32 0, i32 1
  store ptr %arr.copy6, ptr %15, align 8, !tbaa !0
  store ptr %"ArrayList$String.copy4", ptr %list2, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @"ArrayListIterator$String.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %list = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$String.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @"ArrayListIterator$String.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca ptr, align 8
  %list = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = call ptr @"ArrayList$String.get"(ptr %list1, i32 %pos2)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  store ptr %strcpy, ptr %value, align 8
  call void @__polaron_str_free(ptr %1)
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %2 = add i32 %pos5, 1
  store i32 %2, ptr %pos3, align 4, !tbaa !4
  %value6 = load ptr, ptr %value, align 8
  %strcpy7 = call ptr @__polaron_str_copy(ptr %value6)
  %3 = load ptr, ptr %value, align 8
  call void @__polaron_str_free(ptr %3)
  ret ptr %strcpy7
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1317)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1319)
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
  store i64 %1, ptr %buf, align 8, !tbaa !9
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
  %buf13 = load i64, ptr %buf, align 8, !tbaa !9
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !9
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !9
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
  %buf3 = load i64, ptr %buf, align 8, !tbaa !9
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
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
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
  %buf24 = load i64, ptr %buf, align 8, !tbaa !9
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !9
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !9
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !9
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
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
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
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !9
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !9
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal ptr @Template.render(ptr %0, ptr %1) {
entry:
  %k = alloca ptr, align 8
  %key = alloca ptr, align 8
  %j = alloca i32, align 4
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %"HashMap$String$String.copy" = alloca %"class.HashMap$String$String", align 8
  %vars = alloca ptr, align 8
  %tpl = alloca ptr, align 8
  store ptr %0, ptr %tpl, align 8
  %2 = call ptr @memcpy(ptr %"HashMap$String$String.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.HashMap$String$String", ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %"class.HashMap$String$String", ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %"class.HashMap$String$String", ptr %"HashMap$String$String.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  %9 = getelementptr inbounds %"class.HashMap$String$String", ptr %1, i32 0, i32 2
  %10 = load ptr, ptr %9, align 8, !tbaa !0
  %arr.len1 = load i64, ptr %10, align 8
  %11 = mul i64 %arr.len1, 8
  %12 = add i64 8, %11
  %arr.copy2 = call ptr @__polaron_malloc(i64 %12)
  %13 = call ptr @memcpy(ptr %arr.copy2, ptr %10, i64 %12)
  %14 = getelementptr inbounds %"class.HashMap$String$String", ptr %"HashMap$String$String.copy", i32 0, i32 2
  store ptr %arr.copy2, ptr %14, align 8, !tbaa !0
  %15 = getelementptr inbounds %"class.HashMap$String$String", ptr %1, i32 0, i32 3
  %16 = load ptr, ptr %15, align 8, !tbaa !0
  %arr.len3 = load i64, ptr %16, align 8
  %17 = mul i64 %arr.len3, 1
  %18 = add i64 8, %17
  %arr.copy4 = call ptr @__polaron_malloc(i64 %18)
  %19 = call ptr @memcpy(ptr %arr.copy4, ptr %16, i64 %18)
  %20 = getelementptr inbounds %"class.HashMap$String$String", ptr %"HashMap$String$String.copy", i32 0, i32 3
  store ptr %arr.copy4, ptr %20, align 8, !tbaa !0
  store ptr %"HashMap$String$String.copy", ptr %vars, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %i5 = load i32, ptr %i, align 4
  %tpl6 = load ptr, ptr %tpl, align 8
  %str.len = getelementptr inbounds %String, ptr %tpl6, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %21 = trunc i64 %len to i32
  %22 = icmp slt i32 %i5, %21
  %23 = zext i1 %22 to i32
  br i1 %22, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %tpl7 = load ptr, ptr %tpl, align 8
  %i8 = load i32, ptr %i, align 4
  %24 = sext i32 %i8 to i64
  %str.data = getelementptr inbounds %String, ptr %tpl7, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %24
  %ch = load i8, ptr %ch.addr, align 1
  %25 = zext i8 %ch to i32
  store i32 %25, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %26 = icmp eq i32 %c9, 123
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then, label %if.else

while.end:                                        ; preds = %while.cond
  %sb50 = load ptr, ptr %sb, align 8
  %28 = call ptr @StringBuilder.toString(ptr %sb50)
  %strcpy51 = call ptr @__polaron_str_copy(ptr %28)
  call void @__polaron_str_free(ptr %28)
  ret ptr %strcpy51

if.then:                                          ; preds = %while.body
  %i10 = load i32, ptr %i, align 4
  %29 = add i32 %i10, 1
  store i32 %29, ptr %j, align 4
  %StringBuilder.obj11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj11)
  store ptr %StringBuilder.obj11, ptr %key, align 8
  br label %while.cond12

if.else:                                          ; preds = %while.body
  %sb47 = load ptr, ptr %sb, align 8
  %c48 = load i32, ptr %c, align 4
  %30 = call ptr @StringBuilder.appendChar(ptr %sb47, i32 %c48)
  %i49 = load i32, ptr %i, align 4
  %31 = add i32 %i49, 1
  store i32 %31, ptr %i, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.end38
  br label %while.cond

while.cond12:                                     ; preds = %while.body13, %if.then
  %j15 = load i32, ptr %j, align 4
  %tpl16 = load ptr, ptr %tpl, align 8
  %str.len17 = getelementptr inbounds %String, ptr %tpl16, i32 0, i32 0
  %len18 = load i64, ptr %str.len17, align 8
  %32 = trunc i64 %len18 to i32
  %33 = icmp slt i32 %j15, %32
  %34 = zext i1 %33 to i32
  %sc.a = icmp ne i32 %34, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body13:                                     ; preds = %sc.end
  %key25 = load ptr, ptr %key, align 8
  %tpl26 = load ptr, ptr %tpl, align 8
  %j27 = load i32, ptr %j, align 4
  %35 = sext i32 %j27 to i64
  %str.data28 = getelementptr inbounds %String, ptr %tpl26, i32 0, i32 1
  %data29 = load ptr, ptr %str.data28, align 8
  %ch.addr30 = getelementptr i8, ptr %data29, i64 %35
  %ch31 = load i8, ptr %ch.addr30, align 1
  %36 = zext i8 %ch31 to i32
  %37 = call ptr @StringBuilder.appendChar(ptr %key25, i32 %36)
  %j32 = load i32, ptr %j, align 4
  %38 = add i32 %j32, 1
  store i32 %38, ptr %j, align 4
  br label %while.cond12

while.end14:                                      ; preds = %sc.end
  %key33 = load ptr, ptr %key, align 8
  %39 = call ptr @StringBuilder.toString(ptr %key33)
  %strcpy = call ptr @__polaron_str_copy(ptr %39)
  store ptr %strcpy, ptr %k, align 8
  call void @__polaron_str_free(ptr %39)
  %vars34 = load ptr, ptr %vars, align 8
  %k35 = load ptr, ptr %k, align 8
  %40 = call i32 @"HashMap$String$String.containsKey"(ptr %vars34, ptr %k35)
  %41 = icmp ne i32 %40, 0
  br i1 %41, label %if.then36, label %if.else37

sc.rhs:                                           ; preds = %while.cond12
  %tpl19 = load ptr, ptr %tpl, align 8
  %j20 = load i32, ptr %j, align 4
  %42 = sext i32 %j20 to i64
  %str.data21 = getelementptr inbounds %String, ptr %tpl19, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %ch.addr23 = getelementptr i8, ptr %data22, i64 %42
  %ch24 = load i8, ptr %ch.addr23, align 1
  %43 = zext i8 %ch24 to i32
  %44 = icmp ne i32 %43, 125
  %45 = zext i1 %44 to i32
  %sc.b = icmp ne i32 %45, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond12
  %sc = phi i1 [ false, %while.cond12 ], [ %sc.b, %sc.rhs ]
  %46 = zext i1 %sc to i32
  br i1 %sc, label %while.body13, label %while.end14

if.then36:                                        ; preds = %while.end14
  %sb39 = load ptr, ptr %sb, align 8
  %vars40 = load ptr, ptr %vars, align 8
  %k41 = load ptr, ptr %k, align 8
  %47 = call ptr @"HashMap$String$String.get"(ptr %vars40, ptr %k41)
  %48 = call ptr @StringBuilder.append(ptr %sb39, ptr %47)
  call void @__polaron_str_free(ptr %47)
  br label %if.end38

if.else37:                                        ; preds = %while.end14
  %sb42 = load ptr, ptr %sb, align 8
  %49 = call ptr @StringBuilder.appendChar(ptr %sb42, i32 123)
  %sb43 = load ptr, ptr %sb, align 8
  %k44 = load ptr, ptr %k, align 8
  %50 = call ptr @StringBuilder.append(ptr %sb43, ptr %k44)
  %sb45 = load ptr, ptr %sb, align 8
  %51 = call ptr @StringBuilder.appendChar(ptr %sb45, i32 125)
  br label %if.end38

if.end38:                                         ; preds = %if.else37, %if.then36
  %j46 = load i32, ptr %j, align 4
  %52 = add i32 %j46, 1
  store i32 %52, ptr %i, align 4
  %53 = load ptr, ptr %k, align 8
  call void @__polaron_str_free(ptr %53)
  br label %if.end
}

define internal ptr @Csv.parse(ptr %0) {
entry:
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %inQuotes = alloca i32, align 4
  %cur = alloca ptr, align 8
  %out = alloca ptr, align 8
  %line = alloca ptr, align 8
  store ptr %0, ptr %line, align 8
  %"ArrayList$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  call void @"ArrayList$String.ArrayList$String"(ptr %"ArrayList$String.obj")
  store ptr %"ArrayList$String.obj", ptr %out, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %cur, align 8
  store i32 0, ptr %inQuotes, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %i1 = load i32, ptr %i, align 4
  %line2 = load ptr, ptr %line, align 8
  %str.len = getelementptr inbounds %String, ptr %line2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %line3 = load ptr, ptr %line, align 8
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %line3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %4
  %ch = load i8, ptr %ch.addr, align 1
  %5 = zext i8 %ch to i32
  store i32 %5, ptr %c, align 4
  %c5 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %c5, 34
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.else

while.end:                                        ; preds = %while.cond
  %out18 = load ptr, ptr %out, align 8
  %cur19 = load ptr, ptr %cur, align 8
  %8 = call ptr @StringBuilder.toString(ptr %cur19)
  call void @"ArrayList$String.add"(ptr %out18, ptr %8)
  call void @__polaron_str_free(ptr %8)
  %out20 = load ptr, ptr %out, align 8
  ret ptr %out20

if.then:                                          ; preds = %while.body
  %inQuotes6 = load i32, ptr %inQuotes, align 4
  %9 = icmp eq i32 %inQuotes6, 0
  %10 = zext i1 %9 to i32
  store i32 %10, ptr %inQuotes, align 4
  br label %if.end

if.else:                                          ; preds = %while.body
  %c7 = load i32, ptr %c, align 4
  %11 = icmp eq i32 %c7, 44
  %12 = zext i1 %11 to i32
  %sc.a = icmp ne i32 %12, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

if.end:                                           ; preds = %if.end11, %if.then
  %i17 = load i32, ptr %i, align 4
  %13 = add i32 %i17, 1
  store i32 %13, ptr %i, align 4
  br label %while.cond

sc.rhs:                                           ; preds = %if.else
  %inQuotes8 = load i32, ptr %inQuotes, align 4
  %14 = icmp eq i32 %inQuotes8, 0
  %15 = zext i1 %14 to i32
  %sc.b = icmp ne i32 %15, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %if.else
  %sc = phi i1 [ false, %if.else ], [ %sc.b, %sc.rhs ]
  %16 = zext i1 %sc to i32
  br i1 %sc, label %if.then9, label %if.else10

if.then9:                                         ; preds = %sc.end
  %out12 = load ptr, ptr %out, align 8
  %cur13 = load ptr, ptr %cur, align 8
  %17 = call ptr @StringBuilder.toString(ptr %cur13)
  call void @"ArrayList$String.add"(ptr %out12, ptr %17)
  call void @__polaron_str_free(ptr %17)
  %StringBuilder.obj14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj14)
  store ptr %StringBuilder.obj14, ptr %cur, align 8
  br label %if.end11

if.else10:                                        ; preds = %sc.end
  %cur15 = load ptr, ptr %cur, align 8
  %c16 = load i32, ptr %c, align 4
  %18 = call ptr @StringBuilder.appendChar(ptr %cur15, i32 %c16)
  br label %if.end11

if.end11:                                         ; preds = %if.else10, %if.then9
  br label %if.end
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5318)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5320)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @__polaron_str_hash_obj(ptr)

declare i32 @strcmp(ptr, ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
!9 = !{!10, !10, i64 0}
!10 = !{!"i64", !2, i64 0}
