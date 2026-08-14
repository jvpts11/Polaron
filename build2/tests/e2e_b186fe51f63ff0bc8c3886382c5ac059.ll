; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/generic_event.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/generic_event.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Box = type { ptr, i32 }
%"class.Event$int" = type { ptr, ptr }
%"class.ArrayList$Handler$int" = type { ptr, ptr, i32 }
%"class.Handler$int" = type { ptr, ptr }
%class.DivideByZeroException = type { ptr }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$Handler$int" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Box.vtable = private constant [349 x ptr] [ptr @Box.add, ptr @Box.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayListIterator$Handler$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$Handler$int.hasNext", ptr @"ArrayListIterator$Handler$int.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Event$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Event$int.subscribe", ptr @"Event$int.emit", ptr @"Event$int.count", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Handler$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Handler$int.invoke", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayList$Handler$int.vtable" = private constant [349 x ptr] [ptr @"ArrayList$Handler$int.add", ptr @"ArrayList$Handler$int.get", ptr null, ptr null, ptr null, ptr @"ArrayList$Handler$int.toArray", ptr @"ArrayList$Handler$int.size", ptr @"ArrayList$Handler$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$Handler$int.remove", ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$Handler$int.count", ptr null, ptr @"ArrayList$Handler$int.ensureCapacity", ptr @"ArrayList$Handler$int.set", ptr @"ArrayList$Handler$int.indexOf", ptr @"ArrayList$Handler$int.contains", ptr @"ArrayList$Handler$int.removeAt", ptr @"ArrayList$Handler$int.insertAt", ptr @"ArrayList$Handler$int.clear", ptr @"ArrayList$Handler$int.forEach", ptr @"ArrayList$Handler$int.filter", ptr @"ArrayList$Handler$int.any", ptr @"ArrayList$Handler$int.all", ptr @"ArrayList$Handler$int.sortedBy", ptr @"ArrayList$Handler$int.mergeSortRange", ptr @"ArrayList$Handler$int.find", ptr @"ArrayList$Handler$int.min", ptr @"ArrayList$Handler$int.max", ptr @"ArrayList$Handler$int.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$Handler$int.~ArrayList$Handler$int"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [9 x i8] c"tick %d\0A\00", align 1
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_1, ptr null]
@.str.1 = private unnamed_addr constant [18 x i8] c"total=%d nsub=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.contract.673 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.ArrayList$Handler$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.674 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.675 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.676 = private unnamed_addr constant [151 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.ArrayList$Handler$int\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.677 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$Handler$int.add\0A\00", align 1
@.faila.678 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.679 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.680 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$Handler$int.add\0A\00", align 1
@.faila.681 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.682 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.683 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$Handler$int.add\0A\00", align 1
@.faila.684 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.685 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.686 = private unnamed_addr constant [129 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$Handler$int.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.687 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.688 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.689 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.690 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.691 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$Handler$int.ensureCapacity\0A\00", align 1
@.faila.692 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.693 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.694 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$Handler$int.ensureCapacity\0A\00", align 1
@.faila.695 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.696 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.697 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.698 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.699 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.700 = private unnamed_addr constant [144 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.701 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$Handler$int.get\0A\00", align 1
@.faila.702 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.703 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.704 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$Handler$int.get\0A\00", align 1
@.faila.705 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.706 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.707 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$Handler$int.set\0A\00", align 1
@.faila.708 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.709 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.710 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.711 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$Handler$int.set\0A\00", align 1
@.faila.712 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.713 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.714 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.715 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$Handler$int.indexOf\0A\00", align 1
@.faila.716 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.717 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.718 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$Handler$int.removeAt\0A\00", align 1
@.faila.719 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.720 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.721 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.722 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.723 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.724 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.725 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$Handler$int.removeAt\0A\00", align 1
@.faila.726 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.727 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.728 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$Handler$int.removeAt\0A\00", align 1
@.faila.729 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.730 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.731 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.732 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.733 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.734 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.735 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$Handler$int.insertAt\0A\00", align 1
@.faila.736 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.737 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.738 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.739 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.740 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.741 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.742 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$Handler$int.insertAt\0A\00", align 1
@.faila.743 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.744 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.745 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$Handler$int.insertAt\0A\00", align 1
@.faila.746 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.747 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.748 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$Handler$int.insertAt\0A\00", align 1
@.faila.749 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.750 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.751 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$Handler$int.insertAt\0A\00", align 1
@.faila.752 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.753 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.754 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$Handler$int.insertAt\0A\00", align 1
@.faila.755 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.756 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.757 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.758 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.759 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.760 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.761 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.762 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.763 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.764 = private unnamed_addr constant [135 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.765 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$Handler$int.toArray\0A\00", align 1
@.faila.766 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.767 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.768 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$Handler$int.toArray\0A\00", align 1
@.faila.769 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.770 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.771 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$Handler$int.forEach\0A\00", align 1
@.faila.772 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.773 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.774 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$Handler$int.filter\0A\00", align 1
@.faila.775 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.776 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.777 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$Handler$int.filter\0A\00", align 1
@.faila.778 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.779 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.780 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$Handler$int.any\0A\00", align 1
@.faila.781 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.782 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.783 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$Handler$int.all\0A\00", align 1
@.faila.784 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.785 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.786 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$Handler$int.count\0A\00", align 1
@.faila.787 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.788 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.789 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$Handler$int.sortedBy\0A\00", align 1
@.faila.790 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.791 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.792 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Handler$int.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.793 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.794 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.795 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.796 = private unnamed_addr constant [144 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.797 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.798 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.799 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.800 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.801 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.802 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.803 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.804 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.805 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.806 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.807 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.808 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.809 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.810 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.811 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.812 = private unnamed_addr constant [144 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.813 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.814 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.815 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.816 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.817 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.818 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.819 = private unnamed_addr constant [144 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.820 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.821 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.822 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.823 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.824 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.825 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.826 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.827 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.828 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.829 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.830 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.831 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.832 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.833 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.834 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.835 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.836 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.837 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.838 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.839 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.840 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.841 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.842 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.843 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.844 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.845 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.846 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.847 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.848 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.849 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.850 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.851 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.852 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.853 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$Handler$int.mergeSortRange\0A\00", align 1
@.faila.854 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.855 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.856 = private unnamed_addr constant [144 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Handler$int.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.857 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$Handler$int.find\0A\00", align 1
@.faila.858 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.859 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.860 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$Handler$int.find\0A\00", align 1
@.faila.861 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.862 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.863 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$Handler$int.min\0A\00", align 1
@.faila.864 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.865 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.866 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$Handler$int.min\0A\00", align 1
@.faila.867 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.868 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.869 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$Handler$int.min\0A\00", align 1
@.faila.870 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.871 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.872 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$Handler$int.max\0A\00", align 1
@.faila.873 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.874 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.875 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$Handler$int.max\0A\00", align 1
@.faila.876 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.877 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.878 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$Handler$int.max\0A\00", align 1
@.faila.879 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.880 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1513 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1514 = private global %String { i64 16, ptr @.strdata.1513, i64 0 }
@.strdata.1515 = private constant [17 x i8] c"division by zero\00"
@.strobj.1516 = private global %String { i64 16, ptr @.strdata.1515, i64 0 }
@.strdata.5515 = private constant [1 x i8] zeroinitializer
@.strobj.5516 = private global %String { i64 0, ptr @.strdata.5515, i64 0 }
@.strdata.5517 = private constant [1 x i8] zeroinitializer
@.strobj.5518 = private global %String { i64 0, ptr @.strdata.5517, i64 0 }

define internal void @Box.Box(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 0
  store ptr @Box.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %v = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  store i32 0, ptr %v, align 4, !tbaa !4
  ret void
}

define internal void @Box.add(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %v = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %v1 = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %v2 = load i32, ptr %v1, align 4, !tbaa !4
  %x3 = load i32, ptr %x, align 4
  %2 = add i32 %v2, %x3
  store i32 %2, ptr %v, align 4, !tbaa !4
  ret void
}

define internal i32 @Box.get(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %v = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %v1 = load i32, ptr %v, align 4, !tbaa !4
  ret i32 %v1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %onTick = alloca ptr, align 8
  %bx = alloca ptr, align 8
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
  %Box.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  call void @Box.Box(ptr %Box.obj)
  store ptr %Box.obj, ptr %bx, align 8
  %"Event$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Event$int", ptr null, i64 1) to i64))
  call void @"Event$int.Event$int"(ptr %"Event$int.obj")
  store ptr %"Event$int.obj", ptr %onTick, align 8
  %onTick1 = load ptr, ptr %onTick, align 8
  %env = call ptr @__polaron_malloc(i64 8)
  %16 = getelementptr ptr, ptr %env, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %17 = load ptr, ptr %bx, align 8
  store ptr %17, ptr %cap, align 8
  store ptr %cap, ptr %16, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_0, ptr %closure, align 8
  %18 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env, ptr %18, align 8
  call void @"Event$int.subscribe"(ptr %onTick1, ptr %closure)
  %onTick2 = load ptr, ptr %onTick, align 8
  call void @"Event$int.subscribe#0=__polaron_lambda_1$fs"(ptr %onTick2, ptr @__polaron_closure)
  %onTick3 = load ptr, ptr %onTick, align 8
  call void @"Event$int.emit"(ptr %onTick3, i32 5)
  %onTick4 = load ptr, ptr %onTick, align 8
  call void @"Event$int.emit"(ptr %onTick4, i32 10)
  %bx5 = load ptr, ptr %bx, align 8
  %19 = call i32 @Box.get(ptr %bx5)
  %onTick6 = load ptr, ptr %onTick, align 8
  %20 = call i32 @"Event$int.count"(ptr %onTick6)
  %21 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %19, i32 %20)
  ret i32 0
}

define internal void @"Event$int.Event$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Event$int", ptr %0, i32 0, i32 0
  store ptr @"Event$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %handlers = getelementptr inbounds %"class.Event$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %handlers, align 8, !tbaa !0
  %handlers1 = getelementptr inbounds %"class.Event$int", ptr %0, i32 0, i32 1
  %"ArrayList$Handler$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Handler$int", ptr null, i64 1) to i64))
  call void @"ArrayList$Handler$int.ArrayList$Handler$int"(ptr %"ArrayList$Handler$int.obj")
  store ptr %"ArrayList$Handler$int.obj", ptr %handlers1, align 8, !tbaa !0
  ret void
}

define internal void @"Event$int.subscribe"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %h = alloca ptr, align 8
  store ptr %1, ptr %h, align 8
  %handlers = getelementptr inbounds %"class.Event$int", ptr %0, i32 0, i32 1
  %handlers1 = load ptr, ptr %handlers, align 8, !tbaa !0
  %"Handler$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %h2 = load ptr, ptr %h, align 8
  call void @"Handler$int.Handler$int"(ptr %"Handler$int.obj", ptr %h2)
  call void @"ArrayList$Handler$int.add"(ptr %handlers1, ptr %"Handler$int.obj")
  call void @__polaron_check_live(ptr %"Handler$int.obj")
  %vtbl.addr = getelementptr inbounds %"class.Handler$int", ptr %"Handler$int.obj", i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %2 = icmp ne ptr %dtor.fn, null
  br i1 %2, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %"Handler$int.obj")
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %"Handler$int.obj")
  ret void
}

define internal void @"Event$int.emit"(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %arg = alloca i32, align 4
  store i32 %1, ptr %arg, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %handlers = getelementptr inbounds %"class.Event$int", ptr %0, i32 0, i32 1
  %handlers2 = load ptr, ptr %handlers, align 8, !tbaa !0
  %2 = call i32 @"ArrayList$Handler$int.size"(ptr %handlers2)
  %3 = icmp slt i32 %i1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %handlers3 = getelementptr inbounds %"class.Event$int", ptr %0, i32 0, i32 1
  %handlers4 = load ptr, ptr %handlers3, align 8, !tbaa !0
  %i5 = load i32, ptr %i, align 4
  %5 = call ptr @"ArrayList$Handler$int.get"(ptr %handlers4, i32 %i5)
  %arg6 = load i32, ptr %arg, align 4
  call void @"Handler$int.invoke"(ptr %5, i32 %arg6)
  br label %for.update

for.update:                                       ; preds = %for.body
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

define internal i32 @"Event$int.count"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handlers = getelementptr inbounds %"class.Event$int", ptr %0, i32 0, i32 1
  %handlers1 = load ptr, ptr %handlers, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$Handler$int.size"(ptr %handlers1)
  ret i32 %1
}

define internal void @"Handler$int.Handler$int"(ptr %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  store ptr %1, ptr %f, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Handler$int", ptr %0, i32 0, i32 0
  store ptr @"Handler$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %fn = getelementptr inbounds %"class.Handler$int", ptr %0, i32 0, i32 1
  %f1 = load ptr, ptr %f, align 8
  store ptr %f1, ptr %fn, align 8, !tbaa !0
  ret void
}

define internal void @"Handler$int.invoke"(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %arg = alloca i32, align 4
  store i32 %1, ptr %arg, align 4
  %fn = getelementptr inbounds %"class.Handler$int", ptr %0, i32 0, i32 1
  %fn1 = load ptr, ptr %fn, align 8, !tbaa !0
  %code = load ptr, ptr %fn1, align 8
  %2 = getelementptr ptr, ptr %fn1, i32 1
  %env = load ptr, ptr %2, align 8
  %arg2 = load i32, ptr %arg, align 4
  call void %code(ptr %env, i32 %arg2)
  ret void
}

define internal void @"ArrayList$Handler$int.ArrayList$Handler$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$Handler$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.673, ptr @.cl.674, i64 %contract.l, ptr @.cr.675, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.676, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$Handler$int.~ArrayList$Handler$int"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %"class.Handler$int", ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %3 = icmp ne ptr %dtor.fn, null
  br i1 %3, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %4 = add i64 %ae.iv, 1
  store i64 %4, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data1)
  ret void

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next
}

define internal void @"ArrayList$Handler$int.add"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %old = alloca i32, align 4
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %5 = trunc i64 %len to i32
  %6 = icmp sle i32 %count3, %5
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  store i32 %count7, ptr %old, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %8 = trunc i64 %len12 to i32
  %9 = icmp sge i32 %count9, %8
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data13 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %11 = trunc i64 %len15 to i32
  %12 = mul i32 %11, 2
  %13 = sext i32 %12 to i64
  %14 = mul i64 %13, 8
  %15 = add i64 8, %14
  %arr = call ptr @__polaron_malloc(i64 %15)
  store i64 %13, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data, i32 0, i64 %14)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

if.end:                                           ; preds = %ae.end, %entry
  %data37 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count39 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count40 = load i32, ptr %count39, align 4, !tbaa !4
  %17 = sext i32 %count40 to i64
  %arr.len41 = load i64, ptr %data38, align 8
  %arr.oob42 = icmp uge i64 %17, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %18 = icmp slt i32 %i16, %count18
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger19 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i, align 4
  %20 = sext i32 %i20 to i64
  %arr.len = load i64, ptr %bigger19, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok28
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data32 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data33 = load ptr, ptr %data32, align 8, !tbaa !0
  %ae.len = load i64, ptr %data33, align 8
  %arr.data34 = getelementptr i8, ptr %data33, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.677, ptr @.faila.678, i64 %20, ptr @.failb.679, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %bigger19, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data21, i64 %20
  %data22 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %23 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %23, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.680, ptr @.faila.681, i64 %23, ptr @.failb.682, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok
  %arr.data29 = getelementptr i8, ptr %data23, i64 8
  %arr.elem30 = getelementptr inbounds ptr, ptr %arr.data29, i64 %23
  %elem = load ptr, ptr %arr.elem30, align 8
  %"Handler$int.copy31" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %24 = call ptr @memcpy(ptr %"Handler$int.copy31", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy31", ptr %arr.elem, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %25 = icmp ult i64 %ae.iv, %ae.len
  br i1 %25, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data34, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %26 = icmp ne ptr %ae.el, null
  br i1 %26, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %"class.Handler$int", ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %27 = icmp ne ptr %dtor.fn, null
  br i1 %27, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %28 = add i64 %ae.iv, 1
  store i64 %28, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data33)
  %data35 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %bigger36 = load ptr, ptr %bigger, align 8
  store ptr %bigger36, ptr %data35, align 8, !tbaa !0
  br label %if.end

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

idx.bad43:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.683, ptr @.faila.684, i64 %17, ptr @.failb.685, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %if.end
  %arr.data45 = getelementptr i8, ptr %data38, i64 8
  %arr.elem46 = getelementptr inbounds ptr, ptr %arr.data45, i64 %17
  %item47 = load ptr, ptr %item, align 8
  %"Handler$int.copy48" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %29 = call ptr @memcpy(ptr %"Handler$int.copy48", ptr %item47, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy48", ptr %arr.elem46, align 8
  %count49 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count50 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count51 = load i32, ptr %count50, align 4, !tbaa !4
  %30 = add i32 %count51, 1
  store i32 %30, ptr %count49, align 4, !tbaa !4
  %count52 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !4
  %old54 = load i32, ptr %old, align 4
  %31 = add i32 %old54, 1
  %32 = icmp eq i32 %count53, %31
  %33 = zext i1 %32 to i32
  %contract.ok = icmp ne i32 %33, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.contract.686, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok44
  %count55 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count56 = load i32, ptr %count55, align 4, !tbaa !4
  %34 = icmp sge i32 %count56, 0
  %35 = zext i1 %34 to i32
  %contract.ok57 = icmp ne i32 %35, 0
  br i1 %contract.ok57, label %contract.cont59, label %contract.fail58

contract.fail58:                                  ; preds = %contract.cont
  %count60 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count61 = load i32, ptr %count60, align 4, !tbaa !4
  %contract.l = sext i32 %count61 to i64
  call void @__polaron_fail(ptr @.contract.687, ptr @.cl.688, i64 %contract.l, ptr @.cr.689, i64 0, i32 1)
  unreachable

contract.cont59:                                  ; preds = %contract.cont
  %count62 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count63 = load i32, ptr %count62, align 4, !tbaa !4
  %data64 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data65 = load ptr, ptr %data64, align 8, !tbaa !0
  %len66 = load i64, ptr %data65, align 8
  %36 = trunc i64 %len66 to i32
  %37 = icmp sle i32 %count63, %36
  %38 = zext i1 %37 to i32
  %contract.ok67 = icmp ne i32 %38, 0
  br i1 %contract.ok67, label %contract.cont69, label %contract.fail68

contract.fail68:                                  ; preds = %contract.cont59
  call void @__polaron_fail(ptr @.contract.690, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont69:                                  ; preds = %contract.cont59
  ret void
}

define internal void @"ArrayList$Handler$int.ensureCapacity"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count31 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !4
  %14 = icmp sge i32 %count32, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
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
  %data26 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data27 = load ptr, ptr %data26, align 8, !tbaa !0
  %ae.len = load i64, ptr %data27, align 8
  %arr.data28 = getelementptr i8, ptr %data27, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.691, ptr @.faila.692, i64 %18, ptr @.failb.693, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.694, ptr @.faila.695, i64 %21, ptr @.failb.696, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %21
  %elem = load ptr, ptr %arr.elem25, align 8
  %"Handler$int.copy" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %22 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %arr.elem, align 8
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
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %"class.Handler$int", ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %25 = icmp ne ptr %dtor.fn, null
  br i1 %25, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %26 = add i64 %ae.iv, 1
  store i64 %26, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data27)
  %data29 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %bigger30 = load ptr, ptr %bigger, align 8
  store ptr %bigger30, ptr %data29, align 8, !tbaa !0
  br label %if.end

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

contract.fail:                                    ; preds = %if.end
  %count33 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count34 = load i32, ptr %count33, align 4, !tbaa !4
  %contract.l = sext i32 %count34 to i64
  call void @__polaron_fail(ptr @.contract.697, ptr @.cl.698, i64 %contract.l, ptr @.cr.699, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count35 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %data37 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !0
  %len39 = load i64, ptr %data38, align 8
  %27 = trunc i64 %len39 to i32
  %28 = icmp sle i32 %count36, %27
  %29 = zext i1 %28 to i32
  %contract.ok40 = icmp ne i32 %29, 0
  br i1 %contract.ok40, label %contract.cont42, label %contract.fail41

contract.fail41:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.700, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont42:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$Handler$int.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.701, ptr @.faila.702, i64 %13, ptr @.failb.703, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  ret ptr %elem

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.704, ptr @.faila.705, i64 %14, ptr @.failb.706, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %if.end
  %arr.data22 = getelementptr i8, ptr %data16, i64 8
  %arr.elem23 = getelementptr inbounds ptr, ptr %arr.data22, i64 %14
  %elem24 = load ptr, ptr %arr.elem23, align 8
  ret ptr %elem24
}

define internal void @"ArrayList$Handler$int.set"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %3 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %2, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %6 = trunc i64 %len to i32
  %7 = icmp sle i32 %count3, %6
  %8 = zext i1 %7 to i32
  %inv.assume5 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume5)
  %i6 = load i32, ptr %i, align 4
  %9 = icmp slt i32 %i6, 0
  %10 = zext i1 %9 to i32
  %sc.a = icmp ne i32 %10, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i7 = load i32, ptr %i, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %11 = icmp sge i32 %i7, %count9
  %12 = zext i1 %11 to i32
  %sc.b = icmp ne i32 %12, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %13 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %14 = trunc i64 %len14 to i32
  %15 = sext i32 %14 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %15, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data22 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %16 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %16, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.707, ptr @.faila.708, i64 %15, ptr @.failb.709, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %15
  %item15 = load ptr, ptr %item, align 8
  %"Handler$int.copy16" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %17 = call ptr @memcpy(ptr %"Handler$int.copy16", ptr %item15, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy16", ptr %arr.elem, align 8
  %count17 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %data19 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data20 = load ptr, ptr %data19, align 8, !tbaa !0
  %len21 = load i64, ptr %data20, align 8
  %18 = trunc i64 %len21 to i32
  %19 = icmp sle i32 %count18, %18
  %20 = zext i1 %19 to i32
  %contract.ok = icmp ne i32 %20, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  call void @__polaron_fail(ptr @.contract.710, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad27:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.711, ptr @.faila.712, i64 %16, ptr @.failb.713, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %if.end
  %arr.data29 = getelementptr i8, ptr %data23, i64 8
  %arr.elem30 = getelementptr inbounds ptr, ptr %arr.data29, i64 %16
  %item31 = load ptr, ptr %item, align 8
  %"Handler$int.copy32" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %21 = call ptr @memcpy(ptr %"Handler$int.copy32", ptr %item31, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy32", ptr %arr.elem30, align 8
  %count33 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count34 = load i32, ptr %count33, align 4, !tbaa !4
  %data35 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0
  %len37 = load i64, ptr %data36, align 8
  %22 = trunc i64 %len37 to i32
  %23 = icmp sle i32 %count34, %22
  %24 = zext i1 %23 to i32
  %contract.ok38 = icmp ne i32 %24, 0
  br i1 %contract.ok38, label %contract.cont40, label %contract.fail39

contract.fail39:                                  ; preds = %idx.ok28
  call void @__polaron_fail(ptr @.contract.714, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont40:                                  ; preds = %idx.ok28
  ret void
}

define internal i32 @"ArrayList$Handler$int.indexOf"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %5 = trunc i64 %len to i32
  %6 = icmp sle i32 %count3, %5
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %8 = icmp slt i32 %i6, %count8
  %9 = zext i1 %8 to i32
  br i1 %8, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data9 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data10 = load ptr, ptr %data9, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i11 = load i32, ptr %i, align 4
  %10 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %data10, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 -1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.715, ptr @.faila.716, i64 %10, ptr @.failb.717, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data10, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %item12 = load ptr, ptr %item, align 8
  %13 = call i32 @Object.equalsKey(ptr %elem, ptr %item12)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %i13 = load i32, ptr %i, align 4
  ret i32 %i13

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$Handler$int.contains"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %5 = trunc i64 %len to i32
  %6 = icmp sle i32 %count3, %5
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load ptr, ptr %item, align 8
  %8 = call i32 @"ArrayList$Handler$int.indexOf"(ptr %0, ptr %item6)
  %9 = icmp sge i32 %8, 0
  %10 = zext i1 %9 to i32
  ret i32 %10
}

define internal void @"ArrayList$Handler$int.removeAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %oob = alloca ptr, align 8
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.718, ptr @.faila.719, i64 %13, ptr @.failb.720, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %14 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %oob, align 8
  %count15 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %15 = icmp sge i32 %count16, 0
  %16 = zext i1 %15 to i32
  %contract.ok = icmp ne i32 %16, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %contract.l = sext i32 %count18 to i64
  call void @__polaron_fail(ptr @.contract.721, ptr @.cl.722, i64 %contract.l, ptr @.cr.723, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %data21 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0
  %len23 = load i64, ptr %data22, align 8
  %17 = trunc i64 %len23 to i32
  %18 = icmp sle i32 %count20, %17
  %19 = zext i1 %18 to i32
  %contract.ok24 = icmp ne i32 %19, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.724, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j28 = load i32, ptr %j, align 4
  %count29 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %20 = sub i32 %count30, 1
  %21 = icmp slt i32 %j28, %20
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count51 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count52 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !4
  %26 = sub i32 %count53, 1
  store i32 %26, ptr %count51, align 4, !tbaa !4
  %count54 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !4
  %27 = icmp sge i32 %count55, 0
  %28 = zext i1 %27 to i32
  %contract.ok56 = icmp ne i32 %28, 0
  br i1 %contract.ok56, label %contract.cont58, label %contract.fail57

idx.bad36:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.725, ptr @.faila.726, i64 %23, ptr @.failb.727, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %for.body
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 %23
  %data40 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data41 = load ptr, ptr %data40, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j42 = load i32, ptr %j, align 4
  %29 = add i32 %j42, 1
  %30 = sext i32 %29 to i64
  %arr.len43 = load i64, ptr %data41, align 8
  %arr.oob44 = icmp uge i64 %30, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !8

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.728, ptr @.faila.729, i64 %30, ptr @.failb.730, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok37
  %arr.data47 = getelementptr i8, ptr %data41, i64 8
  %arr.elem48 = getelementptr inbounds ptr, ptr %arr.data47, i64 %30
  %elem49 = load ptr, ptr %arr.elem48, align 8
  %"Handler$int.copy50" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %31 = call ptr @memcpy(ptr %"Handler$int.copy50", ptr %elem49, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy50", ptr %arr.elem39, align 8
  br label %for.update

contract.fail57:                                  ; preds = %for.end
  %count59 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count60 = load i32, ptr %count59, align 4, !tbaa !4
  %contract.l61 = sext i32 %count60 to i64
  call void @__polaron_fail(ptr @.contract.731, ptr @.cl.732, i64 %contract.l61, ptr @.cr.733, i64 0, i32 1)
  unreachable

contract.cont58:                                  ; preds = %for.end
  %count62 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count63 = load i32, ptr %count62, align 4, !tbaa !4
  %data64 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data65 = load ptr, ptr %data64, align 8, !tbaa !0
  %len66 = load i64, ptr %data65, align 8
  %32 = trunc i64 %len66 to i32
  %33 = icmp sle i32 %count63, %32
  %34 = zext i1 %33 to i32
  %contract.ok67 = icmp ne i32 %34, 0
  br i1 %contract.ok67, label %contract.cont69, label %contract.fail68

contract.fail68:                                  ; preds = %contract.cont58
  call void @__polaron_fail(ptr @.contract.734, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont69:                                  ; preds = %contract.cont58
  ret void
}

define internal void @"ArrayList$Handler$int.insertAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %j = alloca i32, align 4
  %ae.i = alloca i64, align 8
  %k = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %3 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %2, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %6 = trunc i64 %len to i32
  %7 = icmp sle i32 %count3, %6
  %8 = zext i1 %7 to i32
  %inv.assume5 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume5)
  %i6 = load i32, ptr %i, align 4
  %9 = icmp slt i32 %i6, 0
  %10 = zext i1 %9 to i32
  %sc.a = icmp ne i32 %10, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i7 = load i32, ptr %i, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %11 = icmp sgt i32 %i7, %count9
  %12 = zext i1 %11 to i32
  %sc.b = icmp ne i32 %12, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %13 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %14 = trunc i64 %len14 to i32
  %15 = sext i32 %14 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %15, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %count29 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %data31 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  %len33 = load i64, ptr %data32, align 8
  %16 = trunc i64 %len33 to i32
  %17 = icmp sge i32 %count30, %16
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then34, label %if.end35

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.735, ptr @.faila.736, i64 %15, ptr @.failb.737, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %15
  %item15 = load ptr, ptr %item, align 8
  %"Handler$int.copy16" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %19 = call ptr @memcpy(ptr %"Handler$int.copy16", ptr %item15, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy16", ptr %arr.elem, align 8
  %count17 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %20 = icmp sge i32 %count18, 0
  %21 = zext i1 %20 to i32
  %contract.ok = icmp ne i32 %21, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %contract.l = sext i32 %count20 to i64
  call void @__polaron_fail(ptr @.contract.738, ptr @.cl.739, i64 %contract.l, ptr @.cr.740, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count21 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count22 = load i32, ptr %count21, align 4, !tbaa !4
  %data23 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data24 = load ptr, ptr %data23, align 8, !tbaa !0
  %len25 = load i64, ptr %data24, align 8
  %22 = trunc i64 %len25 to i32
  %23 = icmp sle i32 %count22, %22
  %24 = zext i1 %23 to i32
  %contract.ok26 = icmp ne i32 %24, 0
  br i1 %contract.ok26, label %contract.cont28, label %contract.fail27

contract.fail27:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.741, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont28:                                  ; preds = %contract.cont
  ret void

if.then34:                                        ; preds = %if.end
  %data36 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data37 = load ptr, ptr %data36, align 8, !tbaa !0
  %len38 = load i64, ptr %data37, align 8
  %25 = trunc i64 %len38 to i32
  %26 = mul i32 %25, 2
  %27 = sext i32 %26 to i64
  %28 = mul i64 %27, 8
  %29 = add i64 8, %28
  %arr = call ptr @__polaron_malloc(i64 %29)
  store i64 %27, ptr %arr, align 8
  %arr.data39 = getelementptr i8, ptr %arr, i64 8
  %30 = call ptr @memset(ptr %arr.data39, i32 0, i64 %28)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond

if.end35:                                         ; preds = %ae.end, %if.end
  %count66 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count67 = load i32, ptr %count66, align 4, !tbaa !4
  store i32 %count67, ptr %j, align 4
  br label %for.cond68

for.cond:                                         ; preds = %for.update, %if.then34
  %k40 = load i32, ptr %k, align 4
  %count41 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count42 = load i32, ptr %count41, align 4, !tbaa !4
  %31 = icmp slt i32 %k40, %count42
  %32 = zext i1 %31 to i32
  br i1 %31, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger43 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %k44 = load i32, ptr %k, align 4
  %33 = sext i32 %k44 to i64
  %arr.len45 = load i64, ptr %bigger43, align 8
  %arr.oob46 = icmp uge i64 %33, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

for.update:                                       ; preds = %idx.ok57
  %34 = load i32, ptr %k, align 4
  %35 = add i32 %34, 1
  store i32 %35, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data61 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data62 = load ptr, ptr %data61, align 8, !tbaa !0
  %ae.len = load i64, ptr %data62, align 8
  %arr.data63 = getelementptr i8, ptr %data62, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad47:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.742, ptr @.faila.743, i64 %33, ptr @.failb.744, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %for.body
  %arr.data49 = getelementptr i8, ptr %bigger43, i64 8
  %arr.elem50 = getelementptr inbounds ptr, ptr %arr.data49, i64 %33
  %data51 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data52 = load ptr, ptr %data51, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %k53 = load i32, ptr %k, align 4
  %36 = sext i32 %k53 to i64
  %arr.len54 = load i64, ptr %data52, align 8
  %arr.oob55 = icmp uge i64 %36, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !8

idx.bad56:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.745, ptr @.faila.746, i64 %36, ptr @.failb.747, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %idx.ok48
  %arr.data58 = getelementptr i8, ptr %data52, i64 8
  %arr.elem59 = getelementptr inbounds ptr, ptr %arr.data58, i64 %36
  %elem = load ptr, ptr %arr.elem59, align 8
  %"Handler$int.copy60" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %37 = call ptr @memcpy(ptr %"Handler$int.copy60", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy60", ptr %arr.elem50, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %38 = icmp ult i64 %ae.iv, %ae.len
  br i1 %38, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data63, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %39 = icmp ne ptr %ae.el, null
  br i1 %39, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %"class.Handler$int", ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %40 = icmp ne ptr %dtor.fn, null
  br i1 %40, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %41 = add i64 %ae.iv, 1
  store i64 %41, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data62)
  %data64 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %bigger65 = load ptr, ptr %bigger, align 8
  store ptr %bigger65, ptr %data64, align 8, !tbaa !0
  br label %if.end35

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

for.cond68:                                       ; preds = %for.update70, %if.end35
  %j72 = load i32, ptr %j, align 4
  %i73 = load i32, ptr %i, align 4
  %42 = icmp sgt i32 %j72, %i73
  %43 = zext i1 %42 to i32
  br i1 %42, label %for.body69, label %for.end71

for.body69:                                       ; preds = %for.cond68
  %data74 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data75 = load ptr, ptr %data74, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j76 = load i32, ptr %j, align 4
  %44 = sext i32 %j76 to i64
  %arr.len77 = load i64, ptr %data75, align 8
  %arr.oob78 = icmp uge i64 %44, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !8

for.update70:                                     ; preds = %idx.ok89
  %45 = load i32, ptr %j, align 4
  %46 = sub i32 %45, 1
  store i32 %46, ptr %j, align 4
  br label %for.cond68

for.end71:                                        ; preds = %for.cond68
  %data94 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data95 = load ptr, ptr %data94, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i96 = load i32, ptr %i, align 4
  %47 = sext i32 %i96 to i64
  %arr.len97 = load i64, ptr %data95, align 8
  %arr.oob98 = icmp uge i64 %47, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !8

idx.bad79:                                        ; preds = %for.body69
  call void @__polaron_fail(ptr @.fail.748, ptr @.faila.749, i64 %44, ptr @.failb.750, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %for.body69
  %arr.data81 = getelementptr i8, ptr %data75, i64 8
  %arr.elem82 = getelementptr inbounds ptr, ptr %arr.data81, i64 %44
  %data83 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data84 = load ptr, ptr %data83, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j85 = load i32, ptr %j, align 4
  %48 = sub i32 %j85, 1
  %49 = sext i32 %48 to i64
  %arr.len86 = load i64, ptr %data84, align 8
  %arr.oob87 = icmp uge i64 %49, %arr.len86
  br i1 %arr.oob87, label %idx.bad88, label %idx.ok89, !prof !8

idx.bad88:                                        ; preds = %idx.ok80
  call void @__polaron_fail(ptr @.fail.751, ptr @.faila.752, i64 %49, ptr @.failb.753, i64 %arr.len86, i32 70)
  unreachable

idx.ok89:                                         ; preds = %idx.ok80
  %arr.data90 = getelementptr i8, ptr %data84, i64 8
  %arr.elem91 = getelementptr inbounds ptr, ptr %arr.data90, i64 %49
  %elem92 = load ptr, ptr %arr.elem91, align 8
  %"Handler$int.copy93" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %50 = call ptr @memcpy(ptr %"Handler$int.copy93", ptr %elem92, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy93", ptr %arr.elem82, align 8
  br label %for.update70

idx.bad99:                                        ; preds = %for.end71
  call void @__polaron_fail(ptr @.fail.754, ptr @.faila.755, i64 %47, ptr @.failb.756, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %for.end71
  %arr.data101 = getelementptr i8, ptr %data95, i64 8
  %arr.elem102 = getelementptr inbounds ptr, ptr %arr.data101, i64 %47
  %item103 = load ptr, ptr %item, align 8
  %"Handler$int.copy104" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %51 = call ptr @memcpy(ptr %"Handler$int.copy104", ptr %item103, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy104", ptr %arr.elem102, align 8
  %count105 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count106 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count107 = load i32, ptr %count106, align 4, !tbaa !4
  %52 = add i32 %count107, 1
  store i32 %52, ptr %count105, align 4, !tbaa !4
  %count108 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count109 = load i32, ptr %count108, align 4, !tbaa !4
  %53 = icmp sge i32 %count109, 0
  %54 = zext i1 %53 to i32
  %contract.ok110 = icmp ne i32 %54, 0
  br i1 %contract.ok110, label %contract.cont112, label %contract.fail111

contract.fail111:                                 ; preds = %idx.ok100
  %count113 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count114 = load i32, ptr %count113, align 4, !tbaa !4
  %contract.l115 = sext i32 %count114 to i64
  call void @__polaron_fail(ptr @.contract.757, ptr @.cl.758, i64 %contract.l115, ptr @.cr.759, i64 0, i32 1)
  unreachable

contract.cont112:                                 ; preds = %idx.ok100
  %count116 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count117 = load i32, ptr %count116, align 4, !tbaa !4
  %data118 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data119 = load ptr, ptr %data118, align 8, !tbaa !0
  %len120 = load i64, ptr %data119, align 8
  %55 = trunc i64 %len120 to i32
  %56 = icmp sle i32 %count117, %55
  %57 = zext i1 %56 to i32
  %contract.ok121 = icmp ne i32 %57, 0
  br i1 %contract.ok121, label %contract.cont123, label %contract.fail122

contract.fail122:                                 ; preds = %contract.cont112
  call void @__polaron_fail(ptr @.contract.760, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont123:                                 ; preds = %contract.cont112
  ret void
}

define internal i32 @"ArrayList$Handler$int.remove"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %5 = trunc i64 %len to i32
  %6 = icmp sle i32 %count3, %5
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load ptr, ptr %item, align 8
  %8 = call i32 @"ArrayList$Handler$int.indexOf"(ptr %0, ptr %item6)
  store i32 %8, ptr %i, align 4
  %i7 = load i32, ptr %i, align 4
  %9 = icmp slt i32 %i7, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %i8 = load i32, ptr %i, align 4
  call void @"ArrayList$Handler$int.removeAt"(ptr %0, i32 %i8)
  ret i32 1
}

define internal void @"ArrayList$Handler$int.clear"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !4
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.761, ptr @.cl.762, i64 %contract.l, ptr @.cr.763, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %data13 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.764, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$Handler$int.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
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
  %count9 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
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
  call void @__polaron_fail(ptr @.fail.765, ptr @.faila.766, i64 %12, ptr @.failb.767, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.768, ptr @.faila.769, i64 %15, ptr @.failb.770, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %15
  %elem = load ptr, ptr %arr.elem22, align 8
  %"Handler$int.copy" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %arr.elem, align 8
  br label %for.update
}

define internal i32 @"ArrayList$Handler$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  ret i32 %count7
}

define internal i32 @"ArrayList$Handler$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = icmp eq i32 %count7, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal void @"ArrayList$Handler$int.forEach"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %action = alloca ptr, align 8
  store ptr %1, ptr %action, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.771, ptr @.faila.772, i64 %10, ptr @.failb.773, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  call void %code(ptr %env, ptr %elem)
  br label %for.update
}

define internal ptr @"ArrayList$Handler$int.filter"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %keep = alloca ptr, align 8
  store ptr %1, ptr %keep, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$Handler$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Handler$int", ptr null, i64 1) to i64))
  call void @"ArrayList$Handler$int.ArrayList$Handler$int"(ptr %"ArrayList$Handler$int.obj")
  store ptr %"ArrayList$Handler$int.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$Handler$int.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.774, ptr @.faila.775, i64 %10, ptr @.failb.776, i64 %arr.len, i32 70)
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
  %data17 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.777, ptr @.faila.778, i64 %15, ptr @.failb.779, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %15
  %elem26 = load ptr, ptr %arr.elem25, align 8
  call void @"ArrayList$Handler$int.add"(ptr %out16, ptr %elem26)
  br label %if.end
}

define internal i32 @"ArrayList$Handler$int.any"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.780, ptr @.faila.781, i64 %10, ptr @.failb.782, i64 %arr.len, i32 70)
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

define internal i32 @"ArrayList$Handler$int.all"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.783, ptr @.faila.784, i64 %10, ptr @.failb.785, i64 %arr.len, i32 70)
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

define internal i32 @"ArrayList$Handler$int.count"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %hits = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.786, ptr @.faila.787, i64 %10, ptr @.failb.788, i64 %arr.len, i32 70)
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

define internal ptr @"ArrayList$Handler$int.sortedBy"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %ae.i = alloca i64, align 8
  %scratch = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$Handler$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Handler$int", ptr null, i64 1) to i64))
  call void @"ArrayList$Handler$int.ArrayList$Handler$int"(ptr %"ArrayList$Handler$int.obj")
  store ptr %"ArrayList$Handler$int.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$Handler$int.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %12 = call i32 @"ArrayList$Handler$int.size"(ptr %out16)
  %13 = icmp sgt i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.789, ptr @.faila.790, i64 %9, ptr @.failb.791, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %9
  %elem = load ptr, ptr %arr.elem, align 8
  call void @"ArrayList$Handler$int.add"(ptr %out12, ptr %elem)
  br label %for.update

if.then:                                          ; preds = %for.end
  %out17 = load ptr, ptr %out, align 8
  %15 = call i32 @"ArrayList$Handler$int.size"(ptr %out17)
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
  %20 = call i32 @"ArrayList$Handler$int.size"(ptr %out21)
  %21 = sub i32 %20, 1
  %compare22 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Handler$int.mergeSortRange"(ptr %out19, ptr %scratch20, i32 0, i32 %21, ptr %compare22)
  %scratch23 = load ptr, ptr %scratch, align 8
  %ae.len = load i64, ptr %scratch23, align 8
  %arr.data24 = getelementptr i8, ptr %scratch23, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

if.end:                                           ; preds = %ae.end, %for.end
  %out25 = load ptr, ptr %out, align 8
  %count26 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
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
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %"class.Handler$int", ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %26 = icmp ne ptr %dtor.fn, null
  br i1 %26, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %27 = add i64 %ae.iv, 1
  store i64 %27, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %scratch23)
  br label %if.end

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

contract.fail:                                    ; preds = %if.end
  %count28 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %contract.l = sext i32 %count29 to i64
  call void @__polaron_fail(ptr @.contract.792, ptr @.cl.793, i64 %contract.l, ptr @.cr.794, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count30 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %data32 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data33 = load ptr, ptr %data32, align 8, !tbaa !0
  %len34 = load i64, ptr %data33, align 8
  %28 = trunc i64 %len34 to i32
  %29 = icmp sle i32 %count31, %28
  %30 = zext i1 %29 to i32
  %contract.ok35 = icmp ne i32 %30, 0
  br i1 %contract.ok35, label %contract.cont37, label %contract.fail36

contract.fail36:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.795, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont37:                                  ; preds = %contract.cont
  ret ptr %out25
}

define internal void @"ArrayList$Handler$int.mergeSortRange"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3, ptr %4) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i32, align 4
  %k = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %mid = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %q = alloca i32, align 4
  %key = alloca ptr, align 8
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %p = alloca i32, align 4
  %compare = alloca ptr, align 8
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %tmp = alloca ptr, align 8
  store ptr %1, ptr %tmp, align 8
  store i32 %2, ptr %lo, align 4
  store i32 %3, ptr %hi, align 4
  store ptr %4, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.796, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data20 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count71 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count72 = load i32, ptr %count71, align 4, !tbaa !4
  %data73 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data74 = load ptr, ptr %data73, align 8, !tbaa !0
  %len75 = load i64, ptr %data74, align 8
  %27 = trunc i64 %len75 to i32
  %28 = icmp sle i32 %count72, %27
  %29 = zext i1 %28 to i32
  %contract.ok76 = icmp ne i32 %29, 0
  br i1 %contract.ok76, label %contract.cont78, label %contract.fail77

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.797, ptr @.faila.798, i64 %25, ptr @.failb.799, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %25
  %elem = load ptr, ptr %arr.elem, align 8
  %30 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %key, align 8
  %p23 = load i32, ptr %p, align 4
  %31 = sub i32 %p23, 1
  store i32 %31, ptr %q, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok53, %idx.ok
  %q24 = load i32, ptr %q, align 4
  %lo25 = load i32, ptr %lo, align 4
  %32 = icmp sge i32 %q24, %lo25
  %33 = zext i1 %32 to i32
  %sc.a = icmp ne i32 %33, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %data38 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data39 = load ptr, ptr %data38, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q40 = load i32, ptr %q, align 4
  %34 = add i32 %q40, 1
  %35 = sext i32 %34 to i64
  %arr.len41 = load i64, ptr %data39, align 8
  %arr.oob42 = icmp uge i64 %35, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

while.end:                                        ; preds = %sc.end
  %data59 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data60 = load ptr, ptr %data59, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q61 = load i32, ptr %q, align 4
  %36 = add i32 %q61, 1
  %37 = sext i32 %36 to i64
  %arr.len62 = load i64, ptr %data60, align 8
  %arr.oob63 = icmp uge i64 %37, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !8

sc.rhs:                                           ; preds = %while.cond
  %compare26 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare26, align 8
  %38 = getelementptr ptr, ptr %compare26, i32 1
  %env = load ptr, ptr %38, align 8
  %data27 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q29 = load i32, ptr %q, align 4
  %39 = sext i32 %q29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %39, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

sc.end:                                           ; preds = %idx.ok33, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok33 ]
  %40 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad32:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.800, ptr @.faila.801, i64 %39, ptr @.failb.802, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %sc.rhs
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %39
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %key37 = load ptr, ptr %key, align 8
  %41 = call i32 %code(ptr %env, ptr %elem36, ptr %key37)
  %42 = icmp sgt i32 %41, 0
  %43 = zext i1 %42 to i32
  %sc.b = icmp ne i32 %43, 0
  br label %sc.end

idx.bad43:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.803, ptr @.faila.804, i64 %35, ptr @.failb.805, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.body
  %arr.data45 = getelementptr i8, ptr %data39, i64 8
  %arr.elem46 = getelementptr inbounds ptr, ptr %arr.data45, i64 %35
  %data47 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q49 = load i32, ptr %q, align 4
  %44 = sext i32 %q49 to i64
  %arr.len50 = load i64, ptr %data48, align 8
  %arr.oob51 = icmp uge i64 %44, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !8

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.806, ptr @.faila.807, i64 %44, ptr @.failb.808, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %data48, i64 8
  %arr.elem55 = getelementptr inbounds ptr, ptr %arr.data54, i64 %44
  %elem56 = load ptr, ptr %arr.elem55, align 8
  %"Handler$int.copy57" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %45 = call ptr @memcpy(ptr %"Handler$int.copy57", ptr %elem56, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy57", ptr %arr.elem46, align 8
  %q58 = load i32, ptr %q, align 4
  %46 = sub i32 %q58, 1
  store i32 %46, ptr %q, align 4
  br label %while.cond

idx.bad64:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.809, ptr @.faila.810, i64 %37, ptr @.failb.811, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %while.end
  %arr.data66 = getelementptr i8, ptr %data60, i64 8
  %arr.elem67 = getelementptr inbounds ptr, ptr %arr.data66, i64 %37
  %key68 = load ptr, ptr %key, align 8
  %"Handler$int.copy69" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %47 = call ptr @memcpy(ptr %"Handler$int.copy69", ptr %key68, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy69", ptr %arr.elem67, align 8
  br label %for.update

contract.fail77:                                  ; preds = %for.end
  call void @__polaron_fail(ptr @.contract.812, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @"ArrayList$Handler$int.mergeSortRange"(ptr %0, ptr %tmp81, i32 %lo82, i32 %mid83, ptr %compare84)
  %tmp85 = load ptr, ptr %tmp, align 8
  %mid86 = load i32, ptr %mid, align 4
  %49 = add i32 %mid86, 1
  %hi87 = load i32, ptr %hi, align 4
  %compare88 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Handler$int.mergeSortRange"(ptr %0, ptr %tmp85, i32 %49, i32 %hi87, ptr %compare88)
  %compare89 = load ptr, ptr %compare, align 8
  %code90 = load ptr, ptr %compare89, align 8
  %50 = getelementptr ptr, ptr %compare89, i32 1
  %env91 = load ptr, ptr %50, align 8
  %data92 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data93 = load ptr, ptr %data92, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid94 = load i32, ptr %mid, align 4
  %51 = sext i32 %mid94 to i64
  %arr.len95 = load i64, ptr %data93, align 8
  %arr.oob96 = icmp uge i64 %51, %arr.len95
  br i1 %arr.oob96, label %idx.bad97, label %idx.ok98, !prof !8

idx.bad97:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.813, ptr @.faila.814, i64 %51, ptr @.failb.815, i64 %arr.len95, i32 70)
  unreachable

idx.ok98:                                         ; preds = %div.ok
  %arr.data99 = getelementptr i8, ptr %data93, i64 8
  %arr.elem100 = getelementptr inbounds ptr, ptr %arr.data99, i64 %51
  %elem101 = load ptr, ptr %arr.elem100, align 8
  %data102 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data103 = load ptr, ptr %data102, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid104 = load i32, ptr %mid, align 4
  %52 = add i32 %mid104, 1
  %53 = sext i32 %52 to i64
  %arr.len105 = load i64, ptr %data103, align 8
  %arr.oob106 = icmp uge i64 %53, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !8

idx.bad107:                                       ; preds = %idx.ok98
  call void @__polaron_fail(ptr @.fail.816, ptr @.faila.817, i64 %53, ptr @.failb.818, i64 %arr.len105, i32 70)
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
  %count114 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count115 = load i32, ptr %count114, align 4, !tbaa !4
  %data116 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.819, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data140 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.820, ptr @.faila.821, i64 %64, ptr @.failb.822, i64 %arr.len143, i32 70)
  unreachable

idx.ok146:                                        ; preds = %while.body126
  %arr.data147 = getelementptr i8, ptr %data141, i64 8
  %arr.elem148 = getelementptr inbounds ptr, ptr %arr.data147, i64 %64
  %elem149 = load ptr, ptr %arr.elem148, align 8
  %data150 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data151 = load ptr, ptr %data150, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j152 = load i32, ptr %j, align 4
  %68 = sext i32 %j152 to i64
  %arr.len153 = load i64, ptr %data151, align 8
  %arr.oob154 = icmp uge i64 %68, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !8

idx.bad155:                                       ; preds = %idx.ok146
  call void @__polaron_fail(ptr @.fail.823, ptr @.faila.824, i64 %68, ptr @.failb.825, i64 %arr.len153, i32 70)
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
  call void @__polaron_fail(ptr @.fail.826, ptr @.faila.827, i64 %72, ptr @.failb.828, i64 %arr.len164, i32 70)
  unreachable

idx.ok167:                                        ; preds = %if.then160
  %arr.data168 = getelementptr i8, ptr %tmp162, i64 8
  %arr.elem169 = getelementptr inbounds ptr, ptr %arr.data168, i64 %72
  %data170 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data171 = load ptr, ptr %data170, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i172 = load i32, ptr %i, align 4
  %75 = sext i32 %i172 to i64
  %arr.len173 = load i64, ptr %data171, align 8
  %arr.oob174 = icmp uge i64 %75, %arr.len173
  br i1 %arr.oob174, label %idx.bad175, label %idx.ok176, !prof !8

idx.bad175:                                       ; preds = %idx.ok167
  call void @__polaron_fail(ptr @.fail.829, ptr @.faila.830, i64 %75, ptr @.failb.831, i64 %arr.len173, i32 70)
  unreachable

idx.ok176:                                        ; preds = %idx.ok167
  %arr.data177 = getelementptr i8, ptr %data171, i64 8
  %arr.elem178 = getelementptr inbounds ptr, ptr %arr.data177, i64 %75
  %elem179 = load ptr, ptr %arr.elem178, align 8
  %"Handler$int.copy180" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %76 = call ptr @memcpy(ptr %"Handler$int.copy180", ptr %elem179, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy180", ptr %arr.elem169, align 8
  %i181 = load i32, ptr %i, align 4
  %77 = add i32 %i181, 1
  store i32 %77, ptr %i, align 4
  br label %if.end161

idx.bad186:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.832, ptr @.faila.833, i64 %73, ptr @.failb.834, i64 %arr.len184, i32 70)
  unreachable

idx.ok187:                                        ; preds = %if.else
  %arr.data188 = getelementptr i8, ptr %tmp182, i64 8
  %arr.elem189 = getelementptr inbounds ptr, ptr %arr.data188, i64 %73
  %data190 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data191 = load ptr, ptr %data190, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j192 = load i32, ptr %j, align 4
  %78 = sext i32 %j192 to i64
  %arr.len193 = load i64, ptr %data191, align 8
  %arr.oob194 = icmp uge i64 %78, %arr.len193
  br i1 %arr.oob194, label %idx.bad195, label %idx.ok196, !prof !8

idx.bad195:                                       ; preds = %idx.ok187
  call void @__polaron_fail(ptr @.fail.835, ptr @.faila.836, i64 %78, ptr @.failb.837, i64 %arr.len193, i32 70)
  unreachable

idx.ok196:                                        ; preds = %idx.ok187
  %arr.data197 = getelementptr i8, ptr %data191, i64 8
  %arr.elem198 = getelementptr inbounds ptr, ptr %arr.data197, i64 %78
  %elem199 = load ptr, ptr %arr.elem198, align 8
  %"Handler$int.copy200" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %79 = call ptr @memcpy(ptr %"Handler$int.copy200", ptr %elem199, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy200", ptr %arr.elem189, align 8
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
  call void @__polaron_fail(ptr @.fail.838, ptr @.faila.839, i64 %83, ptr @.failb.840, i64 %arr.len210, i32 70)
  unreachable

idx.ok213:                                        ; preds = %while.body204
  %arr.data214 = getelementptr i8, ptr %tmp208, i64 8
  %arr.elem215 = getelementptr inbounds ptr, ptr %arr.data214, i64 %83
  %data216 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data217 = load ptr, ptr %data216, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i218 = load i32, ptr %i, align 4
  %84 = sext i32 %i218 to i64
  %arr.len219 = load i64, ptr %data217, align 8
  %arr.oob220 = icmp uge i64 %84, %arr.len219
  br i1 %arr.oob220, label %idx.bad221, label %idx.ok222, !prof !8

idx.bad221:                                       ; preds = %idx.ok213
  call void @__polaron_fail(ptr @.fail.841, ptr @.faila.842, i64 %84, ptr @.failb.843, i64 %arr.len219, i32 70)
  unreachable

idx.ok222:                                        ; preds = %idx.ok213
  %arr.data223 = getelementptr i8, ptr %data217, i64 8
  %arr.elem224 = getelementptr inbounds ptr, ptr %arr.data223, i64 %84
  %elem225 = load ptr, ptr %arr.elem224, align 8
  %"Handler$int.copy226" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %85 = call ptr @memcpy(ptr %"Handler$int.copy226", ptr %elem225, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy226", ptr %arr.elem215, align 8
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
  call void @__polaron_fail(ptr @.fail.844, ptr @.faila.845, i64 %90, ptr @.failb.846, i64 %arr.len236, i32 70)
  unreachable

idx.ok239:                                        ; preds = %while.body230
  %arr.data240 = getelementptr i8, ptr %tmp234, i64 8
  %arr.elem241 = getelementptr inbounds ptr, ptr %arr.data240, i64 %90
  %data242 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data243 = load ptr, ptr %data242, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j244 = load i32, ptr %j, align 4
  %91 = sext i32 %j244 to i64
  %arr.len245 = load i64, ptr %data243, align 8
  %arr.oob246 = icmp uge i64 %91, %arr.len245
  br i1 %arr.oob246, label %idx.bad247, label %idx.ok248, !prof !8

idx.bad247:                                       ; preds = %idx.ok239
  call void @__polaron_fail(ptr @.fail.847, ptr @.faila.848, i64 %91, ptr @.failb.849, i64 %arr.len245, i32 70)
  unreachable

idx.ok248:                                        ; preds = %idx.ok239
  %arr.data249 = getelementptr i8, ptr %data243, i64 8
  %arr.elem250 = getelementptr inbounds ptr, ptr %arr.data249, i64 %91
  %elem251 = load ptr, ptr %arr.elem250, align 8
  %"Handler$int.copy252" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %92 = call ptr @memcpy(ptr %"Handler$int.copy252", ptr %elem251, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy252", ptr %arr.elem241, align 8
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
  %data262 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count282 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count283 = load i32, ptr %count282, align 4, !tbaa !4
  %data284 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data285 = load ptr, ptr %data284, align 8, !tbaa !0
  %len286 = load i64, ptr %data285, align 8
  %99 = trunc i64 %len286 to i32
  %100 = icmp sle i32 %count283, %99
  %101 = zext i1 %100 to i32
  %contract.ok287 = icmp ne i32 %101, 0
  br i1 %contract.ok287, label %contract.cont289, label %contract.fail288

idx.bad267:                                       ; preds = %for.body257
  call void @__polaron_fail(ptr @.fail.850, ptr @.faila.851, i64 %97, ptr @.failb.852, i64 %arr.len265, i32 70)
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
  call void @__polaron_fail(ptr @.fail.853, ptr @.faila.854, i64 %102, ptr @.failb.855, i64 %arr.len273, i32 70)
  unreachable

idx.ok276:                                        ; preds = %idx.ok268
  %arr.data277 = getelementptr i8, ptr %tmp271, i64 8
  %arr.elem278 = getelementptr inbounds ptr, ptr %arr.data277, i64 %102
  %elem279 = load ptr, ptr %arr.elem278, align 8
  %"Handler$int.copy280" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %103 = call ptr @memcpy(ptr %"Handler$int.copy280", ptr %elem279, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy280", ptr %arr.elem270, align 8
  br label %for.update258

contract.fail288:                                 ; preds = %for.end259
  call void @__polaron_fail(ptr @.contract.856, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont289:                                 ; preds = %for.end259
  ret void
}

define internal %__polaron_variant @"ArrayList$Handler$int.find"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.857, ptr @.faila.858, i64 %10, ptr @.failb.859, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %data13 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.860, ptr @.faila.861, i64 %15, ptr @.failb.862, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 %15
  %elem22 = load ptr, ptr %arr.elem21, align 8
  %var.enc.p = ptrtoint ptr %elem22 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val
}

define internal %__polaron_variant @"ArrayList$Handler$int.min"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca ptr, align 8
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.863, ptr @.faila.864, i64 0, ptr @.failb.865, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %9 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %10 = icmp slt i32 %i10, %count12
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %12 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %12, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %13 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %13, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

for.update:                                       ; preds = %if.end26
  %14 = load i32, ptr %i, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best37 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best37 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.866, ptr @.faila.867, i64 %13, ptr @.failb.868, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %13
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %best24 = load ptr, ptr %best, align 8
  %16 = call i32 %code(ptr %env, ptr %elem23, ptr %best24)
  %17 = icmp slt i32 %16, 0
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %19 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %19, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %vcopy.done, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.869, ptr @.faila.870, i64 %19, ptr @.failb.871, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %19
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %20 = load ptr, ptr %best, align 8
  %21 = icmp eq ptr %elem36, %20
  br i1 %21, label %vcopy.done, label %vcopy

vcopy:                                            ; preds = %idx.ok33
  %22 = getelementptr inbounds %"class.Handler$int", ptr %20, i32 0, i32 1
  %23 = call ptr @memcpy(ptr %20, ptr %elem36, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  br label %vcopy.done

vcopy.done:                                       ; preds = %vcopy, %idx.ok33
  br label %if.end26
}

define internal %__polaron_variant @"ArrayList$Handler$int.max"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca ptr, align 8
  %"Handler$int.copy" = alloca %"class.Handler$int", align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.872, ptr @.faila.873, i64 0, ptr @.failb.874, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %9 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %10 = icmp slt i32 %i10, %count12
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %12 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %12, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %13 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %13, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

for.update:                                       ; preds = %if.end26
  %14 = load i32, ptr %i, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best37 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best37 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.875, ptr @.faila.876, i64 %13, ptr @.failb.877, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %13
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %best24 = load ptr, ptr %best, align 8
  %16 = call i32 %code(ptr %env, ptr %elem23, ptr %best24)
  %17 = icmp sgt i32 %16, 0
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %19 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %19, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %vcopy.done, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.878, ptr @.faila.879, i64 %19, ptr @.failb.880, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %19
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %20 = load ptr, ptr %best, align 8
  %21 = icmp eq ptr %elem36, %20
  br i1 %21, label %vcopy.done, label %vcopy

vcopy:                                            ; preds = %idx.ok33
  %22 = getelementptr inbounds %"class.Handler$int", ptr %20, i32 0, i32 1
  %23 = call ptr @memcpy(ptr %20, ptr %elem36, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  br label %vcopy.done

vcopy.done:                                       ; preds = %vcopy, %idx.ok33
  br label %if.end26
}

define internal ptr @"ArrayList$Handler$int.iterator"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayListIterator$Handler$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayListIterator$Handler$int", ptr null, i64 1) to i64))
  call void @"ArrayListIterator$Handler$int.ArrayListIterator$Handler$int"(ptr %"ArrayListIterator$Handler$int.obj", ptr %0)
  ret ptr %"ArrayListIterator$Handler$int.obj"
}

define internal void @"ArrayListIterator$Handler$int.ArrayListIterator$Handler$int"(ptr %0, ptr %1) {
entry:
  %"ArrayList$Handler$int.copy" = alloca %"class.ArrayList$Handler$int", align 8
  %list = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"ArrayList$Handler$int.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Handler$int", ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i = phi i64 [ 0, %entry ], [ %14, %arrdup.cont ]
  %8 = icmp slt i64 %i, %arr.len
  br i1 %8, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %9 = mul i64 %i, 8
  %10 = add i64 8, %9
  %11 = getelementptr i8, ptr %arr.copy, i64 %10
  %elem = load ptr, ptr %11, align 8
  %12 = icmp eq ptr %elem, null
  br i1 %12, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %"Handler$int.copy" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %13 = call ptr @memcpy(ptr %"Handler$int.copy", ptr %elem, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy", ptr %11, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %14 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %15 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %"ArrayList$Handler$int.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %15, align 8, !tbaa !0
  store ptr %"ArrayList$Handler$int.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$Handler$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %list1 = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %list1, align 8, !tbaa !0
  %list2 = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 1
  %list3 = load ptr, ptr %list, align 8
  %"ArrayList$Handler$int.copy4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Handler$int", ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %"ArrayList$Handler$int.copy4", ptr %list3, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Handler$int", ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %list3, i32 0, i32 1
  %18 = load ptr, ptr %17, align 8, !tbaa !0
  %arr.len5 = load i64, ptr %18, align 8
  %19 = mul i64 %arr.len5, 8
  %20 = add i64 8, %19
  %arr.copy6 = call ptr @__polaron_malloc(i64 %20)
  %21 = call ptr @memcpy(ptr %arr.copy6, ptr %18, i64 %20)
  br label %arrdup.head7

arrdup.head7:                                     ; preds = %arrdup.cont10, %arrdup.done
  %i12 = phi i64 [ 0, %arrdup.done ], [ %28, %arrdup.cont10 ]
  %22 = icmp slt i64 %i12, %arr.len5
  br i1 %22, label %arrdup.body8, label %arrdup.done11

arrdup.body8:                                     ; preds = %arrdup.head7
  %23 = mul i64 %i12, 8
  %24 = add i64 8, %23
  %25 = getelementptr i8, ptr %arr.copy6, i64 %24
  %elem13 = load ptr, ptr %25, align 8
  %26 = icmp eq ptr %elem13, null
  br i1 %26, label %arrdup.cont10, label %arrdup.copy9

arrdup.copy9:                                     ; preds = %arrdup.body8
  %"Handler$int.copy14" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %27 = call ptr @memcpy(ptr %"Handler$int.copy14", ptr %elem13, i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  store ptr %"Handler$int.copy14", ptr %25, align 8
  br label %arrdup.cont10

arrdup.cont10:                                    ; preds = %arrdup.copy9, %arrdup.body8
  %28 = add i64 %i12, 1
  br label %arrdup.head7

arrdup.done11:                                    ; preds = %arrdup.head7
  %29 = getelementptr inbounds %"class.ArrayList$Handler$int", ptr %"ArrayList$Handler$int.copy4", i32 0, i32 1
  store ptr %arr.copy6, ptr %29, align 8, !tbaa !0
  store ptr %"ArrayList$Handler$int.copy4", ptr %list2, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @"ArrayListIterator$Handler$int.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %list = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$Handler$int.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @"ArrayListIterator$Handler$int.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca ptr, align 8
  %list = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = call ptr @"ArrayList$Handler$int.get"(ptr %list1, i32 %pos2)
  store ptr %1, ptr %value, align 8
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$Handler$int", ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %2 = add i32 %pos5, 1
  store i32 %2, ptr %pos3, align 4, !tbaa !4
  %value6 = load ptr, ptr %value, align 8
  ret ptr %value6
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1514)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1516)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5516)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5518)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal void @__polaron_lambda_0(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %2 = getelementptr ptr, ptr %0, i32 0
  %bx = load ptr, ptr %2, align 8
  %bx1 = load ptr, ptr %bx, align 8
  %x2 = load i32, ptr %x, align 4
  call void @Box.add(ptr %bx1, i32 %x2)
  ret void
}

define internal void @__polaron_lambda_1(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %2 = call i32 (ptr, ...) @printf(ptr @.str, i32 %x1)
  ret void
}

declare i32 @printf(ptr, ...)

define internal void @"Event$int.subscribe#0=__polaron_lambda_1$fs"(ptr %0, ptr %1) {
entry:
  %h = alloca ptr, align 8
  store ptr %1, ptr %h, align 8
  %handlers = getelementptr inbounds %"class.Event$int", ptr %0, i32 0, i32 1
  %handlers1 = load ptr, ptr %handlers, align 8, !tbaa !0
  %"Handler$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Handler$int", ptr null, i64 1) to i64))
  %h2 = load ptr, ptr %h, align 8
  call void @"Handler$int.Handler$int"(ptr %"Handler$int.obj", ptr %h2)
  call void @"ArrayList$Handler$int.add"(ptr %handlers1, ptr %"Handler$int.obj")
  call void @__polaron_check_live(ptr %"Handler$int.obj")
  %vtbl.addr = getelementptr inbounds %"class.Handler$int", ptr %"Handler$int.obj", i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %2 = icmp ne ptr %dtor.fn, null
  br i1 %2, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %"Handler$int.obj")
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %"Handler$int.obj")
  ret void
}

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare void @__polaron_check_live(ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

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
